using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public class ApproveConfirmInfo
    {
        public string UserName { get; set; }

        public string UserEmail { get; set; }

        public string PoolName { get; set; }

        public string DrawDate { get; set; }

        public List<string> LotteryNumbers { get; set; }
    }
}