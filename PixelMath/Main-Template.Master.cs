using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Profile;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Main_Template : System.Web.UI.MasterPage
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"].ToString() != "1")
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
                string query = "SELECT FullName, Form FROM Users WHERE UserId = @UserId";

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
                                string formValue = reader["Form"].ToString();
                                Form.Text = !string.IsNullOrEmpty(formValue) ? "Form " + formValue : "General";
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        System.Diagnostics.Debug.WriteLine("Error loading sidebar profile: " + ex.Message);
                    }
                }
            }
        }
    }
}