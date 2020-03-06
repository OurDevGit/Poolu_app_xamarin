using DevExpress.Web.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PoolrApp.Models;
using PoolrApp.Models.ViewModels;
using PoolrApp.Filters;

namespace PoolrApp.Controllers
{
    [Authorize]
    [SessionExpire]
    public class PoolTypesController : Controller
    {
        private IPoolTypesRepository repo;

        public PoolTypesController(IPoolTypesRepository repository)
        {
            repo = repository;
            ViewData["TicketTypes"] = repo.TicketTypes.ToList();
        }

        public ActionResult List()
        {
            return View(repo.PoolTypes.ToList());
        }

        [ValidateInput(false)]
        public ActionResult PoolTypesGridViewPartial()
        {
            return PartialView("PoolTypesGridViewPartial", repo.PoolTypes.ToList());
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PoolTypesAddNew(PoolType pool)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    repo.SavePoolType(pool);
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

            return PartialView("PoolTypesGridViewPartial", repo.PoolTypes.ToList());
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PoolTypesUpdate(PoolType pool)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    repo.SavePoolType(pool);
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

            return PartialView("PoolTypesGridViewPartial", repo.PoolTypes.ToList());
        }

        [HttpPost, ValidateInput(false)]
        public ActionResult PoolTypesDelete(int poolTypeId)
        {
            if (poolTypeId >= 0)
            {
                try
                {
                    repo.DeletePoolType(poolTypeId);
                }
                catch (Exception e)
                {
                    ViewData["EditError"] = e.Message;
                }
            }
            return PartialView("PoolTypesGridViewPartial", repo.PoolTypes.ToList());
        }


    }
}