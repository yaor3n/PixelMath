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
                string sql = @"
                    SELECT 
                        R.ResourceId,
                        R.Title,
                        R.Description,
                        R.ResourceType,
                        R.FilePath AS ResourceUrl,
                        R.OriginalFileName,
                        R.UploadedAt AS CreatedAt
                    FROM Resources R
                    INNER JOIN StudentClasses SC ON R.ClassId = SC.ClassId
                    WHERE SC.StudentId = @StudentId
                    ORDER BY R.UploadedAt DESC;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                cmd.Parameters.Add("@StudentId", SqlDbType.UniqueIdentifier).Value = Guid.Parse(studentId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                if (dt.Rows.Count > 0)
                {
                    ResourceRepeater.DataSource = dt;
                    ResourceRepeater.DataBind();
                    pnlNoResources.Visible = false;
                }
                else
                {
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
                        Description,
                        ResourceType,
                        FilePath AS ResourceUrl,
                        OriginalFileName,
                        UploadedAt AS CreatedAt
                    FROM Resources
                    ORDER BY UploadedAt DESC;";

                SqlCommand cmd = new SqlCommand(sql, conn);
                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                ResourceRepeater.DataSource = dt;
                ResourceRepeater.DataBind();

                pnlNoResources.Visible = dt.Rows.Count == 0;
            }
        }

        // 🎯 Helper Method: Ensures path matches ~/Uploads/resources/[filename] and resolves correctly
        public string GetFormattedUrl(object pathObj)
        {
            if (pathObj == null || pathObj == DBNull.Value) return "#";

            string rawPath = pathObj.ToString().Trim();

            // If path doesn't start with '~/', format it properly
            if (!rawPath.StartsWith("~/"))
            {
                if (rawPath.StartsWith("/"))
                    rawPath = "~" + rawPath;
                else
                    rawPath = "~/" + rawPath;
            }

            // Clean double slashes if any
            rawPath = rawPath.Replace("//", "/");

            return ResolveUrl(rawPath);
        }
    }
}