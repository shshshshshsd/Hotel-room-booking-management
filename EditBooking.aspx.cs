using System;
using System.Web.UI;
using WebApplicationRooms.Models;

namespace WebApplicationRooms
{
    public partial class EditBooking : Page
    {
       

        private Booking currentBooking
        {
            get
            {
                if (ViewState["CurrentBooking"] != null)
                {
                    return (Booking)ViewState["CurrentBooking"];
                }
                return null;
            }
            set
            {
                ViewState["CurrentBooking"] = value;
            }
        }

        

        protected void Page_Load(object sender, EventArgs e)
        {

            User currentUser = (User)Session["User"];
            if (currentUser == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }
           ddlStatus.Visible = currentUser.Role == "Admin";
           txtAdminComments.Visible = currentUser.Role == "Admin";

            if (!IsPostBack)
            {
                LoadAvailableRooms();
                LoadBooking();
                
            }
        }

        private void LoadBooking()
        {
            string bookingIdStr = Request.QueryString["id"];
            if (string.IsNullOrEmpty(bookingIdStr) || !int.TryParse(bookingIdStr, out int bookingId))
            {
                ShowMessage("Invalid booking ID", "error");
                return;
            }

            currentBooking = GetBookingById(bookingId);
            if (currentBooking == null)
            {
                ShowMessage("Booking not found", "error");
                return;
            }

            // Check if user has permission to edit this booking
            User currentUser = (User)Session["User"];
            if (currentUser.Role == "Guest" && currentBooking.UserId != currentUser.Id)
            {
                ShowMessage("You don't have permission to edit this booking", "error");
                return;
            }

            // Load booking data into form
            txtGuestName.Text = currentBooking.Customer.Name;
            txtGuestEmail.Text = currentBooking.Customer.Email;
            txtGuestPhone.Text = currentBooking.Customer.Phone;
            txtCheckInDate.Text = currentBooking.CheckInDate.ToString("yyyy-MM-dd");
            txtCheckOutDate.Text = currentBooking.CheckOutDate.ToString("yyyy-MM-dd");
            ddlRoom.SelectedValue = currentBooking.Room.Id.ToString();
           
            if(currentUser.Role == "Guest")
            ddlStatus.SelectedValue = "Pending";
            else
            ddlStatus.SelectedValue = currentBooking.Status;

            txtSpecialRequests.Text = currentBooking.SpecialRequests;
            txtAdminComments.Text = currentBooking.AdminComments;
            txtNumberOfGuests.Text = currentBooking.GuestCount.ToString();



            // Load additional services
            if (!string.IsNullOrEmpty(currentBooking.AdditionalServices))
            {
                string services = currentBooking.AdditionalServices;
                chkSpa.Checked = services.Contains("Spa");
                chkMeals.Checked = services.Contains("Meals");
                chkTransportation.Checked = services.Contains("Transportation");
            }
               
            // Calculate and display current price
            CalculatePrice();
        }

        protected void CalculatePrice(object sender, EventArgs e)
        {
            CalculatePrice();
        }

        private void LoadAvailableRooms()
        {
            ddlRoom.Items.Clear();
            ddlRoom.Items.Add(new System.Web.UI.WebControls.ListItem("Select Available Room", ""));

            foreach (Room room in DataManagement.Rooms)
            {
                if (room.IsAvailable)
                {
                    string roomText = $"{room.Name} ({room.Type}) - {room.BasePrice} SAR/night - Capacity: {room.Capacity}";
                    ddlRoom.Items.Add(new System.Web.UI.WebControls.ListItem(roomText, room.Id.ToString()));
                }
            }
        }
       
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                // If currentBooking is null, try to reload it
                if (currentBooking == null)
                {
                    string bookingIdStr = Request.QueryString["id"];
                    if (string.IsNullOrEmpty(bookingIdStr) || !int.TryParse(bookingIdStr, out int bookingId))
                    {
                        ShowMessage("Invalid booking ID", "error");
                        return;
                    }
                    
                    currentBooking = GetBookingById(bookingId);
                    if (currentBooking == null)
                    {
                        ShowMessage("Booking not found", "error");
                        return;
                    }
                }

                // Validate required fields
                if (string.IsNullOrEmpty(txtGuestName.Text) || string.IsNullOrEmpty(txtGuestEmail.Text) || 
                    string.IsNullOrEmpty(txtGuestPhone.Text) || string.IsNullOrEmpty(txtCheckInDate.Text) || 
                    string.IsNullOrEmpty(txtCheckOutDate.Text) || string.IsNullOrEmpty(ddlRoom.SelectedValue))
                {
                    ShowMessage("Please fill all required fields", "error");
                    return;
                }

                DateTime checkIn = DateTime.Parse(txtCheckInDate.Text);
                DateTime checkOut = DateTime.Parse(txtCheckOutDate.Text);

                if (checkOut < checkIn)
                {
                    ShowMessage("Check-out date must be after check-in date", "error");
                    return;
                }

                
                // Get selected room
                int roomId = int.Parse(ddlRoom.SelectedValue);
                Room selectedRoom = null;
                for (int i = 0; i < DataManagement.Rooms.Count; i++)
                {
                    if (DataManagement.Rooms[i].Id == roomId)
                    {
                        selectedRoom = DataManagement.Rooms[i];
                        break;
                    }
                }

