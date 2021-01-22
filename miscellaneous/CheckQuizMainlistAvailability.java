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

@WebServlet(urlPatterns= {"/CheckQuizMainlistAvailability"})
public class CheckQuizMainlistAvailability extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		DataHiding hd = new DataHiding();
		int qmid = Integer.parseInt(hd.decodeMethod(req.getParameter("qmid")));
		HttpSession session = req.getSession(false);
		ResultSet rs;
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		String msg = "";
		
		try {
			// check does this quiz list removed by educator 
			query = "select qmid from quizmainlist where qmid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, qmid);
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
			System.out.println("Exception at CheckQuizMainlistAvailability : " + e);
			e.printStackTrace();

		}
	}
}
