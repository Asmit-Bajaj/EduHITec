package emailValidation;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import connnection.EduHITecDb;

@WebServlet(urlPatterns = { "/CheckEmail" })
public class CheckEmail extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String msg = "";
		String email = req.getParameter("email").trim().toLowerCase();
		String type = req.getParameter("type").trim().toLowerCase();
		Connection conn = EduHITecDb.getConnection();
		String query = "";
		ResultSet rs;
		boolean flag = true;

		PreparedStatement ps = null;

		try {
			if (type.equals("edu")) {
				// check for email in educator table if type is edu
				query = "select email from educator where email=?";
				ps = conn.prepareStatement(query);
				ps.setString(1, email.toLowerCase());

				rs = ps.executeQuery();

				if (rs.next()) {
					flag = false;
				}
			} else if (type.equals("std")) {
				// check in student table for email if type is std
				query = "select email from student where email=?";

				ps = conn.prepareStatement(query);
				ps.setString(1, email.toLowerCase());

				rs = ps.executeQuery();

				if (rs.next()) {
					flag = false;
				}
			}else if(type.equals("admin")) {
				// check in admin table for email if type is admin
				query = "select email from admin where email=?";

				ps = conn.prepareStatement(query);
				ps.setString(1, email.toLowerCase());

				rs = ps.executeQuery();

				if (rs.next()) {
					flag = false;
				}
			}

			if (flag == false) {
				msg = "novalid";
			}

			resp.setContentType("text/plain"); // Set content type of the response so that jQuery knows what it can
												// expect.
			resp.setCharacterEncoding("UTF-8");
			resp.getWriter().write(msg);

		} catch (Exception e) {
			System.out.println("Exception at CheckEmail : " + e);
		}
	}
}
