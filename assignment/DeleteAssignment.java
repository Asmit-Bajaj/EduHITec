package assignment;

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

@WebServlet(urlPatterns = { "/DeleteAssignment" })
public class DeleteAssignment extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		Connection conn = EduHITecDb.getConnection();
		HttpSession sess = req.getSession(false);
		PreparedStatement ps = null;
		String amid = req.getParameter("Damid");
		ResultSet set;
		String paths[];
		String query1 = "select * from mainlistassignments where asgid=?";

		String query = "delete from mainlistassignments where asgid=?";
		try {
			ps = conn.prepareStatement(query1);
			ps.setInt(1, Integer.parseInt(req.getParameter("Dasgid")));
			set = ps.executeQuery();
			//first deleting all the files of assignment
			
			if (set.next()) {
				paths = set.getString("path").split("#");
				for (int i = 0; i < paths.length; i++) {
					File f = new File(paths[i]);
					f.delete();
				}

			} else {
				sess.setAttribute("error", "1");
				resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
			}
			
			ps = conn.prepareStatement(query);
			ps.setInt(1, Integer.parseInt(req.getParameter("Dasgid")));

			if (ps.executeUpdate() > 0) {
				// delete from unlock assignment too
				query1 = "delete from unlockedassignment where asgid=?";
				ps = conn.prepareStatement(query1);

				ps.setInt(1, Integer.parseInt(req.getParameter("Dasgid")));

				ps.executeUpdate();

				sess.setAttribute("success", "3");

				// delete all the submissions too
				query1 = "select * from asgmnsubmissions where asgid=?";
				ps = conn.prepareStatement(query1);

				ps.setInt(1, Integer.parseInt(req.getParameter("Dasgid")));

				set = ps.executeQuery();

				if (set.next()) {
					//delete submission files
					paths = set.getString("path").split("#");
					for (int i = 0; i < paths.length; i++) {
						File f = new File(paths[i]);
						f.delete();
					}

					//if returned file then delete it
					if (set.getString("ret_path") != null) {
						paths = set.getString("ret_path").split("#");
						for (int i = 0; i < paths.length; i++) {
							File f = new File(paths[i]);
							f.delete();
						}
					}
				}
				
				query1 = "delete from asgmnsubmissions where asgid=?";
				ps = conn.prepareStatement(query1);

				ps.setInt(1, Integer.parseInt(req.getParameter("Dasgid")));

				ps.executeUpdate();

				resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
			} else {
				sess.setAttribute("error", "1");
				resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
			}
			
		} catch (SQLException e) {
			System.out.println("exception at DeleteAssignment : " + e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("educatorAssignmentSection.jsp?amid=" + new DataHiding().encodeMethod(amid));
		}

	}
}
