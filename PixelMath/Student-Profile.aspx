<%@ Page Title="" Language="C#" MasterPageFile="~/Main-Template.Master" AutoEventWireup="true" CodeBehind="Student-Profile.aspx.cs" Inherits="PixelMath.Student_Profile" MaintainScrollPositionOnPostback="true"%>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <link rel="stylesheet" href="Student-Profile-CSS.css" />
    <script src="https://unpkg.com/@lottiefiles/dotlottie-wc@0.9.14/dist/dotlottie-wc.js" type="module"></script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="TopbarTitleContent" runat="server">
    My Profile
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="profile-wrapper">
        
        <div class="profile-top-section">
            
            <div class="personal-info left-box">
                <div class="title">
                    <i class="fa-solid fa-user"></i>Personal info
                </div>

                <div class="image-section">
                    <div class="profile-picture">
                        <img src="Student-Avatar.png" alt="Profile Picture" class="image"/>
                    </div>
                </div>

                <div class="profile-badge">
                    <asp:Label ID="ProfileBadge" runat="server"></asp:Label>
                </div>

                <div class="personal-detail">
                    <table class="profile-table">
                        <tr>
                            <td class="form-field-label">FULL NAME</td>
                            <td class="colon-column">:</td>
                            <td><asp:TextBox ID="TextFullName" runat="server" CssClass="profile-disabled-input" ReadOnly="true"/></td>
                        </tr>
                        <tr>
                            <td class="form-field-label">EMAIL</td>
                            <td class="colon-column">:</td>
                            <td><asp:TextBox ID="TextEmail" runat="server" CssClass="profile-disabled-input" ReadOnly="true"/></td>
                        </tr>
                        <tr>
                            <td class="form-field-label">EDUCATIONAL LEVEL</td>
                            <td class="colon-column">:</td>
                            <td><asp:TextBox ID="TextFormLevel" runat="server" CssClass="profile-disabled-input" ReadOnly="true"/></td>
                        </tr>
                        <tr>
                            <td class="form-field-label">JOINED DATE</td>
                            <td class="colon-column">:</td>
                            <td><asp:TextBox ID="TextJoinedDate" runat="server" CssClass="profile-disabled-input" ReadOnly="true"/></td>
                        </tr>
                    </table>
                </div>
            </div>

            <div class="personal-info right-box">
                <div class="title">
                    <i class="fa-solid fa-chart-line"></i>Quiz Progress
                </div>
                <div class="personal-detail" style="text-align: center; color: #64748b; padding-top: 40px;">
                    <p>Performance metrics coming soon</p>
                </div>
            </div>

        </div>

        <div class="personal-info security-box" style="margin-top: 15px;">
            <div class="title">
                <i class="fa-solid fa-lock"></i>Security Settings
            </div>

            <div style="display:flex; justify-content:center; margin:10px 0 0 0 ">
                <dotlottie-wc
                  src="https://lottie.host/3ced9f8a-ebaa-4837-95b0-f8f88c261761/FJ7OmbVufD.lottie"
                  style="width: 80px;height: 80px"
                  autoplay
                  loop
                ></dotlottie-wc>
            </div>

            <p class="personal-info-subtitle">Keep your account secure. Use this section to update your password whenever you need a change.</p>

            <div class="personal-detail">
                <asp:Panel ID="PanelPasswordInput" runat="server" Visible="false">
                    <table class="profile-table">
                        <tr>
                            <td class="form-field-label">VERIFY REGISTERED EMAIL</td>
                            <td class="colon-column">:</td>
                            <td><asp:TextBox ID="TextVerifyEmail" runat="server" placeholder="e.g., student@pixelmath.com" CssClass="profile-active-input" /></td>
                        </tr>
                        <tr>
                            <td class="form-field-label">NEW PASSWORD</td>
                            <td class="colon-column">:</td>
                            <td><asp:TextBox ID="TextNewPassword" runat="server" TextMode="Password" CssClass="profile-active-input" /></td>
                        </tr>
                        <tr>
                            <td class="form-field-label">CONFIRM PASSWORD</td>
                            <td class="colon-column">:</td>
                            <td><asp:TextBox ID="TextConfirmPassword" runat="server" TextMode="Password" CssClass="profile-active-input" /></td>
                        </tr>
                    </table>
                </asp:Panel>

                <div class="password-btn-container" style="margin-top: 20px; display: flex; justify-content: center; gap: 15px;">
                    <asp:Button ID="BtnEditPassword" runat="server" Text="Edit Password" OnClick="BtnEditPassword_Click" CssClass="profile-btn-edit" />
                    <asp:Button ID="BtnCancelPassword" runat="server" Text="Cancel" OnClick="BtnCancelPassword_Click" Visible="false" CssClass="profile-btn-cancel" />
                    <asp:Button ID="BtnSavePassword" runat="server" Text="Save Changes" OnClick="BtnSavePassword_Click" Visible="false" CssClass="profile-btn-save" />
                </div>

                <div style="margin-top: 15px; text-align: center;">
                    <asp:Label ID="LblMessage" runat="server"></asp:Label>
                </div>
            </div>

        </div>

        <div id="successModal" class="modal" style="display: none;">
            <div class="modal-content">
                <div style="display:flex; justify-content:center;">
                    <dotlottie-wc
                        src="https://lottie.host/ad9c9e32-8b5f-4fe0-bc0d-0d7e900717b7/CeTsD1XmXf.lottie"
                        style="width: 100px;height: 100px"
                        autoplay
                        loop
                    ></dotlottie-wc>
                </div>
                <h2>Success!</h2>
                <p>Your password has been changed successfully.</p>
                <div class="modal-buttons">
                    <button type="button" class="btn-confirm" style="background: #28a745; color: white;" onclick="closeSuccessModal()">Great!</button>
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