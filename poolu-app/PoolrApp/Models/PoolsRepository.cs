using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PoolrApp.Infrastructure;

namespace PoolrApp.Models
{
    public class PoolsRepository : IPoolsRepository
    {
        private AppDBContext context = new AppDBContext();

        public IQueryable<TicketType> TicketTypes => context.TicketTypes; 
        
        public IQueryable<PoolType> PoolTypes => context.PoolTypes;

        public IQueryable<Pool> Pools => context.Pools;

        public IEnumerable<Pool> GetLotteryPools(PoolStatus status) =>
            DataAccess.GetLotteryPools(status);

        public void UpdatePool(Pool pool, int adminId) =>
            DataAccess.UpdatePool(pool, adminId);
    }
}