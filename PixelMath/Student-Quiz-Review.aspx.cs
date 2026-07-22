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
    public partial class Student_Quiz_Review : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["attemptId"] != null && int.TryParse(Request.QueryString["attemptId"], out int attemptId))
                {
                    LoadQuizAttemptSummary(attemptId);
                    LoadQuestionsAndAnswers(attemptId);
                }
                else
                {
                    Response.Redirect("Student-Previous-Quiz.aspx");
                }
            }
        }

        private void LoadQuizAttemptSummary(int attemptId)
        {
            string studentId = Session["UserId"].ToString();

            string query = @"
                SELECT 
                    q.Title,
                    qa.Score,
                    q.PassingMarks,
                    qa.EndTime,
                    qa.IsGraded
                FROM QuizAttempts qa
                INNER JOIN Quizzes q ON qa.QuizId = q.QuizId
                WHERE qa.AttemptId = @AttemptId AND qa.StudentId = @StudentId";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AttemptId", attemptId);
                    cmd.Parameters.Add("@StudentId", SqlDbType.UniqueIdentifier).Value = new Guid(studentId);

                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            lblQuizTitle.Text = reader["Title"].ToString();

                            if (reader["EndTime"] != DBNull.Value)
                            {
                                DateTime endTime = Convert.ToDateTime(reader["EndTime"]);
                                lblSubmittedDate.Text = endTime.ToString("dd MMM yyyy, h:mm tt");
                            }

                            bool isGraded = reader["IsGraded"] != DBNull.Value && Convert.ToBoolean(reader["IsGraded"]);
                            int actualScore = Convert.ToInt32(reader["Score"]);

                            // 🎯 Show 0 % while pending lecturer marking
                            if (!isGraded)
                            {
                                lblScore.Text = "0";
                                lblStatusBadge.Text = "⏳ Pending Marking";
                                lblStatusBadge.CssClass = "badge badge-pending";
                            }
                            else
                            {
                                lblScore.Text = actualScore.ToString();
                                int passingMarks = Convert.ToInt32(reader["PassingMarks"]);

                                if (actualScore >= passingMarks)
                                {
                                    lblStatusBadge.Text = "Passed";
                                    lblStatusBadge.CssClass = "badge badge-passed";
                                }
                                else
                                {
                                    lblStatusBadge.Text = "Failed";
                                    lblStatusBadge.CssClass = "badge badge-failed";
                                }
                            }
                        } // 👈 Added missing closing brace for if(reader.Read())
                    }
                }
            }
        }

        private void LoadQuestionsAndAnswers(int attemptId)
        {
            string query = @"
                SELECT 
                    q.QuestionId,
                    q.QuestionText,
                    q.QuestionType,
                    sa.SelectedOptionId,
                    sa.AnswerText,
                    sa.LecturerFeedback
                FROM Questions q
                INNER JOIN QuizAttempts qa ON q.QuizId = qa.QuizId
                LEFT JOIN StudentAnswers sa ON q.QuestionId = sa.QuestionId AND sa.AttemptId = @AttemptId
                WHERE qa.AttemptId = @AttemptId";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@AttemptId", attemptId);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        repeatQuestions.DataSource = dt;
                        repeatQuestions.DataBind();
                    }
                }
            }
        }

        protected void repeatQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                string questionType = row["QuestionType"].ToString();

                if (questionType == "Objective")
                {
                    int questionId = Convert.ToInt32(row["QuestionId"]);
                    int selectedOptionId = row["SelectedOptionId"] != DBNull.Value ? Convert.ToInt32(row["SelectedOptionId"]) : 0;

                    Repeater repeatOptions = (Repeater)e.Item.FindControl("repeatOptions");
                    if (repeatOptions != null)
                    {
                        repeatOptions.DataSource = GetOptionsForQuestion(questionId, selectedOptionId);
                        repeatOptions.DataBind();
                    }
                }
            }
        }

        private DataTable GetOptionsForQuestion(int questionId, int selectedOptionId)
        {
            string query = @"
                SELECT 
                    OptionId,
                    OptionText,
                    IsCorrect,
                    CASE WHEN OptionId = @SelectedOptionId THEN 1 ELSE 0 END AS IsSelected
                FROM Options
                WHERE QuestionId = @QuestionId";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuestionId", questionId);
                    cmd.Parameters.AddWithValue("@SelectedOptionId", selectedOptionId);

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        return dt;
                    }
                }
            }
        }

        public string GetOptionStyleClass(object isCorrectObj, object isSelectedObj)
        {
            bool isCorrect = isCorrectObj != DBNull.Value && Convert.ToBoolean(isCorrectObj);
            bool isSelected = isSelectedObj != DBNull.Value && Convert.ToInt32(isSelectedObj) == 1;

            if (isCorrect) return "option-item option-correct"; // Green highlight for correct choice
            if (isSelected && !isCorrect) return "option-item option-wrong"; // Red highlight for wrong pick

            return "option-item";
        }
    }
}