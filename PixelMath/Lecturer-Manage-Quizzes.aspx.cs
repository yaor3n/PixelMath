using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Lecturer_Manage_Quizzes : Page
    {
        private string connStr => ConfigurationManager.ConnectionStrings["PixelMathConnStr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Session guard: Ensure only logged-in lecturers can access this page
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Session["FullName"] != null)
                {
                    litSidebarLecturerName.Text = Session["FullName"].ToString();
                }

                LoadClassFilter();
                LoadQuizzes();
            }
        }

        private void LoadClassFilter()
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT ClassId, ClassName FROM Classes WHERE CreatedBy = @LecturerId ORDER BY ClassName ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlFilterClass.DataSource = reader;
                        ddlFilterClass.DataTextField = "ClassName";
                        ddlFilterClass.DataValueField = "ClassId";
                        ddlFilterClass.DataBind();
                    }
                }
            }

            ddlFilterClass.Items.Insert(0, new ListItem("All Classes", "0"));
        }

        private void LoadQuizzes()
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());
            string searchTerm = txtSearch.Text.Trim();
            int selectedClassId = Convert.ToInt32(ddlFilterClass.SelectedValue);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT Q.QuizId, Q.Title, Q.DurationMinutes, Q.PassingMarks, Q.CreatedAt, C.ClassName 
                    FROM Quizzes Q
                    INNER JOIN Classes C ON Q.ClassId = C.ClassId
                    WHERE Q.CreatedBy = @LecturerId";

                if (selectedClassId > 0)
                {
                    query += " AND Q.ClassId = @ClassId";
                }

                if (!string.IsNullOrEmpty(searchTerm))
                {
                    query += " AND Q.Title LIKE @SearchTerm";
                }

                query += " ORDER BY Q.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);

                    if (selectedClassId > 0)
                    {
                        cmd.Parameters.AddWithValue("@ClassId", selectedClassId);
                    }

                    if (!string.IsNullOrEmpty(searchTerm))
                    {
                        cmd.Parameters.AddWithValue("@SearchTerm", "%" + searchTerm + "%");
                    }

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptQuizzes.DataSource = dt;
                        rptQuizzes.DataBind();
                        rptQuizzes.Visible = true;
                        pnlNoQuizzes.Visible = false;
                    }
                    else
                    {
                        rptQuizzes.Visible = false;
                        pnlNoQuizzes.Visible = true;
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadQuizzes();
        }

        protected void ddlFilterClass_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQuizzes();
        }

        protected void rptQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "DeleteQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                DeleteQuiz(quizId);
            }
        }

        private void DeleteQuiz(int quizId)
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "DELETE FROM Quizzes WHERE QuizId = @QuizId AND CreatedBy = @LecturerId";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);

                        conn.Open();
                        int rowsAffected = cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowAlert("Quiz deleted successfully.", true);
                        }
                        else
                        {
                            ShowAlert("Unable to delete quiz or quiz not found.", false);
                        }
                    }
                }

                LoadQuizzes();
            }
            catch (Exception ex)
            {
                ShowAlert("Error deleting quiz: " + ex.Message, false);
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/LoginPage.aspx");
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            litAlertMessage.Text = msg;

            if (isSuccess)
            {
                pnlAlert.CssClass = "mb-6 p-4 rounded-2xl text-xs font-bold bg-emerald-50 text-emerald-800 border border-emerald-200";
            }
            else
            {
                pnlAlert.CssClass = "mb-6 p-4 rounded-2xl text-xs font-bold bg-rose-50 text-rose-800 border border-rose-200";
            }
        }
    }
}