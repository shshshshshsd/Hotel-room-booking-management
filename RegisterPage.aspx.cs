using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WebApplicationRooms.Models;

namespace WebApplicationRooms
{
    public partial class RegisterPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnRegister_OnClick(object sender, EventArgs e)
        {
            User user = new User();

            int userId = DataManagement.Users.Select(u => u.Id).Last() + 1;
            user.Id = userId;
            user.Name = txtName.Text;
            user.Email = txtEmail.Text.Trim();
            user.Phone = txtPhone.Text;
            user.Username = txtUsername.Text.Trim();
            user.Password = DataManagement.HashPassword(txtPassword.Text.Trim());
            user.Role = "Guest";

            DataManagement.AddUser(user);

            Response.Redirect("LoginPage.aspx");
            return;
            

        }
    }
}