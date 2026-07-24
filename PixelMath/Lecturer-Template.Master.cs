using System;
using System.Web;
using System.Web.UI;

namespace PixelMath
{
    public partial class Lecturer_Template : MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
                {
                    Response.Redirect("~/LoginPage.aspx");
                    return;
                }

                if (Session["FullName"] != null)
                {
                    litSidebarLecturerName.Text = Session["FullName"].ToString();
                }
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // 1. Clear server-side session data
            Session.Clear();
            Session.Abandon();

            // 2. Explicitly destroy the ASP.NET Session cookie in the browser
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                HttpCookie sessionCookie = new HttpCookie("ASP.NET_SessionId");
                sessionCookie.Expires = DateTime.Now.AddDays(-1);
                Response.Cookies.Add(sessionCookie);
            }

            // 3. Redirect back to login
            Response.Redirect("~/LoginPage.aspx");
        }
    }
}