package quiz;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.jws.WebService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns = { "/DeleteQuestion" })
public class DeleteQuestion extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int quesid = Integer.parseInt(req.getParameter("id"));
		String query;
		PreparedStatement ps = null;
		HttpSession sess = req.getSession(false);
		ResultSet rs1 = null;
		Connection conn = EduHITecDb.getConnection();
		int quizid = Integer.parseInt(req.getParameter("qzid"));
		int marks = 0;
		String marks_obt;

		try {
			query = "select quizid,quesAttAbslPath,optionsAttAbslPath,marks from quesans where quesid=?";
			ps = conn.prepareStatement(query);

			ps.setInt(1, quesid);

			rs1 = ps.executeQuery();
			
			while (rs1.next()) {
				marks = rs1.getInt("marks");
				System.out.println(marks);
				// first delete all the files

				if (rs1.getString("quesAttAbslPath") != null) {
					String[] paths = rs1.getString("quesAttAbslPath").split("#");
					for (int i = 0; i < paths.length; i++) {
						File f = new File(paths[i]);
						f.delete();
					}
				}

				if (rs1.getString("optionsAttAbslPath") != null) {
					String[] paths = rs1.getString("optionsAttAbslPath").split("#");
					for (int i = 0; i < paths.length; i++) {
						File f = new File(paths[i]);
						f.delete();
					}
				}

			}

			// now delete the question
			query = "delete from quesans where quesid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, quesid);

			ps.executeUpdate();
			
			
			//before deleting the question the marks need to be updated
			//for each review
			
			//get all the review id for this question
			
			query = "select review_id,marks_obt from studentquizreview where quesid=? and marks_obt != ?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, quesid);
			ps.setString(2, "NA");
					
			rs1 = ps.executeQuery();
			
			while(rs1.next()) {
				//System.out.println("inside rs1 ");
				//now get the total marks and obtained marks from quiz review
				query = "select total_marks,obt_marks from quizreview where review_id=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, rs1.getInt("review_id"));
				ResultSet rs = ps.executeQuery();
				
				if(rs.next()) {
					//System.out.println("inside rs2 ");
					query = "update quizreview set total_marks=?,obt_marks=? where review_id=?";
					ps = conn.prepareStatement(query);
					ps.setString(1, String.valueOf(Integer.parseInt(rs.getString("total_marks"))-marks));
					
					marks_obt = rs1.getString("marks_obt");
				
					//now update the marks
					if(marks_obt.charAt(0) == '-') {
						ps.setString(2, String.valueOf(Double.parseDouble(rs.getString("obt_marks"))+Double.parseDouble(marks_obt.substring(1))));
					}else {
						ps.setString(2, String.valueOf(Double.parseDouble(rs.getString("obt_marks"))-Double.parseDouble(marks_obt)));
					}
					
					ps.setInt(3, rs1.getInt("review_id"));
					ps.executeUpdate();
				}
			}
					
					
			// now delete studentquizreview based on quesid	
			query = "delete from studentquizreview where quesid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, quesid);

			ps.executeUpdate();
			
			sess.setAttribute("success", "1");
			resp.sendRedirect("educatorDeleteQuestion.jsp?qzid="+new DataHiding().encodeMethod(String.valueOf(quizid)));
			
		} catch (Exception e) {
			
			System.out.println("Exception at DeleteQuestion : "+e);
			e.printStackTrace();
			sess.setAttribute("error", "1");
			resp.sendRedirect("educatorDeleteQuestion.jsp?qzid="+new DataHiding().encodeMethod(String.valueOf(quizid)));
		}
	}
}
