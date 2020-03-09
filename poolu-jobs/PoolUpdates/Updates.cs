using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using PoolUpdates.OneSignalHelper;

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

        public static async Task UpdatePowerballResults() =>
            await UpdateResults(TicketTypeId.Powerball);
            
        public static async Task UpdateMegaMillionResults() =>
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

        public static async Task SendLotteryNotification() =>
            await SendLotteryNotificationToAllUsers();


        private static async Task SendLotteryNotificationToAllUsers()
        {
            List<JackpotModel> pools = new List<JackpotModel>();
            List<OneSignalNotification> notifToSend = new List<OneSignalNotification>();

            var url = ConfigurationManager.AppSettings["JackpotApi"];

            if (!string.IsNullOrEmpty(url))
            {
                var json = await GetJsonResponse(TicketTypeId.Powerball, url);
                var model = JsonConvert.DeserializeObject<JackpotModel>(json);
                model.JackpotName = "Powerball";
                pools.Add(model);

                json = await GetJsonResponse(TicketTypeId.MegaMillion, url);
                model = JsonConvert.DeserializeObject<JackpotModel>(json);
                model.JackpotName = "MegaMillion";
                pools.Add(model);


            }

            try
            {

                foreach (var item in pools)
                {
                    double jackot = item.Jackpot;
                    string drawdate = item.Next_draw;
                    string loteryname = item.JackpotName;
                    var content = "The " + loteryname + " jackpot is :" + jackot + "$ and the drawing data : " + drawdate;
                    OneSignalNotification _notificationItem = new OneSignalNotification();
                    _notificationItem.headings = "HELLO FROM Poolu !";
                    _notificationItem.contents = content;
                    _notificationItem.small_icon = "icon.png";
                    _notificationItem.included_segments = new List<string> { "PooluUserSegment" };
                    //_notificationItem.include_player_ids = new List<string> { "OneSignal_playerid_fordevice", "Another_onesignal_playerid" };
                    //myNotification.Send();
                    notifToSend.Add(_notificationItem);
                }

                foreach (var item in notifToSend)
                {
                    item.Send();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public static async Task UpdateWinnersPerDrawing () =>
            await GetTodayDrawinWinners();


        private static async Task GetTodayDrawinWinners()
        {
            var users = DataAccess.GetUsers();
            var lotterypools = DataAccess.GetLotteryPools(3).Where(x => x.PoolStatus == 2).ToList();
            var lotterytickets = DataAccess.GetTickets();
            var lotterynumbertickets = DataAccess.GetTicketsApproved();
            var winningticekts = new List<dynamic>();

                
            var powerballpools = new List<dynamic>();
            var megamillionpools = new List<dynamic>();
            foreach (var item in lotterypools)
            {
                var drawingdate = (DateTime)item.DrawDate;
                var pooltypeId = item.PoolTypeId;
                // PowerballResultsSchedule
                if (pooltypeId == 1 && (drawingdate.DayOfWeek == DayOfWeek.Thursday ||  drawingdate.DayOfWeek == DayOfWeek.Sunday) && drawingdate.Month >= DateTime.Now.Month && drawingdate.Year >= DateTime.Now.Year)
                {
                    powerballpools.Add(item);
                }

                // PowerballResultsSchedule
                if (pooltypeId == 2 && (drawingdate.DayOfWeek == DayOfWeek.Wednesday || drawingdate.DayOfWeek == DayOfWeek.Saturday) && drawingdate.Month >= DateTime.Now.Month && drawingdate.Year >= DateTime.Now.Year)
                {
                    powerballpools.Add(item);
                }
            }

            foreach (var item in lotterytickets)
            {
                var data = powerballpools.FirstOrDefault(x => x.TicketTypeId == item.TicketTypeId);
                if (data != null && item.MatchNumbers == data.WinningNumbers)
                {
                    var winningitem = lotterytickets.FirstOrDefault(x => x.TicketId == item.TicketId);
                    if (winningitem != null)
                    {
                        winningticekts.Add(winningitem);
                    }
                }

            }

            var receiverMail = ConfigurationManager.AppSettings["ExcelDataReceiver"].Split('|').ToList();
            foreach (var item in winningticekts)
            {
                var jackpot = lotterypools.FirstOrDefault(x => x.PoolId == item.PoolId).Jackpot;
                var winnerMessage = $"We have a winner " + item.UserName + " E-mail : " + item.Email + " Jackpot : ";
                Helpers.SendMailMessage(receiverMail, "Winners ", "info@pooluapp.com",
                    winnerMessage, null, null);
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
