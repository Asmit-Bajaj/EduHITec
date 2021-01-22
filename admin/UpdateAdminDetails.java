package admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns = { "/UpdateAdminDetails" })
public class UpdateAdminDetails extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		PreparedStatement ps = null;
		String query;

		HttpSession session = req.getSession(false);
		int admin_id = (Integer) session.getAttribute("admin_id");
		Connection conn = EduHITecDb.getConnection();

		String name = req.getParameter("name").trim();
		String emp_id = req.getParameter("emp_id").trim();

		String address = req.getParameter("address").trim();
		String contact_no = req.getParameter("contact_no").trim();
		String city = req.getParameter("city").trim();
		String state = req.getParameter("state").trim();
		String gender = req.getParameter("gender");

		ValidateEducator ve = new ValidateEducator();
		boolean flag = ve.validateAddress(address) && ve.validateCity(city) && ve.validateContact(contact_no)
				&& ve.validateGender(gender) && ve.validateState(state);

			if(name == null || name.equals(""))
				flag = false;
		// if validation failed sent back to client side and ask for validation
		if (flag == false) {
			session.setAttribute("no_validAdmin", "1");
			resp.sendRedirect("editAdminProfile.jsp");
		} else {
			try {
				query = "update admin set name=?,emp_id=?,address=?,contact_no=?,city=?,state=?,gender=? where admin_id=?";
				// validation succeed update details
				ps = conn.prepareStatement(query);

				ps.setString(1, name.toUpperCase());
				ps.setString(2, emp_id.toUpperCase());
				ps.setString(3, address.toUpperCase());
				ps.setString(4, contact_no);

				ps.setString(5, city.toUpperCase());
				ps.setString(6, state.toUpperCase());
				ps.setString(7, gender.toUpperCase());
				ps.setInt(8, admin_id);

				if (ps.executeUpdate() > 0) {
					session.setAttribute("success", "3");
					resp.sendRedirect("admin_profile.jsp");
				} else {
					throw new Exception("unable to update info");
				}

			} catch (Exception e) {
				System.out.println("Exception at UpdateAdminDetails : " + e);
				e.printStackTrace();
				session.setAttribute("error", "1");
				resp.sendRedirect("editAdminProfile.jsp");
			}
		}
	}
}
