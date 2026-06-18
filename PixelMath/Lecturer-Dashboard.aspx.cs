using System;

namespace PixelMath
{
    public partial class Lecturer_Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Session["UserId"] == null || Session["RoleId"].ToString() != "2")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("LoginPage.aspx");
            }
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            // 1. Flush all running data elements from the temporary collection cache
            Session.Clear();

            // 2. Terminate the server session engine mapping instance completely
            Session.Abandon();

            // 3. Clear and invalidate the client-side session identification tracking cookie
            if (Request.Cookies["ASP.NET_SessionId"] != null)
            {
                Response.Cookies["ASP.NET_SessionId"].Value = string.Empty;
                Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddMonths(-20); // Forces immediate removal via browser engine
            }

            // 4. Safely return back to the landing page
            Response.Redirect("LoginPage.aspx");
        }
    }
}