                if (int.Parse(txtNumberOfGuests.Text) > selectedRoom.Capacity)
                {
                    ShowMessage("Number of guests exceeds the capacity of the selected room", "error");
                    return;
                }

                // Check room availability
                if (!DataManagement.IsRoomAvailable(currentBooking, selectedRoom.Id, checkIn, checkOut))
                {
                    ShowMessage("Selected room is not available for the specified dates", "error");
                    return;
                }

               
                if (currentBooking != null)
                {
                    // Update booking in the actual list
                    currentBooking.Customer.Name = txtGuestName.Text.Trim();
                    currentBooking.Customer.Email = txtGuestEmail.Text.Trim();
                    currentBooking.Customer.Phone = txtGuestPhone.Text.Trim();
                    currentBooking.CheckInDate = checkIn;
                    currentBooking.CheckOutDate = checkOut;
                    currentBooking.Room = selectedRoom;
                    currentBooking.Status = ddlStatus.SelectedValue;
                    currentBooking.SpecialRequests = txtSpecialRequests.Text.Trim();
                    currentBooking.AdminComments = txtAdminComments.Text.Trim();
                    currentBooking.AdditionalServices = GetAdditionalServices();
                    currentBooking.GuestCount = int.Parse(txtNumberOfGuests.Text);
                    currentBooking.TotalPrice = decimal.Parse(lblTotalPrice.Text);

                    DataManagement.UpdateBooking(currentBooking);

                    ShowMessage("Booking updated successfully", "success");

                    // Redirect after a short delay to show success message
                ScriptManager.RegisterStartupScript(this, this.GetType(), "redirect",
                    "setTimeout(function() { window.location.href = 'BookingsList.aspx'; }, 1000);", true);
                }
                else
                {
                    ShowMessage("Booking not found in the system", "error");
                }
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating booking: " + ex.Message, "error");
            }
        }

        private void CalculatePrice()
        {
            if (string.IsNullOrEmpty(txtCheckInDate.Text) || string.IsNullOrEmpty(txtCheckOutDate.Text) || string.IsNullOrEmpty(ddlRoom.SelectedValue))
            {
                pnlPrice.Visible = false;
                return;
            }

            try
            {
                DateTime checkIn = DateTime.Parse(txtCheckInDate.Text);
                DateTime checkOut = DateTime.Parse(txtCheckOutDate.Text);

                if (checkOut <= checkIn)
                {
                    ShowMessage("Check-out date must be after check-in date", "error");
                    pnlPrice.Visible = false;
                    return;
                }
               

                // Get selected room
                int roomId = int.Parse(ddlRoom.SelectedValue);
                Room selectedRoom = null;
                for (int i = 0; i < DataManagement.Rooms.Count; i++)
                {
                    if (DataManagement.Rooms[i].Id == roomId)
                    {
                        selectedRoom = DataManagement.Rooms[i];
                        break;
                    }
                }
                // Check room availability (excluding current booking)
                if (!DataManagement.IsRoomAvailable(currentBooking, selectedRoom.Id, checkIn, checkOut))
                {
                    ShowMessage("Selected room is not available for the specified dates", "error");
                    pnlPrice.Visible = false;
                    return;
                }
                currentBooking.Room = selectedRoom;
                decimal basePrice = DataManagement.CalculatePrice(currentBooking.Room, checkIn, checkOut);
                decimal totalPrice = basePrice;

                // Add additional services
                if (chkSpa.Checked)
                {
                    totalPrice += 50;
                }
                if (chkMeals.Checked)
                {
                    int days = (checkOut - checkIn).Days;
                    totalPrice += 30 * days; // $30 per meal
                }
                if (chkTransportation.Checked)
                {
                    totalPrice += 25;
                }

                lblTotalPrice.Text = totalPrice.ToString("F2");
                pnlPrice.Visible = true;
                lblMessage.Visible = false;
            }
            catch (Exception ex)
            {
                ShowMessage("Error calculating price: " + ex.Message, "error");
                pnlPrice.Visible = false;
            }
        }

        private string GetAdditionalServices()
        {
            string services = "";
            if (chkSpa.Checked) services += "Spa, ";
            if (chkMeals.Checked) services += "Meals, ";
            if (chkTransportation.Checked) services += "Transportation, ";
            
            if (services.EndsWith(", "))
            {
                services = services.Substring(0, services.Length - 2);
            }
            
            return services;
        }

        private Booking GetBookingById(int bookingId)
        {
            for (int i = 0; i < DataManagement.Bookings.Count; i++)
            {
                if (DataManagement.Bookings[i].Id == bookingId)
                {
                    return DataManagement.Bookings[i];
                }
            }
            return null;
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;
            
            if (type == "error")
            {
                lblMessage.Style["color"] = "red";
                lblMessage.Style["font-weight"] = "bold";
            }
            else
            {
                lblMessage.Style["color"] = "green";
                lblMessage.Style["font-weight"] = "bold";
            }
        }

        protected void btnCancel_Click(object sender, EventArgs e)
        {
            Response.Redirect("BookingsList.aspx");
        }
       
    }
}
