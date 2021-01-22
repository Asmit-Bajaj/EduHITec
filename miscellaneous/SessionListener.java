package miscellaneous;

import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import connnection.EduHITecDb;

@WebListener
public class SessionListener implements HttpSessionListener {
	@Override
	public void sessionDestroyed(HttpSessionEvent arg0) {
		Connection conn = EduHITecDb.getConnection();
		try {
			System.out.println("session destroyed");
			if (arg0.getSession().getAttribute("edu_id") != null) {

				// update login to false
				String query = "update educator set loggedIn=? where edu_id=?";

				PreparedStatement ps = conn.prepareStatement(query);
				ps.setBoolean(1, false);
				ps.setInt(2, (Integer) arg0.getSession().getAttribute("edu_id"));

				ps.executeUpdate();

			} else if (arg0.getSession().getAttribute("std_id") != null) {
				// update login to false
				String query = "update student set loggedIn=? where std_id=?";

				PreparedStatement ps = conn.prepareStatement(query);
				ps.setBoolean(1, false);
				ps.setInt(2, (Integer) arg0.getSession().getAttribute("std_id"));

				ps.executeUpdate();
				
			} else if (arg0.getSession().getAttribute("admin_id") != null) {
				// update login to false
				String query = "update admin set loggedIn=? where admin_id=?";

				PreparedStatement ps = conn.prepareStatement(query);
				ps.setBoolean(1, false);
				ps.setInt(2, (Integer) arg0.getSession().getAttribute("admin_id"));
				ps.executeUpdate();
			}
		} catch (Exception e) {
			System.out.println("Exception at SessionListener : " + e);
		}
	}

	@Override
	public void sessionCreated(HttpSessionEvent arg0) {
		System.out.println("session created");

	}
}
