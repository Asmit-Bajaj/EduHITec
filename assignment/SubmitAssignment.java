package assignment;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

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

@WebServlet(urlPatterns = { "/SubmitAssignment" })
@MultipartConfig(maxFileSize = 567898989)
public class SubmitAssignment extends HttpServlet {

	String path = "H:\\java\\EduHITec\\WebContent\\assignSubmission\\";

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		String fileNames = "";
		String extensions = "";
		String name;
		String extension;
		String paths = "";
		int no_of_files;

		HttpSession sess = req.getSession(false);
		int std_id = (Integer) sess.getAttribute("std_id");
		int asgid = Integer.parseInt(req.getParameter("asgid"));

		int count = 0;
		boolean flag = true;

		for (Part part : req.getParts()) {
			// System.out.println(part);
			name = FileOperations.extractFileName(part);
			// System.out.println(name);
			if (name.equals("")) {
				continue;
			}
			// System.out.println(part.getSize());
			count++;

			if (part.getSize() <= 0) {
				flag = false;
				System.out.println("false");
				break;
			}
		}
		
		if(count == 0)
			flag = false;

		// if files are empty then return back
		if (flag == false) {
			System.out.println(count);
			sess.setAttribute("novalidFilesAdd", "1");
			
			resp.sendRedirect("studentAssignmentSubSection.jsp?asgid="+new DataHiding().encodeMethod(String.valueOf(asgid))+"&name=" + req.getParameter("name"));
		} else {
			
			//validation succeed add files
			try {
				String query = "select * from mainlistassignments where asgid=? and deadline > now()";

				ps = conn.prepareStatement(query);
				ps.setInt(1, asgid);
				rs = ps.executeQuery();

				if (rs.next()) {
					query = "insert into asgmnsubmissions(std_id,asgid,path,orgnames,no_of_files,extensions,datetime)values(?,?,?,?,?,?,now())";
					ps = conn.prepareStatement(query);
					no_of_files = 1;
					for (Part part : req.getParts()) {
						name = FileOperations.extractFileName(part);
						if (name.equals("")) {
							break;
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

					System.out.println(paths);
					ps.setInt(1, std_id);
					ps.setInt(2, asgid);
					ps.setString(3, paths);
					ps.setString(4, fileNames);
					ps.setInt(5, no_of_files - 1);
					ps.setString(6, extensions);

					if (ps.executeUpdate() > 0) {
						sess.setAttribute("addsuccess", "1");
						resp.sendRedirect("studentAssignmentSubSection.jsp?asgid=" + new DataHiding().encodeMethod(String.valueOf(asgid))
								+ "&name=" + req.getParameter("name"));
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("studentAssignmentSubSection.jsp?asgid=" + new DataHiding().encodeMethod(String.valueOf(asgid))
								+ "&name=" + req.getParameter("name"));
					}

				} else {
					sess.setAttribute("noallowed", "1");
					resp.sendRedirect("studentAssignmentSubSection.jsp?asgid=" + new DataHiding().encodeMethod(String.valueOf(asgid))
							+ "&name=" + req.getParameter("name"));
				}

			} catch (Exception e) {
				System.out.println("Exception at SubmitAssignment : " + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("studentAssignmentSubSection.jsp?asgid=" + new DataHiding().encodeMethod(String.valueOf(asgid))
						+ "&name=" + req.getParameter("name"));
			}
		}
	}
}
