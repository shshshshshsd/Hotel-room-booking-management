using System;
using System.Collections.Generic;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using WebApplicationRooms.Models;

namespace WebApplicationRooms
{
    public partial class StatisticPage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is admin
                if (Session["User"] == null || ((User)Session["User"]).Role != "Admin")
                {
                    Response.Redirect("LoginPage.aspx");
                    return;
                }

                // Set admin name
                lblAdminName.Text = ((User)Session["User"]).Username;

                // Set default dates
                txtStartDate.Text = DateTime.Now.AddDays(-30).ToString("yyyy-MM-dd");
                txtEndDate.Text = DateTime.Now.ToString("yyyy-MM-dd");

                LoadStatistics();
            }
        }

        protected void FilterStatistics(object sender, EventArgs e)
        {
            LoadStatistics();
        }

        private void LoadStatistics()
        {
            try
            {
                DateTime startDate, endDate;
                GetDateRange(out startDate, out endDate);

                // Load statistics data
                var stats = DataManagement.GetStatistics(startDate, endDate);

                // Update statistics cards
                lblTotalBookings.Text = stats.TotalBookings.ToString();
                lblTotalRevenue.Text = stats.TotalRevenue.ToString("C").Replace("$", "") + " SAR";
                lblTotalGuests.Text = stats.TotalGuests.ToString();

                // Update percentage changes with proper formatting
                UpdatePercentageLabel(lblBookingChange, stats.BookingChange);
                UpdatePercentageLabel(lblRevenueChange, stats.RevenueChange);
                UpdatePercentageLabel(lblGuestsChange, stats.GuestsChange);

                   // Load recent activities
                var activities = DataManagement.GetRecentActivities(5);
                rptRecentActivities.DataSource = activities;
                rptRecentActivities.DataBind();

                // Show/hide custom range panel
                pnlCustomRange.Visible = ddlTimeRange.SelectedValue == "0";
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error loading statistics: " + ex.Message;
                lblMessage.Visible = true;
                lblMessage.Style["color"] = "red";
            }
        }

        private void GetDateRange(out DateTime startDate, out DateTime endDate)
        {
            endDate = DateTime.Now;

            if (ddlTimeRange.SelectedValue == "0") // Custom range
            {
                if (!string.IsNullOrEmpty(txtStartDate.Text) && !string.IsNullOrEmpty(txtEndDate.Text))
                {
                    startDate = DateTime.Parse(txtStartDate.Text);
                    endDate = DateTime.Parse(txtEndDate.Text);
                }
                else
                {
                    startDate = DateTime.Now.AddDays(-30);
                }
            }
            else
            {
                int days = int.Parse(ddlTimeRange.SelectedValue);
                startDate = endDate.AddDays(-days);
            }
        }

        private void UpdatePercentageLabel(Label label, double percentage)
        {
            label.Text = percentage.ToString("+0.0;-0.0;0.0") + "%";

            // Remove existing CSS classes
            label.CssClass = label.CssClass.Replace("positive", "").Replace("negative", "").Trim();

            // Add appropriate CSS class based on value
            if (percentage > 0)
            {
                label.CssClass += " positive";
                label.Text = "<i class='fas fa-arrow-up'></i> " + label.Text;
            }
            else if (percentage < 0)
            {
                label.CssClass += " negative";
                label.Text = "<i class='fas fa-arrow-down'></i> " + label.Text;
            }
            else
            {
                label.Text = "<i class='fas fa-minus'></i> " + label.Text;
            }
        }

        protected void rptRecentActivities_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                var activity = e.Item.DataItem as Activity;
                if (activity != null)
                {
                    var activityIcon = (HtmlGenericControl)e.Item.FindControl("activityIcon");
                    var activityIconClass = (HtmlGenericControl)e.Item.FindControl("activityIconClass");

                    if (activityIcon != null && activityIconClass != null)
                    {
                        // Set background color and icon based on activity type
                        switch (activity.Type)
                        {
                            case "Booking":
                                activityIcon.Style["background-color"] = "#3498db";
                                activityIconClass.Attributes["class"] = "fas fa-calendar-plus";
                                break;
                            case "CheckIn":
                                activityIcon.Style["background-color"] = "#2ecc71";
                                activityIconClass.Attributes["class"] = "fas fa-sign-in-alt";
                                break;
                            case "CheckOut":
                                activityIcon.Style["background-color"] = "#f39c12";
                                activityIconClass.Attributes["class"] = "fas fa-sign-out-alt";
                                break;
                            case "Cancellation":
                                activityIcon.Style["background-color"] = "#e74c3c";
                                activityIconClass.Attributes["class"] = "fas fa-times-circle";
                                break;
                            default:
                                activityIcon.Style["background-color"] = "#95a5a6";
                                activityIconClass.Attributes["class"] = "fas fa-info-circle";
                                break;
                        }
                    }
                }
            }
        }
    }
}