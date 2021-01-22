package notes;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import connnection.EduHITecDb;

@WebServlet(urlPatterns= {"/EditNote"})
public class EditNote extends HttpServlet{
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		String query="update subjectnotes set title=? where nid=?";
		
		try {
			ps = conn.prepareStatement(query);
			ps.setString(1, req.getParameter("title"));
			ps.setInt(2, Integer.parseInt(req.getParameter("Enid")));
			if(ps.executeUpdate() > 0) {
				resp.sendRedirect("educatorNotesSection.jsp?success=2&npid="+req.getParameter("Enpid"));
			}else {
				resp.sendRedirect("educatorNotesSection.jsp?error=1&npid="+req.getParameter("Enpid"));
			}
			
		} catch (Exception e) {
			System.out.println("Exception at EditNote : "+e);
			resp.sendRedirect("educatorNotesSection.jsp?error=1&npid="+req.getParameter("Enpid"));
		}
	}
}
