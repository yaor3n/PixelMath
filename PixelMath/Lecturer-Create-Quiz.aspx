<%@ Page Title="Create Quiz - PixelMath" Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Create-Quiz.aspx.cs" Inherits="PixelMath.Lecturer_Create_Quiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <asp:HiddenField ID="hfQuestionsJson" runat="server" />

    <main class="p-8 flex-1 max-w-5xl">

        <div class="mb-6">
            <h1 class="font-fredoka text-xl text-slate-800">Create New Quiz ✍️</h1>
        </div>

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

                <div class="md:col-span-2">
                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="2" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="Brief description of what this quiz covers"></asp:TextBox>
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

            <div id="questionsContainer" class="space-y-6"></div>

            <div id="emptyState" class="text-center py-10 text-slate-400 text-xs bg-slate-50 rounded-2xl border border-dashed border-slate-200">
                📝 No questions added yet. Click <strong>"+ Add Question"</strong> to start building your quiz.
            </div>
        </div>

        <div class="flex justify-end gap-4">
            <a href="Lecturer-Dashboard.aspx" class="bg-slate-100 text-slate-600 text-xs font-bold px-6 py-3 rounded-2xl hover:bg-slate-200 transition">Cancel</a>
            <asp:Button ID="btnSaveQuiz" runat="server" Text="🚀 Publish Quiz" OnClick="btnSaveQuiz_Click" OnClientClick="return serializeQuestions();" CssClass="bg-[#22C55E] text-white text-xs font-bold px-8 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer shadow-sm" />
        </div>

    </main>

    <script>
        let questionCount = 0;

        function addQuestionCard() {
            document.getElementById('emptyState').style.display = 'none';
            questionCount++;

            const container = document.getElementById('questionsContainer');
            const card = document.createElement('div');
            card.className = "p-5 rounded-2xl bg-slate-50 border border-slate-200 relative question-card";
            card.id = `qCard_${questionCount}`;

            const fileInputName = `qFile_${questionCount}`;

            card.innerHTML = `
                <div class="flex justify-between items-center mb-4">
                    <span class="font-fredoka text-sm text-slate-700">Question ${questionCount}</span>
                    <button type="button" onclick="removeQuestionCard('${card.id}')" class="text-rose-500 hover:text-rose-700 text-xs font-bold">🗑️ Remove</button>
                </div>

                <div class="space-y-4">

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                        <div>
                            <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Question Type</label>
                            <select class="q-type w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs focus:outline-none focus:border-[#22C55E]" onchange="toggleQuestionType('${card.id}')">
                                <option value="Objective">Objective (Multiple Choice)</option>
                                <option value="Subjective">Subjective (Short Answer / Essay)</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Marks</label>
                            <input type="number" min="1" value="1" class="q-marks w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs focus:outline-none focus:border-[#22C55E]" />
                        </div>
                    </div>

                    <div>
                        <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Question Image (optional)</label>
                        <input type="file" name="${fileInputName}" accept=".png,.jpg,.jpeg" class="q-image-file w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs focus:outline-none focus:border-[#22C55E]" />
                    </div>

                    <div>
                        <label class="block text-[11px] font-bold text-slate-500 uppercase mb-1">Question Text</label>
                        <textarea class="q-text w-full bg-white border border-slate-200 rounded-xl px-3 py-2 text-xs focus:outline-none focus:border-[#22C55E]" rows="2" placeholder="e.g. What is x if 2x + 6 = 14?"></textarea>
                    </div>

                    <div class="q-options-block grid grid-cols-1 md:grid-cols-2 gap-3">
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

                    <div class="q-subjective-note hidden text-[11px] text-slate-400 bg-white border border-dashed border-slate-200 rounded-xl px-3 py-2">
                        ℹ️ This question will require you to manually mark and give feedback once a student submits their answer.
                    </div>

                </div>
            `;

            container.appendChild(card);
        }

        function toggleQuestionType(cardId) {
            const card = document.getElementById(cardId);
            const type = card.querySelector('.q-type').value;
            const optionsBlock = card.querySelector('.q-options-block');
            const subjectiveNote = card.querySelector('.q-subjective-note');

            if (type === 'Subjective') {
                optionsBlock.classList.add('hidden');
                subjectiveNote.classList.remove('hidden');
            } else {
                optionsBlock.classList.remove('hidden');
                subjectiveNote.classList.add('hidden');
            }
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
                const qType = card.querySelector('.q-type').value;
                const qText = card.querySelector('.q-text').value.trim();
                const qMarks = parseInt(card.querySelector('.q-marks').value) || 1;
                const fileInput = card.querySelector('.q-image-file');
                const fileInputName = fileInput ? fileInput.getAttribute('name') : '';

                if (!qText) {
                    alert('Please fill out all question texts.');
                    return false;
                }

                const question = {
                    type: qType,
                    text: qText,
                    marks: qMarks,
                    fileInputName: fileInputName,
                    options: [],
                    correctIndex: -1
                };

                if (qType === 'Objective') {
                    const opt0 = card.querySelector('.q-opt-0').value.trim();
                    const opt1 = card.querySelector('.q-opt-1').value.trim();
                    const opt2 = card.querySelector('.q-opt-2').value.trim();
                    const opt3 = card.querySelector('.q-opt-3').value.trim();

                    if (!opt0 || !opt1 || !opt2 || !opt3) {
                        alert('Please fill out all 4 options for objective questions.');
                        return false;
                    }

                    const qNum = card.id.split('_')[1];
                    const selectedRadio = card.querySelector(`input[name="correct_${qNum}"]:checked`);
                    question.options = [opt0, opt1, opt2, opt3];
                    question.correctIndex = selectedRadio ? parseInt(selectedRadio.value) : 0;
                }

                questions.push(question);
            }

            document.getElementById('<%= hfQuestionsJson.ClientID %>').value = JSON.stringify(questions);
            return true;
        }
    </script>
</asp:Content>