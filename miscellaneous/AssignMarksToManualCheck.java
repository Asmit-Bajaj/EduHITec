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

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns= {"/AssignMarksToManualCheck"})
public class AssignMarksToManualCheck extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		DataHiding hd = new DataHiding();
		String msg = "notvalid";
		
		int rvid = Integer.parseInt(hd.decodeMethod(req.getParameter("rvid")));
		int quesid = Integer.parseInt(hd.decodeMethod(req.getParameter("quid")));
		Connection conn = null;
		String marks = req.getParameter("marks");
		
		if(conn == null) {
			conn = EduHITecDb.getConnection();
		}
		
		try {
			//first update the marks against this ques in studentquiz review
			String query = "update studentquizreview set marks_obt=? where review_id=? and quesid=?";
			PreparedStatement ps = conn.prepareStatement(query);
			
			ps.setString(1, marks);
			ps.setInt(2, rvid);
			ps.setInt(3, quesid);
			
			if(ps.executeUpdate() > 0) {
				//now obtain the total obtained marks
				query = "select obt_marks from quizreview where review_id=?";
				ps = conn.prepareStatement(query);
				
				ps.setInt(1, rvid);
				
				ResultSet set = ps.executeQuery();
				
				if(set.next()) {
					//now update the obtained marks
					query = "update quizreview set obt_marks=? where review_id=?";
					ps = conn.prepareStatement(query);
					
					ps.setString(1,String.valueOf(Double.parseDouble(set.getString("obt_marks"))+Double.parseDouble(marks)));
					
					ps.setInt(2, rvid);
					
					if(ps.executeUpdate() > 0) {
						msg = marks;
					}
				}
			}
					
			resp.setContentType("text/plain");  // Set content type of the response so that jQuery knows what it can expect.
		    resp.setCharacterEncoding("UTF-8"); 
		    resp.getWriter().write(msg);
		}catch (Exception e) {
			System.out.println("Exception at AssignMarksToManualCheck : "+e);
		}
		
		
	}
}
