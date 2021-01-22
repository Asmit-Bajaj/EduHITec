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

import admin.AdminDao;
import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns= {"/CheckSubjectName"})
public class CheckSubjectName extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		DataHiding hd = new DataHiding();
		
		String name = req.getParameter("name").trim();
		HttpSession session = req.getSession(false);
		int inst_id = new AdminDao().inst_id((Integer)session.getAttribute("admin_id"));
		ResultSet rs;
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		String msg = "";
		
		try {
			// check does this name already occupied by institute or not 
			query = "select subjectName from subject where subjectName=? and inst_id=? and status=?";
			ps = conn.prepareStatement(query);
			ps.setString(1, name);
			ps.setInt(2,inst_id);
			ps.setBoolean(3, true);
		
			rs = ps.executeQuery();
		
			
			//if still available then do this
			if (rs.next()) {
				msg = "exist";
			} else {
				
				msg = "notexist";
			}
			
			resp.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
		    resp.setCharacterEncoding("UTF-8"); 
		    resp.getWriter().write(msg);
		    
		} catch (Exception e) {
			System.out.println("Exception at CheckAssignmentAvailability : " + e);
			e.printStackTrace();

		}
	}
}
