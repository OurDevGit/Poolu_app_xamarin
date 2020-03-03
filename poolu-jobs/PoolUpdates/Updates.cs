using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;

namespace PoolUpdates
{
    public class Updates
    {
        public static async Task UpdatePowerballJackpot() =>
            await UpdateJackpot(TicketTypeId.Powerball);

        public static async Task UpdateMegaMillionJackpot() =>
            await UpdateJackpot(TicketTypeId.MegaMillion);

        private static async Task UpdateJackpot(TicketTypeId id)
        {
            var url = ConfigurationManager.AppSettings["JackpotApi"];

            if (!string.IsNullOrEmpty(url))
            {
                var json = await GetJsonResponse(id, url);
                var model = JsonConvert.DeserializeObject<JackpotModel>(json);

                if (model.Error == 0)
                {
                    DataAccess.UpdateJackpot(id, model);
                }
            }

        }

        public static async Task UpdatePowerballResluts() =>
            await UpdateResults(TicketTypeId.Powerball);
            
        public static async Task UpdateMegaMillionResluts() =>
            await UpdateResults(TicketTypeId.MegaMillion);
            
        private static async Task UpdateResults(TicketTypeId id)
        {
            var url = ConfigurationManager.AppSettings["ResultsApi"];

            if (!string.IsNullOrEmpty(url))
            {
                var json = await GetJsonResponse(id, url);
                var model = JsonConvert.DeserializeObject<ResultsModel>(json);

                if (model.Error == 0)
                {
                    DataAccess.UpdateWinningNumbers(id, model);
                }
            }
        }

        private static async Task<string> GetJsonResponse(TicketTypeId id, string url)
        {
            if (id == TicketTypeId.Powerball)
            {
                url += ConfigurationManager.AppSettings["Powerball"];
            }
            else if (id == TicketTypeId.MegaMillion)
            {
                url += ConfigurationManager.AppSettings["MegaMillions"];
            }

            var client = new HttpClient();
            var response = await client.GetAsync(url);

            return await response.Content.ReadAsStringAsync();
        }
    }
}
