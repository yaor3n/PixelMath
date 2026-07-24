using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace PixelMath
{
    public static class ActivityLogger
    {
        private static readonly string connStr =
            ConfigurationManager
                .ConnectionStrings["PixelMathSQL"]
                .ConnectionString;

        public static void Log(
            string userId,
            string actionType,
            string description,
            string entityType = null,
            string entityId = null)
        {
            object userIdValue = DBNull.Value;

            Guid parsedUserId;

            if (Guid.TryParse(userId, out parsedUserId))
            {
                userIdValue = parsedUserId;
            }

            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    INSERT INTO ActivityLogs
                    (
                        UserId,
                        ActionType,
                        Description,
                        EntityType,
                        EntityId,
                        CreatedAt
                    )
                    VALUES
                    (
                        @UserId,
                        @ActionType,
                        @Description,
                        @EntityType,
                        @EntityId,
                        GETDATE()
                    )";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@UserId",
                        SqlDbType.UniqueIdentifier
                    ).Value = userIdValue;

                    cmd.Parameters.Add(
                        "@ActionType",
                        SqlDbType.VarChar,
                        50
                    ).Value = actionType;

                    cmd.Parameters.Add(
                        "@Description",
                        SqlDbType.NVarChar,
                        500
                    ).Value = description;

                    cmd.Parameters.Add(
                        "@EntityType",
                        SqlDbType.VarChar,
                        50
                    ).Value = string.IsNullOrWhiteSpace(entityType)
                        ? (object)DBNull.Value
                        : entityType;

                    cmd.Parameters.Add(
                        "@EntityId",
                        SqlDbType.VarChar,
                        100
                    ).Value = string.IsNullOrWhiteSpace(entityId)
                        ? (object)DBNull.Value
                        : entityId;

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        // Logging failure should not stop the main action.
                        System.Diagnostics.Debug.WriteLine(
                            "Activity logging error: " +
                            ex.Message
                        );
                    }
                }
            }
        }
    }
}