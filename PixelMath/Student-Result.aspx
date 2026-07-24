<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Result.aspx.cs" Inherits="PixelMath.Student_Result" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Result-CSS.css" />
    <link href="https://fonts.googleapis.com/css2?family=Nunito:wght@400;600;700;800&family=Fredoka+One&display=swap" rel="stylesheet"/>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Result
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="stats-grid">
        <!-- 1. Total Quizzes Taken -->
        <div class="top-card">
            <div class="top-card-icon">
                <i class="fa-solid fa-list-check"></i>
            </div>
            <div class="top-card-content">
                <div class="top-card-value">
                    <asp:Label ID="lblQuizzesTaken" runat="server" Text="0"></asp:Label>
                </div>
                <div class="top-card-label">Quizzes Taken</div>
            </div>
        </div>

        <!-- 2. Average Score -->
        <div class="top-card">
            <div class="top-card-icon">
                <i class="fa-solid fa-chart-line"></i>
            </div>
            <div class="top-card-content">
                <div class="top-card-value">
                    <asp:Label ID="lblAvgScore" runat="server" Text="0%"></asp:Label>
                </div>
                <div class="top-card-label">Average Score</div>
            </div>
        </div>

        <!-- 3. Best Topic -->
        <div class="top-card">
            <div class="top-card-icon">
                <i class="fa-solid fa-star"></i>
            </div>
            <div class="top-card-content">
                <div class="top-card-value">
                    <asp:Label ID="lblBestTopic" runat="server" Text="N/A"></asp:Label>
                </div>
                <div class="top-card-label">Best Topic</div>
            </div>
        </div>

        <!-- 4. Time Spent -->
        <div class="top-card">
            <div class="top-card-icon">
                <i class="fa-solid fa-clock"></i>
            </div>
            <div class="top-card-content">
                <div class="top-card-value">
                    <asp:Label ID="lblTimeSpent" runat="server" Text="0m"></asp:Label>
                </div>
                <div class="top-card-label">Time Spent</div>
            </div>
        </div>
    </div>

    <!-- 2. QUIZ RESULTS TABLE SECTION -->
    <div class="table-card">
        <div class="table-card-header">
            <h3 class="table-title">Quiz Result</h3>
        </div>

        <!-- Filters Row: Left Search | Right Dropdown Filter -->
        <div class="filter-row">
            <div class="search-box">
                <i class="fa-solid fa-magnifying-glass search-icon"></i>
                <asp:TextBox ID="txtSearchQuiz" runat="server" CssClass="filter-input" Placeholder="Search quiz name..." onkeyup="applyFilters()"></asp:TextBox>
            </div>
            <div class="select-box">
                <asp:DropDownList ID="ddlStatusFilter" runat="server" CssClass="filter-select" 
                    onchange="applyFilters()">
                    <asp:ListItem Value="ALL">All Status</asp:ListItem>
                    <asp:ListItem Value="PASS">Passed</asp:ListItem>
                    <asp:ListItem Value="FAIL">Failed</asp:ListItem>
                </asp:DropDownList>
            </div>
        </div>

        <!-- 2-Column Table: Quiz Name | Marks -->
        <div class="table-responsive">
            <table class="results-table">
                <thead>
                    <tr>
                        <th style="width: 70%;">Quiz Name</th>
                        <th style="width: 30%; text-align: right;">Marks</th>
                    </tr>
                </thead>
                <tbody>
                    <asp:Repeater ID="rptQuizResults" runat="server">
                        <ItemTemplate>
                            <tr>
                                <td class="quiz-name-cell"><%# Eval("QuizTitle") %></td>
                                <td class="marks-cell <%# Convert.ToBoolean(Eval("IsPassed")) ? "pass" : "fail" %>">
                                    <%# Eval("Score") %>%
                                </td>
                            </tr>
                        </ItemTemplate>
                    </asp:Repeater>
                </tbody>
            </table>

            <!-- No Data Message -->
            <asp:Panel ID="pnlNoData" runat="server" Visible="false" CssClass="no-data-msg">
                No quiz results found matching your criteria.
            </asp:Panel>
        </div>
    </div>

    <!-- 3. BOTTOM GENTLE REMINDER CARD -->
    <asp:Panel ID="pnlRevisionReminder" runat="server" Visible="false" CssClass="reminder-card">
        <div class="reminder-header">
            <i class="fa-solid fa-lightbulb"></i>
            <span>Gentle Reminder</span>
        </div>
        <p class="reminder-text">Your score falls below the passing mark for the following quiz topic(s). Take some time to revise them:</p>
        <ul class="reminder-list">
            <asp:Repeater ID="rptFailedQuizzes" runat="server">
                <ItemTemplate>
                    <li>
                        <strong><%# Eval("QuizTitle") %></strong> 
                        <span>(Score: <%# Eval("Score") %>% / Passing: <%# Eval("PassingMarks") %>%)</span>
                    </li>
                </ItemTemplate>
            </asp:Repeater>
        </ul>
    </asp:Panel>

    <script type="text/javascript">
        function applyFilters() {
            var searchInput, searchFilter, dropdown, statusFilter, table, rows, quizNameCell, marksCell, i;

            // 1. Grab inputs and filters
            searchInput = document.getElementById('<%= txtSearchQuiz.ClientID %>');
            searchFilter = searchInput.value.toUpperCase();

            dropdown = document.getElementById('<%= ddlStatusFilter.ClientID %>');
            statusFilter = dropdown.value.toUpperCase();

            table = document.querySelector(".results-table");
            if (!table) return;

            // Grab all rows in tbody (skip the <thead>)
            rows = table.querySelectorAll("tbody tr");

            // Remove any existing "No results" row
            var existingNoResults = document.getElementById("js-no-data-row");
            if (existingNoResults) {
                existingNoResults.remove();
            }

            var hasResults = false;

            // 2. Loop through table rows and check matches
            for (i = 0; i < rows.length; i++) {
                quizNameCell = rows[i].querySelector(".quiz-name-cell");
                marksCell = rows[i].querySelector(".marks-cell");

                if (quizNameCell && marksCell) {
                    var quizNameText = (quizNameCell.textContent || quizNameCell.innerText).toUpperCase();

                    // Check if the marks cell has class 'pass' or 'fail'
                    var isPassed = marksCell.classList.contains("pass");

                    var matchesSearch = quizNameText.indexOf(searchFilter) > -1;
                    var matchesStatus = (statusFilter === "ALL") ||
                        (statusFilter === "PASS" && isPassed) ||
                        (statusFilter === "FAIL" && !isPassed);

                    if (matchesSearch && matchesStatus) {
                        rows[i].style.display = ""; // Show row
                        hasResults = true;
                    } else {
                        rows[i].style.display = "none"; // Hide row
                    }
                }
            }

            // 3. Show "No results" message inside the table if nothing matches
            if (!hasResults && rows.length > 0) {
                var tbody = table.querySelector("tbody");
                var noResultsRow = document.createElement("tr");
                noResultsRow.id = "js-no-data-row";
                noResultsRow.innerHTML = '<td colspan="2" style="text-align:center; padding:20px; color:#8c9ba5;">No quiz results match your search metrics.</td>';
                tbody.appendChild(noResultsRow);
            }
        }
    </script>
</asp:Content>
