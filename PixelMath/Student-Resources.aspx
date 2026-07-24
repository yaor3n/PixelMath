<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Resources.aspx.cs" Inherits="PixelMath.Student_Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Resources-CSS.css" />
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Fredoka+One&display=swap" rel="stylesheet"/>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Learning Resources
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="resource-container">
       <asp:Repeater ID="ResourceRepeater" runat="server">
            <ItemTemplate>
                <div class="resource-card">
                    <!-- Top Section: Icon on Left | Title & Date Stacked on Right -->
                    <div class="resource-header">
                        <div class="resource-icon">
                            <i class="fa-solid fa-file-pdf"></i>
                        </div>
                        <div class="resource-details">
                            <h3 class="resource-title"><%# Eval("Title") %></h3>
                            <span class="resource-meta">
                                <i class="fa-regular fa-calendar"></i> <%# Eval("CreatedAt", "{0:dd MMM yyyy}") %>
                            </span>
                        </div>
                    </div>

                    <!-- Bottom Action Row: View Button (Left) | Download Button (Right) -->
                    <div class="resource-action-row">
                        <!-- VIEW BUTTON (LEFT) -->
                        <a href='<%# GetFormattedUrl(Eval("ResourceUrl")) %>' target="_blank" class="btn-action btn-view">
                            <i class="fa-solid fa-eye"></i> View
                        </a>

                        <!-- DOWNLOAD BUTTON (RIGHT) -->
                        <a href='<%# GetFormattedUrl(Eval("ResourceUrl")) %>' download='<%# Eval("OriginalFileName") %>' class="btn-action btn-download">
                            <i class="fa-solid fa-download"></i> Download
                        </a>
                    </div>
                </div>
            </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoResources" runat="server" Visible="false" CssClass="no-resource-msg">
            No learning resources available yet.
        </asp:Panel>
    </div>
</asp:Content>