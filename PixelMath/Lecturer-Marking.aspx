<%@ Page Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Marking.aspx.cs" Inherits="PixelMath.Lecturer_Marking" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page Specific Styles if needed -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Grade Subjective Submissions ✍️
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="w-full px-4 sm:px-6 lg:px-8 space-y-6 pb-12">

        <!-- Alert Message -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- Header Card -->
        <div class="bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs">
            <h2 class="font-fredoka text-lg text-slate-800 mb-2">Subjective Quiz Grading</h2>
            <p class="text-xs text-slate-400">Review student written responses, award marks, and provide constructive feedback.</p>
        </div>

        <!-- Step 1: Select Quiz Pending Review -->
        <div class="bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs space-y-4">
            <h2 class="font-fredoka text-lg text-slate-800 mb-4 pb-2 border-b border-slate-100">1. Select Quiz</h2>
            <div class="flex items-center gap-4">
                <asp:DropDownList ID="ddlQuizzes" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlQuizzes_SelectedIndexChanged"
                    CssClass="w-full max-w-md bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E] text-slate-700">
                </asp:DropDownList>
            </div>
        </div>

        <!-- Step 2: Select Student Attempt -->
        <asp:Panel ID="pnlAttempts" runat="server" Visible="false" CssClass="bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs space-y-4">
            <h2 class="font-fredoka text-lg text-slate-800 mb-4 pb-2 border-b border-slate-100">2. Select Student Submission</h2>
            <div class="space-y-3">
                <asp:Repeater ID="rptAttempts" runat="server" OnItemCommand="rptAttempts_ItemCommand">
                    <ItemTemplate>
                        <div class="flex items-center justify-between p-4 bg-slate-50 border border-slate-100 rounded-2xl">
                            <div>
                                <p class="font-bold text-slate-800 text-xs">Student: <%# Eval("StudentName") %></p>
                                <p class="text-[11px] text-slate-400 mt-1">Submitted At: <%# Eval("EndTime", "{0:yyyy-MM-dd HH:mm}") %></p>
                            </div>
                            <asp:Button ID="btnSelectAttempt" runat="server" Text="Grade Submission →" CommandName="GradeAttempt" CommandArgument='<%# Eval("AttemptId") %>'
                                CssClass="bg-[#22C55E] text-white text-xs font-bold px-4 py-2.5 rounded-2xl hover:bg-emerald-600 transition cursor-pointer" />
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            <asp:Label ID="lblNoAttempts" runat="server" Text="📋 No pending submissions found for this quiz." Visible="false" CssClass="text-xs text-slate-400 block py-4 text-center"></asp:Label>
        </asp:Panel>

        <!-- Step 3: Grading Interface (Answers) -->
        <asp:Panel ID="pnlGradingArea" runat="server" Visible="false" CssClass="bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs space-y-6">
            <h2 class="font-fredoka text-lg text-slate-800 mb-4 pb-2 border-b border-slate-100">
                3. Grading Answers for <span class="text-[#22C55E]"><asp:Literal ID="litStudentName" runat="server"></asp:Literal></span>
            </h2>

            <div class="space-y-6">
                <asp:Repeater ID="rptAnswers" runat="server">
                    <ItemTemplate>
                        <div class="p-6 bg-slate-50 border border-slate-100 rounded-[20px] space-y-4">
                            <asp:HiddenField ID="hfAnswerId" runat="server" Value='<%# Eval("AnswerId") %>' />
                            
                            <div class="flex justify-between items-start">
                                <h3 class="font-bold text-slate-800 text-xs">Question: <%# Eval("QuestionText") %></h3>
                                <span class="bg-indigo-50 text-indigo-700 font-semibold px-2.5 py-1 rounded-lg text-[10px] shrink-0">Max Marks: <%# Eval("MaxMarks") %></span>
                            </div>

                            <div class="bg-white p-4 rounded-xl border border-slate-200">
                                <p class="text-[11px] font-bold text-slate-400 uppercase tracking-wider mb-1">Student's Answer:</p>
                                <p class="text-xs text-slate-800 whitespace-pre-wrap"><%# Eval("AnswerText") %></p>
                            </div>

                            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
                                <div>
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Marks Awarded</label>
                                    <asp:TextBox ID="txtMarksAwarded" runat="server" Text='<%# Eval("MarksAwarded") %>' TextMode="Number" 
                                        CssClass="w-full bg-white border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" />
                                </div>
                                <div class="md:col-span-2">
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Lecturer Feedback</label>
                                    <asp:TextBox ID="txtFeedback" runat="server" Text='<%# Eval("LecturerFeedback") %>' TextMode="MultiLine" Rows="2" 
                                        CssClass="w-full bg-white border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" />
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <div class="pt-6 border-t border-slate-100 flex justify-end">
                <asp:Button ID="btnSubmitGrades" runat="server" Text="Save & Complete Grading 🚀" OnClick="btnSubmitGrades_Click"
                    CssClass="bg-[#22C55E] text-white text-xs font-bold px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer" />
            </div>
        </asp:Panel>

    </div>
</asp:Content>