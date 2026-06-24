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
        <div class="quiz-filter">
            <p>pending</p>
        </div>
        <div class="quiz-content">
            <asp:Repeater ID="repeatQuizzes" runat="server" OnItemCommand="repeatQuizzes_ItemCommand">
                <ItemTemplate>
                    <div class="quiz-card">
                        <div class="card-top-info">
                            <div class="quiz-icon">
                                <i class="fa-solid fa-file-pen"></i>
                            </div>
                            <div class="quiz-meta-text">
                                <h3><%# Eval("Title") %></h3>
                                <p class="quiz-meta-text">
                                    <%# Eval("QuestionCount") %> questions • <%# Eval("DurationMinutes") %> min
                                </p>
                            </div>
                        </div>

                        <div class="card-divider"></div>

                        <div class="card-bottom-info">
                            <span class="quiz-type"><%# Eval("QuestionType") %></span>
                            <span class="quiz-pass-mark">Pass Mark: <%# Eval("PassingMarks") %>%</span>
                        </div>
                    
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
