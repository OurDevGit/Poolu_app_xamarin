using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;

namespace PoolrApp.Models
{
    public class PoolGroup
    {
        [Key]
        public int PoolGroupId { get; set; }

        [Required]
        public int PooId { get; set; }

        [Required]
        public int PoolerCount { get; set; }

        [Required]
        public decimal WinnerShare { get; set; }

        [Required]
        public decimal PoolerShare { get; set; }
    }
}