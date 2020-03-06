using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public class DrawDatesRepository : IDrawDatesRepository
    {
        private AppDBContext context = new AppDBContext();

        public IEnumerable<TicketType> TicketTypes
        {
            get { return context.TicketTypes; }
        }

        public IEnumerable<LotteryDrawDate> LotteryDrawDates
        {
            get { return context.LotteryDrawDates; }
        }

        public void SaveDrawDate(LotteryDrawDate drawDate)
        {
            context.LotteryDrawDates.Add(drawDate);
            context.SaveChanges();
        }
    }
}