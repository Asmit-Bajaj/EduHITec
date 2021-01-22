package quiz;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns = { "/ComputeMarks" })
public class ComputeMarks extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int qzid = Integer.parseInt(req.getParameter("qzid"));
		String ans;
		String[] acc_ans;
		String review_ans = "";
		int std_id = (Integer) req.getSession(false).getAttribute("std_id");
		double marks_obt = 0;
		ResultSet set = null;
		int review_id = 0;
		int total_marks = 0;
		//new quizDao().releaseLock(qzid);

		String query = "insert into quizreview(std_id, quizid, date)values(?,?,now())";
		PreparedStatement ps = null;
		Connection conn = EduHITecDb.getConnection();

		try {
			ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);

			ps.setInt(1, std_id);
			ps.setInt(2, qzid);

			if (ps.executeUpdate() > 0) {
				set = ps.getGeneratedKeys();
				set.next();
				review_id = set.getInt(1);
			}

			int flag = 0;

			ArrayList<QuesAns> list = new quizDao().getQuesAns(qzid);

			// 1 means haven't ans 2 means given wrong ans 3 means correct ans 4 means
			// manual check
			for (int i = 1; i <= list.size(); i++) {
				flag = 2;
				if (req.getParameter("QuesType" + i).equals("2")) {
					ans = req.getParameter("ans" + i);
					if (ans.equals("")) {
						if (list.get(i - 1).isManualCheck()) {
							flag = 4;
						} else {
							flag = 1;
						}
					} else {
						// if manual check exist then set flag to 4 that is manual check
						if (list.get(i - 1).isManualCheck()) {
							flag = 4;
						} else {
							// if manual check is false then check the answer against the given keywords
							acc_ans = list.get(i - 1).getFillBlAns().split("\\|");

							for (String each_ans : acc_ans) {
								System.out.println("ans = " + ans);
								System.out.println("each_ans = " + each_ans);
								if (each_ans.equalsIgnoreCase(ans)) {
									flag = 3;
									break;
								}
							}
						}
					}

					query = "insert into studentquizreview(review_id, quesid, ans_given, marks_obt)values(?,?,?,?)";

					ps = conn.prepareStatement(query);

					ps.setInt(1, review_id);
					ps.setInt(2, list.get(i - 1).getQuesid());
					ps.setString(3, ans);
					
					if(flag == 4) {
						//NA means need manual check
						ps.setString(4, "NA");
					}else if (flag == 2) {
						if (list.get(i - 1).getNeg_marking() != -1) {
							// System.out.println("neg :
							// "+((list.get(i-1).getMarks()*list.get(i-1).getNeg_marking())/100));
							marks_obt = marks_obt
									- ((double) (list.get(i - 1).getMarks() * list.get(i - 1).getNeg_marking()) / 100);
							ps.setString(4, "-"
									+ ((double) (list.get(i - 1).getMarks() * list.get(i - 1).getNeg_marking()) / 100));
						} else {
							ps.setString(4, "0");
						}
					} else if (flag == 3) {
						marks_obt = marks_obt + list.get(i - 1).getMarks();
						ps.setString(4, "" + list.get(i - 1).getMarks());
					} else {
						ps.setString(4, "0");
					}

					ps.executeUpdate();

				} else {
					ans = req.getParameter("ans" + i);

					if (ans == null) {
						ans = "";
						flag = 1;
					} else {
						if (ans.equals(list.get(i - 1).getOptionsAns())) {
							flag = 3;
						} else {
							flag = 2;
						}
					}

					query = "insert into studentquizreview(review_id, quesid, ans_given, marks_obt)values(?,?,?,?)";

					ps = conn.prepareStatement(query);

					ps.setInt(1, review_id);
					ps.setInt(2, list.get(i - 1).getQuesid());
					ps.setString(3, ans);

					if (flag == 2) {
						if (list.get(i - 1).getNeg_marking() != -1) {
							// System.out.println("neg :
							// "+(double)((list.get(i-1).getMarks()*list.get(i-1).getNeg_marking())/100));
							marks_obt = marks_obt
									- ((double) (list.get(i - 1).getMarks() * list.get(i - 1).getNeg_marking()) / 100);
							ps.setString(4, "-"
									+ ((double) (list.get(i - 1).getMarks() * list.get(i - 1).getNeg_marking()) / 100));
						} else {
							ps.setString(4, "0");
						}
					} else if (flag == 3) {
						marks_obt = marks_obt + list.get(i - 1).getMarks();
						ps.setString(4, "" + list.get(i - 1).getMarks());
					} else {
						ps.setString(4, "0");
					}
					System.out.println("marks = " + marks_obt);
					ps.executeUpdate();
				}
				total_marks += list.get(i - 1).getMarks();
			}

			query = "update quizreview set obt_marks = ?,total_marks=? where review_id = ?";

			ps = conn.prepareStatement(query);
			ps.setString(1, "" + marks_obt);
			ps.setString(2, "" + total_marks);
			ps.setInt(3, review_id);

			if (ps.executeUpdate() > 0) {
				if (new quizDao().updateAttemptCount(qzid, std_id))
					resp.sendRedirect("showQuizObtMarks.jsp?m=" + marks_obt + "&tot=" + total_marks+"&qzid="+new DataHiding().encodeMethod(""+qzid));
				else
					resp.sendRedirect("showQuizObtMarks.jsp?error=1"+"&qzid="+new DataHiding().encodeMethod(""+qzid));
			} else {
				resp.sendRedirect("showQuizObtMarks.jsp?error=1"+"&qzid="+new DataHiding().encodeMethod(""+qzid));
			}
		} catch (Exception e) {
			System.out.println("exception at ComputeMarks : " + e);
			e.printStackTrace();
			resp.sendRedirect("showQuizObtMarks.jsp?error=1"+"&qzid="+new DataHiding().encodeMethod(""+qzid));
		} finally {
			conn = null;
			set = null;
			ps = null;
		}

	}
}
