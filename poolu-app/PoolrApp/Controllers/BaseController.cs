using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PoolrApp.Models;

namespace PoolrApp.Controllers
{
    public abstract class BaseController : Controller
    {
        private AppDBContext context = new AppDBContext();

        protected int AdminId => Session["AdminId"] != null ? (int)Session["AdminId"] : 0;

        protected string DuplicateTicketFoundMessage => 
            "Lottery number already exist in the same pool";

        private IQueryable<Pool> Pools => context.Pools;

        protected DateTime EasternStandardTimeNow => 
            TimeZoneInfo.ConvertTimeFromUtc(DateTime.UtcNow, TimeZoneInfo.FindSystemTimeZoneById("Eastern Standard Time"));
        
        //protected List<Pool> GetCurrentPools()
        //{
          
        //    var pools = Pools
        //               .Where(d => d.DrawDate >= EasternTimeNow.Date)
        //               .GroupBy(t => t.PoolTypeId)
        //               .Select(p => p.OrderBy(r => r.PoolId).FirstOrDefault())
        //               .ToList();

        //    var currentPools = (from pool in pools
        //                        join poolType in context.PoolTypes
        //                        on pool.PoolTypeId equals poolType.PoolTypeId
        //                        join ticketType in context.TicketTypes
        //                        on poolType.TicketTypeId equals ticketType.TicketTypeId
        //                        select new Pool
        //                        {
        //                            PoolId = pool.PoolId,
        //                            PoolName = poolType.PoolName,
        //                            PoolNameAndDrawDate = poolType.PoolName + "  " + pool.DisplayDrawDate,
        //                            TicketType = ticketType.TicketTypeName,
        //                            DisplayDrawDate = pool.DisplayDrawDate,
        //                            Jackpot = pool.Jackpot
        //                        }).ToList();

        //    return currentPools;
        //}

        //protected List<Pool> GetPools(PoolStatus poolStatus)
        //{
        //    IEnumerable<Pool> poolList;

        //    if (poolStatus == PoolStatus.Closed)
        //    {
        //        poolList = Pools
        //               .Where(d => d.DrawDate < EasternTimeNow.Date)
        //               .GroupBy(t => t.PoolTypeId)
        //               .SelectMany(p => p.OrderByDescending(r => r.PoolId))
        //               .ToList();
        //    }
        //    else if (poolStatus == PoolStatus.Open)
        //    {
        //        poolList = Pools
        //               .Where(d => d.DrawDate >= EasternTimeNow.Date)
        //               .GroupBy(t => t.PoolTypeId)
        //               .Select(p => p.OrderBy(r => r.PoolId).FirstOrDefault())
        //               .ToList();
        //    }
        //    else
        //    {
        //        poolList = Pools
        //               .Where(d => d.DrawDate <= EasternTimeNow.Date)
        //               .GroupBy(t => t.PoolTypeId)
        //               .SelectMany(p => p.OrderByDescending(r => r.PoolId))
        //               .ToList();
        //    }


        //    return (from pool in poolList
        //            join poolType in context.PoolTypes
        //            on pool.PoolTypeId equals poolType.PoolTypeId
        //            join ticketType in context.TicketTypes
        //            on poolType.TicketTypeId equals ticketType.TicketTypeId
        //            select new Pool
        //            {
        //                PoolId = pool.PoolId,
        //                PoolName = poolType.PoolName,
        //                PoolNameAndDrawDate = poolType.PoolName + "  " + pool.DisplayDrawDate,
        //                TicketType = ticketType.TicketTypeName,
        //                DisplayDrawDate = pool.DisplayDrawDate,
        //                Jackpot = pool.Jackpot
        //            }).ToList();
        //}

        protected string GetModelStateError()
        {
            var errors = new System.Text.StringBuilder();
            foreach (ModelState modelState in ViewData.ModelState.Values)
            {
                foreach (ModelError error in modelState.Errors)
                {
                    errors.Append(error.ErrorMessage);
                }
            }

            return errors.ToString();
        } 
       
    }
}