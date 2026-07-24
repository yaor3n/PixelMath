using System;
using System.Configuration;
using System.Data.SqlClient;

namespace PixelMath
{
    public partial class LoginPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already logged in, redirect them out immediately
            if (Session["UserId"] != null && Session["RoleId"] != null)
            {
                RedirectUserBasedOnRole(Session["RoleId"].ToString());
            }

            if (!IsPostBack) {
                string registrationStatus = Request.QueryString["registered"];
                if (registrationStatus == "pending")
                {
                    labelStatus.Text = "Registration Successful. Please wait for the approval from the administrator.";
                    labelStatus.ForeColor = System.Drawing.Color.DarkOrange;
                    labelStatus.Visible = true;
                }
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

            string plainEmail = email.Text.Trim();
            string plainPassword = txtPassword.Text;

            if (string.IsNullOrEmpty(plainEmail) || string.IsNullOrEmpty(plainPassword))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please fill in all fields.');", true);
                return;
            }

            string hashedInput = ComputeSha256Hash(plainPassword);
            string query = "SELECT [UserId], [FullName], [Email], [RoleId], [IsApproved], [AccountStatus] FROM [Users] WHERE [Email] = @Email AND [PasswordHash] = @Password";

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Email", plainEmail);
                        cmd.Parameters.AddWithValue("@Password", hashedInput);

                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                bool isApproved = Convert.ToBoolean(reader["IsApproved"]);
                                string accountStatus = reader["AccountStatus"].ToString();

                                if (!isApproved || accountStatus != "Approved")
                                {
                                    if (accountStatus == "Rejected")
                                    {
                                        labelStatus.Text = "Your account has been rejected. Please contact the administrator.";
                                        labelStatus.ForeColor = System.Drawing.Color.Red;
                                    } else
                                    {
                                        labelStatus.Text = "Your account is on pending. Please contact the administrator.";
                                        labelStatus.ForeColor = System.Drawing.Color.DarkOrange;
                                    }
                                    labelStatus.Visible = true;
                                    return;
                                }

                                // Store raw string data from DB directly into Sessions
                                Session["UserId"] = reader["UserId"].ToString();
                                Session["FullName"] = reader["FullName"].ToString();
                                Session["RoleId"] = reader["RoleId"].ToString(); // Saves "1" or "2"

                                // Route directly using the string ID
                                RedirectUserBasedOnRole(Session["RoleId"].ToString());
                            }
                            else
                            {
                                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Invalid Email or Password.');", true);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", $"alert('Database Error: {ex.Message.Replace("'", "\\'")}');", true);
            }
        }

        private void RedirectUserBasedOnRole(string roleId)
        {
            switch (roleId)
            {
                case "3":
                    Response.Redirect("Admin-Dashboard.aspx");
                    break;
                case "2":
                    Response.Redirect("Lecturer-Dashboard.aspx");
                    break;
                case "1":
                default:
                    Response.Redirect("Student-Dashboard.aspx");
                    break;
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
    }
}