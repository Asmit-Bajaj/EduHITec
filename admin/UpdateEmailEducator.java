package admin;

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

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns= {"/UpdateEmailEducator"})
public class UpdateEmailEducator extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int edu_id=Integer.parseInt(req.getParameter("id"));
		String email = req.getParameter("email");
		final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
		Connection conn = EduHITecDb.getConnection();
		HttpSession session = req.getSession(false);
		DataHiding hd = new DataHiding();
		
		
		try {
			//check if email exist in educator table
			String query = "select email from educator where email=? and edu_id != ?";
			boolean flag = true;
			
			PreparedStatement ps = conn.prepareStatement(query);
			ps.setString(1, email);
			ps.setInt(2, edu_id);
			
			ResultSet rs = ps.executeQuery();
			
			if(rs.next()) {
				flag = false;
			}
			
//			//check if email exist in student table
//			query =  "select email from student where email=?";
//			
//			ps = conn.prepareStatement(query);
//			ps.setString(1, email);
//			
//			rs = ps.executeQuery();
//			if(rs.next()) {
//				flag = false;
//			}
			
			
			query =  "select validate_email from educator where edu_id=?";
			
			ps = conn.prepareStatement(query);
			ps.setInt(1, edu_id);
			
			boolean flag1 = true;
			
			rs = ps.executeQuery();
			if(rs.next()) {
				if(rs.getBoolean("validate_email"))
					flag1 = false;
			}
			
			if(flag == false) {
				//if email already exist then sent error message
				
				session.setAttribute("exist1", "email");
				
				resp.sendRedirect("check_Educators.jsp");
				
			}else if(flag1 == false) {
				
				//To check if this educator is already validated email or not for concurrency control
				
				session.setAttribute("exist2", "email");
				resp.sendRedirect("check_Educators.jsp");
				
			}else{
				flag = new ValidateEducator().validateEmail(email);
				
				if(flag == false) {
					
					session.setAttribute("no_valid","1");
					resp.sendRedirect("check_Educators.jsp");
				}
				
				//update the email and date
				query = "update educator set email=?,date_of_linkGen=now() where edu_id=?";
				ps= conn.prepareStatement(query);
				
				ps.setString(1, email);
				ps.setInt(2, edu_id);
				
				if(ps.executeUpdate() > 0) {
					String encodeId = null;
					String upId = null;
					//do encoding of ids
					encodeId= hd.encodeMethod(""+edu_id);
					query = "select date_of_linkGen from educator where edu_id=?";
					ps= conn.prepareStatement(query);
					
					ps.setInt(1, edu_id);
					rs = ps.executeQuery();
					
					if(rs.next()) {
						upId = hd.encodeMethod(rs.getString("date_of_linkGen"));
					}else {
						throw new Exception("error in getting the date of linkGen");
					}
					
					if(encodeId == null || upId == null) {
						throw new Exception("Problem at Encoder");
					}
					

				     
				     //update the link
				     query = "update educator set link=? where edu_id=?";
				     
				     ps = conn.prepareStatement(query);
				     ps.setString(1, "http://localhost:8081/EduHITec/confirmEducatorMail.jsp?id="+encodeId+"&upid="+upId);
				     ps.setInt(2, edu_id);
				     
				     if(ps.executeUpdate() > 0) {
				    	 
				    	//Now send the email to given email address
							
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
						     
						  
						     Session session_ = Session.getDefaultInstance(props, 
						                          new Authenticator(){
						                             protected PasswordAuthentication getPasswordAuthentication() {
						                                return new PasswordAuthentication(username, password);
						                             }});

						   // -- Create a new message --
						     Message msg = new MimeMessage(session_);

						  // -- Set the FROM and TO fields --
						     msg.setFrom(new InternetAddress("EduHITec"));
						  
						     msg.setRecipients(Message.RecipientType.TO, 
						                      InternetAddress.parse(email,false));
						     msg.setSubject("[EdhuHITec] Confirm E-Mail Address");
						    msg.setContent("<div>\r\n" + 
						    		"        <b>Welcome to EduHITec</b>,<br><br>\r\n" + 
						    		"        Thank you for registering on our portal. You are just one step away from completing the registration.<br>\r\n" + 
						    		"        Please Follow the given link to complete the registration.<br><br><br>\r\n" + 
						    		"        <a href=\"http://localhost:8081/EduHITec/confirmEducatorMail.jsp?id="+encodeId+"&upid="+upId+"\">"
						    				+ "http://localhost:8081/EduHITec/confirmEducatorMail.jsp?id="+encodeId+"&upid="+upId+"</a>\r\n" + 
						    		"    </div>", "text/html");
						     msg.setSentDate(new Date());
						     
						     Transport.send(msg);
						     System.out.println("Message sent.");
						     
				    	 session.setAttribute("success", "4");
				    	 
				    	 resp.sendRedirect("check_Educators.jsp");
				     }else {
				    	 throw new Exception("Problem in setting link back");
				     }
					
				}else {
					throw new Exception("error in updating email");
				}
			}
			
		} catch (Exception e) {
			System.out.println("Exception at UpdateEmailEducator : "+e);
			session.setAttribute("error", "1");
			resp.sendRedirect("check_Educators.jsp");
		}
	}
}
