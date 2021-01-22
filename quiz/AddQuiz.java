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

@WebServlet(urlPatterns = { "/AddQuiz" })
public class AddQuiz extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		boolean flag = true;
		HttpSession sess = req.getSession(false);

		ResultSet rs;

		String code = "a_b";
		String id = req.getParameter("id");
		String title = req.getParameter("title");
		String inst = req.getParameter("inst");
		String timelineSelect = req.getParameter("timelineSelect");
		String from = req.getParameter("from");
		String to = req.getParameter("to");
		String toInfinity = req.getParameter("toInfinity");
		String attemptsSelect = req.getParameter("attemptsSelect");
		String attempts = req.getParameter("attempts");
		String timer = req.getParameter("timer");
		String overalltimer = req.getParameter("overalltimer");
		String webcam = req.getParameter("webcam");
		
		ValidateMainQuiz mq = new ValidateMainQuiz();

		flag = mq.validateTitle(title) && mq.validateInst(inst);

		if (timelineSelect.equals("1")) {
			flag = mq.validateFromTimeline(from);
			System.out.println(flag);
			if (toInfinity == null) {
				System.out.println(toInfinity);
				flag = mq.validateToTimeline(to);
				System.out.println(flag);
			}
		}

		if (attemptsSelect.equals("1")) {
			flag = mq.validateAttempts(attempts);
			System.out.println(flag);
		}

		if (timer.equals("1")) {
			flag = mq.validateOverallTimer(overalltimer);
			System.out.println(flag);
		}

		// validation failed
		if (flag == false) {
			sess.setAttribute("noValidAdd", "1");
			resp.sendRedirect("educatorQuizSection.jsp?qmid=" + new DataHiding().encodeMethod(id));
			
		} else {
				//validation succeed insert the values
			try {
				String query = "insert into mainquiz(qmid,title,inst,timeline,fromtime,totime,ava,timer,attempts,overalltimer,webcam)values(?,?,?,?,?,?,?,?,?,?,?)";

				ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);

				ps.setInt(1, Integer.parseInt(req.getParameter("id")));
				ps.setString(2, title.trim());
				ps.setString(3, inst.trim());
				
				//webcam is enabled
				if(webcam.equals("1")) {
					System.out.println("webcam enabled");
					ps.setBoolean(11, true);
				}else {
					ps.setBoolean(11, false);
				}

				if (timelineSelect.equals("0")) {
					ps.setBoolean(4, false);
					ps.setString(5, null);
					ps.setString(6, null);

				} else {
					ps.setBoolean(4, true);

					ps.setString(5, req.getParameter("from").trim());
					System.out.println(req.getParameter("from"));

					System.out.println(req.getParameter("to"));
					if (req.getParameter("to") == null) {
						ps.setString(6, null);
					} else {
						ps.setString(6, req.getParameter("to").trim());
					}
				}

				ps.setInt(8, Integer.parseInt(req.getParameter("timer").trim()));
				if (req.getParameter("timer").equals("1")) {
					ps.setInt(10, Integer.parseInt(req.getParameter("overalltimer")));
				} else {
					ps.setInt(10, -1);
				}

				if (req.getParameter("attemptsSelect").equals("1")) {
					ps.setInt(9, Integer.parseInt(req.getParameter("attempts").trim()));
				} else {
					ps.setInt(9, -1);
				}
				// true for public and false for private
				if (req.getParameter("ava").equals("1")) {
					ps.setBoolean(7, true);
					flag = false;
				} else {
					ps.setBoolean(7, false);
				}

				if (ps.executeUpdate() > 0) {
					rs = ps.getGeneratedKeys();

					if (flag) {
						if (rs.next()) {
							code = code + rs.getInt(1);
							query = "update mainquiz set code=? where quizid=?";

							ps = conn.prepareStatement(query);
							ps.setString(1, code);
							ps.setInt(2, rs.getInt(1));

							if (ps.executeUpdate() > 0) {
								sess.setAttribute("success", "1");
								resp.sendRedirect("educatorQuizSection.jsp?qmid=" + new DataHiding().encodeMethod(id)+"&cd=" + code);
								
							} else {
								sess.setAttribute("error", "1");
								resp.sendRedirect("educatorQuizSection.jsp?qmid=" + new DataHiding().encodeMethod(id));
								
							}
						} else {
							sess.setAttribute("error", "1");
							resp.sendRedirect("educatorQuizSection.jsp?qmid=" + new DataHiding().encodeMethod(id));
							
						}
					} else {
						sess.setAttribute("success", "1");
						resp.sendRedirect("educatorQuizSection.jsp?qmid=" + new DataHiding().encodeMethod(id));
						
					}
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("educatorQuizSection.jsp?qmid=" + new DataHiding().encodeMethod(id));
					
				}
			} catch (Exception e) {
				sess.setAttribute("error", "1");
				System.out.println("Exception at AddQuiz : " + e);
				resp.sendRedirect("educatorQuizSection.jsp?qmid=" + new DataHiding().encodeMethod(id));
				
			} finally {
				conn = null;
				ps = null;
				rs = null;
			}
		}
	}
}
