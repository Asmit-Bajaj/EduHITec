package student;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;
import hide.DataHiding;
import login.LoginBean;
import login.Validate;

@WebServlet(urlPatterns = { "/StudentLogin" })
public class StudentLogin extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		PreparedStatement ps = null;
		ResultSet rs = null;

		String email = req.getParameter("email").trim();
		String pwd = req.getParameter("pwd").trim();
		String role = req.getParameter("role");
		HttpSession session = req.getSession();

		Validate ve = new Validate();
		// validate email at server

		boolean flag = ve.validateEmail(email) && ve.validatePwd(pwd) && ve.validateRole(role);
		LoginBean bean = new LoginBean();
		bean.setEmail(email);
		bean.setPwd(pwd);
		bean.setRole(role);

		if (flag == false) {
			session.setAttribute("bean", bean);
			resp.sendRedirect("login.jsp");

		} else {
			DataHiding dh = new DataHiding();

			String query = "select std_id,inst_id,validate_email from student where email=? and pwd=?";
			Connection conn = EduHITecDb.getConnection();

			try {
				pwd = dh.toHexString(dh.getSHA(pwd));

				ps = conn.prepareStatement(query);
				ps.setString(1, email);
				ps.setString(2, pwd);
				

				rs = ps.executeQuery();

				if (rs.next()) {
					if (rs.getBoolean("validate_email")) {
						System.out.println(rs.getInt("std_id"));
						//update login to true
						query = "update student set loggedIn=? where std_id=?";
						
						ps = conn.prepareStatement(query);
						ps.setBoolean(1, true);
						ps.setInt(2, rs.getInt("std_id"));
						
						ps.executeUpdate();
						
						session.setAttribute("std_id", rs.getInt("std_id"));
						session.setAttribute("inst_id", rs.getInt("inst_id"));

						ps = null;
						rs = null;
						conn = null;
						resp.sendRedirect("student_home.jsp");
					} else {
						//if email is not validated yet then validate it
						session.setAttribute("bean", bean);
						session.setAttribute("validate","0");
						resp.sendRedirect("login.jsp");
					}
				} else {
					ps = null;
					rs = null;
					conn = null;
					session.setAttribute("bean", bean);
					session.setAttribute("novalid", "0");
					resp.sendRedirect("login.jsp");
				}

			} catch (Exception e) {
				System.out.println("Exception at studentLogin: " + e);
				session.setAttribute("error", "0");
				resp.sendRedirect("login.jsp");
			}

		}
	}
}
