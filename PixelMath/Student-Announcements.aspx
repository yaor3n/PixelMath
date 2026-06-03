<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Announcements.aspx.cs" Inherits="PixelMath.Student_Announcements" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Announcements-CSS.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Announcements 📢
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="announcement-wrapper">
        <div class="left-panel">
            <div class="panel-search">
                <div class="search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input class="search-input" type="text" placeholder="Search announcements..." id="search-input" oninput="filterItems()"/>
                </div>
            </div>

            <div class="filter-row">
                <button >Not sure</button>
            </div>

            <div class="announcements">
                <p>hi</p>
            </div>

        </div>
        <div class="right-panel">
            <div class="detail-header">
                <div class="detail-title">
                    <asp:Label ID="AnnouncementLabel" runat="server"></asp:Label>
                </div>
            </div>
            <div class="detail-meta">
                <div class="detail-meta-item">
                    <strong>
                        <i class="fa-solid fa-user meta-icon"></i>
                        <asp:Label ID="AnnouncementTeacherName" runat="server"></asp:Label>
                    </strong>
                </div>
                <div class="detail-meta-item">
                    
                        <i class="fa-solid fa-clock meta-icon"></i>
                        <asp:Label ID="AnnouncementCreatedDate" runat="server"></asp:Label>
                    
                </div>
            </div>
            
            <p><asp:Label ID="AnnouncementMessage" runat="server"></asp:Label></p>
        </div>
    </div>
</asp:Content>
