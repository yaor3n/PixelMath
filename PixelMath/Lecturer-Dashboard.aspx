<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lecturer-Dashboard.aspx.cs" Inherits="PixelMath.Lecturer_Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lecturer Dashboard - PixelMath</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Fredoka+One&family=Plus+Jakarta+Sans:wght@400;600;700&display=swap" rel="stylesheet">
    
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    
    <style>
        .font-fredoka { font-family: 'Fredoka One', cursive; }
        .font-body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="bg-[#F8FAFC] font-body text-slate-800 min-h-screen">
    <form id="form1" runat="server">
        
        <div class="flex min-h-screen">
            
            <!-- ══════════════════════════════════════════════════════════ -->
            <!-- SELF-CONTAINED LECTURER SIDEBAR                          -->
            <!-- ══════════════════════════════════════════════════════════ -->
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
                    <ul class="space-y-1 mb-6 text-xs font-semibold">
                        <li>
                            <a href="Lecturer-Dashboard.aspx" class="flex items-center gap-3 p-3 rounded-2xl bg-[#22C55E] text-white font-bold shadow-xs">
                                <span>🏠</span> Dashboard
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Announcements.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>📢</span> Announcements
                            </a>
                        </li>
                    </ul>

                    <div class="text-[10px] font-bold text-slate-400 uppercase tracking-wider mb-2">Teaching</div>
                    <ul class="space-y-1 mb-6 text-xs font-semibold">
                        <li>
                            <a href="Lecturer-Create-Class.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>🏫</span> Create Class
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Create-Quiz.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>➕</span> Create Quiz
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Manage-Quizzes.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>📋</span> Manage Quizzes
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Upload-Resources.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>📁</span> Upload Resources
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Logout Button -->
                <div>
                    <asp:LinkButton ID="btnLogout" runat="server" OnClick="btnLogout_Click" 
                        CssClass="flex items-center gap-2 text-xs font-bold text-rose-500 hover:bg-rose-50 p-3 rounded-2xl transition w-full">
                        🚪 Logout
                    </asp:LinkButton>
                </div>
            </aside>

            <!-- ══════════════════════════════════════════════════════════ -->
            <!-- MAIN CONTENT WORKSPACE                                    -->
            <!-- ══════════════════════════════════════════════════════════ -->
            <div class="flex-1 flex flex-col min-w-0">
                
                <!-- Topbar Header -->
                <header class="bg-white border-b border-slate-100 px-8 py-5 flex justify-between items-center">
                    <h1 class="font-fredoka text-xl text-slate-800">
                        Lecturer Dashboard 🏠
                    </h1>
                </header>

                <!-- Page Body -->
                <main class="p-8 flex-1">
                    
                    <!-- Lecturer Welcome Banner -->
                    <div class="bg-[#22C55E] rounded-[24px] px-8 py-6 mb-8 flex items-center justify-between overflow-hidden relative shadow-sm">
                        <div class="relative z-10">
                            <div class="text-xs md:text-sm font-bold text-white/80 mb-1">
                                <asp:Literal ID="litTimeGreeting" runat="server">Good day,</asp:Literal>
                            </div>
                            <div class="font-fredoka text-2xl md:text-3xl text-white">
                                <asp:Literal ID="litLecturerName" runat="server"></asp:Literal>
                            </div>
                            <div class="text-xs md:text-sm text-white/90 mt-1 font-medium">
                                You have <span class="font-bold underline text-amber-200"><asp:Literal ID="litBannerPendingCount" runat="server">0</asp:Literal> pending submissions</span> waiting to be marked.
                            </div>
                        </div>
                        <div class="hidden sm:block text-5xl opacity-20 select-none">
                            📚
                        </div>
                    </div>

                    <!-- Quick Metric Cards -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
                        
                        <!-- Card 1: Pending Markings -->
                        <div class="bg-white p-6 rounded-[20px] border border-slate-100 shadow-xs flex justify-between items-center relative overflow-hidden">
                            <div class="absolute top-0 left-0 w-2 h-full bg-amber-400"></div>
                            <div>
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Pending Markings</span>
                                <div class="font-fredoka text-3xl text-slate-800 mt-1">
                                    <asp:Literal ID="litPendingCount" runat="server">0</asp:Literal>
                                </div>
                                <a href="Lecturer-Manage-Quizzes.aspx" class="inline-block mt-2 text-xs font-bold text-indigo-600 hover:underline">Grade Attempts &rarr;</a>
                            </div>
                            <div class="text-3xl bg-amber-50 p-3 rounded-2xl">📝</div>
                        </div>

                        <!-- Card 2: Unread Class Announcements -->
                        <div class="bg-white p-6 rounded-[20px] border border-slate-100 shadow-xs flex justify-between items-center relative overflow-hidden">
                            <div class="absolute top-0 left-0 w-2 h-full bg-rose-400"></div>
                            <div>
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Unread Announcements</span>
                                <div class="font-fredoka text-3xl text-slate-800 mt-1">
                                    <asp:Literal ID="litUnreadAnnouncements" runat="server">0</asp:Literal>
                                </div>
                                <a href="Lecturer-Announcements.aspx" class="inline-block mt-2 text-xs font-bold text-indigo-600 hover:underline">View Feed &rarr;</a>
                            </div>
                            <div class="text-3xl bg-rose-50 p-3 rounded-2xl">🔔</div>
                        </div>

                        <!-- Card 3: Classes Taught -->
                        <div class="bg-white p-6 rounded-[20px] border border-slate-100 shadow-xs flex justify-between items-center relative overflow-hidden">
                            <div class="absolute top-0 left-0 w-2 h-full bg-[#22C55E]"></div>
                            <div>
                                <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Classes Taught</span>
                                <div class="font-fredoka text-3xl text-slate-800 mt-1">
                                    <asp:Literal ID="litClassCount" runat="server">0</asp:Literal>
                                </div>
                                <a href="Lecturer-Create-Class.aspx" class="inline-block mt-2 text-xs font-bold text-indigo-600 hover:underline">+ Add New Class &rarr;</a>
                            </div>
                            <div class="text-3xl bg-emerald-50 p-3 rounded-2xl">🏫</div>
                        </div>

                    </div>

                    <!-- Two Column Dashboard Grid -->
                    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                        
                        <!-- Table: Submissions Needing Grading -->
                        <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs">
                            <div class="flex justify-between items-center mb-4">
                                <h2 class="font-fredoka text-lg text-slate-800">Pending Student Submissions</h2>
                                <a href="Lecturer-Manage-Quizzes.aspx" class="text-xs font-semibold text-indigo-600 hover:underline">View All</a>
                            </div>

                            <asp:Repeater ID="rptPendingAttempts" runat="server">
                                <HeaderTemplate>
                                    <div class="overflow-x-auto">
                                        <table class="w-full text-left text-xs text-slate-600">
                                            <thead>
                                                <tr class="text-slate-400 border-b border-slate-100 font-bold uppercase">
                                                    <th class="pb-3 px-2">Student</th>
                                                    <th class="pb-3 px-2">Quiz</th>
                                                    <th class="pb-3 px-2">Submitted</th>
                                                    <th class="pb-3 px-2 text-right">Action</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-slate-50">
                                </HeaderTemplate>
                                <ItemTemplate>
                                    <tr class="hover:bg-slate-50">
                                        <td class="py-3 px-2 font-bold text-slate-700"><%# Eval("FullName") %></td>
                                        <td class="py-3 px-2 text-slate-600"><%# Eval("QuizTitle") %></td>
                                        <td class="py-3 px-2 text-slate-400"><%# Eval("EndTime", "{0:MMM dd, HH:mm}") %></td>
                                        <td class="py-3 px-2 text-right">
                                            <a href='<%# "Quizzes/MarkAttempt.aspx?attemptId=" + Eval("AttemptId") %>' 
                                               class="bg-amber-100 text-amber-800 hover:bg-amber-200 px-3 py-1.5 rounded-full font-bold text-[11px] transition inline-block">
                                                Mark
                                            </a>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <FooterTemplate>
                                            </tbody>
                                        </table>
                                    </div>
                                </FooterTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoPending" runat="server" Visible="false" CssClass="text-center py-8 text-slate-400 text-xs">
                                🎉 All submitted quizzes are fully graded!
                            </asp:Panel>
                        </div>

                        <!-- Section: Recent Quizzes Created -->
                        <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs">
                            <div class="flex justify-between items-center mb-4">
                                <h2 class="font-fredoka text-lg text-slate-800">Recent Quiz Activity</h2>
                                <a href="Lecturer-Create-Quiz.aspx" class="text-xs font-bold bg-[#22C55E] text-white px-3 py-1.5 rounded-full hover:bg-emerald-600 transition">+ Create Quiz</a>
                            </div>

                            <asp:Repeater ID="rptRecentQuizzes" runat="server">
                                <ItemTemplate>
                                    <div class="p-3 mb-3 rounded-2xl bg-slate-50 border border-slate-100 flex items-center justify-between">
                                        <div>
                                            <span class="text-[10px] font-bold bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded-full">
                                                <%# Eval("ClassName") %>
                                            </span>
                                            <h3 class="font-bold text-xs text-slate-800 mt-1"><%# Eval("Title") %></h3>
                                            <p class="text-[11px] text-slate-400 mt-0.5">
                                                Duration: <%# Eval("DurationMinutes") %> mins | Passing: <%# Eval("PassingMarks") %> pts
                                            </p>
                                        </div>
                                        <a href='<%# "Quizzes/Attempts.aspx?quizId=" + Eval("QuizId") %>' 
                                           class="text-xs font-bold text-indigo-600 hover:text-indigo-800 bg-white border border-slate-200 px-3 py-1.5 rounded-xl shadow-xs">
                                            View Attempts
                                        </a>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false" CssClass="text-center py-8 text-slate-400 text-xs">
                                📋 You haven't created any quizzes yet.
                            </asp:Panel>
                        </div>

                    </div>

                </main>
            </div>

        </div>

    </form>
</body>
</html>