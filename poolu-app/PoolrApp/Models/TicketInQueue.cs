using System;
using System.ComponentModel.DataAnnotations;

namespace PoolrApp.Models
{
    public class TicketInQueue
    {
        [Key]
        public long Id { get; set; }

        [Required]
        public Guid UserId { get; set; }

        [Required]
        public string PhotoName { get; set; }

        [Required]
        public string PhotoUri { get; set; }

        [Required]
        public int PhotoSize { get; set; }

        [Required]
        public DateTime UploadTime { get; set; }
    }
}