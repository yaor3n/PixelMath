﻿<%@ Page Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Dashboard.aspx.cs" Inherits="PixelMath.Student_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Dashboard-CSS.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Dashboard 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="welcome-banner">
        <div>
            <div class="greeting">Good morning,</div>
            <div class="name">Ali</div>
            <div class="reminder">can wait database</div>
        </div>
    </div>
    <h1>test</h1>

</asp:Content>