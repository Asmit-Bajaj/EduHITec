package videos;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import connnection.EduHITecDb;
import file.FileOperations;

@WebServlet(urlPatterns = { "/AddPlaylist" })
@MultipartConfig(maxFileSize = 99999999)
public class AddPlaylist extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		String desp = req.getParameter("desp").trim();
		String title = req.getParameter("title").trim();
		String id = req.getParameter("selectTopic");

		HttpSession sess = req.getSession(false);
		int instId = new VideoDao().getInstId((Integer) sess.getAttribute("edu_id"));
		PreparedStatement ps = null;
		

		boolean flag = true;
		// validate the attributes of form
		ValidateVideoPlayList vp = new ValidateVideoPlayList();

		flag = vp.validateDesp(desp) && vp.validateSubject(id) && vp.validateTitle(title);
		Part file = req.getPart("thumbnail");
		
		if(file.getSize() <= 0)
			flag = false;
		
		try {
			
			// check for files
			String name = FileOperations.extractFileName(file);
			if (!FileOperations.getExtension(name).equalsIgnoreCase("jpg")
					&& !FileOperations.getExtension(name).equalsIgnoreCase("jpeg")
					&& !FileOperations.getExtension(name).equalsIgnoreCase("png")) {
				flag = false;
			}
		} catch (Exception e) {
			System.out.println(e);
			e.printStackTrace();
			flag = false;
			
		} finally {

			if (flag == false) {
				// if validation fails go back
				sess.setAttribute("noValidAdd", "1");
				VideoPlayListBean bean = new VideoPlayListBean();
				bean.setTitle(title);
				bean.setDesp(desp);
				if (id != null && id.isEmpty() == false)
					bean.setSub_id(Integer.parseInt(id));
				else
					bean.setSub_id(-1);
				sess.setAttribute("bean", bean);
				resp.sendRedirect("uploadVideos.jsp");

			} else {

				// System.out.println(Integer.parseInt(req.getParameter("selectTopic")));
				// System.out.println(req.getParameter("selectTopic"));

				// add the playlist
				String query = "insert into videoplaylist(sub_id,edu_id,desp,topic,date_of_addition,thumbnail,inst_id)"
						+ "values(?,?,?,?,now(),?,?)";
				try {
					ps = conn.prepareStatement(query);
					ps.setInt(1, Integer.parseInt(id));
					ps.setInt(2, (Integer) sess.getAttribute("edu_id"));
					ps.setString(3, desp);
					ps.setString(4, title);

					Part part = req.getPart("thumbnail");
					InputStream photo = part.getInputStream();

					ps.setBlob(5, photo);
					ps.setInt(6, instId);

					if (ps.executeUpdate() > 0) {
						sess.setAttribute("success", "1");
						resp.sendRedirect("uploadVideos.jsp");
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("uploadVideos.jsp");
					}

				} catch (Exception e) {
					System.out.println("Exception at AddPlaylist:" + e);
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadVideos.jsp");
				}
			}
		}
	}

}
