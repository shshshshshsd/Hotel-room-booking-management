<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Rooms.aspx.cs" Inherits="WebApplicationRooms.Rooms" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Room Management | Hotel Management System</title>
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
        
        .form-container {
            background: white;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: var(--shadow);
            border: 1px solid var(--border);
        }
        
        .form-title {
            font-size: 18px;
            font-weight: 600;
            color: var(--dark);
            margin-bottom: 25px;
            padding-bottom: 12px;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .form-group {
            margin-bottom: 20px;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
            color: var(--dark);
            font-size: 14px;
        }
        
        .form-group-full {
            grid-column: 1 / -1;
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
        
        .checkbox-group {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-top: 20px;
        }
        
        .checkbox-group input[type="checkbox"] {
            width: 18px;
            height: 18px;
        }
        
        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 25px;
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
        
        .table-container {
            background: white;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: var(--shadow);
            margin-bottom: 25px;
            border: 1px solid var(--border);
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }
        
        th {
            background: var(--primary);
            color: white;
            padding: 15px 12px;
            text-align: left;
            font-weight: 600;
            font-size: 14px;
            border-bottom: 1px solid var(--primary);
        }
        
        td {
            padding: 12px;
            border-bottom: 1px solid var(--border);
            font-size: 14px;
        }
        
        tr:hover {
            background-color: var(--light);
        }
        
        .status-badge {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-available {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .status-unavailable {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .type-badge {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .type-standard {
            background: #e8f4fc;
            color: #0c5460;
            border: 1px solid #b8daff;
        }
        
        .type-deluxe {
            background: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        
        .type-suite {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .type-family {
            background: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .type-royal {
            background: #f5c6cb;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        
        .type-presidential {
            background: #856404;
            color: white;
            border: 1px solid #bee5eb;
        }
        
        .action-buttons {
            display: flex;
            gap: 8px;
        }
        
        .action-btn {
            padding: 6px 12px;
            border: none;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 4px;
        }
        
        .btn-edit {
            background: var(--secondary);
            color: white;
            border: 1px solid #2a4a6b;
        }
        
        .btn-enable {
            background: var(--success);
            color: white;
            border: 1px solid #1e7e34;
        }
        
        .btn-disable {
            background: var(--warning);
            color: #212529;
            border: 1px solid #e0a800;
        }
        
        .action-btn:hover {
            transform: translateY(-1px);
            opacity: 0.9;
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
        
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: var(--text-light);
        }
        
        .empty-state i {
            font-size: 48px;
            margin-bottom: 15px;
            color: #bdc3c7;
        }
        
        .empty-state h3 {
            font-size: 18px;
            margin-bottom: 10px;
            color: var(--dark);
        }
        
        .empty-state p {
            font-size: 14px;
            color: var(--text-light);
        }
        
        @media (max-width: 768px) {
            .navigation {
                flex-direction: column;
            }
            
            .logout {
                margin-left: 0;
            }
            
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .form-actions {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
            }
            
            .table-container {
                border-radius: 0;
                margin: 0 -20px;
            }
        }
        
        .amenities-cell {
            max-width: 200px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .price-cell {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            color: var(--success);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container">
            <div class="header">
                <h1>Room Management</h1>
                <p>Manage hotel rooms, availability, and pricing</p>
            </div>

            <div class="navigation">
                <a href="BookingsDashboard.aspx" class="btn btn-secondary">← Back to Dashboard</a>
            </div>

            <div class="form-container">
                <div class="form-title">➕ Add/Edit Room</div>
                <asp:HiddenField ID="hfRoomId" runat="server" />
                
                <div class="form-grid">
                    <div class="form-group">
                        <label for="txtRoomName" class="required">Room Name</label>
                        <asp:TextBox ID="txtRoomName" runat="server" placeholder="e.g., Ocean View Suite" required></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="ddlRoomType" class="required">Room Type</label>
                        <asp:DropDownList ID="ddlRoomType" runat="server" required>
                            <asp:ListItem Value="Standard" Text="Standard"></asp:ListItem>
                            <asp:ListItem Value="Deluxe" Text="Deluxe"></asp:ListItem>
                            <asp:ListItem Value="Suite" Text="Suite"></asp:ListItem>
                            <asp:ListItem Value="Family" Text="Family"></asp:ListItem>
                            <asp:ListItem Value="Presidential" Text="Presidential"></asp:ListItem>
                            <asp:ListItem Value="Penthouse" Text="Penthouse"></asp:ListItem>
                            <asp:ListItem Value="Royal" Text="Royal"></asp:ListItem>
                           
                        </asp:DropDownList>
                    </div>

                    <div class="form-group">
                        <label for="txtBasePrice" class="required">Base Price (SAR)</label>
                        <asp:TextBox ID="txtBasePrice" runat="server" TextMode="Number" step="0.01" placeholder="0.00" required></asp:TextBox>
                    </div>

                    <div class="form-group">
                        <label for="txtCapacity" class="required">Capacity</label>
                        <asp:TextBox ID="txtCapacity" runat="server" TextMode="Number" placeholder="Number of people" required></asp:TextBox>
                    </div>

                    <div class="form-group form-group-full">
                        <label for="txtAmenities">Amenities</label>
                        <asp:TextBox ID="txtAmenities" runat="server" TextMode="MultiLine" Rows="3" 
                            placeholder="List room amenities separated by commas (e.g., WiFi, TV, Mini Bar, Air Conditioning)"></asp:TextBox>
                    </div>
                </div>

                <div class="checkbox-group">
                    <asp:CheckBox ID="chkIsAvailable" runat="server" Checked="true" />
                    <label for="chkIsAvailable">Room is available for booking</label>
                </div>

                <div class="form-actions">
                    <asp:Button ID="btnSave" runat="server" Text="Save Room" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                </div>
            </div>

            <div class="table-container">
                <asp:GridView ID="gvRooms" runat="server" AutoGenerateColumns="false" 
                    OnRowCommand="gvRooms_RowCommand" OnRowEditing="gvRooms_RowEditing" DataKeyNames="Id"
                    HeaderStyle-CssClass="grid-header"
                    RowStyle-CssClass="grid-row"
                    AlternatingRowStyle-CssClass="grid-alt-row">
                    <Columns>
                        <asp:BoundField DataField="Id" HeaderText="Room ID" />
                        <asp:BoundField DataField="Name" HeaderText="Room Name" />
                        <asp:TemplateField HeaderText="Type">
                            <ItemTemplate>
                                <span class='type-badge type-<%# Eval("Type").ToString().ToLower() %>'>
                                    <%# Eval("Type") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Base Price">
                            <ItemTemplate>
                                <span class="price-cell">
                                    <%# "SAR " + Eval("BasePrice") %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="Capacity" HeaderText="Capacity" />
                        <asp:TemplateField HeaderText="Amenities">
                            <ItemTemplate>
                                <div class="amenities-cell" title='<%# Eval("Amenities") %>'>
                                    <%# Eval("Amenities") %>
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <span class='status-badge status-<%# (bool)Eval("IsAvailable") ? "available" : "unavailable" %>'>
                                    <%# (bool)Eval("IsAvailable") ? "Available" : "Unavailable" %>
                                </span>
                            </ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Actions">
                            <ItemTemplate>
                                <div class="action-buttons">
                                    <asp:LinkButton ID="btnEdit" runat="server" Text="Edit" CommandName="Edit" 
                                        CommandArgument='<%# Eval("Id") %>' CssClass="action-btn btn-edit" />
                                    <asp:LinkButton ID="btnToggle" runat="server" 
                                        Text='<%# (bool)Eval("IsAvailable") ? "Disable" : "Enable" %>' 
                                        CommandName="Toggle" CommandArgument='<%# Eval("Id") %>'
                                        CssClass='action-btn <%# (bool)Eval("IsAvailable") ? "btn-disable" : "btn-enable" %>' />
                                </div>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                    <EmptyDataTemplate>
                        <div class="empty-state">
                            <div>🚪</div>
                            <h3>No Rooms Found</h3>
                            <p>Get started by adding your first room to the system.</p>
                        </div>
                    </EmptyDataTemplate>
                </asp:GridView>
            </div>

            <asp:Label ID="lblMessage" runat="server" Visible="false" CssClass="message"></asp:Label>
        </div>
    </form>
</body>
</html>