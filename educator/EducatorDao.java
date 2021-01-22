package educator;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import admin.AdminBean;
import connnection.EduHITecDb;

public class EducatorDao {
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	String query;
	
	//returns the complete profile of educator
			public EducatorProfileBean getProfile(int edu_id) {
				if(conn == null) {
					conn = EduHITecDb.getConnection();
				}
				
				EducatorProfileBean bean = new EducatorProfileBean();
				
				try {
					
					query = "select * from educator where edu_id=?";
					ps = conn.prepareStatement(query);
					
					ps.setInt(1, edu_id);
					
					rs = ps.executeQuery();
					
					if(rs.next()) {
						bean.setEdu_id(edu_id);
						bean.setAddress(rs.getString("address").toUpperCase());
						bean.setCity(rs.getString("city").toUpperCase());
						bean.setContact_no(rs.getString("contact_no").toUpperCase());
						bean.setEmail(rs.getString("email"));
						if(rs.getString("emp_id") != null && rs.getString("emp_id").equals("") == false)
							bean.setEmp_id(rs.getString("emp_id").toUpperCase());
						else
							bean.setEmp_id(null);
						
						bean.setGender(rs.getString("gender").toUpperCase());
						bean.setInst_id(rs.getInt("inst_id"));
						bean.setName(rs.getString("name").toUpperCase());
						bean.setState(rs.getString("state").toUpperCase());
					}
					
				} catch (Exception e) {
					System.out.println("Exception at getprofile() : "+e);
				}finally {
					conn = null;
					rs = null;
					ps = null;
					return bean;
				}
			}
}
