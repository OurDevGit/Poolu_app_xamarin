using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;


namespace PoolUpdates.OneSignalHelper
{
    public class OneSignalConfiguration
    {


        public static string App_ID = "YOUR_APP_ID_HERE";
        public static string Rest_API_KEY = "YOUR_REST_API_KEY_HERE";
        /// <summary>
        /// You can change the post url
        /// </summary>
        public static string URL_Notification_POST = "https://onesignal.com/api/v1/notifications";

        public OneSignalConfiguration()
        {
            App_ID = ConfigurationManager.AppSettings["OneSignalApp_ID"];
            Rest_API_KEY = ConfigurationManager.AppSettings["OneSignalRest_API_KEY"];
            URL_Notification_POST = ConfigurationManager.AppSettings["OneSignalNotifUrl"];
        }

    }
}