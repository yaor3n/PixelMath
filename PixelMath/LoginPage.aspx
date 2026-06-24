<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginPage.aspx.cs" Inherits="PixelMath.LoginPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Login - Pixel Math</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="images/pixelmath_logo.png"/>
</head>

<body class="min-h-screen bg-green-50 flex flex-col">

    <form id="form1" runat="server" class="flex-1 flex flex-col">

        <!-- navbar (same style as homepage) -->
        <header class="bg-green-50 border-b-4 border-green-400 py-4 px-8 flex items-center justify-between">
            <div class="flex items-center space-x-3">
                <img src="images/pixelmath_logo_transparentbg.png" class="w-10 h-10" />
                <span class="text-green-800 text-xl font-bold">Pixel Math</span>
            </div>

            <a href="index.aspx"
               class="border border-green-700 text-green-700 px-4 py-2 rounded-md font-semibold hover:bg-green-100">
                Home
            </a>
        </header>

        <!-- login box -->
        <div class="flex-1 flex items-center justify-center px-6">

            <div class="bg-white border border-green-100 shadow-lg rounded-2xl w-full max-w-md p-8">

                <h2 class="text-2xl font-bold text-green-800 text-center mb-6">
                    Login to Pixel Math
                </h2>

                <!-- username -->
                <label class="text-green-700 text-sm font-semibold">Email</label>
                <asp:TextBox ID="email" runat="server"
                    CssClass="w-full mt-1 mb-4 px-4 py-2 border border-green-200 rounded-md focus:outline-none focus:ring-2 focus:ring-green-400" />

                <!-- password -->
                <label class="text-green-700 text-sm font-semibold">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" TextMode="Password"
                    CssClass="w-full mt-1 mb-6 px-4 py-2 border border-green-200 rounded-md focus:outline-none focus:ring-2 focus:ring-green-400" />

                <!-- login button -->
                <asp:Button ID="btnLogin" runat="server" Text="Login"
                    CssClass="w-full bg-green-600 text-white py-2 rounded-md font-semibold hover:bg-green-700 transition"
                    OnClick="btnLogin_Click" />

                <!-- signup redirect -->
                <div class="text-center mt-6">
                    <p class="text-green-700 text-sm">
                        Don’t have an account?
                    </p>

                    <a href="SignUpPage.aspx"
                       class="inline-block mt-2 text-green-700 font-semibold hover:underline">
                        Sign up here
                    </a>
                </div>

            </div>
        </div>

        <!-- footer -->
        <footer class="bg-green-50 border-t-4 border-green-400 py-4 text-center text-green-700">
            &copy; Pixel Math 2026
        </footer>

    </form>

    <script>
        sessionStorage.setItem("isLoggedIn", "true");
    </script>
</body>
</html>