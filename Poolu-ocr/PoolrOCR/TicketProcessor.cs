using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Drawing;
using System.Configuration;
using System.Data;
using System.Drawing.Imaging;
using System.IO;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using Emgu.CV;
using Emgu.CV.OCR;
using Emgu.CV.Structure;
using Microsoft.Azure.WebJobs;

namespace PoolrOCR
{
    class TicketProcessor
    {
        private CloudBlobClient blobClient;
        private CloudBlobContainer blobContainer;
        private Ticket ticket;
        private Tesseract OCR;

        private string TesseractDataPath
        {
            get
            {
                return @".\tessdata";
            }
        }

        public TicketProcessor(string ticketInfo)
        {
            this.ticket = GetTicket(ticketInfo);

            blobClient = CloudStorageAccount.Parse(
               ConfigurationManager.ConnectionStrings["PoolrStorageConnString"].ConnectionString).CreateCloudBlobClient();

            blobContainer = blobClient.GetContainerReference(ConfigurationManager.AppSettings["TicketPhotoContainer"]);

            InitOCR(TesseractDataPath, "eng", OcrEngineMode.TesseractOnly);

        }

        private Ticket GetTicket(string ticketInfo)
        {
            var info = ticketInfo.Split('|');

            return new Ticket
            {
                UserId = Guid.Parse(info[0]),
                PhotoName = info[1],
                PhotoSize = int.Parse(info[2]),
                UploadTime = DateTime.Parse(info[3]),
                PoolId = int.Parse(info[4])
            };
        }
        

        public void SaveTicket()
        {
            try
            {
                var blockBlob = blobContainer.GetBlockBlobReference(ticket.PhotoName);

                var photo = ConvertPhotoToBlackWhite(blockBlob);
                if (photo == null) return;

                var text = ExtractTextFromPhoto(photo);
                if (text == null) return;

                var lines = text.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
                var lotteryNumberTable = CreateLotteryNumberTable();

                foreach (string line in lines)
                {
                    var lotteryNumber = ParseLotteryNumber(line);

                    if (!string.IsNullOrEmpty(lotteryNumber))
                    {
                        DataRow row = lotteryNumberTable.NewRow();
                        row["MatchNumbers"] = lotteryNumber.Substring(0, 10);
                        row["FinalNumbers"] = lotteryNumber.Substring(10, 2);
                        lotteryNumberTable.Rows.Add(row);
                    }

                }

                DataAccess.SaveTicket(ticket, lotteryNumberTable);

            }
            finally
            {
                if (OCR != null)
                {
                    OCR.Dispose();
                    OCR = null;
                }
            }

        }

        private Mat ConvertPhotoToBlackWhite(CloudBlockBlob blob)
        {
            var photo = new Bitmap(blob.OpenRead());
            var imgInput = new Image<Bgr, byte>(photo);
            var imgGray = imgInput.Convert<Gray, byte>();
            var imgBinary = new Image<Gray, byte>(imgGray.Width, imgGray.Height, new Gray(0));

            CvInvoke.Threshold(imgGray, imgBinary, 0, 255, Emgu.CV.CvEnum.ThresholdType.Otsu);
            CvInvoke.Threshold(imgGray, imgBinary, 160, 255, Emgu.CV.CvEnum.ThresholdType.Binary);

            return imgBinary.Mat;
        }

        private void InitOCR(string dataPath, string lang, OcrEngineMode mode)
        {
            try
            {
                if (OCR != null)
                {
                    OCR.Dispose();
                    OCR = null;
                }

                OCR = new Tesseract(dataPath, lang, mode);
            }
            catch(Exception e)
            {
                OCR = null;
                Console.WriteLine("Failed to initialize tesseract OCR engine, error: " + e.Message);
            }
        }

        private string ExtractTextFromPhoto(Mat photo)
        {
            OCR.SetImage(photo);

            if (OCR.Recognize() != 0)
            {
                Console.WriteLine("Tesseract failed to recognize image");
                return null;
            }

            Tesseract.Character[] chars = OCR.GetCharacters();

            return OCR.GetUTF8Text();

        }

        private DataTable CreateLotteryNumberTable()
        {
            var lotteryNumbers = new DataTable("LotteryNumbers");

            //DataColumn colId = new DataColumn("TicketId", typeof(long));
            //lotteryNumbers.Columns.Add(colId);

            var colMatchNumber = new DataColumn("MatchNumbers", typeof(string));
            lotteryNumbers.Columns.Add(colMatchNumber);

            var colFinalNumber = new DataColumn("FinalNumbers", typeof(string));
            lotteryNumbers.Columns.Add(colFinalNumber);

            return lotteryNumbers;
        }

        private string ParseLotteryNumber(string line)
        {

            if (line.Count(Char.IsWhiteSpace) < 3)
            {
                return string.Empty;
            }

            var newline = line.Substring(1);
            newline = System.Text.RegularExpressions.Regex.Replace(newline, @"[^0-9.]", string.Empty);

            if (newline.Contains('.'))
            {
                newline = newline.Substring(newline.IndexOf('.') + 1);
            }

            if (newline.Contains('.'))
            {
                return string.Empty;
            }

            if (newline.Count() == 12)
            {

                return newline;

            }

            return string.Empty;

        }


    }
}
