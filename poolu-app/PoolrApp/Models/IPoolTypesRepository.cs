using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PoolrApp.Models
{
    public interface IPoolTypesRepository
    {
        IQueryable<PoolType> PoolTypes { get; }

        IQueryable<TicketType> TicketTypes { get; }

        void SavePoolType(PoolType pool);

        PoolType DeletePoolType(int poolId);

    }
}