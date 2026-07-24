<%@ Page
    Title="Announcements - PixelMath"
    Language="C#"
    MasterPageFile="~/Admin-Template.Master"
    AutoEventWireup="true"
    CodeBehind="Admin-Announcements.aspx.cs"
    Inherits="PixelMath.Admin_Announcements" %>

<asp:Content
    ID="ContentHead"
    ContentPlaceHolderID="head"
    runat="server">
</asp:Content>

<asp:Content
    ID="ContentTopbar"
    ContentPlaceHolderID="TopbarTitleContent"
    runat="server">

    Announcements
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

    <%-- Create or edit announcement --%>
    <div class="admin-panel announcement-form-panel">

        <div class="admin-panel-header">
            <div>
                <div class="admin-panel-title">
                    <asp:Label
                        ID="LblFormTitle"
                        runat="server"
                        Text="Create Announcement" />
                </div>

                <div class="admin-panel-subtitle">
                    Publish an announcement for all users or a specific class.
                </div>
            </div>
        </div>

        <asp:HiddenField
            ID="HiddenAnnouncementId"
            runat="server" />

        <asp:ValidationSummary
            ID="AnnouncementValidationSummary"
            runat="server"
            ValidationGroup="AnnouncementForm"
            CssClass="admin-inline-message error"
            HeaderText="Please correct the following:"
            DisplayMode="BulletList" />

        <div class="announcement-form-grid">

            <%-- Title --%>
            <div class="admin-form-field announcement-title-field">
                <label>Announcement Title</label>

                <asp:TextBox
                    ID="TxtTitle"
                    runat="server"
                    MaxLength="200"
                    placeholder="Enter announcement title" />

                <asp:RequiredFieldValidator
                    ID="ReqTitle"
                    runat="server"
                    ControlToValidate="TxtTitle"
                    ErrorMessage="Announcement title is required."
                    Display="Dynamic"
                    CssClass="admin-field-error"
                    ValidationGroup="AnnouncementForm" />
            </div>

            <%-- Target --%>
            <div class="admin-form-field">
                <label>Target Audience</label>

                <asp:DropDownList
                    ID="DdlTargetClass"
                    runat="server">
                </asp:DropDownList>

                <span class="admin-form-hint">
                    Select All Users or one specific class.
                </span>
            </div>

            <%-- Status --%>
            <div class="admin-form-field">
                <label>Status</label>

                <asp:DropDownList
                    ID="DdlStatus"
                    runat="server">

                    <asp:ListItem
                        Text="Published"
                        Value="1" />

                    <asp:ListItem
                        Text="Hidden"
                        Value="0" />
                </asp:DropDownList>
            </div>

            <%-- Message --%>
            <div class="admin-form-field announcement-message-field">
                <label>Message</label>

                <asp:TextBox
                    ID="TxtMessage"
                    runat="server"
                    TextMode="MultiLine"
                    Rows="7"
                    placeholder="Write the announcement message..." />

                <asp:RequiredFieldValidator
                    ID="ReqMessage"
                    runat="server"
                    ControlToValidate="TxtMessage"
                    ErrorMessage="Announcement message is required."
                    Display="Dynamic"
                    CssClass="admin-field-error"
                    ValidationGroup="AnnouncementForm" />
            </div>

        </div>

        <div class="announcement-form-actions">

            <asp:Button
                ID="BtnCancelEdit"
                runat="server"
                Text="Cancel Edit"
                CssClass="btn-admin-secondary"
                Visible="false"
                CausesValidation="false"
                OnClick="BtnCancelEdit_Click" />

            <asp:Button
                ID="BtnSaveAnnouncement"
                runat="server"
                Text="Publish Announcement"
                CssClass="btn-admin-primary"
                ValidationGroup="AnnouncementForm"
                CausesValidation="true"
                OnClick="BtnSaveAnnouncement_Click" />

        </div>
    </div>

    <%-- Announcement history --%>
    <div class="admin-panel">

        <div class="admin-panel-header">
            <div>
                <div class="admin-panel-title">
                    Announcement History
                </div>

                <div class="admin-panel-subtitle">
                    View, search, edit, hide, publish or delete announcements.
                </div>
            </div>

            <div class="admin-toolbar">

                <div class="admin-search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>

                    <asp:TextBox
                        ID="TxtSearch"
                        runat="server"
                        CssClass="admin-search-input"
                        placeholder="Search announcements..." />
                </div>

                <asp:DropDownList
                    ID="DdlClassFilter"
                    runat="server"
                    CssClass="admin-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="AnnouncementFilterChanged">
                </asp:DropDownList>

                <asp:DropDownList
                    ID="DdlStatusFilter"
                    runat="server"
                    CssClass="admin-select"
                    AutoPostBack="true"
                    OnSelectedIndexChanged="AnnouncementFilterChanged">

                    <asp:ListItem
                        Text="All Statuses"
                        Value="-1" />

                    <asp:ListItem
                        Text="Published"
                        Value="1" />

                    <asp:ListItem
                        Text="Hidden"
                        Value="0" />
                </asp:DropDownList>

                <asp:Button
                    ID="BtnSearch"
                    runat="server"
                    Text="Search"
                    CssClass="btn-admin-secondary"
                    CausesValidation="false"
                    OnClick="AnnouncementFilterChanged" />

            </div>
        </div>

        <div class="admin-table-wrap">

            <asp:Repeater
                ID="RepeatAnnouncements"
                runat="server"
                OnItemCommand="RepeatAnnouncements_ItemCommand">

                <HeaderTemplate>
                    <table class="admin-table admin-announcements-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Message</th>
                                <th>Audience</th>
                                <th>Status</th>
                                <th>Created By</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>
                </HeaderTemplate>

                <ItemTemplate>
                    <tr>

                        <td class="announcement-table-title">
                            <%# Eval("Title") %>
                        </td>

                        <td>
                            <div class="announcement-message-preview">
                                <%# Eval("Message") %>
                            </div>
                        </td>

                        <td>
                            <span class="announcement-audience-badge">
                                <%# Eval("AudienceName") %>
                            </span>
                        </td>

                        <td>
                            <span class='<%# GetAnnouncementStatusCss(Eval("Status")) %>'>
                                <%# GetAnnouncementStatusText(Eval("Status")) %>
                            </span>
                        </td>

                        <td>
                            <%# Eval("CreatedByName") %>
                        </td>

                        <td>
                            <%# FormatAnnouncementDate(Eval("CreatedAt")) %>
                        </td>

                        <td>
                            <div class="admin-row-actions announcement-row-actions">

                                <asp:LinkButton
                                    ID="BtnEditAnnouncement"
                                    runat="server"
                                    CssClass="btn-admin-action btn-admin-edit"
                                    CommandName="EditAnnouncement"
                                    CommandArgument='<%# Eval("AnnouncementId") %>'
                                    CausesValidation="false">

                                    <i class="fa-solid fa-pen"></i>
                                    <span>Edit</span>
                                </asp:LinkButton>

                                <asp:LinkButton
                                    ID="BtnToggleStatus"
                                    runat="server"
                                    CssClass='<%# GetToggleButtonCss(Eval("Status")) %>'
                                    CommandName="ToggleStatus"
                                    CommandArgument='<%# Eval("AnnouncementId") %>'
                                    CausesValidation="false">

                                    <i class='<%# GetToggleButtonIcon(Eval("Status")) %>'></i>
                                    <span>
                                        <%# GetToggleButtonText(Eval("Status")) %>
                                    </span>
                                </asp:LinkButton>

                                <asp:LinkButton
                                    ID="BtnDeleteAnnouncement"
                                    runat="server"
                                    CssClass="btn-admin-action btn-admin-danger"
                                    CommandName="DeleteAnnouncement"
                                    CommandArgument='<%# Eval("AnnouncementId") %>'
                                    CausesValidation="false"
                                    OnClientClick="return confirm('Delete this announcement? This cannot be undone.');">

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

            <asp:Panel
                ID="PanelNoAnnouncements"
                runat="server"
                Visible="false"
                CssClass="admin-empty-state">

                <i class="fa-solid fa-bullhorn"></i>
                <div>No announcements found.</div>

            </asp:Panel>

        </div>
    </div>

</asp:Content>