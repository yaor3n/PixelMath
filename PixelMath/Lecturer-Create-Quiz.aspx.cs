using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.Script.Serialization;
using System.Web.UI;

namespace PixelMath
{
    public partial class Lecturer_Create_Quiz : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["PixelMathConnStr"]?.ConnectionString
            ?? ConfigurationManager.ConnectionStrings["PixelMathDB"]?.ConnectionString
            ?? @"Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=PixelMath;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authenticate Lecturer Session (RoleId = 2)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string name = Session["FullName"] != null ? Session["FullName"].ToString() : "Lecturer";
                litSidebarLecturerName.Text = name;

                Guid lecturerId;
                if (Guid.TryParse(Session["UserId"].ToString(), out lecturerId))
                {
                    LoadClassesDropdown(lecturerId);
                }
            }
        }

        private void LoadClassesDropdown(Guid lecturerId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT ClassId, ClassName FROM Classes WHERE CreatedBy = @LecturerId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    ddlClass.DataSource = reader;
                    ddlClass.DataTextField = "ClassName";
                    ddlClass.DataValueField = "ClassId";
                    ddlClass.DataBind();
                }
            }
        }

        protected void btnSaveQuiz_Click(object sender, EventArgs e)
        {
            Guid lecturerId;
            if (!Guid.TryParse(Session["UserId"].ToString(), out lecturerId))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string title = txtQuizTitle.Text.Trim();
            string json = hfQuestionsJson.Value;

            if (string.IsNullOrEmpty(title) || ddlClass.SelectedValue == "" || string.IsNullOrEmpty(json))
            {
                ShowAlert("Please fill in all general quiz details and questions.", false);
                return;
            }

            int duration = int.TryParse(txtDuration.Text, out duration) ? duration : 30;
            int passingMarks = int.TryParse(txtPassingMarks.Text, out passingMarks) ? passingMarks : 50;
            Guid classId = Guid.Parse(ddlClass.SelectedValue);

            JavaScriptSerializer serializer = new JavaScriptSerializer();
            List<QuestionDTO> questions = serializer.Deserialize<List<QuestionDTO>>(json);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();

                try
                {
                    // 1. Insert Quiz Record
                    Guid quizId = Guid.NewGuid();
                    string insertQuizSql = @"
                        INSERT INTO Quizzes (QuizId, ClassId, Title, DurationMinutes, PassingMarks, CreatedBy, CreatedAt)
                        VALUES (@QuizId, @ClassId, @Title, @Duration, @PassingMarks, @CreatedBy, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertQuizSql, conn, trans))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.Parameters.AddWithValue("@ClassId", classId);
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Duration", duration);
                        cmd.Parameters.AddWithValue("@PassingMarks", passingMarks);
                        cmd.Parameters.AddWithValue("@CreatedBy", lecturerId);
                        cmd.ExecuteNonQuery();
                    }

                    // 2. Loop & Insert Questions and Options
                    foreach (var q in questions)
                    {
                        Guid questionId = Guid.NewGuid();
                        string insertQSql = @"
                            INSERT INTO Questions (QuestionId, QuizId, QuestionText)
                            VALUES (@QuestionId, @QuizId, @QuestionText)";

                        using (SqlCommand cmd = new SqlCommand(insertQSql, conn, trans))
                        {
                            cmd.Parameters.AddWithValue("@QuestionId", questionId);
                            cmd.Parameters.AddWithValue("@QuizId", quizId);
                            cmd.Parameters.AddWithValue("@QuestionText", q.text);
                            cmd.ExecuteNonQuery();
                        }

                        // Insert 4 Options
                        for (int i = 0; i < q.options.Count; i++)
                        {
                            string insertOptSql = @"
                                INSERT INTO QuestionOptions (OptionId, QuestionId, OptionText, IsCorrect)
                                VALUES (NEWID(), @QuestionId, @OptionText, @IsCorrect)";

                            using (SqlCommand cmd = new SqlCommand(insertOptSql, conn, trans))
                            {
                                cmd.Parameters.AddWithValue("@QuestionId", questionId);
                                cmd.Parameters.AddWithValue("@OptionText", q.options[i]);
                                cmd.Parameters.AddWithValue("@IsCorrect", i == q.correctIndex ? 1 : 0);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }

                    trans.Commit();
                    ShowAlert("🎉 Quiz published successfully!", true);
                    Response.Redirect("~/Lecturer-Dashboard.aspx");
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    ShowAlert("Database Error: " + ex.Message, false);
                }
            }
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isSuccess
                ? "mb-6 p-4 rounded-2xl text-xs font-bold bg-emerald-50 text-emerald-800 border border-emerald-200"
                : "mb-6 p-4 rounded-2xl text-xs font-bold bg-rose-50 text-rose-800 border border-rose-200";
            litAlertMessage.Text = msg;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }

        // Helper Data Transport Class
        public class QuestionDTO
        {
            public string text { get; set; }
            public List<string> options { get; set; }
            public int correctIndex { get; set; }
        }
    }
}