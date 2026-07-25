<%@ Page Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Dashboard.aspx.cs" Inherits="PixelMath.Student_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Dashboard-CSS.css" />
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Fredoka+One&display=swap" rel="stylesheet"/>
    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.9.14/dist/dotlottie-wc.js" type="module"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Dashboard 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="dashboard-wrapper">
        
        <!-- 1. Dynamic Greeting Banner -->
        <div class="welcome-banner">
            <!-- Left Side Text Container -->
            <div class="welcome-text">
                <div class="greeting">
                    <asp:Label ID="lblGreetingTime" runat="server" Text="Welcome back,"></asp:Label>
                </div>
                <div class="name">
                    <asp:Label ID="lblStudentName" runat="server" Text="Student"></asp:Label> 👋
                </div>
            </div>

            <!-- Right Side Animation -->
            <div class="welcome-animation">
                <dotlottie-wc
                  src="https://lottie.host/f723efd3-f997-4323-8e85-2d4fbb2f6e6e/C6w44i4bRQ.lottie"
                  style="width: 100px; height: 100px;"
                  autoplay
                  loop
                ></dotlottie-wc>
            </div>
        </div>

        <!-- 2. Needs Revision Focus Box (Visible only if a score is below passing) -->
        <asp:Panel ID="pnlRevisionAlert" runat="server" CssClass="alert-card revision-card" Visible="false">
            <div class="alert-icon revision-icon">
                <i class="fa-solid fa-book-bookmark"></i>
            </div>
            <div class="alert-body">
                <span class="alert-tag revision-tag">RECOMMENDED REVISION</span>
                <h3><asp:Label ID="lblRevisionQuizTitle" runat="server"></asp:Label></h3>
                <p>Your last score was <asp:Label ID="lblRevisionScore" runat="server" Font-Bold="true"></asp:Label>%. Check out the class learning materials to boost your understanding!</p>
            </div>
            <div class="alert-action">
                <a href="Student-Resources.aspx" class="btn-alert btn-revision">
                    View Resources <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </asp:Panel>

        <!-- 3. unread annoucement -->
        <asp:Panel ID="pnlUnreadNotice" runat="server" CssClass="alert-card notice-card" Visible="false">
            <div class="alert-icon notice-icon">
                <i class="fa-solid fa-bell"></i>
            </div>
            <div class="alert-body">
                <span class="alert-tag notice-tag">CLASS ANNOUNCEMENT</span>
                <h3><asp:Label ID="lblLatestNoticeTitle" runat="server"></asp:Label></h3>
                <p>You have <asp:Label ID="lblNoticeCount" runat="server" Font-Bold="true"></asp:Label> unread notice(s) from your lecturer.</p>
            </div>
            <div class="alert-action">
                <a href="Student-Announcements.aspx" class="btn-alert btn-notice">
                    Read Now <i class="fa-solid fa-arrow-right"></i>
                </a>
            </div>
        </asp:Panel>

        <!-- 4. recent quiz -->
        <asp:Panel ID="pnlRecentAttempt" runat="server" CssClass="recent-activity-card" Visible="false">
            <div class="activity-header">
                <span><i class="fa-solid fa-clock-rotate-left"></i> LAST QUIZ ATTEMPT</span>
                <asp:Label ID="lblRecentDate" runat="server" CssClass="activity-date"></asp:Label>
            </div>
            <div class="activity-body">
                <div>
                    <h4 class="activity-title"><asp:Label ID="lblRecentQuizTitle" runat="server"></asp:Label></h4>
                    <p class="activity-status"><asp:Label ID="lblRecentStatusText" runat="server"></asp:Label></p>
                </div>
                <div class="activity-score">
                    <asp:Label ID="lblRecentScore" runat="server"></asp:Label>%
                </div>
            </div>
        </asp:Panel>

    </div>
</asp:Content>