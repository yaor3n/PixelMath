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
		protected void Page_Load(object sender, EventArgs e)
		{
			if (!Page.IsPostBack)
			{
				string connStr = ConfigurationManager.ConnectionStrings["PixelMathDB"].ConnectionString;
				using (SqlConnection con = new SqlConnection(connStr))
				{
					string sqlQuery = @"SELECT A.Title, A.Message, A.CreatedAt, U.FullName AS TeacherName FROM [Announcements]A INNER JOIN [Users]U ON A.CreatedBy=U.UserId  ";

					SqlDataAdapter da = new SqlDataAdapter(sqlQuery, con);
					DataTable dt = new DataTable();

					try
					{
						con.Open();
						da.Fill(dt);

						if (dt.Rows.Count > 0)
						{
							AnnouncementLabel.Text = dt.Rows[0]["Title"].ToString();
							AnnouncementMessage.Text = dt.Rows[0]["Message"].ToString();
							AnnouncementTeacherName.Text = dt.Rows[0]["TeacherName"].ToString();
							DateTime postDate = Convert.ToDateTime(dt.Rows[0]["CreatedAt"]);
							AnnouncementCreatedDate.Text = postDate.ToString("dd MMM yyyy");
						}
						else
						{
							AnnouncementLabel.Text = "No Announcements Found";
							AnnouncementMessage.Text = "There are currently no active system notifications.";
							AnnouncementTeacherName.Text = "-";
							AnnouncementCreatedDate.Text = "-";

                        }
					}
					catch (Exception ex)
					{
						AnnouncementLabel.Text = "Database Connection Error";
						AnnouncementMessage.Text = ex.Message;
						AnnouncementTeacherName.Text = "Error";
						AnnouncementCreatedDate.Text = "-";

                    }
				}
			}
		}
	}
}