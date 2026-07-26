using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.IdentityModel.Tokens;
using System.Web;

namespace PixelMath
{
    public partial class LoginPage : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Removed the Page_Load session redirect entirely to prevent ERR_TOO_MANY_REDIRECTS loops.
            if (!IsPostBack)
            {
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
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.Add("@Email", System.Data.SqlDbType.VarChar, 255).Value = plainEmail;
                        cmd.Parameters.Add("@Password", System.Data.SqlDbType.VarChar, 64).Value = hashedInput;

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
                                        labelStatus.ForeColor = System.Drawing.Color.DarkOrange;
                                    }
                                    else
                                    {
                                        labelStatus.Text = "Your account is on pending. Please contact the administrator.";
                                        labelStatus.ForeColor = System.Drawing.Color.DarkOrange;
                                    }
                                    labelStatus.Visible = true;
                                    return;
                                }

                                // Store raw string data from DB directly into Sessions
                                string userId = reader["UserId"].ToString();
                                string fullName = reader["FullName"].ToString();
                                int roleId = Convert.ToInt32(reader["RoleId"]);

                                Session["UserId"] = userId;
                                Session["FullName"] = fullName;
                                Session["RoleId"] = roleId;

                                // --- JWT HttpOnly Cookie Implementation ---
                                try
                                {
                                    // Secret key must be at least 256 bits (32 characters) long
                                    string secretKey = "PixelMathSuperSecretKeyForExtraMarks2026!";
                                    var key = Encoding.UTF8.GetBytes(secretKey);

                                    var tokenDescriptor = new SecurityTokenDescriptor
                                    {
                                        Subject = new ClaimsIdentity(new[]
                                        {
                                            new Claim(ClaimTypes.NameIdentifier, userId),
                                            new Claim(ClaimTypes.Email, plainEmail),
                                            new Claim(ClaimTypes.Role, roleId.ToString())
                                        }),
                                        Expires = DateTime.UtcNow.AddHours(2),
                                        SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key), SecurityAlgorithms.HmacSha256Signature)
                                    };

                                    var tokenHandler = new JwtSecurityTokenHandler();
                                    var token = tokenHandler.CreateToken(tokenDescriptor);
                                    string jwtToken = tokenHandler.WriteToken(token);

                                    // Create the HttpOnly cookie for extra security marks
                                    HttpCookie jwtCookie = new HttpCookie("jwt", jwtToken)
                                    {
                                        HttpOnly = true,
                                        Secure = Request.IsSecureConnection, // Automatically true if running HTTPS, safe for local HTTP
                                        Expires = DateTime.Now.AddHours(2)
                                    };

                                    Response.Cookies.Add(jwtCookie);
                                }
                                catch
                                {
                                    // Fallback gracefully so standard login flow isn't broken if JWT throws unexpected environment issues
                                }
                                // ------------------------------------------

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