<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="index.aspx.cs" Inherits="PixelMath.index" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Pixel Math</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="images/pixelmath_logo.png"/>
</head>
<body class="min-h-screen flex flex-col bg-white">
<form id="form1" runat="server" style="display:contents">

    <!-- navbar -->
    <header class="bg-green-50 border-b-4 border-green-400 py-4 px-8 flex items-center justify-between">
        <div class="flex items-center space-x-3">
            <img src="images/pixelmath_logo_transparentbg.png" alt="Pixel Math Logo" class="w-10 h-10"/>
            <span class="text-green-800 text-xl font-bold">Pixel Math</span>
        </div>
        <div class="space-x-3">
            <asp:Button ID="btnLogin" runat="server" Text="login" OnClick="btnLogin_Click" CssClass="border border-green-700 text-green-700 px-4 py-2 rounded-md font-semibold hover:bg-green-100 transition duration-300 ease-in-out cursor-pointer bg-transparent" />
            <asp:Button ID="btnSignUpNav" runat="server" Text="sign up" OnClick="btnSignUp_Click" CssClass="bg-green-600 text-white px-4 py-2 rounded-md font-semibold hover:bg-green-700 transition duration-300 ease-in-out cursor-pointer" />
        </div>
    </header>

    <!-- hero section -->
    <section class="bg-green-50 py-24 px-8 text-center border-b border-green-100 flex-1">
        <h1 class="text-4xl font-bold text-green-900 mb-4">The smarter way to ace math</h1>
        <p class="text-green-700 text-lg mb-8 max-w-xl mx-auto">
            Interactive lessons, quizzes, and instant feedback all in one place.
        </p>
        <div class="space-x-4">
            <asp:Button ID="btnGetStarted" runat="server" Text="get started" OnClick="btnSignUp_Click" CssClass="bg-green-600 text-white px-6 py-3 rounded-lg font-semibold hover:bg-green-700 transition duration-300 ease-in-out cursor-pointer" />
            <asp:Button ID="btnLearnMore" runat="server" Text="learn more" OnClick="btnLearnMore_Click" CssClass="border border-green-600 text-green-700 px-6 py-3 rounded-lg font-semibold hover:bg-green-100 transition duration-300 ease-in-out cursor-pointer bg-transparent" />
        </div>
    </section>

    <!-- features -->
    <section class="py-16 px-8 bg-white">
        <div class="max-w-4xl mx-auto grid grid-cols-3 gap-6">
            <div class="bg-green-50 border border-green-100 rounded-xl p-6">
                <h3 class="text-green-800 font-bold mb-2">Structured courses</h3>
                <p class="text-green-600 text-sm">Step-by-step lessons built for all levels.</p>
            </div>
            <div class="bg-green-50 border border-green-100 rounded-xl p-6">
                <h3 class="text-green-800 font-bold mb-2">Quizzes & tests</h3>
                <p class="text-green-600 text-sm">Test your knowledge with instant grading.</p>
            </div>
            <div class="bg-green-50 border border-green-100 rounded-xl p-6">
                <h3 class="text-green-800 font-bold mb-2">Track progress</h3>
                <p class="text-green-600 text-sm">See your results and improvement over time.</p>
            </div>
        </div>
    </section>

    <!-- footer -->
    <footer class="bg-green-50 border-t-4 border-green-400 py-6 px-8 text-center text-green-700">
        &copy; Pixel Math 2026
    </footer>

</form>
</body>
</html>