<%@ Page Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Create-Class.aspx.cs" Inherits="PixelMath.Lecturer_Create_Class" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page Specific Styles if needed -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Create & Manage Classes 🏫
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="w-full px-4 sm:px-6 lg:px-8 space-y-6 pb-12">
        
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

    </div>
</asp:Content>