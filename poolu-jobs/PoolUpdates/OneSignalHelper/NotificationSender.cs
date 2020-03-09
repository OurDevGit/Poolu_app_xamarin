using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Threading.Tasks;

namespace PoolUpdates.OneSignalHelper
{
    public class NotificationSender
    {
        public static async void SendNotification(string playerId, NotificationLocalizatedContent content)
        {
            var response = await NotificationClientManager.Post<Object, OneSignalNotification>(new OneSignalNotification
            {
                android_group = "test",
                contents = content,
                priority = 10,
                include_player_ids = new List<string> { playerId },
                small_icon = "icon",


            }, OneSignalConfiguration.URL_Notification_POST);

            var test = response;
        }
        /// <summary>
        /// Returns successful statement
        /// </summary>
        /// <returns></returns>
        public static async Task<bool> SendNotification(OneSignalNotification notification)
        {
            try
            {
                var response = await NotificationClientManager.Post<object, OneSignalNotification>(notification, OneSignalConfiguration.URL_Notification_POST);
                return response != null;
            }
            catch (Exception ex)
            {
                Debug.WriteLine(ex.ToString());
                return false;
            }
        }
    }
}