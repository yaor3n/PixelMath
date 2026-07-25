using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Lecturer_Marking : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["PixelMathConnStr"]?.ConnectionString
            ?? ConfigurationManager.ConnectionStrings["PixelMathDB"]?.ConnectionString
            ?? @"Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=PixelMath;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authenticate Lecturer Role (RoleId = 2)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLecturerQuizzes();
            }
        }

        private void LoadLecturerQuizzes()
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT QuizId, Title FROM Quizzes WHERE CreatedBy = @LecturerId ORDER BY CreatedAt DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    conn.Open();
                    SqlDataReader reader = cmd.ExecuteReader();

                    ddlQuizzes.Items.Clear();
                    ddlQuizzes.Items.Add(new ListItem("-- Select Quiz to Grade --", ""));

                    while (reader.Read())
                    {
                        ddlQuizzes.Items.Add(new ListItem(reader["Title"].ToString(), reader["QuizId"].ToString()));
                    }
                }
            }
        }

        protected void ddlQuizzes_SelectedIndexChanged(object sender, EventArgs e)
        {
            pnlGradingArea.Visible = false;
            if (string.IsNullOrEmpty(ddlQuizzes.SelectedValue))
            {
                pnlAttempts.Visible = false;
                return;
            }

            LoadPendingAttempts(Convert.ToInt32(ddlQuizzes.SelectedValue));
        }

        private void LoadPendingAttempts(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Fetch attempts that have pending subjective reviews (IsGraded = 0 or answers unmarked)
                string query = @"
                    SELECT DISTINCT qa.AttemptId, u.FullName AS StudentName, qa.EndTime
                    FROM QuizAttempts qa
                    JOIN Users u ON qa.StudentId = u.UserId
                    JOIN StudentAnswers sa ON qa.AttemptId = sa.AttemptId
                    JOIN Questions qu ON sa.QuestionId = qu.QuestionId
                    WHERE qa.QuizId = @QuizId 
                      AND qu.QuestionType = 'Subjective'
                      AND qa.IsCompleted = 1
                      AND (sa.IsMarked = 0 OR sa.IsMarked IS NULL)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    pnlAttempts.Visible = true;
                    rptAttempts.DataSource = dt;
                    rptAttempts.DataBind();

                    lblNoAttempts.Visible = (dt.Rows.Count == 0);
                }
            }
        }

        protected void rptAttempts_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "GradeAttempt")
            {
                int attemptId = Convert.ToInt32(e.CommandArgument);
                ViewState["CurrentAttemptId"] = attemptId;
                LoadSubjectiveAnswersForGrading(attemptId);
            }
        }

        private void LoadSubjectiveAnswersForGrading(int attemptId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT sa.AnswerId, qu.QuestionText, qu.Marks AS MaxMarks, sa.AnswerText, sa.MarksAwarded, sa.LecturerFeedback
                    FROM StudentAnswers sa
                    JOIN Questions qu ON sa.QuestionId = qu.QuestionId
                    WHERE sa.AttemptId = @AttemptId AND qu.QuestionType = 'Subjective'";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AttemptId", attemptId);
                    conn.Open();
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        pnlGradingArea.Visible = true;
                        rptAnswers.DataSource = dt;
                        rptAnswers.DataBind();

                        // Get student name for header
                        string studentQuery = "SELECT u.FullName FROM QuizAttempts qa JOIN Users u ON qa.StudentId = u.UserId WHERE qa.AttemptId = @AttemptId";
                        using (SqlCommand nameCmd = new SqlCommand(studentQuery, conn))
                        {
                            nameCmd.Parameters.AddWithValue("@AttemptId", attemptId);
                            litStudentName.Text = nameCmd.ExecuteScalar()?.ToString() ?? "Student";
                        }
                    }
                    else
                    {
                        ShowAlert("⚠️ No subjective answers found for this submission.", false);
                    }
                }
            }
        }

        protected void btnSubmitGrades_Click(object sender, EventArgs e)
        {
            if (ViewState["CurrentAttemptId"] == null) return;
            int attemptId = Convert.ToInt32(ViewState["CurrentAttemptId"]);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    conn.Open();

                    foreach (RepeaterItem item in rptAnswers.Items)
                    {
                        if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                        {
                            HiddenField hfAnswerId = (HiddenField)item.FindControl("hfAnswerId");
                            TextBox txtMarksAwarded = (TextBox)item.FindControl("txtMarksAwarded");
                            TextBox txtFeedback = (TextBox)item.FindControl("txtFeedback");

                            int answerId = Convert.ToInt32(hfAnswerId.Value);
                            int marksAwarded = string.IsNullOrEmpty(txtMarksAwarded.Text) ? 0 : Convert.ToInt32(txtMarksAwarded.Text);
                            string feedback = txtFeedback.Text.Trim();

                            // Update individual answer score and feedback
                            string updateAnsSql = @"
                                UPDATE StudentAnswers 
                                SET MarksAwarded = @MarksAwarded, 
                                    LecturerFeedback = @Feedback, 
                                    IsMarked = 1 
                                WHERE AnswerId = @AnswerId";

                            using (SqlCommand cmd = new SqlCommand(updateAnsSql, conn))
                            {
                                cmd.Parameters.AddWithValue("@MarksAwarded", marksAwarded);
                                cmd.Parameters.AddWithValue("@Feedback", string.IsNullOrEmpty(feedback) ? (object)DBNull.Value : feedback);
                                cmd.Parameters.AddWithValue("@AnswerId", answerId);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }

                    // Recalculate total score for the attempt (Objective + Subjective marks)
                    string recalcSql = @"
                        UPDATE QuizAttempts 
                        SET Score = (SELECT ISNULL(SUM(MarksAwarded), 0) FROM StudentAnswers WHERE AttemptId = @AttemptId),
                            IsGraded = 1
                        WHERE AttemptId = @AttemptId";

                    using (SqlCommand recalcCmd = new SqlCommand(recalcSql, conn))
                    {
                        recalcCmd.Parameters.AddWithValue("@AttemptId", attemptId);
                        recalcCmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("🎉 Grades and feedback submitted successfully!", true);
                pnlGradingArea.Visible = false;

                // Refresh list
                if (ddlQuizzes.SelectedValue != "")
                {
                    LoadPendingAttempts(Convert.ToInt32(ddlQuizzes.SelectedValue));
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error saving grades: " + ex.Message, false);
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/Lecturer-Dashboard.aspx");
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isSuccess
                ? "mb-6 p-4 rounded-2xl text-xs font-bold bg-emerald-50 text-emerald-800 border border-emerald-200"
                : "mb-6 p-4 rounded-2xl text-xs font-bold bg-rose-50 text-rose-800 border border-rose-200";
            litAlertMessage.Text = msg;
        }
    }
}