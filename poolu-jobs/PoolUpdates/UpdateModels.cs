using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using System.Text.RegularExpressions;

namespace PoolUpdates
{
    public enum TicketTypeId
    {
        Powerball = 1,
        MegaMillion = 2
    }

    public class JackpotModel
    {
        public int Error { get; set; }
        public string JackpotName { get; set; }
        public string Next_draw { get; set; }
        public string Currency { get; set; }
        public double Jackpot { get; set; }
    }

    public class ResultsModel
    {
        public int Error { get; set; }
        public DateTime Draw { get; set; }
        public string Results { get; set; }

        [JsonIgnore]
        public string WinningNumbers
        {
            get
            {
                if (string.IsNullOrEmpty(this.Results))
                {
                    return string.Empty;
                }
                return Regex.Replace(this.Results, @"[^\w]", string.Empty);
            }
        }
    }
}
