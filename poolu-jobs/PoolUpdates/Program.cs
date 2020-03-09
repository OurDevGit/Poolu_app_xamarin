using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Host;
using Microsoft.Azure.WebJobs.Extensions;
using Microsoft.Extensions.Logging;

namespace PoolUpdates
{
    // To learn more about Microsoft Azure WebJobs SDK, please see https://go.microsoft.com/fwlink/?LinkID=320976
    class Program
    {
        // Please set the following connection strings in app.config for this WebJob to run:
        // AzureWebJobsDashboard and AzureWebJobsStorage
        static void Main()
        {
            try
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
            catch (Exception ex)
            {

                throw;
            }
        }
    }
}


//System.IO.FileLoadException
//  HResult = 0x80131040
//  Message=Could not load file or assembly 'Microsoft.Azure.WebJobs.Host, Version=3.0.16.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35' or one of its dependencies.The located assembly's manifest definition does not match the assembly reference. (Exception from HRESULT: 0x80131040)
//  Source=<Cannot evaluate the exception source>
//  StackTrace:
//<Cannot evaluate the exception stack trace>

//Inner Exception 1:
//FileLoadException: Could not load file or assembly 'Microsoft.Azure.WebJobs.Host, Version=2.3.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35' or one of its dependencies.The located assembly's manifest definition does not match the assembly reference. (Exception from HRESULT: 0x80131040)




//using System;
//using System.Collections.Generic;
//using System.Linq;
//using System.Net;
//using System.Text;
//using System.Threading.Tasks;
//using Microsoft.Azure.WebJobs;
//using Microsoft.Azure.WebJobs.Extensions;
//using Microsoft.Extensions.Hosting;
//using Microsoft.Extensions.Logging;
//using Microsoft.Extensions.Configuration;
//using Microsoft.Azure.WebJobs.Logging;

//namespace PoolUpdates
//{
//    // To learn more about Microsoft Azure WebJobs SDK, please see https://go.microsoft.com/fwlink/?LinkID=320976
//    class Program
//    {
//        // Please set the following connection strings in app.config for this WebJob to run:
//        // AzureWebJobsDashboard and AzureWebJobsStorage
//        public static async Task Main(string[] args)
//        {
//            try
//            {
//                ServicePointManager.DefaultConnectionLimit = Int32.MaxValue;

//                var builder = new HostBuilder();
//                builder.UseEnvironment("Development");
//                builder.ConfigureWebJobs(b =>
//                {
//                    b.UseHostId("987412");
//                    b.AddDashboardLogging();
//                    b.AddAzureStorageCoreServices();
//                    b.AddAzureStorage(a =>
//                    {
//                        a.MaxPollingInterval = TimeSpan.FromSeconds(2);
//                    });
//                    b.AddExecutionContextBinding();

//                    b.AddTimers();
//                    //b.AddFiles(a => a.RootPath = @"c:\data\import");


//                });

//                builder.ConfigureLogging((context, b) =>
//                {

//                    b.SetMinimumLevel(LogLevel.Debug);
//                    b.AddFilter("Function", LogLevel.Error);
//                    b.AddFilter(LogCategories.Results, LogLevel.Error);
//                    b.AddFilter("Host.Triggers", LogLevel.Debug);
//                    b.AddConsole((g) => {
//                        g.IncludeScopes = true;
//                    });
//                });

//                builder.ConfigureAppConfiguration(b =>
//                {
//                    // Adding command line as a configuration source
//                    b.AddCommandLine(args);
//                });

//                var host = builder.Build();
//                using (host)
//                {
//                    await host.RunAsync();
//                }
//            }
//            catch (Exception ex)
//            {

//                throw;
//            }


//        }
//    }
//}

