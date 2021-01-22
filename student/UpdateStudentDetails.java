package student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.ValidateEducator;
import connnection.EduHITecDb;

@WebServlet(urlPatterns= {"/UpdateStudentDetails"})
public class UpdateStudentDetails extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		PreparedStatement ps = null;
		String query;

		HttpSession session = req.getSession(false);
		int std_id = (Integer) session.getAttribute("std_id");
		Connection conn = EduHITecDb.getConnection();

		String name = req.getParameter("name").trim();
		String roll_no = req.getParameter("roll_no").trim();

		String address = req.getParameter("address").trim();
		String contact_no = req.getParameter("contact_no").trim();
		String city = req.getParameter("city").trim();
		String state = req.getParameter("state").trim();
		String gender = req.getParameter("gender");
		
		String degree = req.getParameter("degree");
		String branch = req.getParameter("branch");
		String std_class = req.getParameter("std_class");
		String section = req.getParameter("section");
		String batch = req.getParameter("batch");

		ValidateEducator ve = new ValidateEducator();
		boolean flag = ve.validateAddress(address) && ve.validateCity(city) && ve.validateContact(contact_no)
				&& ve.validateGender(gender) && ve.validateState(state);

		if (name == null || name.equals(""))
			flag = false;
		
		// if validation failed sent back to client side and ask for validation
		if (flag == false) {
			session.setAttribute("no_validEdu", "1");
			resp.sendRedirect("editEducatorProfile.jsp");
		} else {
			try {
				query = "update student set name=?,roll_no=?,address=?,contact_no=?,city=?,state=?,gender=?,"
						+ "degree=?,branch=?,std_class=?,section=?,batch=? where std_id=?";
				// validation succeed update details
				ps = conn.prepareStatement(query);

				ps.setString(1, name.toUpperCase());
				ps.setString(2, roll_no.toUpperCase());
				ps.setString(3, address.toUpperCase());
				ps.setString(4, contact_no);

				ps.setString(5, city.toUpperCase());
				ps.setString(6, state.toUpperCase());
				ps.setString(7, gender.toUpperCase());
				ps.setString(8, branch);
				ps.setString(9, degree);
				ps.setString(10, section);
				ps.setString(11, std_class);
				ps.setString(12, batch);
				ps.setInt(13, std_id);

				if (ps.executeUpdate() > 0) {
					session.setAttribute("success", "3");
					resp.sendRedirect("student_profile.jsp");
				} else {
					throw new Exception("unable to update info");
				}

			} catch (Exception e) {
				System.out.println("Exception at UpdateStudentDetails : " + e);
				e.printStackTrace();
				session.setAttribute("error", "1");
				resp.sendRedirect("editStudentProfile.jsp");
			}
		}
	}
}
