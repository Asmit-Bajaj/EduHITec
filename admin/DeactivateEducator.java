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

@WebServlet(urlPatterns = { "/DeactivateEducator" })
public class DeactivateEducator extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int edu_id = Integer.parseInt(req.getParameter("id"));
		HttpSession session = req.getSession(false);
		ResultSet rs;
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		try {
			//check logged in is true or not
			query = "select loggedIn from educator where edu_id=? and loggedIn=?";
			ps = conn.prepareStatement(query);
			ps.setBoolean(2, true);
			ps.setInt(1, edu_id);
			rs = ps.executeQuery();

			if (rs.next()) {
				session.setAttribute("logEduDeact", "1");
				resp.sendRedirect("check_Educators.jsp");
			} else {
				// update the status to false (deactivate)
				query = "update educator set status=? where edu_id=?";
				ps = conn.prepareStatement(query);

				ps.setBoolean(1, false);
				ps.setInt(2, edu_id);

				if (ps.executeUpdate() > 0) {
					session.setAttribute("success", "2");
					resp.sendRedirect("check_Educators.jsp");
				} else {
					throw new Exception("Educator not found");
				}
			}
		} catch (Exception e) {
			System.out.println("Exception at DeactivateEducator : " + e);
			e.printStackTrace();
			session.setAttribute("error", "1");
			resp.sendRedirect("check_Educators.jsp");
		}
	}
}
