using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace PoolrApp.Models
{
    public class TicketType
    {
        [Key]
        public int TicketTypeId { get; set; }

        [Required]
        public string TicketTypeName { get; set; }
    }
}