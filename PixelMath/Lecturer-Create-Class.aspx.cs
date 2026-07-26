using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PixelMath
{
    public partial class Lecturer_Create_Class : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["PixelMathConnStr"]?.ConnectionString
            ?? ConfigurationManager.ConnectionStrings["PixelMathDB"]?.ConnectionString
            ?? @"Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=PixelMath;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authenticate Lecturer (RoleId = 2)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadExistingClasses();
            }
        }

        private void LoadExistingClasses()
        {
            Guid lecturerId;
            if (!Guid.TryParse(Session["UserId"].ToString(), out lecturerId)) return;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string sql = "SELECT ClassId, ClassName, ISNULL(Description, 'No description provided.') AS Description, CreatedAt FROM Classes WHERE CreatedBy = @LecturerId ORDER BY CreatedAt DESC";
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                        conn.Open();

                        SqlDataAdapter da = new SqlDataAdapter(cmd);
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            rptClasses.DataSource = dt;
                            rptClasses.DataBind();
                            pnlNoClasses.Visible = false;
                            litClassCount.Text = dt.Rows.Count.ToString();
                        }
                        else
                        {
                            rptClasses.DataSource = null;
                            rptClasses.DataBind();
                            pnlNoClasses.Visible = true;
                            litClassCount.Text = "0";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading classes: " + ex.Message, false);
            }
        }

        protected void btnCreateClass_Click(object sender, EventArgs e)
        {
            Guid lecturerId;
            if (Session["UserId"] == null || !Guid.TryParse(Session["UserId"].ToString(), out lecturerId))
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            string className = txtClassName.Text.Trim();
            string description = txtDescription.Text.Trim();

            if (string.IsNullOrEmpty(className))
            {
                ShowAlert("⚠️ Please enter a class name.", false);
                return;
            }

            // --- GUARD RAIL: Check description length to prevent database truncation error ---
            if (description.Length > 255)
            {
                ShowAlert($"⚠️ Class description is too long! ({description.Length}/255 characters). Please shorten it before creating the class.", false);
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string insertSql = @"
                        INSERT INTO Classes (ClassName, Description, CreatedBy, CreatedAt)
                        VALUES (@ClassName, @Description, @CreatedBy, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                    {
                        cmd.Parameters.AddWithValue("@ClassName", className);
                        cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                        cmd.Parameters.AddWithValue("@CreatedBy", lecturerId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert($"🎉 Class '{className}' was created successfully! You can now assign resources to it.", true);

                // Clear fields & Refresh List
                txtClassName.Text = string.Empty;
                txtDescription.Text = string.Empty;
                LoadExistingClasses();
            }
            catch (Exception ex)
            {
                ShowAlert("Error creating class: " + ex.Message, false);
            }
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isSuccess
                ? "mb-6 p-4 rounded-2xl text-xs font-bold bg-emerald-50 text-emerald-800 border border-emerald-200"
                : "mb-6 p-4 rounded-2xl text-xs font-bold bg-rose-50 text-rose-800 border border-rose-200";
            litAlertMessage.Text = msg;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/LoginPage.aspx");
        }
    }
}