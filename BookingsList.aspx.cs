using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using WebApplicationRooms.Models;

namespace WebApplicationRooms
{
    public partial class BookingsList : Page
    {
        protected User GetCurrentUser()
        {
            User currentUser = (User)Session["User"];
            return currentUser;
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadBookings();
            }
        }

        private void LoadBookings()
        {
            var user = (User)Session["User"];
            var bookings = DataManagement.Bookings;

            if (user.Role == "Guest")
            {
                bookings = bookings.Where(b => b.UserId == user.Id).ToList();
            }

            // Apply filters
            bookings = ApplyFilters(bookings);

            // Apply sorting
            bookings = ApplySorting(bookings);

            rptBookings.DataSource = bookings;
            rptBookings.DataBind();
            pnlNoBookings.Visible = !bookings.Any();
        }

        private List<Booking> ApplyFilters(List<Booking> bookings)
        {
            var filteredBookings = bookings;

            // Status filter
            if (!string.IsNullOrEmpty(ddlStatusFilter.SelectedValue))
            {
                filteredBookings = filteredBookings.Where(b => b.Status == ddlStatusFilter.SelectedValue).ToList();
            }

            // Room type filter
            if (!string.IsNullOrEmpty(ddlRoomTypeFilter.SelectedValue))
            {
                filteredBookings = filteredBookings.Where(b => b.Room.Type == ddlRoomTypeFilter.SelectedValue).ToList();
            }

            return filteredBookings;
        }

        private List<Booking> ApplySorting(List<Booking> bookings)
        {
            var sortedBookings = bookings;

            if (!string.IsNullOrEmpty(ddlSortBy.SelectedValue))
            {
                switch (ddlSortBy.SelectedValue)
                {
                    case "CheckInAsc":
                        sortedBookings = sortedBookings.OrderBy(b => b.CheckInDate).ToList();
                        break;
                    case "CheckInDesc":
                        sortedBookings = sortedBookings.OrderByDescending(b => b.CheckInDate).ToList();
                        break;
                    case "CheckOutAsc":
                        sortedBookings = sortedBookings.OrderBy(b => b.CheckOutDate).ToList();
                        break;
                    case "CheckOutDesc":
                        sortedBookings = sortedBookings.OrderByDescending(b => b.CheckOutDate).ToList();
                        break;
                    default:
                        // Default order (by booking ID or creation date)
                        sortedBookings = sortedBookings.OrderBy(b => b.Id).ToList();
                        break;
                }
            }
            else
            {
                // Default order if no sorting selected
                sortedBookings = sortedBookings.OrderBy(b => b.Id).ToList();
            }

            return sortedBookings;
        }

        protected void FilterBookings(object sender, EventArgs e)
        {
            LoadBookings();
        }

        protected void ClearFilters(object sender, EventArgs e)
        {
            ddlStatusFilter.SelectedValue = "";
            ddlRoomTypeFilter.SelectedValue = "";
            ddlSortBy.SelectedValue = "";
            LoadBookings();
            ShowToast("Filters cleared successfully", "success");
        }

        public string GetStatusText(string status)
        {
            switch (status)
            {
                case "Pending": return "Pending";
                case "Confirmed": return "Confirmed";
                case "Checked-In": return "Checked-In";
                case "Checked-Out": return "Checked-Out";
                case "Cancelled": return "Cancelled";
                default: return status;
            }
        }

        public string GetRoomName(string roomId)
        {
            if (string.IsNullOrEmpty(roomId) || !int.TryParse(roomId, out int id))
                return "Unknown Room";

            var room = DataManagement.Rooms.FirstOrDefault(r => r.Id == id);
            return room?.Name ?? "Room Not Found";
        }

        protected void rptBookings_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int bookingId = Convert.ToInt32(e.CommandArgument);
            var booking = DataManagement.Bookings.FirstOrDefault(b => b.Id == bookingId);

            if (booking == null) return;

