using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Lecturer_Announcements : Page
    {
        private string connStr => ConfigurationManager.ConnectionStrings["PixelMathConnStr"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Session guard: Ensure only logged-in lecturers can access this page
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLecturerClasses();
                LoadRecentAnnouncements();
                LoadAdminAnnouncements();
            }
        }

        private void LoadLecturerClasses()
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT ClassId, ClassName FROM Classes WHERE CreatedBy = @LecturerId ORDER BY ClassName ASC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        ddlClasses.DataSource = reader;
                        ddlClasses.DataTextField = "ClassName";
                        ddlClasses.DataValueField = "ClassId";
                        ddlClasses.DataBind();
                    }
                }
            }

            // Insert default prompt
            ddlClasses.Items.Insert(0, new ListItem("-- Select Target Class --", "0"));
        }

        private void LoadRecentAnnouncements()
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
            SELECT A.AnnouncementId, A.Title, A.Message, A.CreatedAt, 
                   ISNULL(C.ClassName, 'General / All Users') AS ClassName 
            FROM Announcements A
            LEFT JOIN Classes C ON A.ClassId = C.ClassId
            WHERE A.CreatedBy = @LecturerId
            ORDER BY A.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptAnnouncements.DataSource = dt;
                        rptAnnouncements.DataBind();
                        litAnnouncementCount.Text = dt.Rows.Count.ToString();
                        pnlNoAnnouncements.Visible = false;
                    }
                    else
                    {
                        rptAnnouncements.DataSource = null;
                        rptAnnouncements.DataBind();
                        litAnnouncementCount.Text = "0";
                        pnlNoAnnouncements.Visible = true;
                    }
                }
            }
        }

        private void LoadAdminAnnouncements()
        {
            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Filters admin announcements to:
                // 1. Announcements for All Users (ClassId IS NULL)
                // 2. Announcements targeting classes created/taught by this specific lecturer
                string query = @"
            SELECT A.AnnouncementId, A.Title, A.Message, A.CreatedAt, 
                   ISNULL(C.ClassName, 'General / All Users') AS AudienceName,
                   U.FullName AS PostedBy
            FROM Announcements A
            INNER JOIN Users U ON A.CreatedBy = U.UserId
            LEFT JOIN Classes C ON A.ClassId = C.ClassId
            WHERE U.RoleId = 3 AND A.Status = 1
              AND (A.ClassId IS NULL OR A.ClassId IN (SELECT ClassId FROM Classes WHERE CreatedBy = @LecturerId))
            ORDER BY A.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        rptAdminAnnouncements.DataSource = dt;
                        rptAdminAnnouncements.DataBind();
                        pnlNoAdminAnnouncements.Visible = false;
                    }
                    else
                    {
                        rptAdminAnnouncements.DataSource = null;
                        rptAdminAnnouncements.DataBind();
                        pnlNoAdminAnnouncements.Visible = true;
                    }
                }
            }
        }

        protected void btnPostAnnouncement_Click(object sender, EventArgs e)
        {
            if (ddlClasses.SelectedValue == "0")
            {
                ShowAlert("Please select a target class for the announcement.", false);
                return;
            }

            string title = txtTitle.Text.Trim();
            string message = txtMessage.Text.Trim();

            if (string.IsNullOrEmpty(title) || string.IsNullOrEmpty(message))
            {
                ShowAlert("Please fill in both the title and message fields.", false);
                return;
            }

            Guid lecturerId = Guid.Parse(Session["UserId"].ToString());
            int classId = Convert.ToInt32(ddlClasses.SelectedValue);

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = @"
                        INSERT INTO Announcements (Title, Message, ClassId, CreatedBy, Status, CreatedAt)
                        VALUES (@Title, @Message, @ClassId, @CreatedBy, 1, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Message", message);
                        cmd.Parameters.AddWithValue("@ClassId", classId);
                        cmd.Parameters.AddWithValue("@CreatedBy", lecturerId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                ShowAlert("Announcement posted successfully to students! 🚀", true);

                // Clear input fields
                txtTitle.Text = string.Empty;
                txtMessage.Text = string.Empty;
                ddlClasses.SelectedIndex = 0;

                // Refresh recent feed
                LoadRecentAnnouncements();
            }
            catch (Exception ex)
            {
                ShowAlert("Error posting announcement: " + ex.Message, false);
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/LoginPage.aspx");
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            litAlertMessage.Text = msg;

            if (isSuccess)
            {
                pnlAlert.CssClass = "mb-6 p-4 rounded-2xl text-xs font-bold bg-emerald-50 text-emerald-800 border border-emerald-200";
            }
            else
            {
                pnlAlert.CssClass = "mb-6 p-4 rounded-2xl text-xs font-bold bg-rose-50 text-rose-800 border border-rose-200";
            }
        }
    }
}