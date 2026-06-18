<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Profile.aspx.cs" Inherits="PixelMath.Student_Profile" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Profile-CSS.css" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    My Profile
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="profile-wrapper">
        <div class="personal-info">
            <div class="title">
                <i class="fa-solid fa-user"></i>Personal info
            </div>

            <div class="profile-picture">
                <img src="Student-Avatar.png" alt="Profile Picture"/>
            </div>

            <div class="profile-badge">
                <asp:Label ID="ProfileBadge" runat="server"></asp:Label>
            </div>

            <div class="personal-detail">
                <div class="profile-form-grid">
                    <div class="form-group-row">
                        <label class="form-field-label">FULL NAME</label>
                        <asp:TextBox ID="TextFullName" runat="server" CssClass="profile-disabled-input" ReadOnly="true"/>
                    </div>

                    <div class="form-group-row">
                        <label class="form-field-label">EMAIL</label>
                        <asp:TextBox ID="TextEmail" runat="server" CssClass="profile-disabled-input" ReadOnly="true"/>
                    </div>

                    <div class="form-group-row">
                        <label class="form-field-label">EDUCATIONAL LEVEL</label>
                        <asp:TextBox ID="TextFormLevel" runat="server" CssClass="profile-disabled-input" ReadOnly="true"/>
                    </div>
                </div>
            </div>
        </div>
    </div>

    
</asp:Content>
