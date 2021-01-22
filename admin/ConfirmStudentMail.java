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

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns= {"/ConfirmStudent"})
public class ConfirmStudentMail extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id=req.getParameter("id");
//		System.out.println(id);
		
		Connection conn = EduHITecDb.getConnection();
		
		PreparedStatement ps = null;
		
		try {
			int decodeId = Integer.parseInt(new DataHiding().decodeMethod(id));
			System.out.println(decodeId);
			System.out.println("hiii");
			
			String query = "select validate_email,link from student where std_id=? "
					+ "and DATEDIFF(now(),date_of_linkGen) < 11";
			
			ps = conn.prepareStatement(query);
			ps.setInt(1, decodeId);
		
			ResultSet rs = ps.executeQuery();
			
			
			if(rs.next()) {
				
				if(rs.getString("link").contains(req.getParameter("id")) == false || 
						rs.getString("link").contains(req.getParameter("upid")) == false) {
					
					resp.sendRedirect("confirmStudentMail.jsp?error=1");
					System.out.println("hii");
					System.out.println(rs.getString("link"));
					
				}else if(rs.getBoolean("validate_email")){
//					System.out.println("i'm back");
					resp.sendRedirect("confirmStudentMail.jsp?error=2");
				}else{
					//update the validate_email to true
					query = "update student set validate_email=? where std_id=?";
					ps = conn.prepareStatement(query);
					
					ps.setBoolean(1, true);
					ps.setInt(2, decodeId);
					
					if(ps.executeUpdate() > 0) {
						resp.sendRedirect("confirmStudentMail.jsp?success=1");
					}else {
						throw new Exception("Cannot able to update the status error");
					}
				}
			}else {
				resp.sendRedirect("confirmStudentMail.jsp?error=2");
			}
			
		}catch (Exception e) {
			System.out.println("Exception at ConfirmStudent : "+e);
			resp.sendRedirect("confirmStudentMail.jsp?error=3");
			
		}finally {
			conn=null;
			ps=null;
		}
	}
}
