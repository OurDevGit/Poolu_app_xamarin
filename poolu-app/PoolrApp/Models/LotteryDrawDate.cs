using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace PoolrApp.Models
{
    public class LotteryDrawDate
    {
        [Key]
        public int Id { get; set; }
        
        [Required]
        public int TicketTypeId { get; set; }

        [Required]
        public string DisplayDrawDate { get; set; }

        [Required]
        public DateTime DrawDate { get; set; }
    }
}