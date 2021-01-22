package miscellaneous;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns = { "/UpdateForgotPwd" })
public class UpdateForgotPwd extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		DataHiding hd = new DataHiding();
		String upid = hd.decodeMethod(req.getParameter("upid"));
		String id = hd.decodeMethod(req.getParameter("id"));
		String role = hd.decodeMethod(req.getParameter("role"));
		String pwd = req.getParameter("pwd");
		String link = "http://localhost:8081/EduHITec/forgotpwd.jsp?role=" + req.getParameter("role") + "&upid="
				+ req.getParameter("upid") + "&id=" + req.getParameter("id");
		HttpSession ss = req.getSession();

		String query;
		PreparedStatement ps = null;
		Connection conn = null;
		ResultSet rs;

		if (pwd == null || pwd.equals("") || pwd.length() < 8) {
			ss.setAttribute("novalid", "1");
			resp.sendRedirect("forgotpwd.jsp");
		} else {
			// first check is this link correct or not
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			try {
				
				
					//now update the pwd
					if(role.equals("admin")) {
						query = "update admin set pwd=? where admin_id=?";
						ps = conn.prepareStatement(query);
						
						ps.setString(1, hd.toHexString(hd.getSHA(pwd)));
						ps.setInt(2, Integer.parseInt(id));
						
						if(ps.executeUpdate() > 0) {
							query = "delete from forgotpwd where link=?";
							ps = conn.prepareStatement(query);
							ps.setString(1, link);
							
							ps.executeUpdate();
							
							ss.setAttribute("success", "1");
							resp.sendRedirect("forgotpwd.jsp");
						}else {
							ss.setAttribute("error", "1");
							resp.sendRedirect("forgotpwd.jsp");
						}
						
					}else if(role.equals("educator")) {
						query = "update educator set pwd=? where edu_id=?";
						
						ps = conn.prepareStatement(query);
						
						ps.setString(1, hd.toHexString(hd.getSHA(pwd)));
						ps.setInt(2, Integer.parseInt(id));
						
						if(ps.executeUpdate() > 0) {
							query = "delete from forgotpwd where link=?";
							ps = conn.prepareStatement(query);
							ps.setString(1, link);
							
							ps.executeUpdate();
							
							ss.setAttribute("success", "1");
							resp.sendRedirect("forgotpwd.jsp");
						}else {
							ss.setAttribute("error", "1");
							resp.sendRedirect("forgotpwd.jsp");
						}
					}else if(role.equals("student")){
						
						query = "update student set pwd=? where std_id=?";
						ps = conn.prepareStatement(query);
						
						ps.setString(1, hd.toHexString(hd.getSHA(pwd)));
						ps.setInt(2, Integer.parseInt(id));
						
						if(ps.executeUpdate() > 0) {
							query = "delete from forgotpwd where link=?";
							ps = conn.prepareStatement(query);
							ps.setString(1, link);
							
							ps.executeUpdate();
							
							ss.setAttribute("success", "1");
							resp.sendRedirect("forgotpwd.jsp");
						}else {
							ss.setAttribute("error", "1");
							resp.sendRedirect("forgotpwd.jsp");
						}
					}else {
						//link is not valid or link expire
						ss.setAttribute("nfd", "1");
						resp.sendRedirect("forgotpwd.jsp");
					}
					
			} catch (Exception e) {
				System.out.println("Exception at UpdateForgotPwd : "+e);
				ss.setAttribute("error", "1");
				resp.sendRedirect("forgotpwd.jsp");
			}
		}
	}
}
