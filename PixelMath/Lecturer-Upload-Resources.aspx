<%@ Page Language="C#" MasterPageFile="~/Lecturer-Template.Master" AutoEventWireup="true" CodeBehind="Lecturer-Upload-Resources.aspx.cs" Inherits="PixelMath.Lecturer_Upload_Resources" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <!-- Page Specific Styles if needed -->
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    Upload Learning Resources 📚
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="w-full px-4 sm:px-6 lg:px-8 space-y-6 pb-12 max-w-4xl">
        
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

    </div>

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
</asp:Content>