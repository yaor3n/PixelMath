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
    public partial class Student_Dashboard : System.Web.UI.Page
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
                string userId = Session["UserId"].ToString();

                // 1. Load Greeting Name
                LoadStudentGreeting(userId);

                // 2. Load Revision Box (if failed/low score)
                CheckNeedsRevisionAlert(userId);

                // 3. Load Unread Announcements Alert
                CheckUnreadAnnouncements(userId);

                // 4. Load Recent Quiz Attempt Card
                LoadRecentActivity(userId);
            }
        }

        // 1. Fetch Name from DB & Dynamic Time Greeting
        private void LoadStudentGreeting(string userId)
        {
            int hour = DateTime.Now.Hour;
            if (hour < 12)
                lblGreetingTime.Text = "Good morning,";
            else if (hour < 18)
                lblGreetingTime.Text = "Good afternoon,";
            else
                lblGreetingTime.Text = "Good evening,";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT FullName FROM Users WHERE UserId = @UserId;";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = Guid.Parse(userId);

                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    lblStudentName.Text = result.ToString();
                }
            }
        }

        // 2. Fetch Lowest/Failed Attempt to Suggest Revision
        private void CheckNeedsRevisionAlert(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT TOP 1 Q.Title, QA.Score
                    FROM QuizAttempts QA
                    INNER JOIN Quizzes Q ON QA.QuizId = Q.QuizId
                    WHERE QA.StudentId = @UserId 
                      AND QA.IsCompleted = 1 
                      AND QA.Score < Q.PassingMarks
                    ORDER BY QA.EndTime DESC;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = Guid.Parse(userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    pnlRevisionAlert.Visible = true;
                    lblRevisionQuizTitle.Text = reader["Title"].ToString();
                    lblRevisionScore.Text = reader["Score"].ToString();
                }
            }
        }

        // 3. Check for Unread Announcements
        private void CheckUnreadAnnouncements(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Query active announcements (Status = 1) for enrolled classes
                string sql = @"
                    SELECT COUNT(A.AnnouncementId) AS NoticeCount, MAX(A.Title) AS LatestTitle
                    FROM Announcements A
                    INNER JOIN StudentClasses SC ON A.ClassId = SC.ClassId
                    WHERE SC.StudentId = @UserId 
                      AND A.Status = 0;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = Guid.Parse(userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    int noticeCount = Convert.ToInt32(reader["NoticeCount"]);
                    if (noticeCount > 0)
                    {
                        pnlUnreadNotice.Visible = true;
                        lblNoticeCount.Text = noticeCount.ToString();
                        lblLatestNoticeTitle.Text = reader["LatestTitle"].ToString();
                    }
                    else
                    {
                        pnlUnreadNotice.Visible = false;
                    }
                }
            }
        }

        // 4. Load Last Quiz Attempt Data
        private void LoadRecentActivity(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT TOP 1 Q.Title, QA.Score, QA.EndTime, Q.PassingMarks
                    FROM QuizAttempts QA
                    INNER JOIN Quizzes Q ON QA.QuizId = Q.QuizId
                    WHERE QA.StudentId = @UserId AND QA.IsCompleted = 1
                    ORDER BY QA.EndTime DESC;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = Guid.Parse(userId);

                conn.Open();
                SqlDataReader reader = cmd.ExecuteReader();
                if (reader.Read())
                {
                    pnlRecentAttempt.Visible = true;
                    lblRecentQuizTitle.Text = reader["Title"].ToString();

                    int score = Convert.ToInt32(reader["Score"]);
                    int passingMarks = Convert.ToInt32(reader["PassingMarks"]);
                    lblRecentScore.Text = score.ToString();

                    if (reader["EndTime"] != DBNull.Value)
                    {
                        lblRecentDate.Text = Convert.ToDateTime(reader["EndTime"]).ToString("dd MMM yyyy, hh:mm tt");
                    }

                    if (score >= passingMarks)
                    {
                        lblRecentStatusText.Text = "Passed";
                        lblRecentStatusText.CssClass = "status-pass";
                    }
                    else
                    {
                        lblRecentStatusText.Text = "Needs Improvement";
                        lblRecentStatusText.CssClass = "status-fail";
                    }
                }
                else
                {
                    pnlRecentAttempt.Visible = false;
                }
            }
        }
    }
}