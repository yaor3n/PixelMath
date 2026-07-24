<%@ Page Title="Manage Quizzes - PixelMath" Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Manage-Quizzes.aspx.cs" Inherits="PixelMath.Lecturer_Manage_Quizzes" %>

<asp:Content ID="ContentHead" ContentPlaceHolderID="head" runat="server">
    <style>
        .font-fredoka { font-family: 'Fredoka One', cursive; }
        .font-body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</asp:Content>

<asp:Content ID="ContentTopbar" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    <span class="font-fredoka text-xl text-slate-800 flex items-center gap-2">
        Manage Quizzes 📋
    </span>
</asp:Content>

<asp:Content ID="ContentMain" ContentPlaceHolderID="MainContent" runat="server">
    <div class="max-w-6xl">
        
        <!-- Top Bar Action Header -->
        <div class="flex justify-between items-center mb-6">
            <div>
                <h2 class="font-fredoka text-lg text-slate-800">Quiz Management</h2>
                <p class="text-xs text-slate-400">View, search, filter, and delete quizzes across your classes.</p>
            </div>
            <a href="Lecturer-Create-Quiz.aspx" class="bg-[#22C55E] text-white font-bold text-xs px-4 py-2.5 rounded-2xl hover:bg-emerald-600 transition shadow-xs">
                + Create New Quiz
            </a>
        </div>

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

    </div>
</asp:Content>