using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.Entity;

namespace PoolrApp.Models
{
    public interface ITicketsRepository 
    {
        IQueryable<Ticket> Tickets { get; }

        IQueryable<LotteryNumber> LotteryNumbers { get; }

        IQueryable<PoolTicket> PoolTickets { get; }

        IQueryable<PoolType> PoolTypes { get; }   

        IQueryable<TicketType> TicketTypes { get; }

        bool CheckDuplicateTicket(long ticketId, bool isForApproval, LotteryNumber lotteryNumber = null);

        void SaveLotteryNumbers(LotteryNumber lotteryNumber);

        LotteryNumber DeleteLotteryNumber(int lotteryNumberId);

        void ApproveTicket(TicketInfo tInfo);

        void UpdateTicket(TicketInfo tInfo);

        void DeclinePendingTicket(long ticketId, int adminId, DateTime declineTime);

        void DeclineApprovedTicket(long ticketId, int PoolId, TicketStatus status, int adminId, DateTime declineTime);

        string DeleteDeclinedTicket(long ticketId);

        Ticket RemoveTicket(int queueId);
    }
}
