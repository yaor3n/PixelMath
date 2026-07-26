using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Lecturer_Manage_Quizzes : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLecturerClasses();
                LoadQuizzes();
            }
        }

        private void LoadLecturerClasses()
        {
            string lecturerId = Session["UserId"].ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT ClassId, ClassName FROM Classes WHERE CreatedBy = @CreatedBy ORDER BY ClassName";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CreatedBy", lecturerId);
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
            ddlFilterClass.Items.Insert(0, new ListItem("All Classes", ""));
        }

        private void LoadQuizzes(string searchKeyword = "", string classIdFilter = "")
        {
            string lecturerId = Session["UserId"].ToString();
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT q.QuizId, q.Title, q.DurationMinutes, q.PassingMarks, q.CreatedAt, c.ClassName 
                                 FROM Quizzes q
                                 JOIN Classes c ON q.ClassId = c.ClassId
                                 WHERE q.CreatedBy = @CreatedBy";

                if (!string.IsNullOrEmpty(searchKeyword))
                {
                    query += " AND q.Title LIKE @Search";
                }
                if (!string.IsNullOrEmpty(classIdFilter))
                {
                    query += " AND q.ClassId = @ClassId";
                }

                query += " ORDER BY q.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@CreatedBy", lecturerId);
                    if (!string.IsNullOrEmpty(searchKeyword))
                    {
                        cmd.Parameters.AddWithValue("@Search", "%" + searchKeyword + "%");
                    }
                    if (!string.IsNullOrEmpty(classIdFilter))
                    {
                        cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(classIdFilter));
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
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
                            rptQuizzes.DataSource = null;
                            rptQuizzes.DataBind();
                            rptQuizzes.Visible = false;
                            pnlNoQuizzes.Visible = true;
                        }
                    }
                }
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadQuizzes(txtSearch.Text.Trim(), ddlFilterClass.SelectedValue);
        }

        protected void ddlFilterClass_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadQuizzes(txtSearch.Text.Trim(), ddlFilterClass.SelectedValue);
        }

        protected void rptQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int quizId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "EditQuiz")
            {
                hfEditingQuizId.Value = quizId.ToString();
                LoadQuizDetails(quizId);
                LoadQuestions(quizId);

                // Switch panels
                pnlList.Visible = false;
                pnlEdit.Visible = true;
                pnlEditSingleQuestion.Visible = false;
            }
            else if (e.CommandName == "DeleteQuiz")
            {
                DeleteQuizAndRelatedData(quizId);
                LoadQuizzes(txtSearch.Text.Trim(), ddlFilterClass.SelectedValue);
                ShowAlert("Quiz deleted successfully.", "bg-emerald-50 text-emerald-700");
            }
        }

        private void DeleteQuizAndRelatedData(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string[] queries = {
                    "DELETE FROM StudentAnswers WHERE QuestionId IN (SELECT QuestionId FROM Questions WHERE QuizId = @QuizId)",
                    "DELETE FROM Options WHERE QuestionId IN (SELECT QuestionId FROM Questions WHERE QuizId = @QuizId)",
                    "DELETE FROM Questions WHERE QuizId = @QuizId",
                    "DELETE FROM QuizAttempts WHERE QuizId = @QuizId",
                    "DELETE FROM Quizzes WHERE QuizId = @QuizId"
                };

                foreach (string q in queries)
                {
                    using (SqlCommand cmd = new SqlCommand(q, conn))
                    {
                        cmd.Parameters.AddWithValue("@QuizId", quizId);
                        cmd.ExecuteNonQuery();
                    }
                }
            }
        }

        private void LoadQuizDetails(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Note: If PassingMarks is stored as points, you can calculate the stored percentage relative to total marks, 
                // or display it directly. Here we fetch the raw column value.
                string query = "SELECT Title, Description, DurationMinutes, PassingMarks FROM Quizzes WHERE QuizId = @QuizId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtQuizTitle.Text = reader["Title"].ToString();
                            txtQuizDesc.Text = reader["Description"].ToString();
                            txtDuration.Text = reader["DurationMinutes"].ToString();
                            txtPassingMarks.Text = reader["PassingMarks"].ToString();
                        }
                    }
                }
            }
        }

        private void LoadQuestions(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT QuestionId, QuestionText, QuestionType, Marks FROM Questions WHERE QuizId = @QuizId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        rptQuestions.DataSource = reader;
                        rptQuestions.DataBind();
                    }
                }
            }
        }

        protected void btnUpdateQuiz_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(hfEditingQuizId.Value, out int quizId))
            {
                ShowAlert("Invalid quiz reference.", "bg-rose-50 text-rose-700");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtQuizTitle.Text))
            {
                ShowAlert("Quiz title cannot be empty.", "bg-rose-50 text-rose-700");
                return;
            }

            if (!int.TryParse(txtDuration.Text, out int duration) || duration <= 0)
            {
                ShowAlert("Duration must be a valid number greater than 0 minutes.", "bg-rose-50 text-rose-700");
                return;
            }

            // ── Guard Rail: Prevent negative passing percentages ──
            if (!int.TryParse(txtPassingMarks.Text, out int passingPercentage) || passingPercentage < 0 || passingPercentage > 100)
            {
                ShowAlert("Passing percentage must be between 0 and 100 (negative values are not allowed).", "bg-rose-50 text-rose-700");
                return;
            }

            // Calculate total marks available from existing questions in this quiz
            int totalQuizMarks = 0;
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(Marks), 0) FROM Questions WHERE QuizId = @QuizId", conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    totalQuizMarks = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }

            if (totalQuizMarks <= 0)
            {
                ShowAlert("This quiz has no questions or total marks equal to zero. Please add questions with positive marks first.", "bg-rose-50 text-rose-700");
                return;
            }

            // Convert passing percentage into actual passing score points
            int finalPassingMarks = (int)Math.Round((double)totalQuizMarks * passingPercentage / 100.0, MidpointRounding.AwayFromZero);

            // ── Guard Rail: Ensure passing threshold does not exceed total marks ──
            if (finalPassingMarks > totalQuizMarks)
            {
                ShowAlert("Passing mark threshold cannot exceed the total available question marks.", "bg-rose-50 text-rose-700");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "UPDATE Quizzes SET Title = @Title, Description = @Description, DurationMinutes = @Duration, PassingMarks = @PassingMarks WHERE QuizId = @QuizId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Title", txtQuizTitle.Text.Trim());
                    cmd.Parameters.AddWithValue("@Description", txtQuizDesc.Text.Trim());
                    cmd.Parameters.AddWithValue("@Duration", duration);
                    cmd.Parameters.AddWithValue("@PassingMarks", finalPassingMarks);
                    cmd.Parameters.AddWithValue("@QuizId", quizId);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }

            ShowAlert("Quiz details updated successfully!", "bg-emerald-50 text-emerald-700");
            LoadQuizzes(txtSearch.Text.Trim(), ddlFilterClass.SelectedValue);
        }

        protected void rptQuestions_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "EditQ")
            {
                int questionId = Convert.ToInt32(e.CommandArgument);
                hfSelectedQuestionId.Value = questionId.ToString();
                LoadSingleQuestionData(questionId);
                pnlEditSingleQuestion.Visible = true;
            }
        }

        private void LoadSingleQuestionData(int questionId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string qQuery = "SELECT QuestionText, Marks FROM Questions WHERE QuestionId = @QuestionId";
                using (SqlCommand cmd = new SqlCommand(qQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@QuestionId", questionId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtEditQText.Text = reader["QuestionText"].ToString();
                            txtEditMarks.Text = reader["Marks"].ToString();
                        }
                    }
                }

                string optQuery = "SELECT OptionId, OptionText, IsCorrect FROM Options WHERE QuestionId = @QuestionId";
                using (SqlCommand cmd = new SqlCommand(optQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@QuestionId", questionId);
                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptOptions.DataSource = dt;
                        rptOptions.DataBind();
                    }
                }
            }
        }

        protected void btnSaveQuestion_Click(object sender, EventArgs e)
        {
            if (!int.TryParse(hfSelectedQuestionId.Value, out int questionId) || !int.TryParse(hfEditingQuizId.Value, out int quizId))
            {
                ShowAlert("Invalid reference IDs.", "bg-rose-50 text-rose-700");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtEditQText.Text))
            {
                ShowAlert("Question text cannot be empty.", "bg-rose-50 text-rose-700");
                return;
            }

            // ── Guard Rail: Prevent negative or zero question marks ──
            if (!int.TryParse(txtEditMarks.Text.Trim(), out int newMarks) || newMarks <= 0)
            {
                ShowAlert("Question marks must be a positive integer greater than 0 (negative values are not allowed).", "bg-rose-50 text-rose-700");
                return;
            }

            int currentQuizPassingMarks = 0;
            int otherQuestionsMarksSum = 0;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // Fetch current passing mark threshold for this quiz
                using (SqlCommand cmd = new SqlCommand("SELECT PassingMarks FROM Quizzes WHERE QuizId = @QuizId", conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    var res = cmd.ExecuteScalar();
                    if (res != null) currentQuizPassingMarks = Convert.ToInt32(res);
                }

                // Sum marks of all OTHER questions in this quiz
                using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(Marks), 0) FROM Questions WHERE QuizId = @QuizId AND QuestionId != @QuestionId", conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    cmd.Parameters.AddWithValue("@QuestionId", questionId);
                    otherQuestionsMarksSum = Convert.ToInt32(cmd.ExecuteScalar());
                }
            }

            int prospectiveTotalMarks = otherQuestionsMarksSum + newMarks;

            // ── Guard Rail: Ensure prospective total question marks don't drop below passing threshold ──
            if (currentQuizPassingMarks > prospectiveTotalMarks)
            {
                ShowAlert($"⚠️ Cannot update marks. The new total question marks ({prospectiveTotalMarks}) would drop below the quiz passing threshold ({currentQuizPassingMarks}). Please lower the passing requirement or increase question points.", "bg-rose-50 text-rose-700");
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();
                string updateQ = "UPDATE Questions SET QuestionText = @QText, Marks = @Marks WHERE QuestionId = @QId";
                using (SqlCommand cmd = new SqlCommand(updateQ, conn))
                {
                    cmd.Parameters.AddWithValue("@QText", txtEditQText.Text.Trim());
                    cmd.Parameters.AddWithValue("@Marks", newMarks);
                    cmd.Parameters.AddWithValue("@QId", questionId);
                    cmd.ExecuteNonQuery();
                }

                foreach (RepeaterItem item in rptOptions.Items)
                {
                    if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                    {
                        HiddenField hfOptionId = (HiddenField)item.FindControl("hfOptionId");
                        TextBox txtOptionText = (TextBox)item.FindControl("txtOptionText");
                        CheckBox chkIsCorrect = (CheckBox)item.FindControl("chkIsCorrect");

                        if (hfOptionId != null && txtOptionText != null && chkIsCorrect != null)
                        {
                            int optionId = Convert.ToInt32(hfOptionId.Value);
                            string optText = txtOptionText.Text.Trim();
                            bool isCorrect = chkIsCorrect.Checked;

                            string updateOpt = "UPDATE Options SET OptionText = @OptText, IsCorrect = @IsCorrect WHERE OptionId = @OptId";
                            using (SqlCommand cmdOpt = new SqlCommand(updateOpt, conn))
                            {
                                cmdOpt.Parameters.AddWithValue("@OptText", optText);
                                cmdOpt.Parameters.AddWithValue("@IsCorrect", isCorrect);
                                cmdOpt.Parameters.AddWithValue("@OptId", optionId);
                                cmdOpt.ExecuteNonQuery();
                            }
                        }
                    }
                }
            }

            LoadQuestions(quizId);
            pnlEditSingleQuestion.Visible = false;
            ShowAlert("Question and options updated successfully!", "bg-emerald-50 text-emerald-700");
        }

        protected void btnCancelEditQuestion_Click(object sender, EventArgs e)
        {
            pnlEditSingleQuestion.Visible = false;
        }

        protected void btnBackToList_Click(object sender, EventArgs e)
        {
            pnlEdit.Visible = false;
            pnlList.Visible = true;
            LoadQuizzes(txtSearch.Text.Trim(), ddlFilterClass.SelectedValue);
        }

        private void ShowAlert(string message, string cssClass)
        {
            litAlertMessage.Text = message;
            pnlAlert.CssClass = "mb-6 p-4 rounded-2xl text-xs font-bold shadow-xs " + cssClass;
            pnlAlert.Visible = true;
        }
    }
}