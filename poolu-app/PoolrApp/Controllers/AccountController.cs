using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;
using System.Web.UI;
using PoolrApp.Models;
using PoolrApp.Models.ViewModels;

namespace PoolrApp.Controllers
{
    [OutputCache(Location = OutputCacheLocation.None, NoStore = true)]
    [Authorize]
    public class AccountController : BaseController
    {
        private IAccountRepository repo;

        public AccountController(IAccountRepository repository)
        {
            repo = repository;
        }

       [AllowAnonymous]
        public ActionResult Login(string returnUrl)
        {
            ViewBag.ReturnUrl = returnUrl;
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public ActionResult Login(LoginViewModel model, string returnUrl)
        {
            
            if (ModelState.IsValid)
            {
                var admin = repo.AdminUsers.Where(a => a.Email.Equals(model.Email) && 
                                                     a.Password.Equals(model.Password)).FirstOrDefault();

                if (admin != null)
                {
                    FormsAuthentication.SetAuthCookie(model.Email, false);
                    Session["AdminName"] = admin.FirstName;
                    Session["AdminId"] = admin.AdminId;

                    return Redirect(returnUrl ?? Url.Action("List", "Ticket"));
                }
                else
                {
                    ModelState.AddModelError("", "Invalid login attempt.");
                    return View(model);
                }
                
            }
            return View();
        }

        [Authorize]
        public ActionResult Logout()
        {
            Session["AdminName"] = null;
            Session["AdminId"] = null;

            FormsAuthentication.SignOut();

            return RedirectToAction("Login", "Account");
        }

        public ActionResult Admins() => View(repo.AdminUsers.ToList());
        
        public ActionResult Users() => View(repo.GetUsers());

        public ActionResult UserTicketsPartial(Guid userId)
        {
            ViewData["UserId"] = userId;

            var model = (from ticket in repo.PoolTickets.ToList()
                         where ticket.UserId == userId
                         select new PoolTicket
                         {
                             TicketId = ticket.TicketId,
                             PoolName = ticket.PoolName,
                             DrawDate = ticket.DrawDate,
                             UploadTime = ticket.UploadTime,
                             TicketStatus = ticket.TicketStatus,
                             ProcessedTime = ticket.ProcessedTime,
                             ProcessedBy = ticket.ProcessedBy
                         }).ToList();
           
            return PartialView(model);
        }
            

        [ValidateInput(false)]
        public ActionResult UserGridViewPartial() =>
            PartialView("UserGridViewPartial", repo.GetUsers());

        [HttpPost, ValidateInput(false)]
        public ActionResult UserUpdate(PoolrUser user)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    repo.SavePoolrUser(user, AdminId);
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            else
            {
                ViewData["EditError"] = GetModelStateError(); 
            }

            return PartialView("UserGridViewPartial", repo.GetUsers());
        }

        [ValidateInput(false)]
        public ActionResult AdminGridViewPartial() =>
            PartialView("AdminGridViewPartial", repo.AdminUsers.ToList());

        [HttpPost, ValidateInput(false)]
        public ActionResult AdminAddNew(AdminUser admin)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    repo.SaveAdminUser(admin);
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

            return PartialView("AdminGridViewPartial", repo.AdminUsers.ToList());
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult AdminUpdate(AdminUser admin)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    repo.SaveAdminUser(admin);
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

            return PartialView("AdminGridViewPartial", repo.AdminUsers.ToList());
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult AdminDelete(int adminId)
        {
            if (adminId >= 0)
            {
                try
                {
                    repo.DeleteAdminUser(adminId);
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            return PartialView("AdminGridViewPartial", repo.AdminUsers.ToList());
        }


    }
}