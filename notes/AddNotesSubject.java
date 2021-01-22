package notes;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import connnection.EduHITecDb;
import videos.VideoDao;
import videos.VideoPlayListBean;

@WebServlet(urlPatterns = { "/AddNotesSubject" })
public class AddNotesSubject extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		Connection conn = EduHITecDb.getConnection();
		HttpSession sess = req.getSession(false);
		int instId = new VideoDao().getInstId((Integer) sess.getAttribute("edu_id"));
		PreparedStatement ps = null;

		String desp = req.getParameter("desp").trim();
		String title = req.getParameter("title").trim();
		String id = req.getParameter("selectTopic");
		boolean flag = false;

		ValidateNotesList vn = new ValidateNotesList();
		// System.out.println(Integer.parseInt(req.getParameter("selectTopic")));
		// System.out.println(req.getParameter("selectTopic"));
		flag = vn.validateDesp(desp) && vn.validateSubject(id) && vn.validateTitle(title);

		if (flag == false) {
			// if validation fails go back
			sess.setAttribute("noValidAdd", "1");
			NotesSubjectBean bean = new NotesSubjectBean();
			bean.setTitle(title);
			bean.setDesp(desp);
			if (id != null && id.isEmpty() == false)
				bean.setSub_id(Integer.parseInt(id));
			else
				bean.setSub_id(-1);
			sess.setAttribute("bean", bean);
			resp.sendRedirect("uploadNotes.jsp");

		} else {
			//validate succeed add notes list
			String query = "insert into notessubject(sub_id,edu_id,desp,title,inst_id,datetime)values(?,?,?,?,?,now())";
			try {
				ps = conn.prepareStatement(query);
				ps.setInt(1, Integer.parseInt(id));
				ps.setInt(2, (Integer) sess.getAttribute("edu_id"));
				ps.setString(3, desp);
				ps.setString(4, title);

				
				ps.setInt(5, instId);

				if (ps.executeUpdate() > 0) {
					sess.setAttribute("success", "1");
					resp.sendRedirect("uploadNotes.jsp");
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadNotes.jsp");
				}

			} catch (Exception e) {
				System.out.println("Exception at AddNotesSubject:" + e);
				
				sess.setAttribute("error", "1");
				resp.sendRedirect("uploadNotes.jsp");
			}
		}
	}
}
