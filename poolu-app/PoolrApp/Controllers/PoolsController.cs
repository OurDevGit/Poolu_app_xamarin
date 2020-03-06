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
    public class PoolsController : BaseController
    {
        IPoolsRepository repo;

        public PoolsController(IPoolsRepository repository)
        {
            repo = repository;
            ViewData["PoolStatus"] = GetPoolStatus();
        }

        public ActionResult List() => View(repo.GetLotteryPools(PoolStatus.Open));


        public ActionResult PoolStatusPartial() => 
            PartialView("PoolStatusPartial", ViewData["PoolStatus"]);

        [ValidateInput(false)]
        public ActionResult PoolsGridViewPartial()
        {
            var status = (PoolStatus)int.Parse(Request.Params["PoolStatus"]);
            return PartialView("PoolsGridViewPartial", repo.GetLotteryPools(status));
        }
           
        

        [HttpPost, ValidateInput(false)]
        public ActionResult UpdatePool(Pool pool)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    repo.UpdatePool(pool, AdminId);
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

            return PartialView("PoolsGridViewPartial", repo.GetLotteryPools(pool.PoolStatus));
        }

        private List<PoolStatusViewModel> GetPoolStatus() => new List<PoolStatusViewModel>()
        {
            new PoolStatusViewModel { StatusId = PoolStatus.Open, Status = "Open Pools" },
            new PoolStatusViewModel { StatusId = PoolStatus.Closed, Status = "Closed Pools" }
        };
    }
}