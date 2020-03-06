using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data;
using System.Data.Sql;
using System.Data.SqlClient;

namespace PoolrOCR
{
    public class DataAccess
    {
        private static string connString = ConfigurationManager.ConnectionStrings["PooluDBConnString"].ConnectionString;

        public static void SaveTicket(Ticket ticket, DataTable lotteryNumberTable)
        {
            using (SqlConnection connection = new SqlConnection(connString))
            using (connection)
            {

                connection.Open();

                var insertCommand = new SqlCommand("SaveLotteryNumbers", connection);
                insertCommand.CommandType = CommandType.StoredProcedure;

                insertCommand.Parameters.AddWithValue("@UserId", ticket.UserId);
                insertCommand.Parameters.AddWithValue("@PhotoName", ticket.PhotoName);
                insertCommand.Parameters.AddWithValue("@PhotoSize", ticket.PhotoSize);
                insertCommand.Parameters.AddWithValue("@UploadTime", ticket.UploadTime);
                insertCommand.Parameters.AddWithValue("@PoolId", ticket.PoolId);
               

                var tvpParam = insertCommand.Parameters.AddWithValue("@LotteryNumbers", lotteryNumberTable);
                tvpParam.SqlDbType = SqlDbType.Structured;

                
                insertCommand.ExecuteNonQuery();
            }
        }
    }
}
