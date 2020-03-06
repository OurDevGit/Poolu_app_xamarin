using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PoolrApp.Models
{
    public class LotteryNumber
    {
        [Key]
        public long LotteryNumberId { get; set; }

        [Required]
        public long TicketId { get; set; }

        [Required]
        public string MatchNumbers { get; set; }

        [Required]
        public string FinalNumbers { get; set; }

        [NotMapped]
        public string FullNumber { get; set; }
    }
}