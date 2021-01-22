package assignment;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;

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

@WebServlet(urlPatterns = { "/GradeAssignment" })
@MultipartConfig(maxFileSize = 567898989)
public class GradeAssignment extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int asgid = Integer.parseInt(req.getParameter("asgId"));
		int std_id = Integer.parseInt(req.getParameter("stdId"));
		HttpSession sess = req.getSession(false);
		String marks = req.getParameter("altmarks");

		String query = "";

		String fileNames = "";
		String extensions = "";
		String name;
		String extension;
		String paths = "";
		int no_of_files;
		ValidateAssignment va = new ValidateAssignment();

		// validate the assignment form
		boolean flag = va.validateMarks(marks);
		
		int count = 0;
		// validate the file
		if (req.getParameter("returnFilesConfirm").equals("1")) {
			
			for (Part part : req.getParts()) {
				// System.out.println(part);
				name = FileOperations.extractFileName(part);
				// System.out.println(name);
				if (name.equals("")) {
					continue;
				}
				// System.out.println(part.getSize());
				count++;
				System.out.println("hii");
				if (part.getSize() <= 0) {
					flag = false;

					System.out.println("false");
					break;
				}
			}

		}else {
			count=1;
		}

		if (count == 0)
			flag = false;

		if (flag == false) {
			// if validation fails go back
			sess.setAttribute("noValidGrade", "1");
			SubmissionBean bean = new SubmissionBean();
			bean.setStd_id(std_id);
			sess.setAttribute("bean", bean);

			resp.sendRedirect(
					"assignmentSubmissions.jsp?asgid=" + new DataHiding().encodeMethod(String.valueOf(asgid)));

		} else {
			// validation succeed grade the assignment as per requirements
			String path = "H:\\java\\EduHITec\\WebContent\\assignmentSubmissionReturnedFiles\\";

			query = "update asgmnsubmissions set marks=?,feedback=?,"
					+ "ret_no_of_files=?,ret_path=?,ret_orgnames=?,ret_extensions=? where asgid=? and std_id=?";

			Connection conn = EduHITecDb.getConnection();

			try {
				PreparedStatement ps = conn.prepareStatement(query);
				ps.setInt(1, Integer.parseInt(req.getParameter("altmarks")));

				if (req.getParameter("feedback").equals("")) {
					ps.setString(2, null);
				} else {
					ps.setString(2, req.getParameter("feedback"));
				}

				ps.setInt(7, asgid);
				ps.setInt(8, std_id);

				if (req.getParameter("returnFilesConfirm").equals("1")) {
					no_of_files = 1;

					// separating parts into files and getting original name and extensions

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
								path + "EduHITec_submission_" + std_id + asgid + no_of_files + "." + extension);
						while ((i = file.read()) != -1) {
							writer.write((char) i);
						}
						file.close();
						writer.close();
						if (no_of_files == 1)
							paths = paths + path + "EduHITec_submission_" + std_id + asgid + no_of_files + "."
									+ extension;
						else
							paths = paths + "#" + path + "EduHITec_submission_" + std_id + asgid + no_of_files + "."
									+ extension;
						no_of_files++;
					}
					ps.setInt(3, no_of_files - 1);
					ps.setString(4, paths);
					ps.setString(5, fileNames);
					ps.setString(6, extensions);

				} else {
					ps.setInt(3, -1);
					ps.setString(4, null);
					ps.setString(5, null);
					ps.setString(6, null);
				}

				if (ps.executeUpdate() > 0) {
					sess.setAttribute("success", "1");
					resp.sendRedirect(
							"assignmentSubmissions.jsp?asgid=" + new DataHiding().encodeMethod(String.valueOf(asgid)));
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect(
							"assignmentSubmissions.jsp?asgid=" + new DataHiding().encodeMethod(String.valueOf(asgid)));
				}
			} catch (Exception e) {
				System.out.println("exception at GradeAsssignment : " + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect(
						"assignmentSubmissions.jsp?asgid=" + new DataHiding().encodeMethod(String.valueOf(asgid)));
			}
		}
	}
}
