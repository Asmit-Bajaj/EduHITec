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

@WebServlet(urlPatterns = { "/DeletePlaylist" })
public class DeletePlaylist extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		HttpSession sess = req.getSession(false);
		String Duid = req.getParameter("Duid");

		try {
			String query = "delete from videoplaylist where uni_id=?";
			PreparedStatement ps = conn.prepareStatement(query);

			ps.setInt(1, Integer.parseInt(Duid));
			if (ps.executeUpdate() > 0) {
				//sess.setAttribute("success", "3");
				

				//delete all the video associated to this playlist 
				query = "delete from playlistvideos where uni_id=?";

				ps = conn.prepareStatement(query);
				ps.setInt(1, Integer.parseInt(Duid));

				ps.executeUpdate();
					sess.setAttribute("success", "3");
					resp.sendRedirect("uploadVideos.jsp");
					
				
			} else {
				sess.setAttribute("error", "1");
				resp.sendRedirect("uploadVideos.jsp");
			}

		} catch (Exception e) {
			System.out.println("Exception at DeletePlaylist : " + e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("uploadVideos.jsp");
		}
	}
}
