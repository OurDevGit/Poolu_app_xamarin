using System.Data.Entity;
using System.Collections.Generic;

namespace PoolrApp.Models
{
    public class AppDBContext : DbContext
    {
        public AppDBContext() 
            :base("PooluDBConnString")
        {}

        public DbSet<PoolType> PoolTypes { get; set; }

        public DbSet<Pool> Pools { get; set; }

        public DbSet<Ticket> Tickets { get; set; }

        public DbSet<PoolTicket> PoolTickets { get; set; }

        public DbSet<LotteryNumber> LotteryNumbers { get; set; }

        public DbSet<LotteryDrawDate> LotteryDrawDates { get; set; }

        public DbSet<PoolrUser> PoolrUsers { get; set; }

        public DbSet<TicketType> TicketTypes { get; set; }

        public DbSet<USZipCode> USZipCodes { get; set; }

        public DbSet<AdminUser> AdminUsers { get; set; }

        public DbSet<Document> Documents { get; set; }
    }
}





























