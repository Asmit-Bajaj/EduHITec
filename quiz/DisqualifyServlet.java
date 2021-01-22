package quiz;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns= {"/disqualifyServlet"})
public class DisqualifyServlet extends HttpServlet{

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		int qzid = Integer.parseInt(req.getParameter("qzid"));
		System.out.println(qzid);
		//new quizDao().releaseLock(qzid);
		boolean flag = new quizDao().updateAttemptCount(qzid, (Integer)req.getSession(false).getAttribute("std_id"));
		
		System.out.println(flag);
		if(flag) {
			resp.sendRedirect("disqualify.jsp?success=1");
		}else {
			resp.sendRedirect("disqualify.jsp?error=1");
		}
	}
}
