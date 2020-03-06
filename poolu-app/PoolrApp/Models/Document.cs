using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace PoolrApp.Models
{
    public enum DocumentType
    {
        PrivacyPolicy = 1,
        TermsAndConditions = 2,
        PlainTalk = 3,
        RulesToPool = 4

    }
    public class Document
    {
        [Key]
        public int DocId { get; set; }
        public string DocContent { get; set; }
    }
}