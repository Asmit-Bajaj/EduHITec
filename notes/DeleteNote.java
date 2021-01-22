package notes;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns= {"/DeleteNote"})
public class DeleteNote extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		HttpSession sess = req.getSession(false);
		String npid = req.getParameter("Dnpid");
		
		String path = "";
		String query1 = "select * from subjectnotes where nid=?";
		
		String query="delete from subjectnotes where nid=?";
		try {
			ps = conn.prepareStatement(query1);
			ps.setInt(1, Integer.parseInt(req.getParameter("Dnid")));
			ResultSet set = ps.executeQuery();
			
			if(set.next()) {
				path = set.getString("path");
			}else {
				sess.setAttribute("error", "1");
				resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
			}
			ps = conn.prepareStatement(query);
			ps.setInt(1, Integer.parseInt(req.getParameter("Dnid")));
			File f = new File(path);
			f.delete();
			if(ps.executeUpdate() > 0) {
				sess.setAttribute("success", "3");
				resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
				}else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
				}
		} catch (SQLException e) {
			System.out.println("exception at DeleteNote : "+e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("educatorNotesSection.jsp?npid=" + new DataHiding().encodeMethod(npid));
		}
		
		
	}
}
