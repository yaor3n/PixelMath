<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Quiz.aspx.cs" Inherits="PixelMath.Student_Quiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Quiz-CSS.css" />
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Fredoka+One&display=swap" rel="stylesheet"/>
    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.9.14/dist/dotlottie-wc.js" type="module"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Take a Quiz 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="quiz-page">

        <!-- Panel 1: quiz list -->
        <asp:Panel ID="QuizListPanel" runat="server" Visible="true">
            <div class="quiz-filter">
                <div class="filter-left">
                    <div class="search-wrap">
                        <i class="fa-solid fa-magnifying-glass search-icon"></i>
                        <asp:TextBox ID="SearchQuiz" runat="server" Placeholder="Search quiz name..." onkeyup="applyFilters()" CssClass="search-input"></asp:TextBox>
                    </div>
                </div>

                <div class="filter-right">
                    <label for="FilterQuestionType" class="filter-label">Type:</label>
                    <asp:DropDownList ID="FilterQuestionType" runat="server" onchange="applyFilters()" CssClass="filter-dropdown">
                        <asp:ListItem Text="All Types" Value="All"></asp:ListItem>
                        <asp:ListItem Text="Objective" Value="Objective"></asp:ListItem>
                        <asp:ListItem Text="Subjective" Value="Subjective"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            
            <!-- 🎯 Main wrapper container to control visibility of fallback blocks cleanly -->
            <div id="quiz-list-wrapper" style="width: 100%;">
                <div id="quiz-content-grid" class="quiz-content">
                    <asp:Repeater ID="RepeatQuizzes" runat="server" OnItemCommand="repeatQuizzes_ItemCommand">
                        <ItemTemplate>
                            <!-- 🎯 FIXED: Added 'quiz-link-btn' to CssClass so JavaScript can select it -->
                            <asp:LinkButton ID="LinkSelectQuiz" runat="server" CommandName="SelectQuiz" CommandArgument='<%# Eval("QuizId") %>' CssClass="quiz-link-btn" style="text-decoration:none; color:inherit; display:block;">
                                <div class="quiz-card">
                                    <div class="card-top-info">
                                        <div class="quiz-icon">
                                            <i class="fa-solid fa-file-pen"></i>
                                        </div>

                                        <div class="quiz-meta-text">
                                            <h3><%# Eval("Title") %></h3>
                                            <p class="quiz-meta-text-sub">
                                                <%# Eval("DurationMinutes") %> min
                                            </p>
                                        </div>

                                        <div class="quiz-tag-wrapper">
                                            <span class="quiz-type-tag"><%# Eval("QuestionType") %></span>
                                        </div>
                                    </div>

                                    <div class="card-divider"></div>

                                    <div class="card-bottom-info">
                                        <span class="quiz-pass-mark">Pass Mark: <%# Eval("PassingMarks") %>%</span>
                                    </div>
                                </div>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </asp:Panel>

        <!-- Panel 2: quiz landing page -->
        <asp:Panel ID="QuizLandingPanel" runat="server" Visible="false">
            <div class="quiz-landing-container">
                <div class="quiz-landing-card">
                    <div class="landing-icon-wrapper">
                        <i class="fa-solid fa-circle-info"></i>
                    </div>
            
                    <h2 class="landing-title">
                        <asp:Label ID="LandingTitleLabel" runat="server"></asp:Label>
                    </h2>
                    <p class="landing-subtitle">Please review the instructions carefully before starting.</p>

                    <div class="quiz-landing-info-box">
                        <p><strong>Duration:</strong> <asp:Label ID="LandingDurationLabel" runat="server"></asp:Label> Minutes</p>
                        <p><strong>Passing Criteria:</strong> Score at least <asp:Label ID="LandingPassMarkLabel" runat="server"></asp:Label>% to pass</p>
                        <p>⚠️ <strong>Notice:</strong> Once initialized, the quiz system cannot be paused. Please ensure a stable network connection.</p>
                    </div>

                    <div class="quiz-landing-actions">
                        <asp:Button ID="BackQuizList" runat="server" Text="Back to Quizzes" CssClass="btn-cancel landing-btn" OnClick="btnBack_Click" />
                        <asp:Button ID="btnStartQuiz" runat="server" Text="Start Quiz Now" CssClass="btn-confirm landing-btn-start" OnClick="btnStartQuiz_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- Panel 3: active quiz -->
        <asp:Panel ID="ActiveQuizPanel" runat="server" Visible="false">
            <div class="quiz-header-bar">
                <asp:Label ID="ActiveQuizTitleLabel" runat="server"></asp:Label>
                <div class="timer-display">Time Remaining: --:--</div>
            </div>

            <!-- Hidden Fields for timer -->
            <asp:HiddenField ID="TotalDurationSecondsHidden" runat="server" Value="0" />
            <asp:HiddenField ID="SecondsRemainingHidden" runat="server" Value="0" />

            <!-- Outer Repeater for loading the list of Questions -->
            <asp:Repeater ID="RepeatQuestions" runat="server" OnItemDataBound="RepeatQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="card-quiz-q-card">
                        <asp:HiddenField ID="QuestionIdHiddenField" runat="server" Value='<%# Eval("QuestionId") %>' />
                        <asp:HiddenField ID="QuestionTypeHiddenField" runat="server" Value='<%# Eval("QuestionType") %>' />

                        <div class="active-quiz-top">
                            <div class="question-number">
                                Question <%# Container.ItemIndex + 1 %>
                            </div>
                
                            <!-- Question Text -->
                            <asp:Panel ID="pnlQuestionText" runat="server" CssClass="question">
                                <%# Eval("QuestionText") %>
                            </asp:Panel>
                        </div>
            
                        <!-- 🎯 QUESTION IMAGE CONTAINER -->
                        <asp:Panel ID="pnlQuestionImage" runat="server" Visible="false" Style="margin-top: 14px; text-align: center;">
                            <asp:Image ID="imgQuestion" runat="server" Style="max-width: 100%; max-height: 350px; border-radius: 12px; border: 1.5px solid #BBF7D0;" />
                        </asp:Panel>

                        <div class="options-block">
                            <asp:PlaceHolder ID="ObjectivePlaceHolder" runat="server" Visible="false">
                                <asp:RadioButtonList ID="OptionsButton" runat="server" CssClass="quiz-options-list" DataTextField="OptionText" DataValueField="OptionId">
                                </asp:RadioButtonList>
                            </asp:PlaceHolder>

                            <asp:PlaceHolder ID="SubjectivePlaceHolder" runat="server" Visible="false">
                                <div style="margin-top: 12px; width: 100%;">
                                    <asp:TextBox ID="TextBoxSubjectiveAnswer" runat="server" TextMode="MultiLine" Rows="4" Placeholder="Type your final answer here" Style="width:100%; max-width:100%; padding:12px; border:2px solid #E5E7EB; border-radius:12px; font-family:'Nunito', sans-serif; font-size:14px; outline:none; box-sizing:border-box; resize:vertical;"></asp:TextBox>
                                </div>
                            </asp:PlaceHolder>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="quiz-nav-buttons">
                <asp:Button ID="ButtonSubmitQuiz" runat="server" Text="Submit Assessment" CssClass="btn-confirm" OnClick="btnSubmitQuiz_Click" OnClientClick="saveRemainingTime();" />
            </div>
        </asp:Panel>

        <!-- Panel 4: quiz result -->
        <asp:Panel ID="QuizResultPanel" runat="server" Visible="false">
            <div class="quiz-landing-container">
                <div class="quiz-landing-card">
                    <dotlottie-wc
                      src="https://lottie.host/2075b9bb-32d3-4d2f-b285-afbe8670425a/MIyh4XFCCb.lottie"
                      style="width: 120px;height: 120px; display:inline-block;"
                      autoplay
                      loop
                    ></dotlottie-wc>
                    <p>Congratulations</p>

                    <div class="quiz-result">
                        <h3>
                            Score: <asp:Label ID="FinalScore" runat="server"></asp:Label>
                        </h3>
                        <p>
                            Total Time Used: <asp:Label ID="TimeUsed" runat="server"></asp:Label>
                        </p>
                    </div>

                    <div class="quiz-landing-actions">
                        <asp:Button ID="FinishQuiz" runat="server" Text="Return to Quiz Menu" CssClass="landing-btn-start" OnClick="btnBack_Click" style="width:100%;" />
                    </div>
                </div>
            </div>
        </asp:Panel>
    </div>

    <script type="text/javascript">
        var internalTimer;
        
        function initializeFrontendTimer() {
            var durationInput = document.getElementById('<%= TotalDurationSecondsHidden.ClientID %>').value;
            var timeRemaining = parseInt(durationInput);

            if (isNaN(timeRemaining) || timeRemaining <= 0) return;

            clearInterval(internalTimer);
            updateClockUI(timeRemaining);

            internalTimer = setInterval(function () {
                timeRemaining--;
                document.getElementById('<%= SecondsRemainingHidden.ClientID %>').value = timeRemaining;
                updateClockUI(timeRemaining);

                if (timeRemaining <= 0) {
                    clearInterval(internalTimer);
                    alert("Time is up! Your quiz answers are being submitted automatically now.");
                    document.getElementById('<%= ButtonSubmitQuiz.ClientID %>').click();
                }
            }, 1000);
        }

        function updateClockUI(secondsLeft) {
            var mins = Math.floor(secondsLeft / 60);
            var secs = secondsLeft % 60;
            if (secs < 10) secs = "0" + secs;

            // 🎯 THE SWITCH: querySelector(".timer-display") finds the element by its class name!
            var timerEl = document.querySelector(".timer-display");
            if (timerEl) {
                timerEl.innerText = "Time Remaining: " + mins + ":" + secs;
            }
        }

        function saveRemainingTime() {
            clearInterval(internalTimer);
        }

        function applyFilters() {
            var searchInput, searchFilter, dropdown, typeFilter, wrapper, gridContainer, cards, titleEl, typeEl, i;

            // 1. Grab inputs and filters
            searchInput = document.getElementById('<%= SearchQuiz.ClientID %>');
            searchFilter = searchInput.value.toUpperCase();

            dropdown = document.getElementById('<%= FilterQuestionType.ClientID %>');
            typeFilter = dropdown.value.toUpperCase();

            wrapper = document.getElementById("quiz-list-wrapper");
            gridContainer = document.getElementById("quiz-content-grid");
            cards = gridContainer.getElementsByClassName("quiz-link-btn");

            // "No matching items found" block layout
            var noResultsBlock = wrapper.querySelector(".no-quiz-row");
            if (noResultsBlock) {
                noResultsBlock.remove();
            }

            var hasResults = false;

            // 3. Evaluate matching metrics
            for (i = 0; i < cards.length; i++) {
                titleEl = cards[i].querySelector(".quiz-meta-text h3");
                typeEl = cards[i].querySelector(".quiz-type-tag");

                if (titleEl && typeEl) {
                    var titleText = (titleEl.textContent || titleEl.innerText).toUpperCase();
                    var typeText = (typeEl.textContent || typeEl.innerText).toUpperCase();

                    var matchesSearch = titleText.indexOf(searchFilter) > -1;
                    var matchesType = (typeFilter === "ALL") || (typeText === typeFilter);

                    if (matchesSearch && matchesType) {
                        cards[i].style.display = "";
                        hasResults = true;
                    } else {
                        cards[i].style.display = "none";
                    }
                }
            }

            // 4. Handle UI visibility toggling based on results status
            if (hasResults) {
                gridContainer.style.display = "grid"; // Show original card grid layout context
            } else {
                gridContainer.style.display = "none"; // Hide empty grid entirely so card doesn't sit at the bottom

                var newFallback = document.createElement("div");
                newFallback.className = "no-quiz-row";
                newFallback.innerHTML = '<img src="result-no-found.png" width="65" height="55" alt="Empty Search View" style="margin-bottom:8px;" /><br/>No quizzes found matching your search metrics.';

                wrapper.appendChild(newFallback);
            }
        }
    </script>
</asp:Content>