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

@WebServlet(urlPatterns= {"/CheckQuizLockStatus"})
public class CheckQuizLockStatus extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		DataHiding hd = new DataHiding();
		int quizid = Integer.parseInt(hd.decodeMethod(req.getParameter("quizid")));
		HttpSession session = req.getSession(false);
		ResultSet rs;
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		String msg = "";
		
		try {
			// check does this note removed by educator or not 
			query = "select qzlock from mainquiz where quizid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, quizid);
			rs = ps.executeQuery();
			rs.next();
			//if still available then do this
			if (rs.getInt("qzlock") != 0) {
				msg = "lock";
			} else {
				
				msg = "unlock";
			}
			
			resp.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
		    resp.setCharacterEncoding("UTF-8"); 
		    resp.getWriter().write(msg);
		    
		} catch (Exception e) {
			System.out.println("Exception at CheckQuizLockStatus : " + e);
			e.printStackTrace();

		}
	}
}
