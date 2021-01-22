package admin;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;

@WebServlet(urlPatterns= {"/ReactivateStudent"})
public class ReactivateStudent extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		
		int edu_id = Integer.parseInt(req.getParameter("id"));
		HttpSession session = req.getSession(false);
		
		Connection conn = EduHITecDb.getConnection();
		
		try {
			//update the status to true (activate)
			String query = "update student set status=? where std_id=?";
			PreparedStatement ps = conn.prepareStatement(query);
			
			ps.setBoolean(1, true);
			ps.setInt(2, edu_id);
			
			if(ps.executeUpdate() > 0) {
				session.setAttribute("success", "3");
				resp.sendRedirect("check_students.jsp");
			}else {
				throw new Exception("Student not found");
			}
		}catch (Exception e) {
			System.out.println("Exception at ReactivateStudent : "+e);
			e.printStackTrace();
			session.setAttribute("error", "1");
			resp.sendRedirect("check_students.jsp");
		}
	}
}
