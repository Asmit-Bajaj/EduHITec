package admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
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

@WebServlet(urlPatterns= {"/AddEducator"})
public class AddEducator extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		PreparedStatement ps = null;
		final String SSL_FACTORY = "javax.net.ssl.SSLSocketFactory";
		String query;
		DataHiding hd = new DataHiding();
		
		HttpSession session = req.getSession(false);
		int admin_id = (Integer)session.getAttribute("admin_id");
		
		String firstName = req.getParameter("firstname").trim();
		String middleName = req.getParameter("middlename").trim();
		
		String lastName = req.getParameter("lastname").trim();
		String email = req.getParameter("email").trim();
		String emp_id = req.getParameter("emp_id").trim();
		String pwd = req.getParameter("pwd").trim();
		String address = req.getParameter("address").trim();
		String contact_no = req.getParameter("contact_no").trim();
		String city = req.getParameter("city").trim();
		String state = req.getParameter("state").trim();
		String gender = req.getParameter("gender");
		
		EducatorBean bean = new EducatorBean();
		bean.setAddress(address);
		bean.setCity(city);
		bean.setContact_no(contact_no);
		bean.setEmail(email);
		bean.setEmp_id(emp_id);
		bean.setGender(gender);
		bean.setName(firstName+"/"+middleName+"/"+lastName);
		bean.setPwd(pwd);
		bean.setState(state);
		
		Connection conn = EduHITecDb.getConnection();
		ResultSet rs=null;
		
		
		
		//validate all the values
		ValidateEducator ve = new ValidateEducator();
		boolean flag = ve.validateAddress(address) && ve.validateCity(city) && ve.validateContact(contact_no) &&
				ve.validateEmail(email) && ve.validateFirstName(firstName) && ve.validateGender(gender) && 
				ve.validateLastName(lastName) && ve.validatePwd(pwd) && ve.validateState(state);
		
		
		try {
			//for checking that this email already exist in system or not for educator
			query = "select email from educator where email=?";
			ps = conn.prepareStatement(query);
			ps.setString(1, email.toLowerCase());
			
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				flag = false;
//				session.setAttribute("email", "Exist");
			}
			
//			//check in student table too for email
//			query = "select email from student where email=?";
//			
//			ps = conn.prepareStatement(query);
//			ps.setString(1, email.toLowerCase());
//			
//			
//			rs = ps.executeQuery();
//			
//			if(rs.next()) {
//				flag = false;
//				session.setAttribute("email", "Exist");
//			}
//			
//			//now check in admin table too
//			
//			query = "select email from admin where email=?";
//			
//			ps = conn.prepareStatement(query);
//			ps.setString(1, email.toLowerCase());
//			
//			
//			rs = ps.executeQuery();
//			
//			if(rs.next()) {
//				flag = false;
//				session.setAttribute("email", "Exist");
//			}
		
		//if validation failed sent back to client side and ask for validation
		if(flag == false) {
			session.setAttribute("no_validEdu", bean);
			resp.sendRedirect("add_educator.jsp");
		}else {
			query = "insert into educator"
					+ "(inst_id, name, email, pwd, emp_id, address, contact_no, status, city, state, gender,"
					+ "validate_email,date_of_linkGen)values(?,?,?,?,?,?,?,?,?,?,?,?,now())";
			
				//validation succeed add educator
				ps = conn.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
				ps.setInt(1, new AdminDao().inst_id(admin_id));
				ps.setString(2, firstName.toUpperCase()+" "+middleName.toUpperCase()+" "+lastName.toUpperCase());
				ps.setString(3, email.toLowerCase());
				ps.setString(4,hd.toHexString(hd.getSHA(pwd)));
				ps.setString(5, emp_id.toUpperCase());
				ps.setString(6, address.toUpperCase());
				ps.setString(7, contact_no);
				ps.setBoolean(8, true);
				ps.setString(9, city.toUpperCase());
				ps.setString(10, state.toUpperCase());
				ps.setString(11, gender.toUpperCase());
				ps.setBoolean(12, false);
				
				if(ps.executeUpdate() > 0) {
					rs = ps.getGeneratedKeys();
					int edu_id= -1;
					
					String encodeId = null;
					String upId = null;
					if(rs.next()) {
						edu_id = rs.getInt(1);
						//generate the encoded id
						encodeId= hd.encodeMethod(""+rs.getInt(1));
						query = "select date_of_linkGen from educator where edu_id=?";
						ps= conn.prepareStatement(query);
						
						ps.setInt(1, rs.getInt(1));
						
						rs = ps.executeQuery();
						
						if(rs.next()) {
							//encoding the date of link generation
							upId = hd.encodeMethod(rs.getString("date_of_linkGen"));
						}else {
							throw new Exception("Didnot get the generated key date_of_linkGen");
						}
						
						if(encodeId == null || upId == null) {
							throw new Exception("Problem at Encoder");
						}
						
					}else {
						throw new Exception("Didnot get the generated key edu_id");
					}
					
					
				     
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
						     
				    	 session.setAttribute("success", "1");
				    	 resp.sendRedirect("add_educator.jsp");
				     }else {
				    	 throw new Exception("Problem in setting link back");
				     }
				}else {
					throw new Exception("Problem in adding educator details");
				}
		}
		
		} catch (Exception e) {
			System.out.println("Exception at AddEducator : "+e);
			e.printStackTrace();
			session.setAttribute("error", "1");
			resp.sendRedirect("add_educator.jsp");
		}finally {
			conn = null;
		}
	}
}