            switch (e.CommandName)
            {
                case "Edit":
                    Response.Redirect($"EditBooking.aspx?id={bookingId}");
                    break;
                case "Cancel":
                    CancelBooking(booking);
                    break;
                case "CheckIn":
                    CheckInBooking(booking);
                    break;
                case "CheckOut":
                    CheckOutBooking(booking);
                    break;
                case "confirm":
                    ConfirmBooking(booking);
                    break;
                case "sendCheckInRemender":
                    SendCheckInReminder(booking);
                    break;
                case "sendCheckOutRemender":
                    SendCheckOutReminder(booking);
                    break;
                case "Pay":
                    Response.Redirect($"PaymentPage.aspx?bookingId={bookingId}");
                    break;
            }
        }

        private void SendCheckOutReminder(Booking booking)
        {
            string title = "Check Out Reminder";
            // message that reminds the guest how many days are left for check out
           string message = $"Dear {booking.Customer.Name}, Your [ booking #{booking.Id} | Room #{booking.Room.Name} ] has {booking.CheckOutDate.Subtract(DateTime.Now).Days} days left to check out!";
            DataManagement.MakeNotificationToUser(booking.UserId, title, message);
            ShowToast($"Checked-out reminder send successfully to guest for Booking #{booking.Id}", "success");
        }

        private void SendCheckInReminder(Booking booking)
        {
            string title = "Check In Reminder";
            // message that reminds the guest how many days are left for check in
            string message = $"Dear {booking.Customer.Name}, Your [ booking #{booking.Id} | Room #{booking.Room.Name} ] has {booking.CheckInDate.Subtract(DateTime.Now).Days} days left to check in!";
            DataManagement.MakeNotificationToUser(booking.UserId, title, message);
            ShowToast($"Checked-in reminder send successfully to guest for Booking #{booking.Id}", "success");
        }

        private void CancelBooking(Booking booking)
        {
            if (booking.Status == "Pending" || booking.Status == "Confirmed")
            {
                booking.Status = "Cancelled";
                booking.CancelPenalty = DataManagement.CalculateCancellationPenalty(booking, DateTime.Now);
                DataManagement.UpdateBooking(booking);
                ShowToast($"Booking #{booking.Id} cancelled successfully", "success");
                string message = $"Dear {booking.Customer.Name}, Your booking #{booking.Id} Room #{booking.Room.Name} has been cancelled!";
                DataManagement.MakeNotificationToUser(booking.UserId, "Booking Cancellation", message);
                LoadBookings();
            }
            else
            {
                ShowToast("Cannot cancel this booking in its current status", "warning");
            }
        }

        private void CheckInBooking(Booking booking)
        {
            if (booking.Status == "Confirmed")
            {
                booking.Status = "Checked-In";
                DataManagement.UpdateBooking(booking);
                ShowToast($"Guest checked in successfully for Booking #{booking.Id}", "success");
                string message = $"Dear {booking.Customer.Name}, Your booking #{booking.Id} Room #{booking.Room.Name} has been checked in!";
                DataManagement.MakeNotificationToUser(booking.UserId, "Booking Check-In", message);
                LoadBookings();
            }
            else
            {
                ShowToast("Cannot check in this booking in its current status", "warning");
            }
        }

        private void CheckOutBooking(Booking booking)
        {
            if (booking.Status == "Checked-In")
            {
                booking.Status = "Checked-Out";
                DataManagement.UpdateBooking(booking);
                ShowToast($"Guest checked out successfully for Booking #{booking.Id}", "success");
                string message = $"Dear {booking.Customer.Name}, Your booking #{booking.Id} Room #{booking.Room.Name} has been checked out!";
                DataManagement.MakeNotificationToUser(booking.UserId, "Booking Check-Out", message);
                LoadBookings();
            }
            else
            {
                ShowToast("Cannot check out this booking in its current status", "warning");
            }
        }

        private void ConfirmBooking(Booking booking)
        {
            if (booking.PaymentStatus == "Unpaid")
            {
                ShowToast("Only paid bookings can be confirmed", "warning");
                return;
            }

            string message = $"Dear {booking.Customer.Name}, Your booking #{booking.Id} Room #{booking.Room.Name} has been confirmed!";
            booking.Status = "Confirmed";
            DataManagement.UpdateBooking(booking);
            // Simulate email sending with toast notification
            ShowToast($"Confirmation notification sent to user #{booking.UserId}", "info");
            DataManagement.MakeNotificationToUser(booking.UserId, "Booking Confirmation", message);

            LoadBookings();
        }

       

        private void ShowToast(string message, string type)
        {
            // Store toast message in hidden fields for JavaScript to pick up
            hdnToastMessage.Value = message;
            hdnToastType.Value = type;

            // Also register startup script to show toast immediately
            ScriptManager.RegisterStartupScript(this, GetType(), "ShowToast",
                $"showToast('{message.Replace("'", "\\'")}', '{type}');", true);
        }
    }
}