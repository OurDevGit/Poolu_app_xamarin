using System;
using System.Collections.Generic;
using System.Net.Http;
using Newtonsoft.Json;
using System.Text;
using System.Threading.Tasks;

namespace PoolUpdates.OneSignalHelper
{
    public class NotificationClientManager
    {
        /// <summary>
        /// Use this dictionary to add something to your requqest's header
        /// </summary>
        static Dictionary<string, string> Headers = new Dictionary<string, string>
        {
            //  {"authorization","Basic MGMzYWZiYjAtYmZhOC00MDZkLWJlNWQtZmQzOTg2ZjgwMWM5" },
        };

        public static HttpClient GetClient()
        {

            HttpClient client = new HttpClient();
            foreach (var item in Headers)
                client.DefaultRequestHeaders.Add(item.Key, item.Value);

            client.DefaultRequestHeaders.Add("authorization", "Basic " + OneSignalConfiguration.Rest_API_KEY);
            return client;
        }

        /// <summary>
        /// For Quick Test Post Method
        /// </summary>
        /// <typeparam name="TResult">Result to deserialize object type</typeparam>
        /// <typeparam name="TPost">Type to be posted</typeparam>
        /// <param name="value">post value to be serialized</param>
        /// <param name="postUrl">Post url</param>
        public static async Task<TResult> Post<TResult, TPost>(TPost value, string postUrl)
        {
            var response = await NotificationClientManager.GetClient().PostAsync(postUrl,
                              new StringContent(JsonConvert.SerializeObject(value, new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore }),
                              Encoding.UTF8, "application/json")).ConfigureAwait(false);
            var mobileResult = await response.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<TResult>(mobileResult);
            return result;

        }



        /// <summary>
        /// For Quick Test Get Method
        /// </summary>
        /// <typeparam name="TResult">Result to deserialize object type</typeparam>
        /// <param name="url">url to post</param>
        public static async Task<TResult> Get<TResult>(string url)
        {
            var response = await NotificationClientManager.GetClient().GetAsync(url).ConfigureAwait(false);
            var mobileResult = await response.Content.ReadAsStringAsync();
            var result = JsonConvert.DeserializeObject<TResult>(mobileResult);
            return result;

        }


    }
}