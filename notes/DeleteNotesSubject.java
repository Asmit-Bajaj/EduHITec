package notes;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;

@WebServlet(urlPatterns= {"/DeleteNotesSubject"})
public class DeleteNotesSubject extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps;
		HttpSession sess = req.getSession(false);
		
		try {
			//first delete all the notes of this list
			String query1 = "select * from subjectnotes where npid=?";
			ps = conn.prepareStatement(query1);
			ps.setInt(1, Integer.parseInt(req.getParameter("Dnpid")));
			
			ResultSet set = ps.executeQuery();
			
			//deleting all the files stored
			while(set.next()) {
				String path = set.getString("path");
				File f = new File(path);
				f.delete();
			}
			
			//now deleting the notes
			String query = "delete from subjectnotes where npid=?";
			ps = conn.prepareStatement(query);
			
			ps.setInt(1, Integer.parseInt(req.getParameter("Dnpid")));
			ps.executeUpdate();
			
				//now delete the notes list
				query = "delete from notessubject where npid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, Integer.parseInt(req.getParameter("Dnpid")));
				
				ps.executeUpdate();
				sess.setAttribute("success", "3");
				resp.sendRedirect("uploadNotes.jsp");
				
		}catch (Exception e) {
			System.out.println("Exception at DeleteNotesSubject : "+e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("uploadNotes.jsp");
		}
	}
}
