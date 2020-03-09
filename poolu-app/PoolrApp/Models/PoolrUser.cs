using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PoolrApp.Models
{
    [Table("AspNetUsers")]
    public class PoolrUser
    {
        [Key]
        [Column("Id")]
        public Guid UserId { get; set; }

        [Required]
        public string Email { get; set; }

        [Required]
        public string PhoneNumber { get; set; }
       
        public string UserName { get; set; }

        [Required]
        public string FirstName { get; set; }

        [Required]
        public string LastName { get; set; }

        public string ZipCode { get; set; }

        public DateTime? CreateDateTime { get; set; }

        public DateTime? LastModifiedDateTime { get; set; }

        [Required]
        public bool IsActive { get; set; }

        public DateTime? AdminUpdateTime { get; set; }

        public int? AdminId { get; set; }


        [NotMapped]
        public string FullName => FirstName + " " + LastName; 
        

        [NotMapped]
        public string City { get; set; }

        [NotMapped]
        public string State { get; set; }

        [NotMapped]
        public string PhotoUri { get; set; }

        [NotMapped]
        public string JoinDate { get; set; }

        public bool IsOneSignalUser { get; set; }

        public string OneSignalAppId { get; set; }
        public string OneSignalId { get; set; }
        public string OneSignalSegmentId { get; set; }
        public string OneSignalDeviceId { get; set; }

    }
}