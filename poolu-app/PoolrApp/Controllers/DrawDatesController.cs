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
    public class DrawDatesController : Controller
    {
        private IDrawDatesRepository repo;

        public DrawDatesController(IDrawDatesRepository repository)
        {
            repo = repository;
        }

        public ActionResult List()
        {
            var model = new LotteryDrawDateViewModel
            {
                TiketTypes = repo.TicketTypes.ToList(),
                LotteryDrawDates = repo.LotteryDrawDates.Where(t => t.TicketTypeId == 1).ToList()
            };

            return View(model);
        }

        public ActionResult LotteryTypesPartial()
        {
            var model = repo.LotteryDrawDates.Where(t => t.TicketTypeId == 1).ToList();

            return PartialView("LotteryDrawDatePartial", model);
        }

        public ActionResult LotteryDrawDatePartial()
        {
            var ticketTypeId = int.Parse(Request.Params["ticketTypeId"]);
            var model = repo.LotteryDrawDates.Where(t => t.TicketTypeId == ticketTypeId).ToList();

            return PartialView("LotteryDrawDatePartial", model);
        }

        public JsonResult SaveDrawDates(int ticketTypeId)
        {
            var typeId = (TicketTypes)ticketTypeId;

            try
            {
                SaveDrawDates(2019, typeId);

                var model = repo.LotteryDrawDates.Where(t => t.TicketTypeId == ticketTypeId).ToList();

                return Json(new { success = true, message = "Draw dates generated successfully" }, JsonRequestBehavior.AllowGet);
            }
            catch
            {
                return Json(new { success = false, message = "Error occured when generate draw dates" }, JsonRequestBehavior.AllowGet);
            }

        }


        private void SaveDrawDates(int year, TicketTypes ticketTypeId)
        {
            var lotteryDrawDates = new List<DayOfWeek>();

            switch (ticketTypeId)
            {
                case TicketTypes.Powerball:
                    lotteryDrawDates.Add(DayOfWeek.Wednesday);
                    lotteryDrawDates.Add(DayOfWeek.Saturday);
                    break;
                case TicketTypes.MegaMillions:
                    lotteryDrawDates.Add(DayOfWeek.Tuesday);
                    lotteryDrawDates.Add(DayOfWeek.Friday);
                    break;
                default:
                    break;
            };

            var drawDates = GetDrawDates(year, lotteryDrawDates);
            foreach (var d in drawDates)
            {
                repo.SaveDrawDate(new LotteryDrawDate
                {
                    TicketTypeId = (int)ticketTypeId,
                    DrawDate = Convert.ToDateTime(d.Key),
                    DisplayDrawDate = d.Value,

                });
            }
        }

        private Dictionary<string, string> GetDrawDates(int year, List<DayOfWeek> drawDays)
        {
            var drawDatesByYear = new Dictionary<string, string>();
            var date = new DateTime(year, 1, 1);


            while (date.Year == year)
            {
                foreach (var d in drawDays)
                {
                    if ((date.DayOfWeek == d))
                    {
                        var longDateStr = date.ToLongDateString().Split(',');

                        var weekDateStr = longDateStr[0].Trim().Substring(0, 3);

                        var monthDateStr = longDateStr[1].Trim().Split();
                        var monthStr = monthDateStr[0].Substring(0, 3);
                        var dateOfMonthStr = monthDateStr[1];

                        var yearStr = longDateStr[2].Trim().Substring(2, 2);

                        var drawDateStr = weekDateStr + " " + monthStr + dateOfMonthStr + " " + yearStr;

                        drawDatesByYear.Add(date.ToShortDateString(), drawDateStr);
                    }
                }

                date = date.AddDays(1);
            }

            return drawDatesByYear;
        }


    }
}
