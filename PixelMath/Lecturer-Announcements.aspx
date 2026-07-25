<%@ Page Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Announcements.aspx.cs" Inherits="PixelMath.Lecturer_Announcements" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page Specific Styles if needed -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    <span class="text-base sm:text-xl font-bold text-slate-800">Class Announcements 📢</span>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="w-full px-3 sm:px-6 lg:max-w-7xl lg:mx-auto lg:px-8 space-y-6 pb-12">
        
        <!-- Alert Message -->
        <asp:Panel ID="pnlAlert" runat="server" Visible="false" CssClass="mb-6 p-4 rounded-2xl text-xs font-bold">
            <asp:Literal ID="litAlertMessage" runat="server"></asp:Literal>
        </asp:Panel>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 lg:gap-8">
            
            <!-- POST ANNOUNCEMENT FORM (2 Cols) -->
            <div class="lg:col-span-2 bg-white p-5 sm:p-8 rounded-2xl sm:rounded-[24px] border border-slate-100 shadow-xs h-fit">
                <h2 class="font-fredoka text-base sm:text-lg text-slate-800 mb-6 pb-2 border-b border-slate-100">
                    Send Announcement to Students
                </h2>

                <div class="space-y-5 sm:space-y-6">
                    <!-- Target Class Dropdown -->
                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Target Class *</label>
                        <asp:DropDownList ID="ddlClasses" runat="server" 
                            CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E] font-medium text-slate-700">
                        </asp:DropDownList>
                    </div>

                    <!-- Announcement Title -->
                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Title / Subject *</label>
                        <asp:TextBox ID="txtTitle" runat="server" 
                            CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" 
                            placeholder="e.g., Mid-Term Exam Update"></asp:TextBox>
                    </div>

                    <!-- Announcement Message -->
                    <div>
                        <label class="block text-xs font-bold text-slate-600 uppercase mb-2">Message *</label>
                        <asp:TextBox ID="txtMessage" runat="server" TextMode="MultiLine" Rows="5" 
                            CssClass="w-full bg-slate-50 border border-slate-200 rounded-xl px-4 py-3 text-xs focus:outline-none focus:border-[#22C55E]" 
                            placeholder="Write your message to the enrolled students here..."></asp:TextBox>
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="mt-8 flex justify-end gap-4 border-t border-slate-100 pt-6">
                    <asp:Button ID="btnPostAnnouncement" runat="server" Text="Post Announcement 📣" OnClick="btnPostAnnouncement_Click"
                        CssClass="bg-[#22C55E] text-white text-xs font-bold px-6 py-3 rounded-2xl hover:bg-emerald-600 transition cursor-pointer w-full sm:w-auto text-center" />
                </div>
            </div>

            <!-- RECENT ANNOUNCEMENTS FEED (1 Col) -->
            <div class="bg-white p-5 sm:p-6 rounded-2xl sm:rounded-[24px] border border-slate-100 shadow-xs h-fit">
                <h2 class="font-fredoka text-sm sm:text-md text-slate-800 mb-4 pb-2 border-b border-slate-100 flex justify-between items-center">
                    <span>Recent Posts</span>
                    <span class="bg-emerald-100 text-emerald-800 text-[10px] px-2 py-0.5 rounded-full font-bold">
                        <asp:Literal ID="litAnnouncementCount" runat="server">0</asp:Literal>
                    </span>
                </h2>

                <div class="space-y-3">
                    <asp:Repeater ID="rptAnnouncements" runat="server">
                        <ItemTemplate>
                            <div class="p-4 rounded-2xl bg-slate-50 border border-slate-100">
                                <div class="flex justify-between items-start gap-2 mb-1">
                                    <span class="font-bold text-xs text-slate-800"><%# Eval("Title") %></span>
                                    <span class="text-[9px] bg-slate-200 text-slate-600 font-bold px-2 py-0.5 rounded-md shrink-0">
                                        <%# Eval("ClassName") %>
                                    </span>
                                </div>
                                <div class="text-[11px] text-slate-600 mt-2 leading-relaxed break-words">
                                    <%# Eval("Message") %>
                                </div>
                                <div class="mt-3 text-[10px] text-slate-400 font-semibold">
                                    Posted: <%# Eval("CreatedAt", "{0:MMM dd, yyyy - hh:mm tt}") %>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <asp:Panel ID="pnlNoAnnouncements" runat="server" Visible="false" CssClass="text-center py-8 text-slate-400 text-xs">
                    📢 No announcements posted yet.
                </asp:Panel>
            </div>

        </div>

        <!-- ANNOUNCEMENTS FROM ADMIN (Full Width) -->
        <div class="bg-white p-6 rounded-[24px] border border-slate-100 shadow-xs">
            <h2 class="font-fredoka text-md text-slate-800 mb-4 pb-2 border-b border-slate-100 flex items-center gap-2">
                <span>📋 Announcements from Admin</span>
            </h2>

            <div class="space-y-3">
                <asp:Repeater ID="rptAdminAnnouncements" runat="server">
                    <ItemTemplate>
                        <div class="p-4 rounded-2xl bg-indigo-50/50 border border-indigo-100">
                            <div class="flex justify-between items-start mb-1 gap-2">
                                <span class="font-bold text-xs text-slate-800"><%# Eval("Title") %></span>
                                <span class="text-[9px] bg-indigo-100 text-indigo-700 font-bold px-2 py-0.5 rounded-md shrink-0">
                                    <%# Eval("AudienceName") %>
                                </span>
                            </div>
                            <div class="text-[11px] text-slate-600 mt-2 leading-relaxed break-words">
                                <%# Eval("Message") %>
                            </div>
                            <div class="mt-3 text-[10px] text-slate-400 font-semibold">
                                By <%# Eval("PostedBy") %> &middot; <%# Eval("CreatedAt", "{0:MMM dd, yyyy - hh:mm tt}") %>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>

            <asp:Panel ID="pnlNoAdminAnnouncements" runat="server" Visible="false" CssClass="text-center py-6 text-slate-400 text-xs">
                📭 No announcements from admin yet.
            </asp:Panel>
        </div>

    </div>
</asp:Content>