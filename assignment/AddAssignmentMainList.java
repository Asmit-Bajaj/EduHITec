package assignment;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import admin.ValidateSubject;
import connnection.EduHITecDb;
import notes.NotesSubjectBean;

@WebServlet(urlPatterns = { "/AddAssignmentMainList" })
public class AddAssignmentMainList extends HttpServlet {

	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		Connection conn = EduHITecDb.getConnection();
		HttpSession sess = req.getSession(false);
		PreparedStatement ps = null;

		String desp = req.getParameter("desp").trim();

		String id = req.getParameter("selectSubject");
		boolean flag = false;

		ValidateAssignmentMainList va = new ValidateAssignmentMainList();

		flag = va.validateDesp(desp) && va.validateSubject(id);

		if (flag == false) {
			// if validation fails go back
			sess.setAttribute("noValidAdd", "1");
			AssignmentMainListBean bean = new AssignmentMainListBean();

			bean.setDesp(desp);
			if (id != null && id.isEmpty() == false)
				bean.setSub_id(Integer.parseInt(id));
			else
				bean.setSub_id(-1);

			sess.setAttribute("bean", bean);
			resp.sendRedirect("uploadAssignment.jsp");
		} else {
			//validation succeed add the record
			String query = "insert into assignmentmainlist(sub_id,edu_id,desp)values(?,?,?)";
			try {
				ps = conn.prepareStatement(query);
				ps.setInt(1, Integer.parseInt(id));
				ps.setInt(2, (Integer) sess.getAttribute("edu_id"));
				ps.setString(3, desp);

				if (ps.executeUpdate() > 0) {
					sess.setAttribute("success", "1");
					resp.sendRedirect("uploadAssignment.jsp");
				} else {
					sess.setAttribute("error", "1");
					resp.sendRedirect("uploadAssignment.jsp");
				}

			} catch (Exception e) {
				System.out.println("Exception at AddAssignmentMainList:" + e);
				sess.setAttribute("error", "1");
				resp.sendRedirect("uploadAssignment.jsp");
			}
		}
	}
}
