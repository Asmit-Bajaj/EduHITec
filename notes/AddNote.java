package notes;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import javax.xml.ws.Response;

import com.oreilly.servlet.MultipartRequest;

import connnection.EduHITecDb;
import file.FileOperations;
import hide.DataHiding;
import videos.VideoPlayListBean;

@MultipartConfig(maxFileSize = 567898989)
@WebServlet(urlPatterns = { "/AddNote" })
public class AddNote extends HttpServlet {
	String path = "H:\\java\\EduHITec\\WebContent\\notes\\";

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		String title = req.getParameter("title").trim();
		String npid = req.getParameter("npid");
		HttpSession sess = req.getSession(false);

		boolean flag = true;
		// validate the attributes of form
		ValidateListNotes ln = new ValidateListNotes();
		flag = ln.validateTitle(title);
		if(req.getPart("file").getSize() <= 0)
			flag = false;
		
		if (flag == false) {
			// if validation fails go back
			sess.setAttribute("noValidAdd", "1");
			SubjectNotesBean bean = new SubjectNotesBean();
			bean.setTitle(title);

			sess.setAttribute("bean", bean);
			resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
			
		} else {
			try {
				//add the record to database 
				String query = "insert into subjectnotes(title,npid)values(?,?)";
				ps = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS);

				ps.setString(1, req.getParameter("title"));
				ps.setString(2, req.getParameter("npid"));

				if (ps.executeUpdate() > 0) {
					ResultSet rs = ps.getGeneratedKeys();
					int id = 0;
					if (rs.next()) {
						PrintWriter out = resp.getWriter();
						
						
						id = rs.getInt(1);
						String prefix = "EduHItec_notes_";
						prefix = prefix + id;

						query = "update subjectnotes set path=?,ext=? where nid=?";

						ps = conn.prepareStatement(query);
						InputStream file = req.getPart("file").getInputStream();
						String ext = FileOperations.getExtension
								(FileOperations.extractFileName(req.getPart("file")));
						ps.setString(1, path + prefix + "."+ext);
						ps.setString(2, ext);
						
						
						ps.setInt(3, id);
						InputStream fin = req.getPart("file").getInputStream();
						int i = 0;
						
						FileOutputStream writer = new FileOutputStream(path + prefix + "."+ext);
						
						while ((i = fin.read()) != -1) {
							writer.write((char) i);
						}
						
						fin.close();
						writer.close();

						if (ps.executeUpdate() > 0) {
							
							sess.setAttribute("success", "1");
							resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
						}else {
							sess.setAttribute("error", "1");
							resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
						}
					}else{
						sess.setAttribute("error", "1");
						resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
					}
				} else{
					sess.setAttribute("error", "1");
					resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
				}

			} catch (Exception e) {
				System.out.println("Exception at AddNote : " + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
			}
		}
	}
}
