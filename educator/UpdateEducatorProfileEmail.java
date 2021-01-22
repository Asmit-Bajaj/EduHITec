package educator;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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

import admin.ValidateEducator;
import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns= {"/UpdateEducatorProfileEmail"})
public class UpdateEducatorProfileEmail extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String email = req.getParameter("email").trim().toLowerCase();
		HttpSession sess = req.getSession(false);
		final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
		int edu_id = (Integer) sess.getAttribute("edu_id");
		DataHiding hd = new DataHiding();

		Connection conn = EduHITecDb.getConnection();
		String query = "";
		ResultSet rs;
		boolean flag = new ValidateEducator().validateEmail(email);

		PreparedStatement ps = null;

		try {
			query = "select email from educator where email=? and edu_id != ?";
			ps = conn.prepareStatement(query);
			ps.setString(1, email.toLowerCase());
			ps.setInt(2, edu_id);
			
			rs = ps.executeQuery();

			if (rs.next()) {
				flag = false;
			}

//			// check in student table too for email
//			query = "select email from student where email=?";
//
//			ps = conn.prepareStatement(query);
//			ps.setString(1, email.toLowerCase());
//
//			rs = ps.executeQuery();
//
//			if (rs.next()) {
//				flag = false;
//			}
//
//			// now check in admin table too
//
//			query = "select email from admin where email=?";
//
//			ps = conn.prepareStatement(query);
//			ps.setString(1, email.toLowerCase());
//			
//
//			rs = ps.executeQuery();
//
//			if (rs.next()) {
//				flag = false;
//			}
			// validation failed
			if (flag == false) {
				sess.setAttribute("noValidEmail", "1");
				resp.sendRedirect("educator_profile.jsp");
			} else {
				// validation succeed

				query = "update educator set email=?,validate_email=?,date_of_linkGen=now() where edu_id=?";
				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				ps.setBoolean(2, false);
				ps.setInt(3, edu_id);

				if (ps.executeUpdate() > 0) {

					String encodeId = null;
					String upId = null;

					// generate the encoded id
					encodeId = hd.encodeMethod("" + edu_id);
					query = "select date_of_linkGen from educator where edu_id=?";
					ps = conn.prepareStatement(query);

					ps.setInt(1, edu_id);

					rs = ps.executeQuery();

					if (rs.next()) {
						// encoding the date of link generation
						upId = hd.encodeMethod(rs.getString("date_of_linkGen"));
					} else {
						throw new Exception("Didnot get the generated key date_of_linkGen");
					}

					if (encodeId == null || upId == null) {
						throw new Exception("Problem at Encoder");
					}

					query = "update educator set link=? where edu_id=?";

					ps = conn.prepareStatement(query);
					ps.setString(1,
							"http://localhost:8081/EduHITec/confirmEducatorMail.jsp?id=" + encodeId + "&upid=" + upId);
					ps.setInt(2, edu_id);

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
						msg.setSubject("[EdhuHITec] Confirm Updated E-Mail Address");
						msg.setContent("<div>\r\n" + "        <b>Request To Update Email</b>,<br><br>\r\n"
								+ "        Your Email Has Been Updated Successfull.<br>\r\n"
								+ "        Please Follow the given link to complete the Email Confirmation Process.<br><br><br>\r\n"
								+ "        <a href=\"http://localhost:8081/EduHITec/confirmEducatorMail.jsp?id=" + encodeId
								+ "&upid=" + upId + "\">" + "http://localhost:8081/EduHITec/confirmEducatorMail.jsp?id="
								+ encodeId + "&upid=" + upId + "</a>\r\n" + "    </div>", "text/html");
						msg.setSentDate(new Date());

						Transport.send(msg);
						System.out.println("Message sent.");

						sess.setAttribute("success", "1");
						resp.sendRedirect("educator_profile.jsp");
					} else {
						throw new Exception("Problem in setting link back");
					}

				} else {
					throw new Exception("Problem in updating  details");
				}
			}
		} catch (Exception e) {

			System.out.println("Exception at UpdateEducatorProfileEmail :"+e);
			e.printStackTrace();
			sess.setAttribute("error", "1");
		}
	}
}
