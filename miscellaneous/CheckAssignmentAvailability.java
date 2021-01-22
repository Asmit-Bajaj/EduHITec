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
import hide.DataHiding;

@WebServlet("/CheckAssignmentAvailability")
public class CheckAssignmentAvailability extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		DataHiding hd = new DataHiding();
		int asgid = Integer.parseInt(hd.decodeMethod(req.getParameter("asgid")));
		HttpSession session = req.getSession(false);
		ResultSet rs;
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		String msg = "";
		
		try {
			// check does this assignment removed by educator or not 
			query = "select asgid from mainlistassignments where asgid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, asgid);
			rs = ps.executeQuery();
			
			//if still available then do this
			if (rs.next()) {
				msg = "notremove";
			} else {
				
				msg = "remove";
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
