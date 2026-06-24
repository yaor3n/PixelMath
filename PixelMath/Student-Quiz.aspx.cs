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
                LoadStudentQuizzes();
            }
        }

        private void LoadStudentQuizzes()
        {
            string activeUserId = Session["UserId"].ToString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT 
                        Q.QuizId, 
                        Q.Title, 
                        Q.Description, 
                        Q.DurationMinutes, 
                        Q.PassingMarks,
                        U.Form,
                        (SELECT COUNT(*) FROM Questions WHERE Questions.QuizId = Q.QuizId) AS QuestionCount,
                        (SELECT TOP 1 QuestionType FROM Questions WHERE Questions.QuizId = Q.QuizId) AS QuestionType
                    FROM [Quizzes] Q
                    INNER JOIN [StudentClasses] SC ON Q.ClassId = SC.ClassId
                    INNER JOIN [Users] U ON SC.StudentId = U.UserId
                    WHERE SC.StudentId = @StudentId";

                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.Add("@StudentId", System.Data.SqlDbType.UniqueIdentifier).Value = new Guid(activeUserId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                try
                {
                    con.Open();
                    da.Fill(dt);

                    repeatQuizzes.DataSource = dt;
                    repeatQuizzes.DataBind();
                }
                catch (Exception ex)
                {
                    System.Diagnostics.Debug.WriteLine("Error loading quizzes: " + ex.Message);
                }
            }
        }

        protected void repeatQuizzes_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "StartQuiz")
            {
                string targetQuizId = e.CommandArgument.ToString();

                Session["ActiveQuizId"] = targetQuizId;

                Response.Redirect("QuizRunner.aspx");
            }
        }
    }
}