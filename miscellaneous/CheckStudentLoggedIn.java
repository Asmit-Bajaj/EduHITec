package miscellaneous;

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

@WebServlet(urlPatterns={"/CheckStudentLoggedIn"})
public class CheckStudentLoggedIn extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int std_id = Integer.parseInt(req.getParameter("std_id"));
		HttpSession session = req.getSession(false);
		ResultSet rs;
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		String msg = "";
		
		try {
			// check logged in is true or not
			query = "select loggedIn from student where std_id=? and loggedIn=?";
			ps = conn.prepareStatement(query);
			ps.setBoolean(2, true);
			ps.setInt(1, std_id);
			rs = ps.executeQuery();

			if (rs.next()) {
				msg = "loggedIn";
			} else {
				msg = "loggedOut";
			}
			
			resp.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
		    resp.setCharacterEncoding("UTF-8"); 
		    resp.getWriter().write(msg);
		    
		} catch (Exception e) {
			System.out.println("Exception at CheckStudentLoggenIn : " + e);
			e.printStackTrace();

		}

	}
}
