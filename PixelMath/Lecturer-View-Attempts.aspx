<%@ Page Title="Student Attempts - PixelMath" Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-View-Attempts.aspx.cs" Inherits="PixelMath.Lecturer_View_Attempts" %>

<asp:Content ID="ContentTopbar" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    <span class="font-fredoka text-xl text-emerald-800 flex items-center gap-2">
        Student Attempts 📊
    </span>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main class="p-8 flex-1 max-w-5xl">

        <!-- Alert Message -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- ================= ATTEMPTS LIST & FILTERS ================= -->
        <asp:Panel ID="pnlList" runat="server">
            
            <!-- Top Bar Action Header -->
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h2 class="font-fredoka text-lg text-slate-800">Student Quiz Attempts</h2>
                    <p class="text-xs text-slate-400">Review student submissions and grades across your created quizzes.</p>
                </div>
            </div>

            <!-- Filter / Search Section -->
            <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs mb-8 flex flex-col md:flex-row items-center gap-4 justify-between">
                <div class="flex items-center gap-3 w-full md:w-auto">
                    <asp:TextBox ID="txtSearch" runat="server" Placeholder="Search student or quiz..." 
                        CssClass="bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E] w-full md:w-64"></asp:TextBox>
                    <asp:DropDownList ID="ddlFilterQuiz" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterQuiz_SelectedIndexChanged"
                        CssClass="bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E] text-slate-700">
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Filter 🔍" OnClick="btnSearch_Click" 
                    CssClass="bg-slate-800 text-white text-xs font-bold px-6 py-3 rounded-xl hover:bg-slate-900 transition cursor-pointer w-full md:w-auto" />
            </div>

            <!-- Attempts Table Card -->
            <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs">
                <asp:Repeater ID="rptAttempts" runat="server">
                    <HeaderTemplate>
                        <div class="overflow-x-auto">
                            <table class="w-full text-left text-xs text-slate-600">
                                <thead>
                                    <tr class="text-slate-400 border-b border-slate-100 font-bold uppercase">
                                        <th class="pb-3 px-3">Student Name</th>
                                        <th class="pb-3 px-3">Quiz Title</th>
                                        <th class="pb-3 px-3">Attempt Date</th>
                                        <th class="pb-3 px-3">Score</th>
                                        <th class="pb-3 px-3 text-right">Status</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-50">
                    </HeaderTemplate>
                    <ItemTemplate>
                                    <tr class="hover:bg-slate-50">
                                        <td class="py-4 px-3 font-bold text-slate-800">
                                            <%# Eval("StudentName") %>
                                        </td>
                                        <td class="py-4 px-3 font-semibold text-slate-700">
                                            <%# Eval("QuizTitle") %>
                                        </td>
                                        <td class="py-4 px-3 text-slate-400 text-[11px]">
                                            <%# Eval("StartTime") != DBNull.Value && Eval("StartTime") != null ? Convert.ToDateTime(Eval("StartTime")).ToString("MMM dd, yyyy HH:mm") : "-" %>
                                        </td>
                                        <td class="py-4 px-3 font-bold text-[#22C55E]">
                                            <%# Eval("Score") %> / <%# Eval("PassingMarks") %>
                                        </td>
                                        <td class="py-4 px-3 text-right">
                                            <%# Convert.ToBoolean(Eval("IsGraded")) 
                                                ? "<span class='bg-emerald-50 text-emerald-700 font-bold px-2.5 py-1 rounded-lg text-[10px]'>Graded</span>" 
                                                : "<span class='bg-amber-50 text-amber-700 font-bold px-2.5 py-1 rounded-lg text-[10px]'>Pending</span>" %>
                                        </td>
                                    </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                                </tbody>
                            </table>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>

                <asp:Panel ID="pnlNoAttempts" runat="server" Visible="false" CssClass="text-center py-10 text-slate-400 text-xs bg-slate-50 rounded-2xl border border-dashed border-slate-200">
                    📊 No student quiz attempts found matching your criteria.
                </asp:Panel>
            </div>

        </asp:Panel>

    </main>
</asp:Content>