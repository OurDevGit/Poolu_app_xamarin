using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace PoolrApp.Models
{
    public class PoolType
    {
        [Key]
        public int PoolTypeId { get; set; }

        [Required]
        public string PoolName { get; set; }

        [Required]
        public int TicketTypeId { get; set; }

        [Required]
        public int ScreenPosition { get; set; }

        [Required]
        public bool IsActive { get; set; }

        [Required]
        public int? GroupSize { get; set; }
    }
}