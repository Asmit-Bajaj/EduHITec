package educator;

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

@WebServlet(urlPatterns= {"/CheckEducatorPwd"})
public class CheckEducatorPwd extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String pwd = req.getParameter("pwd").trim();
		DataHiding hd = new DataHiding();
		Connection conn = EduHITecDb.getConnection();
		
		
		PreparedStatement ps = null;
		String msg = "";
		boolean flag = false;
		try {
			pwd =	hd.toHexString(hd.getSHA(pwd));
			String query = "select pwd from educator where edu_id=?";
			
			ps = conn.prepareStatement(query);
			ps.setInt(1, (Integer)req.getSession(false).getAttribute("edu_id"));
			
			ResultSet rs = ps.executeQuery();
			
			//if password found
			if(rs.next()) {
				//now check is password same or not
				if(rs.getString("pwd").equals(pwd)) {
					msg = "valid";
				}else {
					msg = "novalid";
				}
				resp.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
			    resp.setCharacterEncoding("UTF-8"); 
			    resp.getWriter().write(msg);
			}else {
				throw new Exception("problem in getting info");
			}
		}catch (Exception e) {
			System.out.println("exception at CheckEducatorPwd : "+e);
		}
	}
}
