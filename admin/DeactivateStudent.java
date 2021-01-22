package admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;

@WebServlet(urlPatterns = { "/DeactivateStudent" })
public class DeactivateStudent extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int std_id = Integer.parseInt(req.getParameter("id"));
		HttpSession session = req.getSession(false);
		ResultSet rs;
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		try {
			// check logged in is true or not
			query = "select loggedIn from student where loggedIn=? and std_id=?";
			ps = conn.prepareStatement(query);
			ps.setBoolean(1, true);
			ps.setInt(2, std_id);
			rs = ps.executeQuery();

			if (rs.next()) {
				session.setAttribute("logStdDeact", "1");
				resp.sendRedirect("check_students.jsp");
			} else {
				// update the status to false (deactivate)
				query = "update student set status=? where std_id=?";
				ps = conn.prepareStatement(query);

				ps.setBoolean(1, false);
				ps.setInt(2, std_id);

				if (ps.executeUpdate() > 0) {
					session.setAttribute("success", "2");
					resp.sendRedirect("check_students.jsp");
				} else {
					throw new Exception("Student not found");
				}
			}
		} catch (Exception e) {
			System.out.println("Exception at DeactivateStudent : " + e);
			e.printStackTrace();
			session.setAttribute("error", "1");
			resp.sendRedirect("check_students.jsp");
		}
	}
}
