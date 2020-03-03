using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;

namespace PoolUpdates
{
    public class DataAccess
    {
        private static readonly string connString = ConfigurationManager.ConnectionStrings["PooluDBConnString"].ConnectionString;

        public static void UpdateJackpot(TicketTypeId id, JackpotModel model)
        {
            using (SqlConnection connection = new SqlConnection(connString))
            using (connection)
            {
                connection.Open();

                var Command = new SqlCommand("UpdateJackpot", connection)
                {
                    CommandType = CommandType.StoredProcedure
                };

                Command.Parameters.AddWithValue("@TicketTypeId", id);
                Command.Parameters.AddWithValue("@Jackpot", model.Jackpot);

                Command.ExecuteNonQuery();
            }
        }

        public static void UpdateWinningNumbers(TicketTypeId id, ResultsModel model)
        {
            using (SqlConnection connection = new SqlConnection(connString))
            using (connection)
            {
                connection.Open();

                var command = new SqlCommand("UpdateWinningNumbers", connection)
                {
                    CommandType = CommandType.StoredProcedure
                };

                command.Parameters.AddWithValue("@TicketTypeId", id);
                command.Parameters.AddWithValue("@DrawDate", model.Draw);
                command.Parameters.AddWithValue("@WinningNumbers", model.WinningNumbers);

                command.ExecuteNonQuery();
            }
        }
    }
}
