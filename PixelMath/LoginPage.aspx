<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="PixelMath.LoginPage" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - Pixel Math</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="images/pixelmath_logo.png"/>
</head>
<body class="min-h-screen bg-green-50 flex flex-col">

    <form id="form1" runat="server" class="flex-1 flex flex-col">

        <!-- navbar -->
        <header class="bg-white border-b-4 border-green-400 py-3 sm:py-4 px-4 sm:px-8 flex items-center justify-between">
            <div class="flex items-center space-x-2 sm:space-x-3">
                <img src="images/pixelmath_logo_transparentbg.png" class="w-8 h-8 sm:w-10 sm:h-10" />
                <span class="text-green-800 text-lg sm:text-xl font-bold">Pixel Math</span>
            </div>

            <a href="index.aspx"
               class="border border-green-700 text-green-700 px-3 py-1.5 sm:px-4 sm:py-2 rounded-md text-xs sm:text-sm font-semibold hover:bg-green-100 transition">
                Home
            </a>
        </header> 

        <!-- login box -->
        <div class="flex-1 flex items-center justify-center px-4 sm:px-6 py-8">

            <div class="bg-white border border-green-100 shadow-lg rounded-2xl w-full max-w-md p-5 sm:p-8">

                <h2 class="text-xl sm:text-2xl font-bold text-green-800 text-center mb-6">
                    Login to Pixel Math
                </h2>

                <asp:Label ID="labelStatus" runat="server" Visible="false" CssClass="block mb-4 px-4 py-3 rounded-lg bg-orange-50 text-orange-700 text-xs sm:text-sm font-semibold border border-orange-200" />

                <!-- username -->
                <label class="text-green-700 text-xs sm:text-sm font-semibold">Email</label>
                <asp:TextBox ID="email" runat="server"
                    CssClass="w-full mt-1 mb-4 px-4 py-2.5 sm:py-2 border border-green-200 rounded-md text-xs sm:text-sm focus:outline-none focus:ring-2 focus:ring-green-400" />

                <!-- password -->
                <label class="text-green-700 text-xs sm:text-sm font-semibold">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                    CssClass="w-full mt-1 mb-2 px-4 py-2.5 sm:py-2 border border-green-200 rounded-md text-xs sm:text-sm focus:outline-none focus:ring-2 focus:ring-green-400" />

                <div class="text-right mb-6">
                    <a href="ForgotPasswordPage.aspx" class="text-xs text-green-700 hover:underline font-semibold">
                        Forgot Password?
                    </a>
                </div>

                <!-- login button -->
                <asp:Button ID="btnLogin" runat="server" Text="Login"
                    CssClass="w-full bg-green-600 text-white py-2.5 sm:py-2 rounded-md text-sm sm:text-base font-semibold hover:bg-green-700 transition cursor-pointer"
                    OnClick="btnLogin_Click" />

                <!-- signup redirect -->
                <div class="text-center mt-6">
                    <p class="text-green-700 text-xs sm:text-sm">
                        Don’t have an account?
                    </p>

                    <a href="SignUpPage.aspx"
                       class="inline-block mt-1 text-green-700 text-xs sm:text-sm font-semibold hover:underline">
                        Sign up here
                    </a>
                </div>

            </div>
        </div>

        <!-- footer -->
        <footer class="bg-green-50 border-t-4 border-green-400 py-4 text-center text-green-700 text-xs sm:text-sm">
            &copy; Pixel Math 2026
        </footer>

    </form>
</body>
</html>