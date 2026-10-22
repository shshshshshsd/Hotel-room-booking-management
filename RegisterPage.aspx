<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegisterPage.aspx.cs" Inherits="WebApplicationRooms.RegisterPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | Hotel Booking System</title>
    <style>
        :root {
             --primary: #89253e;
            --secondary: #3a6186;
            --success: #2ecc71;
            --accent: #e74c3c;
            --light: #ecf0f1;
            --dark: #2c3e50;
            --shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            --transition: all 0.3s ease;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        
        .container {
            max-width: 500px;
            width: 100%;
            background: white;
            border-radius: 15px;
            box-shadow: var(--shadow);
            overflow: hidden;
        }
        
        .header {
            background: var(--primary);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .header::before {
            content: "";
            position: absolute;
            top: -50px;
            right: -50px;
            width: 120px;
            height: 120px;
            background: #2ecc71
            border-radius: 50%;
        }
        
        .header::after {
            content: "";
            position: absolute;
            bottom: -30px;
            left: -30px;
            width: 80px;
            height: 80px;
            background: #7f8c8d;
            border-radius: 50%;
        }
        
        .header h2 {
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 8px;
            position: relative;
            z-index: 1;
        }
        
        .header p {
            opacity: 0.9;
            font-size: 16px;
            position: relative;
            z-index: 1;
        }
        
        .form-container {
            padding: 30px;
        }
        
        .page-title {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .page-title h3 {
            color: var(--primary);
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 8px;
        }
        
        .page-title p {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
        }
        
        .required::after {
            content: " *";
            color: var(--accent);
        }
        
        .input-group {
            position: relative;
        }
        
        .input-group i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #7f8c8d;
            z-index: 1;
        }
        
        input[type="text"], 
        input[type="email"], 
        input[type="tel"], 
        input[type="password"],
        input[type="number"] {
            width: 100%;
            padding: 14px 15px 14px 45px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 16px;
            transition: var(--transition);
            background-color: #f8f9fa;
        }
        
        input:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
            background-color: white;
        }
        
        .btn-register {
            width: 100%;
            padding: 15px;
            background: var(--secondary);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            margin-top: 10px;
            box-shadow: 0 4px 6px rgba(52, 152, 219, 0.3);
        }
        
        .btn-register:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(52, 152, 219, 0.4);
        }
        
        .btn-register:active {
            transform: translateY(0);
        }
        
        .login-link {
            text-align: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        
        .login-link a {
            color: var(--secondary);
            text-decoration: none;
            font-weight: 500;
            transition: var(--transition);
        }
        
        .login-link a:hover {
            color: var(--primary);
            text-decoration: underline;
        }
        
        .message {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 500;
        }
        
        .message-success {
            background-color: rgba(46, 204, 113, 0.1);
            color: var(--success);
            border: 1px solid rgba(46, 204, 113, 0.3);
        }
        
        .message-error {
            background-color: rgba(231, 76, 60, 0.1);
            color: var(--accent);
            border: 1px solid rgba(231, 76, 60, 0.3);
        }
        
        @media (max-width: 480px) {
            .container {
                max-width: 100%;
            }
            
            .form-container {
                padding: 20px;
            }
            
            .header {
                padding: 25px 20px;
            }
            
            .header h2 {
                font-size: 24px;
            }
        }
        
        .password-strength {
            margin-top: 5px;
            font-size: 12px;
            color: #7f8c8d;
        }
        
        .terms {
            display: flex;
            align-items: center;
            gap: 8px;
            margin: 20px 0;
            font-size: 14px;
            color: #7f8c8d;
        }
        
        .terms a {
            color: var(--secondary);
            text-decoration: none;
        }
        
        .terms a:hover {
            text-decoration: underline;
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h2>Hotel Booking System</h2>
                <p>Create your account to start booking</p>
            </div>
            
            <div class="form-container">
                <div class="page-title">
                    <h3>Create New Account</h3>
                    <p>Join us and enjoy our services</p>
                </div>
                
                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

                <div class="form-group">
                    <label for="txtName" class="required">Full Name</label>
                    <div class="input-group">
                        <i class="fas fa-user"></i>
                        <asp:TextBox ID="txtName" runat="server" placeholder="Enter your full name" required></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtEmail" class="required">Email Address</label>
                    <div class="input-group">
                        <i class="fas fa-envelope"></i>
                        <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" placeholder="your.email@example.com" required></asp:TextBox>
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="txtPhone" class="required">Phone Number</label>
                    <div class="input-group">
                        <i class="fas fa-phone"></i>
                        <asp:TextBox ID="txtPhone" runat="server" placeholder="Enter your phone number" required></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtUsername" class="required">Username</label>
                    <div class="input-group">
                        <i class="fas fa-user-tag"></i>
                        <asp:TextBox ID="txtUsername" runat="server" placeholder="Choose a username" required></asp:TextBox>
                    </div>
                </div>

                <div class="form-group">
                    <label for="txtPassword" class="required">Password</label>
                    <div class="input-group">
                        <i class="fas fa-lock"></i>
                        <asp:TextBox ID="txtPassword" runat="server" TextMode="Password" placeholder="Create a password" required></asp:TextBox>
                    </div>
                   
                </div>

              
           
                <asp:Button ID="btnRegister" runat="server" Text="Create Account" OnClick="btnRegister_OnClick" CssClass="btn-register" />
                
                <div class="login-link">
                    Already have an account? <a href="LoginPage.aspx">Sign in here</a>
                </div>
            </div>
        </div>
    </form>
</body>
</html>