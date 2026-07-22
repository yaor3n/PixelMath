using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PixelMath
{
    public partial class Lecturer_Dashboard : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["PixelMathConnStr"]?.ConnectionString
            ?? @"Data Source=(LocalDB)\MSSQLLocalDB;AttachDbFilename=|DataDirectory|\PixelMath.mdf;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // 1. Check if Session exists
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // 2. Parse Guid safely (handles string, object, or Guid types seamlessly)
                Guid lecturerId;
                if (!Guid.TryParse(Session["UserId"].ToString(), out lecturerId))
                {
                    // Session UserId is invalid or corrupted, redirect to login
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                SetGreeting();
                string name = Session["FullName"] != null ? Session["FullName"].ToString() : "Lecturer";
                litLecturerName.Text = name;
                litSidebarLecturerName.Text = name;

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

        private void FetchCounts(Guid lecturerId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1. Pending Markings: Completed attempts for quizzes created by lecturer where IsGraded = 0
                string sqlPending = @"
                    SELECT COUNT(DISTINCT qa.AttemptId)
                    FROM QuizAttempts qa
                    INNER JOIN Quizzes q ON qa.QuizId = q.QuizId
                    WHERE q.CreatedBy = @LecturerId 
                      AND qa.IsCompleted = 1 
                      AND qa.IsGraded = 0";

                using (SqlCommand cmd = new SqlCommand(sqlPending, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    string count = cmd.ExecuteScalar()?.ToString() ?? "0";
                    litPendingCount.Text = count;
                    litBannerPendingCount.Text = count;
                }

                // 2. Unread Announcements: Status = 0 in classes created by lecturer
                string sqlUnread = @"
                    SELECT COUNT(*) 
                    FROM Announcements a
                    INNER JOIN Classes c ON a.ClassId = c.ClassId
                    WHERE c.CreatedBy = @LecturerId AND a.Status = 0";

                using (SqlCommand cmd = new SqlCommand(sqlUnread, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    litUnreadAnnouncements.Text = cmd.ExecuteScalar()?.ToString() ?? "0";
                }

                // 3. Classes Taught by this lecturer
                string sqlClasses = "SELECT COUNT(*) FROM Classes WHERE CreatedBy = @LecturerId";
                using (SqlCommand cmd = new SqlCommand(sqlClasses, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
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
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
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
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
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
            Response.Redirect("~/Login.aspx");
        }
    }
}