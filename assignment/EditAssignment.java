package assignment;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import connnection.EduHITecDb;
import file.FileOperations;
import hide.DataHiding;

@WebServlet(urlPatterns = { "/EditAssignment" })
@MultipartConfig(maxFileSize = 567898989)
public class EditAssignment extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String query = "";
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;

		String code = "a_";
		String fileNames = "";
		String extensions = "";
		String name;
		String extension;
		String paths = "";
		int no_of_files;
		String path = "H:\\java\\EduHITec\\WebContent\\assignment\\";
		ValidateAssignment va = new ValidateAssignment();

		String title = req.getParameter("title").trim();
		String inst = req.getParameter("inst").trim();
		String deadline = req.getParameter("deadline");
		String marks = req.getParameter("marks");
		String asgid = req.getParameter("Easgid");
		String amid = req.getParameter("Eampid");
		boolean flag = true;
		flag = va.validateInst(inst) && va.validateMarks(marks) && va.validateTitle(title);

		HttpSession sess = req.getSession(false);

		try {
			// when only title desp and marks are changed only
			if (req.getParameter("changedeadline").equalsIgnoreCase("no")
					&& req.getParameter("changefile").equalsIgnoreCase("no")) {

				if (flag == false) {
					// if validation fails go back
					sess.setAttribute("noValidEdit", "1");
					MainListAssignmentsBean bean = new MainListAssignmentsBean();
					bean.setTitle(title);
					bean.setDeadline(deadline);
					bean.setAsgid(Integer.parseInt(asgid));
					bean.setInstructions(inst);
					if (marks != null && marks.equals("") == false)
						bean.setMarks(Integer.parseInt(marks));
					else
						bean.setMarks(-1);
					System.out.println(bean.getTitle());
					System.out.println(bean.getDeadline());

					sess.setAttribute("bean", bean);
					resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
				} else {
					// validation succeed update the record
					query = "update mainlistassignments set instructions=?, title=?,marks=? where asgid=?";
					ps = conn.prepareStatement(query);

					ps.setString(1, req.getParameter("inst"));
					ps.setString(2, req.getParameter("title"));
					ps.setInt(3, Integer.parseInt(req.getParameter("marks")));
					ps.setInt(4, Integer.parseInt(req.getParameter("Easgid")));

					if (ps.executeUpdate() > 0) {
						sess.setAttribute("success", "2");
						resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
					}
				}
			} else if (req.getParameter("changedeadline").equalsIgnoreCase("no")
					&& req.getParameter("changefile").equalsIgnoreCase("yes")) {
				// if files are changed then do this

				// validate the files
				int count = 0;
				for (Part part : req.getParts()) {
//					System.out.println(part);
					name = FileOperations.extractFileName(part);
//					System.out.println(name);
					if (name.equals("")) {
						continue;
					}
//					System.out.println(part.getSize());
					
					count++;
					if (part.getSize() <= 0) {
						flag = false;
						
						System.out.println("false");
						break;
					}
				}
				
				if(count == 0)
					flag = false;

				if (flag == false) {
					// if validation fails go back
					sess.setAttribute("noValidEdit", "1");
					MainListAssignmentsBean bean = new MainListAssignmentsBean();
					bean.setTitle(title);
					bean.setDeadline(deadline);
					bean.setAsgid(Integer.parseInt(asgid));
					bean.setInstructions(inst);
					if (marks != null && marks.equals("") == false)
						bean.setMarks(Integer.parseInt(marks));
					else
						bean.setMarks(-1);
					System.out.println(bean.getTitle());
					System.out.println(bean.getDeadline());

					sess.setAttribute("bean", bean);
					resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));

				} else {

					// validation succeed update the record
					query = "select * from mainlistassignments where asgid=?";
					ps = conn.prepareStatement(query);

					ps.setInt(1, Integer.parseInt(req.getParameter("Easgid")));

					ResultSet set = ps.executeQuery();

					// updating the files
					if (set.next()) {
						String[] filepath = set.getString("path").split("#");

						for (int i = 0; i < filepath.length; i++) {
							File f = new File(filepath[i]);
							f.delete();
						}

						int id = Integer.parseInt(req.getParameter("Easgid"));

						no_of_files = 1;
						for (Part part : req.getParts()) {
							name = FileOperations.extractFileName(part);
							if (name.equals("")) {
								continue;
							}
							if (no_of_files == 1)
								fileNames = fileNames + name;
							else
								fileNames = fileNames + "/" + name;

							extension = FileOperations.getExtension(name);
							if (no_of_files == 1)
								extensions = extensions + extension;
							else
								extensions = extensions + "/" + extension;
							InputStream file = part.getInputStream();

							int i = 0;
							FileOutputStream writer = new FileOutputStream(
									path + "EduHItec_assignment_" + id + no_of_files + "." + extension);
							while ((i = file.read()) != -1) {
								writer.write((char) i);
							}
							file.close();
							writer.close();
							if (no_of_files == 1)
								paths = paths + path + "EduHItec_assignment_" + id + no_of_files + "." + extension;
							else
								paths = paths + "#" + path + "EduHItec_assignment_" + id + no_of_files + "."
										+ extension;
							no_of_files++;
						}

						query = "update mainlistassignments set instructions=?,title=?,marks=?,path=?,no_of_files=?,extensions=?,orgnames=? where asgid=?";
						ps = conn.prepareStatement(query);

						ps.setString(1, req.getParameter("inst"));
						ps.setString(2, req.getParameter("title"));
						ps.setInt(3, Integer.parseInt(req.getParameter("marks")));
						ps.setString(4, paths);
						ps.setInt(5, no_of_files - 1);
						ps.setString(6, extensions);
						ps.setString(7, fileNames);
						ps.setInt(8, Integer.parseInt(req.getParameter("Easgid")));

						if (ps.executeUpdate() > 0) {
							sess.setAttribute("success", "2");
							resp.sendRedirect(
									"educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
						} else {
							sess.setAttribute("error", "1");
							resp.sendRedirect(
									"educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
						}

					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
					}
				}
			} else if (req.getParameter("changedeadline").equalsIgnoreCase("yes")
					&& req.getParameter("changefile").equalsIgnoreCase("no")) {

				// now deadline is changed but files not

				if (flag == false) {
					// if validation fails go back
					sess.setAttribute("noValidEdit", "1");
					MainListAssignmentsBean bean = new MainListAssignmentsBean();
					bean.setTitle(title);
					bean.setDeadline(deadline);
					bean.setAsgid(Integer.parseInt(asgid));
					bean.setInstructions(inst);
					if (marks != null && marks.equals("") == false)
						bean.setMarks(Integer.parseInt(marks));
					else
						bean.setMarks(-1);
					System.out.println(bean.getTitle());
					System.out.println(bean.getDeadline());

					sess.setAttribute("bean", bean);
					resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));

				} else {

					query = "update mainlistassignments set instructions=?,deadline=?,title=?,marks=? where asgid=?";
					ps = conn.prepareStatement(query);

					ps.setString(1, req.getParameter("inst"));
					ps.setString(2, req.getParameter("deadline"));
					ps.setString(3, req.getParameter("title"));
					ps.setInt(4, Integer.parseInt(req.getParameter("marks")));
					ps.setInt(5, Integer.parseInt(req.getParameter("Easgid")));

					if (ps.executeUpdate() > 0) {
						sess.setAttribute("success", "2");
						resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
					}
				}

			} else {

				// both files and deadlines are changed
				// validate the files
				int count = 0;
				for (Part part : req.getParts()) {
//					System.out.println(part);
					name = FileOperations.extractFileName(part);
//					System.out.println(name);
					if (name.equals("")) {
						continue;
					}
//					System.out.println(part.getSize());
					count++;
					
					if (part.getSize() <= 0) {
						flag = false;
						
						System.out.println("false");
						break;
					}
				}
				
				if(count == 0)
					flag = false;

				if (flag == false) {
					// if validation fails go back
					sess.setAttribute("noValidEdit", "1");
					MainListAssignmentsBean bean = new MainListAssignmentsBean();
					bean.setTitle(title);
					bean.setDeadline(deadline);
					bean.setAsgid(Integer.parseInt(asgid));
					bean.setInstructions(inst);
					if (marks != null && marks.equals("") == false)
						bean.setMarks(Integer.parseInt(marks));
					else
						bean.setMarks(-1);
					System.out.println(bean.getTitle());
					System.out.println(bean.getDeadline());

					sess.setAttribute("bean", bean);
					resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
				} else {

					query = "select * from mainlistassignments where asgid=?";
					ps = conn.prepareStatement(query);

					ps.setInt(1, Integer.parseInt(req.getParameter("Easgid")));

					ResultSet set = ps.executeQuery();
						
					//update the files 
					if (set.next()) {
						String[] filepath = set.getString("path").split("#");

						for (int i = 0; i < filepath.length; i++) {
							File f = new File(filepath[i]);
							f.delete();
						}

						int id = Integer.parseInt(req.getParameter("Easgid"));

						no_of_files = 1;
						for (Part part : req.getParts()) {
							name = FileOperations.extractFileName(part);
							if (name.equals("")) {
								continue;
							}
							if (no_of_files == 1)
								fileNames = fileNames + name;
							else
								fileNames = fileNames + "/" + name;

							extension = FileOperations.getExtension(name);
							if (no_of_files == 1)
								extensions = extensions + extension;
							else
								extensions = extensions + "/" + extension;
							InputStream file = part.getInputStream();

							int i = 0;
							FileOutputStream writer = new FileOutputStream(
									path + "EduHItec_assignment_" + id + no_of_files + "." + extension);
							while ((i = file.read()) != -1) {
								writer.write((char) i);
							}
							file.close();
							writer.close();
							if (no_of_files == 1)
								paths = paths + path + "EduHItec_assignment_" + id + no_of_files + "." + extension;
							else
								paths = paths + "#" + path + "EduHItec_assignment_" + id + no_of_files + "."
										+ extension;
							no_of_files++;
						}

						query = "update mainlistassignments set instructions=?,deadline=?,title=?,marks=?,path=?,no_of_files=?,extensions=?,orgnames=? where asgid=?";
						ps = conn.prepareStatement(query);

						ps.setString(1, req.getParameter("inst"));
						ps.setString(2, req.getParameter("deadline"));
						ps.setString(3, req.getParameter("title"));
						ps.setInt(4, Integer.parseInt(req.getParameter("marks")));
						ps.setString(5, paths);
						ps.setInt(6, no_of_files - 1);
						ps.setString(7, extensions);
						ps.setString(8, fileNames);
						ps.setInt(9, Integer.parseInt(req.getParameter("Easgid")));

						if (ps.executeUpdate() > 0) {
							sess.setAttribute("success", "2");
							resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
						} else {
							sess.setAttribute("error", "1");
							resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
						}
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
					}
				}
			}
		} catch (Exception e) {
			System.out.println("Exception at EditAssignment: " + e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
		}
	}
}
