package assignment;

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

@WebServlet(urlPatterns = { "/DeleteAssignmentMainList" })
public class DeleteAssignmentMainList extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		Connection conn = EduHITecDb.getConnection();
		HttpSession sess = req.getSession(false);
		
		PreparedStatement ps;
		
		try {
			//first getting all the files
			String query1 = "select * from mainlistassignments where amid=?";
			ps = conn.prepareStatement(query1);
			ps.setInt(1, Integer.parseInt(req.getParameter("Damid")));

			ResultSet set = ps.executeQuery();
			//deleting all the files
			while (set.next()) {
				String[] paths = set.getString("path").split("#");
				for(int i=0;i<paths.length;i++) {
					File f = new File(paths[i]);
					f.delete();
				}
				
				//delete from unlock assignment too
				query1 = "delete from unlockedassignment where asgid=?";
				ps = conn.prepareStatement(query1);
				
				ps.setInt(1, set.getInt("asgid"));
				
				ps.executeUpdate();
				
				// delete all the submissions too
				query1 = "select * from asgmnsubmissions where asgid=?";
				ps = conn.prepareStatement(query1);

				ps.setInt(1, set.getInt("asgid"));

				ResultSet set1 = ps.executeQuery();

				if (set1.next()) {
					//delete submisssion files
					paths = set1.getString("path").split("#");
					for (int i = 0; i < paths.length; i++) {
						File f = new File(paths[i]);
						f.delete();
					}

					//if returned file then delete it
					if (set1.getString("ret_path") != null) {
						paths = set1.getString("ret_path").split("#");
						for (int i = 0; i < paths.length; i++) {
							File f = new File(paths[i]);
							f.delete();
						}
					}
				}
				
				query1 = "delete from asgmnsubmissions where asgid=?";
				ps = conn.prepareStatement(query1);
				
				ps.setInt(1, set.getInt("asgid"));
				
				ps.executeUpdate();
			}
			
			//now finally delete the assignment main list
			String query = "delete from assignmentmainlist where amid=?";
			ps = conn.prepareStatement(query);

			ps.setInt(1, Integer.parseInt(req.getParameter("Damid")));

			if (ps.executeUpdate() > 0) {
				query = "delete from mainlistassignments where amid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, Integer.parseInt(req.getParameter("Damid")));

				ps.executeUpdate();
				sess.setAttribute("success", "3");
				resp.sendRedirect("uploadAssignment.jsp");
				
			} else {
				sess.setAttribute("error", "1");
				resp.sendRedirect("uploadAssignment.jsp");
			}
		} catch (Exception e) {
			System.out.println("Exception at DeleteAssignmentMainList : " + e);
			sess.setAttribute("error", "1");
			resp.sendRedirect("uploadAssignment.jsp");
		}
	}
}
