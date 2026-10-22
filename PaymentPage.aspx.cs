using System;
using System.Web.UI;
using WebApplicationRooms.Models;

namespace WebApplicationRooms
{
    public partial class PaymentPage : Page
    {
        private Booking currentBooking;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadBookingData();
            }
        }

        private void LoadBookingData()
        {
            string bookingIdStr = Request.QueryString["bookingId"];
            if (string.IsNullOrEmpty(bookingIdStr) || !int.TryParse(bookingIdStr, out int bookingId))
            {
                ShowMessage("Invalid booking ID", "error");
                return;
            }

            // Find the booking
            currentBooking = DataManagement.Bookings.Find(b => b.Id == bookingId);
            if (currentBooking == null)
            {
                ShowMessage("Booking not found", "error");
                return;
            }

            // Verify user owns this booking
            User currentUser = (User)Session["User"];
            if (currentUser.Role == "Guest" && currentBooking.UserId != currentUser.Id)
            {
                ShowMessage("You don't have permission to access this booking", "error");
                return;
            }

            // Populate booking summary
            hfBookingId.Value = bookingId.ToString();
            lblRoomName.Text = currentBooking.Room.Name;
            lblCheckIn.Text = currentBooking.CheckInDate.ToString("MMM dd, yyyy");
            lblCheckOut.Text = currentBooking.CheckOutDate.ToString("MMM dd, yyyy");
            lblGuests.Text = currentBooking.GuestCount.ToString();
            lblTotalAmount.Text = currentBooking.TotalPrice.ToString("F2");
        }

        protected void btnProcessPayment_Click(object sender, EventArgs e)
        {
            try
            {
                if (!ValidatePaymentForm())
                    return;

                ProcessPayment("Card");
                ShowMessage("Payment processed successfully! Your booking is now confirmed.", "success");

                // Redirect to bookings list after 2 seconds
                ScriptManager.RegisterStartupScript(this, GetType(), "redirect",
                    "setTimeout(function() { window.location.href = 'BookingsList.aspx'; }, 2000);", true);
            }
            catch (Exception ex)
            {
                ShowMessage("Error processing payment: " + ex.Message, "error");
            }
        }

      

        private void ProcessPayment(string paymentMethod)
        {
            int bookingId = int.Parse(hfBookingId.Value);
            var booking = DataManagement.Bookings.Find(b => b.Id == bookingId);
            var user = (User)Session["User"];

            if (booking != null)
            {
                //simulate payment processing

                // Update booking status
                booking.PaymentStatus = paymentMethod == "Card" ? "Paid" : "Unpaid";
                booking.Status = "Confirmed"; // Confirm booking when payment is processed
                DataManagement.UpdateBooking(booking);

                // Send notification
                string message = paymentMethod == "Card"
                    ? $"\nPayment of {booking.TotalPrice} SAR received for booking #{booking.Id}"
                    : $"\nBooking #{booking.Id} confirmed with pending payment of {booking.TotalPrice} SAR";

                DataManagement.MakeNotificationToUser(user.Id,
                    paymentMethod == "Card" ? "Payment Received" : "Booking Confirmed",
                    message);
            }
        }

        private bool ValidatePaymentForm()
        {
            // Validate card number (simple Luhn check)
            string cardNumber = txtCardNumber.Text.Replace(" ", "");
            if (cardNumber.Length < 13 || cardNumber.Length > 19)
            {
                ShowMessage("Please enter a valid card number", "error");
                return false;
            }

            // Validate expiry date
            if (!IsValidExpiryDate(txtExpiryDate.Text))
            {
                ShowMessage("Please enter a valid expiry date (MM/YY)", "error");
                return false;
            }

            // Validate CVV
            if (txtCVV.Text.Length < 3)
            {
                ShowMessage("Please enter a valid CVV", "error");
                return false;
            }

            // Validate cardholder name
            if (string.IsNullOrWhiteSpace(txtCardHolder.Text))
            {
                ShowMessage("Please enter cardholder name", "error");
                return false;
            }

            return true;
        }

        private bool IsValidExpiryDate(string expiryDate)
        {
            if (string.IsNullOrWhiteSpace(expiryDate) || expiryDate.Length != 5)
                return false;

            try
            {
                string[] parts = expiryDate.Split('/');
                if (parts.Length != 2) return false;

                int month = int.Parse(parts[0]);
                int year = int.Parse(parts[1]) + 2000; // Convert YY to YYYY

                if (month < 1 || month > 12) return false;

                DateTime expiry = new DateTime(year, month, 1).AddMonths(1).AddDays(-1);
                return expiry >= DateTime.Today;
            }
            catch
            {
                return false;
            }
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