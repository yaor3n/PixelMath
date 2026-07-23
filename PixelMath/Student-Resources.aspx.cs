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
            // 1. Ensure user is logged in
            if (Session["UserId"] == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string studentId = Session["UserId"].ToString();
                LoadResources(studentId);
            }
        }

        private void LoadResources(string studentId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Query resources available for classes the student is enrolled in
                string sql = @"
                    SELECT 
                        R.ResourceId,
                        R.Title,
                        R.ResourceUrl,
                        R.CreatedAt
                    FROM Resources R
                    INNER JOIN StudentClasses SC ON R.ClassId = SC.ClassId
                    WHERE SC.StudentId = @StudentId
                    ORDER BY R.CreatedAt DESC;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@StudentId", SqlDbType.UniqueIdentifier).Value = Guid.Parse(studentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                // If enrolled classes have resources, bind them
                if (dt.Rows.Count > 0)
                {
                    ResourceRepeater.DataSource = dt;
                    ResourceRepeater.DataBind();
                    pnlNoResources.Visible = false;
                }
                else
                {
                    // Fallback: If no class-specific resources are found, load all resources
                    LoadAllResources();
                }
            }
        }

        private void LoadAllResources()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string sql = @"
                    SELECT 
                        ResourceId,
                        Title,
                        ResourceUrl,
                        CreatedAt
                    FROM Resources
                    ORDER BY CreatedAt DESC;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ResourceRepeater.DataSource = dt;
                ResourceRepeater.DataBind();

                pnlNoResources.Visible = dt.Rows.Count == 0;
            }
        }
    }
}