package quiz;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns = { "/EditQuiz" })
public class EditQuiz extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		boolean flag = true;
		ResultSet rs;
		HttpSession sess = req.getSession(false);
		int quizid = Integer.parseInt(req.getParameter("id"));

		String code = "a_b";
		
		String title = req.getParameter("title");
		String inst = req.getParameter("inst");
		String timelineSelect = req.getParameter("timelineSelect");
		String from = req.getParameter("from");
		String to = req.getParameter("to");
		String toInfinity = req.getParameter("toInfinity");
		String attemptsSelect = req.getParameter("attemptsSelect");
		String attempts = req.getParameter("attempts");
		String webcam = req.getParameter("webcam");
		

		ValidateMainQuiz mq = new ValidateMainQuiz();

		flag = mq.validateTitle(title.trim()) && mq.validateInst(inst.trim());

		if (timelineSelect.equals("1")) {
			flag = flag && mq.validateFromTimeline(from);
			System.out.println(flag);
			if (toInfinity == null) {
				System.out.println(toInfinity);
				flag = flag && mq.validateToTimeline(to);
				System.out.println(flag);
			}
		}

		if (attemptsSelect.equals("1")) {
			flag = flag && mq.validateAttempts(attempts);
			System.out.println(flag);
		}

		
		// validation failed
		if (flag == false) {
			sess.setAttribute("noValidEdit", "1");
			resp.sendRedirect("educatorQuizSubSection1.jsp?qzid=" + new DataHiding().encodeMethod(String.valueOf(quizid)));

		} else {
			// validation succeed insert the values

			try {
				String query = "update mainquiz set title=?,inst=?,timeline=?,fromtime=?,totime=?,ava=?,attempts=?,webcam=? where quizid=?";

				ps = conn.prepareStatement(query);

				ps.setString(1, req.getParameter("title"));
				ps.setString(2, req.getParameter("inst"));

				if (req.getParameter("timelineSelect").equals("0")) {
					ps.setBoolean(3, false);
					ps.setString(4, null);
					ps.setString(5, null);

				} else {
					ps.setBoolean(3, true);

					ps.setString(4, req.getParameter("from"));
					System.out.println(req.getParameter("from"));

					System.out.println(req.getParameter("to"));
					if (req.getParameter("to") == null) {
						ps.setString(5, null);
					} else {
						ps.setString(5, req.getParameter("to"));
					}
				}

				

				if (req.getParameter("attemptsSelect").equals("1")) {
					ps.setInt(7, Integer.parseInt(req.getParameter("attempts")));
				} else {
					ps.setInt(7, -1);
				}
				// true for public and false for private
				if (req.getParameter("ava").equals("1")) {
					ps.setBoolean(6, true);
					flag = true;
				} else {
					ps.setBoolean(6, false);
					flag = false;
				}

				if(webcam.equals("1")) {
					ps.setBoolean(8, true);
				}else {
					ps.setBoolean(8, false);
				}
				
				ps.setInt(9, quizid);

				if (ps.executeUpdate() > 0) {

					query = "select code from mainquiz where quizid=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, quizid);

					rs = ps.executeQuery();
					rs.next();
					System.out.println();

					//if code is null but quiz is made private
					if (rs.getString("code") == null && flag == false) {
						code = code + quizid;
						query = "update mainquiz set code=? where quizid=?";

						ps = conn.prepareStatement(query);
						ps.setString(1, code);
						ps.setInt(2, quizid);

						if (ps.executeUpdate() > 0) {
							sess.setAttribute("success", "2");
							resp.sendRedirect("educatorQuizSubSection1.jsp?qzid=" + 
							new DataHiding().encodeMethod(String.valueOf(quizid))+"&cd=" + code);
							
						} else {
							sess.setAttribute("error", "1");
							resp.sendRedirect("educatorQuizSubSection1.jsp?qzid=" + 
							new DataHiding().encodeMethod(String.valueOf(quizid)));
						}

						//if code is not null and quiz is made public
					} else if (rs.getString("code") != null && flag == true) {

						query = "update mainquiz set code=? where quizid=?";
						ps = null;
						ps = conn.prepareStatement(query);
						ps.setString(1, null);
						ps.setInt(2, quizid);

						if (ps.executeUpdate() > 0) {
							sess.setAttribute("success", "2");
							resp.sendRedirect("educatorQuizSubSection1.jsp?qzid=" + 
							new DataHiding().encodeMethod(String.valueOf(quizid)));
						} else {
							sess.setAttribute("error", "1");
							resp.sendRedirect("educatorQuizSubSection1.jsp?qzid=" + 
							new DataHiding().encodeMethod(String.valueOf(quizid)));
						}
					} else {
						sess.setAttribute("success", "2");
						resp.sendRedirect("educatorQuizSubSection1.jsp?qzid=" + 
						new DataHiding().encodeMethod(String.valueOf(quizid)));
					}
				}
			} catch (Exception e) {
				System.out.println("Exception at EditQuiz : " + e);
				e.printStackTrace();
				sess.setAttribute("error", "1");
				resp.sendRedirect("educatorQuizSubSection1.jsp?qzid=" + 
				new DataHiding().encodeMethod(String.valueOf(quizid)));
			} finally {
				conn = null;
				ps = null;
				rs = null;
			}
		}
	}
}
