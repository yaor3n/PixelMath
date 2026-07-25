<%@ Page Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Dashboard.aspx.cs" Inherits="PixelMath.Lecturer_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page Specific Styles if needed -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Lecturer Dashboard 🏠
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="w-full px-4 sm:px-6 lg:px-8 space-y-6 pb-12">

        <!-- Lecturer Welcome Banner -->
        <div class="w-full bg-[#22C55E] rounded-[24px] p-6 sm:p-8 flex items-center justify-between overflow-hidden relative shadow-sm">
            <div class="relative z-10 pr-2">
                <div class="text-xs sm:text-sm font-bold text-white/80 mb-1">
                    <asp:Literal ID="litTimeGreeting" runat="server">Good day,</asp:Literal>
                </div>
                <div class="font-fredoka text-2xl sm:text-3xl text-white">
                    <asp:Literal ID="litLecturerName" runat="server"></asp:Literal>
                </div>
                <div class="text-xs sm:text-sm text-white/90 mt-1.5 font-medium leading-relaxed">
                    You have <span class="font-bold underline text-amber-200"><asp:Literal ID="litBannerPendingCount" runat="server">0</asp:Literal> pending submissions</span> waiting to be marked.
                </div>
            </div>
            <div class="hidden sm:block text-5xl opacity-20 select-none shrink-0">
                📚
            </div>
        </div>

        <!-- Quick Metric Cards -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 sm:gap-6">
            
            <!-- Card 1: Pending Markings -->
            <div class="w-full bg-white p-5 rounded-[22px] border border-slate-100 shadow-xs flex justify-between items-center relative overflow-hidden">
                <div class="absolute top-0 left-0 w-2 h-full bg-amber-400"></div>
                <div class="pr-2">
                    <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Pending Markings</span>
                    <div class="font-fredoka text-2xl sm:text-3xl text-slate-800 mt-1">
                        <asp:Literal ID="litPendingCount" runat="server">0</asp:Literal>
                    </div>
                    <a href="Lecturer-Manage-Quizzes.aspx" class="inline-block mt-2 text-xs font-bold text-indigo-600 hover:underline">Grade Attempts &rarr;</a>
                </div>
                <div class="text-2xl sm:text-3xl bg-amber-50 p-3 rounded-2xl shrink-0">📝</div>
            </div>

            <!-- Card 2: Unread Class Announcements -->
            <div class="w-full bg-white p-5 rounded-[22px] border border-slate-100 shadow-xs flex justify-between items-center relative overflow-hidden">
                <div class="absolute top-0 left-0 w-2 h-full bg-rose-400"></div>
                <div class="pr-2">
                    <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Unread Announcements</span>
                    <div class="font-fredoka text-2xl sm:text-3xl text-slate-800 mt-1">
                        <asp:Literal ID="litUnreadAnnouncements" runat="server">0</asp:Literal>
                    </div>
                    <a href="Lecturer-Announcements.aspx" class="inline-block mt-2 text-xs font-bold text-indigo-600 hover:underline">View Feed &rarr;</a>
                </div>
                <div class="text-2xl sm:text-3xl bg-rose-50 p-3 rounded-2xl shrink-0">🔔</div>
            </div>

            <!-- Card 3: Classes Taught -->
            <div class="w-full bg-white p-5 rounded-[22px] border border-slate-100 shadow-xs flex justify-between items-center relative overflow-hidden sm:col-span-2 lg:col-span-1">
                <div class="absolute top-0 left-0 w-2 h-full bg-[#22C55E]"></div>
                <div class="pr-2">
                    <span class="text-[10px] font-bold text-slate-400 uppercase tracking-wider">Classes Taught</span>
                    <div class="font-fredoka text-2xl sm:text-3xl text-slate-800 mt-1">
                        <asp:Literal ID="litClassCount" runat="server">0</asp:Literal>
                    </div>
                    <a href="Lecturer-Create-Class.aspx" class="inline-block mt-2 text-xs font-bold text-indigo-600 hover:underline">+ Add New Class &rarr;</a>
                </div>
                <div class="text-2xl sm:text-3xl bg-emerald-50 p-3 rounded-2xl shrink-0">🏫</div>
            </div>

        </div>

        <!-- Two Column Dashboard Grid -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            
            <!-- Table: Submissions Needing Grading -->
            <div class="w-full bg-white p-5 sm:p-6 rounded-[24px] border border-slate-100 shadow-xs">
                <div class="flex justify-between items-center mb-4">
                    <h2 class="font-fredoka text-base sm:text-lg text-slate-800">Pending Student Submissions</h2>
                    <a href="Lecturer-Manage-Quizzes.aspx" class="text-xs font-semibold text-indigo-600 hover:underline">View All</a>
                </div>

                <asp:Repeater ID="rptPendingAttempts" runat="server">
                    <HeaderTemplate>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left text-xs text-slate-600 whitespace-nowrap sm:whitespace-normal">
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
            <div class="w-full bg-white p-5 sm:p-6 rounded-[24px] border border-slate-100 shadow-xs">
                <div class="flex justify-between items-center mb-4 gap-2">
                    <h2 class="font-fredoka text-base sm:text-lg text-slate-800">Recent Quiz Activity</h2>
                    <a href="Lecturer-Create-Quiz.aspx" class="text-xs font-bold bg-[#22C55E] text-white px-3.5 py-1.5 rounded-full hover:bg-emerald-600 transition shrink-0">+ Create Quiz</a>
                </div>

                <asp:Repeater ID="rptRecentQuizzes" runat="server">
                    <ItemTemplate>
                        <div class="p-3.5 mb-3 rounded-2xl bg-slate-50 border border-slate-100 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-3">
                            <div>
                                <span class="text-[10px] font-bold bg-indigo-100 text-indigo-700 px-2 py-0.5 rounded-full">
                                    <%# Eval("ClassName") %>
                                </span>
                                <h3 class="font-bold text-xs sm:text-sm text-slate-800 mt-1"><%# Eval("Title") %></h3>
                                <p class="text-[11px] text-slate-400 mt-0.5">
                                    Duration: <%# Eval("DurationMinutes") %> mins | Passing: <%# Eval("PassingMarks") %> pts
                                </p>
                            </div>
                            <a href='<%# "Lecturer-View-Attempts.aspx?quizId=" + Eval("QuizId") %>' 
                               class="text-xs font-bold text-indigo-600 hover:text-indigo-800 bg-white border border-slate-200 px-3 py-1.5 rounded-xl shadow-xs shrink-0 self-end sm:self-center">
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

    </div>
</asp:Content>