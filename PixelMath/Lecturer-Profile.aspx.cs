using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Security.Cryptography;
using System.Text;

namespace PixelMath
{
    public partial class Lecturer_Profile : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["PixelMathSQL"]?.ConnectionString
                                               ?? ConfigurationManager.ConnectionStrings["PixelMath"]?.ConnectionString
                                               ?? ConfigurationManager.ConnectionStrings["PixelMathConnStr"]?.ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"]?.ToString() != "2")
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLecturerProfile();
                LoadLecturerStatistics();
            }
        }

        private void LoadLecturerProfile()
        {
            try
            {
                Guid lecturerId = Guid.Parse(Session["UserId"].ToString());
                string query = "SELECT FullName, Email, CreatedAt FROM Users WHERE UserId = @LecturerId";

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                TextFullName.Text = reader["FullName"]?.ToString() ?? "";
                                TextEmail.Text = reader["Email"]?.ToString() ?? "";
                                TextDepartment.Text = "General Mathematics";

                                if (reader["CreatedAt"] != DBNull.Value)
                                {
                                    TextJoinedDate.Text = Convert.ToDateTime(reader["CreatedAt"]).ToString("MMMM dd, yyyy");
                                }
                                else
                                {
                                    TextJoinedDate.Text = "N/A";
                                }

                                ProfileBadge.Text = "Lecturer";
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading profile details: " + ex.Message, true);
            }
        }

        private void LoadLecturerStatistics()
        {
            try
            {
                Guid lecturerId = Guid.Parse(Session["UserId"].ToString());

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    // 1. Total Classes
                    string qClasses = "SELECT COUNT(1) FROM Classes WHERE CreatedBy = @LecturerId";
                    using (SqlCommand cmd = new SqlCommand(qClasses, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                        int totalClasses = Convert.ToInt32(cmd.ExecuteScalar() ?? 0);
                        lblTotalClasses.Text = totalClasses.ToString();
                    }

                    // 2. Active Quizzes
                    string qQuizzes = "SELECT COUNT(1) FROM Quizzes WHERE CreatedBy = @LecturerId";
                    using (SqlCommand cmd = new SqlCommand(qQuizzes, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                        int activeQuizzes = Convert.ToInt32(cmd.ExecuteScalar() ?? 0);
                        lblActiveQuizzes.Text = activeQuizzes.ToString();
                    }

                    // 3. Pending Marking
                    string qPending = @"
                        SELECT COUNT(DISTINCT qa.AttemptId) 
                        FROM QuizAttempts qa
                        INNER JOIN Quizzes q ON qa.QuizId = q.QuizId
                        WHERE q.CreatedBy = @LecturerId AND qa.IsGraded = 0 AND qa.IsCompleted = 1";
                    using (SqlCommand cmd = new SqlCommand(qPending, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                        int pendingMarking = Convert.ToInt32(cmd.ExecuteScalar() ?? 0);
                        lblPendingMarking.Text = pendingMarking.ToString();
                    }

                    // 4. Total Students
                    string qStudents = @"
                        SELECT COUNT(DISTINCT sc.StudentId) 
                        FROM StudentClasses sc
                        INNER JOIN Classes c ON sc.ClassId = c.ClassId
                        WHERE c.CreatedBy = @LecturerId";
                    using (SqlCommand cmd = new SqlCommand(qStudents, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                        int totalStudents = Convert.ToInt32(cmd.ExecuteScalar() ?? 0);
                        lblTotalStudents.Text = totalStudents.ToString();
                    }

                    // 5. Average Passing Rate
                    string qPassRate = @"
                        SELECT 
                            ISNULL(
                                (SUM(CASE WHEN qa.Score >= q.PassingMarks THEN 1.0 ELSE 0.0 END) / NULLIF(COUNT(qa.AttemptId), 0)) * 100, 
                                0
                            ) AS PassRate
                        FROM QuizAttempts qa
                        INNER JOIN Quizzes q ON qa.QuizId = q.QuizId
                        WHERE q.CreatedBy = @LecturerId AND qa.IsCompleted = 1";
                    using (SqlCommand cmd = new SqlCommand(qPassRate, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                        object result = cmd.ExecuteScalar();
                        double passRate = result != DBNull.Value && result != null ? Convert.ToDouble(result) : 0.0;

                        int roundedRate = (int)Math.Round(passRate);
                        lblAvgPassRate.Text = roundedRate + "%";
                        pnlPassProgressBar.Style["width"] = roundedRate + "%";
                    }
                }
            }
            catch (Exception)
            {
                // Suppress metrics exception to avoid crashing profile load
            }
        }

        protected void BtnEditPassword_Click(object sender, EventArgs e)
        {
            PanelPasswordInput.Visible = true;
            BtnEditPassword.Visible = false;
            BtnCancelPassword.Visible = true;
            BtnSavePassword.Visible = true;
            LblMessage.Text = "";
            pnlAlert.Visible = false;
        }

        protected void BtnSavePassword_Click(object sender, EventArgs e)
        {
            string email = TextVerifyEmail.Text.Trim();
            string newPass = TextNewPassword.Text;
            string confirmPass = TextConfirmPassword.Text;
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(newPass) || string.IsNullOrEmpty(confirmPass))
            {
                SetPasswordMessage("Please fill in all password fields.", true);
                return;
            }

            if (newPass != confirmPass)
            {
                SetPasswordMessage("Passwords do not match.", true);
                return;
            }

            string hashedPassword = ComputeSha256Hash(newPass);

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();

                    string checkQuery = "SELECT Email FROM Users WHERE UserId = @UserId";
                    using (SqlCommand cmdCheck = new SqlCommand(checkQuery, conn))
                    {
                        cmdCheck.Parameters.AddWithValue("@UserId", lecturerId);
                        string dbEmail = cmdCheck.ExecuteScalar()?.ToString();

                        if (!string.Equals(dbEmail, email, StringComparison.OrdinalIgnoreCase))
                        {
                            SetPasswordMessage("Verified email does not match your account email.", true);
                            return;
                        }
                    }

                    string updateQuery = "UPDATE Users SET PasswordHash = @PasswordHash WHERE UserId = @UserId";
                    using (SqlCommand cmdUpdate = new SqlCommand(updateQuery, conn))
                    {
                        cmdUpdate.Parameters.AddWithValue("@PasswordHash", hashedPassword);
                        cmdUpdate.Parameters.AddWithValue("@UserId", lecturerId);
                        cmdUpdate.ExecuteNonQuery();
                    }
                }

                BtnCancelPassword_Click(sender, e);
                ClientScript.RegisterStartupScript(this.GetType(), "ShowModal", "showSuccessModal();", true);
            }
            catch (Exception ex)
            {
                SetPasswordMessage("Error updating password: " + ex.Message, true);
            }
        }

        protected void BtnCancelPassword_Click(object sender, EventArgs e)
        {
            PanelPasswordInput.Visible = false;
            BtnEditPassword.Visible = true;
            BtnCancelPassword.Visible = false;
            BtnSavePassword.Visible = false;
            TextVerifyEmail.Text = "";
            TextNewPassword.Text = "";
            TextConfirmPassword.Text = "";
            LblMessage.Text = "";
            pnlAlert.Visible = false;
        }

        private void ShowAlert(string message, bool isError)
        {
            pnlAlert.Visible = true;
            litAlertMessage.Text = message;
            pnlAlert.CssClass = isError
                ? "mb-6 p-4 rounded-2xl text-xs font-bold bg-rose-50 text-rose-700 border border-rose-100"
                : "mb-6 p-4 rounded-2xl text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-100";
        }

        private void SetPasswordMessage(string message, bool isError)
        {
            LblMessage.Text = message;
            LblMessage.CssClass = isError
                ? "text-xs font-bold text-rose-600"
                : "text-xs font-bold text-emerald-600";
        }

        private string ComputeSha256Hash(string rawData)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(rawData));

                StringBuilder builder = new StringBuilder();
                foreach (byte t in bytes)
                {
                    builder.Append(t.ToString("x2"));
                }

                return builder.ToString();
            }
        }
    }
}