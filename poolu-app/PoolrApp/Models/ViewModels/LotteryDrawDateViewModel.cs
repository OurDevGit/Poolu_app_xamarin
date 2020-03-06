using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models.ViewModels
{
    public class LotteryDrawDateViewModel
    {
        public IEnumerable<TicketType> TiketTypes { get; set; }

        public IEnumerable<LotteryDrawDate> LotteryDrawDates { get; set; }
    }
}