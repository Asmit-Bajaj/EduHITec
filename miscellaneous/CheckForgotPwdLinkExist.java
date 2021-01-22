package miscellaneous;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import connnection.EduHITecDb;

public class CheckForgotPwdLinkExist {
	//check does this link really exist or not
	public boolean checkLink(String link) {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps;
		
		boolean flag = false;
		try {
			String query = "select link from forgotpwd where link=? and DATEDIFF(now(),date) < 3";
			ps = conn.prepareStatement(query);
			ps.setString(1, link);

			if(ps.executeQuery().next()) {
				flag = true;
			}
			
		}catch (Exception e) {
			// TODO: handle exception
		}finally {
			conn = null;
			ps = null;
			return flag;
		}
	}
}
