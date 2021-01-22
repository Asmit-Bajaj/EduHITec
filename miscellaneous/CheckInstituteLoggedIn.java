package miscellaneous;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.mail.Session;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.AdminDao;
import connnection.EduHITecDb;

@WebServlet(urlPatterns = { "/CheckInstituteLoggedIn" })
public class CheckInstituteLoggedIn extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		HttpSession session = req.getSession(false);
		int inst_id = new AdminDao().inst_id((Integer)session.getAttribute("admin_id"));
		ResultSet rs;
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		String msg = "";

		try {
			// check logged in is true or not
			query = "select loggedIn from educator where inst_id=? and loggedIn=?";
			ps = conn.prepareStatement(query);
			ps.setBoolean(2, true);
			ps.setInt(1, inst_id);
			rs = ps.executeQuery();

			if (rs.next()) {
				msg = "loggedIn";
			} else {
				query = "select loggedIn from student where inst_id=? and loggedIn=?";
				ps = conn.prepareStatement(query);
				ps.setBoolean(2, true);
				ps.setInt(1, inst_id);
				rs = ps.executeQuery();

				if (rs.next()) {
					msg = "loggedIn";
				} else {
					msg = "loggedOut";
				}
			}

			resp.setContentType("text/plain"); // Set content type of the response so that jQuery knows what it can
												// expect.
			resp.setCharacterEncoding("UTF-8");
			resp.getWriter().write(msg);

		} catch (Exception e) {
			System.out.println("Exception at CheckInstituteLoggedIn : " + e);
			e.printStackTrace();

		}

	}
}
