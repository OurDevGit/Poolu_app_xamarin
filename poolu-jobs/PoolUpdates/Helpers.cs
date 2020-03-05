﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Data;
using System.IO;
using System.Net;
using System.Net.Mail;
using OfficeOpenXml;
using System.Net.Http;
using System.Net.Http.Headers;
using Microsoft.Extensions.Logging;
using MimeTypes;
using System.Data.SqlClient;

namespace PoolUpdates
{ 
    public class Helpers 
    {
        const string staticFilesFolder = "www";
        static string defaultPage =
            string.IsNullOrEmpty(GetEnvironmentVariable("DEFAULT_PAGE")) ?
            "index.html" : GetEnvironmentVariable("DEFAULT_PAGE");

        public static string GetMimeType(string filePath)
        {
            var fileInfo = new FileInfo(filePath);
            return MimeTypeMap.GetMimeType(fileInfo.Extension);
        }

        public static bool IsInDirectory(string parentPath, string childPath)
        {
            var parent = new DirectoryInfo(parentPath);
            var child = new DirectoryInfo(childPath);

            var dir = child;
            do
            {
                if (dir.FullName == parent.FullName)
                {
                    return true;
                }
                dir = dir.Parent;
            } while (dir != null);

            return false;
        }

        public static string GetFilePath(HttpRequestMessage req, ILogger log)
        {
            var pathValue = req.GetQueryNameValuePairs()
                .FirstOrDefault(q => string.Compare(q.Key, "file", true) == 0)
                .Value;

            var path = pathValue ?? "";

            var staticFilesPath =
                Path.GetFullPath(Path.Combine(GetScriptPath(), staticFilesFolder));
            var fullPath = Path.GetFullPath(Path.Combine(staticFilesPath, path));

            if (!IsInDirectory(staticFilesPath, fullPath))
            {
                throw new ArgumentException("Invalid path");
            }

            var isDirectory = Directory.Exists(fullPath);
            if (isDirectory)
            {
                fullPath = Path.Combine(fullPath, defaultPage);
            }

            return fullPath;
        }

        public static dynamic CreateExcelFile(HttpRequestMessage req, ILogger log)
        {
            var com = new SqlCommand("SELECT * FROM [dbo].[INVOICES] where invoicedate > @startdt and invoicedate < @enddt");

            com.Parameters.AddWithValue("startdt", DateTime.Now.AddMonths(-1));
            com.Parameters.AddWithValue("enddt", DateTime.Now.AddDays(-1));
            var dt = new DataTable();

            using (var con = new SqlConnection("connectionstring goes here"))
            {
                con.Open();
                com.Connection = con;
                var da = new SqlDataAdapter(com);
                da.Fill(dt);

                log.LogInformation($"start: {DateTime.Now.AddMonths(-1)} and end { DateTime.Now.AddDays(-1) } gave {dt.Rows.Count}");
            }

            using (var wb = new ExcelPackage())
            {
                wb.Workbook.Worksheets.Add("Our company");
                var ws = wb.Workbook.Worksheets[0];

                FillData(ws, dt, "Our company B.V.");
                SendMailMessage(new List<string>() { "mymail@companydomain.com" }, "Montly invoices", "the@cloud.com",
                     $"Invoices from {DateTime.Now.AddMonths(-1)} to { DateTime.Now.AddDays(-1) } in the Excel attachment.", "Invoices.xlsx", wb);

                return ws;
            }
        }

        private static void FillData(ExcelWorksheet ws, DataTable dt, string title)
        {
            ws.Cells[1, 1].Value = title;

            ws.Cells[2, 1].Value = "Invoice nr";
            ws.Cells[2, 2].Value = "Invoice date";
            ws.Cells[2, 3].Value = "Amount inc. VAT";
            ws.Cells[2, 4].Value = "VAT";
            ws.Cells[2, 5].Value = "Amount exc. VAT";

            int row = 3;

            foreach (DataRow dr in dt.Rows)
            {
                ws.Cells[row, 1].Value = dr[0].ToString();
                ws.Cells[row, 2].Value = dr[1].ToString();
                ws.Cells[row, 3].Value = dr[2].ToString();
                ws.Cells[row, 4].Value = dr[3].ToString();
                ws.Cells[row++, 5].Value = dr[4].ToString();
            }
        }

        private static void SendMailMessage(List<string> receiver, string subject, string sender, string mailbody, string attachementName, dynamic attachement)
        {
            var msg = new MailMessage();

            foreach (var item in receiver)
            {
                msg.To.Add(item);
            }
            
            msg.Subject = subject;
            msg.From = new MailAddress(sender);
            msg.Body = mailbody;
            var ms = new MemoryStream(attachement.GetAsByteArray());
            ms.Position = 0;

            msg.Attachments.Add(new Attachment(ms, attachementName, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
            var smtp = new SmtpClient
            {
                Host = "smtp.gmail.com",
                Port = 587,
                EnableSsl = true,
                Credentials = new NetworkCredential("my@gmailaccount.com", "incorrectpassword")
            };
            smtp.Send(msg);
        }

        public static string GetScriptPath() => Path.Combine(GetEnvironmentVariable("HOME"), @"site\wwwroot");
        private static string GetEnvironmentVariable(string name) => System.Environment.GetEnvironmentVariable(name, EnvironmentVariableTarget.Process);
    }

}
