using System;
using System.Linq;
using System.Web.UI;
using WebApplicationRooms.Models;

namespace WebApplicationRooms
{
    public partial class BookingsDashboard : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("LoginPage.aspx");
               return;
            }

            User currentUser =  (User)Session["User"];
            lblUser.Text = currentUser.Username + " (" + currentUser.Role + ")";

            lnkRooms.Visible = currentUser.Role == "Admin";
            lnkStatistic.Visible = currentUser.Role == "Admin";
            lnkNotifications.Visible = currentUser.Role == "Guest";

            if (!IsPostBack)
            {
                LoadDashboardStats();
            }
        }

        private void LoadDashboardStats()
        {
            var bookings = DataManagement.Bookings;
            var user = (User)Session["User"];

            if (user.Role == "Guest")
            {
                bookings = bookings.Where(b => b.UserId == user.Id).ToList();
            }

            lblTotalBookings.Text = bookings.Count.ToString();
            lblActiveBookings.Text = bookings.Count(b => b.Status == "Checked-In").ToString();
            lblPendingBookings.Text = bookings.Count(b => b.Status == "Pending").ToString();
            lblCancelledBookings.Text = bookings.Count(b => b.Status == "Cancelled").ToString();
        }

        protected void lnkLogout_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect("LoginPage.aspx");
        }
    }
}