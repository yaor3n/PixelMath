using System;
using System.Configuration;
using System.Data.SqlClient;

namespace PixelMath
{
    public partial class LoginPage : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Removed the Page_Load session redirect entirely to prevent ERR_TOO_MANY_REDIRECTS loops.
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string plainEmail = email.Text.Trim();
            string plainPassword = txtPassword.Text;

            if (string.IsNullOrEmpty(plainEmail) || string.IsNullOrEmpty(plainPassword))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "alert", "alert('Please fill in all fields.');", true);
                return;
            }

            string hashedInput = ComputeSha256Hash(plainPassword);
            string query = "SELECT [UserId], [FullName], [Email], [RoleId] FROM [Users] WHERE [Email] = @Email AND [PasswordHash] = @Password";

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
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
                                Session.Clear();

                                Session["UserId"] = reader["UserId"].ToString();
                                Session["FullName"] = reader["FullName"].ToString();

                                int roleId = Convert.ToInt32(reader["RoleId"]);
                                Session["RoleId"] = roleId;

                                // Determine target dashboard based on role
                                string targetUrl = "Student-Dashboard.aspx";
                                if (roleId == 2)
                                {
                                    targetUrl = "Lecturer-Dashboard.aspx";
                                }
                                else if (roleId == 3)
                                {
                                    targetUrl = "Admin-Dashboard.aspx";
                                }

                                // 100% reliable client-side navigation that skips server thread abortion blocks
                                ClientScript.RegisterStartupScript(this.GetType(), "redir", $"window.location.href = '{targetUrl}';", true);
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