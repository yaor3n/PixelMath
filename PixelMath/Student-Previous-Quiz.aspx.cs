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
    public partial class Student_Previous_Quiz : System.Web.UI.Page
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
                LoadPreviousQuizzes();
            }
        }

        private void LoadPreviousQuizzes()
        {
            string studentId = Session["UserId"].ToString();

            string query = @"
                SELECT 
                    qa.AttemptId,
                    q.Title AS QuizTitle,
                    CASE 
                        WHEN qa.IsGraded = 0 THEN 0 
                        ELSE qa.Score 
                    END AS Score,
                    q.PassingMarks,
                    qa.EndTime,
                    qa.IsGraded
                FROM QuizAttempts qa
                INNER JOIN Quizzes q ON qa.QuizId = q.QuizId
                WHERE qa.StudentId = @StudentId AND qa.IsCompleted = 1
                ORDER BY qa.EndTime DESC";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@StudentId", SqlDbType.UniqueIdentifier).Value = new Guid(studentId);

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            repeatPreviousQuizzes.DataSource = dt;
                            repeatPreviousQuizzes.DataBind();
                            panelNoHistory.Visible = false;
                        }
                        else
                        {
                            panelNoHistory.Visible = true;
                        }
                    }
                }
            }
        }

        public string GetStatusBadgeClass(object isGradedObj, object scoreObj, object passingMarksObj)
        {
            bool isGraded = isGradedObj != DBNull.Value && Convert.ToBoolean(isGradedObj);
            if (!isGraded) return "badge badge-pending";

            int score = scoreObj != DBNull.Value ? Convert.ToInt32(scoreObj) : 0;
            int passingMarks = passingMarksObj != DBNull.Value ? Convert.ToInt32(passingMarksObj) : 0;

            return score >= passingMarks ? "badge badge-passed" : "badge badge-failed";
        }

        public string GetStatusText(object isGradedObj, object scoreObj, object passingMarksObj)
        {
            bool isGraded = isGradedObj != DBNull.Value && Convert.ToBoolean(isGradedObj);

            if (!isGraded) return "Pending Marking";

            int score = scoreObj != DBNull.Value ? Convert.ToInt32(scoreObj) : 0;
            int passingMarks = passingMarksObj != DBNull.Value ? Convert.ToInt32(passingMarksObj) : 0;

            return score >= passingMarks ? "Passed" : "Failed";
        }

    }
}