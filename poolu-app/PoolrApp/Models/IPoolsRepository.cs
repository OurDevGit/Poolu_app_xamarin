using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public interface IPoolsRepository
    {
        IQueryable<Pool> Pools { get; }

        IQueryable<PoolType> PoolTypes { get; }

        IEnumerable<Pool> GetLotteryPools(PoolStatus status);

        IQueryable<TicketType> TicketTypes { get; }

        void UpdatePool(Pool pool, int adminId);
    }
}