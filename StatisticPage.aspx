<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="StatisticPage.aspx.cs" Inherits="WebApplicationRooms.StatisticPage" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hotel Statistics | Admin Dashboard</title>
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
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background: var(--light);
            padding: 20px;
            min-height: 100vh;
            color: var(--text);
        }

        .container {
            max-width: 1400px;
            margin: 0 auto;
        }

        .header {
            background: var(--primary);
            color: white;
            padding: 25px 30px;
            border-radius: 8px;
            margin-bottom: 25px;
            box-shadow: var(--shadow);
            border: 1px solid var(--primary);
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

        .navigation {
            display: flex;
            gap: 12px;
            margin-bottom: 25px;
            flex-wrap: wrap;
        }

        .nav-link {
            padding: 12px 20px;
            background: white;
            border-radius: 4px;
            text-decoration: none;
            color: var(--dark);
            font-weight: 500;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0,0,0,0.1);
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .nav-link:hover {
            background: var(--secondary);
            color: white;
            transform: translateY(-1px);
            box-shadow: 0 2px 8px rgba(58, 97, 134, 0.3);
        }

        .logout {
            background: var(--danger);
            color: white;
            border: 1px solid #b22222;
            margin-left: auto;
        }

        .logout:hover {
            background: #b22222;
        }

        .filters {
            background: white;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
        }

        .filter-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            align-items: end;
        }

        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .filter-group label {
            font-weight: 500;
            color: var(--dark);
            font-size: 14px;
        }

        select, input[type="date"] {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--border);
            border-radius: 4px;
            font-size: 14px;
            color: var(--text);
            background: #fff;
            transition: all 0.2s ease;
        }

        select:focus, input[type="date"]:focus {
            outline: none;
            border-color: var(--secondary);
            box-shadow: 0 0 0 2px rgba(58, 97, 134, 0.1);
        }

        .btn {
            padding: 12px 28px;
            border: none;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            text-decoration: none;
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

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: var(--shadow);
            text-align: center;
            transition: var(--transition);
            border: 1px solid var(--border);
            border-left: 4px solid var(--secondary);
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        .stat-icon {
            font-size: 32px;
            margin-bottom: 15px;
        }

        .stat-value {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 5px;
            color: var(--dark);
        }

        .stat-label {
            color: var(--text-light);
            font-size: 14px;
            text-transform: uppercase;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .stat-change {
            font-size: 12px;
            font-weight: 500;
        }

        .positive {
            color: var(--success);
        }

        .negative {
            color: var(--danger);
        }

       

        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 20px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 10px;
        }

      

        .activity-item:hover {
            background: var(--light);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .recent-activities {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: var(--shadow);
            margin-bottom: 25px;
        }

        .activities-list {
            margin-top: 15px;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 15px;
            border-bottom: 1px solid #eee;
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 16px;
        }

        .activity-content {
            flex: 1;
        }

        .activity-title {
            font-weight: 500;
            margin-bottom: 2px;
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
            background: #d4edda;
            color: #155724;
            border-color: #c3e6cb;
        }

        .message-error {
            background: #f8d7da;
            color: #721c24;
            border-color: #f5c6cb;
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 8px;
            color: white;
            font-weight: 500;
        }

        @media (max-width: 768px) {
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .filter-grid {
                grid-template-columns: 1fr;
            }
            
            .navigation {
                flex-direction: column;
            }
            
            .logout {
                margin-left: 0;
            }
            
            .btn {
                width: 100%;
            }
        }

        /* Custom stat card colors */
        .stat-card-revenue {
            border-left-color: var(--success);
        }

        .stat-card-revenue .stat-icon {
            color: var(--success);
        }

        .stat-card-guests {
            border-left-color: var(--warning);
        }

        .stat-card-guests .stat-icon {
            color: var(--warning);
        }

        .stat-card-bookings {
            border-left-color: var(--secondary);
        }

        .stat-card-bookings .stat-icon {
            color: var(--secondary);
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <!-- Header Section -->
            <div class="header">
                <div>
                    <h1>Hotel Statistics Dashboard</h1>
                    <p>Comprehensive overview of hotel performance and bookings</p>
                </div>
                <div class="user-info">
                    <span>👤</span>
                    <asp:Label ID="lblAdminName" runat="server" Text="Admin"></asp:Label>
                </div>
            </div>

            <!-- Navigation -->
            <div class="navigation">
                <a href="BookingsDashboard.aspx" class="nav-link">← Back to Dashboard</a>
            </div>

            <!-- Filters -->
            <div class="filters">
                <div class="filter-grid">
                    <div class="filter-group">
                        <label for="ddlTimeRange">Time Range</label>
                        <asp:DropDownList ID="ddlTimeRange" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterStatistics">
                            <asp:ListItem Value="7" Text="Last 7 Days"></asp:ListItem>
                            <asp:ListItem Value="30" Text="Last 30 Days" Selected="True"></asp:ListItem>
                            <asp:ListItem Value="90" Text="Last 90 Days"></asp:ListItem>
                            <asp:ListItem Value="365" Text="Last Year"></asp:ListItem>
                            <asp:ListItem Value="0" Text="Custom Range"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    
                    <asp:Panel ID="pnlCustomRange" runat="server" Visible="false">
                        <div class="filter-group">
                            <label for="txtStartDate">Start Date</label>
                            <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date"></asp:TextBox>
                        </div>
                        <div class="filter-group">
                            <label for="txtEndDate">End Date</label>
                            <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date"></asp:TextBox>
                        </div>
                    </asp:Panel>
                    
                    <div class="filter-group">
                        <label>&nbsp;</label>
                        <asp:Button ID="btnApplyFilters" runat="server" Text="Apply Filters" 
                            CssClass="btn btn-primary" OnClick="FilterStatistics" />
                    </div>
                </div>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card stat-card-bookings">
                    <div class="stat-icon">🛏️</div>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalBookings" runat="server" Text="0"></asp:Label>
                    </div>
                    <div class="stat-label">Total Bookings</div>
                    <div class="stat-change">
                        <asp:Label ID="lblBookingChange" runat="server" Text="0%"></asp:Label> from previous period
                    </div>
                </div>

                <div class="stat-card stat-card-revenue">
                    <div class="stat-icon">💰</div>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalRevenue" runat="server" Text="0 SAR"></asp:Label>
                    </div>
                    <div class="stat-label">Total Revenue</div>
                    <div class="stat-change">
                        <asp:Label ID="lblRevenueChange" runat="server" Text="0%"></asp:Label> from previous period
                    </div>
                </div>

                <div class="stat-card stat-card-guests">
                    <div class="stat-icon">👥</div>
                    <div class="stat-value">
                        <asp:Label ID="lblTotalGuests" runat="server" Text="0"></asp:Label>
                    </div>
                    <div class="stat-label">Total Guests</div>
                    <div class="stat-change">
                        <asp:Label ID="lblGuestsChange" runat="server" Text="0%"></asp:Label> from previous period
                    </div>
                </div>
            </div>

            <!-- Recent Activities -->
            <div class="recent-activities">
                <h3><i class="fas fa-history"></i> Recent Activities</h3>
                <div class="activities-list">
                    <asp:Repeater ID="rptRecentActivities" runat="server" OnItemDataBound="rptRecentActivities_ItemDataBound">
                        <ItemTemplate>
                            <div class="activity-item">
                                <div class="activity-icon" id="activityIcon" runat="server">
                                    <i class="fas" id="activityIconClass" runat="server"></i>
                                </div>
                                <div class="activity-content">
                                    <div class="activity-title"><%# Eval("Description") %></div>
                                    <div class="activity-time"><%# Eval("Timestamp", "{0:MMM dd, yyyy HH:mm}") %></div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>

            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
        </div>
    </form>
</body>
</html>