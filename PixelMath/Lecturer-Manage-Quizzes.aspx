<%@ Page Title="Manage Quizzes - PixelMath" Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Manage-Quizzes.aspx.cs" Inherits="PixelMath.Lecturer_Manage_Quizzes" %>

<asp:Content ID="ContentTopbar" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    <span class="font-fredoka text-xl text-emerald-800 flex items-center gap-2">
        Manage Quizzes 📋
    </span>
</asp:Content>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <main class="p-8 flex-1 max-w-5xl">

        <!-- Alert Message -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- ================= VIEW 1: QUIZ LIST & FILTERS ================= -->
        <asp:Panel ID="pnlList" runat="server">
            
            <!-- Top Bar Action Header -->
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h2 class="font-fredoka text-lg text-slate-800">Quiz Management</h2>
                    <p class="text-xs text-slate-400">View, search, filter, edit, and delete quizzes across your classes.</p>
                </div>
                <a href="Lecturer-Create-Quiz.aspx" class="bg-[#22C55E] text-white font-bold text-xs px-4 py-2.5 rounded-xl hover:bg-emerald-600 transition shadow-xs flex items-center gap-2">
                    ➕ Create New Quiz
                </a>
            </div>

            <!-- Filter / Search Section -->
            <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs mb-8 flex flex-col md:flex-row items-center gap-4 justify-between">
                <div class="flex items-center gap-3 w-full md:w-auto">
                    <asp:TextBox ID="txtSearch" runat="server" Placeholder="Search quiz title..." 
                        CssClass="bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E] w-full md:w-64"></asp:TextBox>
                    <asp:DropDownList ID="ddlFilterClass" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlFilterClass_SelectedIndexChanged"
                        CssClass="bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E] text-slate-700">
                    </asp:DropDownList>
                </div>
                <asp:Button ID="btnSearch" runat="server" Text="Filter 🔍" OnClick="btnSearch_Click" 
                    CssClass="bg-slate-800 text-white text-xs font-bold px-6 py-3 rounded-xl hover:bg-slate-900 transition cursor-pointer w-full md:w-auto" />
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
                                            🎯 <%# Eval("PassingMarks") %>%
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
                                                <asp:LinkButton ID="btnEdit" runat="server" CommandName="EditQuiz" CommandArgument='<%# Eval("QuizId") %>'
                                                    CssClass="bg-sky-50 text-sky-700 hover:bg-sky-100 px-3 py-1.5 rounded-xl font-bold text-[11px] transition">
                                                    Edit ✏️
                                                </asp:LinkButton>
                                                <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteQuiz" CommandArgument='<%# Eval("QuizId") %>'
                                                    OnClientClick="return confirm('Are you sure you want to delete this quiz? All related questions and attempts will be removed.');"
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

                <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false" CssClass="text-center py-10 text-slate-400 text-xs bg-slate-50 rounded-2xl border border-dashed border-slate-200">
                    📋 No quizzes found matching your criteria.
                </asp:Panel>
            </div>
        </asp:Panel>


        <!-- ================= VIEW 2: EDIT QUIZ & QUESTIONS ================= -->
        <asp:Panel ID="pnlEdit" runat="server" Visible="false">
            <asp:HiddenField ID="hfEditingQuizId" runat="server" />
            
            <!-- Back Button Header -->
            <div class="flex justify-between items-center mb-6">
                <div>
                    <h2 class="font-fredoka text-lg text-slate-800">Edit Quiz & Questions</h2>
                    <p class="text-xs text-slate-400">Modify quiz details, structure, questions, and correct choices.</p>
                </div>
                <asp:Button ID="btnBackToList" runat="server" Text="← Back to Quizzes" OnClick="btnBackToList_Click"
                    CssClass="bg-slate-100 text-slate-600 font-bold text-xs px-6 py-2.5 rounded-2xl hover:bg-slate-200 transition cursor-pointer" />
            </div>

            <!-- Quiz Metadata Card -->
            <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs mb-8">
                <h2 class="font-fredoka text-lg text-slate-800 mb-4 pb-2 border-b border-slate-100">1. Quiz General Details</h2>
                
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-6">
                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Quiz Title</label>
                        <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]"></asp:TextBox>
                    </div>

                    <div class="md:col-span-2">
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Description</label>
                        <asp:TextBox ID="txtQuizDesc" runat="server" TextMode="MultiLine" Rows="2" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]"></asp:TextBox>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Duration (Minutes)</label>
                        <asp:TextBox ID="txtDuration" runat="server" TextMode="Number" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]"></asp:TextBox>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Passing Marks (%)</label>
                        <asp:TextBox ID="txtPassingMarks" runat="server" TextMode="Number" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]"></asp:TextBox>
                    </div>
                </div>

                <asp:Button ID="btnUpdateQuiz" runat="server" Text="💾 Save Quiz Details" OnClick="btnUpdateQuiz_Click" 
                    CssClass="bg-[#22C55E] text-white font-bold text-xs px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer shadow-sm" />
            </div>

            <!-- Quiz Questions List Card -->
            <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs mb-8">
                <h2 class="font-fredoka text-lg text-slate-800 mb-4 pb-2 border-b border-slate-100">2. Existing Questions</h2>
                
                <div class="space-y-4">
                    <asp:Repeater ID="rptQuestions" runat="server" OnItemCommand="rptQuestions_ItemCommand">
                        <ItemTemplate>
                            <div class="p-5 rounded-2xl border border-slate-200 bg-slate-50 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
                                <div>
                                    <p class="font-bold text-slate-800 text-xs mb-1">Question <%# Container.ItemIndex + 1 %>: <%# Eval("QuestionText") %></p>
                                    <div class="flex items-center gap-3 text-[11px] text-slate-400 font-semibold">
                                        <span>Type: <%# Eval("QuestionType") %></span>
                                        <span>•</span>
                                        <span>Marks: <%# Eval("Marks") %></span>
                                    </div>
                                </div>
                                <asp:Button ID="btnEditQuestion" runat="server" Text="Edit ✏️" CommandName="EditQ" CommandArgument='<%# Eval("QuestionId") %>' 
                                    CssClass="bg-indigo-50 text-indigo-700 hover:bg-indigo-100 font-bold text-xs px-4 py-2 rounded-xl transition shrink-0 cursor-pointer" />
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <!-- Edit Single Question Panel -->
            <asp:Panel ID="pnlEditSingleQuestion" runat="server" Visible="false" CssClass="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs mb-8">
                <asp:HiddenField ID="hfSelectedQuestionId" runat="server" />
                <h2 class="font-fredoka text-lg text-slate-800 mb-4 pb-2 border-b border-slate-100">3. Edit Question & Options</h2>
                
                <div class="space-y-4 mb-6">
                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Question Text</label>
                        <asp:TextBox ID="txtEditQText" runat="server" TextMode="MultiLine" Rows="2" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]"></asp:TextBox>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Marks</label>
                        <asp:TextBox ID="txtEditMarks" runat="server" TextMode="Number" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]"></asp:TextBox>
                    </div>

                    <h4 class="font-fredoka text-sm text-slate-700 pt-2">Choices / Options</h4>
                    <div class="space-y-3">
                        <asp:Repeater ID="rptOptions" runat="server">
                            <ItemTemplate>
                                <div class="flex items-center gap-3 bg-slate-50 p-4 rounded-xl border border-slate-200">
                                    <asp:HiddenField ID="hfOptionId" runat="server" Value='<%# Eval("OptionId") %>' />
                                    <asp:TextBox ID="txtOptionText" runat="server" Text='<%# Eval("OptionText") %>' CssClass="w-full bg-white border border-slate-200 rounded-xl px-4 py-2.5 text-xs focus:outline-none focus:border-[#22C55E]" />
                                    <label class="flex items-center gap-2 text-xs font-bold text-emerald-700 cursor-pointer shrink-0">
                                        <asp:CheckBox ID="chkIsCorrect" runat="server" Checked='<%# Convert.ToBoolean(Eval("IsCorrect")) %>' CssClass="rounded text-[#22C55E] focus:ring-[#22C55E]" /> 
                                        Correct
                                    </label>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </div>

                <div class="flex items-center gap-4">
                    <asp:Button ID="btnSaveQuestion" runat="server" Text="💾 Save Question Changes" OnClick="btnSaveQuestion_Click" 
                        CssClass="bg-[#22C55E] text-white font-bold text-xs px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer shadow-sm" />
                    <asp:Button ID="btnCancelEditQuestion" runat="server" Text="Cancel" OnClick="btnCancelEditQuestion_Click" 
                        CssClass="bg-slate-100 text-slate-600 font-bold text-xs px-6 py-3 rounded-2xl hover:bg-slate-200 transition cursor-pointer" />
                </div>
            </asp:Panel>

        </asp:Panel>

    </main>
</asp:Content>