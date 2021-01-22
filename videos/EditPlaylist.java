package videos;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;

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

@WebServlet(urlPatterns = { "/EditPlaylist" })
@MultipartConfig(maxFileSize = 99999999)
public class EditPlaylist extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		String query;
		PreparedStatement ps;
		String desp = req.getParameter("desp").trim();
		String title = req.getParameter("title").trim();
		System.out.println("title = "+title);
		VideoPlayListBean bean = new VideoPlayListBean();
		
		String confirm = req.getParameter("thumbnailConfirm");
		HttpSession sess = req.getSession(false);
		boolean flag = true;
		// validate the attributes of form
		ValidateVideoPlayList vp = new ValidateVideoPlayList();
		flag = vp.validateDesp(desp) && vp.validateTitle(title);
		
		if(req.getParameter("Euid").equals("")){
			System.out.println("here i am");
			flag = false;
		}else {
			bean.setUni_id(Integer.parseInt(req.getParameter("Euid")));
		}

		if (confirm.equalsIgnoreCase("1")) {
			System.out.println(flag);
			try {
				Part file = req.getPart("thumbnail");
				// check for files
				String name = FileOperations.extractFileName(file);
				System.out.println(name);
				if (!FileOperations.getExtension(name).equalsIgnoreCase("jpg")
						&& !FileOperations.getExtension(name).equalsIgnoreCase("jpeg")
						&& !FileOperations.getExtension(name).equalsIgnoreCase("png")) {
					flag = false;
				}

			} catch (Exception e) {
				System.out.println(e);
				e.printStackTrace();
				flag = false;
			}

			if (flag == false) {
				// validation fails
				sess.setAttribute("noValidEdit", "1");
				

				bean.setTitle(title);
				bean.setDesp(desp);
				

				sess.setAttribute("bean", bean);
				resp.sendRedirect("uploadVideos.jsp");

			} else {
				//update the data
				query = "update videoplaylist set topic=?,desp=?,thumbnail=? where uni_id=?";

				try {

					ps = conn.prepareStatement(query);
					ps.setString(1, req.getParameter("title"));
					ps.setString(2, req.getParameter("desp"));

					Part part = req.getPart("thumbnail");
					InputStream photo = part.getInputStream();

					ps.setBlob(3, photo);
					ps.setInt(4, Integer.parseInt(req.getParameter("Euid")));

					if (ps.executeUpdate() > 0) {
						sess.setAttribute("success", "2");
						resp.sendRedirect("uploadVideos.jsp");
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("uploadVideos.jsp");
					}

				} catch (Exception e) {
					System.out.println("Exception at EditPlaylist : " + e);
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadVideos.jsp");
				}
			}
			
		} else {
			//update the data
			if (flag == false) {
				// validation fails
				sess.setAttribute("noValidEdit", "1");
				

				bean.setTitle(title);
				bean.setDesp(desp);

				sess.setAttribute("bean", bean);
				resp.sendRedirect("uploadVideos.jsp");
			} else {
				query = "update videoplaylist set topic=?,desp=? where uni_id=?";

				try {

					ps = conn.prepareStatement(query);
					ps.setString(1, req.getParameter("title"));
					ps.setString(2, req.getParameter("desp"));

					ps = conn.prepareStatement(query);
					ps.setString(1, req.getParameter("title"));
					ps.setString(2, req.getParameter("desp"));
					ps.setInt(3, Integer.parseInt(req.getParameter("Euid")));

					if (ps.executeUpdate() > 0) {
						sess.setAttribute("success", "2");
						resp.sendRedirect("uploadVideos.jsp");
					} else {
						sess.setAttribute("error", "1");
						resp.sendRedirect("uploadVideos.jsp");
					}

				} catch (Exception e) {
					System.out.println("Exception at EditPlaylist : " + e);
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadVideos.jsp");
				}
			}
		}

		// System.out.println(req.getParameter("title"));
		// System.out.println(req.getParameter("desp"));
		// System.out.println(req.getParameter("thumbnail"));
		// System.out.println(req.getPart("thumbnailConfirm"));
		// System.out.println(req.getParameter("Euid"));

	}
}
