using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Lecturer_View_Attempts : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["PixelMathSQL"]?.ConnectionString
                                             ?? ConfigurationManager.ConnectionStrings["PixelMath"]?.ConnectionString
                                             ?? ConfigurationManager.ConnectionStrings["PixelMathConnStr"]?.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"]?.ToString() != "2")
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLecturerQuizzesDropdown();
                LoadStudentAttempts();
            }
        }

        private void LoadLecturerQuizzesDropdown()
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());
            string query = "SELECT QuizId, Title FROM Quizzes WHERE CreatedBy = @LecturerId ORDER BY Title ASC";

            using (SqlConnection conn = new SqlConnection(connString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        ddlFilterQuiz.DataSource = dt;
                        ddlFilterQuiz.DataTextField = "Title";
                        ddlFilterQuiz.DataValueField = "QuizId";
                        ddlFilterQuiz.DataBind();

                        ddlFilterQuiz.Items.Insert(0, new ListItem("-- All Quizzes --", "0"));
                    }
                }
            }
        }

        private void LoadStudentAttempts()
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());
            string searchTerm = txtSearch.Text.Trim();
            string selectedQuizId = ddlFilterQuiz.SelectedValue;

            // By explicitly adding GETDATE() AS StartTime, we guarantee the column exists in the DataTable
            string query = @"
        SELECT 
            qa.AttemptId, 
            qa.QuizId, 
            qa.StudentId, 
            ISNULL(qa.Score, 0) AS Score, 
            ISNULL(qa.IsCompleted, 1) AS IsCompleted, 
            ISNULL(qa.IsGraded, 0) AS IsGraded, 
            GETDATE() AS StartTime, 
            q.Title AS QuizTitle, 
            u.FullName AS StudentName,
            q.PassingMarks
        FROM QuizAttempts qa
        INNER JOIN Quizzes q ON qa.QuizId = q.QuizId
        INNER JOIN Users u ON qa.StudentId = u.UserId
        WHERE q.CreatedBy = @LecturerId";

            if (!string.IsNullOrEmpty(searchTerm))
            {
                query += " AND (u.FullName LIKE @Search OR q.Title LIKE @Search)";
            }

            if (selectedQuizId != "0" && !string.IsNullOrEmpty(selectedQuizId))
            {
                query += " AND q.QuizId = @QuizId";
            }

            query += " ORDER BY qa.AttemptId DESC";

            using (SqlConnection conn = new SqlConnection(connString))
            {
                try
                {
                    conn.Open();
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);

                        if (!string.IsNullOrEmpty(searchTerm))
                        {
                            cmd.Parameters.AddWithValue("@Search", "%" + searchTerm + "%");
                        }

                        if (selectedQuizId != "0" && !string.IsNullOrEmpty(selectedQuizId))
                        {
                            cmd.Parameters.AddWithValue("@QuizId", int.Parse(selectedQuizId));
                        }

                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);

                            if (dt.Rows.Count > 0)
                            {
                                rptAttempts.DataSource = dt;
                                rptAttempts.DataBind();
                                rptAttempts.Visible = true;
                                pnlNoAttempts.Visible = false;
                            }
                            else
                            {
                                rptAttempts.Visible = false;
                                pnlNoAttempts.Visible = true;
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    ShowAlert("Error loading student attempts: " + ex.Message, true);
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadStudentAttempts();
        }

        protected void ddlFilterQuiz_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadStudentAttempts();
        }

        private void ShowAlert(string message, bool isError)
        {
            pnlAlert.Visible = true;
            litAlertMessage.Text = message;
            pnlAlert.CssClass = isError
                ? "mb-6 p-4 rounded-2xl text-xs font-bold bg-rose-50 text-rose-700 border border-rose-100"
                : "mb-6 p-4 rounded-2xl text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-100";
        }
    }
}