<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Announcements.aspx.cs" Inherits="PixelMath.Student_Announcements" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Announcements-CSS.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Announcements
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="announcement-wrapper">
        <div class="left-panel">
            <div class="panel-search">
                <div class="search-wrap">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <input class="search-input" type="text" placeholder="Search announcements..." id="search-input" oninput="filterAnnouncements()" onkeydown="if(event.key === 'Enter') {return false;}"/>
                </div>
            </div>

            <div id="announcements-container">
                <asp:Repeater ID="repeatAnnouncements" runat="server" OnItemCommand="repeatAnnouncements_ItemCommand" OnItemDataBound="left_announcements">
                    <ItemTemplate>
                        <asp:LinkButton ID="SelectAnnouncement" runat="server" 
                            CommandName="Select" 
                            CommandArgument='<%# Eval("AnnouncementId") %>' 
                            CssClass="announcements-card-button">  
            
                            <div class="announcements">
                                <asp:Panel ID="PanelStatusDot" runat="server" CssClass="unread-status-dot"></asp:Panel>

                                <div class="announcement-text-content">
                                    <div class="left-title">
                                        <asp:Label ID="LabelLeftTitle" runat="server" />
                                    </div>

                                    <div class="left-meta">
                                        <asp:Label ID="LabelLeftTeacher" runat="server" />
                                        <span class="meta-dot">&middot;</span>
                                        <asp:Label ID="labelLeftDate" runat="server" />
                                    </div>
                               </div>
                            </div>

                            <div class="left-separator-line"></div>
                        </asp:LinkButton>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

        </div>

        <div class="right-panel">
            <asp:Panel ID="rightPanelDetailView" runat="server" Visible="false">
                <div class="detail-header">
                    <div class="detail-title">
                        <asp:Label ID="AnnouncementLabel" runat="server"></asp:Label>
                    </div>
                </div>
                <div class="detail-meta">
                    <div class="detail-meta-item">
                        <strong>
                            <i class="fa-solid fa-user"></i>
                            <asp:Label ID="AnnouncementTeacherName" runat="server"></asp:Label>
                        </strong>
                    </div>

                    <div class="detail-meta-item">
                        <i class="fa-solid fa-calendar"></i>
                        <asp:Label ID="AnnouncementCreatedDate" runat="server"></asp:Label>
                    </div>

                    <div class="detail-meta-item">
                        <i class="fa-solid fa-clock"></i>
                        <asp:Label ID="AnnouncementCreatedTime" runat="server"></asp:Label>
                    </div>
                </div>
            
                <p class="announcement-body-text">
                    <asp:Label ID="AnnouncementMessage" runat="server"></asp:Label>
                </p>

            </asp:Panel>

            <asp:Panel ID="rightPanelPlaceHolder" runat="server" CssClass="no-selection-placeholder">
                <div class="placeholder-content">
                    <img src="Select-Announcement.png" width="75" height="75" />
                    <h2>No Announcement Selected</h2>
                    <p>Click on any announcement from the left-side list view to read its detailed description info message contents.</p>
                </div>
            </asp:Panel>

        </div>
    </div>


    <script type="text/javascript">
        function filterAnnouncements() {
            var input, filter, container, cards, titleEl, txtValue, i;

            input = document.getElementById("search-input");
            filter = input.value.toUpperCase();
            container = document.getElementById("announcements-container");
            cards = container.getElementsByClassName("announcements-card-button");

            
            var noResultsBlock = document.getElementById("no-announcements-row");
            if (noResultsBlock) {
                noResultsBlock.remove();
            }

            var hasResults = false;

            
            for (i = 0; i < cards.length; i++) {
                // Find the specific title element block inside this specific item card pass
                titleEl = cards[i].querySelector(".left-title");

                if (titleEl) {
                    txtValue = titleEl.textContent || titleEl.innerText;

                    // Match characters against filter inputs
                    if (txtValue.toUpperCase().indexOf(filter) > -1) {
                        cards[i].style.display = ""; // Keeps card layout block visible
                        hasResults = true;
                    } else {
                        cards[i].style.display = "none";
                    }
                }
            }

            // no match found
            if (!hasResults && filter.length > 0) {
                var newFallback = document.createElement("div");
                newFallback.id = "no-announcements-row";
                newFallback.style.display = "flex";
                newFallback.style.flexDirection = "column";
                newFallback.style.alignItems = "center";
                newFallback.style.justifyContent = "center";
                newFallback.style.gap = "12px";

                newFallback.style.textAlign = "center";
                newFallback.style.padding = "40px 16px";
                newFallback.style.color = "#6B7280";
                newFallback.style.fontFamily = "'Nunito', sans-serif";
                newFallback.style.fontSize = "13px";

                newFallback.innerHTML = '<img src="result-no-found.png" width="65" height="55" alt="Empty Search View" />No announcement found matching your search.';

                container.appendChild(newFallback);
            }
        }
    </script>
</asp:Content>


