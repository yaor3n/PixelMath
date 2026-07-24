<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lecturer-Marking.aspx.cs" Inherits="PixelMath.Lecturer_Marking" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Grade Subjective Submissions - Pixel Math</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="images/pixelmath_logo.png"/>
</head>
<body class="min-h-screen flex flex-col bg-slate-50">
<form id="form1" runat="server">

    <!-- Navbar -->
    <header class="bg-green-50 border-b-4 border-green-400 py-4 px-8 flex items-center justify-between">
        <div class="flex items-center space-x-3 cursor-pointer" onclick="window.location.href='Lecturer-Dashboard.aspx'">
            <img src="images/pixelmath_logo_transparentbg.png" alt="Pixel Math Logo" class="w-10 h-10"/>
            <span class="text-green-800 text-xl font-bold">Pixel Math - Lecturer Portal</span>
        </div>
        <div>
            <asp:Button ID="btnBack" runat="server" Text="← Back to Dashboard" OnClick="btnBack_Click" CssClass="border border-green-700 text-green-700 px-4 py-2 rounded-md font-semibold hover:bg-green-100 transition duration-300 text-sm cursor-pointer bg-transparent" />
        </div>
    </header>

    <!-- Main Container -->
    <main class="py-10 px-8 max-w-5xl mx-auto w-full flex-1 space-y-6">
        
        <div class="bg-white border border-green-100 rounded-2xl p-6 shadow-xs">
            <h1 class="text-2xl font-bold text-green-900 mb-2">✍️ Subjective Quiz Grading</h1>
            <p class="text-green-700 text-sm">Review student written responses, award marks, and provide constructive feedback.</p>
        </div>

        <!-- Alert Notification Panel -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false">
            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        </asp:Panel>

        <!-- Step 1: Select Quiz Pending Review -->
        <div class="bg-white border border-green-100 rounded-2xl p-6 shadow-xs space-y-4">
            <h2 class="text-lg font-bold text-green-900">1. Select Quiz</h2>
            <div class="flex items-center gap-4">
                <asp:DropDownList ID="ddlQuizzes" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlQuizzes_SelectedIndexChanged"
                    CssClass="w-full max-w-md border border-green-300 rounded-xl p-3 text-sm text-green-900 bg-green-50/30 focus:ring-2 focus:ring-green-500 outline-hidden">
                </asp:DropDownList>
            </div>
        </div>

        <!-- Step 2: Select Student Attempt -->
        <asp:Panel ID="pnlAttempts" runat="server" Visible="false" CssClass="bg-white border border-green-100 rounded-2xl p-6 shadow-xs space-y-4">
            <h2 class="text-lg font-bold text-green-900">2. Select Student Submission</h2>
            <asp:Repeater ID="rptAttempts" runat="server" OnItemCommand="rptAttempts_ItemCommand">
                <ItemTemplate>
                    <div class="flex items-center justify-between p-4 bg-green-50/50 border border-green-100 rounded-xl mb-3">
                        <div>
                            <p class="font-bold text-green-900 text-sm">Student: <%# Eval("StudentName") %></p>
                            <p class="text-xs text-green-600">Submitted At: <%# Eval("EndTime", "{0:yyyy-MM-dd HH:mm}") %></p>
                        </div>
                        <asp:Button ID="btnSelectAttempt" runat="server" Text="Grade Submission →" CommandName="GradeAttempt" CommandArgument='<%# Eval("AttemptId") %>'
                            CssClass="bg-green-600 text-white text-xs font-semibold px-4 py-2 rounded-lg hover:bg-green-700 transition cursor-pointer" />
                    </div>
                </ItemTemplate>
            </asp:Repeater>
            <asp:Label ID="lblNoAttempts" runat="server" Text="No pending submissions found for this quiz." Visible="false" CssClass="text-sm text-green-700 italic"></asp:Label>
        </asp:Panel>

        <!-- Step 3: Grading Interface (Answers) -->
        <asp:Panel ID="pnlGradingArea" runat="server" Visible="false" CssClass="bg-white border border-green-100 rounded-2xl p-6 shadow-xs space-y-6">
            <div class="flex justify-between items-center border-b border-green-100 pb-4">
                <h2 class="text-lg font-bold text-green-900">3. Grading Answers for <asp:Literal ID="litStudentName" runat="server"></asp:Literal></h2>
            </div>

            <asp:Repeater ID="rptAnswers" runat="server">
                <ItemTemplate>
                    <div class="p-5 bg-green-50/30 border border-green-200 rounded-xl space-y-3">
                        <asp:HiddenField ID="hfAnswerId" runat="server" Value='<%# Eval("AnswerId") %>' />
                        
                        <div class="flex justify-between items-start">
                            <h3 class="font-bold text-green-900 text-sm">Question: <%# Eval("QuestionText") %></h3>
                            <span class="bg-green-100 text-green-800 text-xs font-bold px-2.5 py-1 rounded-md">Max Marks: <%# Eval("MaxMarks") %></span>
                        </div>

                        <div class="bg-white p-3 rounded-lg border border-slate-200">
                            <p class="text-xs font-semibold text-slate-500 mb-1">Student's Answer:</p>
                            <p class="text-sm text-slate-800 whitespace-pre-wrap"><%# Eval("AnswerText") %></p>
                        </div>

                        <div class="grid grid-cols-1 md:grid-cols-3 gap-4 pt-2">
                            <div>
                                <label class="block text-xs font-bold text-green-900 mb-1">Marks Awarded:</label>
                                <asp:TextBox ID="txtMarksAwarded" runat="server" Text='<%# Eval("MarksAwarded") %>' TextMode="Number" 
                                    CssClass="w-full border border-green-300 rounded-lg p-2 text-sm text-green-900 bg-white outline-hidden focus:ring-2 focus:ring-green-500" />
                            </div>
                            <div class="md:col-span-2">
                                <label class="block text-xs font-bold text-green-900 mb-1">Lecturer Feedback:</label>
                                <asp:TextBox ID="txtFeedback" runat="server" Text='<%# Eval("LecturerFeedback") %>' TextMode="MultiLine" Rows="2" 
                                    CssClass="w-full border border-green-300 rounded-lg p-2 text-sm text-green-900 bg-white outline-hidden focus:ring-2 focus:ring-green-500" />
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="pt-4 text-right">
                <asp:Button ID="btnSubmitGrades" runat="server" Text="Save & Complete Grading" OnClick="btnSubmitGrades_Click"
                    CssClass="bg-green-600 text-white font-semibold px-6 py-3 rounded-xl hover:bg-green-700 transition cursor-pointer text-sm shadow-md" />
            </div>
        </asp:Panel>

    </main>

    <!-- Footer -->
    <footer class="bg-green-50 border-t-4 border-green-400 py-6 px-8 text-center text-green-700 text-sm">
        &copy; Pixel Math 2026
    </footer>

</form>
</body>
</html>