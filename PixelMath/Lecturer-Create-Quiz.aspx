<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lecturer-Create-Quiz.aspx.cs" Inherits="PixelMath.Lecturer_Create_Quiz" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Quiz - PixelMath</title>
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
        <asp:HiddenField ID="hfQuestionsJson" runat="server" />

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
                <a href="Quizzes/List.aspx" class="nav-link flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
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

    <!-- AUTO-HIGHLIGHT ACTIVE LINK SCRIPT -->
    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const currentPage = window.location.pathname.split("/").pop().toLowerCase();
            const navLinks = document.querySelectorAll(".nav-link");

            navLinks.forEach(link => {
                const linkPage = link.getAttribute("href").split("/").pop().toLowerCase();
                if (currentPage === linkPage && linkPage !== "") {
                    // Apply green active styles
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
                        Create New Quiz ✍️
                    </h1>
                </header>

                <main class="p-8 flex-1 max-w-5xl">
                    
                    <!-- Alert Message Container -->
                    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
                        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                    </asp:Panel>

                    <!-- SECTION 1: QUIZ DETAILS -->
                    <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs mb-8">
                        <h2 class="font-fredoka text-lg text-slate-800 mb-4 pb-2 border-b border-slate-100">1. Quiz General Details</h2>
                        
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            
                            <div class="md:col-span-2">
                                <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Quiz Title</label>
                                <asp:TextBox ID="txtQuizTitle" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="e.g. Chapter 4: Quadratic Equations Quiz"></asp:TextBox>
                            </div>

                            <div>
                                <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Assign to Class</label>
                                <asp:DropDownList ID="ddlClass" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]">
                                </asp:DropDownList>
                            </div>

                            <div>
                                <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Duration (Minutes)</label>
                                <asp:TextBox ID="txtDuration" runat="server" TextMode="Number" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="30"></asp:TextBox>
                            </div>

                            <div>
                                <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Passing Marks (%)</label>
                                <asp:TextBox ID="txtPassingMarks" runat="server" TextMode="Number" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="50"></asp:TextBox>
                            </div>

                        </div>
                    </div>

                    <!-- SECTION 2: QUESTIONS BUILDER -->
                    <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs mb-8">
                        <div class="flex justify-between items-center mb-6 pb-2 border-b border-slate-100">
                            <h2 class="font-fredoka text-lg text-slate-800">2. Add Questions</h2>
                            <button type="button" onclick="addQuestionCard()" class="bg-[#22C55E] text-white text-xs font-bold px-4 py-2 rounded-xl hover:bg-emerald-600 transition flex items-center gap-2">
                                ➕ Add Question
                            </button>
                        </div>

                        <!-- Dynamic Questions Container -->
                        <div id="questionsContainer" class="space-y-6"></div>

                        <div id="emptyState" class="text-center py-10 text-slate-400 text-xs bg-slate-50 rounded-2xl border border-dashed border-slate-200">
                            📝 No questions added yet. Click <strong>"+ Add Question"</strong> to start building your quiz.
                        </div>
                    </div>

                    <!-- ACTION BUTTONS -->
                    <div class="flex justify-end gap-4">
                        <a href="Lecturer-Dashboard.aspx" class="bg-slate-100 text-slate-600 text-xs font-bold px-6 py-3 rounded-2xl hover:bg-slate-200 transition">Cancel</a>
                        <asp:Button ID="btnSaveQuiz" runat="server" Text="🚀 Publish Quiz" OnClick="btnSaveQuiz_Click" OnClientClick="return serializeQuestions();" CssClass="bg-[#22C55E] text-white text-xs font-bold px-8 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer shadow-sm" />
                    </div>

                </main>
            </div>

        </div>

    </form>

    <!-- FRONTEND DYNAMIC QUESTION BUILDER SCRIPT -->
    <script>
        let questionCount = 0;

        function addQuestionCard() {
            document.getElementById('emptyState').style.display = 'none';
            questionCount++;

            const container = document.getElementById('questionsContainer');
            const card = document.createElement('div');
            card.className = "p-5 rounded-2xl bg-slate-50 border border-slate-200 relative question-card";
            card.id = `qCard_${questionCount}`;

            card.innerHTML = `
                <div class="flex justify-between items-center mb-4">
                    <span class="font-fredoka text-sm text-slate-700">Question ${questionCount}</span>
                    <button type="button" onclick="removeQuestionCard('${card.id}')" class="text-rose-500 hover:text-rose-700 text-xs font-bold">🗑️ Remove</button>
                </div>

                <div class="space-y-4">
                    <div>
                        <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Question Text</label>
                        <input type="text" class="q-text w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="e.g. What is x if 2x + 6 = 14?" />
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                        <div>
                            <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Option A</label>
                            <div class="flex items-center gap-2">
                                <input type="radio" name="correct_${questionCount}" value="0" checked class="accent-[#22C55E]" />
                                <input type="text" class="q-opt-0 w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs" placeholder="Option A value" />
                            </div>
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Option B</label>
                            <div class="flex items-center gap-2">
                                <input type="radio" name="correct_${questionCount}" value="1" class="accent-[#22C55E]" />
                                <input type="text" class="q-opt-1 w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs" placeholder="Option B value" />
                            </div>
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Option C</label>
                            <div class="flex items-center gap-2">
                                <input type="radio" name="correct_${questionCount}" value="2" class="accent-[#22C55E]" />
                                <input type="text" class="q-opt-2 w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs" placeholder="Option C value" />
                            </div>
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Option D</label>
                            <div class="flex items-center gap-2">
                                <input type="radio" name="correct_${questionCount}" value="3" class="accent-[#22C55E]" />
                                <input type="text" class="q-opt-3 w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs" placeholder="Option D value" />
                            </div>
                        </div>
                    </div>
                </div>
            `;

            container.appendChild(card);
        }

        function removeQuestionCard(id) {
            const card = document.getElementById(id);
            if (card) card.remove();

            if (document.querySelectorAll('.question-card').length === 0) {
                document.getElementById('emptyState').style.display = 'block';
            }
        }

        function serializeQuestions() {
            const cards = document.querySelectorAll('.question-card');
            if (cards.length === 0) {
                alert('Please add at least one question before publishing.');
                return false;
            }

            const questions = [];

            for (let card of cards) {
                const qText = card.querySelector('.q-text').value.trim();
                const opt0 = card.querySelector('.q-opt-0').value.trim();
                const opt1 = card.querySelector('.q-opt-1').value.trim();
                const opt2 = card.querySelector('.q-opt-2').value.trim();
                const opt3 = card.querySelector('.q-opt-3').value.trim();
                
                const qNum = card.id.split('_')[1];
                const selectedRadio = card.querySelector(`input[name="correct_${qNum}"]:checked`);
                const correctIdx = selectedRadio ? parseInt(selectedRadio.value) : 0;

                if (!qText || !opt0 || !opt1 || !opt2 || !opt3) {
                    alert('Please fill out all question texts and options.');
                    return false;
                }

                questions.push({
                    text: qText,
                    options: [opt0, opt1, opt2, opt3],
                    correctIndex: correctIdx
                });
            }

            // Store JSON array string in hidden field for C# processing
            document.getElementById('<%= hfQuestionsJson.ClientID %>').value = JSON.stringify(questions);
            return true;
        }
    </script>
</body>
</html>