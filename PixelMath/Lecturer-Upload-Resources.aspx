<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lecturer-Upload-Resources.aspx.cs" Inherits="PixelMath.Lecturer_Upload_Resources" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Upload Resources - PixelMath</title>
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
                        Upload Learning Resources 📚
                    </h1>
                </header>

                <main class="p-8 flex-1 max-w-4xl">
                    
                    <!-- Alert Status Message -->
                    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
                        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                    </asp:Panel>

                    <!-- UPLOAD FORM CARD -->
                    <div class="bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs mb-8">
                        <h2 class="font-fredoka text-lg text-slate-800 mb-6 pb-2 border-b border-slate-100">
                            Resource Details
                        </h2>

                        <div class="space-y-6">
                            
                            <!-- Resource Title -->
                            <div>
                                <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Resource Title</label>
                                <asp:TextBox ID="txtResourceTitle" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="e.g. Chapter 3 Formula Sheet & Notes"></asp:TextBox>
                            </div>

                            <!-- Target Class & Resource Type Grid -->
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                                <div>
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Assign to Class</label>
                                    <asp:DropDownList ID="ddlClass" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]">
                                    </asp:DropDownList>
                                </div>

                                <div>
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Resource Type</label>
                                    <asp:DropDownList ID="ddlResourceType" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]">
                                        <asp:ListItem Value="Lecture Notes">Lecture Notes</asp:ListItem>
                                        <asp:ListItem Value="Worksheet">Worksheet / Practice</asp:ListItem>
                                        <asp:ListItem Value="Formula Sheet">Formula Sheet</asp:ListItem>
                                        <asp:ListItem Value="Reference">Reference Material</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>

                            <!-- Description -->
                            <div>
                                <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Description (Optional)</label>
                                <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="Brief summary of what this document contains..."></asp:TextBox>
                            </div>

                            <!-- File Upload Area -->
                            <div>
                                <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Attach Document</label>
                                <div class="border-2 border-dashed border-slate-200 bg-slate-50 rounded-2xl p-6 text-center">
                                    <asp:FileUpload ID="fileUpload" runat="server" 
                                        onchange="validateFileSize(this)"
                                        CssClass="text-xs text-slate-600 file:mr-4 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-[#22C55E] file:text-white hover:file:bg-emerald-600 cursor-pointer" />
                                    <p class="text-[11px] text-slate-400 mt-2">Allowed formats: PDF, DOCX, PPTX, PNG, JPG (Max 15MB)</p>
                                    
                                    <!-- Client-side Error Output -->
                                    <div id="clientFileError" class="hidden mt-3 p-3 bg-rose-50 border border-rose-200 text-rose-700 rounded-xl text-xs font-semibold"></div>
                                </div>
                            </div>

                        </div>

                        <!-- Action Buttons -->
                        <div class="mt-8 flex justify-end gap-4 border-t border-slate-100 pt-6">
                            <a href="Lecturer-Dashboard.aspx" class="bg-slate-100 text-slate-600 text-xs font-bold px-6 py-3 rounded-2xl hover:bg-slate-200 transition">Cancel</a>
                            
                            <asp:Button ID="btnUpload" runat="server" Text="Upload Resource 🚀" OnClick="btnUpload_Click"
                                CssClass="bg-[#22C55E] text-white text-xs font-bold px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed" />
                        </div>

                    </div>

                </main>
            </div>

        </div>

    </form>

    <script type="text/javascript">
        function validateFileSize(fileInput) {
            var errorDiv = document.getElementById('clientFileError');
            var uploadBtn = document.getElementById('<%= btnUpload.ClientID %>');

            if (fileInput.files && fileInput.files[0]) {
                var fileSize = fileInput.files[0].size; // Bytes
                var maxSizeBytes = 15 * 1024 * 1024; // 15 MB

                if (fileSize > maxSizeBytes) {
                    var sizeInMB = (fileSize / (1024 * 1024)).toFixed(2);
                    errorDiv.innerText = '⚠️ Selected file is too large (' + sizeInMB + ' MB). Maximum allowed size is 15 MB.';
                    errorDiv.classList.remove('hidden');

                    // Reset input and disable submit button
                    fileInput.value = '';
                    if (uploadBtn) uploadBtn.disabled = true;
                } else {
                    errorDiv.classList.add('hidden');
                    errorDiv.innerText = '';
                    if (uploadBtn) uploadBtn.disabled = false;
                }
            }
        }
    </script>
</body>
</html>