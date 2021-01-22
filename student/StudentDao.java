package student;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import connnection.EduHITecDb;


public class StudentDao {
	Connection conn = null;
	PreparedStatement ps = null;
	ResultSet rs = null;
	String query;
	
	//returns the complete profile of student
			public StudentProfileBean getProfile(int std_id) {
				if(conn == null) {
					conn = EduHITecDb.getConnection();
				}
				
				StudentProfileBean bean = new StudentProfileBean();
				
				try {
					
					query = "select * from student where std_id=?";
					ps = conn.prepareStatement(query);
					
					ps.setInt(1, std_id);
					
					rs = ps.executeQuery();
					
					if(rs.next()) {
						bean.setStd_id(std_id);
						bean.setAddress(rs.getString("address").toUpperCase());
						bean.setCity(rs.getString("city").toUpperCase());
						bean.setContact_no(rs.getString("contact_no").toUpperCase());
						bean.setEmail(rs.getString("email"));
						if(rs.getString("roll_no") != null && rs.getString("roll_no").equals("") == false)
							bean.setRoll_no(rs.getString("roll_no").toUpperCase());
						else
							bean.setRoll_no(null);
						
						bean.setGender(rs.getString("gender").toUpperCase());
						
						bean.setName(rs.getString("name").toUpperCase());
						bean.setState(rs.getString("state").toUpperCase());
						
						if(rs.getString("branch") != null && rs.getString("branch").equals("") == false)
							bean.setBranch(rs.getString("branch").toUpperCase());
						else
							bean.setBranch(null);
						
						if(rs.getString("degree") != null && rs.getString("degree").equals("") == false)
							bean.setDegree(rs.getString("degree").toUpperCase());
						else
							bean.setDegree(null);
						
						if(rs.getString("section") != null && rs.getString("section").equals("") == false)
							bean.setSection(rs.getString("section").toUpperCase());
						else
							bean.setSection(null);
						
						if(rs.getString("batch") != null && rs.getString("batch").equals("") == false)
							bean.setBatch(rs.getString("batch").toUpperCase());
						else
							bean.setBatch(null);
						
						if(rs.getString("std_class") != null && rs.getString("std_class").equals("") == false)
							bean.setStd_class(rs.getString("std_class").toUpperCase());
						else
							bean.setStd_class(null);
						
						
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
