<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="BookingsList.aspx.cs" Inherits="WebApplicationRooms.BookingsList" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bookings | Hotel System</title>
    <style>
        :root {
             --primary: #89253e;
            --secondary: #3a6186;
            --success: #48bb78;
            --warning: #ed8936;
            --danger: #f56565;
            --light: #eceeef;
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
            background: var(--light)
            min-height: 100vh;
            color: var(--dark);
        }
        
        .container {
            max-width: 1400px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            background: white;
            padding: 25px;
            margin-bottom: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }
        
        .header h1 {
            color: var(--primary);
            font-size: 28px;
        }
        
        .back-btn {
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Filters Section */
        .filters-section {
            background: white;
            padding: 20px;
            margin-bottom: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }

        .filters-section h3 {
            color: var(--primary);
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
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
            font-weight: 600;
            color: var(--dark);
            font-size: 14px;
        }

        select {
            padding: 10px 12px;
            border: 2px solid var(--border);
            border-radius: 8px;
            font-size: 14px;
            background: white;
            transition: all 0.3s ease;
        }

        select:focus {
            outline: none;
            border-color: var(--primary);
        }

        .btn-apply {
            padding: 10px 20px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .btn-apply:hover {
            background: var(--secondary);
            transform: translateY(-2px);
        }
        
        .bookings-container {
            display: grid;
            gap: 20px;
        }
        
        .booking-card {
            background: white;
            padding: 25px;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            border-left: 5px solid var(--primary);
            transition: transform 0.3s ease;
        }

        .booking-card:hover {
            transform: translateY(-3px);
        }
        
        .booking-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            flex-wrap: wrap;
            gap: 10px;
        }
        
        .booking-id {
            font-size: 1.2rem;
            font-weight: bold;
            color: var(--primary);
        }
        
        .status-badge {
            padding: 6px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-pending { background: #fff3cd; color: #856404; }
        .status-confirmed { background: #d4edda; color: #155724; }
        .status-checked-in { background: #cce7ff; color: #004085; }
        .status-checked-out { background: #e2e3e5; color: #383d41; }
        .status-cancelled { background: #f8d7da; color: #721c24; }
        
        .booking-details {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .detail-item {
            display: flex;
            flex-direction: column;
            gap: 5px;
        }
        
        .detail-label {
            font-size: 12px;
            color: #718096;
            text-transform: uppercase;
            font-weight: 600;
        }
        
        .detail-value {
            font-weight: 500;
        }
        
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        
        .action-btn {
            padding: 8px 15px;
            border: none;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 5px;
            transition: all 0.3s ease;
        }
        
        .btn-edit { background: var(--primary); color: white; }
        .btn-cancel { background: var(--danger); color: white; }
        .btn-checkin { background: var(--success); color: white; }
        .btn-checkout { background: var(--warning); color: white; }
        .btn-confirm { background: #6c757d; color: white; }
        .btn-primary { background: var(--secondary); color: white; border: 1px solid #2a4a6b; }
        .btn-send-check-out-remender{background: #2d3748; color: white;}
        .btn-send-check-in-remender{background: #00550f; color: white;}

        .action-btn:hover {
            transform: translateY(-2px);
            opacity: 0.9;
        }
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #718096;
        }
        
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #cbd5e0;
        }

        /* Toast Notifications */
        .toast-container {
            position: fixed;
            top: 20px;
            right: 20px;
            z-index: 1000;
            max-width: 400px;
        }

        .toast {
            background: white;
            padding: 15px 20px;
            margin-bottom: 10px;
            border-radius: 8px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            border-left: 4px solid var(--primary);
            display: flex;
            align-items: center;
            gap: 12px;
            transform: translateX(400px);
            transition: transform 0.3s ease;
            opacity: 0;
        }

        .toast.show {
            transform: translateX(0);
            opacity: 1;
        }

        .toast.success {
            border-left-color: var(--success);
        }

        .toast.warning {
            border-left-color: var(--warning);
        }

        .toast.error {
            border-left-color: var(--danger);
        }

        .toast.info {
            border-left-color: var(--primary);
        }

        .toast-icon {
            font-size: 20px;
        }

        .toast.success .toast-icon { color: var(--success); }
        .toast.warning .toast-icon { color: var(--warning); }
        .toast.error .toast-icon { color: var(--danger); }
        .toast.info .toast-icon { color: var(--primary); }

        .toast-content {
            flex: 1;
        }

        .toast-title {
            font-weight: 600;
            margin-bottom: 4px;
        }

        .toast-message {
            font-size: 14px;
            color: #718096;
        }

        .toast-close {
            background: none;
            border: none;
            font-size: 16px;
            cursor: pointer;
            color: #718096;
            padding: 4px;
        }
        
        @media (max-width: 768px) {
            .header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .filter-grid {
                grid-template-columns: 1fr;
            }
            
            .booking-header {
                flex-direction: column;
                align-items: flex-start;
            }
            
            .booking-details {
                grid-template-columns: 1fr;
            }
            
            .action-buttons {
                flex-direction: column;
            }
            
            .action-btn {
                width: 100%;
                justify-content: center;
            }

            .toast-container {
                left: 20px;
                right: 20px;
                max-width: none;
            }
        }
        
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <form id="form1" runat="server">
         <!-- Toast Container -->
        <div class="toast-container" id="toastContainer" runat="server"></div>

        <div class="container">
            <div class="header">
                <h1>All Bookings</h1>
                <a href="BookingsDashboard.aspx" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Dashboard
                </a>
            </div>

            <!-- Filters Section -->
            <div class="filters-section">
                <h3><i class="fas fa-filter"></i> Filter Bookings</h3>
                <div class="filter-grid">
                    <div class="filter-group">
                        <label for="ddlStatusFilter">Booking Status</label>
                        <asp:DropDownList ID="ddlStatusFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterBookings">
                            <asp:ListItem Value="" Text="All Statuses"></asp:ListItem>
                            <asp:ListItem Value="Pending" Text="Pending"></asp:ListItem>
                            <asp:ListItem Value="Confirmed" Text="Confirmed"></asp:ListItem>
                            <asp:ListItem Value="Checked-In" Text="Checked-In"></asp:ListItem>
                            <asp:ListItem Value="Checked-Out" Text="Checked-Out"></asp:ListItem>
                            <asp:ListItem Value="Cancelled" Text="Cancelled"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label for="ddlRoomTypeFilter">Room Type</label>
                        <asp:DropDownList ID="ddlRoomTypeFilter" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterBookings">
                            <asp:ListItem Value="" Text="All Room Types"></asp:ListItem>
                            <asp:ListItem Value="Standard" Text="Standard"></asp:ListItem>
                            <asp:ListItem Value="Deluxe" Text="Deluxe"></asp:ListItem>
                            <asp:ListItem Value="Suite" Text="Suite"></asp:ListItem>
                            <asp:ListItem Value="Family" Text="Family"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <!-- Sorting Dropdown -->
                    <div class="filter-group">
                        <label for="ddlSortBy">Sort By</label>
                        <asp:DropDownList ID="ddlSortBy" runat="server" AutoPostBack="true" OnSelectedIndexChanged="FilterBookings">
                            <asp:ListItem Value="" Text="Default Order"></asp:ListItem>
                            <asp:ListItem Value="CheckInAsc" Text="Check-In (Oldest First)"></asp:ListItem>
                            <asp:ListItem Value="CheckInDesc" Text="Check-In (Newest First)"></asp:ListItem>
                            <asp:ListItem Value="CheckOutAsc" Text="Check-Out (Oldest First)"></asp:ListItem>
                            <asp:ListItem Value="CheckOutDesc" Text="Check-Out (Newest First)"></asp:ListItem>
                        </asp:DropDownList>
                    </div>

                    <div class="filter-group">
                        <label>&nbsp;</label>
                        <asp:Button ID="btnClearFilters" runat="server" Text="Clear Filters" 
                            CssClass="btn-apply" OnClick="ClearFilters" />
                    </div>
                </div>
            </div>

            <div class="bookings-container">
                <asp:Repeater ID="rptBookings" runat="server" OnItemCommand="rptBookings_ItemCommand">
                    <ItemTemplate>
                        <div class="booking-card">
                            <div class="booking-header">
                                <div class="booking-id">Booking #<%# Eval("Id") %></div>
                                <span class='status-badge status-<%# Eval("Status").ToString().ToLower() %>'>
                                    <%# GetStatusText(Eval("Status").ToString()) %>
                                </span>
                            </div>
                            
                            <div class="booking-details">
                                <div class="detail-item">
                                    <span class="detail-label">Guest Name</span>
                                    <span class="detail-value"><%# Eval("Customer.Name") %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Email</span>
                                    <span class="detail-value"><%# Eval("Customer.Email") %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Check-In</span>
                                    <span class="detail-value"><%# Convert.ToDateTime(Eval("CheckInDate")).ToString("MMM dd, yyyy") %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Check-Out</span>
                                    <span class="detail-value"><%# Convert.ToDateTime(Eval("CheckOutDate")).ToString("MMM dd, yyyy") %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Room</span>
                                    <span class="detail-value"><%# GetRoomName(Eval("Room.Id").ToString()) %></span>
                                </div>
                                <div class="detail-item">
                                    <span class="detail-label">Number of Guests</span>
                                    <span class="detail-value"><%# Eval("GuestCount").ToString() %></span>
                                </div>

                                <div class="detail-item">
                                    <span class="detail-label">Total Price</span>
                                    <span class="detail-value">SAR <%# Convert.ToDecimal(Eval("TotalPrice")).ToString() %></span>
                                </div>
                                  <div class="detail-item">
                                      <asp:Panel ID="pnlCancelPenalty" 
                                    Visible='<%# Eval("Status").ToString() == "Cancelled" %>' 
                                    runat="server" CssClass="detail-value">
                                     <span class="detail-label">Cancel Penalty</span>
                                          <br />
                                    <span class="detail-value">SAR <%# Convert.ToDecimal(Eval("CancelPenalty")).ToString() %></span>
                                </asp:Panel>
                              
                                  </div>     
                                 <div class="detail-item">
                                      <asp:Panel ID="PnlPaymentStatus" 
                                    runat="server" CssClass="detail-value">
                                     <span class="detail-label">Payment Status</span>
                                          <br />
                                    <span class="detail-value"><%#Eval("PaymentStatus").ToString() %></span>
                                </asp:Panel>
                              
                                  </div>  
                                
                            </div>
                            
                            <div class="action-buttons">
                                <asp:LinkButton ID="btnEdit" 
                                    Visible='<%# Eval("Status").ToString() != "Cancelled" && Eval("Status").ToString() != "Checked-Out" && Eval("Status").ToString() != "Checked-In" %>' 
                                    runat="server" CommandName="Edit" CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-edit">
                                    <i class="fas fa-edit"></i> Edit
                                </asp:LinkButton>
                                
                                <asp:LinkButton ID="btnCancel" 
                                    OnClientClick="return confirm('Are you sure you want to cancel this booking?');"
                                    Visible='<%# Eval("Status").ToString() != "Cancelled" && Eval("Status").ToString() != "Checked-Out" && Eval("Status").ToString() != "Checked-In" %>' 
                                    runat="server" CommandName="Cancel" CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-cancel">
                                    <i class="fas fa-times"></i> Cancel
                                </asp:LinkButton>
                                
                                <asp:LinkButton ID="btnCheckIn" 
                                    Visible='<%# GetCurrentUser().Role == "Admin" && Eval("Status").ToString() != "Checked-Out" && Eval("Status").ToString() != "Cancelled" && Eval("Status").ToString() != "Checked-In" %>' 
                                    runat="server" CommandName="CheckIn" CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-checkin">
                                    <i class="fas fa-sign-in-alt"></i> Check In
                                </asp:LinkButton>
                                
                                <asp:LinkButton ID="btnCheckOut" 
                                    Visible='<%# GetCurrentUser().Role == "Admin" && Eval("Status").ToString() != "Checked-Out" && Eval("Status").ToString() != "Cancelled" %>' 
                                    runat="server" CommandName="CheckOut" CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-checkout">
                                    <i class="fas fa-sign-out-alt"></i> Check Out
                                </asp:LinkButton>
                                
                                <asp:LinkButton ID="btnSendConfirmation" 
                                    Visible='<%# GetCurrentUser().Role == "Admin" && Eval("Status").ToString() != "Checked-Out" && Eval("Status").ToString() != "Cancelled" && Eval("Status").ToString() != "Confirmed" && Eval("Status").ToString() != "Checked-In" %>' 
                                    runat="server" CommandName="confirm" CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-confirm">
                                    <i class="fas fa-envelope"></i> Confirm
                                </asp:LinkButton>

                                 <asp:LinkButton ID="btnSendCheckInRemender" 
                                    Visible='<%# GetCurrentUser().Role == "Admin" && Eval("Status").ToString() != "Checked-Out" && Eval("Status").ToString() != "Cancelled" && Eval("Status").ToString() != "Checked-In" && Eval("Status").ToString() != "Pending"  %>' 
                                    runat="server" CommandName="sendCheckInRemender" CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-send-check-in-remender">
                                    <i class="fas fa-envelope"></i> Send Check in Reminder
                                </asp:LinkButton>
                                 <asp:LinkButton ID="btnSendCheckOutRemender" 
                                    Visible='<%# GetCurrentUser().Role == "Admin" && Eval("Status").ToString() != "Checked-Out" && Eval("Status").ToString() != "Cancelled" && Eval("Status").ToString() != "Confirmed" && Eval("Status").ToString() != "Pending" %>' 
                                    runat="server" CommandName="sendCheckOutRemender" CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-send-check-out-remender">
                                    <i class="fas fa-envelope"></i> Send Check out Reminder
                                </asp:LinkButton>

                              <asp:LinkButton ID="btnPay" 
                                    Visible='<%# (Eval("PaymentStatus").ToString() == "Unpaid") && Eval("Status").ToString() != "Cancelled" && GetCurrentUser().Role == "Guest" %>' 
                                      runat="server" CommandName="Pay" CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-primary">
                                 <i class="fas fa-credit-card"></i> Pay Now

                              </asp:LinkButton>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                
                <asp:Panel ID="pnlNoBookings" runat="server" Visible="false">
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <h3>No Bookings Found</h3>
                        <p>There are no bookings matching your current filters.</p>
                        <a href="AddBooking.aspx" class="action-btn btn-edit" style="margin-top: 15px;">
                            <i class="fas fa-plus"></i> Create First Booking
                        </a>
                    </div>
                </asp:Panel>
            </div>
        </div>

        

        <!-- Hidden field to store toast messages -->
        <asp:HiddenField ID="hdnToastMessage" runat="server" />
        <asp:HiddenField ID="hdnToastType" runat="server" />

        <script type="text/javascript">
           
            // Toast notification system
            function showToast(message, type = 'info') {
                const toastContainer = document.getElementById('toastContainer');
                const toastId = 'toast-' + Date.now();
                
                const icons = {
                    success: 'fas fa-check-circle',
                    warning: 'fas fa-exclamation-triangle',
                    error: 'fas fa-times-circle',
                    info: 'fas fa-info-circle'
                };

                const toast = document.createElement('div');
                toast.className = `toast ${type}`;
                toast.id = toastId;
                toast.innerHTML = `
                    <i class="toast-icon ${icons[type]}"></i>
                    <div class="toast-content">
                        <div class="toast-title">${getToastTitle(type)}</div>
                        <div class="toast-message">${message}</div>
                    </div>
                    <button class="toast-close" onclick="closeToast('${toastId}')">
                        <i class="fas fa-times"></i>
                    </button>
                `;

                toastContainer.appendChild(toast);

                // Show toast with animation
                setTimeout(() => {
                    toast.classList.add('show');
                }, 100);

                // Auto remove after 5 seconds
                setTimeout(() => {
                    closeToast(toastId);
                }, 5000);
            }

            function getToastTitle(type) {
                const titles = {
                    success: 'Success!',
                    warning: 'Warning!',
                    error: 'Error!',
                    info: 'Information'
                };
                return titles[type] || 'Notification';
            }

            function closeToast(toastId) {
                const toast = document.getElementById(toastId);
                if (toast) {
                    toast.classList.remove('show');
                    setTimeout(() => {
                        if (toast.parentNode) {
                            toast.parentNode.removeChild(toast);
                        }
                    }, 300);
                }
            }

            // Check for server-side toast messages
            function checkForServerToast() {
                const message = document.getElementById('<%= hdnToastMessage.ClientID %>').value;
                const type = document.getElementById('<%= hdnToastType.ClientID %>').value;
                
                if (message) {
                    showToast(message, type);
                    // Clear the hidden fields
                    document.getElementById('<%= hdnToastMessage.ClientID %>').value = '';
                    document.getElementById('<%= hdnToastType.ClientID %>').value = '';
                }
            }

            // Initialize on page load
            document.addEventListener('DOMContentLoaded', function () {
                checkForServerToast();
            });
        </script>
    </form>
</body>
</html>