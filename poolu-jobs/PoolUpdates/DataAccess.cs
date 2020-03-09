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

        public static IEnumerable<dynamic> GetLotteryNumbers(int statusId)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("GetLotteryNumbers", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@TicketStatusId", (int)statusId);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        yield return new
                        {
                            TicketId = reader.GetInt64(reader.GetOrdinal("TicketId")),
                            FullNumber = reader.GetString(reader.GetOrdinal("LotteryNumber"))
                        };
                    }
                } // end innner using
            } // end outer using
        }

        public static IEnumerable<dynamic> GetPoolsForComboBox(int statusId)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("GetPoolsForComboBox", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@PoolStatusId", (int)statusId);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        yield return new
                        {
                            PoolId = reader.GetInt32(reader.GetOrdinal("PoolId")),
                            PoolName = reader.GetString(reader.GetOrdinal("PoolName"))
                        };
                    }
                } // end innner using
            } // end outer using
        }

        public static IEnumerable<dynamic> GetLotteryPools(int status)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("GetLotteryPools", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@PoolStatusId", (int)status);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        yield return new 
                        {
                            PoolId = reader.GetInt32(reader.GetOrdinal("PoolId")),
                            PoolName = reader.GetString(reader.GetOrdinal("PoolName")),
                            TicketType = reader.GetString(reader.GetOrdinal("TicketTypeName")),
                            DrawDate = reader.GetDateTime(reader.GetOrdinal("DrawDate")),
                            Jackpot = reader.GetDecimal(reader.GetOrdinal("Jackpot")),
                            WinningNumbers = reader.GetString(reader.GetOrdinal("WinningNumbers")),
                            UpdatedBy = reader.GetString(reader.GetOrdinal("UpdatedBy")),
                            DisplayUpdateTime = reader.GetString(reader.GetOrdinal("UpdateTime")),
                            PoolStatus = status
                        };
                    }
                } // end innner using
            } // end outer using
        }

        public static IEnumerable<dynamic> GetPools(int statusId)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("GetPools", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@PoolStatusId", (int)statusId);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        yield return new 
                        {
                            PoolId = reader.GetInt32(reader.GetOrdinal("PoolId")),
                            PoolName = reader.GetString(reader.GetOrdinal("PoolName"))
                        };
                    }
                } // end innner using
            } // end outer using
        }

        public static IEnumerable<dynamic> GetUsers()
        {
            List<dynamic> results = new List<dynamic>();
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("GetUsers", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Add(new 
                        {
                            UserId = reader.GetGuid(reader.GetOrdinal("UserId")),
                            FirstName = reader.GetString(reader.GetOrdinal("FirstName")),
                            LastName = reader.GetString(reader.GetOrdinal("LastName")),
                            Email = reader.GetString(reader.GetOrdinal("Email")),
                            PhoneNumber = reader.GetString(reader.GetOrdinal("PhoneNumber")),
                            IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive")),
                        });
                    }
                } // end innner using
            } // end outer using
            return results;
        }


        public static SqlDataReader GetAllDataExport(string tableName)
        {
            using (var conn = new SqlConnection(connString))
            {
                using (conn)
                {
                    conn.Open();
                    var sqlRequest = "Select * from " + tableName;
                    var cmd = new SqlCommand(sqlRequest, conn);
                    cmd.CommandType = CommandType.Text;

                    var result = cmd.ExecuteReader();
                    return result;
                }

            } // end outer using
        }

        public static IEnumerable<dynamic> GetTickets()
        {
            List<dynamic> results = new List<dynamic>();
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();
                var sqlCommand = "Select * from PoolTickets where TicketStatusId = 3";
                var cmd = new SqlCommand(sqlCommand, conn);
                cmd.CommandType = CommandType.Text;
                
                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        results.Add( new
                        {
                            TicketId = reader.GetInt32(reader.GetOrdinal("TicketId")),
                            PoolId = reader.GetInt32(reader.GetOrdinal("PoolId")),
                            UserId = reader.GetGuid(reader.GetOrdinal("UserId")),
                            CurrentPoolId = reader.GetGuid(reader.GetOrdinal("CurrentPoolId")),
                            UserName = reader.GetGuid(reader.GetOrdinal("UserName")),
                            Email = reader.GetGuid(reader.GetOrdinal("Email")),
                            Phone = reader.GetGuid(reader.GetOrdinal("Phone")),
                            ProcessedTime = reader.GetDateTime(reader.GetOrdinal("ProcessedTime")),
                            TicketStatusId = reader.GetInt32(reader.GetOrdinal("TicketStatusId")),
                            TicketType = reader.GetInt32(reader.GetOrdinal("TicketType")),
                        });
                    }
                } // end innner using
            } // end outer using
            return results;
        }

        public static IEnumerable<dynamic> GetTicketsApproved()
        {
            List<dynamic> results = new List<dynamic>();
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();
                var sqlCommand = "Select * from LotteryNumber ";
                var cmd = new SqlCommand(sqlCommand, conn);
                cmd.CommandType = CommandType.Text;
                
                using (var reader = cmd.ExecuteReader())
                {

                    while (reader.Read())
                    {
                        results.Add( new
                        {
                            LotteryNumberId = reader.GetInt32(reader.GetOrdinal("LotteryNumberId")),
                            TicketId = reader.GetInt32(reader.GetOrdinal("TicketId")),
                            MatchNumbers = reader.GetString(reader.GetOrdinal("MatchNumbers")),
                            FinalNumbers = reader.GetString(reader.GetOrdinal("FinalNumbers")),
                            FullNumber = reader.GetString(reader.GetOrdinal("FullNumber")),
                            TicketType = string.Empty
                        });
                    }
                } // end innner using
            } // end outer using
            return results;
        }

    }
}
