using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using PoolrApp.Infrastructure;

namespace PoolrApp.Models
{
    public class AccountRepository : IAccountRepository
    {
        private AppDBContext context = new AppDBContext();

        public IQueryable<AdminUser> AdminUsers => context.AdminUsers;

        public void SaveAdminUser(AdminUser admin)
        {
            if (admin.AdminId == 0)
            {
                context.AdminUsers.Add(admin);
            }
            else
            {
                var dbEntry = context.AdminUsers.Find(admin.AdminId);
                if (dbEntry != null)
                {
                    dbEntry.FirstName = admin.FirstName;
                    dbEntry.LastName = admin.LastName;
                    dbEntry.PhoneNumber = admin.PhoneNumber;
                    dbEntry.Email = admin.Email;
                    dbEntry.Password = admin.Password;
                    dbEntry.IsActive = admin.IsActive;
                }
            }

            context.SaveChanges();
        }

        public AdminUser DeleteAdminUser(int adminId)
        {
            var dbEntry = context.AdminUsers.Find(adminId);
            if (dbEntry != null)
            {
                context.AdminUsers.Remove(dbEntry);
                context.SaveChanges();
            }

            return dbEntry;
        }

        public IQueryable<PoolrUser> PoolrUsers => context.PoolrUsers;

        public IEnumerable<PoolrUser> GetUsers() =>
            DataAccess.GetUsers();

        public IQueryable<PoolTicket> PoolTickets => context.PoolTickets;

        public void SavePoolrUser(PoolrUser user, int adminId)
        {
            var dbEntry = context.PoolrUsers.Find(user.UserId);
            if (dbEntry != null)
            {
                dbEntry.IsActive = user.IsActive;
                dbEntry.AdminId = adminId;
                dbEntry.AdminUpdateTime = DateTime.Now;

                context.SaveChanges();
            }
        }
    }
}