using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public class DeclineConfirmInfo
    {
        public string UserName { get; set; }

        public string UserEmail { get; set; }

        public string PoolName { get; set; }

        public string DrawDate { get; set; }

        public string UploadDate { get; set; }

        public string UploadTime { get; set; }
    }
}