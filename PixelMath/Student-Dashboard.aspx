<%@ Page Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Dashboard.aspx.cs" Inherits="PixelMath.Student_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    </asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <%-- ONLY put the unique contents of the dashboard page here! --%>
    <div class="welcome-banner">
        <div>
            <div class="greeting">Good morning,</div>
            <div class="name">Ali</div>
            <div class="reminder">can wait database</div>
        </div>
    </div>

    <%-- Your team can continue adding dashboard items right here --%>
</asp:Content>