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
        }

        private void LoadAllQuizzes()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT QuizId, Title, DurationMinutes, PassingMarks FROM Quizzes";
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

        // 🎯 STAGE A: USER SELECTS A QUIZ CARD
        protected void repeatQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "SelectQuiz")
            {
                int quizId = Convert.ToInt32(e.CommandArgument);
                ViewState["CurrentQuizId"] = quizId;

                // Load preview metadata inside the Landing view panel element
                LoadQuizMetaData(quizId);

                // Open landing menu and close list
                QuizListPanel.Visible = false;
                QuizLandingPanel.Visible = true;
                ActiveQuizPanel.Visible = false;
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
                            ActiveQuizTitleLabel.Text = reader["Title"].ToString(); // Set header title for later
                            LandingDurationLabel.Text = reader["DurationMinutes"].ToString();
                            LandingPassMarkLabel.Text = reader["PassingMarks"].ToString();
                        }
                    }
                }
            }
        }

        // 🎯 STAGE B: USER CLICKS "START QUIZ NOW" ON LANDING PAGE
        protected void btnStartQuiz_Click(object sender, EventArgs e)
        {
            if (ViewState["CurrentQuizId"] != null)
            {
                int quizId = (int)ViewState["CurrentQuizId"];

                // Fetch layout question items right here upon initialization confirmation
                LoadQuizQuestions(quizId);

                // Switch visible staging view panel layouts
                QuizListPanel.Visible = false;
                QuizLandingPanel.Visible = false;
                ActiveQuizPanel.Visible = true;
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

        protected void RepeatQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfQuestionId = (HiddenField)e.Item.FindControl("QuestionIdHiddenField");
                RadioButtonList rblOptions = (RadioButtonList)e.Item.FindControl("OptionsButton");

                if (hfQuestionId != null && rblOptions != null)
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

        protected void btnBack_Click(object sender, EventArgs e)
        {
            QuizListPanel.Visible = true;
            QuizLandingPanel.Visible = false;
            ActiveQuizPanel.Visible = false;
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            QuizListPanel.Visible = true;
            QuizLandingPanel.Visible = false;
            ActiveQuizPanel.Visible = false;
        }
    }
}