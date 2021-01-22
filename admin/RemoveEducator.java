package admin;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.mail.Session;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;

@WebServlet(urlPatterns = { "/RemoveEducator" })
public class RemoveEducator extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		HttpSession session = req.getSession(false);
		String query;
		int edu_id = Integer.parseInt(req.getParameter("id"));
		String removeContent = req.getParameter("removeContent");
		boolean flag = true;

		System.out.println(removeContent);
		PreparedStatement ps;
		ResultSet rs, rs1, rs2;
		try {
			// check logged in is true or not
			query = "select loggedIn from educator where loggedIn=? and edu_id=?";
			ps = conn.prepareStatement(query);
			ps.setBoolean(1, true);
			ps.setInt(2, edu_id);
			rs = ps.executeQuery();

			if (rs.next()) {
				session.setAttribute("logEduRemove", "1");
				resp.sendRedirect("check_Educators.jsp");
			} else {
				// if remove content is checked then delete all the content of this educator
				if (removeContent != null) {
					// first remove all the video playlist of this educator
					query = "select uni_id from videoplaylist where edu_id=?";
					ps = conn.prepareStatement(query);

					ps.setInt(1, edu_id);

					rs = ps.executeQuery();

					while (rs.next()) {
						// now deleting the playlist one by one

						// delete all the video associated to this playlist
						query = "delete from playlistvideos where uni_id=?";

						ps = conn.prepareStatement(query);
						ps.setInt(1, rs.getInt("uni_id"));

						ps.executeUpdate();
					}

					// now delete the playlist
					query = "delete from videoplaylist where edu_id=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, edu_id);

					ps.executeUpdate();

					// now removing the notes playlist
					query = "select npid from notessubject where edu_id=?";
					ps = conn.prepareStatement(query);

					ps.setInt(1, edu_id);

					rs = ps.executeQuery();

					while (rs.next()) {
						// deleting all the notes of this list
						query = "select * from subjectnotes where npid=?";
						ps = conn.prepareStatement(query);
						ps.setInt(1, rs.getInt("npid"));

						rs1 = ps.executeQuery();

						// deleting all the files stored
						while (rs1.next()) {
							String path = rs1.getString("path");
							File f = new File(path);
							f.delete();
						}

						query = "delete from subjectnotes where npid=?";
						ps = conn.prepareStatement(query);

						ps.setInt(1, rs.getInt("npid"));
						ps.executeUpdate();
					}

					// now delete all the notes list finally
					query = "delete from notessubject where edu_id=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, edu_id);

					ps.executeUpdate();

					// now delete the assignment playlist
					query = "select amid from assignmentmainlist where edu_id=?";
					ps = conn.prepareStatement(query);

					ps.setInt(1, edu_id);

					rs = ps.executeQuery();

					while (rs.next()) {
						// first getting all the files
						String query1 = "select * from mainlistassignments where amid=?";
						ps = conn.prepareStatement(query1);
						ps.setInt(1, rs.getInt("amid"));

						ResultSet set = ps.executeQuery();
						// deleting all the files
						while (set.next()) {
							String[] paths = set.getString("path").split("#");
							for (int i = 0; i < paths.length; i++) {
								File f = new File(paths[i]);
								f.delete();
							}

							// delete from unlock assignment too
							query1 = "delete from unlockedassignment where asgid=?";
							ps = conn.prepareStatement(query1);

							ps.setInt(1, set.getInt("asgid"));

							ps.executeUpdate();

							// delete all the submissions too
							query1 = "select * from asgmnsubmissions where asgid=?";
							ps = conn.prepareStatement(query1);

							ps.setInt(1, set.getInt("asgid"));

							ResultSet set1 = ps.executeQuery();

							if (set1.next()) {
								// delete submisssion files
								paths = set1.getString("path").split("#");
								for (int i = 0; i < paths.length; i++) {
									File f = new File(paths[i]);
									f.delete();
								}

								// if returned file then delete it
								if (set1.getString("ret_path") != null) {
									paths = set1.getString("ret_path").split("#");
									for (int i = 0; i < paths.length; i++) {
										File f = new File(paths[i]);
										f.delete();
									}
								}
							}
						}

					}
					query = "delete from assignmentmainlist where edu_id=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, edu_id);

					ps.executeUpdate();

					// now delete the quiz
					query = "select qmid from quizmainlist where edu_id=?";
					ps = conn.prepareStatement(query);

					ps.setInt(1, edu_id);

					rs = ps.executeQuery();

					while (rs.next()) {
						// first select all the quizzes of this list
						query = "select quizid from mainquiz where qmid=?";
						ps = conn.prepareStatement(query);
						ps.setInt(1, rs.getInt("qmid"));

						rs1 = ps.executeQuery();

						while (rs1.next()) {
							// first delete all the attempts made on this quiz

							query = "delete from quiz_attempts where quizid=?";
							ps = conn.prepareStatement(query);
							ps.setInt(1, rs1.getInt("quizid"));

							ps.executeUpdate();

							// now get review id for this quiz

							query = "select review_id from quizreview where quizid=?";
							ps = conn.prepareStatement(query);
							ps.setInt(1, rs1.getInt("quizid"));

							rs2 = ps.executeQuery();

							while (rs2.next()) {
								// now delete studentquizreview based on id

								query = "delete from studentquizreview where review_id=?";
								ps = conn.prepareStatement(query);
								ps.setInt(1, rs2.getInt("review_id"));

								ps.executeUpdate();
							}

							// now delete quiz review of this quiz
							query = "delete from quizreview where quizid=?";
							ps = conn.prepareStatement(query);
							ps.setInt(1, rs1.getInt("quizid"));

							ps.executeUpdate();

							// now delete this quiz data from unlocked quizzes
							query = "delete from unlockedquizzes where quizid=?";
							ps = conn.prepareStatement(query);
							ps.setInt(1, rs1.getInt("quizid"));

							ps.executeUpdate();

							// now delete ques ans of these quizzes

							query = "select quesAttAbslPath,optionsAttAbslPath from quesans where quizid=?";
							ps = conn.prepareStatement(query);

							ps.setInt(1, rs1.getInt("quizid"));

							rs2 = ps.executeQuery();

							while (rs2.next()) {
								// first delete all the files

								if (rs2.getString("quesAttAbslPath") != null) {
									String[] paths = rs2.getString("quesAttAbslPath").split("#");
									for (int i = 0; i < paths.length; i++) {
										File f = new File(paths[i]);
										f.delete();
									}
								}

								if (rs2.getString("optionsAttAbslPath") != null) {
									String[] paths = rs2.getString("optionsAttAbslPath").split("#");
									for (int i = 0; i < paths.length; i++) {
										File f = new File(paths[i]);
										f.delete();
									}
								}

							}
							// now delete all the questions
							query = "delete from quesans where quizid=?";
							ps = conn.prepareStatement(query);
							ps.setInt(1, rs1.getInt("quizid"));

							ps.executeUpdate();

							// finally delete the quiz
							query = "delete from mainquiz where quizid=?";
							ps = conn.prepareStatement(query);
							ps.setInt(1, rs1.getInt("quizid"));

							ps.executeUpdate();

						}
					}

					// finally remove all quiz list
					query = "delete from quizmainlist where edu_id=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, edu_id);

					ps.executeUpdate();
				}
				// delete from educator table
				query = "delete from educator where edu_id=?";
				ps = conn.prepareStatement(query);

				ps.setInt(1, edu_id);

				if (ps.executeUpdate() > 0) {
					session.setAttribute("success", "1");
					resp.sendRedirect("check_Educators.jsp");
				} else {
					throw new Exception("Educator Not Found");
				}
			}
		} catch (Exception e) {
			System.out.println("Exception at RemoveEducator() : " + e);
			session.setAttribute("error", "1");
			resp.sendRedirect("check_Educators.jsp");

		} finally {
			conn = null;
		}
	}
}
