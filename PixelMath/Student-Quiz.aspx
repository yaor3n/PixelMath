<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Quiz.aspx.cs" Inherits="PixelMath.Student_Quiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Quiz-CSS.css" />
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Fredoka+One&display=swap" rel="stylesheet"/>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Take a Quiz 
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="quiz-page">

        <!-- Panel 1: quiz list -->
        <asp:Panel ID="QuizListPanel" runat="server" Visible="true">
            <div class="quiz-filter">
                <p>Available Quizzes</p>
            </div>
            <div class="quiz-content">
                <asp:Repeater ID="RepeatQuizzes" runat="server" OnItemCommand="repeatQuizzes_ItemCommand">
                    <ItemTemplate>
                        <!-- make the card become button -->
                        <asp:LinkButton ID="LinkSelectQuiz" runat="server" CommandName="SelectQuiz" CommandArgument='<%# Eval("QuizId") %>' style="text-decoration:none; color:inherit; display:block;">
                            <div class="quiz-card">
                                <div class="card-top-info">
                                    <div class="quiz-icon">
                                        <i class="fa-solid fa-file-pen"></i>
                                    </div>
                                    <div class="quiz-meta-text">
                                        <h3><%# Eval("Title") %></h3>
                                        <p class="quiz-meta-text">
                                            <%# Eval("DurationMinutes") %> min
                                        </p>
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
        </asp:Panel>

        <!-- Panel 2: quiz landing page -->
        <asp:Panel ID="QuizLandingPanel" runat="server" Visible="false">
            <div class="quiz-landing-container">
                <div class="quiz-landing-card">
                    <div class="landing-icon-wrapper">
                        <i class="fa-solid fa-circle-info"></i>
                    </div>
            
                    <!-- 🎯 FIXED: Properly closed ASP Label component -->
                    <h2 class="landing-title">
                        <asp:Label ID="LandingTitleLabel" runat="server"></asp:Label>
                    </h2>
                    <p class="landing-subtitle">Please review the instructions carefully before starting.</p>

                    <!-- 🎯 FIXED: Replaced raw ** markup with <strong> tags -->
                    <div class="quiz-landing-info-box">
                        <p>⏱️ <strong>Duration:</strong> <asp:Label ID="LandingDurationLabel" runat="server"></asp:Label> Minutes</p>
                        <p>🎯 <strong>Passing Criteria:</strong> Score at least <asp:Label ID="LandingPassMarkLabel" runat="server"></asp:Label>% to pass</p>
                        <p>⚠️ <strong>Notice:</strong> Once initialized, the quiz system cannot be paused. Please ensure a stable network connection.</p>
                    </div>

                    <div class="quiz-landing-actions">
                        <!-- 🎯 FIXED: Kept your unique ID BackQuizList but targeted clean CSS variables -->
                        <asp:Button ID="BackQuizList" runat="server" Text="⬅ Back to Quizzes" CssClass="btn-cancel landing-btn" OnClick="btnBack_Click" />
                        <asp:Button ID="btnStartQuiz" runat="server" Text="Start Quiz Now 🚀" CssClass="btn-confirm landing-btn-start" OnClick="btnStartQuiz_Click" />
                    </div>
                </div>
            </div>
        </asp:Panel>

        <!-- after select the quiz -->
        <asp:Panel ID="ActiveQuizPanel" runat="server" Visible="false">
            <div class="quiz-header-bar" style="margin-bottom: 20px;">
                <asp:Button ID="btnBack" runat="server" Text="⬅ Back to Quizzes" CssClass="btn-cancel" OnClick="btnBack_Click" Style="margin-bottom: 15px; height: 35px; padding: 0 12px;" />
                <h2><asp:Label ID="ActiveQuizTitleLabel" runat="server"></asp:Label></h2>
            </div>

            <!-- Outer Repeater for loading the list of Questions -->
            <asp:Repeater ID="RepeatQuestions" runat="server" OnItemDataBound="RepeatQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="card quiz-q-card" style="background:#fff; border:1.5px solid #BBF7D0; padding:20px; border-radius:14px; margin-bottom:20px;">
                        <!-- Hidden Field tracking the current database Question ID -->
                        <asp:HiddenField ID="QuestionIdHiddenField" runat="server" Value='<%# Eval("QuestionId") %>' />
                        
                        <h4>Question <%# Container.ItemIndex + 1 %>: <%# Eval("QuestionText") %></h4>
                        <p style="font-size:12px; color:#15803D; font-weight:700;"><%# Eval("QuestionType") %></p>
                        
                        <div class="options-block" style="margin-top:15px;">
                            <!-- Inner RadioButtonList for rendering dynamic choice paths linked to the database row -->
                            <asp:RadioButtonList ID="OptionsButton" runat="server" CssClass="quiz-options-list" DataTextField="OptionText" DataValueField="OptionId">
                            </asp:RadioButtonList>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <div class="quiz-nav-buttons" style="margin-top:20px;">
                <asp:Button ID="ButtonSubmitQuiz" runat="server" Text="Submit Assessment" CssClass="btn-confirm" OnClick="btnSubmitQuiz_Click" Style="width:100%; height:50px; border-radius:12px;" />
            </div>
        </asp:Panel>
    </div>
</asp:Content>
