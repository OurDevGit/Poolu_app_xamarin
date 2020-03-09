using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Timers;

namespace PoolUpdates
{ 
    public class PowerballJackpotSchedule : PoolWeeklySchedule
    {
        private static readonly DayOfWeek[] weekDays = { DayOfWeek.Thursday, DayOfWeek.Sunday };
        private static readonly string[] times = ConfigurationManager.AppSettings["JackpotUpdateTime"].Split('|');

        public PowerballJackpotSchedule() : base(weekDays, times)
        {
        }
    }

    public class MegaMillionsJackpotSchedule : PoolWeeklySchedule
    {
        private static readonly DayOfWeek[] weekDays = { DayOfWeek.Wednesday, DayOfWeek.Saturday };
        private static readonly string[] times = ConfigurationManager.AppSettings["JackpotUpdateTime"].Split('|');
       
        public MegaMillionsJackpotSchedule() : base(weekDays, times)
        {
        }
    }

    public class DrawingResultsUpdateSchedule : PoolWeeklySchedule
    {
        private static readonly DayOfWeek[] weekDays = { DayOfWeek.Wednesday, DayOfWeek.Thursday, DayOfWeek.Saturday,
          DayOfWeek.Sunday };
        private static readonly string[] times = ConfigurationManager.AppSettings["DrawingResultsUpdateTime"].Split('|');
        public DrawingResultsUpdateSchedule() : base(weekDays, times)
        {
        }
    } 
    
    public class PowerballResultsSchedule : PoolWeeklySchedule
    {
        private static readonly DayOfWeek[] weekDays = { DayOfWeek.Thursday, DayOfWeek.Sunday };
        private static readonly string[] times = ConfigurationManager.AppSettings["ResultsUpdateTime"].Split('|');
        public PowerballResultsSchedule() : base(weekDays, times)
        {
        }
    }

    public class MegaMillionsResultsSchedule : PoolWeeklySchedule
    {
        private static readonly DayOfWeek[] weekDays = { DayOfWeek.Wednesday, DayOfWeek.Saturday };
        private static readonly string[] times = ConfigurationManager.AppSettings["ResultsUpdateTime"].Split('|');
        public MegaMillionsResultsSchedule() : base(weekDays, times)
        {       
        }
    }

    public class LotteryReminderSchedule : PoolWeeklySchedule
    {
        private static readonly DayOfWeek[] weekDays = { DayOfWeek.Tuesday, DayOfWeek.Friday };
        private static readonly string[] times = ConfigurationManager.AppSettings["LotteryReminderUpdateTime"].Split('|');
        public LotteryReminderSchedule() : base(weekDays, times)
        {
        }
    }

    public class PoolWeeklySchedule : WeeklySchedule
    {
        public PoolWeeklySchedule(DayOfWeek[] weekDays, string[] times)
        {
            foreach (var day in weekDays)
            { 
                foreach (var t in times)
                {
                    Add(day, DateTime.Parse(t).TimeOfDay); // UTC time
                }
                
            }
        }
    }
}
