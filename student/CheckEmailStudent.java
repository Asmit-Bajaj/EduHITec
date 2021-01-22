package student;

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

@WebServlet(urlPatterns= {"/CheckEmailStudent"})
public class CheckEmailStudent extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String msg = "";
		String email = req.getParameter("email").trim().toLowerCase();
		
		Connection conn = EduHITecDb.getConnection();
		String query = "";
		ResultSet rs;
		boolean flag =true;
		
		PreparedStatement ps = null;
		
		try {
//			query = "select email from educator where email=?";
//			ps = conn.prepareStatement(query);
//			ps.setString(1, email.toLowerCase());
//			
//			rs = ps.executeQuery();
//			
//			if(rs.next()) {
//				flag = false;
//			}
			
			//check in student table too for email
			query = "select email from student where email=? and std_id != ?";
			
			ps = conn.prepareStatement(query);
			ps.setString(1, email.toLowerCase());
			if((Integer)req.getSession(false).getAttribute("std_id") != null)
				ps.setInt(2, (Integer)req.getSession(false).getAttribute("std_id"));
			else
				ps.setInt(2, Integer.parseInt(req.getParameter("std_id")));
			
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				flag = false;
			}
			
//			//now check in admin table too
//			
//			query = "select email from admin where email=?";
//			
//			ps = conn.prepareStatement(query);
//			ps.setString(1, email.toLowerCase());
//			
//			
//			
//			rs = ps.executeQuery();
//			
//			if(rs.next()) {
//				flag = false;
//			}
			
			if(flag == false) {
				msg = "novalid";
			}
			
			resp.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
		    resp.setCharacterEncoding("UTF-8"); 
		    resp.getWriter().write(msg);
		    
		} catch (Exception e) {
			System.out.println("Exception at CheckEmailStudent : "+e);
		}
	}
}
