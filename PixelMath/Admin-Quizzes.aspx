<%@ Page
    Title="Manage Quizzes - PixelMath"
    Language="C#"
    MasterPageFile="~/Admin-Template.Master"
    AutoEventWireup="true"
    CodeBehind="Admin-Quizzes.aspx.cs"
    Inherits="PixelMath.Admin_Quizzes" %>

<asp:Content
    ID="ContentHead"
    ContentPlaceHolderID="head"
    runat="server">
</asp:Content>

<asp:Content
    ID="ContentTopbar"
    ContentPlaceHolderID="TopbarTitleContent"
    runat="server">

    Manage Quizzes
</asp:Content>

<asp:Content
    ID="ContentMain"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <%-- Success or error message --%>
    <asp:Panel
        ID="PanelMessage"
        runat="server"
        Visible="false"
        CssClass="admin-inline-message admin-page-message">

        <asp:Label
            ID="LblMessage"
            runat="server" />
    </asp:Panel>

    <%-- Quiz management panel --%>
    <div class="admin-panel">

        <div class="admin-panel-header">
            <div>
                <div class="admin-panel-title">
                    Quiz Management
                </div>

                <div class="admin-panel-subtitle">
                    View, search, filter and delete quizzes from all classes.
                </div>
            </div>

            <%-- Search and class filter --%>
            <div class="admin-toolbar">

                <div class="admin-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>

                    <asp:TextBox
                        ID="TxtQuizSearch"
                        runat="server"
                        CssClass="admin-search-input"
                        placeholder="Search quiz title..." />
                </div>

                <asp:DropDownList
                    ID="DdlClassFilter"
                    runat="server"
                    CssClass="admin-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="DdlClassFilter_SelectedIndexChanged">
                </asp:DropDownList>

                <asp:Button
                    ID="BtnSearch"
                    runat="server"
                    Text="Search"
                    CssClass="btn-admin-secondary"
                    OnClick="BtnSearch_Click"
                    CausesValidation="false" />

            </div>
        </div>

        <%-- Quizzes table --%>
        <div class="admin-table-wrap">

            <asp:Repeater
                ID="RepeatQuizzes"
                runat="server"
                OnItemCommand="RepeatQuizzes_ItemCommand">

                <HeaderTemplate>
                    <table class="admin-table admin-quizzes-table">
                        <thead>
                            <tr>
                                <th>Quiz Title</th>
                                <th>Class</th>
                                <th>Duration</th>
                                <th>Passing Marks</th>
                                <th>Created By</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>
                </HeaderTemplate>

                <ItemTemplate>
                    <tr>

                        <%-- Quiz title --%>
                        <td class="admin-quiz-title">
                            <%# Eval("Title") %>
                        </td>

                        <%-- Class --%>
                        <td>
                            <span class="admin-class-badge">
                                <%# Eval("ClassName") %>
                            </span>
                        </td>

                        <%-- Duration --%>
                        <td>
                            <i class="fa-regular fa-clock"></i>
                            <%# Eval("DurationMinutes") %> mins
                        </td>

                        <%-- Passing marks --%>
                        <td>
                            <i class="fa-solid fa-bullseye"></i>
                            <%# Eval("PassingMarks") %> pts
                        </td>

                        <%-- Lecturer who created the quiz --%>
                        <td>
                            <%# Eval("CreatedByName") %>
                        </td>

                        <%-- Created date --%>
                        <td>
                            <%# Eval("CreatedAt", "{0:dd MMM yyyy}") %>
                        </td>

                        <%-- Admin can only delete --%>
                        <td>
                            <div class="admin-row-actions admin-quiz-actions">

                                <asp:LinkButton
                                    ID="BtnDeleteQuiz"
                                    runat="server"
                                    CssClass="btn-admin-action btn-admin-danger"
                                    CommandName="DeleteQuiz"
                                    CommandArgument='<%# Eval("QuizId") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Are you sure you want to delete this quiz? This action cannot be undone.');">

                                    <i class="fa-solid fa-trash"></i>
                                    <span>Delete</span>
                                </asp:LinkButton>

                            </div>
                        </td>

                    </tr>
                </ItemTemplate>

                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>

            </asp:Repeater>

            <%-- Empty state --%>
            <asp:Panel
                ID="PanelNoQuizzes"
                runat="server"
                Visible="false"
                CssClass="admin-empty-state">

                <i class="fa-solid fa-file-circle-question"></i>
                <div>No quizzes found matching your search.</div>

            </asp:Panel>

        </div>
    </div>

</asp:Content>