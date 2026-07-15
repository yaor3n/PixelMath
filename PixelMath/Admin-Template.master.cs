using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace PixelMath
{
    public partial class Admin_Template : System.Web.UI.MasterPage
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Only Admins (RoleId 3) may view any page using this master
            if (Session["UserId"] == null || Session["RoleId"] == null || Session["RoleId"].ToString() != "3")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadSidebarDetail();
            }
        }

        protected void btnConfirmLogOut_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20);
            }
            Response.Redirect("LoginPage.aspx");
        }

        private void LoadSidebarDetail()
        {
            string activeUserId = Session["UserId"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT FullName FROM Users WHERE UserId = @UserId";

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
                                FullName.Text = reader["FullName"].ToString();
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error loading admin sidebar profile: " + ex.Message);
                    }
                }
            }
        }
    }
}
