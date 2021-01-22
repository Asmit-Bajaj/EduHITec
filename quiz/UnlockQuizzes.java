package quiz;

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

@WebServlet(urlPatterns= {"/UnlockQuiz"})
public class UnlockQuizzes extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String query = "select * from mainquiz where code=?";
		Connection conn = EduHITecDb.getConnection();
		HttpSession ss = req.getSession(false);
		
		int id = (Integer)ss.getAttribute("std_id");
		PreparedStatement ps = null;
		
		try {
			ps = conn.prepareStatement(query);
			ps.setString(1, req.getParameter("SecretCode"));
			ResultSet set = ps.executeQuery();
			
			if(set.next()) {
				if(set.getString("code").equals(req.getParameter("SecretCode"))) {
					query = "insert into unlockedquizzes(std_id,quizid,unlockDate)values(?,?,now())";
					ps = conn.prepareStatement(query);
					ps.setInt(1, id);
					ps.setInt(2, set.getInt("quizid"));
					
					if(ps.executeUpdate() > 0) {
						ss.setAttribute("success", "1");
						resp.sendRedirect("studentQuizMainSection.jsp");
					}else {
						ss.setAttribute("error", "1");
						resp.sendRedirect("studentQuizMainSection.jsp");
					}
				}else {
					ss.setAttribute("nfd", "1");
					resp.sendRedirect("studentQuizMainSection.jsp");
				}
			}else {
				ss.setAttribute("nfd", "1");
				resp.sendRedirect("studentQuizMainSection.jsp");
			}
		} catch (Exception e) {
			System.out.println("Exception at UnlockQuizzes : "+e);
			ss.setAttribute("error", "1");
			resp.sendRedirect("studentQuizMainSection.jsp");
		}
	}
}
