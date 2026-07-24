using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace PixelMath
{
    public partial class Admin_Activity_Logs : Page
    {
        private readonly string connStr =
            ConfigurationManager
                .ConnectionStrings["PixelMathSQL"]
                .ConnectionString;

        protected void Page_Load(
            object sender,
            EventArgs e)
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
                LoadActivityLogs();
            }
        }

        private void LoadActivityLogs()
        {
            string searchText =
                TxtSearch.Text.Trim();

            string actionFilter =
                DdlActionFilter.SelectedValue;

            string entityFilter =
                DdlEntityFilter.SelectedValue;

            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        L.LogId,
                        L.UserId,
                        L.ActionType,
                        L.Description,
                        L.EntityType,
                        L.EntityId,
                        L.CreatedAt,

                        ISNULL(
                            U.FullName,
                            'Deleted or Unknown User'
                        ) AS UserName,

                        ISNULL(
                            U.Email,
                            ''
                        ) AS UserEmail

                    FROM ActivityLogs L

                    LEFT JOIN Users U
                        ON L.UserId = U.UserId

                    WHERE
                        (
                            @Search = ''
                            OR L.Description LIKE
                                '%' + @Search + '%'
                            OR L.ActionType LIKE
                                '%' + @Search + '%'
                            OR L.EntityType LIKE
                                '%' + @Search + '%'
                            OR U.FullName LIKE
                                '%' + @Search + '%'
                            OR U.Email LIKE
                                '%' + @Search + '%'
                        )

                        AND
                        (
                            @ActionFilter = ''
                            OR L.ActionType =
                                @ActionFilter
                        )

                        AND
                        (
                            @EntityFilter = ''
                            OR L.EntityType =
                                @EntityFilter
                        )

                    ORDER BY
                        L.CreatedAt DESC,
                        L.LogId DESC";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.NVarChar,
                        200
                    ).Value = searchText;

                    cmd.Parameters.Add(
                        "@ActionFilter",
                        SqlDbType.VarChar,
                        50
                    ).Value = actionFilter;

                    cmd.Parameters.Add(
                        "@EntityFilter",
                        SqlDbType.VarChar,
                        50
                    ).Value = entityFilter;

                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();

                        using (SqlDataAdapter da =
                            new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        RepeatActivityLogs.DataSource = dt;
                        RepeatActivityLogs.DataBind();

                        RepeatActivityLogs.Visible =
                            dt.Rows.Count > 0;

                        PanelNoLogs.Visible =
                            dt.Rows.Count == 0;
                    }
                    catch (Exception ex)
                    {
                        RepeatActivityLogs.DataSource = null;
                        RepeatActivityLogs.DataBind();
                        RepeatActivityLogs.Visible = false;

                        PanelNoLogs.Visible = true;

                        ShowMessage(
                            "Error loading activity logs: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }
        }

        protected void FilterChanged(
            object sender,
            EventArgs e)
        {
            LoadActivityLogs();
        }

        protected string FormatLogDate(
            object dateValue)
        {
            if (dateValue == null ||
                dateValue == DBNull.Value)
            {
                return "—";
            }

            DateTime logDate;

            if (DateTime.TryParse(
                dateValue.ToString(),
                out logDate))
            {
                return logDate.ToString(
                    "dd MMM yyyy, hh:mm tt"
                );
            }

            return "—";
        }

        protected string GetActionCss(
            object actionValue)
        {
            string action =
                actionValue == null ||
                actionValue == DBNull.Value
                    ? ""
                    : actionValue
                        .ToString()
                        .Trim()
                        .ToLower();

            switch (action)
            {
                case "create":
                    return
                        "activity-action-badge activity-action-create";

                case "update":
                    return
                        "activity-action-badge activity-action-update";

                case "delete":
                    return
                        "activity-action-badge activity-action-delete";

                case "approve":
                    return
                        "activity-action-badge activity-action-approve";

                case "reject":
                    return
                        "activity-action-badge activity-action-reject";

                case "publish":
                    return
                        "activity-action-badge activity-action-publish";

                case "hide":
                    return
                        "activity-action-badge activity-action-hide";

                case "login":
                case "logout":
                    return
                        "activity-action-badge activity-action-session";

                default:
                    return
                        "activity-action-badge activity-action-default";
            }
        }

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