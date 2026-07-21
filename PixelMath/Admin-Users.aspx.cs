using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Admin_Users : System.Web.UI.Page
    {
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
                LoadUsers();
            }
        }

        // ===================== LIST / SEARCH =====================

        private void LoadUsers()
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT U.UserId, U.FullName, U.Email, U.Form, U.CreatedAt, R.RoleName, R.RoleId
                    FROM Users U
                    INNER JOIN Roles R ON U.RoleId = R.RoleId
                    WHERE (@Search = '' OR U.FullName LIKE '%' + @Search + '%' OR U.Email LIKE '%' + @Search + '%')
                      AND (@RoleFilter = 0 OR U.RoleId = @RoleFilter)
                    ORDER BY U.CreatedAt DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Search", TxtSearch.Text.Trim());
                    cmd.Parameters.AddWithValue("@RoleFilter", Convert.ToInt32(DdlRoleFilter.SelectedValue));

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();
                        da.Fill(dt);

                        if (dt.Rows.Count == 0)
                        {
                            RepeatUsers.DataSource = null;
                            RepeatUsers.DataBind();
                            PanelNoUsers.Visible = true;
                        }
                        else
                        {
                            PanelNoUsers.Visible = false;
                            RepeatUsers.DataSource = dt;
                            RepeatUsers.DataBind();
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading users: " + ex.Message, false);
                    }
                }
            }
        }

        protected void FilterChanged(object sender, EventArgs e)
        {
            LoadUsers();
        }

        protected void RepeatUsers_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;
                Label lblRoleBadge = (Label)e.Item.FindControl("LblRoleBadge");

                if (lblRoleBadge != null)
                {
                    int roleId = Convert.ToInt32(row["RoleId"]);
                    lblRoleBadge.Text = row["RoleName"].ToString();

                    switch (roleId)
                    {
                        case 3:
                            lblRoleBadge.CssClass = "role-badge role-badge-admin";
                            break;
                        case 2:
                            lblRoleBadge.CssClass = "role-badge role-badge-lecturer";
                            break;
                        default:
                            lblRoleBadge.CssClass = "role-badge role-badge-student";
                            break;
                    }
                }
            }
        }

        // ===================== ADD / EDIT FORM =====================

        protected void BtnAddUser_Click(object sender, EventArgs e)
        {
            ResetForm();
            PanelMessage.Visible = false;

            LblFormTitle.Text = "Add New User";
            LblPasswordHint.Text = "Password";
            LblPasswordEditHint.Visible = false;

            BtnSaveUser.Text = "Create User";

            ReqPassword.Enabled = true;
            ReqConfirmPassword.Enabled = true;

            PanelUserForm.Visible = true;
        }

        protected void BtnCancelForm_Click(object sender, EventArgs e)
        {
            PanelUserForm.Visible = false;
            ResetForm();
        }

        private void ResetForm()
        {
            HiddenUserId.Value = string.Empty;

            TxtFullName.Text = string.Empty;
            TxtEmail.Text = string.Empty;
            TxtForm.Text = string.Empty;
            TxtPassword.Text = string.Empty;
            TxtConfirmPassword.Text = string.Empty;
            DdlRole.SelectedValue = "1";
        }

        protected void RepeatUsers_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string targetUserId = e.CommandArgument.ToString();

            if (e.CommandName == "Edit")
            {
                LoadUserIntoForm(targetUserId);
            }
            else if (e.CommandName == "Delete")
            {
                DeleteUser(targetUserId);
            }
        }

        private void LoadUserIntoForm(string userId)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "SELECT FullName, Email, RoleId, Form FROM Users WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = new Guid(userId);

                    try
                    {
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                HiddenUserId.Value = userId;
                                TxtFullName.Text = reader["FullName"].ToString();
                                TxtEmail.Text = reader["Email"].ToString();
                                DdlRole.SelectedValue = reader["RoleId"].ToString();
                                TxtForm.Text = reader["Form"] != DBNull.Value ? reader["Form"].ToString() : "";
                                TxtPassword.Text = "";

                                TxtConfirmPassword.Text = "";
                                LblFormTitle.Text = "Edit User";
                                LblPasswordHint.Text = "New Password";
                                LblPasswordEditHint.Visible = true;
                                BtnSaveUser.Text = "Save Changes";
                                ReqPassword.Enabled = false;
                                ReqConfirmPassword.Enabled = false;
                                PanelUserForm.Visible = true;
                            }
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage("Error loading user: " + ex.Message, false);
                    }
                }
            }
        }

        protected void BtnSaveUser_Click(object sender, EventArgs e)
        {
            if (!Page.IsValid)
            {
                PanelUserForm.Visible = true;
                return;
            }

            bool isEditMode = !string.IsNullOrEmpty(HiddenUserId.Value);
            string fullName = TxtFullName.Text.Trim();
            string email = TxtEmail.Text.Trim();
            string password = TxtPassword.Text;
            string confirmPassword = TxtConfirmPassword.Text;
            int roleId = Convert.ToInt32(DdlRole.SelectedValue);

            // Password is compulsory when creating a new user.
            if (!isEditMode && string.IsNullOrWhiteSpace(password))
            {
                ShowMessage("Password is required for new users.", false);
                PanelUserForm.Visible = true;

                return;
            }

            // Validate password confirmation when either field contains a value.
            if (!string.IsNullOrWhiteSpace(password) ||
                !string.IsNullOrWhiteSpace(confirmPassword))
            {
                if (password != confirmPassword)
                {
                    ShowMessage(

                        "Password and confirm password do not match.",

                        false

                    );
                    PanelUserForm.Visible = true;

                    return;
                }
            }

            // Form level is only stored for students.
            object formValue = DBNull.Value;

            if (roleId == 1 && !string.IsNullOrWhiteSpace(TxtForm.Text))
            {
                int form;

                if (!int.TryParse(TxtForm.Text.Trim(), out form))

                {
                    ShowMessage("Form level must be a valid number.", false);
                    PanelUserForm.Visible = true;

                    return;
                }
                formValue = form;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                try
                {
                    conn.Open();

                    if (isEditMode)
                    {
                        // Update, only touching PasswordHash if a new password was supplied
                        string query = string.IsNullOrWhiteSpace(TxtPassword.Text)
                            ? @"UPDATE Users SET FullName = @FullName, Email = @Email, RoleId = @RoleId, Form = @Form
                                WHERE UserId = @UserId"
                            : @"UPDATE Users SET FullName = @FullName, Email = @Email, RoleId = @RoleId, Form = @Form, PasswordHash = @PasswordHash
                                WHERE UserId = @UserId";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@FullName", fullName);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@RoleId", roleId);
                            cmd.Parameters.AddWithValue("@Form", formValue);
                            cmd.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = new Guid(HiddenUserId.Value);

                            if (!string.IsNullOrWhiteSpace(TxtPassword.Text))
                            {
                                cmd.Parameters.AddWithValue("@PasswordHash", ComputeSha256Hash(TxtPassword.Text));
                            }

                            cmd.ExecuteNonQuery();
                        }

                        ShowMessage("User updated successfully.", true);
                    }
                    else
                    {
                        string query = @"
                            INSERT INTO Users (FullName, Email, PasswordHash, RoleId, IsApproved, Form)
                            VALUES (@FullName, @Email, @PasswordHash, @RoleId, 1, @Form)";

                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@FullName", fullName);
                            cmd.Parameters.AddWithValue("@Email", email);
                            cmd.Parameters.AddWithValue("@PasswordHash", ComputeSha256Hash(TxtPassword.Text));
                            cmd.Parameters.AddWithValue("@RoleId", roleId);
                            cmd.Parameters.AddWithValue("@Form", formValue);

                            cmd.ExecuteNonQuery();
                        }

                        ShowMessage("User added successfully.", true);
                    }

                    PanelUserForm.Visible = false;
                    ResetForm();
                    LoadUsers();
                }
                catch (SqlException ex)
                {
                    if (ex.Number == 2601 || ex.Number == 2627)
                    {
                        ShowMessage(
                            "This email is already registered to another account.",
                            false
                        );

                        PanelUserForm.Visible = true;
                    }
                    else
                    {
                        ShowMessage("Error saving user: " + ex.Message, false);
                        PanelUserForm.Visible = true;
                    }
                }
                catch (Exception ex)
                {
                    ShowMessage("Error saving user: " + ex.Message, false);
                    PanelUserForm.Visible = true;
                }
            }
        }

        private void DeleteUser(string userId)
        {
            // Prevent an admin from deleting their own active account
            if (Session["UserId"] != null && Session["UserId"].ToString() == userId)
            {
                ShowMessage("You cannot delete your own account while logged in.", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = "DELETE FROM Users WHERE UserId = @UserId";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add("@UserId", SqlDbType.UniqueIdentifier).Value = new Guid(userId);

                    try
                    {
                        conn.Open();
                        cmd.ExecuteNonQuery();
                        ShowMessage("User deleted successfully.", true);
                    }
                    catch (Exception ex)
                    {
                        // Likely a foreign key constraint (user has classes/quizzes/attempts linked)
                        ShowMessage("Cannot delete this user: they have related records (classes, quizzes, or attempts) linked to their account.", false);
                        System.Diagnostics.Debug.WriteLine(ex.Message);
                    }
                }
            }

            LoadUsers();
        }

        // ===================== HELPERS =====================

        private void ShowMessage(string message, bool isSuccess)
        {
            LblMessage.Text = message;
            PanelMessage.CssClass = isSuccess ? "admin-inline-message success" : "admin-inline-message error";
            PanelMessage.Visible = true;
        }

        private string ComputeSha256Hash(string rawData)
        {
            using (System.Security.Cryptography.SHA256 sha256Hash = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(System.Text.Encoding.UTF8.GetBytes(rawData));
                System.Text.StringBuilder builder = new System.Text.StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
