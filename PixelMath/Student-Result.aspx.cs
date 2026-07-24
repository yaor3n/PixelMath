using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Student_Result : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string studentId = Session["UserId"].ToString();
                LoadTopCardsData(studentId);
                LoadTableResults(studentId);
                LoadRevisionReminders(studentId);
            }
        }

        private void LoadTopCardsData(string studentId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. Fetch Quizzes Taken, Avg Score, and Total Time Spent (using TimeTakenSeconds)
                string sqlStats = @"
                                SELECT 
                                    COUNT(AttemptId) AS QuizzesTaken,
                                    ISNULL(AVG(Score), 0) AS AvgScore,
                                    ISNULL(SUM(TimeTakenSeconds), 0) AS TotalSeconds
                                FROM QuizAttempts 
                                WHERE StudentId = @StudentId AND IsCompleted = 1;";

                SqlCommand cmd = new SqlCommand(sqlStats, conn);
                cmd.Parameters.AddWithValue("@StudentId", studentId);

                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    lblQuizzesTaken.Text = reader["QuizzesTaken"].ToString();
                    lblAvgScore.Text = Convert.ToInt32(reader["AvgScore"]) + "%";

                    int totalSec = Convert.ToInt32(reader["TotalSeconds"]);
                    TimeSpan time = TimeSpan.FromSeconds(totalSec);

                    if (time.Hours > 0)
                    {
                        lblTimeSpent.Text = $"{time.Hours}h {time.Minutes}m"; // Displays "1h 15m"
                    }
                    else
                    {
                        lblTimeSpent.Text = $"{time.Minutes}m {time.Seconds}s"; // Displays "45m 12s"
                    }
                }
                reader.Close();

                // 2. Fetch Best Topic
                string sqlBestTopic = @"
                                    SELECT TOP 1 Q.Title
                                    FROM QuizAttempts QA
                                    INNER JOIN Quizzes Q ON QA.QuizId = Q.QuizId
                                    WHERE QA.StudentId = @StudentId AND QA.IsCompleted = 1
                                    GROUP BY Q.Title
                                    ORDER BY AVG(QA.Score) DESC;";

                SqlCommand cmdTopic = new SqlCommand(sqlBestTopic, conn);
                cmdTopic.Parameters.AddWithValue("@StudentId", studentId);

                object result = cmdTopic.ExecuteScalar();
                lblBestTopic.Text = result != null ? result.ToString() : "N/A";
            }
        }

        private void LoadTableResults(string studentId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Simple query loading all completed attempts
                string sql = @"
                        SELECT 
                            Q.Title AS QuizTitle,
                            QA.Score,
                            CASE WHEN QA.Score >= Q.PassingMarks THEN 1 ELSE 0 END AS IsPassed
                        FROM QuizAttempts QA
                        INNER JOIN Quizzes Q ON QA.QuizId = Q.QuizId
                        WHERE QA.StudentId = @StudentId AND QA.IsCompleted = 1
                        ORDER BY QA.EndTime DESC;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@StudentId", SqlDbType.UniqueIdentifier).Value = Guid.Parse(studentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptQuizResults.DataSource = dt;
                rptQuizResults.DataBind();
            }
        }

        private void LoadRevisionReminders(string studentId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Fetch quizzes where score was below passing mark
                string sql = @"
            SELECT DISTINCT 
                Q.Title AS QuizTitle,
                QA.Score,
                Q.PassingMarks
            FROM QuizAttempts QA
            INNER JOIN Quizzes Q ON QA.QuizId = Q.QuizId
            WHERE QA.StudentId = @StudentId 
              AND QA.IsCompleted = 1 
              AND QA.Score < Q.PassingMarks;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.AddWithValue("@StudentId", studentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    pnlRevisionReminder.Visible = true;
                    rptFailedQuizzes.DataSource = dt;
                    rptFailedQuizzes.DataBind();
                }
                else
                {
                    pnlRevisionReminder.Visible = false;
                }
            }
        }

        protected void FilterResults(object sender, EventArgs e)
        {
            if (Session["UserId"] != null)
            {
                string studentId = Session["UserId"].ToString();
                LoadTableResults(studentId);
            }
        }
    }
}