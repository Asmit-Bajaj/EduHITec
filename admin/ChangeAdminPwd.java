package admin;

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
import hide.DataHiding;

@WebServlet(urlPatterns = { "/ChangeAdminPwd" })
public class ChangeAdminPwd extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String newPwd = req.getParameter("newpwd").trim();
		String oldPwd = req.getParameter("oldpwd").trim();
		HttpSession sess = req.getSession(false);
		int admin_id = (Integer) sess.getAttribute("admin_id");
		DataHiding hd = new DataHiding();
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;

		if (newPwd.equals("")) {
			sess.setAttribute("surpassPwd", "1");
			resp.sendRedirect("admin_profile.jsp");
		} else {

			try {
				// validation at server side
				oldPwd = hd.toHexString(hd.getSHA(oldPwd));
				String query = "select pwd from admin where admin_id=?";

				ps = conn.prepareStatement(query);
				ps.setInt(1, admin_id);

				ResultSet rs = ps.executeQuery();

				// if password found
				if (rs.next()) {
					// now check is password same or not
					if (rs.getString("pwd").equals(oldPwd)) {
						// updating password
						query = "update admin set pwd=? where admin_id=?";
						newPwd = hd.toHexString(hd.getSHA(newPwd));

						ps = conn.prepareStatement(query);
						ps.setString(1, newPwd);
						ps.setInt(2, admin_id);

						// pwd updated successfully
						if (ps.executeUpdate() > 0) {
							sess.setAttribute("success", "2");
							resp.sendRedirect("admin_profile.jsp");
						} else {
							throw new Exception("error in updating the password");
						}
					} else {
						// old pwd does not match
						sess.setAttribute("novalidPwd", "1");
						resp.sendRedirect("admin_profile.jsp");
					}

				} else {
					throw new Exception("problem in getting info");
				}

			} catch (Exception e) {
				System.out.println("Exception at ChangeAdminPwd : " + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("admin_profile.jsp");
			}
		}
	}

}
