<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Resources.aspx.cs" Inherits="PixelMath.Student_Resources" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Resources-CSS.css" />
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Fredoka+One&display=swap" rel="stylesheet"/>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="resource-container">
        <h2>Learning Materials</h2>
        
        <!-- 🎯 Wrap the link in a Repeater to loop through rows properly -->
        <asp:Repeater ID="ResourceRepeater" runat="server">
            <ItemTemplate>
                <div class="resource-card" style="margin-bottom: 15px;">
                    <!-- Displaying the Title column from your DB -->
                    <h3><%# Eval("Title") %></h3>
                    
                    <!-- The clickable link that opens the PDF path in a new tab -->
                    <a href='<%# ResolveUrl(Eval("ResourceUrl").ToString()) %>' target="_blank" class="view-btn">
                        View Learning Resource (PDF)
                    </a>
                </div>
            </ItemTemplate>
        </asp:Repeater>
    </div>
</asp:Content>
