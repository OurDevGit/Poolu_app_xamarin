using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;



namespace PoolUpdates.OneSignalHelper
{
    public class NotificationButton
    {
        public string id { get; set; }
        public string text { get; set; }
        public string icon { get; set; }
    }
}