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

@WebServlet(urlPatterns = { "/ForgotPwd" })
public class ForgotPwd extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String role = req.getParameter("fprole");
		final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
		String email = req.getParameter("fpemail");
		DataHiding hd = new DataHiding();
		String query;
		String link;
		PreparedStatement ps;
		Connection conn = null;
		ResultSet rs;
		String id = "";
		boolean flag = false;

		HttpSession ss = req.getSession();

		// check for validation
		if (role == null || role.equals("") || email == null || email.equals("")) {

			// validation failed
			ss.setAttribute("novalid1", "1");
			resp.sendRedirect("login.jsp");
		} else {

			if (conn == null) {
				conn = EduHITecDb.getConnection();
			}

			try {
				// check for this email as per the role
				if (role.equals("admin")) {
					query = "select admin_id from admin where email=?";
					ps = conn.prepareStatement(query);
					ps.setString(1, email);

					rs = ps.executeQuery();

					if (rs.next()) {
						flag = true;
						id = rs.getString("admin_id");
					} else {
						flag = false;
					}

				} else if (role.equals("educator")) {
					query = "select edu_id from educator where email=?";
					ps = conn.prepareStatement(query);
					ps.setString(1, email);

					rs = ps.executeQuery();

					if (rs.next()) {
						flag = true;
						id = rs.getString("edu_id");
					} else {
						flag = false;
					}

				} else if (role.equals("student")) {
					query = "select std_id from student where email=?";
					ps = conn.prepareStatement(query);
					ps.setString(1, email);

					rs = ps.executeQuery();

					if (rs.next()) {
						flag = true;
						id = rs.getString("std_id");
					} else {
						flag = false;
					}

				} else {
					flag = false;
				}

				// if validation succeed then add the link and notify the user
				if (flag) {
					query = "insert into forgotpwd(link, date)values(?,now())";
					ps = conn.prepareStatement(query);
					// generate link and store it
					link = "http://localhost:8081/EduHITec/forgotpwd.jsp?role=" + hd.encodeMethod(role) + "&upid="
							+ hd.encodeMethod("" + LocalDateTime.now())+"&id="+hd.encodeMethod(id);
					ps.setString(1, link);

					if (ps.executeUpdate() > 0) {
						// Now send the email to given email address

						// Get a Properties object
						Properties props = System.getProperties();
						props.setProperty("mail.smtp.host", "smtp.gmail.com");
						props.setProperty("mail.smtp.socketFactory.class", SSL_FACTORY);
						props.setProperty("mail.smtp.socketFactory.fallback", "false");
						props.setProperty("mail.smtp.port", "465");
						props.setProperty("mail.smtp.socketFactory.port", "465");
						props.put("mail.smtp.auth", "true");
						props.put("mail.debug", "true");
						props.put("mail.store.protocol", "pop3");
						props.put("mail.transport.protocol", "smtp");
						final String username = "eduhitec.004@gmail.com";
						final String password = "EduHITec";

						Session session_ = Session.getDefaultInstance(props, new Authenticator() {
							protected PasswordAuthentication getPasswordAuthentication() {
								return new PasswordAuthentication(username, password);
							}
						});

						// -- Create a new message --
						Message msg = new MimeMessage(session_);

						// -- Set the FROM and TO fields --
						msg.setFrom(new InternetAddress("EduHITec"));

						msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email, false));
						msg.setSubject("[EdhuHITec] Forgot Password");
						msg.setContent("<div>\r\n" + "        <b>Forgot Password Request</b>,<br><br>\r\n"
								+ "        Please Follow The Below Link For Further Process And For Changing The Password.<br>\r\n"
								+ "        <br><br>\r\n"
								+ "        <a href=\""+link+"\">"
								+ link+"</a>\r\n" + "</div>","text/html");
						msg.setSentDate(new Date());

						Transport.send(msg);
						System.out.println("Message sent.");

						ss.setAttribute("success", "1");
						resp.sendRedirect("login.jsp");
					} else {
						ss.setAttribute("error", "1");
						resp.sendRedirect("login.jsp");
					}
				} else {
					// validation failed
					ss.setAttribute("novalid", "1");
					resp.sendRedirect("login.jsp");
				}
			} catch (Exception e) {
				System.out.println("Exception at ForgotPwd : " + e);
				e.printStackTrace();
				ss.setAttribute("error", "1");
				resp.sendRedirect("login.jsp");
			}
		}
	}
}
