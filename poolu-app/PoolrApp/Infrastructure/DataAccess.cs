using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using PoolrApp.Models;


namespace PoolrApp.Infrastructure
{
    public static class DataAccess
    {
        private static string connString = ConfigurationManager.ConnectionStrings["PooluDBConnString"].ConnectionString;

        public static bool CheckDuplicateTicket(long ticketId, bool isForApproval, LotteryNumber lotteryNumber = null)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("CheckDuplicateTicket", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@TicketId", ticketId);
                cmd.Parameters.AddWithValue("@IsForApproval", isForApproval);

                if (lotteryNumber != null)
                {
                    cmd.Parameters.AddWithValue("@LotteryNumberId", lotteryNumber.LotteryNumberId);
                    cmd.Parameters.AddWithValue("@MatchNumbers", lotteryNumber.MatchNumbers);
                    cmd.Parameters.AddWithValue("@FinalNumbers", lotteryNumber.FinalNumbers);
                }
                

                return Convert.ToInt32(cmd.ExecuteScalar()) == 1 ? true : false;
            }
        }

        public static void ApproveTicket(TicketInfo tInfo)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("ApproveTicket", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@TicketId", tInfo.TicketId);
                cmd.Parameters.AddWithValue("@PoolId", tInfo.PoolId);
                cmd.Parameters.AddWithValue("@TerminalId", tInfo.TerminalId);
                cmd.Parameters.AddWithValue("@StatusId", (int)tInfo.Status);
                cmd.Parameters.AddWithValue("@AdminId", tInfo.AdminId);
                cmd.Parameters.AddWithValue("@ProcessedTime", tInfo.ApproveTime);

                cmd.ExecuteNonQuery();
            }
        }

        public static void UpdateTicket(TicketInfo tInfo)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("UpdateTicket", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@TicketId", tInfo.TicketId);
                cmd.Parameters.AddWithValue("@PoolId", tInfo.PoolId);
                cmd.Parameters.AddWithValue("@TerminalId", tInfo.TerminalId);
                cmd.Parameters.AddWithValue("@StatusId", (int)tInfo.Status);
                cmd.Parameters.AddWithValue("@AdminId", tInfo.AdminId);
                cmd.Parameters.AddWithValue("@UpdateTime", tInfo.UpdateTime);

                cmd.ExecuteNonQuery();
            }
        }

        public static void DeclineApprovedTicket(long ticketId, int poolId, TicketStatus status, int adminId, DateTime declineTime)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("DeclineApprovedTicket", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@TicketId", ticketId);
                cmd.Parameters.AddWithValue("@PoolId", poolId);
                cmd.Parameters.AddWithValue("@StatusId", (int)status);
                cmd.Parameters.AddWithValue("@AdminId", adminId);
                cmd.Parameters.AddWithValue("@ProcessedTime", declineTime);

                cmd.ExecuteNonQuery();
            }
        }

        public static string DeletDeclinedTicket(long ticketId)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("RemoveTicket", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@TicketId", ticketId);
                cmd.Parameters.AddWithValue("@IsDeclinedTicket", 1);

                var photoNameParam = cmd.Parameters.Add("@PhotoName", SqlDbType.VarChar);
                photoNameParam.Direction = ParameterDirection.Output;
                photoNameParam.Size = 50;

                cmd.ExecuteNonQuery();

                return photoNameParam.Value.ToString();
            }

        }

        public static IEnumerable<LotteryNumber> GetLotteryNumbers(TicketStatus statusId)
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
                        yield return new LotteryNumber
                        {
                            TicketId = reader.GetInt64(reader.GetOrdinal("TicketId")),
                            FullNumber = reader.GetString(reader.GetOrdinal("LotteryNumber"))
                        };
                    }
                } // end innner using
            } // end outer using
        }

        public static IEnumerable<Pool> GetPoolsForComboBox(PoolStatus statusId)
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
                        yield return new Pool
                        {
                            PoolId = reader.GetInt32(reader.GetOrdinal("PoolId")),
                            PoolName = reader.GetString(reader.GetOrdinal("PoolName"))
                        };
                    }
                } // end innner using
            } // end outer using
        }

        public static IEnumerable<Pool> GetLotteryPools(PoolStatus status)
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
                        yield return new Pool
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

        public static IEnumerable<Pool> GetPools(PoolStatus statusId)
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
                        yield return new Pool
                        {
                            PoolId = reader.GetInt32(reader.GetOrdinal("PoolId")),
                            PoolName = reader.GetString(reader.GetOrdinal("PoolName"))
                        };
                    }
                } // end innner using
            } // end outer using
        }

        public static IEnumerable<PoolrUser> GetUsers()
        {
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
                        yield return new PoolrUser
                        {
                            UserId = reader.GetGuid(reader.GetOrdinal("UserId")),
                            FirstName = reader.GetString(reader.GetOrdinal("FirstName")),
                            LastName = reader.GetString(reader.GetOrdinal("LastName")),
                            Email = reader.GetString(reader.GetOrdinal("Email")),
                            PhoneNumber = reader.GetString(reader.GetOrdinal("PhoneNumber")),
                            City = reader.GetString(reader.GetOrdinal("City")),
                            State = reader.GetString(reader.GetOrdinal("State")),
                            ZipCode = reader.GetString(reader.GetOrdinal("ZipCode")),
                            CreateDateTime = Convert.ToDateTime(reader.GetString(reader.GetOrdinal("CreateDateTime"))),
                            IsActive = reader.GetBoolean(reader.GetOrdinal("IsActive")),
                            PhotoUri = ConfigurationManager.AppSettings["UserPhotoBaseUrl"] + reader.GetString(reader.GetOrdinal("PhotoName"))
                        };
                    }
                } // end innner using
            } // end outer using
        }

        public static void UpdatePool(Pool pool, int adminId)
        {
            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("UpdatePool", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@PoolId", pool.PoolId);
                cmd.Parameters.AddWithValue("@Jackpot", pool.Jackpot);
                cmd.Parameters.AddWithValue("@AdminId", adminId);

                if (!string.IsNullOrEmpty(pool.WinningNumbers))
                {
                    cmd.Parameters.AddWithValue("WinningNumbers", pool.WinningNumbers);
                }
                

                cmd.ExecuteNonQuery();
            }
        }

        public static ApproveConfirmInfo GetApproveConfirmInfo(long ticketId)
        {
            var info = new ApproveConfirmInfo();
            var lottoNums = new List<string>();

            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("GetApproveConfirmInfo", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@TicketId", ticketId);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        info.UserName = reader.GetString(reader.GetOrdinal("UserName")).Split(' ')[0];
                        info.UserEmail = reader.GetString(reader.GetOrdinal("UserEmail"));
                        info.PoolName = reader.GetString(reader.GetOrdinal("PoolName"));
                        info.DrawDate = reader.GetString(reader.GetOrdinal("DrawDate"));
                    }

                    reader.NextResult();

                    while (reader.Read())
                    {
                        lottoNums.Add(reader.GetString(reader.GetOrdinal("LotteryNumbers")));
                    }

                    info.LotteryNumbers = lottoNums;

                } // end innner using

                return info;
            }
        }

        public static DeclineConfirmInfo  GetDeclinedConfirmInfo(long ticketId)
        {
            var info = new DeclineConfirmInfo();

            using (var conn = new SqlConnection(connString))
            {
                conn.Open();

                var cmd = new SqlCommand("GetDeclineConfirmInfo", conn)
                {
                    CommandType = CommandType.StoredProcedure
                };

                cmd.Parameters.AddWithValue("@TicketId", ticketId);

                using (var reader = cmd.ExecuteReader())
                {
                    while (reader.Read())
                    {
                        info.UserName = reader.GetString(reader.GetOrdinal("UserName")).Split(' ')[0];
                        info.UserEmail = reader.GetString(reader.GetOrdinal("UserEmail"));
                        info.PoolName = reader.GetString(reader.GetOrdinal("PoolName"));
                        info.DrawDate = reader.GetString(reader.GetOrdinal("DrawDate"));
                        info.UploadDate = reader.GetDateTime(reader.GetOrdinal("UploadTime")).ToShortDateString();
                        info.UploadTime = reader.GetDateTime(reader.GetOrdinal("UploadTime")).ToShortTimeString();
                    }

                } // end innner using

                return info;
            }
        }

    }
}