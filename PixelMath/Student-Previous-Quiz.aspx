<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Previous-Quiz.aspx.cs" Inherits="PixelMath.Student_Previous_Quiz" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Previous-Quiz-CSS.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Previous Quizzes
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="previous-quiz-container">
        
        <div class="table-card">
            <asp:Repeater ID="repeatPreviousQuizzes" runat="server">
                <HeaderTemplate>
                    <%-- 🎯 Added wrapper for smooth mobile horizontal scrolling --%>
                    <div class="table-responsive-wrapper">
                        <table class="quiz-history-table">
                            <thead>
                                <tr>
                                    <th>Quiz Title</th>
                                    <th>Submitted Date</th>
                                    <th class="text-center">Score</th>
                                    <th class="text-center">Passing Grade</th>
                                    <th class="text-center">Status</th>
                                </tr>
                            </thead>
                            <tbody>
                </HeaderTemplate>

                <ItemTemplate>
                    <tr class="selectable-row" onclick="toggleReviewRow(this)">
                        <td class="quiz-title-cell">
                            <strong><%# Eval("QuizTitle") %></strong>
                        </td>
                        <td><%# Eval("EndTime", "{0:dd MMM yyyy, h:mm tt}") %></td>
                        <td class="text-center">
                            <span class="score-text"><%# Eval("Score") %> %</span>
                        </td>
                        <td class="text-center"><%# Eval("PassingMarks") %> %</td>
                        <td class="text-center">
                            <span class='<%# GetStatusBadgeClass(Eval("IsGraded"), Eval("Score"), Eval("PassingMarks")) %>'>
                                <%# GetStatusText(Eval("IsGraded"), Eval("Score"), Eval("PassingMarks")) %>
                            </span>
                        </td>
                    </tr>

                    <%-- 🎯 Expandable Review Row --%>
                    <tr class="review-row" style="display: none;">
                        <td colspan="5" style="padding: 0;">
                            <div class="review-row-content">
                                <a href='Student-Quiz-Review.aspx?attemptId=<%# Eval("AttemptId") %>' class="btn-review-inline">
                                    View Quiz
                                </a>
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

            <asp:Panel ID="panelNoHistory" runat="server" Visible="false" CssClass="empty-history-state">
                <p>You haven't attempted any quizzes yet.</p>
            </asp:Panel>
        </div>

    </div>

    <%-- 🎯 JavaScript to toggle review row --%>
    <script type="text/javascript">
        function toggleReviewRow(mainRow) {
            var reviewRow = mainRow.nextElementSibling;

            // If clicking the currently open row, close it
            if (reviewRow && reviewRow.classList.contains('review-row') && reviewRow.style.display !== 'none') {
                reviewRow.style.display = 'none';
                mainRow.classList.remove('expanded-row');
                return;
            }

            // Hide all other open review rows first
            var allReviewRows = document.querySelectorAll('.review-row');
            allReviewRows.forEach(function (r) {
                r.style.display = 'none';
            });

            var allMainRows = document.querySelectorAll('.selectable-row');
            allMainRows.forEach(function (r) {
                r.classList.remove('expanded-row');
            });

            // Expand the selected row's review panel
            if (reviewRow && reviewRow.classList.contains('review-row')) {
                reviewRow.style.display = 'table-row';
                mainRow.classList.add('expanded-row');
            }
        }
    </script>
</asp:Content>