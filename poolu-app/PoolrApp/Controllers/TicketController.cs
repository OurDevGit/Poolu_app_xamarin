using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Configuration;
using System.Threading.Tasks;
using System.IO;
using Microsoft.WindowsAzure.Storage;
using Microsoft.WindowsAzure.Storage.Blob;
using SendGrid;
using SendGrid.Helpers.Mail;
using PoolrApp.Models;
using PoolrApp.Models.ViewModels;
using PoolrApp.Filters;
using System.Collections;
using PoolrApp.Infrastructure;

namespace PoolrApp.Controllers
{
    
    [Authorize]
    [SessionExpire]
    public class TicketController : BaseController
    {
        private ITicketsRepository repo;
        private CloudBlobClient blobClient = CloudStorageAccount.Parse(
               ConfigurationManager.ConnectionStrings["PoolrStorageConnString"].ConnectionString).CreateCloudBlobClient();

        private static string connString = ConfigurationManager.ConnectionStrings["PooluDBConnString"].ConnectionString;


        public TicketController(ITicketsRepository repository)
        {
            repo = repository;
        }

        public ActionResult List(int statusId) =>
            (statusId >= 0 && statusId <= 4) ? View(GetTicketList((TicketStatus)statusId)) : View();
        
            
        public ActionResult PendingPartial() =>
            PartialView(GetTicketList(TicketStatus.Pending));

        public ActionResult PrevPendingPartial() =>
            PartialView(GetTicketList(TicketStatus.PrevPending));

        public ActionResult OnHoldPartial() =>
            PartialView(GetTicketList(TicketStatus.Declined));

        public ActionResult ApprovedPartial()
        {
            if (Request.Params["ticketId"] != null)
            {
                var ticketId = Int64.Parse(Request.Params["ticketId"]);
                return PartialView(new TicketsViewModel
                {
                    TicketStatusId = (int)TicketStatus.Approved,
                    TicketList = repo.PoolTickets.Where(t => t.TicketId == ticketId).ToList(),
                    IsSearch = true
                });
            }
            return PartialView(GetTicketList(TicketStatus.Approved));
        }
            
        public ActionResult DetailPartial(TicketDetailViewModel model)
        {
            var stream = ReadTicketPhotoToStream(model.PhotoName);
            var photoData = GetByteArrayFromImage(stream);

            ViewData["TicketId"] = model.TicketId;

            return PartialView(new TicketDetailViewModel
            {
                PhotoData = photoData,
                TicketId = model.TicketId,
                TerminalId = model.TerminalId,
                TicketStatusId = (TicketStatus)model.TicketStatusId,
                PoolId = model.PoolId,
                LotteryNumbers = GetLotteryNumbers(model.TicketId)
            });
        }

        public ActionResult OnHoldLotteryNumberPartial(long ticketId) =>
            PartialView("OnHoldLotteryNumberPartial", GetLotteryNumbers(ticketId));

        [HttpPost, ValidateInput(false)]
        public ActionResult LotteryNumberPartial(long ticketId) =>
            PartialView("LotteryNumberPartial", GetLotteryNumbers(ticketId));
  
        [HttpPost, ValidateInput(false)]
        public ActionResult LotteryNumberAddNew(LotteryNumber lotteryNumber, int ticketId)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var dupNumFound = repo.CheckDuplicateTicket(ticketId, false, lotteryNumber);
                    if (dupNumFound)
                    {
                        ViewData["EditError"] = DuplicateTicketFoundMessage;
                    }
                    else
                    {
                        repo.SaveLotteryNumbers(lotteryNumber);
                    }   
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            else
            {
                ViewData["EditError"] = "Please, correct all errors.";
            }

            return PartialView("LotteryNumberPartial", GetLotteryNumbers(ticketId));
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult LotteryNumberUpdate(LotteryNumber lotteryNumber, int ticketId)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    var dupNumFound = repo.CheckDuplicateTicket(ticketId, false, lotteryNumber);
                    if (dupNumFound)
                    {
                        ViewData["EditError"] = DuplicateTicketFoundMessage;
                    }
                    else
                    {
                        repo.SaveLotteryNumbers(lotteryNumber);
                    }
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            else
            {
                ViewData["EditError"] = "Please, correct all errors.";
            }

