using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class ForgotPasswordPage : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // 🎯 STEP 1: GENERATE & SEND OTP
        protected void btnSendOTP_Click(object sender, EventArgs e)
        {
            string userEmail = txtEmail.Text.Trim();

            if (string.IsNullOrEmpty(userEmail))
            {
                ShowMessage("Please enter your email address.", false);
                return;
            }

            // 1. Verify if user exists in DB
            if (!UserExists(userEmail))
            {
                ShowMessage("Email address not found in our records.", false);
                return;
            }

            // 2. Generate Random 6-digit OTP
            Random rand = new Random();
            string otpCode = rand.Next(100000, 999999).ToString();

            // 3. Store OTP & Expiration in Session (Valid for 5 minutes)
            Session["ResetEmail"] = userEmail;
            Session["ResetOTP"] = otpCode;
            Session["OTPExpiry"] = DateTime.Now.AddMinutes(5);

            // 4. Send Email via SMTP
            bool emailSent = SendOTPEmail(userEmail, otpCode);

            if (emailSent)
            {
                ShowMessage("OTP code has been sent to your email!", true);
                pnlStep1.Visible = false;
                pnlStep2.Visible = true;
            }
            else
            {
                ShowMessage("Failed to send email. Please check server SMTP configuration.", false);
            }
        }

        // 🎯 STEP 2: VERIFY OTP & UPDATE PASSWORD
        protected void btnResetPassword_Click(object sender, EventArgs e)
        {
            string enteredOTP = txtOTP.Text.Trim();
            string newPass = txtNewPassword.Text.Trim();
            string confirmPass = txtConfirmPassword.Text.Trim();

            // Validation checks
            if (Session["ResetOTP"] == null || Session["OTPExpiry"] == null)
            {
                ShowMessage("Session expired. Please request a new OTP code.", false);
                pnlStep1.Visible = true;
                pnlStep2.Visible = false;
                return;
            }

            if ((DateTime)Session["OTPExpiry"] < DateTime.Now)
            {
                ShowMessage("OTP code has expired. Please request a new one.", false);
                pnlStep1.Visible = true;
                pnlStep2.Visible = false;
                return;
            }

            if (enteredOTP != Session["ResetOTP"].ToString())
            {
                ShowMessage("Invalid OTP code. Please try again.", false);
                return;
            }

            if (string.IsNullOrEmpty(newPass) || newPass.Length < 6)
            {
                ShowMessage("Password must be at least 6 characters long.", false);
                return;
            }

            if (newPass != confirmPass)
            {
                ShowMessage("Passwords do not match.", false);
                return;
            }

            // Update Database Password
            string emailToReset = Session["ResetEmail"].ToString();
            bool isUpdated = UpdatePasswordInDB(emailToReset, newPass);

            if (isUpdated)
            {
                // Clear session keys
                Session.Remove("ResetEmail");
                Session.Remove("ResetOTP");
                Session.Remove("ResetOTPExpiry");

                // Redirect back to login page
                Response.Redirect("LoginPage.aspx?reset=success");
            }
            else
            {
                ShowMessage("Failed to update password. Please try again.", false);
            }
        }

        // Helper Method: Check if User Exists
        private bool UserExists(string userEmail)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Email", userEmail);
                    conn.Open();
                    int count = Convert.ToInt32(cmd.ExecuteScalar());
                    return count > 0;
                }
            }
        }

        // Helper Method: Send Email via SMTP
        private bool SendOTPEmail(string toEmail, string otp)
        {
            try
            {
                string senderEmail = ConfigurationManager.AppSettings["SmtpEmail"];
                string senderPassword = ConfigurationManager.AppSettings["SmtpPassword"];

                MailMessage mail = new MailMessage();
                mail.From = new MailAddress(senderEmail, "Pixel Math Support");
                mail.To.Add(toEmail);
                mail.Subject = "Your Pixel Math Password Reset OTP Code";
                mail.Body = $@"
                    <div style='font-family: Arial, sans-serif; padding: 20px; background-color: #f0fdf4;'>
                        <h2 style='color: #14532d;'>Pixel Math Password Reset</h2>
                        <p>You requested a password reset. Use the OTP code below to set your new password:</p>
                        <h1 style='color: #16a34a; letter-spacing: 5px;'>{otp}</h1>
                        <p>This code will expire in <strong>5 minutes</strong>.</p>
                        <p>If you didn't request this, please ignore this email.</p>
                    </div>";
                mail.IsBodyHtml = true;

                SmtpClient smtp = new SmtpClient("smtp.gmail.com", 587);
                smtp.Credentials = new NetworkCredential(senderEmail, senderPassword);
                smtp.EnableSsl = true;

                smtp.Send(mail);
                return true;
            }
            catch (Exception ex)
            {
                // Log exception if needed
                return false;
            }
        }

        // Helper Method: Update Password in SQL
        private bool UpdatePasswordInDB(string userEmail, string newPassword)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // 🎯 1. YOU MUST HASH THE NEW PASSWORD HERE BEFORE SAVING!
                string hashedPassword = ComputeSha256Hash(newPassword);

                string query = "UPDATE Users SET PasswordHash = @Password WHERE Email = @Email";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Password", hashedPassword); // 👈 Passes hashedPassword
                    cmd.Parameters.AddWithValue("@Email", userEmail);

                    conn.Open();
                    int rows = cmd.ExecuteNonQuery();
                    return rows > 0;
                }
            }
        }

        // 🎯 2. Add this method inside ForgotPasswordPage.aspx.cs
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

        private void ShowMessage(string msg, bool isSuccess)
        {
            lblMessage.Text = msg;
            lblMessage.CssClass = isSuccess ? "block text-center text-sm font-semibold mb-4 text-green-600" : "block text-center text-sm font-semibold mb-4 text-red-600";
            lblMessage.Visible = true;
        }
    }
}