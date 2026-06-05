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
            string connString = ConfigurationManager.ConnectionStrings["PixelMathDB"].ConnectionString;

            string query = @"
                IF NOT EXISTS (SELECT * FROM [Roles] WHERE [RoleId] = 1)
                BEGIN
                    SET IDENTITY_INSERT [Roles] ON;
                    INSERT INTO [Roles] ([RoleId], [RoleName]) VALUES (1, 'Student');
                    SET IDENTITY_INSERT [Roles] OFF;
                END

                INSERT INTO [Users] (FullName, Email, PasswordHash, RoleId, IsApproved) 
                VALUES (@FullName, @Email, @Password, 1, 1);";

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@FullName", txtFullName.Text.Trim());
                        cmd.Parameters.AddWithValue("@Email", txtEmail.Text.Trim());
                        cmd.Parameters.AddWithValue("@Password", txtPassword.Text); // Note: Hash in production!

                        conn.Open();
                        cmd.ExecuteNonQuery();

                        // Registration succeeded! Route them to the login screen
                        Response.Redirect("LoginPage.aspx");
                    }
                }
            }
            catch (Exception ex)
            {
                lblStatus.Text = "Error: " + ex.Message;
                lblStatus.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnLoginRedirect_Click(object sender, EventArgs e)
        {
            Response.Redirect("LoginPage.aspx");
        }
    }
}