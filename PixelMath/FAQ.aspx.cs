using System;

namespace PixelMath
{
    public partial class FAQ : System.Web.UI.Page
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

        protected void btnBackHome_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/index.aspx");
        }
    }
}