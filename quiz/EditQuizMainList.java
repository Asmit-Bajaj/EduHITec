package quiz;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import videos.VideoDao;

@WebServlet(urlPatterns = { "/EditQuizMainList" })
public class EditQuizMainList extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		String desp = req.getParameter("desp");
		String title = req.getParameter("title");
		String enpid = req.getParameter("Eqmid");
		HttpSession sess = req.getSession(false);
		QuizMainListBean bean = new QuizMainListBean();

		ValidateQuizMainList vq = new ValidateQuizMainList();
		boolean flag = false;
		flag = vq.validateDesp(desp) && vq.validateTitle(title);

		if (enpid.equals("")) {
			// System.out.println("here i am");
			flag = false;
		} else {
			bean.setQmid(Integer.parseInt(enpid));
		}

		if (flag == false) {
			// validation fails
			sess.setAttribute("noValidEdit", "1");

			bean.setTitle(title);
			bean.setDesp(desp);

			sess.setAttribute("bean", bean);
			resp.sendRedirect("uploadQuizzes.jsp");
		}else{
			//validation succeed update the record
			String query = "update quizmainlist set desp=?,title=? where qmid=?";

			try {
				ps = conn.prepareStatement(query);

				ps.setString(1, req.getParameter("desp"));
				ps.setString(2, req.getParameter("title"));
				ps.setInt(3, Integer.parseInt(req.getParameter("Eqmid")));

				if (ps.executeUpdate() > 0) {
					sess.setAttribute("success", "2");
					resp.sendRedirect("uploadQuizzes.jsp");
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadQuizzes.jsp");
				}

			} catch (Exception e) {
				System.out.println("Exception at EditQuizMainList :" + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("uploadQuizzes.jsp");
			}
		}
	}
}
