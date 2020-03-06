using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PoolrApp.Models
{

    public enum TicketTypes
    {
        Powerball = 1,
        MegaMillions = 2
    }

    public enum TicketStatus
    {
        Pending = 0,
        Declined = 1,
        Removed = 2,
        Approved = 3,
        PrevPending = 4
    }

    public class Ticket
    {
        [Key]
        public long TicketId { get; set; }

        [Required]
        public int PoolId { get; set; }

        [Required]
        public Guid UserId { get; set; }

        [Required]
        public string PhotoName { get; set; }

        [Required]
        public int PhotoSize { get; set; }

        [Required]
        public DateTime UploadTime { get; set; }

        [Required]
        public int TicketStatusId { get; set; }

        public DateTime? ProcessedTime { get; set; }

        public int? AdminUserId { get; set; }

        public string TerminalId { get; set; }

    }
}