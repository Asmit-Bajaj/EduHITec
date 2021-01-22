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

@WebServlet(urlPatterns= {"/EditSubject"})
public class EditSubject extends HttpServlet{
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn= EduHITecDb.getConnection();
		String subjectName = req.getParameter("subjectName").trim();
		String code = req.getParameter("code").trim();
		String subjectSession = req.getParameter("subjectSession").trim();
		String course = req.getParameter("course").trim();
		System.out.println(req.getParameter("id"));
		int sub_id = Integer.parseInt(new DataHiding().decodeMethod(req.getParameter("id")));
		
		HttpSession session = req.getSession(false);
		
		int admin_id = (Integer)session.getAttribute("admin_id");
		int inst_id= new AdminDao().inst_id(admin_id);
		
		ResultSet rs=null;
		
		ValidateSubject vs = new ValidateSubject();
		boolean flag = vs.validateSubjectName(subjectName);
		
		SubjectBean bean = new SubjectBean();
		
		bean.setSubjectName(subjectName);
		bean.setCode(code);
		
		//check if subject name fulfills the validation or not
		System.out.println(flag);
		if(flag == false) {
			session.setAttribute("no_validSub", bean);
			resp.sendRedirect("check_subjects.jsp");
		}else {
		
			String query = "";
			try {
			
				query = "select subjectName from subject where subjectName=? and inst_id=? and status=? and sub_id !=?";
			
				PreparedStatement ps = conn.prepareStatement(query);
				ps.setString(1, subjectName);
				ps.setInt(2,inst_id);
				ps.setBoolean(3, true);
				ps.setInt(4, sub_id);
			
				rs = ps.executeQuery();
			
			//if this name is already in use or not
				if(rs.next()) {
					session.setAttribute("exist", "name");
					session.setAttribute("no_validSub", bean);
					resp.sendRedirect("check_subjects.jsp");
				
				}else {
					query = "update subject set subjectName=?, code=?,session=?,course=? where sub_id=?";
				
					ps = conn.prepareStatement(query);
					
					ps.setString(1, subjectName.toUpperCase());
					ps.setString(2, code.toUpperCase());
					ps.setString(3, subjectSession.toUpperCase());
					ps.setString(4, course.toUpperCase());
					ps.setInt(5, sub_id);
					
				//edit subjects after performing all validations
					if(ps.executeUpdate() > 0) {
						session.setAttribute("success", "2");
						resp.sendRedirect("check_subjects.jsp");
					}
				}
			
			}catch (Exception e) {
				System.out.println("exception at EditSubject : "+e);
				session.setAttribute("error", "1");
				resp.sendRedirect("check_subjects.jsp");
			
			}finally {
				conn = null;
				rs = null;
			}
		}
	}
}
