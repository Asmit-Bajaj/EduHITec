package quiz;

import java.io.File;
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

@WebServlet(urlPatterns = { "/DeleteQuizMainList" })
public class DeleteQuizMainList extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		HttpSession sess = req.getSession(false);
		ResultSet rs1 = null;

		int qmid = Integer.parseInt(req.getParameter("Dqmid"));

		String query = "delete from quizmainlist where qmid=?";

		try {
			// first select all the quizzes of this list
			query = "select quizid from mainquiz where qmid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, qmid);

			rs = ps.executeQuery();

			while (rs.next()) {
				// first delete all the attempts made on this quiz

				query = "delete from quiz_attempts where quizid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, rs.getInt("quizid"));

				ps.executeUpdate();

				// now get review id for this quiz

				query = "select review_id from quizreview where quizid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, rs.getInt("quizid"));

				rs1 = ps.executeQuery();

				while (rs1.next()) {
					// now delete studentquizreview based on id

					query = "delete from studentquizreview where review_id=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, rs1.getInt("review_id"));

					ps.executeUpdate();
				}

				// now delete quiz review of this quiz
				query = "delete from quizreview where quizid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, rs.getInt("quizid"));

				ps.executeUpdate();

				// now delete this quiz data from unlocked quizzes
				query = "delete from unlockedquizzes where quizid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, rs.getInt("quizid"));

				ps.executeUpdate();

				// now delete ques ans of these quizzes

				query = "select quesAttAbslPath,optionsAttAbslPath from quesans where quizid=?";
				ps = conn.prepareStatement(query);

				ps.setInt(1, rs.getInt("quizid"));

				rs1 = ps.executeQuery();

				while (rs1.next()) {
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
				// now delete all the questions
				query = "delete from quesans where quizid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, rs.getInt("quizid"));

				ps.executeUpdate();
				
				//finally delete the quiz
				query = "delete from mainquiz where quizid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, rs.getInt("quizid"));

				ps.executeUpdate();
				
			}
			
			query = "delete from quizmainlist where qmid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, qmid);
			
			if(ps.executeUpdate() > 0) {
				sess.setAttribute("success", "3");
				resp.sendRedirect("uploadQuizzes.jsp");
			}else {
				throw new Exception("error in deleting the list");
			}
			
		} catch (Exception e) {
			System.out.println("Exception at DeleteQuizMainList :" + e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("uploadQuizzes.jsp");
		}
	}
}
