using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath {
    public partial class Admin_Classes : System.Web.UI.Page {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["RoleId"] == null || Session["RoleId"].ToString() != "3")
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadClasses();
            }
        }

        // ===================== CLASS LIST =====================

        private void LoadClasses()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT C.ClassId, C.ClassName, C.Description, C.CreatedAt,
                           (SELECT COUNT(*) FROM StudentClasses SC WHERE SC.ClassId = C.ClassId) AS StudentCount
                    FROM Classes C
                    ORDER BY C.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();
                        da.Fill(dt);

                        if (dt.Rows.Count == 0)
                        {
                            RepeatClasses.DataSource = null;
                            RepeatClasses.DataBind();
                            PanelNoClasses.Visible = true;
                        }
                        else
                        {
                            PanelNoClasses.Visible = false;
                            RepeatClasses.DataSource = dt;
                            RepeatClasses.DataBind();
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading classes: " + ex.Message, false);
                    }
                }
            }
        }

        // ===================== ADD / EDIT CLASS =====================

        protected void BtnAddClass_Click(object sender, EventArgs e)
        {
            ResetClassForm();
            PanelMessage.Visible = false;
            LblFormTitle.Text = "Add New Class";
            BtnSaveClass.Text = "Create Class";
            PanelClassForm.Visible = true;
        }

        protected void BtnCancelForm_Click(object sender, EventArgs e)
        {
            PanelClassForm.Visible = false;
            ResetClassForm();
        }

        private void ResetClassForm()
        {
            HiddenClassId.Value = string.Empty;
            TxtClassName.Text = string.Empty;
            TxtDescription.Text = string.Empty;
        }

        protected void RepeatClasses_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string targetClassId = e.CommandArgument.ToString();

            if (e.CommandName == "Edit")
            {
                LoadClassIntoForm(targetClassId);
            }
            else if (e.CommandName == "Delete")
            {
                DeleteClass(targetClassId);
            }
            else if (e.CommandName == "ManageStudents")
            {
                OpenEnrolmentPanel(targetClassId);
            }
        }

        private void LoadClassIntoForm(string classId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT ClassName, Description FROM Classes WHERE ClassId = @ClassId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(classId));

                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                HiddenClassId.Value = classId;
                                TxtClassName.Text = reader["ClassName"].ToString();
                                TxtDescription.Text = reader["Description"] != DBNull.Value ? reader["Description"].ToString() : "";

                                LblFormTitle.Text = "Edit Class";
                                PanelEnrolment.Visible = false;
                                PanelClassForm.Visible = true;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading class: " + ex.Message, false);
                    }
                }
            }
        }

        protected void BtnSaveClass_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                PanelClassForm.Visible = true;
                return;
            }

            string className = TxtClassName.Text.Trim();
            string description = TxtDescription.Text.Trim();
            bool isEditMode = !string.IsNullOrEmpty(HiddenClassId.Value);

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    conn.Open();

                    if (isEditMode)
                    {
                        string query = "UPDATE Classes SET ClassName = @ClassName, Description = @Description WHERE ClassId = @ClassId";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@ClassName", className);
                            cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                            cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(HiddenClassId.Value));
                            cmd.ExecuteNonQuery();
                        }

                        ShowMessage("Class updated successfully.", true);
                    }
                    else
                    {
                        string query = @"
                            INSERT INTO Classes (ClassName, Description, CreatedBy)
                            VALUES (@ClassName, @Description, @CreatedBy)";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@ClassName", className);
                            cmd.Parameters.AddWithValue("@Description", string.IsNullOrEmpty(description) ? (object)DBNull.Value : description);
                            cmd.Parameters.Add("@CreatedBy", SqlDbType.UniqueIdentifier).Value = new Guid(Session["UserId"].ToString());
                            cmd.ExecuteNonQuery();
                        }

                        ShowMessage("Class added successfully.", true);
                    }

                    PanelClassForm.Visible = false;
                    ResetClassForm();
                    LoadClasses();
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving class: " + ex.Message, false);
                }
            }
        }

        private void DeleteClass(string classId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    conn.Open();

                    // Remove enrolments first (FK dependency), then the class itself
                    string deleteEnrolments = "DELETE FROM StudentClasses WHERE ClassId = @ClassId";
                    using (SqlCommand cmd = new SqlCommand(deleteEnrolments, conn))
                    {
                        cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(classId));
                        cmd.ExecuteNonQuery();
                    }

                    string deleteClass = "DELETE FROM Classes WHERE ClassId = @ClassId";
                    using (SqlCommand cmd = new SqlCommand(deleteClass, conn))
                    {
                        cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(classId));
                        cmd.ExecuteNonQuery();
                    }

                    ShowMessage("Class deleted successfully.", true);
                }
                catch (Exception ex)
                {
                    ShowMessage("Cannot delete this class: it may have related announcements, resources, or quizzes linked to it.", false);
                    System.Diagnostics.Debug.WriteLine(ex.Message);
                }
            }

            PanelEnrolment.Visible = false;
            LoadClasses();
        }

        // ===================== ENROLMENT =====================

        private void OpenEnrolmentPanel(string classId)
        {
            PanelClassForm.Visible = false;
            HiddenEnrolClassId.Value = classId;

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT ClassName FROM Classes WHERE ClassId = @ClassId";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(classId));
                    try
                    {
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        LblEnrolClassName.Text = result != null ? result.ToString() : "";
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading class: " + ex.Message, false);
                    }
                }
            }

            LoadEnrolledStudents(classId);
            LoadAvailableStudentsDropdown(classId);

            PanelEnrolment.Visible = true;
        }

        protected void BtnCloseEnrolment_Click(object sender, EventArgs e)
        {
            PanelEnrolment.Visible = false;
        }

        private void LoadEnrolledStudents(string classId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT SC.StudentClassId, U.FullName, U.Email, SC.EnrolledAt
                    FROM StudentClasses SC
                    INNER JOIN Users U ON SC.StudentId = U.UserId
                    WHERE SC.ClassId = @ClassId
                    ORDER BY U.FullName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(classId));

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();
                        da.Fill(dt);

                        if (dt.Rows.Count == 0)
                        {
                            RepeatEnrolledStudents.DataSource = null;
                            RepeatEnrolledStudents.DataBind();
                            PanelNoEnrolled.Visible = true;
                        }
                        else
                        {
                            PanelNoEnrolled.Visible = false;
                            RepeatEnrolledStudents.DataSource = dt;
                            RepeatEnrolledStudents.DataBind();
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading enrolled students: " + ex.Message, false);
                    }
                }
            }
        }

        private void LoadAvailableStudentsDropdown(string classId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                // Students (RoleId = 1) not already enrolled in this class
                string query = @"
                    SELECT UserId, FullName, Email
                    FROM Users
                    WHERE RoleId = 1
                      AND UserId NOT IN (SELECT StudentId FROM StudentClasses WHERE ClassId = @ClassId)
                    ORDER BY FullName";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(classId));

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();
                        da.Fill(dt);

                        DdlAddStudent.DataSource = dt;
                        DdlAddStudent.DataTextField = "FullName";
                        DdlAddStudent.DataValueField = "UserId";
                        DdlAddStudent.DataBind();

                        if (dt.Rows.Count == 0)
                        {
                            DdlAddStudent.Items.Insert(0, new ListItem("No students available", ""));
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading students: " + ex.Message, false);
                    }
                }
            }
        }

        protected void BtnAddStudentToClass_Click(object sender, EventArgs e)
        {
            string classId = HiddenEnrolClassId.Value;

            if (string.IsNullOrEmpty(DdlAddStudent.SelectedValue))
            {
                ShowMessage("Please select a student to enrol.", false);
                OpenEnrolmentPanel(classId);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "INSERT INTO StudentClasses (StudentId, ClassId) VALUES (@StudentId, @ClassId)";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@StudentId", SqlDbType.UniqueIdentifier).Value = new Guid(DdlAddStudent.SelectedValue);
                    cmd.Parameters.AddWithValue("@ClassId", Convert.ToInt32(classId));

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        ShowMessage("Student enrolled successfully.", true);
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error enrolling student: " + ex.Message, false);
                    }
                }
            }

            OpenEnrolmentPanel(classId);
            LoadClasses();
        }

        protected void RepeatEnrolledStudents_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Remove")
            {
                string studentClassId = e.CommandArgument.ToString();
                string classId = HiddenEnrolClassId.Value;

                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    string query = "DELETE FROM StudentClasses WHERE StudentClassId = @StudentClassId";

                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@StudentClassId", Convert.ToInt32(studentClassId));

                        try
                        {
                            conn.Open();
                            cmd.ExecuteNonQuery();
                            ShowMessage("Student removed from class.", true);
                        }
                        catch (Exception ex)
                        {
                            ShowMessage("Error removing student: " + ex.Message, false);
                        }
                    }
                }

                OpenEnrolmentPanel(classId);
                LoadClasses();
            }
        }

        // ===================== HELPERS =====================

        private void ShowMessage(string message, bool isSuccess)
        {
            LblMessage.Text = message;
            PanelMessage.CssClass = isSuccess ? "admin-inline-message success" : "admin-inline-message error";
            PanelMessage.Visible = true;
        }
    }
}
