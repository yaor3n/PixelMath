using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Student_Resources : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                BindResources();
            }
        }
        private void BindResources()
        {
            string activeUserId = Session["UserId"].ToString();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Select columns matching your database diagram (Title, ResourceUrl)
                string query = "SELECT Title, ResourceUrl FROM Resources";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        sda.Fill(dt);

                        // 🎯 Bind the data table to the Repeater element
                        ResourceRepeater.DataSource = dt;
                        ResourceRepeater.DataBind(); // <-- THIS EXECUTED THE <%# %> CODE!
                    }
                }
            }
        }
    }
}