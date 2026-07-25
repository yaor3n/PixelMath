using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Admin_Dashboard : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"] == null || Session["RoleId"].ToString() != "3")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadStats();
                LoadRecentUsers();
            }
        }

        private void LoadStats()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        (SELECT COUNT(*) FROM Users WHERE RoleId = 1) AS StudentCount,
                        (SELECT COUNT(*) FROM Users WHERE RoleId = 2) AS LecturerCount,
                        (SELECT COUNT(*) FROM Classes) AS ClassCount,
                        (SELECT COUNT(*) FROM Quizzes) AS QuizCount";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                LblTotalStudents.Text = reader["StudentCount"].ToString();
                                LblTotalLecturers.Text = reader["LecturerCount"].ToString();
                                LblTotalClasses.Text = reader["ClassCount"].ToString();
                                LblTotalQuizzes.Text = reader["QuizCount"].ToString();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error loading admin stats: " + ex.Message);
                    }
                }
            }
        }

        private void LoadRecentUsers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT TOP 7 U.FullName, U.Email, U.AccountStatus, U.CreatedAt, R.RoleName, R.RoleId
                    FROM Users U
                    INNER JOIN Roles R ON U.RoleId = R.RoleId
                    ORDER BY U.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();
                        da.Fill(dt);

                        if (dt.Rows.Count == 0)
                        {
                            PanelNoRecentUsers.Visible = true;
                        }
                        else
                        {
                            RepeatRecentUsers.DataSource = dt;
                            RepeatRecentUsers.DataBind();
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error loading recent users: " + ex.Message);
                        PanelNoRecentUsers.Visible = true;
                    }
                }
            }
        }

        protected void RepeatRecentUsers_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                Label lblRoleBadge = (Label)e.Item.FindControl("LblRoleBadge");

                if (lblRoleBadge != null)
                {
                    int roleId = Convert.ToInt32(row["RoleId"]);
                    string roleName = row["RoleName"].ToString();

                    lblRoleBadge.Text = roleName;
                    switch (roleId)
                    {
                        case 3:
                            lblRoleBadge.CssClass = "role-badge role-badge-admin";
                            break;
                        case 2:
                            lblRoleBadge.CssClass = "role-badge role-badge-lecturer";
                            break;
                        default:
                            lblRoleBadge.CssClass = "role-badge role-badge-student";
                            break;
                    }
                }
            }
        }

        protected string GetStatusCss(object statusValue)
        {
            string status =
                statusValue == null || statusValue == DBNull.Value
                    ? ""
                    : statusValue.ToString().Trim();

            if (status.Equals(
                "Approved",
                StringComparison.OrdinalIgnoreCase))
            {
                return "status-badge status-badge-approved";
            }

            if (status.Equals(
                "Rejected",
                StringComparison.OrdinalIgnoreCase))
            {
                return "status-badge status-badge-rejected";
            }

            return "status-badge status-badge-pending";
        }
    }
}
