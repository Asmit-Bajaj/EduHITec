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

import connnection.EduHITecDb;

@WebServlet(urlPatterns= {"/CheckForgotPwdEmail"})
public class CheckForgotPwdEmail extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String role = req.getParameter("role");
		String email = req.getParameter("email");
		String query;
		PreparedStatement ps;
		Connection conn = null;
		ResultSet rs;
		String msg;
		if(conn == null) {
			conn = EduHITecDb.getConnection();
		}
		
		try {
			// check for this email as per the role
			
			if(role.equals("admin")) {
				query = "select email from admin where email=?";
				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				
				rs = ps.executeQuery();
				
				if (rs.next()) {	
					msg = "valid";
				} else {
					msg = "novalid";
				}
				
			}else if(role.equals("educator")) {
				query = "select email from educator where email=?";
				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				
				rs = ps.executeQuery();
				
				if (rs.next()) {	
					msg = "valid";
				} else {
					msg = "novalid";
				}
			}else if(role.equals("student")){
				query = "select email from student where email=?";
				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				
				rs = ps.executeQuery();
				
				if (rs.next()) {	
					msg = "valid";
				} else {
					msg = "novalid";
				}
			}else {
				msg = "novalid";
			}
			
			resp.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
		    resp.setCharacterEncoding("UTF-8"); 
		    resp.getWriter().write(msg);
		    
		} catch (Exception e) {
			System.out.println("Exception at CheckForgotPwdEmail : " + e);
			e.printStackTrace();

		}
	}
}
