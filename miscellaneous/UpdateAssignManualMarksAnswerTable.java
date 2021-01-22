package miscellaneous;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import connnection.EduHITecDb;
import hide.DataHiding;

@WebServlet(urlPatterns = { "/UpdateAssignManualAnswerTable" })
public class UpdateAssignManualMarksAnswerTable extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		DataHiding hd = new DataHiding();
		String msg = "notvalid";

		int rvid = Integer.parseInt(hd.decodeMethod(req.getParameter("rvid")));

		Connection conn = null;
		String marks = "";
		String isAll = "";
		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		try {
			// Check for this review all questions are graded or not
			String query = "select quesid from studentquizreview where review_id=? and marks_obt=?";
			PreparedStatement ps = conn.prepareStatement(query);

			ps.setInt(1, rvid);
			ps.setString(2, "NA");

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				// all questions are not checked
				isAll = "no";
			} else {
				// all questions are checked
				isAll = "yes";
			}

			query = "select obt_marks from quizreview where review_id=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, rvid);

			rs = ps.executeQuery();

			if (rs.next()) {
				// now convert to json object
				marks = rs.getString("obt_marks");
				JSONObject obj = new JSONObject();
				obj.put("marks", marks);
				obj.put("isAll", isAll);

				msg = String.valueOf(obj);
			} else {
				msg = "error";
			}

			resp.setContentType("text/plain"); // Set content type of the response so that jQuery knows what it can
												// expect.
			resp.setCharacterEncoding("UTF-8");
			resp.getWriter().write(msg);
		} catch (Exception e) {
			System.out.println("Exception at AssignMarksToManualCheck : " + e);
		}

	}
}
