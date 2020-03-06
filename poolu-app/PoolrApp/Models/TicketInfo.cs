using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public class TicketInfo
    {
        public long TicketId { get; set; }
        public int PoolId { get; set; }
        public string TerminalId { get; set; }
        public TicketStatus Status { get; set; }
        public int AdminId { get; set; }
        public DateTime ApproveTime { get; set; }
        public DateTime UpdateTime { get; set; }
    }
}