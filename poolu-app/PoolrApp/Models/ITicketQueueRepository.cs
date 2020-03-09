using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;

namespace PoolrApp.Models
{
    interface ITicketQueueRepository 
    {
        IEnumerable<TicketInQueue> TicketsQueue { get; }

        TicketInQueue RemoveTicketFromQueue(int queueId);
    }
}
