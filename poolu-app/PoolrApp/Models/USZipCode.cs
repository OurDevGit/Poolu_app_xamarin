using System;
using System.ComponentModel.DataAnnotations;

namespace PoolrApp.Models
{
    public class USZipCode
    {
        [Key]
        public int ZipCode { get; set; }

        [Required]
        public string City { get; set; }

        [Required]
        public string State { get; set; }
    }
}
