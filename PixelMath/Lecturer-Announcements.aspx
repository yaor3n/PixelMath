<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lecturer-Announcements.aspx.cs" Inherits="PixelMath.Lecturer_Announcements" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Announcements - PixelMath</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka+One&family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .font-fredoka { font-family: 'Fredoka One', cursive; }
        .font-body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="bg-[#F8FAFC] font-body text-slate-800 min-h-screen">
    <form id="form1" runat="server">

        <div class="flex min-h-screen">
            
            <!-- SIDEBAR NAVIGATION -->
            <aside class="w-64 bg-white border-r border-slate-100 p-6 flex flex-col justify-between shrink-0">
                <div>
                    <!-- Logo Header -->
                    <div class="flex items-center gap-3 mb-8">
                        <div class="w-10 h-10 rounded-2xl bg-[#22C55E] flex items-center justify-center font-fredoka text-white text-xl shadow-xs">
                            P
                        </div>
                        <span class="font-fredoka text-2xl text-slate-800 tracking-wide">PixelMath</span>
                    </div>

                    <!-- Lecturer Profile Badge -->
                    <div class="bg-[#F0FDF4] border border-[#DCFCE7] rounded-[20px] p-4 mb-6 flex items-center gap-3">
                        <div class="w-10 h-10 rounded-2xl bg-[#22C55E] flex items-center justify-center text-white text-lg font-bold shadow-xs">
                            👨‍🏫
                        </div>
                        <div class="overflow-hidden">
                            <div class="font-bold text-xs text-slate-800 truncate">
                                <asp:Literal ID="litSidebarLecturerName" runat="server">Lecturer</asp:Literal>
                            </div>
                            <div class="text-[11px] text-[#16A34A] font-semibold">
                                Lecturer Portal
                            </div>
                        </div>
                    </div>

                    <!-- Navigation Links -->
                    <div class="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-2">Main</div>
                    <ul class="space-y-1 mb-6 text-xs font-semibold nav-menu">
                        <li>
                            <a href="Lecturer-Dashboard.aspx" class="nav-link flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>🏠</span> Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Announcements.aspx" class="nav-link flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>📢</span> Announcements
                            </a>
                        </li>
                    </ul>

                    <div class="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-2">Teaching</div>
                    <ul class="space-y-1 mb-6 text-xs font-semibold nav-menu">
                        <li>
                            <a href="Lecturer-Create-Class.aspx" class="nav-link flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>🏫</span> Create Class
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Create-Quiz.aspx" class="nav-link flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>➕</span> Create Quiz
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Manage-Quizzes/List.aspx" class="nav-link flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>📋</span> Manage Quizzes
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Upload-Resources.aspx" class="nav-link flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>📁</span> Upload Resources
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Logout -->
                <div>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" 
                        CssClass="flex items-center gap-2 text-xs font-bold text-rose-500 hover:bg-rose-50 p-3 rounded-2xl transition w-full">
                        🚪 Logout
                    </asp:LinkButton>
                </div>

                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                        const currentPage = window.location.pathname.split("/").pop().toLowerCase();
                        const navLinks = document.querySelectorAll(".nav-link");

                        navLinks.forEach(link => {
                            const linkPage = link.getAttribute("href").split("/").pop().toLowerCase();
                            if (currentPage === linkPage && linkPage !== "") {
                                link.className = "nav-link flex items-center gap-3 p-3 rounded-2xl bg-[#22C55E] text-white font-bold shadow-xs";
                            }
                        });
                    });
                </script>
            </aside>

            <!-- MAIN WORKSPACE -->
            <div class="flex-1 flex flex-col min-w-0">
                
                <header class="bg-white border-b border-slate-100 px-8 py-5 flex justify-between items-center">
                    <h1 class="font-fredoka text-xl text-slate-800">
                        Class Announcements 📢
                    </h1>
                </header>

                <main class="p-8 flex-1 max-w-6xl">
                    
                    <!-- Alert Message -->
                    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
                        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        
                        <!-- POST ANNOUNCEMENT FORM (2 Cols) -->
                        <div class="lg:col-span-2 bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs h-fit">
                            <h2 class="font-fredoka text-lg text-slate-800 mb-6 pb-2 border-b border-slate-100">
                                Send Announcement to Students
                            </h2>

                            <div class="space-y-6">
                                <!-- Target Class Dropdown -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Target Class *</label>
                                    <asp:DropDownList ID="ddlClasses" runat="server" 
                                        CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E] font-medium text-slate-700">
                                    </asp:DropDownList>
                                </div>

                                <!-- Announcement Title -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Title / Subject *</label>
                                    <asp:TextBox ID="txtTitle" runat="server" 
                                        CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" 
                                        placeholder="e.g., Mid-Term Exam Update"></asp:TextBox>
                                </div>

                                <!-- Announcement Message -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Message *</label>
                                    <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" 
                                        CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" 
                                        placeholder="Write your message to the enrolled students here..."></asp:TextBox>
                                </div>
                            </div>

                            <!-- Submit Button -->
                            <div class="mt-8 flex justify-end gap-4 border-t border-slate-100 pt-6">
                                <asp:Button ID="btnPostAnnouncement" runat="server" Text="Post Announcement 📣" OnClick="btnPostAnnouncement_Click"
                                    CssClass="bg-[#22C55E] text-white text-xs font-bold px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer" />
                            </div>
                        </div>

                        <!-- RECENT ANNOUNCEMENTS FEED (1 Col) -->
                        <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs h-fit">
                            <h2 class="font-fredoka text-md text-slate-800 mb-4 pb-2 border-b border-slate-100 flex justify-between items-center">
                                <span>Recent Posts</span>
                                <span class="bg-emerald-100 text-emerald-800 text-[10px] px-2 py-0.5 rounded-full font-bold">
                                    <asp:Literal ID="litAnnouncementCount" runat="server">0</asp:Literal>
                                </span>
                            </h2>

                            <asp:Repeater ID="rptAnnouncements" runat="server">
                                <ItemTemplate>
                                    <div class="p-4 mb-3 rounded-2xl bg-slate-50 border border-slate-100">
                                        <div class="flex justify-between items-start mb-1">
                                            <span class="font-bold text-xs text-slate-800"><%# Eval("Title") %></span>
                                            <span class="text-[9px] bg-slate-200 text-slate-600 font-bold px-2 py-0.5 rounded-md">
                                                <%# Eval("ClassName") %>
                                            </span>
                                        </div>
                                        <div class="text-[11px] text-slate-600 mt-2 leading-relaxed">
                                            <%# Eval("Message") %>
                                        </div>
                                        <div class="mt-3 text-[10px] text-slate-400 font-semibold">
                                            Posted: <%# Eval("CreatedAt", "{0:MMM dd, yyyy - hh:mm tt}") %>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoAnnouncements" runat="server" Visible="false" CssClass="text-center py-6 text-slate-400 text-xs">
                                📢 No announcements posted yet.
                            </asp:Panel>
                        </div>

                    </div>

                </main>
            </div>

        </div>

    </form>
</body>
</html>