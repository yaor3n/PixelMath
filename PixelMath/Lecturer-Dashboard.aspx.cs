using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Lecturer_Dashboard : Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Check if Session exists (matching student pattern)
            if (Session["UserId"] == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string userId = Session["UserId"].ToString();

                SetGreeting();

                // Load Name and Data using explicit UniqueIdentifier parameters
                LoadLecturerGreeting(userId);

                Guid lecturerId = Guid.Parse(userId);
                FetchCounts(lecturerId);
                FetchPendingSubmissions(lecturerId);
                FetchRecentQuizzes(lecturerId);
            }
        }

        private void SetGreeting()
        {
            int hour = DateTime.Now.Hour;
            if (hour < 12) litTimeGreeting.Text = "Good morning,";
            else if (hour < 18) litTimeGreeting.Text = "Good afternoon,";
            else litTimeGreeting.Text = "Good evening,";
        }

        private void LoadLecturerGreeting(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = "SELECT FullName FROM Users WHERE UserId = @UserId;";
                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = Guid.Parse(userId);

                conn.Open();
                object result = cmd.ExecuteScalar();
                if (result != null)
                {
                    string name = result.ToString();
                    litLecturerName.Text = name;
                }
                else
                {
                    litLecturerName.Text = "Lecturer";
                }
            }
        }

        private void FetchCounts(Guid lecturerId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. Pending Markings
                string sqlPending = @"
                    SELECT COUNT(DISTINCT qa.AttemptId)
                    FROM QuizAttempts qa
                    INNER JOIN Quizzes q ON qa.QuizId = q.QuizId
                    WHERE q.CreatedBy = @LecturerId 
                      AND qa.IsCompleted = 1 
                      AND qa.IsGraded = 0";

                using (SqlCommand cmd = new SqlCommand(sqlPending, conn))
                {
                    cmd.Parameters.Add("@LecturerId", SqlDbType.UniqueIdentifier).Value = lecturerId;
                    string count = cmd.ExecuteScalar()?.ToString() ?? "0";
                    litPendingCount.Text = count;
                    litBannerPendingCount.Text = count;
                }

                // 2. Classes Taught
                string sqlClasses = "SELECT COUNT(*) FROM Classes WHERE CreatedBy = @LecturerId";
                using (SqlCommand cmd = new SqlCommand(sqlClasses, conn))
                {
                    cmd.Parameters.Add("@LecturerId", SqlDbType.UniqueIdentifier).Value = lecturerId;
                    litClassCount.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
                }
            }
        }

        private void FetchPendingSubmissions(Guid lecturerId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT TOP 5 
                        qa.AttemptId, 
                        u.FullName, 
                        q.Title AS QuizTitle, 
                        qa.EndTime
                    FROM QuizAttempts qa
                    INNER JOIN Quizzes q ON qa.QuizId = q.QuizId
                    INNER JOIN Users u ON qa.StudentId = u.UserId
                    WHERE q.CreatedBy = @LecturerId 
                      AND qa.IsCompleted = 1 
                      AND qa.IsGraded = 0
                    ORDER BY qa.EndTime DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.Add("@LecturerId", SqlDbType.UniqueIdentifier).Value = lecturerId;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptPendingAttempts.DataSource = dt;
                        rptPendingAttempts.DataBind();
                        pnlNoPending.Visible = false;
                    }
                    else
                    {
                        pnlNoPending.Visible = true;
                    }
                }
            }
        }

        private void FetchRecentQuizzes(Guid lecturerId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT TOP 5 
                        q.QuizId, 
                        q.Title, 
                        q.DurationMinutes, 
                        q.PassingMarks, 
                        c.ClassName
                    FROM Quizzes q
                    INNER JOIN Classes c ON q.ClassId = c.ClassId
                    WHERE q.CreatedBy = @LecturerId
                    ORDER BY q.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.Add("@LecturerId", SqlDbType.UniqueIdentifier).Value = lecturerId;
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptRecentQuizzes.DataSource = dt;
                        rptRecentQuizzes.DataBind();
                        pnlNoQuizzes.Visible = false;
                    }
                    else
                    {
                        pnlNoQuizzes.Visible = true;
                    }
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("LoginPage.aspx");
        }
    }
}