using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplicationRooms.Models;

namespace WebApplicationRooms
{
    public partial class Rooms : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["User"] == null)
            {
                Response.Redirect("LoginPage.aspx");
                return;
            }

            User currentUser = (User)Session["User"];
            if (currentUser.Role != "Admin")
            {
                Response.Redirect("BookingsDashboard.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadRooms();
            }
        }

        private void LoadRooms()
        {
            gvRooms.DataSource = DataManagement.Rooms;
            gvRooms.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                if (string.IsNullOrEmpty(txtRoomName.Text) || string.IsNullOrEmpty(ddlRoomType.SelectedValue) || 
                    string.IsNullOrEmpty(txtBasePrice.Text) || string.IsNullOrEmpty(txtCapacity.Text))
                {
                    ShowMessage("Please fill all required fields", "error");
                    return;
                }

                decimal basePrice;
                int capacity;
                
                if (!decimal.TryParse(txtBasePrice.Text, out basePrice) || basePrice <= 0)
                {
                    ShowMessage("Base price must be a positive number", "error");
                    return;
                }

                if (!int.TryParse(txtCapacity.Text, out capacity) || capacity <= 0)
                {
                    ShowMessage("Capacity must be a positive number", "error");
                    return;
                }

                int roomId = 0;
                if (!string.IsNullOrEmpty(hfRoomId.Value) && int.TryParse(hfRoomId.Value, out roomId))
                {
                    // Successfully parsed the room ID
                }
                
                if (roomId > 0) // تعديل غرفة موجودة
                {
                    Room room = null;
                    for (int i = 0; i < DataManagement.Rooms.Count; i++)
                    {
                        if (DataManagement.Rooms[i].Id == roomId)
                        {
                            room = DataManagement.Rooms[i];
                            break;
                        }
                    }
                    if (room != null)
                    {
                        room.Name = txtRoomName.Text.Trim();
                        room.Type = ddlRoomType.SelectedValue;
                        room.BasePrice = basePrice;
                        room.Capacity = capacity;
                        room.Amenities = txtAmenities.Text.Trim();
                        room.IsAvailable = chkIsAvailable.Checked;
                        DataManagement.UpdateRoom(room);
                        ShowMessage("Room updated successfully", "success");
                    }
                }
                else // إضافة غرفة جديدة
                {
                    Room newRoom = new Room
                    {
                      
                        Name = txtRoomName.Text.Trim(),
                        Type = ddlRoomType.SelectedValue,
                        BasePrice = basePrice,
                        Capacity = capacity,
                        Amenities = txtAmenities.Text.Trim(),
                        IsAvailable = chkIsAvailable.Checked
                    };
                    
                    DataManagement.AddRoom(newRoom);
                    ShowMessage("Room added successfully", "success");
                }

                ClearForm();
                gvRooms.EditIndex = -1; // Ensure GridView is not in edit mode
                LoadRooms();
            }
            catch (Exception ex)
            {
                ShowMessage("Error saving room: " + ex.Message, "error");
            }
        }


        protected void btnCancel_Click(object sender, EventArgs e)
        {
            ClearForm();
        }

        protected void gvRooms_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int roomId = Convert.ToInt32(e.CommandArgument);
            Room room = null;
            for (int i = 0; i < DataManagement.Rooms.Count; i++)
            {
                if (DataManagement.Rooms[i].Id == roomId)
                {
                    room = DataManagement.Rooms[i];
                    break;
                }
            }

            if (room == null) return;

            switch (e.CommandName)
            {
                case "Edit":
                    EditRoom(room);
                    break;
                case "Toggle":
                    ToggleRoomAvailability(room);
                    break;
            }
        }

        private void EditRoom(Room room)
        {
            hfRoomId.Value = room.Id.ToString();
            txtRoomName.Text = room.Name;
            ddlRoomType.SelectedValue = room.Type;
            txtBasePrice.Text = room.BasePrice.ToString();
            txtCapacity.Text = room.Capacity.ToString();
            txtAmenities.Text = room.Amenities;
            chkIsAvailable.Checked = room.IsAvailable;
        }

        private void ToggleRoomAvailability(Room room)
        {
            room.IsAvailable = !room.IsAvailable;
            DataManagement.UpdateRoom(room);
            ShowMessage("Room status changed successfully", "success");
            LoadRooms();
        }

        private void ClearForm()
        {
            hfRoomId.Value = "";
            txtRoomName.Text = "";
            ddlRoomType.SelectedIndex = 0;
            txtBasePrice.Text = "";
            txtCapacity.Text = "";
            txtAmenities.Text = "";
            chkIsAvailable.Checked = true;
        }

        protected void gvRooms_RowEditing(object sender, GridViewEditEventArgs e)
        {
            // Cancel edit mode and load room for editing in form
            gvRooms.EditIndex = -1;
            int roomId = Convert.ToInt32(gvRooms.DataKeys[e.NewEditIndex].Value);
            Room room = null;
            for (int i = 0; i < DataManagement.Rooms.Count; i++)
            {
                if (DataManagement.Rooms[i].Id == roomId)
                {
                    room = DataManagement.Rooms[i];
                    break;
                }
            }
            if (room != null)
            {
                LoadRoomForEdit(room);
            }
            LoadRooms(); // Refresh GridView
        }

        private void LoadRoomForEdit(Room room)
        {
            hfRoomId.Value = room.Id.ToString();
            txtRoomName.Text = room.Name;
            ddlRoomType.SelectedValue = room.Type;
            txtBasePrice.Text = room.BasePrice.ToString();
            txtCapacity.Text = room.Capacity.ToString();
            txtAmenities.Text = room.Amenities;
            chkIsAvailable.Checked = room.IsAvailable;
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
    }
}
