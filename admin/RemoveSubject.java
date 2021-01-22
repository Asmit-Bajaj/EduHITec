package admin;

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

@WebServlet(urlPatterns= {"/RemoveSubject"})
public class RemoveSubject extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn= EduHITecDb.getConnection();
		HttpSession session = req.getSession(false);
		
		String query = "update subject set status=? where sub_id=?";
		try {
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setBoolean(1, false);
			ps.setInt(2,Integer.parseInt(req.getParameter("id")));
			
			if(ps.executeUpdate() > 0) {
				session.setAttribute("success", "1");
				resp.sendRedirect("check_subjects.jsp");
			}else {
				throw new Exception("Problem in removing subject");
			}
			
		}catch (Exception e) {
			System.out.println("exception at RemoveSubject : "+e);
			session.setAttribute("error", "1");
			resp.sendRedirect("check_subjects.jsp");
		}
		
	}
}
