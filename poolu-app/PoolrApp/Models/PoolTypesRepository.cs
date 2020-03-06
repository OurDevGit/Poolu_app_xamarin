using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public class PoolTypesRepository : IPoolTypesRepository
    {
        private AppDBContext context = new AppDBContext();


        public IQueryable<TicketType> TicketTypes => context.TicketTypes; 

        public IQueryable<PoolType> PoolTypes => context.PoolTypes;

        public void SavePoolType(PoolType pool)
        {
            if (pool.PoolTypeId == 0)
            {
                context.PoolTypes.Add(pool);
            }
            else
            {
                var dbEntry = context.PoolTypes.Find(pool.PoolTypeId);
                if (dbEntry != null)
                {
                    dbEntry.PoolName = pool.PoolName;
                    dbEntry.TicketTypeId = pool.TicketTypeId;
                    dbEntry.ScreenPosition = pool.ScreenPosition;
                    dbEntry.GroupSize = pool.GroupSize;
                    dbEntry.IsActive = pool.IsActive;
                }
            }

            context.SaveChanges();
        }

        public PoolType DeletePoolType(int poolTypeId)
        {
            var dbEntry = context.PoolTypes.Find(poolTypeId);
            if (dbEntry != null)
            {
                context.PoolTypes.Remove(dbEntry);
                context.SaveChanges();
            }

            return dbEntry;
        }

    }
}