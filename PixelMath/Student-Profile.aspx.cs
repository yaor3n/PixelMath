using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace PixelMath
{
    public partial class Student_Profile : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                return;
            }

            if (!IsPostBack)
            {
                LoadStudentProfile();
            }
        }

        private void LoadStudentProfile()
        {
            string activeUserId = Session["UserId"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT FullName, Email, Form, CreatedAt FROM Users WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@UserId", System.Data.SqlDbType.UniqueIdentifier).Value = new Guid(activeUserId);

                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                TextFullName.Text = reader["FullName"].ToString();
                                TextEmail.Text = reader["Email"].ToString();

                                string formValue = reader["Form"].ToString();
                                TextFormLevel.Text = !string.IsNullOrEmpty(formValue) ? "Form " + formValue : "Not Specified";

                                if (reader["CreatedAt"] != DBNull.Value)
                                {
                                    DateTime joinedDate = Convert.ToDateTime(reader["CreatedAt"]);
                                    TextJoinedDate.Text = joinedDate.ToString("dd MMM yyyy");
                                }
                                else
                                {
                                    TextJoinedDate.Text = "N/A";
                                }

                                ProfileBadge.Text = "Role: Student";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Error loading profile: " + ex.Message + "');</script>");
                    }
                }
            }
        }

        protected void BtnEditPassword_Click(object sender, EventArgs e)
        {
            PanelPasswordInput.Visible = true;
            TextVerifyEmail.Text = "";
            TextNewPassword.Text = "";
            TextConfirmPassword.Text = "";

            BtnEditPassword.Visible = false;
            BtnCancelPassword.Visible = true;
            BtnSavePassword.Visible = true;
        }

        protected void BtnCancelPassword_Click(object sender, EventArgs e)
        {
            ResetPasswordUI();
        }

        protected void BtnSavePassword_Click(object sender, EventArgs e)
        {
            string verifyEmailInput = TextVerifyEmail.Text.Trim();
            string newPasswordText = TextNewPassword.Text.Trim();
            string confirmPasswordText = TextConfirmPassword.Text.Trim();

            if (string.IsNullOrEmpty(verifyEmailInput) || string.IsNullOrEmpty(newPasswordText) || string.IsNullOrEmpty(confirmPasswordText))
            {
                Response.Write("<script>alert('Please fill in all verification and password fields.');</script>");
                return;
            }

            if (newPasswordText != confirmPasswordText)
            {
                Response.Write("<script>alert('New passwords do not match.');</script>");
                return;
            }

            if (newPasswordText.Length < 8)
            {
                Response.Write("<script>alert('New password must be at least 8 characters.');</script>");
                return;
            }

            string activeUserId = Session["UserId"].ToString();

            // Generate Perfect Hash Using Sign-Up Logic 
            string matchingNewHash = ComputeSha256Hash(newPasswordText);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string updateQuery = @"
                    IF EXISTS (SELECT 1 FROM Users WHERE UserId = @UserId AND LOWER(Email) = LOWER(@VerifyEmail))
                    BEGIN
                        UPDATE Users SET PasswordHash = @PasswordHash WHERE UserId = @UserId;
                        SELECT 1;
                    END
                    ELSE
                    BEGIN
                        SELECT 0;
                    END";

                using (SqlCommand cmd = new SqlCommand(updateQuery, conn))
                {
                    cmd.Parameters.AddWithValue("@VerifyEmail", verifyEmailInput);
                    cmd.Parameters.AddWithValue("@PasswordHash", matchingNewHash);
                    cmd.Parameters.Add("@UserId", System.Data.SqlDbType.UniqueIdentifier).Value = new Guid(activeUserId);

                    try
                    {
                        conn.Open();
                        object result = cmd.ExecuteScalar();

                        if (result != null && Convert.ToInt32(result) == 1)
                        {
                            ClientScript.RegisterStartupScript(this.GetType(), "PopSuccess", "showSuccessModal();", true);
                            ResetPasswordUI();
                        }
                        else
                        {
                            Response.Write("<script>alert('Verification failed: The email entered does not match this account.');</script>");
                        }
                    }
                    catch (Exception ex)
                    {
                        Response.Write("<script>alert('Database Error: " + ex.Message + "');</script>");
                    }
                }
            }
        }

        private string ComputeSha256Hash(string rawData)
        {
            using (System.Security.Cryptography.SHA256 sha256Hash = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(System.Text.Encoding.UTF8.GetBytes(rawData));
                System.Text.StringBuilder builder = new System.Text.StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }

        private void ResetPasswordUI()
        {
            PanelPasswordInput.Visible = false;
            TextVerifyEmail.Text = "";
            TextNewPassword.Text = "";
            TextConfirmPassword.Text = "";

            BtnEditPassword.Visible = true;
            BtnCancelPassword.Visible = false;
            BtnSavePassword.Visible = false;
        }
    }
}