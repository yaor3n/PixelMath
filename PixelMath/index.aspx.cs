using System;

namespace PixelMath
{
    public partial class index : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/LoginPage.aspx");
        }

        protected void btnSignUp_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/SignUpPage.aspx");
        }

        protected void btnLearnMore_Click(object sender, EventArgs e)
        {
            // Optional: Redirect somewhere else or keep on page
            Response.Redirect("~/FAQ.aspx");
        }
    }
}