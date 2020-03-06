using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public interface IDrawDatesRepository
    {
        IEnumerable<TicketType> TicketTypes { get; }

        IEnumerable<LotteryDrawDate> LotteryDrawDates { get; }

        void SaveDrawDate(LotteryDrawDate drawDate);
    }
}