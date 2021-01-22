package quiz;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import notes.NotesSubjectBean;
import videos.VideoDao;

@WebServlet(urlPatterns = { "/AddQuizMainList" })
public class AddQuizMainList extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;

		HttpSession sess = req.getSession(false);
		int instId = new VideoDao().getInstId((Integer) sess.getAttribute("edu_id"));

		String desp = req.getParameter("desp").trim();
		String title = req.getParameter("title").trim();
		String id = req.getParameter("selectSubject");
		boolean flag = false;

		ValidateQuizMainList vq = new ValidateQuizMainList();

		flag = vq.validateDesp(desp) && vq.validateSubject(id) && vq.validateTitle(title);

		if (flag == false) {
			// if validation fails go back
			sess.setAttribute("noValidAdd", "1");
			QuizMainListBean bean = new QuizMainListBean();
			bean.setTitle(title);
			bean.setDesp(desp);
			if (id != null && id.isEmpty() == false)
				bean.setSub_id(Integer.parseInt(id));
			else
				bean.setSub_id(-1);
			sess.setAttribute("bean", bean);
			resp.sendRedirect("uploadQuizzes.jsp");
			
		} else {
			//validate succeed add notes list
			String query = "insert into quizmainlist(sub_id,edu_id,desp,title,inst_id)values(?,?,?,?,?)";

			try {
				ps = conn.prepareStatement(query);
				ps.setInt(1, Integer.parseInt(req.getParameter("selectSubject")));
				ps.setInt(2, (Integer) sess.getAttribute("edu_id"));
				ps.setString(3, req.getParameter("desp"));
				ps.setString(4, req.getParameter("title"));

				ps.setInt(5, instId);

				if (ps.executeUpdate() > 0) {
					sess.setAttribute("success", "1");
					resp.sendRedirect("uploadQuizzes.jsp");
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadQuizzes.jsp");
				}
				
			} catch (Exception e) {
				System.out.println("Exception at AddQuizMainList :" + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("uploadQuizzes.jsp");
			}
		}
	}
}
