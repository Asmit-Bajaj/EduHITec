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

@WebServlet(urlPatterns= {"/AddStudent"})
public class AddStudent extends HttpServlet{
	
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
		String roll_no = req.getParameter("roll_no").trim();
		String pwd = req.getParameter("pwd").trim();
		String address = req.getParameter("address").trim();
		String contact_no = req.getParameter("contact_no").trim();
		String city = req.getParameter("city").trim();
		String state = req.getParameter("state").trim();
		String gender = req.getParameter("gender");
		String degree = req.getParameter("degree");
		String branch = req.getParameter("branch");
		String std_class = req.getParameter("std_class");
		String section = req.getParameter("section");
		String batch = req.getParameter("batch");
		
		StudentBean bean = new StudentBean();
		bean.setAddress(address);
		bean.setCity(city);
		bean.setContact_no(contact_no);
		bean.setEmail(email);
		bean.setRoll_no(roll_no);
		bean.setGender(gender);
		bean.setName(firstName+"/"+middleName+"/"+lastName);
		bean.setPwd(pwd);
		bean.setState(state);
		bean.setBranch(branch);
		bean.setSection(section);
		bean.setStd_class(std_class);
		bean.setDegree(degree);
		bean.setBatch(batch);
		
		
		Connection conn = EduHITecDb.getConnection();
		ResultSet rs=null;
		
		
		
		//validate all the values
		ValidateStudent ve = new ValidateStudent();
		boolean flag = ve.validateAddress(address) && ve.validateCity(city) && ve.validateContact(contact_no) &&
				ve.validateEmail(email) && ve.validateFirstName(firstName) && ve.validateGender(gender) && 
				ve.validateLastName(lastName) && ve.validatePwd(pwd) && ve.validateState(state);
		
		
		try {
			//for checking that this email already exist in system or not
//			query = "select email from educator where email=?";
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
			
			//check in student table  for email
			query = "select email from student where email=?";
			
			ps = conn.prepareStatement(query);
			ps.setString(1, email.toLowerCase());
			
			
			rs = ps.executeQuery();
			
			if(rs.next()) {
				flag = false;
				//session.setAttribute("email", "Exist");
			}
			
			
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
			session.setAttribute("no_validStd", bean);
			resp.sendRedirect("add_student.jsp");
		}else {
			query = "insert into student"
					+ "(inst_id, name, email, pwd, roll_no, address, contact_no, status, city, state, gender,"
					+ "validate_email,date_of_linkGen,branch,degree,section,std_class,batch)"
					+ "values(?,?,?,?,?,?,?,?,?,?,?,?,now(),?,?,?,?,?)";
			
				//validation succeed add educator
				ps = conn.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
				ps.setInt(1, new AdminDao().inst_id(admin_id));
				ps.setString(2, firstName.toUpperCase()+" "+middleName.toUpperCase()+" "+lastName.toUpperCase());
				ps.setString(3, email.toLowerCase());
				ps.setString(4,hd.toHexString(hd.getSHA(pwd)));
				ps.setString(5, roll_no.toUpperCase());
				ps.setString(6, address.toUpperCase());
				ps.setString(7, contact_no);
				ps.setBoolean(8, true);
				ps.setString(9, city.toUpperCase());
				ps.setString(10, state.toUpperCase());
				ps.setString(11, gender.toUpperCase());
				ps.setBoolean(12, false);
				ps.setString(13, branch);
				ps.setString(14, degree);
				ps.setString(15, section);
				ps.setString(16, std_class);
				ps.setString(17, batch);
				
				
				if(ps.executeUpdate() > 0) {
					rs = ps.getGeneratedKeys();
					int std_id= -1;
					
					String encodeId = null;
					String upId = null;
					if(rs.next()) {
						std_id = rs.getInt(1);
						//generate the encoded id
						encodeId= hd.encodeMethod(""+rs.getInt(1));
						query = "select date_of_linkGen from student where std_id=?";
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
					
					
				     
				     query = "update student set link=? where std_id=?";
				     
				     ps = conn.prepareStatement(query);
				     ps.setString(1, "http://localhost:8081/EduHITec/confirmStudentMail.jsp?id="+encodeId+"&upid="+upId);
				     ps.setInt(2, std_id);
				     
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
						    		"        <b>Welcome "+firstName.toUpperCase()+" "+middleName.toUpperCase()+" "+lastName.toUpperCase()+
						    		" to EduHITec</b>,<br><br>\r\n" + 
						    		"        Thank you for registering on our portal. You are just one step away from completing the registration.<br>\r\n" + 
						    		"        Please Follow the given link to complete the registration.<br><br><br>\r\n" + 
						    		"        <a href=\"http://localhost:8081/EduHITec/confirmStudentMail.jsp?id="+encodeId+"&upid="+upId+"\">"
						    				+ "http://localhost:8081/EduHITec/confirmStudentMail.jsp?id="+encodeId+"&upid="+upId+"</a>\r\n" + 
						    		"    </div>", "text/html");
						     msg.setSentDate(new Date());
						     
						     Transport.send(msg);
						     System.out.println("Message sent.");
						     
				    	 session.setAttribute("success", "1");
				    	 resp.sendRedirect("add_student.jsp");
				     }else {
				    	 throw new Exception("Problem in setting link back");
				     }
				}else {
					throw new Exception("Problem in adding student details");
				}
		}
		
		} catch (Exception e) {
			System.out.println("Exception at AddStudent : "+e);
			e.printStackTrace();
			session.setAttribute("error", "1");
			resp.sendRedirect("add_student.jsp");
		}finally {
			conn = null;
		}
	}
	
}
