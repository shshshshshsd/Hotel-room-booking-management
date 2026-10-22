<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookingsDashboard.aspx.cs" Inherits="WebApplicationRooms.BookingsDashboard" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings Dashboard | Hotel System</title>
    <style>
        :root {
            --primary: #89253e;
            --secondary: #3a6186;
            --success: #48bb78;
            --warning: #ed8936;
            --danger: #f56565;
            --light: #f7fafc;
            --dark: #2d3748;
            --border: #e2e8f0;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Arial, sans-serif;
        }
        
        body {
           background: linear-gradient(135deg, var(--primary) 0%, var(--secondary) 100%);
            min-height: 100vh;
            color: var(--dark);
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Header */
        .header {
            background: white;
            padding: 30px;
            margin-bottom: 30px;
            border-radius: 15px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .header h1 {
            color: var(--primary);
            font-size: 2.5rem;
            margin-bottom: 10px;
        }
        
        .header p {
            color: #718096;
            font-size: 1.1rem;
        }
        
        .user-info {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: var(--light);
            padding: 10px 20px;
            border-radius: 25px;
            margin-top: 15px;
            font-weight: 500;
        }
        
        /* Quick Stats */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        
        .stat-card:hover {
            transform: translateY(-5px);
        }
        
        .stat-icon {
            font-size: 2.5rem;
            margin-bottom: 15px;
        }
        
        .stat-number {
            font-size: 2rem;
            font-weight: bold;
            margin-bottom: 5px;
        }
        
        .stat-label {
            color: #718096;
            font-size: 0.9rem;
        }
        
        /* Actions Grid */
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .action-card {
            background: white;
            padding: 30px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .action-card:hover {
            border-color: var(--primary);
            transform: translateY(-3px);
        }
        
        .action-icon {
            font-size: 3rem;
            margin-bottom: 20px;
            color: var(--primary);
        }
        
        .action-title {
            font-size: 1.3rem;
            margin-bottom: 10px;
            color: var(--dark);
        }
        
        .action-description {
            color: #718096;
            margin-bottom: 20px;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            font-weight: 600;
            text-decoration: none;
            display: inline-block;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .btn-primary {
            background: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background: var(--secondary);
            transform: translateY(-2px);
        }
        
        /* Navigation */
        .nav {
            display: flex;
            gap: 15px;
            justify-content: center;
            flex-wrap: wrap;
        }
        
        .nav a {
            padding: 12px 25px;
            background: white;
            border-radius: 25px;
            text-decoration: none;
            color: var(--dark);
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 3px 10px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .nav a:hover {
            background: var(--primary);
            color: white;
            transform: translateY(-2px);
        }
        
        .logout {
            background: var(--danger) !important;
            color: white !important;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .header h1 {
                font-size: 2rem;
            }
            
            .stats-grid,
            .actions-grid {
                grid-template-columns: 1fr;
            }
            
            .nav {
                flex-direction: column;
                align-items: center;
            }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <!-- Header -->
            <div class="header">
                <h1>Hotel Booking Dashboard</h1>
                <p>Welcome to your booking management system</p>
                <div class="user-info">
                    <i class="fas fa-user-circle"></i>
                    <asp:Label ID="lblUser" runat="server"></asp:Label>
                </div>
            </div>

            <!-- Quick Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon" style="color: var(--primary);">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-number"><asp:Label ID="lblTotalBookings" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Total Bookings</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="color: var(--success);">
                        <i class="fas fa-bed"></i>
                    </div>
                    <div class="stat-number"><asp:Label ID="lblActiveBookings" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Active Stays</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="color: var(--warning);">
                        <i class="fas fa-clock"></i>
                    </div>
                    <div class="stat-number"><asp:Label ID="lblPendingBookings" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Pending Approval</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-icon" style="color: var(--danger);">
                        <i class="fas fa-times-circle"></i>
                    </div>
                    <div class="stat-number"><asp:Label ID="lblCancelledBookings" runat="server" Text="0"></asp:Label></div>
                    <div class="stat-label">Cancelled</div>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="actions-grid">
                <div class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-plus-circle"></i>
                    </div>
                    <h3 class="action-title">Create New Booking</h3>
                    <p class="action-description">Add a new reservation for your guests</p>
                    <asp:HyperLink ID="lnkAddBooking" runat="server" NavigateUrl="AddBooking.aspx" CssClass="btn btn-primary">
                        <i class="fas fa-plus"></i> Add Booking
                    </asp:HyperLink>
                </div>
                
                <div class="action-card">
                    <div class="action-icon">
                        <i class="fas fa-list"></i>
                    </div>
                    <h3 class="action-title">View All Bookings</h3>
                    <p class="action-description">See complete list of all reservations</p>
                    <asp:HyperLink ID="lnkViewBookings" runat="server" NavigateUrl="BookingsList.aspx" CssClass="btn btn-primary">
                        <i class="fas fa-eye"></i> View All
                    </asp:HyperLink>
                </div>
                
               
            </div>

            <!-- Navigation -->
            <div class="nav">
                <asp:HyperLink ID="lnkRooms" runat="server" NavigateUrl="Rooms.aspx" Visible="false">
                    <i class="fas fa-door-closed"></i> Room Management
                </asp:HyperLink>
                <asp:HyperLink ID="lnkStatistic" runat="server" NavigateUrl="StatisticPage.aspx" Visible="false">
                    <i class="fas fa-chart-bar"></i> Statistics
                </asp:HyperLink>
                 <asp:HyperLink ID="lnkNotifications" runat="server" NavigateUrl="NotificationsList.aspx" Visible="false">
                    <i class="fas fa-bell"></i> Notifications
                </asp:HyperLink>
                <asp:LinkButton ID="lnkLogout" runat="server" CssClass="logout" OnClick="lnkLogout_Click">
                    <i class="fas fa-sign-out-alt"></i> Logout
                </asp:LinkButton>
            </div>
        </div>
    </form>
</body>
</html>