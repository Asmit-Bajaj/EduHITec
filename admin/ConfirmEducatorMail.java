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

@WebServlet(urlPatterns= {"/ConfirmEducator"})
public class ConfirmEducatorMail extends HttpServlet {
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String id=req.getParameter("id");
//		System.out.println(id);
		
		Connection conn = EduHITecDb.getConnection();
		
		PreparedStatement ps = null;
		
		try {
			//check whether this link is valid or not
			int decodeId = Integer.parseInt(new DataHiding().decodeMethod(id));
			System.out.println(decodeId);
			
			String query = "select validate_email,link from educator where edu_id=? "
					+ "and DATEDIFF(now(),date_of_linkGen) < 11";
			
			ps = conn.prepareStatement(query);
			ps.setInt(1, decodeId);
		
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()) {
				
				if(rs.getString("link").contains(req.getParameter("id")) == false || 
						rs.getString("link").contains(req.getParameter("upid")) == false) {
					
					resp.sendRedirect("confirmEducatorMail.jsp?error=1");
				}else if(rs.getBoolean("validate_email")){
					resp.sendRedirect("confirmEducatorMail.jsp?error=2");
				}else{
					//update the validate_email to true
					query = "update educator set validate_email=? where edu_id=?";
					ps = conn.prepareStatement(query);
					
					ps.setBoolean(1, true);
					ps.setInt(2, decodeId);
					
					if(ps.executeUpdate() > 0) {
						resp.sendRedirect("confirmEducatorMail.jsp?success=1");
					}else {
						throw new Exception("Cannot able to update the status error");
					}
				}
			}else {
				resp.sendRedirect("confirmEducatorMail.jsp?error=2");
			}
			
		}catch (Exception e) {
			System.out.println("Exception at ConfirmEducator : "+e);
			resp.sendRedirect("confirmEducatorMail.jsp?error=3");
			
		}finally {
			conn=null;
			ps=null;
		}
	}
}
