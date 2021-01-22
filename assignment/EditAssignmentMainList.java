package assignment;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import connnection.EduHITecDb;

@WebServlet(urlPatterns = { "/EditAssignmentMainList" })
public class EditAssignmentMainList extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String desp = req.getParameter("desp").trim();
		HttpSession sess = req.getSession(false);
		String id = req.getParameter("Eamid");

		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		boolean flag = false;

		ValidateAssignmentMainList va = new ValidateAssignmentMainList();
		flag = va.validateDesp(desp) && va.validateSubject(id);

		if (flag == false) {
			// if validation fails go back
			sess.setAttribute("noValidEdit", "1");
			AssignmentMainListBean bean = new AssignmentMainListBean();

			bean.setDesp(desp);
			bean.setAmid(Integer.parseInt(id));
			sess.setAttribute("bean", bean);
			resp.sendRedirect("uploadAssignment.jsp");
		} else {

			String query = "update assignmentmainlist set desp=? where amid=?";
			try {
				ps = conn.prepareStatement(query);
				ps.setString(1, req.getParameter("desp"));
				ps.setInt(2, Integer.parseInt(id));

				if (ps.executeUpdate() > 0) {
					sess.setAttribute("success", "2");
					resp.sendRedirect("uploadAssignment.jsp");
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadAssignment.jsp");
				}

			} catch (SQLException e) {
				System.out.println("Exception at EditAssignmentMainList:" + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("uploadAssignment.jsp");
			}
		}
	}
}
