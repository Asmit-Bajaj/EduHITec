package notes;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import connnection.EduHITecDb;

@WebServlet(urlPatterns = { "/EditNotesSubject" })
public class EditNotesSubject extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		HttpSession sess = req.getSession(false);
		String desp = req.getParameter("desp");
		String title = req.getParameter("title");
		String enpid = req.getParameter("Enpid");
		NotesSubjectBean bean = new NotesSubjectBean();

		boolean flag = false;

		ValidateNotesList vn = new ValidateNotesList();
		// System.out.println(Integer.parseInt(req.getParameter("selectTopic")));
		// System.out.println(req.getParameter("selectTopic"));
		flag = vn.validateDesp(desp) && vn.validateTitle(title);
		// System.out.println(req.getParameter("title"));
		// System.out.println(req.getParameter("desp"));
		// System.out.println(req.getParameter("Enpid"));

		if (enpid.equals("")) {
			// System.out.println("here i am");
			flag = false;
		} else {
			bean.setNpid(Integer.parseInt(enpid));
		}

		if (flag == false) {
			// validation fails
			sess.setAttribute("noValidEdit", "1");

			bean.setTitle(title);
			bean.setDesp(desp);

			sess.setAttribute("bean", bean);
			resp.sendRedirect("uploadNotes.jsp");
			
		} else {
				//validation succeed update the record
			try {
				query = "update notessubject set title=?,desp=? where npid=?";
				ps = conn.prepareStatement(query);
				ps.setString(1, title);
				ps.setString(2, desp);

				ps.setInt(3, Integer.parseInt(enpid));

				if (ps.executeUpdate() > 0) {
					sess.setAttribute("success", "2");
					resp.sendRedirect("uploadNotes.jsp");
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadNotes.jsp");
				}
			} catch (Exception e) {
				System.out.println("Exception at EditNotesSubject : " + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("uploadNotes.jsp");
			}
		}
	}
}
