<%@ Page Title="Lecturer Profile - PixelMath" Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Profile.aspx.cs" Inherits="PixelMath.Lecturer_Profile" MaintainScrollPositionOnPostback="true" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.9.14/dist/dotlottie-wc.js" type="module"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    My Profile 👤
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="w-full px-4 sm:px-6 lg:px-8 space-y-6 pb-12 font-body">

        <!-- Alert Message -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        </asp:Panel>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
            
            <!-- LEFT BOX: Personal Info -->
            <div class="bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs h-fit">
                <h2 class="font-fredoka text-lg text-slate-800 mb-6 pb-2 border-b border-slate-100 flex items-center gap-2">
                    <i class="fa-solid fa-user text-[#22C55E]"></i> Personal Info
                </h2>

                <div class="flex flex-col items-center justify-center mb-6">
                    <div class="w-24 h-24 rounded-full overflow-hidden border-4 border-slate-100 shadow-sm mb-3">
                        <img src="images/pixelmath_logo.png" alt="Profile Picture" class="w-full h-full object-cover"/>
                    </div>
                    <div class="profile-badge">
                        <asp:Label ID="ProfileBadge" runat="server" CssClass="bg-emerald-100 text-emerald-800 text-xs px-3 py-1 rounded-full font-bold"></asp:Label>
                    </div>
                </div>

                <div class="space-y-4">
                    <table class="w-full text-xs text-slate-700">
                        <tr class="border-b border-slate-50">
                            <td class="py-3 font-bold text-slate-500 w-1/3">FULL NAME</td>
                            <td class="py-3 px-2 font-bold text-slate-400">:</td>
                            <td class="py-3"><asp:TextBox ID="TextFullName" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-xs text-slate-700 focus:outline-none" ReadOnly="true"/></td>
                        </tr>
                        <tr class="border-b border-slate-50">
                            <td class="py-3 font-bold text-slate-500">EMAIL</td>
                            <td class="py-3 px-2 font-bold text-slate-400">:</td>
                            <td class="py-3"><asp:TextBox ID="TextEmail" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-xs text-slate-700 focus:outline-none" ReadOnly="true"/></td>
                        </tr>
                        <tr class="border-b border-slate-50">
                            <td class="py-3 font-bold text-slate-500">DEPARTMENT</td>
                            <td class="py-3 px-2 font-bold text-slate-400">:</td>
                            <td class="py-3"><asp:TextBox ID="TextDepartment" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-xs text-slate-700 focus:outline-none" ReadOnly="true"/></td>
                        </tr>
                        <tr>
                            <td class="py-3 font-bold text-slate-500">JOINED DATE</td>
                            <td class="py-3 px-2 font-bold text-slate-400">:</td>
                            <td class="py-3"><asp:TextBox ID="TextJoinedDate" runat="server" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-2.5 text-xs text-slate-700 focus:outline-none" ReadOnly="true"/></td>
                        </tr>
                    </table>
                </div>
            </div>

            <!-- RIGHT BOX: Lecturer Metrics & Statistics -->
            <div class="bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs h-fit">
                <h2 class="font-fredoka text-lg text-slate-800 mb-6 pb-2 border-b border-slate-100 flex items-center gap-2">
                    <i class="fa-solid fa-chart-line text-[#22C55E]"></i> Lecturer Statistics
                </h2>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6">
                    <!-- Metric 1: Total Classes -->
                    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-100 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-emerald-100 text-emerald-700 flex items-center justify-center text-lg font-bold">
                            <i class="fa-solid fa-chalkboard-user"></i>
                        </div>
                        <div>
                            <span class="block text-base font-bold text-slate-800"><asp:Label ID="lblTotalClasses" runat="server" Text="0"></asp:Label></span>
                            <span class="block text-[11px] text-slate-400 font-semibold uppercase">Total Classes</span>
                        </div>
                    </div>

                    <!-- Metric 2: Active Quizzes -->
                    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-100 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-indigo-100 text-indigo-700 flex items-center justify-center text-lg font-bold">
                            <i class="fa-solid fa-clipboard-question"></i>
                        </div>
                        <div>
                            <span class="block text-base font-bold text-slate-800"><asp:Label ID="lblActiveQuizzes" runat="server" Text="0"></asp:Label></span>
                            <span class="block text-[11px] text-slate-400 font-semibold uppercase">Active Quizzes</span>
                        </div>
                    </div>

                    <!-- Metric 3: Pending Submissions -->
                    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-100 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-amber-100 text-amber-700 flex items-center justify-center text-lg font-bold">
                            <i class="fa-solid fa-pen-to-square"></i>
                        </div>
                        <div>
                            <span class="block text-base font-bold text-slate-800"><asp:Label ID="lblPendingMarking" runat="server" Text="0"></asp:Label></span>
                            <span class="block text-[11px] text-slate-400 font-semibold uppercase">Pending Marking</span>
                        </div>
                    </div>

                    <!-- Metric 4: Total Students -->
                    <div class="p-4 rounded-2xl bg-slate-50 border border-slate-100 flex items-center gap-4">
                        <div class="w-12 h-12 rounded-xl bg-sky-100 text-sky-700 flex items-center justify-center text-lg font-bold">
                            <i class="fa-solid fa-users"></i>
                        </div>
                        <div>
                            <span class="block text-base font-bold text-slate-800"><asp:Label ID="lblTotalStudents" runat="server" Text="0"></asp:Label></span>
                            <span class="block text-[11px] text-slate-400 font-semibold uppercase">Total Students</span>
                        </div>
                    </div>
                </div>

                <!-- Pass Rate Bar -->
                <div class="p-4 rounded-2xl bg-slate-50 border border-slate-100">
                    <div class="flex justify-between items-center mb-2">
                        <span class="text-xs font-bold text-slate-700">Average Student Passing Rate</span>
                        <span class="text-xs font-bold text-emerald-700"><asp:Label ID="lblAvgPassRate" runat="server" Text="0%"></asp:Label></span>
                    </div>
                    <div class="w-full bg-slate-200 h-2.5 rounded-full overflow-hidden">
                        <asp:Panel ID="pnlPassProgressBar" runat="server" CssClass="bg-[#22C55E] h-full rounded-full transition-all duration-500" Style="width: 0%;"></asp:Panel>
                    </div>
                </div>
            </div>

        </div>

        <!-- SECURITY SETTINGS BOX -->
        <div class="bg-white p-8 rounded-[24px] border border-slate-100 shadow-xs">
            <h2 class="font-fredoka text-lg text-slate-800 mb-4 pb-2 border-b border-slate-100 flex items-center gap-2">
                <i class="fa-solid fa-lock text-[#22C55E]"></i> Security Settings
            </h2>

            <div class="flex justify-center my-4">
                <dotlottie-wc
                  src="https://lottie.host/3ced9f8a-ebaa-4837-95b0-f8f88c261761/FJ7OmbVufD.lottie"
                  style="width: 80px;height: 80px"
                  autoplay
                  loop
                ></dotlottie-wc>
            </div>

            <p class="text-xs text-slate-400 text-center mb-6">Keep your account secure. Use this section to update your password whenever you need a change.</p>

            <div class="max-w-2xl mx-auto space-y-4">
                <asp:Panel ID="PanelPasswordInput" runat="server" Visible="false" CssClass="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Verify Registered Email</label>
                        <asp:TextBox ID="TextVerifyEmail" runat="server" placeholder="e.g., lecturer@pixelmath.com" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" />
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">New Password</label>
                        <asp:TextBox ID="TextNewPassword" runat="server" TextMode="Password" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" />
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Confirm Password</label>
                        <asp:TextBox ID="TextConfirmPassword" runat="server" TextMode="Password" CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" />
                    </div>
                </asp:Panel>

                <div class="flex justify-center gap-4 pt-4">
                    <asp:Button ID="BtnEditPassword" runat="server" Text="Edit Password 🔑" OnClick="BtnEditPassword_Click" CssClass="bg-slate-800 text-white text-xs font-bold px-6 py-3 rounded-2xl hover:bg-slate-900 transition cursor-pointer" />
                    <asp:Button ID="BtnCancelPassword" runat="server" Text="Cancel" OnClick="BtnCancelPassword_Click" Visible="false" CssClass="bg-slate-100 text-slate-600 text-xs font-bold px-6 py-3 rounded-2xl hover:bg-slate-200 transition cursor-pointer" />
                    <asp:Button ID="BtnSavePassword" runat="server" Text="Save Changes 💾" OnClick="BtnSavePassword_Click" Visible="false" CssClass="bg-[#22C55E] text-white text-xs font-bold px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer" />
                </div>

                <div class="text-center mt-4">
                    <asp:Label ID="LblMessage" runat="server" CssClass="text-xs font-bold"></asp:Label>
                </div>
            </div>
        </div>

        <!-- Success Modal -->
        <div id="successModal" class="fixed inset-0 bg-slate-900/50 backdrop-blur-xs flex items-center justify-center z-50" style="display: none;">
            <div class="bg-white p-8 rounded-[24px] max-w-sm w-full mx-4 text-center shadow-xl border border-slate-100">
                <div class="flex justify-center mb-4">
                    <dotlottie-wc
                        src="https://lottie.host/ad9c9e32-8b5f-4fe0-bc0d-0d7e900717b7/CeTsD1XmXf.lottie"
                        style="width: 100px; height: 100px"
                        autoplay
                        loop
                    ></dotlottie-wc>
                </div>
                <h3 class="font-fredoka text-lg text-slate-800 mb-2">Success!</h3>
                <p class="text-xs text-slate-500 mb-6">Your password has been changed successfully.</p>
                <div>
                    <button type="button" class="bg-[#22C55E] text-white text-xs font-bold px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer w-full" onclick="closeSuccessModal()">Great!</button>
                </div>
            </div>
        </div>

    </div>

    <script type="text/javascript">
        function showSuccessModal() {
            document.getElementById('successModal').style.display = 'flex';
        }
        function closeSuccessModal() {
            document.getElementById('successModal').style.display = 'none';
        }
    </script>
</asp:Content>