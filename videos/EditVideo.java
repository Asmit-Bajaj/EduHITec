package videos;

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
import hide.DataHiding;

@WebServlet(urlPatterns = { "/EditVideo" })
public class EditVideo extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		HttpSession sess = req.getSession(false);

		String desp = req.getParameter("desp").trim();
		String title = req.getParameter("title").trim();
		String uni_id = req.getParameter("uni_id");
		String Evid = req.getParameter("Evid");

		String link = req.getParameter("link").trim();

		boolean flag = true;
		// validate the form
		ValidatePlaylistVideo vv = new ValidatePlaylistVideo();

		flag = vv.validateDesp(desp) && vv.validateTitle(title);

		if (flag == false) {
			// if validation fails go back
			sess.setAttribute("noValidEdit", "1");
			PlaylistVideosBean bean = new PlaylistVideosBean();
			bean.setTitle(title);
			bean.setDesp(desp);
			bean.setLink(link);
			bean.setUni_id(Integer.parseInt(uni_id));
			bean.setVid(Integer.parseInt(Evid));
			sess.setAttribute("bean", bean);
			resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));

		} else {
			// if link is not valid
			if (vv.validateLink(link) == false) {
				sess.setAttribute("noValidEdit", "1");
				PlaylistVideosBean bean = new PlaylistVideosBean();
				bean.setTitle(title);
				bean.setDesp(desp);
				bean.setLink(link);
				bean.setUni_id(Integer.parseInt(uni_id));
				bean.setVid(Integer.parseInt(Evid));
				sess.setAttribute("bean", bean);
				sess.setAttribute("novalidLink", "1");

				resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
			} else {
				//everything is fine update the details
				String query = "update playlistvideos set title=?,desp=?,link=? where vid=?";

				try {
					ps = conn.prepareStatement(query);
					ps.setString(1, req.getParameter("title"));
					ps.setString(2, req.getParameter("desp"));
					ps.setString(3, req.getParameter("link"));
					ps.setInt(4, Integer.parseInt(req.getParameter("Evid")));

					if (ps.executeUpdate() > 0) {
						sess.setAttribute("success", "2");
						resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
					}

				} catch (Exception e) {
					System.out.println("Exception at EditVideo : " + e);
					sess.setAttribute("error", "1");
					resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
				}
			}
		}
	}
}
