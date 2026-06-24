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
    public partial class Student_Announcements : System.Web.UI.Page
    {
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathSQL"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Redirect if not logged in
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadLeftPanelAnnouncements();
            }
        }

        private void LoadLeftPanelAnnouncements()
        {
            string activeUserId = Session["UserId"].ToString();

            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sqlQuery = @"
                    SELECT 
                        A.AnnouncementId,
                        A.Title,
                        A.Message,
                        A.CreatedAt,
                        A.Status,
                        U.FullName AS TeacherName
                    FROM [Announcements] A
                    INNER JOIN [Users] U 
                        ON A.CreatedBy = U.UserId
                    INNER JOIN [StudentClasses] SC 
                        ON A.ClassId = SC.ClassId
                    WHERE SC.StudentId = @StudentId
                    ORDER BY A.CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(sqlQuery, con);
                cmd.Parameters.Add("@StudentId", SqlDbType.UniqueIdentifier).Value
                    = new Guid(activeUserId);

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();

                try
                {
                    con.Open();
                    da.Fill(dt);

                    repeatAnnouncements.DataSource = dt;
                    repeatAnnouncements.DataBind();

                    int unreadTotalCount = 0;
                    foreach (DataRow row in dt.Rows)
                    {
                        if (row["Status"] != DBNull.Value &&
                            Convert.ToBoolean(row["Status"]) == false)
                        {
                            unreadTotalCount++;
                        }
                    }

                    Label LabelSidebarCount = (Label)Master.FindControl("LabelUnreadCountSummary");
                    if (LabelSidebarCount != null)
                    {
                        LabelSidebarCount.Text = unreadTotalCount > 0
                            ? unreadTotalCount.ToString()
                            : "";
                    }
                }
                catch (Exception ex)
                {
                    rightPanelPlaceHolder.Visible = false;
                    rightPanelDetailView.Visible = true;
                    AnnouncementLabel.Text = "Database Connection Error";
                    AnnouncementMessage.Text = ex.Message;
                }
            }
        }

        protected void repeatAnnouncements_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName == "Select")
            {
                if (Session["UserId"] == null)
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }

                string activeUserId = Session["UserId"].ToString();
                int targetId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sqlQuery = @"
                        SELECT 
                            A.Title,
                            A.Message,
                            A.CreatedAt,
                            U.FullName AS TeacherName
                        FROM [Announcements] A
                        INNER JOIN [Users] U 
                            ON A.CreatedBy = U.UserId
                        INNER JOIN [StudentClasses] SC 
                            ON A.ClassId = SC.ClassId
                        WHERE A.AnnouncementId = @AnnId
                          AND SC.StudentId = @StudentId";

                    SqlCommand cmd = new SqlCommand(sqlQuery, con);
                    cmd.Parameters.AddWithValue("@AnnId", targetId);
                    cmd.Parameters.Add("@StudentId", SqlDbType.UniqueIdentifier).Value
                        = new Guid(activeUserId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    string updateQuery = @"
                        UPDATE [Announcements] 
                        SET Status = 1 
                        WHERE AnnouncementId = @AnnId";

                    SqlCommand updateCmd = new SqlCommand(updateQuery, con);
                    updateCmd.Parameters.AddWithValue("@AnnId", targetId);

                    try
                    {
                        con.Open();
                        updateCmd.ExecuteNonQuery();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            AnnouncementLabel.Text = dt.Rows[0]["Title"].ToString();
                            AnnouncementMessage.Text = dt.Rows[0]["Message"].ToString()
                                                             .Replace("\n", "<br />");
                            AnnouncementTeacherName.Text = dt.Rows[0]["TeacherName"].ToString();

                            DateTime postDate = Convert.ToDateTime(dt.Rows[0]["CreatedAt"]);
                            AnnouncementCreatedDate.Text = postDate.ToString("dd MMM yyyy");
                            AnnouncementCreatedTime.Text = postDate.ToString("h:mm tt");

                            rightPanelDetailView.Visible = true;
                            rightPanelPlaceHolder.Visible = false;
                        }
                        else
                        {
                            rightPanelPlaceHolder.Visible = false;
                            rightPanelDetailView.Visible = true;
                            AnnouncementLabel.Text = "Access Denied";
                            AnnouncementMessage.Text = "This announcement is not available for your class.";
                        }
                    }
                    catch (Exception ex)
                    {
                        rightPanelPlaceHolder.Visible = false;
                        rightPanelDetailView.Visible = true;
                        AnnouncementLabel.Text = "Selection Loading Error";
                        AnnouncementMessage.Text = ex.Message;
                    }
                }

                LoadLeftPanelAnnouncements();
            }
        }

        protected void left_announcements(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item ||
                e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;

                Label LabelLeftTitle = (Label)e.Item.FindControl("LabelLeftTitle");
                Label LabelLeftTeacher = (Label)e.Item.FindControl("LabelLeftTeacher");
                Label labelLeftDate = (Label)e.Item.FindControl("labelLeftDate");
                Panel PanelStatusDot = (Panel)e.Item.FindControl("PanelStatusDot");

                if (LabelLeftTitle != null)
                    LabelLeftTitle.Text = row["Title"].ToString();

                if (LabelLeftTeacher != null)
                    LabelLeftTeacher.Text = row["TeacherName"].ToString();

                if (labelLeftDate != null)
                {
                    DateTime postDate = Convert.ToDateTime(row["CreatedAt"]);
                    labelLeftDate.Text = postDate.ToString("dd MMM yyyy");
                }

                if (PanelStatusDot != null && row["Status"] != DBNull.Value)
                {
                    bool isRead = Convert.ToBoolean(row["Status"]);
                    PanelStatusDot.Visible = !isRead;
                }
            }
        }
    }
}