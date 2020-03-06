using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PoolrApp.Infrastructure;

namespace PoolrApp.Models
{
    public class TicketsRepository : ITicketsRepository
    {
        private AppDBContext context = new AppDBContext();


        public IQueryable<PoolType> PoolTypes => context.PoolTypes; 

        public IQueryable<Ticket> Tickets => context.Tickets;

        public IQueryable<PoolTicket> PoolTickets => context.PoolTickets;

        public IQueryable<LotteryNumber> LotteryNumbers  => context.LotteryNumbers;

        public IQueryable<TicketType> TicketTypes => context.TicketTypes;

        public bool CheckDuplicateTicket(long ticketId, 
            bool isForApproval, LotteryNumber lotteryNumber = null) =>
            DataAccess.CheckDuplicateTicket(ticketId, isForApproval, lotteryNumber);

        public void ApproveTicket(TicketInfo tInfo) => DataAccess.ApproveTicket(tInfo);

        public void UpdateTicket(TicketInfo tInfo) => DataAccess.UpdateTicket(tInfo);

        public void DeclineApprovedTicket(long ticketId, int poolId, TicketStatus status, int adminId, DateTime declineTime) =>
           DataAccess.DeclineApprovedTicket(ticketId, poolId, status, adminId, declineTime);

        public void DeclinePendingTicket(long ticketId, int adminId, DateTime declineTime)
        {
            var dbEntry = context.Tickets.Find(ticketId);
            if (dbEntry != null)
            {
                dbEntry.TicketStatusId = (int)TicketStatus.Declined;
                dbEntry.AdminUserId = adminId;
                dbEntry.ProcessedTime = declineTime;

                context.SaveChanges();
            }
        }

        public string DeleteDeclinedTicket(long ticketId) =>
            DataAccess.DeletDeclinedTicket(ticketId);

        public void SaveLotteryNumbers(LotteryNumber lotteryNumber)
        {
            if (lotteryNumber.LotteryNumberId == 0)
            {
                context.LotteryNumbers.Add(lotteryNumber);
            }
            else
            {
                var dbEntry = context.LotteryNumbers.Find(lotteryNumber.LotteryNumberId);
                if (dbEntry != null)
                {
                    dbEntry.MatchNumbers = lotteryNumber.MatchNumbers;
                    dbEntry.FinalNumbers = lotteryNumber.FinalNumbers;
                }
            }

            context.SaveChanges();
        }

        public LotteryNumber DeleteLotteryNumber(int lotteryNumberId)
        {
            var dbEntry = context.LotteryNumbers.Find(lotteryNumberId);
            if (dbEntry != null)
            {
                context.LotteryNumbers.Remove(dbEntry);
                context.SaveChanges();
            }
            
            return dbEntry;
        }


        public Ticket RemoveTicket(int Id)
        {
            Ticket dbEntry = context.Tickets.Find(Id);
            if (dbEntry != null)
            {
                context.Tickets.Remove(dbEntry);
                context.SaveChanges();
                
            }

            return dbEntry;
        }
    }
}