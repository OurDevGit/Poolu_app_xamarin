using System;
using System.Collections.Generic;



namespace PoolrApp.Infrastructure
{
    public class NotificationLocalizatedContent : Dictionary<string, string>
    {
        public NotificationLocalizatedContent()
        {

        }
        public NotificationLocalizatedContent(string _en, string _tr = null)
        {
            this.Add("en", _en);
            this.Add("tr", _tr);
        }
        public static implicit operator NotificationLocalizatedContent(string value)
        {
            return new NotificationLocalizatedContent(value);
        }
    }
}