using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Admin_Announcements : Page
    {
        private readonly string connStr =
            ConfigurationManager
                .ConnectionStrings["PixelMathSQL"]
                .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null ||
                Session["RoleId"] == null ||
                Session["RoleId"].ToString() != "3")
            {
                Session.Clear();
                Session.Abandon();

                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadClassDropdowns();
                ResetAnnouncementForm();
                LoadAnnouncements();
            }
        }

        // ===================== CLASS DROPDOWNS =====================

        private void LoadClassDropdowns()
        {
            DataTable classTable = new DataTable();

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        ClassId,
                        ClassName
                    FROM Classes
                    ORDER BY ClassName ASC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();

                        using (SqlDataAdapter da =
                            new SqlDataAdapter(cmd))
                        {
                            da.Fill(classTable);
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage(
                            "Error loading classes: " +
                            ex.Message,
                            false
                        );

                        return;
                    }
                }
            }

            DdlTargetClass.DataSource = classTable;
            DdlTargetClass.DataTextField = "ClassName";
            DdlTargetClass.DataValueField = "ClassId";
            DdlTargetClass.DataBind();

            DdlTargetClass.Items.Insert(
                0,
                new ListItem(
                    "All Users",
                    "0"
                )
            );

            DdlClassFilter.DataSource = classTable;
            DdlClassFilter.DataTextField = "ClassName";
            DdlClassFilter.DataValueField = "ClassId";
            DdlClassFilter.DataBind();

            DdlClassFilter.Items.Insert(
                0,
                new ListItem(
                    "All Audiences",
                    "-1"
                )
            );

            DdlClassFilter.Items.Insert(
                1,
                new ListItem(
                    "All Users Only",
                    "0"
                )
            );
        }

        // ===================== LOAD ANNOUNCEMENTS =====================

        private void LoadAnnouncements()
        {
            string searchText = TxtSearch.Text.Trim();

            int classFilter = -1;
            int statusFilter = -1;

            int.TryParse(
                DdlClassFilter.SelectedValue,
                out classFilter
            );

            int.TryParse(
                DdlStatusFilter.SelectedValue,
                out statusFilter
            );

            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        A.AnnouncementId,
                        A.Title,
                        A.Message,
                        A.ClassId,
                        A.CreatedBy,
                        A.CreatedAt,
                        A.Status,

                        CASE
                            WHEN A.ClassId IS NULL
                                THEN 'All Users'
                            ELSE C.ClassName
                        END AS AudienceName,

                        ISNULL(
                            U.FullName,
                            'Unknown Administrator'
                        ) AS CreatedByName

                    FROM Announcements A

                    LEFT JOIN Classes C
                        ON A.ClassId = C.ClassId

                    LEFT JOIN Users U
                        ON A.CreatedBy = U.UserId

                    WHERE
                        (
                            @Search = ''
                            OR A.Title LIKE '%' + @Search + '%'
                            OR A.Message LIKE '%' + @Search + '%'
                        )

                        AND
                        (
                            @StatusFilter = -1
                            OR A.Status = @StatusFilter
                        )

                        AND
                        (
                            @ClassFilter = -1

                            OR
                            (
                                @ClassFilter = 0
                                AND A.ClassId IS NULL
                            )

                            OR
                            (
                                @ClassFilter > 0
                                AND A.ClassId = @ClassFilter
                            )
                        )

                    ORDER BY A.CreatedAt DESC,
                             A.AnnouncementId DESC";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        200
                    ).Value = searchText;

                    cmd.Parameters.Add(
                        "@ClassFilter",
                        SqlDbType.Int
                    ).Value = classFilter;

                    cmd.Parameters.Add(
                        "@StatusFilter",
                        SqlDbType.Int
                    ).Value = statusFilter;

                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();

                        using (SqlDataAdapter da =
                            new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        RepeatAnnouncements.DataSource = dt;
                        RepeatAnnouncements.DataBind();

                        RepeatAnnouncements.Visible =
                            dt.Rows.Count > 0;

                        PanelNoAnnouncements.Visible =
                            dt.Rows.Count == 0;
                    }
                    catch (Exception ex)
                    {
                        RepeatAnnouncements.DataSource = null;
                        RepeatAnnouncements.DataBind();
                        RepeatAnnouncements.Visible = false;

                        PanelNoAnnouncements.Visible = true;

                        ShowMessage(
                            "Error loading announcements: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }
        }

        protected void AnnouncementFilterChanged(
            object sender,
            EventArgs e)
        {
            LoadAnnouncements();
        }

        // ===================== CREATE / UPDATE =====================

        protected void BtnSaveAnnouncement_Click(
            object sender,
            EventArgs e)
        {
            if (!Page.IsValid)
            {
                return;
            }

            string title = TxtTitle.Text.Trim();
            string message = TxtMessage.Text.Trim();

            int selectedClassId = 0;
            int selectedStatus = 1;

            int.TryParse(
                DdlTargetClass.SelectedValue,
                out selectedClassId
            );

            int.TryParse(
                DdlStatus.SelectedValue,
                out selectedStatus
            );

            bool isEditMode =
                !string.IsNullOrWhiteSpace(
                    HiddenAnnouncementId.Value
                );

            Guid adminId;

            if (!Guid.TryParse(
                Session["UserId"].ToString(),
                out adminId))
            {
                ShowMessage(
                    "Unable to identify the logged-in administrator.",
                    false
                );

                return;
            }

            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query;

                if (isEditMode)
                {
                    query = @"
                        UPDATE Announcements

                        SET
                            Title = @Title,
                            Message = @Message,
                            ClassId = @ClassId,
                            Status = @Status

                        WHERE
                            AnnouncementId =
                            @AnnouncementId";
                }
                else
                {
                    query = @"
                        INSERT INTO Announcements
                        (
                            Title,
                            Message,
                            ClassId,
                            CreatedBy,
                            CreatedAt,
                            Status
                        )

                        VALUES
                        (
                            @Title,
                            @Message,
                            @ClassId,
                            @CreatedBy,
                            GETDATE(),
                            @Status
                        )";
                }

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@Title",
                        SqlDbType.VarChar,
                        200
                    ).Value = title;

                    cmd.Parameters.Add(
                        "@Message",
                        SqlDbType.NVarChar,
                        -1
                    ).Value = message;

                    cmd.Parameters.Add(
                        "@ClassId",
                        SqlDbType.Int
                    ).Value = selectedClassId == 0
                        ? (object)DBNull.Value
                        : selectedClassId;

                    cmd.Parameters.Add(
                        "@Status",
                        SqlDbType.Bit
                    ).Value = selectedStatus == 1;

                    if (isEditMode)
                    {
                        int announcementId;

                        if (!int.TryParse(
                            HiddenAnnouncementId.Value,
                            out announcementId))
                        {
                            ShowMessage(
                                "Invalid announcement ID.",
                                false
                            );

                            return;
                        }

                        cmd.Parameters.Add(
                            "@AnnouncementId",
                            SqlDbType.Int
                        ).Value = announcementId;
                    }
                    else
                    {
                        cmd.Parameters.Add(
                            "@CreatedBy",
                            SqlDbType.UniqueIdentifier
                        ).Value = adminId;
                    }

                    try
                    {
                        conn.Open();

                        int rowsAffected =
                            cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage(
                                isEditMode
                                    ? "Announcement updated successfully."
                                    : "Announcement created successfully.",
                                true
                            );

                            ResetAnnouncementForm();
                            LoadAnnouncements();
                        }
                        else
                        {
                            ShowMessage(
                                "The announcement was not saved.",
                                false
                            );
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage(
                            "Error saving announcement: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }
        }

        // ===================== REPEATER COMMANDS =====================

        protected void RepeatAnnouncements_ItemCommand(
            object source,
            RepeaterCommandEventArgs e)
        {
            int announcementId;

            if (!int.TryParse(
                e.CommandArgument.ToString(),
                out announcementId))
            {
                ShowMessage(
                    "Invalid announcement ID.",
                    false
                );

                return;
            }

            if (e.CommandName == "EditAnnouncement")
            {
                LoadAnnouncementIntoForm(
                    announcementId
                );
            }
            else if (e.CommandName == "ToggleStatus")
            {
                ToggleAnnouncementStatus(
                    announcementId
                );
            }
            else if (
                e.CommandName ==
                "DeleteAnnouncement")
            {
                DeleteAnnouncement(
                    announcementId
                );
            }
        }

        private void LoadAnnouncementIntoForm(
            int announcementId)
        {
            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        AnnouncementId,
                        Title,
                        Message,
                        ClassId,
                        Status
                    FROM Announcements
                    WHERE AnnouncementId =
                        @AnnouncementId";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@AnnouncementId",
                        SqlDbType.Int
                    ).Value = announcementId;

                    try
                    {
                        conn.Open();

                        using (SqlDataReader reader =
                            cmd.ExecuteReader())
                        {
                            if (!reader.Read())
                            {
                                ShowMessage(
                                    "Announcement not found.",
                                    false
                                );

                                return;
                            }

                            HiddenAnnouncementId.Value =
                                reader[
                                    "AnnouncementId"
                                ].ToString();

                            TxtTitle.Text =
                                reader["Title"].ToString();

                            TxtMessage.Text =
                                reader["Message"].ToString();

                            string classValue =
                                reader["ClassId"] ==
                                DBNull.Value
                                    ? "0"
                                    : reader[
                                        "ClassId"
                                    ].ToString();

                            if (
                                DdlTargetClass.Items
                                    .FindByValue(
                                        classValue
                                    ) != null)
                            {
                                DdlTargetClass.SelectedValue =
                                    classValue;
                            }

                            bool isPublished =
                                reader["Status"] !=
                                DBNull.Value &&
                                Convert.ToBoolean(
                                    reader["Status"]
                                );

                            DdlStatus.SelectedValue =
                                isPublished
                                    ? "1"
                                    : "0";

                            LblFormTitle.Text =
                                "Edit Announcement";

                            BtnSaveAnnouncement.Text =
                                "Save Changes";

                            BtnCancelEdit.Visible = true;
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage(
                            "Error loading announcement: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }
        }

        private void ToggleAnnouncementStatus(
            int announcementId)
        {
            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    UPDATE Announcements

                    SET Status =
                        CASE
                            WHEN Status = 1
                                THEN 0
                            ELSE 1
                        END

                    WHERE AnnouncementId =
                        @AnnouncementId";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@AnnouncementId",
                        SqlDbType.Int
                    ).Value = announcementId;

                    try
                    {
                        conn.Open();

                        int rowsAffected =
                            cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage(
                                "Announcement status updated.",
                                true
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Announcement not found.",
                                false
                            );
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage(
                            "Error updating announcement status: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }

            LoadAnnouncements();
        }

        private void DeleteAnnouncement(
            int announcementId)
        {
            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    DELETE FROM Announcements
                    WHERE AnnouncementId =
                        @AnnouncementId";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@AnnouncementId",
                        SqlDbType.Int
                    ).Value = announcementId;

                    try
                    {
                        conn.Open();

                        int rowsAffected =
                            cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage(
                                "Announcement deleted successfully.",
                                true
                            );

                            if (
                                HiddenAnnouncementId.Value ==
                                announcementId.ToString())
                            {
                                ResetAnnouncementForm();
                            }
                        }
                        else
                        {
                            ShowMessage(
                                "Announcement not found.",
                                false
                            );
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage(
                            "Error deleting announcement: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }

            LoadAnnouncements();
        }

        protected void BtnCancelEdit_Click(
            object sender,
            EventArgs e)
        {
            ResetAnnouncementForm();
        }

        private void ResetAnnouncementForm()
        {
            HiddenAnnouncementId.Value =
                string.Empty;

            TxtTitle.Text = string.Empty;
            TxtMessage.Text = string.Empty;

            if (
                DdlTargetClass.Items.Count > 0)
            {
                DdlTargetClass.SelectedValue =
                    "0";
            }

            DdlStatus.SelectedValue = "1";

            LblFormTitle.Text =
                "Create Announcement";

            BtnSaveAnnouncement.Text =
                "Publish Announcement";

            BtnCancelEdit.Visible = false;
        }

        // ===================== DISPLAY HELPERS =====================

        protected string GetAnnouncementStatusCss(
            object statusValue)
        {
            bool isPublished =
                statusValue != null &&
                statusValue != DBNull.Value &&
                Convert.ToBoolean(statusValue);

            return isPublished
                ? "status-badge status-badge-approved"
                : "status-badge status-badge-hidden";
        }

        protected string GetAnnouncementStatusText(
            object statusValue)
        {
            bool isPublished =
                statusValue != null &&
                statusValue != DBNull.Value &&
                Convert.ToBoolean(statusValue);

            return isPublished
                ? "Published"
                : "Hidden";
        }

        protected string GetToggleButtonCss(
            object statusValue)
        {
            bool isPublished =
                statusValue != null &&
                statusValue != DBNull.Value &&
                Convert.ToBoolean(statusValue);

            return isPublished
                ? "btn-admin-action btn-announcement-hide"
                : "btn-admin-action btn-announcement-publish";
        }

        protected string GetToggleButtonText(
            object statusValue)
        {
            bool isPublished =
                statusValue != null &&
                statusValue != DBNull.Value &&
                Convert.ToBoolean(statusValue);

            return isPublished
                ? "Hide"
                : "Publish";
        }

        protected string GetToggleButtonIcon(
            object statusValue)
        {
            bool isPublished =
                statusValue != null &&
                statusValue != DBNull.Value &&
                Convert.ToBoolean(statusValue);

            return isPublished
                ? "fa-solid fa-eye-slash"
                : "fa-solid fa-eye";
        }

        protected string FormatAnnouncementDate(
            object createdAt)
        {
            if (
                createdAt == null ||
                createdAt == DBNull.Value)
            {
                return "—";
            }

            DateTime date;

            if (DateTime.TryParse(
                createdAt.ToString(),
                out date))
            {
                return date.ToString(
                    "dd MMM yyyy"
                );
            }

            return "—";
        }

        // ===================== MESSAGE =====================

        private void ShowMessage(
            string message,
            bool isSuccess)
        {
            LblMessage.Text = message;

            PanelMessage.CssClass =
                isSuccess
                    ? "admin-inline-message success admin-page-message"
                    : "admin-inline-message error admin-page-message";

            PanelMessage.Visible = true;
        }
    }
}