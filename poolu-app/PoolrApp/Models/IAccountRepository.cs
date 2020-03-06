using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PoolrApp.Models
{
    public interface IAccountRepository
    {
        IQueryable<AdminUser> AdminUsers { get; }

        IQueryable<PoolrUser> PoolrUsers { get; }

        IQueryable<PoolTicket> PoolTickets { get; }

        IEnumerable<PoolrUser> GetUsers();

        void SaveAdminUser(AdminUser admin);

        AdminUser DeleteAdminUser(int adminId);

       void SavePoolrUser(PoolrUser user, int admin);
    }
}
