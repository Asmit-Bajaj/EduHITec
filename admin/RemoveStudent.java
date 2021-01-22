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

@WebServlet(urlPatterns = { "/RemoveStudent" })
public class RemoveStudent extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		HttpSession session = req.getSession(false);
		String query;
		int std_id = Integer.parseInt(req.getParameter("id"));
		PreparedStatement ps;
		ResultSet rs;
		try {
			// check logged in is true or not
			query = "select loggedIn from student where loggedIn=? and std_id=?";
			ps = conn.prepareStatement(query);
			ps.setBoolean(1, true);
			ps.setInt(2, std_id);
			
			rs = ps.executeQuery();

			if (rs.next()) {
				session.setAttribute("logStdRemove", "1");
				resp.sendRedirect("check_students.jsp");
			} else {
				// delete from educator table
				query = "delete from student where std_id=?";
				ps = conn.prepareStatement(query);

				ps.setInt(1, std_id);

				if (ps.executeUpdate() > 0) {
					session.setAttribute("success", "1");
					resp.sendRedirect("check_students.jsp");
				} else {
					throw new Exception("Student Not Found");
				}
			}
		} catch (Exception e) {
			System.out.println("Exception at RemoveStudent() : " + e);
			session.setAttribute("error", "1");
			resp.sendRedirect("check_students.jsp");

		} finally {
			conn = null;
		}
	}
}
