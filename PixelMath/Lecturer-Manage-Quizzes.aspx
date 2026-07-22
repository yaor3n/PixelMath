<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lecturer-Manage-Quizzes.aspx.cs" Inherits="PixelMath.Lecturer_Manage_Quizzes" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Manage Quizzes - PixelMath</title>
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
                            <a href="Lecturer-Manage-Quizzes.aspx" class="nav-link flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
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
                        Manage Quizzes 📋
                    </h1>
                    <a href="Lecturer-Create-Quiz.aspx" class="bg-[#22C55E] text-white font-bold text-xs px-4 py-2.5 rounded-2xl hover:bg-emerald-600 transition shadow-xs">
                        + Create New Quiz
                    </a>
                </header>

                <main class="p-8 flex-1 max-w-6xl">
                    
                    <!-- Alert Message -->
                    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
                        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                    </asp:Panel>

                    <!-- Filter / Search Section -->
                    <div class="bg-white p-4 rounded-[20px] border border-slate-100 shadow-xs mb-6 flex flex-col md:flex-row items-center gap-4 justify-between">
                        <div class="flex items-center gap-3 w-full md:w-auto">
                            <asp:TextBox ID="txtSearch" runat="server" Placeholder="Search quiz title..." 
                                CssClass="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-xs focus:outline-none focus:border-[#22C55E] w-full md:w-64"></asp:TextBox>
                            <asp:DropDownList ID="ddlFilterClass" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterClass_SelectedIndexChanged"
                                CssClass="bg-slate-50 border border-slate-200 rounded-xl px-4 py-2 text-xs focus:outline-none focus:border-[#22C55E] text-slate-700">
                            </asp:DropDownList>
                        </div>
                        <asp:Button ID="btnSearch" runat="server" Text="Filter 🔍" OnClick="btnSearch_Click" 
                            CssClass="bg-slate-800 text-white text-xs font-bold px-4 py-2 rounded-xl hover:bg-slate-900 transition cursor-pointer w-full md:w-auto" />
                    </div>

                    <!-- Quizzes Table Card -->
                    <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs">
                        
                        <asp:Repeater ID="rptQuizzes" runat="server" OnItemCommand="rptQuizzes_ItemCommand">
                            <HeaderTemplate>
                                <div class="overflow-x-auto">
                                    <table class="w-full text-left text-xs text-slate-600">
                                        <thead>
                                            <tr class="text-slate-400 border-b border-slate-100 font-bold uppercase">
                                                <th class="pb-3 px-3">Quiz Title</th>
                                                <th class="pb-3 px-3">Class</th>
                                                <th class="pb-3 px-3">Duration</th>
                                                <th class="pb-3 px-3">Passing Marks</th>
                                                <th class="pb-3 px-3">Created</th>
                                                <th class="pb-3 px-3 text-right">Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody class="divide-y divide-slate-50">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <tr class="hover:bg-slate-50">
                                    <td class="py-4 px-3 font-bold text-slate-800">
                                        <%# Eval("Title") %>
                                    </td>
                                    <td class="py-4 px-3">
                                        <span class="bg-indigo-50 text-indigo-700 font-semibold px-2.5 py-1 rounded-lg text-[10px]">
                                            <%# Eval("ClassName") %>
                                        </span>
                                    </td>
                                    <td class="py-4 px-3 font-semibold text-slate-600">
                                        ⏱️ <%# Eval("DurationMinutes") %> mins
                                    </td>
                                    <td class="py-4 px-3 font-semibold text-slate-600">
                                        🎯 <%# Eval("PassingMarks") %> pts
                                    </td>
                                    <td class="py-4 px-3 text-slate-400 text-[11px]">
                                        <%# Eval("CreatedAt", "{0:MMM dd, yyyy}") %>
                                    </td>
                                    <td class="py-4 px-3 text-right">
                                        <div class="flex items-center justify-end gap-2">
                                            <a href='<%# "Quizzes/Attempts.aspx?quizId=" + Eval("QuizId") %>' 
                                               class="bg-emerald-50 text-emerald-700 hover:bg-emerald-100 px-3 py-1.5 rounded-xl font-bold text-[11px] transition">
                                                Attempts 📊
                                            </a>
                                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteQuiz" CommandArgument='<%# Eval("QuizId") %>'
                                                OnClientClick="return confirm('Are you sure you want to delete this quiz? All related attempts will be removed.');"
                                                CssClass="bg-rose-50 text-rose-600 hover:bg-rose-100 px-3 py-1.5 rounded-xl font-bold text-[11px] transition">
                                                Delete 🗑️
                                            </asp:LinkButton>
                                        </div>
                                    </td>
                                </tr>
                            </ItemTemplate>
                            <FooterTemplate>
                                        </tbody>
                                    </table>
                                </div>
                            </FooterTemplate>
                        </asp:Repeater>

                        <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false" CssClass="text-center py-12 text-slate-400 text-xs">
                            📋 No quizzes found matching your criteria.
                        </asp:Panel>

                    </div>

                </main>
            </div>

        </div>

    </form>
</body>
</html>