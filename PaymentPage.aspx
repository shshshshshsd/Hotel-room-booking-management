<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="PaymentPage.aspx.cs" Inherits="WebApplicationRooms.PaymentPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment | Hotel Booking System</title>
    <style>
        :root {
            --primary: #89253e;
            --secondary: #3a6186;
            --success: #2e8b57;
            --warning: #ffa500;
            --danger: #dc143c;
            --light: #f8f9fa;
            --dark: #2c3e50;
            --border: #dee2e6;
            --text: #343a40;
            --shadow: 0 2px 12px rgba(0,0,0,0.08);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', 'Arial', sans-serif;
        }
        
        body {
            background: var(--light);
            padding: 20px;
            min-height: 100vh;
            color: var(--text);
        }
        
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            border-radius: 8px;
            box-shadow: var(--shadow);
            overflow: hidden;
            border: 1px solid var(--border);
        }
        
        .header {
            background: var(--primary);
            color: white;
            padding: 25px 30px;
            border-bottom: 1px solid var(--primary);
        }
        
        .header h1 {
            font-size: 24px;
            margin-bottom: 5px;
            font-weight: 600;
        }
        
        .form-container {
            padding: 35px;
        }
        
        .booking-summary {
            background: var(--light);
            padding: 20px;
            border-radius: 6px;
            margin-bottom: 25px;
            border: 1px solid var(--border);
        }
        
        .summary-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .summary-total {
            font-weight: 600;
            font-size: 18px;
            color: var(--primary);
            border-top: 1px solid var(--border);
            padding-top: 10px;
            margin-top: 10px;
        }
        
        .form-group {
            margin-bottom: 22px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
            font-size: 14px;
        }
        
        .required::after {
            content: " *";
            color: var(--danger);
        }
        
        input, select {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 14px;
            color: var(--text);
            background: #fff;
            transition: all 0.2s ease;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(58, 97, 134, 0.1);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .card-icons {
            display: flex;
            gap: 10px;
            margin-top: 8px;
        }
        
        .card-icon {
            width: 40px;
            height: 25px;
            background: var(--light);
            border: 1px solid var(--border);
            border-radius: 3px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            color: var(--text-light);
        }
        
        .actions {
            display: flex;
            gap: 12px;
            justify-content: space-between;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid var(--border);
        }
        
        .btn {
            padding: 12px 28px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s ease;
            min-width: 120px;
        }
        
        .btn-primary {
            background: var(--success);
            color: white;
            border: 1px solid #1e7e34;
        }
        
        .btn-primary:hover {
            background: #1e7e34;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(46, 139, 87, 0.3);
        }
        
        .btn-secondary {
            background: var(--secondary);
            color: white;
            border: 1px solid #2a4a6b;
        }
        
        .btn-secondary:hover {
            background: #2a4a6b;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(58, 97, 134, 0.3);
        }
        
        .btn-warning {
            background: var(--warning);
            color: white;
            border: 1px solid #cc8400;
        }
        
        .btn-warning:hover {
            background: #cc8400;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(255, 165, 0, 0.3);
        }
        
        .message {
            padding: 14px 16px;
            border-radius: 4px;
            margin: 0 0 25px 0;
            font-size: 14px;
            font-weight: 500;
            border: 1px solid transparent;
            text-align: center;
        }
        
        .message-success {
            background: rgba(46, 139, 87, 0.1);
            color: var(--success);
            border-color: rgba(46, 139, 87, 0.3);
        }
        
        .message-error {
            background: rgba(220, 20, 60, 0.1);
            color: var(--danger);
            border-color: rgba(220, 20, 60, 0.3);
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
            
            .actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>Complete Your Booking</h1>
                <p>Secure payment processing</p>
            </div>
            
            <div class="form-container">
                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

                <!-- Booking Summary -->
                <div class="booking-summary">
                    <h3 style="margin-bottom: 15px; color: var(--primary);">Booking Summary</h3>
                    <asp:Panel ID="pnlBookingSummary" runat="server">
                        <div class="summary-item">
                            <span>Room:</span>
                            <span><asp:Label ID="lblRoomName" runat="server"></asp:Label></span>
                        </div>
                        <div class="summary-item">
                            <span>Check-in:</span>
                            <span><asp:Label ID="lblCheckIn" runat="server"></asp:Label></span>
                        </div>
                        <div class="summary-item">
                            <span>Check-out:</span>
                            <span><asp:Label ID="lblCheckOut" runat="server"></asp:Label></span>
                        </div>
                        <div class="summary-item">
                            <span>Guests:</span>
                            <span><asp:Label ID="lblGuests" runat="server"></asp:Label></span>
                        </div>
                        <div class="summary-item summary-total">
                            <span>Total Amount:</span>
                            <span><asp:Label ID="lblTotalAmount" runat="server"></asp:Label> SAR</span>
                        </div>
                    </asp:Panel>
                </div>

                <!-- Payment Form -->
                <div class="form-section">
                    <h3 style="margin-bottom: 20px; color: var(--primary);">Payment Information</h3>
                    
                    <div class="form-group">
                        <label for="txtCardNumber" class="required">Card Number</label>
                        <asp:TextBox ID="txtCardNumber" runat="server" placeholder="1234 5678 9012 3456" 
                            MaxLength="19" required></asp:TextBox>
                        <div class="card-icons">
                            <div class="card-icon">💳</div>
                            <div class="card-icon">VISA</div>
                            <div class="card-icon">MC</div>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtExpiryDate" class="required">Expiry Date</label>
                            <asp:TextBox ID="txtExpiryDate" runat="server" placeholder="MM/YY" 
                                MaxLength="5" required></asp:TextBox>
                        </div>
                        
                        <div class="form-group">
                            <label for="txtCVV" class="required">CVV</label>
                            <asp:TextBox ID="txtCVV" runat="server" placeholder="123" 
                                MaxLength="3" TextMode="Password" required></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-group">
                        <label for="txtCardHolder" class="required">Cardholder Name</label>
                        <asp:TextBox ID="txtCardHolder" runat="server" placeholder="John Doe" required></asp:TextBox>
                    </div>
                </div>

                <div class="actions">
                     <a href="BookingsList.aspx" id="btnPayLater"                          
                        class="btn btn-warning"
                        onclick="return confirm('Your booking will be saved and pending. Continue?');" >Pay Later</a>
                    
                    <asp:Button ID="btnProcessPayment" runat="server" Text="Pay Now" 
                        CssClass="btn btn-primary" OnClick="btnProcessPayment_Click" OnClientClick="return confirm('Your booking will be confirmed. Continue?');" />
                </div>
            </div>
        </div>
        
        <!-- Hidden fields to store data -->
        <asp:HiddenField ID="hfBookingId" runat="server" />
    </form>
    
    <script type="text/javascript">
        // Format card number with spaces
        document.getElementById('<%= txtCardNumber.ClientID %>').addEventListener('input', function (e) {
            var value = e.target.value.replace(/\s+/g, '').replace(/[^0-9]/gi, '');
            var matches = value.match(/\d{4,16}/g);
            var match = matches && matches[0] || '';
            var parts = [];
            for (var i = 0, len = match.length; i < len; i += 4) {
                parts.push(match.substring(i, i + 4));
            }
            if (parts.length) {
                e.target.value = parts.join(' ');
            } else {
                e.target.value = value;
            }
        });

        // Format expiry date
        document.getElementById('<%= txtExpiryDate.ClientID %>').addEventListener('input', function (e) {
            var value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                e.target.value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
        });
    </script>
</body>
</html>