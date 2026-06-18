<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SignUpPage.aspx.cs" Inherits="PixelMath.SignUpPage" %>
<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign Up - Pixel Math</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link class="flex" rel="icon" type="image/png" href="images/pixelmath_logo.png"/>
    <script type="text/javascript">
        function validateSignup() {
            const name = document.getElementById("<%= txtFullName.ClientID %>").value.trim();
            const email = document.getElementById("<%= txtEmail.ClientID %>").value.trim();
            const password = document.getElementById("<%= txtPassword.ClientID %>").value;
            const confirm = document.getElementById("<%= txtConfirmPassword.ClientID %>").value;

            if (!name || !email || !password || !confirm) {
                alert("Please fill in all fields");
                return false;
            }

            if (password !== confirm) {
                alert("Passwords do not match");
                return false;
            }

            return true;
        }
    </script>
</head>
<body class="bg-green-50 min-h-screen flex items-center justify-center">
    <form id="form1" runat="server" class="bg-white shadow-lg rounded-xl p-8 w-96">

        <div class="text-center mb-6">
            <h2 class="text-2xl font-bold text-green-800">Create Account</h2>
            <p class="text-green-600 text-sm">Join Pixel Math today</p>
        </div>

        <div class="space-y-4">
            <asp:TextBox ID="txtFullName" runat="server" placeholder="Full Name"
                CssClass="w-full border border-green-200 p-2 rounded focus:outline-none focus:ring-2 focus:ring-green-400"></asp:TextBox>

            <asp:TextBox ID="txtEmail" runat="server" placeholder="Email" TextMode="Email"
                CssClass="w-full border border-green-200 p-2 rounded focus:outline-none focus:ring-2 focus:ring-green-400"></asp:TextBox>

            <div class="flex flex-col">
                <label class="text-green-700 text-xs font-semibold mb-1">Account Type:</label>
                <asp:DropDownList ID="ddlRole" runat="server" 
                    CssClass="w-full border border-green-200 p-2 rounded bg-white text-gray-700 focus:outline-none focus:ring-2 focus:ring-green-400">
                    <asp:ListItem Text="Student" Value="1"></asp:ListItem>
                    <asp:ListItem Text="Lecturer" Value="2"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:TextBox ID="txtPassword" runat="server" placeholder="Password" TextMode="Password"
                CssClass="w-full border border-green-200 p-2 rounded focus:outline-none focus:ring-2 focus:ring-green-400"></asp:TextBox>

            <asp:TextBox ID="txtConfirmPassword" runat="server" placeholder="Confirm Password" TextMode="Password"
                CssClass="w-full border border-green-200 p-2 rounded focus:outline-none focus:ring-2 focus:ring-green-400"></asp:TextBox>

            <div class="text-center text-sm font-semibold">
                <asp:Label ID="lblStatus" runat="server"></asp:Label>
            </div>

            <asp:Button ID="btnSubmit" runat="server" Text="Sign Up" 
                OnClientClick="return validateSignup();" OnClick="btnSubmit_Click"
                CssClass="w-full bg-green-600 text-white py-2 rounded-md font-semibold hover:bg-green-700 transition cursor-pointer text-center" />
        </div>

        <div class="my-6 text-center text-green-500 text-sm">
            already have an account?
        </div>

        <asp:Button ID="btnLoginRedirect" runat="server" Text="Go to Login" 
            OnClick="btnLoginRedirect_Click" UseSubmitBehavior="false"
            CssClass="w-full border border-green-600 text-green-700 py-2 rounded-md font-semibold hover:bg-green-100 transition cursor-pointer text-center" />

    </form>
</body>
</html>