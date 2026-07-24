<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FAQ.aspx.cs" Inherits="PixelMath.FAQ" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Frequently Asked Questions - Pixel Math</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="icon" type="image/png" href="images/pixelmath_logo.png"/>
</head>
<body class="min-h-screen flex flex-col bg-white">
<form id="form1" runat="server" style="display:contents">

    <!-- navbar -->
    <header class="bg-green-50 border-b-4 border-green-400 py-4 px-8 flex items-center justify-between">
        <div class="flex items-center space-x-3 cursor-pointer" onclick="window.location.href='index.aspx'">
            <img src="images/pixelmath_logo_transparentbg.png" alt="Pixel Math Logo" class="w-10 h-10"/>
            <span class="text-green-800 text-xl font-bold">Pixel Math</span>
        </div>
        <div class="space-x-3">
            <asp:Button ID="btnLogin" runat="server" Text="login" OnClick="btnLogin_Click" CssClass="border border-green-700 text-green-700 px-4 py-2 rounded-md font-semibold hover:bg-green-100 transition duration-300 ease-in-out cursor-pointer bg-transparent" />
            <asp:Button ID="btnSignUp" runat="server" Text="sign up" OnClick="btnSignUp_Click" CssClass="bg-green-600 text-white px-4 py-2 rounded-md font-semibold hover:bg-green-700 transition duration-300 ease-in-out cursor-pointer" />
        </div>
    </header>

    <!-- header intro -->
    <section class="bg-green-50 py-16 px-8 text-center border-b border-green-100">
        <h1 class="text-3xl font-bold text-green-900 mb-3">Frequently Asked Questions</h1>
        <p class="text-green-700 text-base max-w-xl mx-auto">
            Everything you need to know about how Pixel Math helps students and lecturers master mathematics.
        </p>
    </section>

    <!-- faq content container -->
    <main class="py-12 px-8 flex-1 max-w-4xl mx-auto w-full space-y-6">

        <!-- FAQ Item 1 -->
        <div class="bg-green-50/50 border border-green-100 rounded-2xl p-6 shadow-xs">
            <h3 class="text-green-900 font-bold text-base mb-2">✨ What is Pixel Math?</h3>
            <p class="text-green-700 text-sm leading-relaxed">
                Pixel Math is an interactive, web-based learning platform designed to make mathematics engaging, structured, and accessible. It connects students and lecturers in a unified portal featuring structured courses, quizzes, immediate feedback, and class announcements.
            </p>
        </div>

        <!-- FAQ Item 2 -->
        <div class="bg-green-50/50 border border-green-100 rounded-2xl p-6 shadow-xs">
            <h3 class="text-green-900 font-bold text-base mb-2">👥 Who is Pixel Math for?</h3>
            <p class="text-green-700 text-sm leading-relaxed">
                The platform caters to two main user roles:
            </p>
            <ul class="list-disc list-inside text-green-700 text-sm mt-2 space-y-1">
                <li><strong>Students:</strong> Learners looking to test their skills with quizzes, review uploaded study resources, and track their academic progress over time.</li>
                <li><strong>Lecturers:</strong> Educators who want to create virtual classes, publish quizzes (objective and subjective), upload learning materials, monitor student enrollment approvals, and broadcast announcements.</li>
            </ul>
        </div>

        <!-- FAQ Item 3 -->
        <div class="bg-green-50/50 border border-green-100 rounded-2xl p-6 shadow-xs">
            <h3 class="text-green-900 font-bold text-base mb-2">📝 How do quizzes work on Pixel Math?</h3>
            <p class="text-green-700 text-sm leading-relaxed">
                Lecturers can build quizzes containing both multiple-choice (objective) questions and written (subjective) response questions. Students take timed quizzes within their enrolled classes. Objective questions are auto-graded instantly, while subjective questions allow lecturers to review student submissions, award marks, and provide custom written feedback.
            </p>
        </div>

        <!-- FAQ Item 4 -->
        <div class="bg-green-50/50 border border-green-100 rounded-2xl p-6 shadow-xs">
            <h3 class="text-green-900 font-bold text-base mb-2">🏫 How do students join a class?</h3>
            <p class="text-green-700 text-sm leading-relaxed">
                Once a student signs up and logs in, they can browse available classes and request enrollment. To keep classrooms secure, student enrollments start with a <strong>Pending</strong> status until the managing lecturer reviews and approves the request.
            </p>
        </div>

        <!-- FAQ Item 5 -->
        <div class="bg-green-50/50 border border-green-100 rounded-2xl p-6 shadow-xs">
            <h3 class="text-green-900 font-bold text-base mb-2">📂 What kind of resources can be shared?</h3>
            <p class="text-green-700 text-sm leading-relaxed">
                Lecturers can upload learning materials (such as lecture notes, formulas, reference guides, and exercise sheets) directly to specific classes. Students can view and download these resources anytime under their class resource center.
            </p>
        </div>

        <!-- FAQ Item 6 -->
        <div class="bg-green-50/50 border border-green-100 rounded-2xl p-6 shadow-xs">
            <h3 class="text-green-900 font-bold text-base mb-2">🚀 How do I get started?</h3>
            <p class="text-green-700 text-sm leading-relaxed">
                Getting started takes less than a minute! Click the <strong>Sign Up</strong> button in the top right corner to create your account as a student or lecturer and dive right in.
            </p>
        </div>

        <!-- Call to action block -->
        <div class="text-center pt-8">
            <asp:Button ID="btnBackHome" runat="server" Text="← Back to Home" OnClick="btnBackHome_Click" CssClass="bg-green-600 text-white px-6 py-3 rounded-xl font-semibold hover:bg-green-700 transition duration-300 ease-in-out cursor-pointer" />
        </div>

    </main>

    <!-- footer -->
    <footer class="bg-green-50 border-t-4 border-green-400 py-6 px-8 text-center text-green-700">
        &copy; Pixel Math 2026
    </footer>

</form>
</body>
</html>