package assignment;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

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
import notes.SubjectNotesBean;

@WebServlet(urlPatterns = { "/AddAssignment" })
@MultipartConfig(maxFileSize = 567898989)
public class AddAssignment extends HttpServlet {

	String path = "H:\\java\\EduHITec\\WebContent\\assignment\\";

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		String code = "a_";
		String fileNames = "";
		String extensions = "";
		String name;
		String extension;
		String paths = "";
		int no_of_files;

		String title = req.getParameter("title").trim();
		String inst = req.getParameter("inst").trim();
		String deadline = req.getParameter("deadline");
		String marks = req.getParameter("marks");
		String amid = req.getParameter("amid");
		HttpSession sess = req.getSession(false);

		ValidateAssignment va = new ValidateAssignment();

		// validate the assignment form
		boolean flag = va.validateAmid(amid) && va.validateDeadline(deadline) && va.validateInst(inst)
				&& va.validateMarks(marks) && va.validateTitle(title);
		
		int count = 0;
		
		//validate the file
		for (Part part : req.getParts()) {
//			System.out.println(part);
			name = FileOperations.extractFileName(part);
//			System.out.println(name);
			if (name.equals("")) {
				continue;
			}
//			System.out.println(part.getSize());
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
			sess.setAttribute("noValidAdd", "1");
			MainListAssignmentsBean bean= new MainListAssignmentsBean(); 
			bean.setTitle(title);
			bean.setDeadline(deadline);
			bean.setAmid(Integer.parseInt(amid));
			bean.setInstructions(inst);
			if(marks != null && marks.equals("") == false)
				bean.setMarks(Integer.parseInt(marks));
			else
				bean.setMarks(-1);
			System.out.println(bean.getTitle());
			System.out.println(bean.getDeadline());
			
			sess.setAttribute("bean", bean);
			resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
			
		} else {
				//validation succeed add the record
			try {
				String query = "insert into mainlistassignments(amid, instructions, deadline, title,marks)values(?,?,?,?,?)";
				ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);

				ps.setString(1, amid);
				ps.setString(2, inst);
				ps.setString(3, deadline);
				ps.setString(4, title);
				ps.setInt(5, Integer.parseInt(marks));

				if (ps.executeUpdate() > 0) {
					ResultSet rs = ps.getGeneratedKeys();
					int id = 0;
					if (rs.next()) {
						id = rs.getInt(1);
						code = code + String.valueOf(id) + "b4";

						query = "update mainlistassignments set path=?,code=?,no_of_files=?,extensions=?,orgnames=? where asgid=?";

						ps = conn.prepareStatement(query);

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

						ps.setString(1, paths);
						ps.setString(2, code);
						ps.setInt(3, no_of_files - 1);
						ps.setString(4, extensions);
						ps.setString(5, fileNames);
						ps.setInt(6, id);

						if (ps.executeUpdate() > 0) {
							sess.setAttribute("success", "1");
							resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid)
									+"&cd="+code);
						} else {
							sess.setAttribute("error", "1");
							resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
						}
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
					}
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
				}

			} catch (Exception e) {
				System.out.println("Exception at AddAssignment : " + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
			}
		}
	}
}
