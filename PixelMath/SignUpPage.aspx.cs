using System;
using System.Configuration;
using System.Data.SqlClient;

namespace PixelMath
{
    public partial class SignUpPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnSubmit_Click(object sender, EventArgs e)
        {
            string connString = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;


            string hashedPassword = ComputeSha256Hash(txtPassword.Text);

            int selectedRoleId = Convert.ToInt32(ddlRole.SelectedValue);

            string query = @"
                IF NOT EXISTS (SELECT * FROM [Roles] WHERE [RoleId] = 1)
                BEGIN
                    SET IDENTITY_INSERT [Roles] ON;
                    INSERT INTO [Roles] ([RoleId], [RoleName]) VALUES (1, 'Student'), (2, 'Lecturer'), (3, 'Admin');
                    SET IDENTITY_INSERT [Roles] OFF;
                END

                INSERT INTO [Users] (FullName, Email, PasswordHash, RoleId, IsApproved, Form) 
                VALUES (@FullName, @Email, @Password, @RoleId, 1, NULL);";

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Password", hashedPassword);
                        cmd.Parameters.AddWithValue("@RoleId", selectedRoleId);

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        Response.Redirect("LoginPage.aspx");
                    }
                }
            }
            catch (Exception ex)
            {
                if (ex.Message.Contains("UNIQUE KEY") || ex.Message.Contains("duplicate"))
                {
                    lblStatus.Text = "This email is already registered.";
                }
                else
                {
                    lblStatus.Text = "Error: " + ex.Message;
                }
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnLoginRedirect_Click(object sender, EventArgs e)
        {
            Response.Redirect("LoginPage.aspx");
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