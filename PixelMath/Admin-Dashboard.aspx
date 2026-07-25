<%@ Page Title="" Language="C#" MasterPageFile="~/Admin-Template.Master" AutoEventWireup="true" CodeBehind="Admin-Dashboard.aspx.cs" Inherits="PixelMath.Admin_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Admin Dashboard
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-user-graduate"></i></div>
            <div>
                <div class="stat-value"><asp:Label ID="LblTotalStudents" runat="server" Text="0" /></div>
                <div class="stat-label">Students</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-chalkboard-user"></i></div>
            <div>
                <div class="stat-value"><asp:Label ID="LblTotalLecturers" runat="server" Text="0" /></div>
                <div class="stat-label">Lecturers</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-chalkboard"></i></div>
            <div>
                <div class="stat-value"><asp:Label ID="LblTotalClasses" runat="server" Text="0" /></div>
                <div class="stat-label">Classes</div>
            </div>
        </div>

        <div class="stat-card">
            <div class="stat-icon"><i class="fa-solid fa-file-pen"></i></div>
            <div>
                <div class="stat-value"><asp:Label ID="LblTotalQuizzes" runat="server" Text="0" /></div>
                <div class="stat-label">Quizzes</div>
            </div>
        </div>
    </div>

    <div class="admin-panel dashboard-recent-panel">
        <div class="admin-panel-header">
            <div class="admin-panel-title">Recently Registered Users</div>
        </div>
        <div class="admin-table-wrap">
            <asp:Repeater ID="RepeatRecentUsers" runat="server" OnItemDataBound="RepeatRecentUsers_ItemDataBound">
                <HeaderTemplate>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Joined</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("FullName") %></td>
                        <td><%# Eval("Email") %></td>
                        <td><asp:Label ID="LblRoleBadge" runat="server" /></td>
                        <td>
                            <span class='<%# GetStatusCss(Eval("AccountStatus")) %>'>
                            <%# Eval("AccountStatus") %>
                            </span>
                        </td>
                        <td><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="PanelNoRecentUsers" runat="server" CssClass="admin-empty-state" Visible="false">
                No users have registered yet.
            </asp:Panel>
        </div>
    </div>

</asp:Content>
