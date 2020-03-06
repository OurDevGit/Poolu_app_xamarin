using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models.ViewModels
{
    public class PoolsTypesViewModel
    {
        public IEnumerable<TicketType> TicketTypes { get; set; }

        public IEnumerable<PoolType> PoolTypes { get; set; }
    }
}