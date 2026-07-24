<%@ Page
    Title="Activity Logs - PixelMath"
    Language="C#"
    MasterPageFile="~/Admin-Template.Master"
    AutoEventWireup="true"
    CodeBehind="Admin-Activity-Logs.aspx.cs"
    Inherits="PixelMath.Admin_Activity_Logs" %>

<asp:Content
    ID="ContentHead"
    ContentPlaceHolderID="head"
    runat="server">
</asp:Content>

<asp:Content
    ID="ContentTopbar"
    ContentPlaceHolderID="TopbarTitleContent"
    runat="server">

    Activity Logs
</asp:Content>

<asp:Content
    ID="ContentMain"
    ContentPlaceHolderID="MainContent"
    runat="server">

    <asp:Panel
        ID="PanelMessage"
        runat="server"
        Visible="false"
        CssClass="admin-inline-message admin-page-message">

        <asp:Label
            ID="LblMessage"
            runat="server" />
    </asp:Panel>

    <div class="admin-panel admin-activity-panel">

        <div class="admin-panel-header">
            <div>
                <div class="admin-panel-title">
                    System Activity History
                </div>

                <div class="admin-panel-subtitle">
                    Review important actions performed by administrators and users.
                </div>
            </div>

            <div class="admin-toolbar">

                <div class="admin-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>

                    <asp:TextBox
                        ID="TxtSearch"
                        runat="server"
                        CssClass="admin-search-input"
                        placeholder="Search activity..." />
                </div>

                <asp:DropDownList
                    ID="DdlActionFilter"
                    runat="server"
                    CssClass="admin-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="FilterChanged">

                    <asp:ListItem
                        Text="All Actions"
                        Value="" />

                    <asp:ListItem
                        Text="Create"
                        Value="Create" />

                    <asp:ListItem
                        Text="Update"
                        Value="Update" />

                    <asp:ListItem
                        Text="Delete"
                        Value="Delete" />

                    <asp:ListItem
                        Text="Approve"
                        Value="Approve" />

                    <asp:ListItem
                        Text="Reject"
                        Value="Reject" />

                    <asp:ListItem
                        Text="Publish"
                        Value="Publish" />

                    <asp:ListItem
                        Text="Hide"
                        Value="Hide" />

                    <asp:ListItem
                        Text="Login"
                        Value="Login" />

                    <asp:ListItem
                        Text="Logout"
                        Value="Logout" />
                </asp:DropDownList>

                <asp:DropDownList
                    ID="DdlEntityFilter"
                    runat="server"
                    CssClass="admin-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="FilterChanged">

                    <asp:ListItem
                        Text="All Categories"
                        Value="" />

                    <asp:ListItem
                        Text="User"
                        Value="User" />

                    <asp:ListItem
                        Text="Class"
                        Value="Class" />

                    <asp:ListItem
                        Text="Quiz"
                        Value="Quiz" />

                    <asp:ListItem
                        Text="Announcement"
                        Value="Announcement" />

                    <asp:ListItem
                        Text="Session"
                        Value="Session" />
                </asp:DropDownList>

                <asp:Button
                    ID="BtnSearch"
                    runat="server"
                    Text="Search"
                    CssClass="btn-admin-secondary"
                    CausesValidation="false"
                    OnClick="FilterChanged" />

            </div>
        </div>

        <div class="admin-table-wrap activity-log-scroll">

            <asp:Repeater
                ID="RepeatActivityLogs"
                runat="server">

                <HeaderTemplate>
                    <table class="admin-table admin-activity-table">
                        <thead>
                            <tr>
                                <th>Date &amp; Time</th>
                                <th>User</th>
                                <th>Action</th>
                                <th>Description</th>
                                <th>Category</th>
                                <th>Entity ID</th>
                            </tr>
                        </thead>

                        <tbody>
                </HeaderTemplate>

                <ItemTemplate>
                    <tr>
                        <td class="activity-log-date">
                            <%# FormatLogDate(Eval("CreatedAt")) %>
                        </td>

                        <td>
                            <div class="activity-user-name">
                                <%# Eval("UserName") %>
                            </div>

                            <div class="activity-user-email">
                                <%# Eval("UserEmail") %>
                            </div>
                        </td>

                        <td>
                            <span class='<%# GetActionCss(Eval("ActionType")) %>'>
                                <%# Eval("ActionType") %>
                            </span>
                        </td>

                        <td>
                            <div class="activity-description">
                                <%# Eval("Description") %>
                            </div>
                        </td>

                        <td>
                            <span class="activity-entity-badge">
                                <%# Eval("EntityType") == DBNull.Value
                                    ? "General"
                                    : Eval("EntityType") %>
                            </span>
                        </td>

                        <td>
                            <%# Eval("EntityId") == DBNull.Value
                                ? "—"
                                : Eval("EntityId") %>
                        </td>
                    </tr>
                </ItemTemplate>

                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>

            </asp:Repeater>

            <asp:Panel
                ID="PanelNoLogs"
                runat="server"
                Visible="false"
                CssClass="admin-empty-state">

                <i class="fa-solid fa-clock-rotate-left"></i>

                <div>
                    No activity logs found.
                </div>
            </asp:Panel>

        </div>
    </div>

</asp:Content>