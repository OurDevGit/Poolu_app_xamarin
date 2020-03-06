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


namespace PoolrOCR
{
    class TicketProcessorTest
    {
        private CloudBlobClient blobClient;
        private CloudBlobContainer blobContainer;

        private Tesseract OCR;

        private string TempFileFolderPath
        {
            get
            {
                string folderName = @"\TempFile";
                if (Environment.GetEnvironmentVariable("HOME") != null)
                {
                    return Environment.GetEnvironmentVariable("HOME") + @"\site\wwwroot" + folderName;
                }
                else
                {
                    return Path.GetDirectoryName(Path.GetDirectoryName(Directory.GetCurrentDirectory())) + folderName;
                }

            }
        }

        private string TesseractDataPath
        {
            get
            {
                return Path.GetDirectoryName(Path.GetDirectoryName(Directory.GetCurrentDirectory())) + @"\tessdata";
            }
        }

        public TicketProcessorTest()
        {
            blobClient = CloudStorageAccount.Parse(
               ConfigurationManager.ConnectionStrings["PoolrStorageConnString"].ConnectionString).CreateCloudBlobClient();

            blobContainer = blobClient.GetContainerReference(ConfigurationManager.AppSettings["TicketPhotoContainer"]);

            InitOCR(TesseractDataPath, "eng", OcrEngineMode.TesseractOnly);
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
            catch (Exception e)
            {
                OCR = null;
                Console.WriteLine("Failed to initialize tesseract OCR engine, error: " + e.Message);
            }
        }

        private string ExtractTextFromPhoto(string filePath)
        {
            //var source = new Mat(filePath);

            //OCR.SetImage(source);

            //if (OCR.Recognize() != 0)
            //{
            //    Console.WriteLine("Tesseract failed to recognize image");
            //    return null;
            //}

            //Tesseract.Character[] chars = OCR.GetCharacters();

            //return OCR.GetUTF8Text();
            return "";
        }

        public void RunTest()
        {
            foreach (IListBlobItem photo in blobContainer.ListBlobs(null, false))
            {

                var blob = (CloudBlockBlob)photo;
                var fileName = blob.Name;
                var filePath = TempFileFolderPath + @"\" + fileName;

                //if (fileName == @"1858753f-a5bd-e711-80c2-00155d2c5c2b+D41067AD-D476-4060-8BBB-B87A2DC2487A.png")
                //{
                //    ConvertPhotoToBlackWhite(fileName, filePath);

                //    string text = ExtractTextFromPhoto(filePath);
                //    var lines = text.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);

                //    WriteToTextFile(fileName, lines);
                //}

                ConvertPhotoToBlackWhiteTest(fileName, filePath);

                Console.WriteLine(fileName);

                string text = ExtractTextFromPhoto(filePath);
                var lines = text.Split(new string[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);

                WriteToTextFileTest(fileName, lines);

            }

        }

        private void ConvertPhotoToBlackWhiteTest(string fileName, string filePath)
        {
            var blockBlob = blobContainer.GetBlockBlobReference(fileName);

            if (blockBlob == null)
            {
                Console.WriteLine("Photo does not exist in Azure Storage");
                return;
            }

            using (var fileStream = System.IO.File.OpenWrite(filePath))
            {
                blockBlob.DownloadToStream(fileStream);
            }

            var imgInput = new Image<Bgr, byte>(filePath);
            var imgGray = imgInput.Convert<Gray, byte>();
            var imgBinary = new Image<Gray, byte>(imgGray.Width, imgGray.Height, new Gray(0));

            CvInvoke.Threshold(imgGray, imgBinary, 0, 255, Emgu.CV.CvEnum.ThresholdType.Otsu);
            CvInvoke.Threshold(imgGray, imgBinary, 160, 255, Emgu.CV.CvEnum.ThresholdType.Binary);

            imgBinary.Bitmap.Save(filePath, ImageFormat.Png);
        }

        private void WriteToTextFileTest(string fileName, string[] lines)
        {
            Console.WriteLine("Writing " + fileName + " to text file....");
            using (System.IO.StreamWriter file = new System.IO.StreamWriter(TempFileFolderPath + @"\test.txt", true))
            {
                file.WriteLine(fileName + ":");
                foreach (string line in lines)
                {
                    //file.WriteLine(line);


                    if (line.Count(Char.IsWhiteSpace) < 3)
                    {
                        continue;
                    }

                    var newline = line.Substring(1);
                    newline = System.Text.RegularExpressions.Regex.Replace(newline, @"[^0-9.]", string.Empty);

                    if (newline.Contains('.'))
                    {
                        newline = newline.Substring(newline.IndexOf('.') + 1);
                    }

                    if (newline.Contains('.'))
                    {
                        continue;
                    }

                    if (newline.Count() == 12)
                    {

                        file.WriteLine(newline);

                    }
                }

                file.WriteLine();
                file.WriteLine();
            }
            Console.WriteLine("Finish writing " + fileName + " to text file.");
            Console.WriteLine();
        }

        public string ParseLineTest()
        {
            var lines = new string[]
            {
                "5 1314 36 38 42m» 11m,",
            };

            foreach (var line in lines)
            {
                Console.WriteLine(line);

                if (line.Count(Char.IsWhiteSpace) < 3)
                {
                    continue;
                }

                //var newline = line.Substring(1);
                //Console.WriteLine(newline);
                var newline = System.Text.RegularExpressions.Regex.Replace(line, @"[^0-9.]", string.Empty);

                if (newline.Contains('.'))
                {
                    newline = newline.Substring(newline.IndexOf('.') + 1);
                }

                if (newline.Contains('.'))
                {
                    continue;
                }


                if (newline.Count() == 12)
                {

                    Console.WriteLine(newline);

                    Console.WriteLine();
                }


            }

            return null;
        }

    }
}
