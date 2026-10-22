<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AddBooking.aspx.cs" Inherits="WebApplicationRooms.AddBooking" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>New Booking | Hotel Management System</title>
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
            --text-light: #6c757d;   
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
            max-width: 800px;
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
            letter-spacing: 0.5px;
        }
        
        .header p {
            font-size: 14px;
            opacity: 0.8;
            font-weight: 300;
        }
        
        .form-container {
            padding: 35px;
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
        
        input, select, textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 14px;
            color: var(--text);
            background: #fff;
            transition: all 0.2s ease;
        }
        
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(58, 97, 134, 0.1);
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-row-3 {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
        }
        
        .services-section {
            background: var(--light);
            padding: 20px;
            border-radius: 6px;
            margin: 25px 0;
            border: 1px solid var(--border);
        }
        
        .services-title {
            font-weight: 600;
            margin-bottom: 16px;
            color: var(--dark);
            font-size: 15px;
            border-bottom: 1px solid var(--border);
            padding-bottom: 8px;
        }
        
        /* Service Item Styles */
        .service-item {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            margin-bottom: 16px;
            padding: 16px;
            border: 2px solid var(--border);
            border-radius: 6px;
            background: white;
            transition: all 0.3s ease;
        }
        
        .service-item:hover {
            border-color: var(--secondary);
            background: #f8fafc;
        }
        
        .service-content {
            flex: 1;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 15px;
        }
        
        .service-text {
            flex: 1;
        }
        
        .service-label {
            display: block;
            font-weight: 500;
            color: var(--dark);
            margin-bottom: 4px;
            transition: color 0.2s ease;
        }
        
        .service-description {
            font-size: 13px;
            color: var(--text-light);
            line-height: 1.4;
            display: block;
        }
        
        .service-price {
            color: var(--success);
            font-weight: 600;
            font-size: 14px;
            background: rgba(46, 139, 87, 0.1);
            padding: 6px 10px;
            border-radius: 4px;
            flex-shrink: 0;
            text-align: center;
            min-width: 80px;
            border: 1px solid rgba(46, 139, 87, 0.2);
        }
        
        .price-box {
            background: var(--primary);
            color: white;
            padding: 22px;
            border-radius: 6px;
            text-align: center;
            margin: 25px 0;
            border: 1px solid var(--primary);
        }
        
        .price-amount {
            font-size: 32px;
            font-weight: 600;
            margin: 8px 0;
            font-family: 'Courier New', monospace;
        }
        
        .price-box div:first-child {
            font-size: 14px;
            opacity: 0.9;
            font-weight: 400;
        }
        
        .price-box div:last-child {
            font-size: 12px;
            opacity: 0.7;
            margin-top: 5px;
        }
        
        .actions {
            display: flex;
            gap: 12px;
            justify-content: flex-end;
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
            background: var(--secondary);
            color: white;
            border: 1px solid #2a4a6b;
        }
        
        .btn-primary:hover {
            background: #2a4a6b;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(58, 97, 134, 0.3);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
            border: 1px solid #5a6268;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(108, 117, 125, 0.3);
        }
        
        .message {
            padding: 14px 16px;
            border-radius: 4px;
            margin: 0 0 25px 0;
            font-size: 14px;
            font-weight: 500;
            border: 1px solid transparent;
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
        
        input:invalid, select:invalid {
            border-color: var(--danger);
        }
        
        input:valid, select:valid {
            border-color: var(--success);
        }
        
        .capacity-info {
            font-size: 12px;
            color: var(--text-light);
            margin-top: 4px;
            font-style: italic;
        }
        
        .form-section {
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 18px;
            padding-bottom: 8px;
            border-bottom: 1px solid var(--border);
        }

        @media (max-width: 768px) {
            .form-row, .form-row-3 {
                grid-template-columns: 1fr;
            }
            
            .actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .form-container {
                padding: 25px;
            }
            
            .header {
                padding: 20px 25px;
            }
            
            .service-item {
                padding: 12px;
            }
            
            .service-content {
                flex-direction: column;
                gap: 8px;
            }
            
            .service-price {
                align-self: flex-start;
            }
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>New Booking Reservation</h1>
                <p>Complete the form below to create a new booking</p>
            </div>
            
            <div class="form-container">
                <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>

                <div class="form-section">
                    <div class="section-title">Guest Information</div>
                    
                    <div class="form-group">
                        <label for="txtGuestName" class="required">Guest Name</label>
                        <asp:TextBox ID="txtGuestName" runat="server" placeholder="Enter guest full name" required></asp:TextBox>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtGuestEmail" class="required">Email Address</label>
                            <asp:TextBox ID="txtGuestEmail" runat="server" TextMode="Email" placeholder="guest@example.com" required></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="txtGuestPhone" class="required">Phone Number</label>
                            <asp:TextBox ID="txtGuestPhone" runat="server" placeholder="Enter phone number" required></asp:TextBox>
                        </div>
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-title">Booking Details</div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="txtCheckInDate" class="required">Check-In Date</label>
                            <asp:TextBox ID="txtCheckInDate" runat="server" TextMode="Date" required OnTextChanged="CalculatePrice" AutoPostBack="true"></asp:TextBox>
                        </div>

                        <div class="form-group">
                            <label for="txtCheckOutDate" class="required">Check-Out Date</label>
                            <asp:TextBox ID="txtCheckOutDate" runat="server" TextMode="Date" required OnTextChanged="CalculatePrice" AutoPostBack="true"></asp:TextBox>
                        </div>
                    </div>

                    <div class="form-row-3">
                        <div class="form-group">
                            <label for="ddlRoom" class="required">Room Selection</label>
                            <asp:DropDownList ID="ddlRoom" runat="server" required OnSelectedIndexChanged="CalculatePrice" AutoPostBack="true">
                                <asp:ListItem Value="" Text="Select a room type"></asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label for="txtNumberOfGuests" class="required">Number of Guests</label>
                            <asp:TextBox ID="txtNumberOfGuests" runat="server" TextMode="Number" min="1" max="10" 
                                placeholder="Enter number of guests" required OnTextChanged="CalculatePrice" AutoPostBack="true"></asp:TextBox>
                            <div class="capacity-info">Enter the total number of guests staying in the room</div>
                        </div>

                        
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-title">Additional Services</div>
                    
                    <div class="services-section">
                        <div class="services-title">Optional Services</div>
                         <div class="service-item">
                            <asp:CheckBox ID="chkSpa" runat="server" AutoPostBack="true" OnCheckedChanged="CalculatePrice"  CssClass="service-checkbox" />
                           
                            <div class="service-content">
                                <div class="service-text">
                                    <span class="service-label">Spa Access</span>
                                    <span class="service-description">Full access to spa facilities and amenities including sauna, steam room, and relaxation areas</span>
                                </div>
                                <span class="service-price">50 SAR</span>
                            </div>
                        </div>
                        
                        <div class="service-item">
                            <asp:CheckBox ID="chkMeals" runat="server" AutoPostBack="true" OnCheckedChanged="CalculatePrice"  CssClass="service-checkbox" />
                            
                            <div class="service-content">
                                <div class="service-text">
                                    <span class="service-label">Meal Package</span>
                                    <span class="service-description">Daily breakfast, lunch, and dinner with our premium dining options</span>
                                </div>
                                <span class="service-price">30 SAR/meal</span>
                            </div>
                        </div>
                        
                        <div class="service-item">
                            <asp:CheckBox ID="chkTransportation" runat="server" OnCheckedChanged="CalculatePrice" AutoPostBack="true" CssClass="service-checkbox"/>
                            
                            <div class="service-content">
                                <div class="service-text">
                                    <span class="service-label">Transportation Service</span>
                                    <span class="service-description">Complimentary airport transfer and local transportation services</span>
                                </div>
                                <span class="service-price">25 SAR</span>
                            </div>
                        </div>
                        
                    </div>
                </div>

                <div class="form-section">
                    <div class="section-title">Additional Information</div>
                    
                    <div class="form-group">
                        <label for="txtSpecialRequests">Special Requests</label>
                        <asp:TextBox ID="txtSpecialRequests" runat="server" TextMode="MultiLine" Rows="4" placeholder="Enter any special requirements or requests"></asp:TextBox>
                    </div>
                </div>

                <asp:Panel ID="pnlPrice" runat="server" CssClass="price-box" Visible="false">
                    <div>Total Amount</div>
                    <div class="price-amount"><asp:Label ID="lblTotalPrice" runat="server"></asp:Label> SAR</div>
                    <div>Including all selected services and taxes</div>
                  
                </asp:Panel>

                <div class="actions">
                    <a href="BookingsDashboard.aspx" onclick="return confirm('Are you sure you want to cancel this booking?');" class="btn btn-secondary">Cancel</a>
                    <asp:Button ID="btnSave" runat="server" Text="Create Booking" OnClick="btnSave_Click" CssClass="btn btn-primary" OnClientClick= "return confirm('Are you sure you want to confirm this booking?');" />
                </div>
            </div>
        </div>
    </form>
</body>
</html>