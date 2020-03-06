using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions;

namespace PoolUpdates
{
    // To learn more about Microsoft Azure WebJobs SDK, please see https://go.microsoft.com/fwlink/?LinkID=320976
    class Program
    {
        // Please set the following connection strings in app.config for this WebJob to run:
        // AzureWebJobsDashboard and AzureWebJobsStorage
        static void Main()
        {
            ServicePointManager.DefaultConnectionLimit = Int32.MaxValue;
            var config = new JobHostConfiguration();
           
            // testing in dev enviroment
            if (config.IsDevelopment)
            {
                config.UseDevelopmentSettings();
                config.HostId = "987412";
                config.Tracing.ConsoleLevel = System.Diagnostics.TraceLevel.Verbose;
                config.Singleton.ListenerLockPeriod = TimeSpan.FromSeconds(15);
                config.Queues.MaxPollingInterval = TimeSpan.FromSeconds(2);
            }

            config.UseTimers();

            var host = new JobHost(config);
            // The following code ensures that the WebJob will be running continuously
            host.RunAndBlock();
        }
    }
}
