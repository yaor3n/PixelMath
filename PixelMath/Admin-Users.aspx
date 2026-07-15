<%@ Page Title="" Language="C#" MasterPageFile="~/Admin-Template.Master" AutoEventWireup="true" CodeBehind="Admin-Users.aspx.cs" Inherits="PixelMath.Admin_Users" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Manage Users
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="PanelMessage" runat="server" Visible="false" CssClass="admin-inline-message">
        <asp:Label ID="LblMessage" runat="server" />
    </asp:Panel>

    <%-- Add / Edit form panel (hidden until "Add User" or "Edit" is clicked) --%>
    <asp:Panel ID="PanelUserForm" runat="server" CssClass="admin-panel" Visible="false">
        <div class="admin-panel-header">
            <div class="admin-panel-title">
                <asp:Label ID="LblFormTitle" runat="server" Text="Add New User" />
            </div>
        </div>

        <asp:HiddenField ID="HiddenUserId" runat="server" />

        <div class="admin-form-grid">
            <div class="admin-form-field">
                <label>Full Name</label>
                <asp:TextBox ID="TxtFullName" runat="server" TextMode="SingleLine" />
                <asp:RequiredFieldValidator ID="ReqFullName" runat="server" ControlToValidate="TxtFullName"
                    ErrorMessage="Full name is required." Display="Dynamic" CssClass="admin-inline-message error"
                    ValidationGroup="UserForm" />
            </div>

            <div class="admin-form-field">
                <label>Email</label>
                <asp:TextBox ID="TxtEmail" runat="server" TextMode="Email" />
                <asp:RequiredFieldValidator ID="ReqEmail" runat="server" ControlToValidate="TxtEmail"
                    ErrorMessage="Email is required." Display="Dynamic" CssClass="admin-inline-message error"
                    ValidationGroup="UserForm" />
                <asp:RegularExpressionValidator ID="RegexEmail" runat="server" ControlToValidate="TxtEmail"
                    ValidationExpression="^[^@\s]+@[^@\s]+\.[^@\s]+$"
                    ErrorMessage="Enter a valid email address." Display="Dynamic" CssClass="admin-inline-message error"
                    ValidationGroup="UserForm" />
            </div>

            <div class="admin-form-field">
                <label>Role</label>
                <asp:DropDownList ID="DdlRole" runat="server">
                    <asp:ListItem Text="Student" Value="1" />
                    <asp:ListItem Text="Lecturer" Value="2" />
                    <asp:ListItem Text="Admin" Value="3" />
                </asp:DropDownList>
            </div>

            <div class="admin-form-field" id="FormLevelField" runat="server">
                <label>Form Level (Students only)</label>
                <asp:TextBox ID="TxtForm" runat="server" TextMode="Number" placeholder="e.g. 1" />
            </div>

            <div class="admin-form-field">
                <label>
                    <asp:Label ID="LblPasswordHint" runat="server" Text="Password" />
                </label>
                <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" autocomplete="new-password" />
                <asp:Label ID="LblPasswordEditHint" runat="server" Text="Leave blank to keep current password."
                    Visible="false" Style="font-size:11px;color:#6B7280;font-weight:600;" />
            </div>
        </div>

        <div class="admin-form-actions">
            <asp:Button ID="BtnSaveUser" runat="server" Text="Save User" CssClass="btn-admin-primary"
                OnClick="BtnSaveUser_Click" ValidationGroup="UserForm" CausesValidation="true" />
            <asp:Button ID="BtnCancelForm" runat="server" Text="Cancel" CssClass="btn-admin-secondary"
                OnClick="BtnCancelForm_Click" CausesValidation="false" />
        </div>
    </asp:Panel>

    <div class="admin-panel">
        <div class="admin-panel-header">
            <div class="admin-panel-title">All Users</div>
            <div class="admin-toolbar">
                <div class="admin-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <asp:TextBox ID="TxtSearch" runat="server" CssClass="admin-search-input" placeholder="Search name or email..." />
                </div>
                <asp:DropDownList ID="DdlRoleFilter" runat="server" CssClass="admin-select" AutoPostBack="true" OnSelectedIndexChanged="FilterChanged">
                    <asp:ListItem Text="All Roles" Value="0" />
                    <asp:ListItem Text="Student" Value="1" />
                    <asp:ListItem Text="Lecturer" Value="2" />
                    <asp:ListItem Text="Admin" Value="3" />
                </asp:DropDownList>
                <asp:Button ID="BtnSearch" runat="server" Text="Search" CssClass="btn-admin-secondary" OnClick="FilterChanged" CausesValidation="false" />
                <asp:Button ID="BtnAddUser" runat="server" Text="+ Add User" CssClass="btn-admin-primary" OnClick="BtnAddUser_Click" CausesValidation="false" />
            </div>
        </div>

        <div class="admin-table-wrap">
            <asp:Repeater ID="RepeatUsers" runat="server" OnItemDataBound="RepeatUsers_ItemDataBound" OnItemCommand="RepeatUsers_ItemCommand">
                <HeaderTemplate>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Role</th>
                                <th>Form</th>
                                <th>Joined</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("FullName") %></td>
                        <td><%# Eval("Email") %></td>
                        <td><asp:Label ID="LblRoleBadge" runat="server" /></td>
                        <td><%# Eval("Form") == DBNull.Value ? "—" : Eval("Form") %></td>
                        <td><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></td>
                        <td>
                            <asp:LinkButton ID="BtnEdit" runat="server" CssClass="btn-admin-edit"
                                CommandName="Edit" CommandArgument='<%# Eval("UserId") %>' CausesValidation="false">Edit</asp:LinkButton>
                            <asp:LinkButton ID="BtnDelete" runat="server" CssClass="btn-admin-danger"
                                CommandName="Delete" CommandArgument='<%# Eval("UserId") %>' CausesValidation="false"
                                OnClientClick="return confirm('Delete this user? This cannot be undone.');">Delete</asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="PanelNoUsers" runat="server" CssClass="admin-empty-state" Visible="false">
                No users found matching your search.
            </asp:Panel>
        </div>
    </div>

</asp:Content>
