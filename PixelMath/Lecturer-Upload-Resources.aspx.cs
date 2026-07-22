using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Lecturer_Upload_Resources : Page
    {
        private readonly string connStr = ConfigurationManager.ConnectionStrings["PixelMathConnStr"]?.ConnectionString
            ?? ConfigurationManager.ConnectionStrings["PixelMathDB"]?.ConnectionString
            ?? @"Data Source=(LocalDB)\MSSQLLocalDB;Initial Catalog=PixelMath;Integrated Security=True;";

        protected void Page_Load(object sender, EventArgs e)
        {
            // Authenticate Lecturer (RoleId = 2)
            if (Session["UserId"] == null || Session["RoleId"] == null || Convert.ToInt32(Session["RoleId"]) != 2)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                string name = Session["FullName"] != null ? Session["FullName"].ToString() : "Lecturer";
                litSidebarLecturerName.Text = name;

                Guid lecturerId;
                if (Guid.TryParse(Session["UserId"].ToString(), out lecturerId))
                {
                    LoadClassesDropdown(lecturerId);
                }
                else
                {
                    ShowAlert("Invalid user session. Please log in again.", false);
                }
            }
        }

        private void LoadClassesDropdown(Guid lecturerId)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "SELECT ClassId, ClassName FROM Classes WHERE CreatedBy = @LecturerId ORDER BY ClassName ASC";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@LecturerId", lecturerId);
                        conn.Open();

                        SqlDataReader reader = cmd.ExecuteReader();

                        ddlClass.Items.Clear();
                        // Add default placeholder item
                        ddlClass.Items.Add(new ListItem("-- Select Class --", ""));

                        if (reader.HasRows)
                        {
                            while (reader.Read())
                            {
                                string classId = reader["ClassId"].ToString();
                                string className = reader["ClassName"].ToString();
                                ddlClass.Items.Add(new ListItem(className, classId));
                            }
                        }
                        else
                        {
                            ShowAlert("⚠️ No classes found. Please create or assign a class first.", false);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAlert("Error loading classes: " + ex.Message, false);
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            Guid lecturerId;
            if (Session["UserId"] == null || !Guid.TryParse(Session["UserId"].ToString(), out lecturerId))
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            string title = txtResourceTitle.Text.Trim();
            string description = txtDescription.Text.Trim();
            string resourceType = ddlResourceType.SelectedValue;
            string selectedClassIdStr = ddlClass.SelectedValue;

            // -------------------------------------------------------------------
            // 1. INPUT VALIDATION
            // -------------------------------------------------------------------
            if (string.IsNullOrEmpty(title))
            {
                ShowAlert("Please enter a resource title.", false);
                return;
            }

            if (string.IsNullOrEmpty(selectedClassIdStr))
            {
                ShowAlert("Please select a valid class to assign this resource.", false);
                return;
            }

            if (!fileUpload.HasFile)
            {
                ShowAlert("Please attach a document file to upload.", false);
                return;
            }

            try
            {
                // -------------------------------------------------------------------
                // 2. FILE SIZE GUARD (15 MB Limit)
                // -------------------------------------------------------------------
                int maxSizeBytes = 15 * 1024 * 1024; // 15 MB in Bytes
                if (fileUpload.PostedFile.ContentLength > maxSizeBytes)
                {
                    double fileSizeMB = Math.Round((double)fileUpload.PostedFile.ContentLength / (1024 * 1024), 2);
                    ShowAlert($"File size ({fileSizeMB} MB) exceeds the maximum allowed limit of 15 MB.", false);
                    return;
                }

                // -------------------------------------------------------------------
                // 3. EXTENSION VALIDATION
                // -------------------------------------------------------------------
                string extension = Path.GetExtension(fileUpload.FileName).ToLower();
                string[] allowedExtensions = { ".pdf", ".docx", ".doc", ".pptx", ".ppt", ".png", ".jpg", ".jpeg" };

                if (Array.IndexOf(allowedExtensions, extension) < 0)
                {
                    ShowAlert("Invalid file format. Allowed formats: PDF, DOCX, PPTX, PNG, JPG.", false);
                    return;
                }

                // -------------------------------------------------------------------
                // 4. SAFE SAVE TO DISK
                // -------------------------------------------------------------------
                string folderPath = Server.MapPath("~/Uploads/");
                if (!Directory.Exists(folderPath))
                {
                    Directory.CreateDirectory(folderPath);
                }

                string uniqueFileName = Guid.NewGuid().ToString() + extension;
                string savePath = Path.Combine(folderPath, uniqueFileName);
                fileUpload.SaveAs(savePath);

                string relativeFilePath = "~/Uploads/" + uniqueFileName;

                // -------------------------------------------------------------------
                // 5. DATABASE INSERTION (Supports both Int and Guid ClassId)
                // -------------------------------------------------------------------
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string insertSql = @"
                        INSERT INTO Resources (ClassId, Title, Description, ResourceType, FilePath, OriginalFileName, UploadedBy, UploadedAt)
                        VALUES (@ClassId, @Title, @Description, @ResourceType, @FilePath, @OriginalFileName, @UploadedBy, GETDATE())";

                    using (SqlCommand cmd = new SqlCommand(insertSql, conn))
                    {
                        // Handle ClassId typing dynamically
                        int classIdInt;
                        Guid classIdGuid;

                        if (int.TryParse(selectedClassIdStr, out classIdInt))
                        {
                            cmd.Parameters.AddWithValue("@ClassId", classIdInt);
                        }
                        else if (Guid.TryParse(selectedClassIdStr, out classIdGuid))
                        {
                            cmd.Parameters.AddWithValue("@ClassId", classIdGuid);
                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@ClassId", selectedClassIdStr);
                        }

                        cmd.Parameters.AddWithValue("@Title", title);
                        cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                        cmd.Parameters.AddWithValue("@ResourceType", resourceType);
                        cmd.Parameters.AddWithValue("@FilePath", relativeFilePath);
                        cmd.Parameters.AddWithValue("@OriginalFileName", fileUpload.FileName);
                        cmd.Parameters.AddWithValue("@UploadedBy", lecturerId);

                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }

                // Success Response & Form Reset
                ShowAlert("🎉 Resource uploaded successfully!", true);
                txtResourceTitle.Text = string.Empty;
                txtDescription.Text = string.Empty;
                ddlClass.SelectedIndex = 0;
            }
            catch (Exception ex)
            {
                ShowAlert("Upload error: " + ex.Message, false);
            }
        }

        private void ShowAlert(string msg, bool isSuccess)
        {
            pnlAlert.Visible = true;
            pnlAlert.CssClass = isSuccess
                ? "mb-6 p-4 rounded-2xl text-xs font-bold bg-emerald-50 text-emerald-800 border border-emerald-200"
                : "mb-6 p-4 rounded-2xl text-xs font-bold bg-rose-50 text-rose-800 border border-rose-200";
            litAlertMessage.Text = msg;
        }

        protected void btnLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Session.Abandon();
            Response.Redirect("~/Login.aspx");
        }
    }
}