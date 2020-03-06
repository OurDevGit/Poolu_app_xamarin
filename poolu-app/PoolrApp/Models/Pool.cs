using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PoolrApp.Models
{
    public enum PoolStatus
    {
        Open = 1,
        Closed = 2,
        OpenAndClosed = 3
    }

    public class Pool
    {
        [Key]
        public int PoolId { get; set; }

        public int PoolTypeId { get; set; }

        public string DisplayDrawDate { get; set; }

        public DateTime DrawDate { get; set; }

        public String WinningNumbers { get; set; }

        [Required]
        public decimal? Jackpot { get; set; }

        public int? AdminId { get; set; }

        public DateTime? UpdateTime { get; set; }

        [NotMapped]
        public string PoolName { get; set; }

        [NotMapped]
        public string PoolNameAndDrawDate { get; set; }

        [NotMapped]
        public string TicketType { get; set; }

        [NotMapped]
        public PoolStatus PoolStatus { get; set; }

        [NotMapped]
        public string UpdatedBy { get; set; }

        [NotMapped]
        public string DisplayUpdateTime { get; set; }
    }
}