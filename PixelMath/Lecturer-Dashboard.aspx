<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Lecturer-Dashboard.aspx.cs" Inherits="PixelMath.Lecturer_Dashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Lecturer Dashboard - Pixel Math</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-100 min-h-screen font-sans flex items-center justify-center">
    <form id="form1" runat="server">
        
        <div class="bg-white shadow-xl rounded-2xl p-8 w-[450px] border border-gray-100 text-center">
            
            <div class="mb-6">
                <span class="bg-green-100 text-green-800 text-xs font-bold px-3 py-1 rounded-full uppercase tracking-wider">
                    Staff Portal
                </span>
                <h1 class="text-3xl font-extrabold text-gray-800 mt-3">Testing Logout Button Lecturer</h1>
            </div>

            <hr class="border-gray-150 my-6" />

            <div class="bg-gray-50 rounded-xl p-4 mb-6 text-left">
                <p class="text-gray-700 text-sm font-medium">click button to logout</p>
            </div>

            <asp:Button ID="btnLogout" runat="server" Text="Log Out Securely" 
                OnClick="btnLogout_Click"
                CssClass="w-full bg-red-600 text-white py-2.5 px-4 rounded-xl font-bold tracking-wide hover:bg-red-700 active:scale-[0.99] transition-all cursor-pointer shadow-md shadow-red-200" />
            
        </div>

    </form>
</body>
</html>