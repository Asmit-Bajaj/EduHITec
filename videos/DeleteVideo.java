package videos;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns={"/DeleteVideo"})
public class DeleteVideo extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		HttpSession sess = req.getSession(false);
		String uni_id = req.getParameter("uni_id");
		
		String query="delete from playlistvideos where vid=?";
		try {
			ps = conn.prepareStatement(query);
			ps.setInt(1, Integer.parseInt(req.getParameter("Dvid")));
			
			if(ps.executeUpdate() > 0) {
				sess.setAttribute("success", "3");
				resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
			}else {
				sess.setAttribute("error", "1");
				resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
			}
		} catch (SQLException e) {
			System.out.println("exception at DeleteVideo : "+e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("educatorVideoSection.jsp?uni_id=" + new DataHiding().encodeMethod(uni_id));
		}
		
		
	}
}
