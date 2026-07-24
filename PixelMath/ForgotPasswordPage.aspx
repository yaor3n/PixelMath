<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ForgotPasswordPage.aspx.cs" Inherits="PixelMath.ForgotPasswordPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Forgot Password - Pixel Math</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="images/pixelmath_logo.png"/>
</head>
<body class="min-h-screen bg-green-50 flex flex-col">

    <form id="form1" runat="server" class="flex-1 flex flex-col">

        <!-- Navbar -->
        <header class="bg-green-50 border-b-4 border-green-400 py-4 px-8 flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <img src="images/pixelmath_logo_transparentbg.png" class="w-10 h-10" />
                <span class="text-green-800 text-xl font-bold">Pixel Math</span>
            </div>
            <a href="LoginPage.aspx" class="border border-green-700 text-green-700 px-4 py-2 rounded-md font-semibold hover:bg-green-100">
                Back to Login
            </a>
        </header>

        <!-- Main Card Container -->
        <div class="flex-1 flex items-center justify-center px-6 py-8">
            <div class="bg-white border border-green-100 shadow-lg rounded-2xl w-full max-w-md p-8">

                <!-- Alert Message Label -->
                <asp:Label ID="lblMessage" runat="server" CssClass="block text-center text-sm font-semibold mb-4" Visible="false"></asp:Label>

                <!-- ---------------- STEP 1: REQUEST OTP ---------------- -->
                <asp:Panel ID="pnlStep1" runat="server">
                    <h2 class="text-2xl font-bold text-green-800 text-center mb-2">Forgot Password</h2>
                    <p class="text-xs text-gray-500 text-center mb-6">Enter your email address to receive a 6-digit OTP code.</p>

                    <label class="text-green-700 text-sm font-semibold">Registered Email</label>
                    <asp:TextBox ID="txtEmail" runat="server" TextMode="Email"
                        CssClass="w-full mt-1 mb-4 px-4 py-2 border border-green-200 rounded-md focus:outline-none focus:ring-2 focus:ring-green-400" Placeholder="name@example.com" />

                    <asp:Button ID="btnSendOTP" runat="server" Text="Send OTP Code"
                        CssClass="w-full bg-green-600 text-white py-2 rounded-md font-semibold hover:bg-green-700 transition cursor-pointer"
                        OnClick="btnSendOTP_Click" />
                </asp:Panel>

                <!-- ---------------- STEP 2: VERIFY OTP & RESET PASSWORD ---------------- -->
                <asp:Panel ID="pnlStep2" runat="server" Visible="false">
                    <h2 class="text-2xl font-bold text-green-800 text-center mb-2">Verify OTP</h2>
                    <p class="text-xs text-gray-500 text-center mb-6">Enter the code sent to your email and set your new password.</p>

                    <!-- OTP Code Input -->
                    <label class="text-green-700 text-sm font-semibold">6-Digit OTP</label>
                    <asp:TextBox ID="txtOTP" runat="server" MaxLength="6"
                        CssClass="w-full mt-1 mb-4 px-4 py-2 border border-green-200 rounded-md tracking-widest text-center text-lg font-bold focus:outline-none focus:ring-2 focus:ring-green-400" Placeholder="000000" />

                    <!-- New Password Input -->
                    <label class="text-green-700 text-sm font-semibold">New Password</label>
                    <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password"
                        CssClass="w-full mt-1 mb-4 px-4 py-2 border border-green-200 rounded-md focus:outline-none focus:ring-2 focus:ring-green-400" />

                    <!-- Confirm Password Input -->
                    <label class="text-green-700 text-sm font-semibold">Confirm Password</label>
                    <asp:TextBox ID="txtConfirmPassword" runat="server" TextMode="Password"
                        CssClass="w-full mt-1 mb-6 px-4 py-2 border border-green-200 rounded-md focus:outline-none focus:ring-2 focus:ring-green-400" />

                    <asp:Button ID="btnResetPassword" runat="server" Text="Reset Password"
                        CssClass="w-full bg-green-600 text-white py-2 rounded-md font-semibold hover:bg-green-700 transition cursor-pointer"
                        OnClick="btnResetPassword_Click" />
                </asp:Panel>

            </div>
        </div>

        <footer class="bg-green-50 border-t-4 border-green-400 py-4 text-center text-green-700">
            &copy; Pixel Math 2026
        </footer>

    </form>
</body>
</html>