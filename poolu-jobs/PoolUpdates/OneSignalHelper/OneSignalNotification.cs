using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Threading.Tasks;

namespace PoolUpdates.OneSignalHelper
{
    public class OneSignalNotification
    {
        public string app_id { get => OneSignalConfiguration.App_ID; }
        public List<string> included_segments { get; set; }
        public List<string> include_player_ids { get; set; }
        public NotificationLocalizatedContent contents { get; set; }
        public NotificationLocalizatedContent headings { get; set; }
        public List<NotificationButton> buttons { get; set; }
        /// <summary>
        /// Any data to send
        /// </summary>
        public Object data { get; set; }
        /// <summary>
        /// URL to open directly in mobile
        /// </summary>
        public string url { get; set; }

        /// <summary>
        /// 10 is max priority
        /// </summary>
        public int priority { get; set; }
        /// <summary>
        /// Android property
        /// </summary>
        public string android_group { get; set; }
        /// <summary>
        /// Android property
        /// use $[notif_count] for using total notification count
        /// </summary>
        public NotificationLocalizatedContent android_group_message { get; set; }
        /// <summary>
        /// Android property
        /// </summary>
        public string small_icon { get; set; }
        /// <summary>
        /// Android property
        /// </summary>
        public string large_icon { get; set; }
        /// <summary>
        /// Sets the background color of the notification circle to the left of the notification text. Only applies to apps targeting Android API level 21+ on Android 5.0+ devices.
        /// Example(Red) : "FFFF0000"
        /// </summary>
        public string android_accent_color { get; set; }

        public OneSignalNotification()
        {
            include_player_ids = new List<string>();
        }
        public OneSignalNotification(string playerId, NotificationLocalizatedContent _content)
        {
            this.included_segments = new List<string> { playerId };
            this.contents = _content;
        }
        /// <summary>
        /// returns proccess successful statement
        /// </summary>
        /// <returns></returns>
        public async Task<bool> Send()
        {
            return await NotificationSender.SendNotification(this);
        }
    }
}