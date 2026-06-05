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
        private string connStr = ConfigurationManager.ConnectionStrings["PixelMathDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
		{
            LoadLeftPanelAnnouncements();
		}

        private void LoadLeftPanelAnnouncements()
        {
            using (SqlConnection con = new SqlConnection(connStr))
            {
                string sqlQuery = @"SELECT A.AnnouncementId, A.Title, A.Message, A.CreatedAt, U.FullName AS TeacherName FROM [Announcements] A INNER JOIN [Users] U ON A.CreatedBy=U.UserId";

                SqlDataAdapter da = new SqlDataAdapter(sqlQuery, con);
                DataTable dt = new DataTable();

                try
                {
                    con.Open();
                    da.Fill(dt);

                    repeatAnnouncements.DataSource = dt;
                    repeatAnnouncements.DataBind();
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
                int targetId = Convert.ToInt32(e.CommandArgument);

                using (SqlConnection con = new SqlConnection(connStr))
                {
                    string sqlQuery = @"SELECT A.Title, A.Message, A.CreatedAt, U.FullName AS TeacherName FROM [Announcements] A INNER JOIN [Users] U ON A.CreatedBy = U.UserId WHERE A.AnnouncementId = @AnnId";

                    SqlCommand cmd = new SqlCommand(sqlQuery, con);
                    cmd.Parameters.AddWithValue("@AnnId", targetId);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();

                    try
                    {
                        con.Open();
                        da.Fill(dt);

                        if (dt.Rows.Count > 0)
                        {
                            AnnouncementLabel.Text = dt.Rows[0]["Title"].ToString();
                            AnnouncementMessage.Text = dt.Rows[0]["Message"].ToString().Replace("\n", "<br />");
                            AnnouncementTeacherName.Text = dt.Rows[0]["TeacherName"].ToString();

                            DateTime postDate = Convert.ToDateTime(dt.Rows[0]["CreatedAt"]);
                            AnnouncementCreatedDate.Text = postDate.ToString("dd MMM yyyy");
                            AnnouncementCreatedTime.Text = postDate.ToString("h:mm tt");

                            rightPanelDetailView.Visible = true;      
                            rightPanelPlaceHolder.Visible = false;    // Hides the "Select an item" message box window
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
            }
        }

        protected void left_announcements(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView row = (DataRowView)e.Item.DataItem;

                Label LabelLeftTitle = (Label)e.Item.FindControl("LabelLeftTitle");
                Label LabelLeftTeacher = (Label)e.Item.FindControl("LabelLeftTeacher");
                Label labelLeftDate = (Label)e.Item.FindControl("labelLeftDate");

                if (LabelLeftTitle != null)
                    LabelLeftTitle.Text = row["Title"].ToString();

                if (LabelLeftTeacher != null)
                    LabelLeftTeacher.Text = row["TeacherName"].ToString();

                if (labelLeftDate != null)
                {
                    DateTime postDate = Convert.ToDateTime(row["CreatedAt"]);
                    labelLeftDate.Text = postDate.ToString("dd MMM yyyy");
                }
            }
        }
    }
}


