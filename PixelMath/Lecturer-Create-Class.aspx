<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lecturer-Create-Class.aspx.cs" Inherits="PixelMath.Lecturer_Create_Class" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Class - PixelMath</title>
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
                    <ul class="space-y-1 mb-6 text-xs font-semibold">
                        <li>
                            <a href="Lecturer-Dashboard.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
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
                    <ul class="space-y-1 mb-6 text-xs font-semibold">
                        <li>
                            <a href="Lecturer-Create-Class.aspx" class="flex items-center gap-3 p-3 rounded-2xl bg-[#22C55E] text-white font-bold shadow-xs">
                                <span>🏫</span> Create Class
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Create-Quiz.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>➕</span> Create Quiz
                            </a>
                        </li>
                        <li>
                            <a href="Quizzes/List.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
                                <span>📋</span> Manage Quizzes
                            </a>
                        </li>
                        <li>
                            <a href="Lecturer-Upload-Resources.aspx" class="flex items-center gap-3 p-3 rounded-2xl hover:bg-slate-50 text-slate-600 transition">
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
            </aside>

            <!-- MAIN WORKSPACE -->
            <div class="flex-1 flex flex-col min-w-0">
                
                <header class="bg-white border-b border-slate-100 px-8 py-5 flex justify-between items-center">
                    <h1 class="font-fredoka text-xl text-slate-800">
                        Create & Manage Classes 🏫
                    </h1>
                </header>

                <main class="p-8 flex-1 max-w-6xl">
                    
                    <!-- Alert Message -->
                    <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
                        <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
                    </asp:Panel>

                    <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                        
                        <!-- CREATE CLASS FORM (2 Cols) -->
                        <div class="lg:col-span-2 bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs h-fit">
                            <h2 class="font-fredoka text-lg text-slate-800 mb-6 pb-2 border-b border-slate-100">
                                New Class Setup
                            </h2>

                            <div class="space-y-6">
                                <!-- Class Name -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Class Name *</label>
                                    <asp:TextBox ID="txtClassName" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="e.g. Mathematics 101 - Section A"></asp:TextBox>
                                </div>

                                <!-- Class Description -->
                                <div>
                                    <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Description / Subject Focus</label>
                                    <asp:TextBox ID="txtDescription" runat="server" TextMode="MultiLine" Rows="3" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" placeholder="Briefly describe the course objectives..."></asp:TextBox>
                                </div>
                            </div>

                            <!-- Action Buttons -->
                            <div class="mt-8 flex justify-end gap-4 border-t border-slate-100 pt-6">
                                <a href="Lecturer-Dashboard.aspx" class="bg-slate-100 text-slate-600 text-xs font-bold px-6 py-3 rounded-2xl hover:bg-slate-200 transition">Cancel</a>
                                
                                <asp:Button ID="btnCreateClass" runat="server" Text="Create Class 🚀" OnClick="btnCreateClass_Click"
                                    CssClass="bg-[#22C55E] text-white text-xs font-bold px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer" />
                            </div>
                        </div>

                        <!-- EXISTING CLASSES SIDEBAR (1 Col) -->
                        <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs h-fit">
                            <h2 class="font-fredoka text-md text-slate-800 mb-4 pb-2 border-b border-slate-100 flex justify-between items-center">
                                <span>Your Classes</span>
                                <span class="bg-emerald-100 text-emerald-800 text-[10px] px-2 py-0.5 rounded-full font-bold">
                                    <asp:Literal ID="litClassCount" runat="server">0</asp:Literal>
                                </span>
                            </h2>

                            <asp:Repeater ID="rptClasses" runat="server">
                                <ItemTemplate>
                                    <div class="p-3 mb-3 rounded-2xl bg-slate-50 border border-slate-100">
                                        <div class="font-bold text-xs text-slate-800"><%# Eval("ClassName") %></div>
                                        <div class="text-[11px] text-slate-500 mt-1"><%# Eval("Description") %></div>
                                        <div class="mt-2 text-[10px] text-slate-400">
                                            Created: <%# Eval("CreatedAt", "{0:MMM dd, yyyy}") %>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <asp:Panel ID="pnlNoClasses" runat="server" Visible="false" CssClass="text-center py-6 text-slate-400 text-xs">
                                🏫 You haven't created any classes yet.
                            </asp:Panel>
                        </div>

                    </div>

                </main>
            </div>

        </div>

    </form>
</body>
</html>