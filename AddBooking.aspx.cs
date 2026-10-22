using System;
using System.Web.UI;
using WebApplicationRooms.Models;

namespace WebApplicationRooms
{
    public partial class AddBooking : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                // Set default dates
                txtCheckInDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
                txtCheckOutDate.Text = DateTime.Now.AddDays(2).ToString("yyyy-MM-dd");
                txtNumberOfGuests.Text = "1";
                LoadAvailableRooms();
            }
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

        protected void CalculatePrice(object sender, EventArgs e)
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

                if (checkOut < checkIn)
                {
                    ShowMessage("Check-out date must be after check-in date", "error");
                    pnlPrice.Visible = false;
                    return;
                }

                if (checkIn < DateTime.Today)
                {
                    ShowMessage("Check-in date cannot be in the past", "error");
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
                if (selectedRoom == null)
                {
                    ShowMessage("Selected room not found", "error");
                    pnlPrice.Visible = false;
                    return;
                }

                decimal basePrice = DataManagement.CalculatePrice(selectedRoom, checkIn, checkOut);
                decimal totalPrice = basePrice;

                // Add additional services
                if (chkSpa.Checked)
                {
                    totalPrice += 50;
                }
                if (chkMeals.Checked)
                {
                    int days = (checkOut - checkIn).Days;
                    totalPrice += 30 * days; // 30 SAR per meal
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

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                // Validate data
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
                if (checkIn < DateTime.Today)
                {
                    ShowMessage("Check-in date cannot be in the past", "error");
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
                if (selectedRoom == null)
                {
                    ShowMessage("Selected room not found", "error");
                    return;
                }
                if (int.Parse(txtNumberOfGuests.Text) > selectedRoom.Capacity)
                {
                    ShowMessage("Number of guests exceeds the capacity of the selected room", "error");
                    return;
                }
                // Check room availability
                if (!DataManagement.IsRoomAvailable(roomId, checkIn, checkOut))
                {
                    ShowMessage("Selected room is not available for the specified dates", "error");
                    return;
                }

                // Create new booking
                Customer customer = new Customer(name: txtGuestName.Text.Trim(), email: txtGuestEmail.Text.Trim(), phone: txtGuestPhone.Text.Trim());

                Booking newBooking = new Booking
                {
                    Customer = customer,
                    CheckInDate = checkIn,
                    CheckOutDate = checkOut,
                    Room = selectedRoom,
                    Status = "Pending",
                    PaymentStatus = "Unpaid",
                    TotalPrice = decimal.Parse(lblTotalPrice.Text),
                    AdditionalServices = GetAdditionalServices(),
                    SpecialRequests = txtSpecialRequests.Text.Trim(),
                    AdminComments = "",
                    BookingDate = DateTime.Now,
                    UserId = ((User)Session["User"]).Id,
                    GuestCount = int.Parse(txtNumberOfGuests.Text),
                    CreatedAt = DateTime.Now

                };

                DataManagement.AddBooking(newBooking);
                ShowMessage("Booking created successfully! Booking ID: " + newBooking.Id, "success");
                Response.Redirect($"PaymentPage.aspx?bookingId={newBooking.Id}");

                // Reset form
                ClearForm();
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving booking: " + ex.Message, "error");
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

        private void ClearForm()
        {
            txtGuestName.Text = "";
            txtGuestEmail.Text = "";
            txtGuestPhone.Text = "";
            txtCheckInDate.Text = DateTime.Now.AddDays(1).ToString("yyyy-MM-dd");
            txtCheckOutDate.Text = DateTime.Now.AddDays(2).ToString("yyyy-MM-dd");
            ddlRoom.SelectedIndex = 0;
            chkSpa.Checked = false;
            chkMeals.Checked = false;
            chkTransportation.Checked = false;
            txtSpecialRequests.Text = "";
            pnlPrice.Visible = false;
            txtNumberOfGuests.Text = "1";
        }

        private void ShowMessage(string message, string type)
        {
            lblMessage.Text = message;
            lblMessage.Visible = true;

            if (type == "error")
            {
                lblMessage.CssClass = "message message-error";
            }
            else
            {
                lblMessage.CssClass = "message message-success";
            }
        }

       


    }
}