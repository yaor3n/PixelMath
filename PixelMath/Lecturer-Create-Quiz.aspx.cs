using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace PixelMath
{
    public partial class Lecturer_Create_Quiz : System.Web.UI.Page
    {
        private readonly string ConnStr = ConfigurationManager.ConnectionStrings["PixelMathConnStr"]?.ConnectionString
            ?? ConfigurationManager.ConnectionStrings["PixelMathDB"]?.ConnectionString
            ?? ConfigurationManager.ConnectionStrings["PixelMathDb"]?.ConnectionString
            ?? @"Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=PixelMath;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // ⚠️ CRITICAL FIX: Force the Master Page's form to accept file uploads
            // Note: If your form ID in the Master Page is not "form1", change it below!
            System.Web.UI.HtmlControls.HtmlForm form = (System.Web.UI.HtmlControls.HtmlForm)Master.FindControl("form1");
            if (form != null)
            {
                form.Enctype = "multipart/form-data";
            }

            if (Session["UserId"] == null || !Guid.TryParse(Session["UserId"].ToString(), out Guid lecturerId))
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadClasses(lecturerId);
            }
        }

        private void LoadClasses(Guid lecturerId)
        {
            using (var conn = new SqlConnection(ConnStr))
            using (var cmd = new SqlCommand(@"
                SELECT ClassId, ClassName FROM Classes
                WHERE CreatedBy = @LecturerId
                ORDER BY ClassName", conn))
            {
                cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                conn.Open();

                var dt = new DataTable();
                using (var reader = cmd.ExecuteReader())
                {
                    dt.Load(reader);
                }

                ddlClass.DataSource = dt;
                ddlClass.DataTextField = "ClassName";
                ddlClass.DataValueField = "ClassId";
                ddlClass.DataBind();

                if (dt.Rows.Count == 0)
                {
                    ddlClass.Items.Insert(0, new System.Web.UI.WebControls.ListItem("No classes found — create a class first", ""));
                }
            }
        }

        protected void btnSaveQuiz_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || !Guid.TryParse(Session["UserId"].ToString(), out Guid lecturerId))
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            // ── Server-side validation ──
            if (string.IsNullOrWhiteSpace(txtQuizTitle.Text))
            {
                ShowAlert("Quiz title is required.", false);
                return;
            }

            if (ddlClass.SelectedValue == "" || !int.TryParse(ddlClass.SelectedValue, out int classId))
            {
                ShowAlert("Please select a valid class.", false);
                return;
            }

            if (!int.TryParse(txtDuration.Text, out int duration) || duration <= 0)
            {
                ShowAlert("Please enter a valid duration.", false);
                return;
            }

            if (!int.TryParse(txtPassingMarks.Text, out int passingMarks) || passingMarks < 0 || passingMarks > 100)
            {
                ShowAlert("Passing marks must be between 0 and 100.", false);
                return;
            }

            List<QuestionDto> questions;
            try
            {
                var serializer = new JavaScriptSerializer();
                questions = serializer.Deserialize<List<QuestionDto>>(hfQuestionsJson.Value);
            }
            catch
            {
                ShowAlert("Something went wrong reading your questions. Please try again.", false);
                return;
            }

            if (questions == null || questions.Count == 0)
            {
                ShowAlert("Please add at least one question.", false);
                return;
            }

            foreach (var q in questions)
            {
                if (string.IsNullOrWhiteSpace(q.text))
                {
                    ShowAlert("One or more questions has empty text.", false);
                    return;
                }
                if (q.marks <= 0) q.marks = 1;

                if (q.type == "Objective")
                {
                    if (q.options == null || q.options.Count != 4 || q.options.Any(o => string.IsNullOrWhiteSpace(o)))
                    {
                        ShowAlert("Every objective question needs 4 filled options.", false);
                        return;
                    }
                    if (q.correctIndex < 0 || q.correctIndex > 3)
                    {
                        ShowAlert("Every objective question needs a correct answer selected.", false);
                        return;
                    }
                }
            }

            // ── Insert Quiz → Questions → Options in one transaction ──
            using (var conn = new SqlConnection(ConnStr))
            {
                conn.Open();
                using (var tran = conn.BeginTransaction())
                {
                    try
                    {
                        int quizId;

                        using (var cmd = new SqlCommand(@"
                            INSERT INTO Quizzes (Title, Description, ClassId, CreatedBy, DurationMinutes, PassingMarks)
                            OUTPUT INSERTED.QuizId
                            VALUES (@Title, @Description, @ClassId, @CreatedBy, @Duration, @PassingMarks)", conn, tran))
                        {
                            cmd.Parameters.AddWithValue("@Title", txtQuizTitle.Text.Trim());
                            cmd.Parameters.AddWithValue("@Description", string.IsNullOrWhiteSpace(txtDescription.Text) ? (object)DBNull.Value : txtDescription.Text.Trim());
                            cmd.Parameters.AddWithValue("@ClassId", classId);
                            cmd.Parameters.AddWithValue("@CreatedBy", lecturerId);
                            cmd.Parameters.AddWithValue("@Duration", duration);
                            cmd.Parameters.AddWithValue("@PassingMarks", passingMarks);

                            quizId = (int)cmd.ExecuteScalar();
                        }

                        foreach (var q in questions)
                        {
                            // Handle file upload per question if present
                            string questionImageUrl = null;
                            if (!string.IsNullOrEmpty(q.fileInputName) && Request.Files[q.fileInputName] != null)
                            {
                                HttpPostedFile postedFile = Request.Files[q.fileInputName];
                                if (postedFile.ContentLength > 0)
                                {
                                    string extension = Path.GetExtension(postedFile.FileName).ToLower();
                                    string[] allowedExtensions = { ".png", ".jpg", ".jpeg" };

                                    if (Array.IndexOf(allowedExtensions, extension) >= 0)
                                    {
                                        // Ensure ~/Uploads/questionimg/ folder exists
                                        string folderPath = Server.MapPath("~/Uploads/questionimg/");
                                        if (!Directory.Exists(folderPath))
                                        {
                                            Directory.CreateDirectory(folderPath);
                                        }

                                        string uniqueFileName = Guid.NewGuid().ToString() + extension;
                                        string savePath = Path.Combine(folderPath, uniqueFileName);
                                        postedFile.SaveAs(savePath);

                                        questionImageUrl = "~/Uploads/questionimg/" + uniqueFileName;
                                    }
                                }
                            }

                            int questionId;

                            using (var cmd = new SqlCommand(@"
                                INSERT INTO Questions (QuizId, QuestionText, QuestionType, QuestionImageUrl, Marks)
                                OUTPUT INSERTED.QuestionId
                                VALUES (@QuizId, @QuestionText, @QuestionType, @QuestionImageUrl, @Marks)", conn, tran))
                            {
                                cmd.Parameters.AddWithValue("@QuizId", quizId);
                                cmd.Parameters.AddWithValue("@QuestionText", q.text.Trim());
                                cmd.Parameters.AddWithValue("@QuestionType", q.type);
                                cmd.Parameters.AddWithValue("@QuestionImageUrl",
                                    string.IsNullOrEmpty(questionImageUrl) ? (object)DBNull.Value : questionImageUrl);
                                cmd.Parameters.AddWithValue("@Marks", q.marks);

                                questionId = (int)cmd.ExecuteScalar();
                            }

                            if (q.type == "Objective")
                            {
                                for (int i = 0; i < q.options.Count; i++)
                                {
                                    using (var cmd = new SqlCommand(@"
                                        INSERT INTO Options (QuestionId, OptionText, IsCorrect)
                                        VALUES (@QuestionId, @OptionText, @IsCorrect)", conn, tran))
                                    {
                                        cmd.Parameters.AddWithValue("@QuestionId", questionId);
                                        cmd.Parameters.AddWithValue("@OptionText", q.options[i].Trim());
                                        cmd.Parameters.AddWithValue("@IsCorrect", i == q.correctIndex);
                                        cmd.ExecuteNonQuery();
                                    }
                                }
                            }
                        }

                        tran.Commit();
                        Response.Redirect("~/Lecturer-Manage-Quizzes.aspx?created=1");
                    }
                    catch (Exception ex)
                    {
                        tran.Rollback();
                        ShowAlert("Failed to save quiz: " + ex.Message, false);
                    }
                }
            }
        }

        private void ShowAlert(string message, bool success)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = "mb-6 p-4 rounded-2xl text-xs font-bold " +
                (success ? "bg-emerald-50 text-emerald-700 border border-emerald-200"
                         : "bg-rose-50 text-rose-700 border border-rose-200");
            litAlertMessage.Text = message;
        }

        private class QuestionDto
        {
            public string type { get; set; }
            public string text { get; set; }
            public int marks { get; set; }
            public string fileInputName { get; set; }
            public List<string> options { get; set; }
            public int correctIndex { get; set; }
        }
    }
}