using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PoolrApp.Models
{
    [Table("PoolTickets")]
    public class PoolTicket
    {
        [Key]
        public long TicketId { get; set; }

        public string TerminalId { get; set; }

        public int PoolId { get; set; }

        public int CurrentPoolId { get; set; }

        public string PoolName { get; set; }

        public string PhotoName { get; set; }

        public DateTime DrawDate { get; set; }

        public Guid UserId { get; set; }

        public string UserName { get; set; }

        public string Email { get; set; }

        public string Phone { get; set; }

        public string City { get; set; }

        public string State { get; set; }

        public int TicketStatusId { get; set; }

        public string TicketStatus { get; set; }

        public DateTime UploadTime { get; set; }

        public DateTime? ProcessedTime { get; set; }

        public string ProcessedBy { get; set; }
    }
}