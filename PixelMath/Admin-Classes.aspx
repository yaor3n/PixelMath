<%@ Page Title="" Language="C#" MasterPageFile="~/Admin-Template.Master" AutoEventWireup="true" CodeBehind="Admin-Classes.aspx.cs" Inherits="PixelMath.Admin_Classes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Manage Classes
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <asp:Panel ID="PanelMessage" runat="server" Visible="false" CssClass="admin-inline-message">
        <asp:Label ID="LblMessage" runat="server" />
    </asp:Panel>

<%-- Add / Edit Class popup --%>
<asp:Panel ID="PanelClassForm" runat="server" CssClass="admin-modal-overlay" Visible="false">
    <div class="admin-modal-card admin-class-modal">
        <div class="admin-modal-header">
            <div>
                <asp:Label ID="LblFormTitle" runat="server" Text="Add New Class" CssClass="admin-modal-title" />
                <div class="admin-modal-subtitle">
                    Enter the class information below.
                </div>
            </div>

            <asp:LinkButton ID="BtnCloseClassForm" runat="server" CssClass="admin-modal-close" OnClick="BtnCancelForm_Click" CausesValidation="false">
                &times;
            </asp:LinkButton>
        </div>

        <asp:HiddenField ID="HiddenClassId" runat="server" />
        <asp:ValidationSummary ID="ClassValidationSummary" runat="server" ValidationGroup="ClassForm" CssClass="admin-inline-message error" HeaderText="Please correct the following:" DisplayMode="BulletList" />

        <div class="admin-form-grid">
            <div class="admin-form-field">
                <label>Class Name</label>
                <asp:TextBox ID="TxtClassName"
                    runat="server"
                    TextMode="SingleLine"
                    placeholder="Enter class name" />

                <asp:RequiredFieldValidator ID="ReqClassName" runat="server" ControlToValidate="TxtClassName" ErrorMessage="Class name is required." Display="Dynamic" CssClass="admin-field-error" ValidationGroup="ClassForm" />
            </div>

            <div class="admin-form-field">
                <label>Description</label>
                <asp:TextBox ID="TxtDescription" runat="server" TextMode="MultiLine" Rows="4" placeholder="Enter a short class description" />
            </div>
        </div>

        <div class="admin-modal-actions">
            <asp:Button ID="BtnCancelForm" runat="server" Text="Cancel" CssClass="btn-admin-secondary" OnClick="BtnCancelForm_Click" CausesValidation="false" />
            <asp:Button ID="BtnSaveClass" runat="server" Text="Create Class" CssClass="btn-admin-primary" OnClick="BtnSaveClass_Click" ValidationGroup="ClassForm" CausesValidation="true" />
        </div>
    </div>
</asp:Panel>

    <%-- Enrolment panel, shown when "Manage Students" is clicked on a class --%>
    <asp:Panel ID="PanelEnrolment" runat="server" CssClass="admin-panel" Visible="false">
        <div class="admin-panel-header">
            <div class="admin-panel-title">
                Enrolment &ndash; <asp:Label ID="LblEnrolClassName" runat="server" />
            </div>
            <asp:Button ID="BtnCloseEnrolment" runat="server" Text="Close" CssClass="btn-admin-secondary"
                OnClick="BtnCloseEnrolment_Click" CausesValidation="false" />
        </div>

        <asp:HiddenField ID="HiddenEnrolClassId" runat="server" />

        <div class="admin-form-grid">
            <div class="admin-form-field">
                <label>Add Student to Class</label>
                <asp:DropDownList ID="DdlAddStudent" runat="server" />
            </div>
            <div class="admin-form-field" style="align-self:flex-end;">
                <asp:Button ID="BtnAddStudentToClass" runat="server" Text="+ Enrol Student" CssClass="btn-admin-primary"
                    OnClick="BtnAddStudentToClass_Click" CausesValidation="false" />
            </div>
        </div>

        <div class="admin-table-wrap">
            <asp:Repeater ID="RepeatEnrolledStudents" runat="server" OnItemCommand="RepeatEnrolledStudents_ItemCommand">
                <HeaderTemplate>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Student Name</th>
                                <th>Email</th>
                                <th>Enrolled</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("FullName") %></td>
                        <td><%# Eval("Email") %></td>
                        <td><%# Eval("EnrolledAt", "{0:dd MMM yyyy}") %></td>
                        <td>
                            <asp:LinkButton ID="BtnRemoveStudent" runat="server" CssClass="btn-admin-danger"
                                CommandName="Remove" CommandArgument='<%# Eval("StudentClassId") %>' CausesValidation="false"
                                OnClientClick="return confirm('Remove this student from the class?');">Remove</asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="PanelNoEnrolled" runat="server" CssClass="admin-empty-state" Visible="false">
                No students enrolled in this class yet.
            </asp:Panel>
        </div>
    </asp:Panel>

    <div class="admin-panel">
        <div class="admin-panel-header">
            <div class="admin-panel-title">All Classes</div>
            <div class="admin-toolbar">
                <asp:Button ID="BtnAddClass" runat="server" Text="+ Add Class" CssClass="btn-admin-primary"
                    OnClick="BtnAddClass_Click" CausesValidation="false" />
            </div>
        </div>

        <div class="admin-table-wrap">
            <asp:Repeater ID="RepeatClasses" runat="server" OnItemCommand="RepeatClasses_ItemCommand">
                <HeaderTemplate>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>Class Name</th>
                                <th>Description</th>
                                <th>Students Enrolled</th>
                                <th>Created</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td><%# Eval("ClassName") %></td>
                        <td><%# Eval("Description") == DBNull.Value ? "—" : Eval("Description") %></td>
                        <td><%# Eval("StudentCount") %></td>
                        <td><%# Eval("CreatedAt", "{0:dd MMM yyyy}") %></td>
                        <td>
                            <asp:LinkButton ID="BtnManageStudents" runat="server" CssClass="btn-admin-edit"
                                CommandName="ManageStudents" CommandArgument='<%# Eval("ClassId") %>' CausesValidation="false">Manage Students</asp:LinkButton>
                            <asp:LinkButton ID="BtnEdit" runat="server" CssClass="btn-admin-edit"
                                CommandName="Edit" CommandArgument='<%# Eval("ClassId") %>' CausesValidation="false">Edit</asp:LinkButton>
                            <asp:LinkButton ID="BtnDelete" runat="server" CssClass="btn-admin-danger"
                                CommandName="Delete" CommandArgument='<%# Eval("ClassId") %>' CausesValidation="false"
                                OnClientClick="return confirm('Delete this class? All enrolments will also be removed.');">Delete</asp:LinkButton>
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
            <asp:Panel ID="PanelNoClasses" runat="server" CssClass="admin-empty-state" Visible="false">
                No classes have been created yet.
            </asp:Panel>
        </div>
    </div>

</asp:Content>