            return PartialView("LotteryNumberPartial", GetLotteryNumbers(ticketId));
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult LotteryNumberDelete(int lotteryNumberId, int ticketId)
        {
            if (lotteryNumberId >= 0)
            {
                try
                {
                    repo.DeleteLotteryNumber(lotteryNumberId);
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            return PartialView("LotteryNumberPartial", GetLotteryNumbers(ticketId));
        }

        public JsonResult ValidateLotteryNumber(int ticketId)
        {
            try
            {
                var lotteryNumber = repo.LotteryNumbers.Where(t => t.TicketId == ticketId).FirstOrDefault();

                if (lotteryNumber == null)
                {
                    return Json(new { success = false, message = "Please enter and save lottery number first." }, JsonRequestBehavior.AllowGet);
                }

                var dupNumFound = repo.CheckDuplicateTicket(ticketId, true);
                if (dupNumFound)
                {
                    return Json(new { success = false, message = DuplicateTicketFoundMessage }, JsonRequestBehavior.AllowGet);
                }

                return Json(new { success = true }, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                return Json(new { success = false, message = "Error occured when validate lottery number." }, JsonRequestBehavior.AllowGet);
            }

        }

        public async Task<ActionResult> ApproveTicket(long ticketId, int poolId, string termId)
        {
            try
            {
                repo.ApproveTicket(new TicketInfo
                {
                    TicketId = ticketId,
                    PoolId = poolId,
                    TerminalId = termId,
                    Status = TicketStatus.Approved,
                    AdminId = AdminId,
                    ApproveTime = EasternStandardTimeNow
                });
                
                await SendApproveConfirmEmailAsync(ticketId);
                
                return Json(new { success = true, message = "Ticket approved successfully and confirmation email send." }, JsonRequestBehavior.AllowGet);      
            }
            catch(Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }
            
        }

        public ActionResult UpdateTicket(long ticketId, int poolId, string termId)
        {
            try
            {
                repo.UpdateTicket(new TicketInfo
                {
                    TicketId = ticketId,
                    PoolId = poolId,
                    TerminalId = termId,
                    Status = TicketStatus.Approved,
                    AdminId = AdminId,
                    UpdateTime = EasternStandardTimeNow
                });
              
                return Json(new { success = true, message = "Ticket update successfully." }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }

        }

        public async Task<ActionResult> DeclinePendingTicket(long ticketId)
        {
            try
            {
                repo.DeclinePendingTicket(ticketId, AdminId, EasternStandardTimeNow);

                await SendDeclineConfirmEmailAsync(ticketId);

                return Json(new { success = true, message = "Ticket declined successfully and confirmation email send." }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        public async Task<ActionResult> DeclineApprovedTicket(long ticketId, int poolId)
        {
            try
            {
                repo.DeclineApprovedTicket(ticketId, poolId, TicketStatus.Declined, AdminId, EasternStandardTimeNow);

                await SendDeclineConfirmEmailAsync(ticketId);

                return Json(new { success = true, message = "Ticket declined successfully and confirmation email send." }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }
        }

        public async Task<ActionResult> DeleteDeclinedTicket(long ticketId)
        {
            try
            {
                var photoName = DataAccess.DeletDeclinedTicket(ticketId);

                if (!string.IsNullOrEmpty(photoName.Trim()))
                {
                    var blobContainer = blobClient.GetContainerReference(ConfigurationManager.AppSettings["TicketPhotoContainer"]);
                    var blockBlob = blobContainer.GetBlockBlobReference(photoName);
                    if (blockBlob != null) await blockBlob.DeleteIfExistsAsync();
                }

                return Json(new { success = true, message = "Ticket delete successfully." }, JsonRequestBehavior.AllowGet);
            }
            catch (Exception ex)
            {
                return Json(new { success = false, message = ex.Message }, JsonRequestBehavior.AllowGet);
            }

        }

        [HttpPost]
        public ActionResult SearchTicket(long cboLottNumWithTicketId) => PartialView("ApprovedPartial", new TicketsViewModel
        {
            TicketStatusId = (int)TicketStatus.Approved,
            TicketList = repo.PoolTickets.Where(t => t.TicketId == cboLottNumWithTicketId).ToList()
        });
     

        private TicketsViewModel GetTicketList(TicketStatus statusId) => new TicketsViewModel
        {
            TicketStatusId = (int)statusId,
            TicketList = repo.PoolTickets.Where(t => t.TicketStatusId == (int)statusId).ToList(),
            IsSearch = false
        };


        private List<LotteryNumber> GetLotteryNumbers(long ticketId) => 
            repo.LotteryNumbers.Where(t => t.TicketId == ticketId).ToList();
        
        private Stream ReadTicketPhotoToStream(string photoName)
        {
            var blobContainer = blobClient.GetContainerReference(ConfigurationManager.AppSettings["TicketPhotoContainer"]);
            var blockBlob = blobContainer.GetBlockBlobReference(photoName);

            if (blockBlob == null)
            {
                return null;
            }

            return blockBlob.OpenRead();
        }

        private byte[] GetByteArrayFromImage(Stream stream)
        {
            byte[] imageInByteArray = new byte[stream.Length];
            stream.Read(imageInByteArray, 0, (int)stream.Length);

            return imageInByteArray;
        }

        private async Task SendApproveConfirmEmailAsync(long ticketId)
        {
            var confirmInfo = DataAccess.GetApproveConfirmInfo(ticketId);

            var client = new SendGridClient(ConfigurationManager.AppSettings["SendGridApiKey"]);
            var from = new EmailAddress("do-not-reply@pooluapp.com", "Poolu");
            var to = new EmailAddress(confirmInfo.UserEmail);
            var title = confirmInfo.PoolName + " ticket approved";

            var message = new System.Text.StringBuilder();

            message.Append("<html><body>");
         
            message.Append("Congratulations " + confirmInfo.UserName + ",");
            message.Append("<br></br>");

            message.Append("<br>");
            message.Append("Your ticket has been approved for the ");
            message.Append(confirmInfo.PoolName);
            message.Append(" lottery pool drawing on ");
            message.Append(confirmInfo.DrawDate);
            message.Append(" at 11pm EST.");
            message.Append("</br><br></br>");

            message.Append("<br>");
            message.Append("Lottery Number:&nbsp;&nbsp;");

            if (confirmInfo.LotteryNumbers.Count > 1)
            {
                foreach (var num in confirmInfo.LotteryNumbers)
                {
                    message.Append("<br>");
                    message.Append("&nbsp;&nbsp;&nbsp;&nbsp;");
                    message.Append(AddSpaceToLotteryNumbers(num));
                    message.Append("</br>");
                }
                message.Append("</br><br></br>");
            }
            else
            {
                message.Append(AddSpaceToLotteryNumbers(confirmInfo.LotteryNumbers[0]));
                message.Append("</br>");
            }

            message.Append("<br>");
            message.Append("Lottery Game:&nbsp;&nbsp;");
            message.Append(confirmInfo.PoolName);
            message.Append("</br>");

            message.Append("<br>");
            message.Append("Draw Date:&nbsp;&nbsp;");
            message.Append(confirmInfo.DrawDate);
            message.Append("</br><br></br>");

            message.Append("<br>Thanks,</br>");
            message.Append("<br></br>");

            message.Append("<br>");
            message.Append("The Poolu Team");
            message.Append("</br><br></br>");
   
            message.Append("</body></html>");

            var msg = MailHelper.CreateSingleEmail(from, to, title, "", message.ToString());

            var response = await client.SendEmailAsync(msg);
        }

        private string AddSpaceToLotteryNumbers(string numbers)
        {
            var whiteBalls = numbers.Substring(0, numbers.Length - 2);
            var colorBall = numbers.Substring(numbers.Length - 2, 2);

            for (int i = 2; i <= whiteBalls.Length; i += 2)
            {
                whiteBalls = whiteBalls.Insert(i, "&nbsp;");
                i += 6;
            }

            return "<strong>" + whiteBalls + "&nbsp;&nbsp;" + colorBall + "</strong>";
        }

        private async Task SendDeclineConfirmEmailAsync(long ticketId)
        {
            var confirmInfo = DataAccess.GetDeclinedConfirmInfo(ticketId);

            var client = new SendGridClient(ConfigurationManager.AppSettings["SendGridApiKey"]);
            var from = new EmailAddress("do-not-reply@pooluapp.com", "Poolu");
            var to = new EmailAddress(confirmInfo.UserEmail);
            var title = confirmInfo.PoolName + " ticket declined";

            var message = new System.Text.StringBuilder();

            message.Append("<html><body>");

            message.Append("Dear " + confirmInfo.UserName + ",");
            message.Append("<br></br>");

            message.Append("<br>");
            message.Append("Unfortunately your ticket submitted on ");
            message.Append(confirmInfo.UploadDate);
            message.Append(" at ");
            message.Append(confirmInfo.UploadTime);
            message.Append(" for the ");
            message.Append(confirmInfo.DrawDate);
            message.Append(" ");
            message.Append(confirmInfo.PoolName);
            message.Append(" drawing has been declined.");
            message.Append("</br><br></br>");

            message.Append("<br>");
            message.Append("If you think this is in error please resubmit the ticket.");
            message.Append("</br><br></br>");

            message.Append("<br>Thanks,</br>");
            message.Append("<br></br>");

            message.Append("<br>");
            message.Append("The Poolu Team");
            message.Append("</br><br></br>");

            message.Append("</body></html>");

            var msg = MailHelper.CreateSingleEmail(from, to, title, "", message.ToString());

            var response = await client.SendEmailAsync(msg);
        }


    }
}