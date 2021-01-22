package videos;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
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

@WebServlet(urlPatterns = { "/AddVideo" })
public class AddVideo extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		Connection conn = EduHITecDb.getConnection();
		HttpSession sess = req.getSession(false);

		String desp = req.getParameter("desp").trim();
		String title = req.getParameter("title").trim();
		String uni_id = req.getParameter("uni_id");

		String link = req.getParameter("link").trim();

		boolean flag = true;

		// validate the form
		ValidatePlaylistVideo vv = new ValidatePlaylistVideo();

		flag = vv.validateDesp(desp) && vv.validateTitle(title);

		if (flag == false) {
			// if validation fails go back
			sess.setAttribute("noValidAdd", "1");
			PlaylistVideosBean bean = new PlaylistVideosBean();
			bean.setTitle(title);
			bean.setDesp(desp);
			bean.setLink(link);
			bean.setUni_id(Integer.parseInt(uni_id));
			sess.setAttribute("bean", bean);
			resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));

		} else {
			//if link is not valid
			if (vv.validateLink(link) == false) {
				sess.setAttribute("noValidAdd", "1");
				PlaylistVideosBean bean = new PlaylistVideosBean();
				bean.setTitle(title);
				bean.setDesp(desp);
				bean.setLink(link);
				bean.setUni_id(Integer.parseInt(uni_id));
				sess.setAttribute("bean", bean);
				sess.setAttribute("novalidLink", "1");
				
				resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
			} else {
				// validation succeed add video
				try {
					String query = "insert into playlistvideos(uni_id,title,desp,link)values(?,?,?,?)";

					PreparedStatement ps = conn.prepareStatement(query);
					ps.setInt(1, Integer.parseInt(uni_id));
					ps.setString(2, title);
					ps.setString(3, desp);
					ps.setString(4, link);

					if (ps.executeUpdate() > 0) {
						sess.setAttribute("success", "1");
						resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
					}

				} catch (Exception e) {
					System.out.println("Exception at addVideo() : " + e);
					sess.setAttribute("error", "1");
					resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
				}
			}
		}
	}
}