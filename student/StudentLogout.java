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

import connnection.EduHITecDb;

@WebServlet(urlPatterns= {"/StudentLogout"})
public class StudentLogout extends HttpServlet{
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		HttpSession session = req.getSession(false);
		if(session != null && session.getAttribute("std_id") != null) {
			try {
			Connection conn = EduHITecDb.getConnection();
			//update login to true
			String query = "update student set loggedIn=? where std_id=?";
			
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setBoolean(1, false);
			ps.setInt(2, (Integer)session.getAttribute("std_id"));
			
			ps.executeUpdate();
			
//			session.removeAttribute("fac_id");
			session.invalidate();
			System.out.println("student Logout");
			}catch (Exception e) {
				System.out.println("Exception at educatorLogout : "+e);
			}
		}
		resp.sendRedirect("login.jsp");
	}
	
}
