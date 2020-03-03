using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Timers;

using System.Configuration;

namespace PoolUpdates
{
    public class Functions
    {
        public static async Task UpdatePowerballJackpotsAsync([TimerTrigger(typeof(PowerballJackpotSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdatePowerballJackpot();
        }

        public static async Task UpdateMegaMillionsJackpotsAsync([TimerTrigger(typeof(MegaMillionsJackpotSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdateMegaMillionJackpot();
        }

        public static async Task UpdatePowerballResultsAsync([TimerTrigger(typeof(PowerballResultsSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdatePowerballResluts();
        }

        public static async Task UpdateMegaMillionsResultsAsync([TimerTrigger(typeof(MegaMillionsResultsSchedule))] TimerInfo timerInfo)
        {
            await Updates.UpdateMegaMillionResluts();
        }
    }
}
