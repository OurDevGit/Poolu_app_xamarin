using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models.ViewModels
{
    public class TicketDetailViewModel
    {
        public byte[] PhotoData { get; set; }

        public string PhotoName { get; set; }

        public long TicketId { get; set; }
        
        public TicketStatus TicketStatusId { get; set; }

        public int PoolId { get; set; }

        public string TerminalId { get; set; }

        public IEnumerable<TicketType> TiketTypes { get; set; }

        //public IEnumerable<Pool> Pools { get; set; }

        public IEnumerable<LotteryNumber> LotteryNumbers { get; set; }
    }
}