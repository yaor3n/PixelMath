using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Student_Quiz : System.Web.UI.Page
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
                LoadAllQuizzes();
            }
            else if (ActiveQuizPanel.Visible)
            {
                // Keeps the JavaScript timer running smoothly during postback state refreshes
                ScriptManager.RegisterStartupScript(this, this.GetType(), "KeepTimerAlive", "initializeFrontendTimer();", true);
            }
        }

        private void LoadAllQuizzes()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"SELECT q.QuizId, q.Title, q.DurationMinutes, q.PassingMarks, 
                                ISNULL(MAX(quest.QuestionType), 'Objective') as QuestionType 
                                FROM Quizzes q 
                                LEFT JOIN Questions quest ON q.QuizId = quest.QuizId 
                                GROUP BY q.QuizId, q.Title, q.DurationMinutes, q.PassingMarks";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        RepeatQuizzes.DataSource = dt;
                        RepeatQuizzes.DataBind();
                    }
                }
            }
        }

        protected void repeatQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                ViewState["CurrentQuizId"] = quizId;

                LoadQuizMetaData(quizId);

                QuizListPanel.Visible = false;
                QuizLandingPanel.Visible = true;
                ActiveQuizPanel.Visible = false;
                QuizResultPanel.Visible = false;
            }
        }

        private void LoadQuizMetaData(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT Title, DurationMinutes, PassingMarks FROM Quizzes WHERE QuizId = @QuizId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    conn.Open();
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            LandingTitleLabel.Text = reader["Title"].ToString();
                            ActiveQuizTitleLabel.Text = reader["Title"].ToString();
                            LandingDurationLabel.Text = reader["DurationMinutes"].ToString();
                            LandingPassMarkLabel.Text = reader["PassingMarks"].ToString();

                            // Synchronize the full layout tracking seconds metrics to the hidden inputs
                            int totalSeconds = Convert.ToInt32(reader["DurationMinutes"]) * 60;
                            TotalDurationSecondsHidden.Value = totalSeconds.ToString();
                            SecondsRemainingHidden.Value = totalSeconds.ToString();
                        }
                    }
                }
            }
        }

        protected void btnStartQuiz_Click(object sender, EventArgs e)
        {
            if (ViewState["CurrentQuizId"] != null)
            {
                int quizId = (int)ViewState["CurrentQuizId"];
                LoadQuizQuestions(quizId);

                QuizListPanel.Visible = false;
                QuizLandingPanel.Visible = false;
                ActiveQuizPanel.Visible = true;
                QuizResultPanel.Visible = false;

                // Fires the client-side countdown clock pipeline immediately
                ScriptManager.RegisterStartupScript(this, this.GetType(), "StartQuizTimer", "initializeFrontendTimer();", true);
            }
        }

        private void LoadQuizQuestions(int quizId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT QuestionId, QuestionText, QuestionType FROM Questions WHERE QuizId = @QuizId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);
                        RepeatQuestions.DataSource = dt;
                        RepeatQuestions.DataBind();
                    }
                }
            }
        }

        // Binds multiple-choice options dynamically to every individual question block row
        protected void RepeatQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfQuestionId = (HiddenField)e.Item.FindControl("QuestionIdHiddenField");
                HiddenField hfQuestionType = (HiddenField)e.Item.FindControl("QuestionTypeHiddenField");

                PlaceHolder plcObjective = (PlaceHolder)e.Item.FindControl("ObjectivePlaceHolder");
                PlaceHolder plcSubjective = (PlaceHolder)e.Item.FindControl("SubjectivePlaceHolder");

                if (hfQuestionId != null && hfQuestionType != null)
                {
                    string qType = hfQuestionType.Value;

                    if (qType.Equals("Subjective", StringComparison.OrdinalIgnoreCase))
                    {
                        // 🎯 Show the text area form element layout field
                        plcSubjective.Visible = true;
                    }
                    else
                    {
                        // 🎯 Show multiple choice form configuration elements
                        plcObjective.Visible = true;
                        RadioButtonList rblOptions = (RadioButtonList)e.Item.FindControl("OptionsButton");

                        if (rblOptions != null)
                        {
                            int questionId = Convert.ToInt32(hfQuestionId.Value);

                            using (SqlConnection conn = new SqlConnection(connStr))
                            {
                                string query = "SELECT OptionId, OptionText FROM Options WHERE QuestionId = @QuestionId";
                                using (SqlCommand cmd = new SqlCommand(query, conn))
                                {
                                    cmd.Parameters.AddWithValue("@QuestionId", questionId);
                                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                                    {
                                        DataTable dt = new DataTable();
                                        sda.Fill(dt);
                                        rblOptions.DataSource = dt;
                                        rblOptions.DataBind();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            int totalQuestions = 0;
            int correctAnswers = 0;
            bool hasSubjective = false;

            int quizId = ViewState["CurrentQuizId"] != null ? (int)ViewState["CurrentQuizId"] : 0;
            string studentId = Session["UserId"].ToString();
            DateTime endTime = DateTime.Now;

            int totalDuration = Convert.ToInt32(TotalDurationSecondsHidden.Value);
            int remaining = Convert.ToInt32(SecondsRemainingHidden.Value);
            int timeTakenSeconds = totalDuration - remaining;
            DateTime startTime = endTime.AddSeconds(-timeTakenSeconds);

            // Track detailed rows in memory to save cleanly after summary generation is completed
            System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>> answerDataList =
                new System.Collections.Generic.List<System.Collections.Generic.Dictionary<string, object>>();

            foreach (RepeaterItem item in RepeatQuestions.Items)
            {
                if (item.ItemType == ListItemType.Item || item.ItemType == ListItemType.AlternatingItem)
                {
                    totalQuestions++;
                    HiddenField hfQuestionId = (HiddenField)item.FindControl("QuestionIdHiddenField");
                    HiddenField hfQuestionType = (HiddenField)item.FindControl("QuestionTypeHiddenField");

                    int questionId = Convert.ToInt32(hfQuestionId.Value);
                    string qType = hfQuestionType.Value;

                    var rowData = new System.Collections.Generic.Dictionary<string, object>();
                    rowData["QuestionId"] = questionId;
                    rowData["QuestionType"] = qType;
                    rowData["SelectedOptionId"] = DBNull.Value;
                    rowData["AnswerText"] = DBNull.Value;
                    rowData["IsMarked"] = 0;

                    if (qType.Equals("Subjective", StringComparison.OrdinalIgnoreCase))
                    {
                        hasSubjective = true;
                        TextBox txtSub = (TextBox)item.FindControl("TextBoxSubjectiveAnswer");
                        if (txtSub != null && !string.IsNullOrWhiteSpace(txtSub.Text))
                        {
                            rowData["AnswerText"] = txtSub.Text.Trim();
                        }
                    }
                    else
                    {
                        RadioButtonList rblOptions = (RadioButtonList)item.FindControl("OptionsButton");
                        if (rblOptions != null && !string.IsNullOrEmpty(rblOptions.SelectedValue))
                        {
                            int selectedOptionId = Convert.ToInt32(rblOptions.SelectedValue);
                            rowData["SelectedOptionId"] = selectedOptionId;
                            rowData["IsMarked"] = 1; // Evaluated immediately

                            using (SqlConnection conn = new SqlConnection(connStr))
                            {
                                string query = "SELECT IsCorrect FROM Options WHERE OptionId = @OptionId";
                                using (SqlCommand cmd = new SqlCommand(query, conn))
                                {
                                    cmd.Parameters.AddWithValue("@OptionId", selectedOptionId);
                                    conn.Open();
                                    object result = cmd.ExecuteScalar();
                                    conn.Close();

                                    if (result != null && Convert.ToBoolean(result))
                                    {
                                        correctAnswers++;
                                    }
                                }
                            }
                        }
                    }
                    answerDataList.Add(rowData);
                }
            }

            int finalScorePercent = totalQuestions > 0 ? (correctAnswers * 100) / totalQuestions : 0;
            int insertedAttemptId = 0;

            // 🎯 IF it contains subjective elements, it cannot be fully graded instantly (IsGraded = 0)
            int isGradedFlag = hasSubjective ? 0 : 1;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Added @IsGraded parameter matching your altered table design mapping pipeline
                string queryAttempt = @"INSERT INTO QuizAttempts (QuizId, StudentId, StartTime, EndTime, TimeTakenSeconds, Score, IsCompleted, IsGraded) 
                                VALUES (@QuizId, @StudentId, @StartTime, @EndTime, @TimeTakenSeconds, @Score, @IsCompleted, @IsGraded);
                                SELECT SCOPE_IDENTITY();";

                using (SqlCommand cmd = new SqlCommand(queryAttempt, conn))
                {
                    cmd.Parameters.AddWithValue("@QuizId", quizId);
                    cmd.Parameters.AddWithValue("@StudentId", studentId);
                    cmd.Parameters.AddWithValue("@StartTime", startTime);
                    cmd.Parameters.AddWithValue("@EndTime", endTime);
                    cmd.Parameters.AddWithValue("@TimeTakenSeconds", timeTakenSeconds);
                    cmd.Parameters.AddWithValue("@Score", finalScorePercent);
                    cmd.Parameters.AddWithValue("@IsCompleted", 1);
                    cmd.Parameters.AddWithValue("@IsGraded", isGradedFlag);

                    conn.Open();
                    object scalarResult = cmd.ExecuteScalar();
                    if (scalarResult != null)
                    {
                        insertedAttemptId = Convert.ToInt32(scalarResult);
                    }
                    conn.Close();
                }
            }

            if (insertedAttemptId > 0)
            {
                foreach (var data in answerDataList)
                {
                    using (SqlConnection conn = new SqlConnection(connStr))
                    {
                        string queryAnswer = @"INSERT INTO StudentAnswers (AttemptId, QuestionId, SelectedOptionId, AnswerText, IsMarked) 
                                        VALUES (@AttemptId, @QuestionId, @SelectedOptionId, @AnswerText, @IsMarked)";

                        using (SqlCommand cmd = new SqlCommand(queryAnswer, conn))
                        {
                            cmd.Parameters.AddWithValue("@AttemptId", insertedAttemptId);
                            cmd.Parameters.AddWithValue("@QuestionId", data["QuestionId"]);
                            cmd.Parameters.AddWithValue("@SelectedOptionId", data["SelectedOptionId"]);
                            cmd.Parameters.AddWithValue("@AnswerText", data["AnswerText"]);
                            cmd.Parameters.AddWithValue("@IsMarked", data["IsMarked"]);

                            conn.Open();
                            cmd.ExecuteNonQuery();
                            conn.Close();
                        }
                    }
                }
            }

            // Adjust visibility updates for the confirmation layout page
            if (hasSubjective)
            {
                FinalScore.Text = "Pending Lecturer Review";
            }
            else
            {
                FinalScore.Text = string.Format("{0} / {1} ({2}%)", correctAnswers, totalQuestions, finalScorePercent);
            }

            int finalMins = timeTakenSeconds / 60;
            int finalSecs = timeTakenSeconds % 60;
            TimeUsed.Text = string.Format("{0} min {1} sec", finalMins, finalSecs);

            QuizListPanel.Visible = false;
            QuizLandingPanel.Visible = false;
            ActiveQuizPanel.Visible = false;
            QuizResultPanel.Visible = true;
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            LoadAllQuizzes();
            QuizListPanel.Visible = true;
            QuizLandingPanel.Visible = false;
            ActiveQuizPanel.Visible = false;
            QuizResultPanel.Visible = false;
        }
    }
}