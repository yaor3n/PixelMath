using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;

namespace PixelMath
{
    public partial class Student_Profile : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        
    }
}