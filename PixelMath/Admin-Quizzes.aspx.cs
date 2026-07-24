using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace PixelMath
{
    public partial class Admin_Quizzes : Page
    {
        private readonly string connStr =
            ConfigurationManager
                .ConnectionStrings["PixelMathSQL"]
                .ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // Only administrators may access this page.
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
                LoadClassFilter();
                LoadQuizzes();
            }
        }

        // ===================== CLASS FILTER =====================

        private void LoadClassFilter()
        {
            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        ClassId,
                        ClassName
                    FROM Classes
                    ORDER BY ClassName ASC";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    try
                    {
                        conn.Open();

                        using (SqlDataReader reader =
                            cmd.ExecuteReader())
                        {
                            DdlClassFilter.DataSource = reader;
                            DdlClassFilter.DataTextField =
                                "ClassName";
                            DdlClassFilter.DataValueField =
                                "ClassId";
                            DdlClassFilter.DataBind();
                        }

                        DdlClassFilter.Items.Insert(
                            0,
                            new ListItem(
                                "All Classes",
                                "0"
                            )
                        );
                    }
                    catch (Exception ex)
                    {
                        ShowMessage(
                            "Error loading classes: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }
        }

        // ===================== LOAD QUIZZES =====================

        private void LoadQuizzes()
        {
            string searchTerm =
                TxtQuizSearch.Text.Trim();

            int selectedClassId = 0;

            int.TryParse(
                DdlClassFilter.SelectedValue,
                out selectedClassId
            );

            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    SELECT
                        Q.QuizId,
                        Q.Title,
                        Q.DurationMinutes,
                        Q.PassingMarks,
                        Q.CreatedAt,
                        C.ClassName,
                        ISNULL(U.FullName, 'Unknown Lecturer')
                            AS CreatedByName
                    FROM Quizzes Q
                    INNER JOIN Classes C
                        ON Q.ClassId = C.ClassId
                    LEFT JOIN Users U
                        ON Q.CreatedBy = U.UserId
                    WHERE
                        (
                            @Search = ''
                            OR Q.Title LIKE '%' + @Search + '%'
                        )
                        AND
                        (
                            @ClassId = 0
                            OR Q.ClassId = @ClassId
                        )
                    ORDER BY Q.CreatedAt DESC";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@Search",
                        SqlDbType.VarChar,
                        150
                    ).Value = searchTerm;

                    cmd.Parameters.Add(
                        "@ClassId",
                        SqlDbType.Int
                    ).Value = selectedClassId;

                    DataTable dt = new DataTable();

                    try
                    {
                        conn.Open();

                        using (SqlDataAdapter da =
                            new SqlDataAdapter(cmd))
                        {
                            da.Fill(dt);
                        }

                        RepeatQuizzes.DataSource = dt;
                        RepeatQuizzes.DataBind();

                        RepeatQuizzes.Visible =
                            dt.Rows.Count > 0;

                        PanelNoQuizzes.Visible =
                            dt.Rows.Count == 0;
                    }
                    catch (Exception ex)
                    {
                        RepeatQuizzes.DataSource = null;
                        RepeatQuizzes.DataBind();
                        RepeatQuizzes.Visible = false;

                        PanelNoQuizzes.Visible = true;

                        ShowMessage(
                            "Error loading quizzes: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }
        }

        // ===================== SEARCH / FILTER =====================

        protected void BtnSearch_Click(
            object sender,
            EventArgs e)
        {
            LoadQuizzes();
        }

        protected void DdlClassFilter_SelectedIndexChanged(
            object sender,
            EventArgs e)
        {
            LoadQuizzes();
        }

        // ===================== DELETE QUIZ =====================

        protected void RepeatQuizzes_ItemCommand(
            object source,
            RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "DeleteQuiz")
            {
                return;
            }

            int quizId;

            if (!int.TryParse(
                e.CommandArgument.ToString(),
                out quizId))
            {
                ShowMessage(
                    "Invalid quiz ID.",
                    false
                );

                return;
            }

            DeleteQuiz(quizId);
        }

        private void DeleteQuiz(int quizId)
        {
            using (SqlConnection conn =
                new SqlConnection(connStr))
            {
                string query = @"
                    DELETE FROM Quizzes
                    WHERE QuizId = @QuizId";

                using (SqlCommand cmd =
                    new SqlCommand(query, conn))
                {
                    cmd.Parameters.Add(
                        "@QuizId",
                        SqlDbType.Int
                    ).Value = quizId;

                    try
                    {
                        conn.Open();

                        int rowsAffected =
                            cmd.ExecuteNonQuery();

                        if (rowsAffected > 0)
                        {
                            ShowMessage(
                                "Quiz deleted successfully.",
                                true
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Quiz was not found.",
                                false
                            );
                        }
                    }
                    catch (SqlException ex)
                    {
                        if (ex.Number == 547)
                        {
                            ShowMessage(
                                "This quiz cannot be deleted because it has related questions, attempts or results.",
                                false
                            );
                        }
                        else
                        {
                            ShowMessage(
                                "Error deleting quiz: " +
                                ex.Message,
                                false
                            );
                        }
                    }
                    catch (Exception ex)
                    {
                        ShowMessage(
                            "Error deleting quiz: " +
                            ex.Message,
                            false
                        );
                    }
                }
            }

            LoadQuizzes();
        }

        // ===================== MESSAGE =====================

        private void ShowMessage(
            string message,
            bool isSuccess)
        {
            LblMessage.Text = message;

            PanelMessage.CssClass = isSuccess
                ? "admin-inline-message success admin-page-message"
                : "admin-inline-message error admin-page-message";

            PanelMessage.Visible = true;
        }
    }
}