using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models.ViewModels
{
    public class TicketsViewModel
    {
        public int TicketStatusId { get; set; }

        public IEnumerable<PoolTicket> TicketList { get; set; }

        public bool IsSearch { get; set; }

    }
}