<%@ Page Title="Quiz Review" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Quiz-Review.aspx.cs" Inherits="PixelMath.Student_Quiz_Review" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Quiz-Review-CSS.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Quiz Review
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="review-container">
        
        <!-- 🎯 Top Bar: Holds the Back Button directly above the card -->
        <div class="review-top-bar">
            <a href="Student-Previous-Quiz.aspx" class="btn-back">
                <i class="fa-solid fa-arrow-left"></i> Back to Previous Quizzes
            </a>
        </div>

        <!-- 🎯 Header / Summary Card -->
        <div class="review-header-card">
            
            <!-- Top Row: Quiz Title & Submitted Date -->
            <div class="header-top-row">
                <h2><asp:Label ID="lblQuizTitle" runat="server" Text="Quiz Title"></asp:Label></h2>
                <p class="meta-date">Submitted on: <asp:Label ID="lblSubmittedDate" runat="server"></asp:Label></p>
            </div>

            <!-- Bottom Row: Final Score & Status Badge flexed to the Right -->
            <div class="header-bottom-row">
                <div class="score-box">
                    <span class="score-label">FINAL SCORE</span>
                    <span class="score-val"><asp:Label ID="lblScore" runat="server">0</asp:Label> %</span>
                </div>
                <div class="status-box">
                    <asp:Label ID="lblStatusBadge" runat="server" CssClass="badge"></asp:Label>
                </div>
            </div>

        </div>

        <!-- Questions Breakdown List -->
        <div class="questions-list">
            <asp:Repeater ID="repeatQuestions" runat="server" OnItemDataBound="repeatQuestions_ItemDataBound">
                <ItemTemplate>
                    <div class="question-card">
                        
                        <!-- Question Header -->
                        <div class="question-header">
                            <span class="q-number">Question <%# Container.ItemIndex + 1 %></span>
                            <span class="q-type"><%# Eval("QuestionType") %></span>
                        </div>
                        
                        <p class="q-text"><%# Eval("QuestionText") %></p>

                        <!-- OBJECTIVE QUESTIONS: Show Options -->
                        <asp:Panel ID="panelObjective" runat="server" Visible='<%# Eval("QuestionType").ToString() == "Objective" %>'>
                            <div class="options-group">
                                <asp:Repeater ID="repeatOptions" runat="server">
                                    <ItemTemplate>
                                        <div class='<%# GetOptionStyleClass(Eval("IsCorrect"), Eval("IsSelected")) %>'>
                                            <span class="option-indicator"></span>
                                            <%# Eval("OptionText") %>
                                        </div>
                                    </ItemTemplate>
                                </asp:Repeater>
                            </div>
                        </asp:Panel>

                        <!-- SUBJECTIVE QUESTIONS: Show Typed Answer & Lecturer Remarks -->
                        <asp:Panel ID="panelSubjective" runat="server" Visible='<%# Eval("QuestionType").ToString() == "Subjective" %>'>
                            <div class="subjective-response-box">
                                <strong>Your Answer:</strong>
                                <p><%# string.IsNullOrEmpty(Eval("AnswerText").ToString()) ? "<em>No response provided.</em>" : Eval("AnswerText") %></p>
                            </div>

                            <!-- Lecturer Feedback Box -->
                            <div class="feedback-box">
                                <div class="feedback-header">
                                    <i class="fa-solid fa-comment-dots"></i> Lecturer Feedback
                                </div>
                                <p><%# string.IsNullOrEmpty(Eval("LecturerFeedback").ToString()) ? "No feedback provided yet." : Eval("LecturerFeedback") %></p>
                            </div>
                        </asp:Panel>

                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

    </div>
</asp:Content>