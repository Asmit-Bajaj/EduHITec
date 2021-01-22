package assignment;

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

@WebServlet(urlPatterns= {"/UnlockAssignment"})
public class UnlockAssignment extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String query = "select * from mainlistassignments where code=? and now() <= deadline";
		Connection conn = EduHITecDb.getConnection();
		HttpSession sess = req.getSession(false);
		HttpSession ss = req.getSession(false);
		
		int id = (Integer)ss.getAttribute("std_id");
		PreparedStatement ps = null;
		
		try {
			ps = conn.prepareStatement(query);
			ps.setString(1, req.getParameter("SecretCode"));
			ResultSet set = ps.executeQuery();
			
			if(set.next()) {
				if(set.getString("code").equals(req.getParameter("SecretCode"))) {
					query = "insert into unlockedassignment(std_id,asgid)values(?,?)";
					ps = conn.prepareStatement(query);
					ps.setInt(1, id);
					ps.setInt(2, set.getInt("asgid"));
					
					if(ps.executeUpdate() > 0) {
						sess.setAttribute("success", "1");
						resp.sendRedirect("studentAssignmentMainSection.jsp?active=1");
					}else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("studentAssignmentMainSection.jsp?active=2");
					}
				}else {
					sess.setAttribute("nfd", "1");
					resp.sendRedirect("studentAssignmentMainSection.jsp?active=2");
				}
			}else {
				sess.setAttribute("nfd", "1");
				resp.sendRedirect("studentAssignmentMainSection.jsp?active=2");
			}
		} catch (Exception e) {
			System.out.println("Exception at UnlockAssignment : "+e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("studentAssignmentMainSection.jsp?active=2");
		}
	}
}
