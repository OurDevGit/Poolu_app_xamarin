using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Timers;
using System.Data;
using System.Data.SqlClient;
using System.Net;
using System.Net.Mail;
using Microsoft.Azure.WebJobs.Host;
using OfficeOpenXml;
using System.Configuration;
using System.Net.Http.Headers;
using System.Net.Http;
using Microsoft.AspNetCore.Routing;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http;

namespace PoolUpdates
{
    public class Functions
    {
        public static async Task UpdatePowerballJackpotsAsync([TimerTrigger(typeof(PowerballJackpotSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdatePowerballJackpot();
        }

        public static async Task UpdateMegaMillionsJackpotsAsync([TimerTrigger(typeof(MegaMillionsJackpotSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdateMegaMillionJackpot();
        }

        public static async Task UpdatePowerballResultsAsync([TimerTrigger(typeof(PowerballResultsSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdatePowerballResults();
        }

        public static async Task UpdateMegaMillionsResultsAsync([TimerTrigger(typeof(MegaMillionsResultsSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdateMegaMillionResults();
        }

        public static async Task SendLotteryNotificationToAllUsers([TimerTrigger(typeof(LotteryReminderSchedule))] TimerInfo timerInfo)
        {
            await Updates.SendLotteryNotification();
        }

        public static async Task SendDrawingWinnersReport([TimerTrigger(typeof(DrawingResultsUpdateSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdateWinnersPerDrawing();
        }

        [FunctionName("ExportAllDataAsSheetAsync")]
        public static async Task<IActionResult> ExportAllDataAsSheetAsync(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)]HttpRequest req, string tablename, TraceWriter log, ExecutionContext context)
        {
            try
            {
                log.Info("Generating files a request.");

                if (string.IsNullOrEmpty(tablename))
                {
                    tablename = "AllTables";
                }

                

                byte[] filebytes = Encoding.UTF8.GetBytes(Helpers.CreateExcelFile(tablename));

                return new FileContentResult(filebytes, "application/octet-stream")
                {
                    FileDownloadName = "ExportData.xls"
                };
            }
            catch (Exception ex)
            {
                return new NotFoundResult();
            }
        }

        

        //[FunctionName("ExportAllDataAsSheetAsync")]
        //public static async Task<HttpResponseMessage> ExportAllDataAsSheetAsync(
        //[HttpTrigger(AuthorizationLevel.Function, "get", "post", Route = null)]HttpRequestMessage req)
        //{

            

        //    try
        //    {
        //        var filePath = Helpers.GetFilePath(req);

        //        var response = new HttpResponseMessage(HttpStatusCode.OK);
        //        var stream = new FileStream(filePath, FileMode.Open);
        //        response.Content = new StreamContent(stream);
        //        response.Content.Headers.ContentType = new MediaTypeHeaderValue(Helpers.GetMimeType(filePath));
        //        return response;
        //    }
        //    catch
        //    {
        //        return new HttpResponseMessage(HttpStatusCode.NotFound);
        //    }


        //}

        
    }
}

