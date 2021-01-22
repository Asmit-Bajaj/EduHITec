package admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Base64;

import connnection.EduHITecDb;

public class AdminDao {
	private PreparedStatement ps;
	private Connection conn;
	private ResultSet rs;
	private String query;
	private boolean flag;
	
	
	public String inst_name(int admin_id) {
		String name = null;
		
		if(conn == null) {
			conn = EduHITecDb.getConnection();
		}
		
		try {
			query = "select * from admin where admin_id=?";
			ps = conn.prepareStatement(query);
			System.out.println(admin_id);
			ps.setInt(1, admin_id);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				System.out.println("hii");
				name = rs.getString("inst_name");
			}
			
		} catch (Exception e) {
			System.out.println("Exception at inst_name() : "+e);
		}finally {
			ps=null;
			rs =null;
			conn = null;
			return name;
		}
	}
	
	public int inst_id(int admin_id) {
		int id = 0;
		
		if(conn == null) {
			conn = EduHITecDb.getConnection();
		}
		
		try {
			query = "select * from admin where admin_id=?";
			ps = conn.prepareStatement(query);
			
			ps.setInt(1, admin_id);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				id = rs.getInt("inst_id");
			}
			
		} catch (Exception e) {
			System.out.println("Exception at inst_id() : "+e);
		}finally {
			ps=null;
			rs =null;
			conn = null;
			return id;
		}
	}
	
	
	
		//returns all the students
		public ArrayList<StudentBean> getAllStudents(int inst_id){
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			StudentBean bean = null;
			ArrayList<StudentBean> list = new ArrayList<>();
			
			try {
				query = "select * from student where inst_id=?";
				ps = conn.prepareStatement(query);
				
				ps.setInt(1, inst_id);
				
				rs = ps.executeQuery();
				
				while(rs.next()) {
					bean = new StudentBean();
					bean.setAddress(rs.getString("address"));
					bean.setBatch(rs.getString("batch"));
					bean.setBranch(rs.getString("branch"));
					bean.setCity(rs.getString("city"));
					bean.setContact_no(rs.getString("contact_no"));
					bean.setDegree(rs.getString("degree"));
					bean.setEmail(rs.getString("email"));
					bean.setGender(rs.getString("gender"));
					bean.setInst_id(inst_id);
					bean.setName(rs.getString("name"));
					bean.setRoll_no(rs.getString("roll_no"));
					bean.setSection(rs.getString("section"));
					bean.setState(rs.getString("state"));
					bean.setStatus(rs.getBoolean("status"));
					bean.setStd_class(rs.getString("std_class"));
					bean.setStd_id(rs.getInt("std_id"));
					bean.setValidate_email(rs.getBoolean("validate_email"));
					list.add(bean);
				}
			} catch (Exception e) {
				System.out.println("Exception at getAllStudents() : "+e);
			}finally {
				ps = null;
				rs = null;
				conn = null;
				return list;
			}
		}
		
		//returns all the faculties
		public ArrayList<EducatorBean>getAllEducators(int inst_id){
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			EducatorBean bean = null;
			ArrayList<EducatorBean> list = new ArrayList<>();
			
			try {
				query = "select * from educator where inst_id=?";
				ps = conn.prepareStatement(query);
				
				ps.setInt(1, inst_id);
				
				rs = ps.executeQuery();
				
				while(rs.next()) {
					bean = new EducatorBean();
					bean.setName(rs.getString("name"));
					bean.setEmail(rs.getString("email"));
					bean.setAddress(rs.getString("address"));
					bean.setCity(rs.getString("city"));
					bean.setContact_no(rs.getString("contact_no"));
					bean.setEdu_id(rs.getInt("edu_id"));
					bean.setEmp_id(rs.getString("emp_id"));
					bean.setGender(rs.getString("gender"));
					bean.setInst_id(rs.getInt("inst_id"));
					bean.setStatus(rs.getBoolean("status"));
					bean.setState(rs.getString("state"));
					bean.setValidate_email(rs.getBoolean("validate_email"));
					list.add(bean);
				}
				
			} catch (Exception e) {
				System.out.println("Exception at getAllEducators() : "+e);
			}finally {
				ps = null;
				rs = null;
				conn = null;
				return list;
			}
		}
		
		//returns the specific student
		public StudentBean getStudent(int std_id){
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			StudentBean bean = null;
			
			try {
				query = "select * from student where std_id=?";
				ps = conn.prepareStatement(query);
				
				ps.setInt(1, std_id);
				rs = ps.executeQuery();
				if(rs.next()) {
					bean = new StudentBean();
					bean.setName(rs.getString("name"));
					bean.setEmail(rs.getString("email"));
					
					bean.setRoll_no(rs.getString("roll_no"));
					bean.setInst_id(rs.getInt("inst_id"));
					bean.setStd_id(rs.getInt("std_id"));
				}
			} catch (Exception e) {
				System.out.println("Exception at getStudent() : "+e);
			}finally {
				ps = null;
				rs = null;
				conn = null;
				return bean;
			}
		}
		
		//returns all the subjects of current institute id
		public ArrayList<SubjectBean> getAllSubjects(int inst_id){
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			SubjectBean bean;
			ArrayList<SubjectBean> list = new ArrayList<>();
			try {
				query = "select * from subject where inst_id=? and status=?";
				ps = conn.prepareStatement(query);
				
				ps.setInt(1, inst_id);
				ps.setBoolean(2, true);
				rs = ps.executeQuery();
				
				while(rs.next()) {
					bean = new SubjectBean();
					bean.setInst_id(inst_id);
					bean.setSub_id(rs.getInt("sub_id"));
					bean.setSubjectName(rs.getString("subjectName").toUpperCase());
					if(rs.getString("code") != null)
						bean.setCode(rs.getString("code").toUpperCase());
					else
						bean.setCode("");
					
					if(rs.getString("session") != null)
						bean.setSession(rs.getString("session").toUpperCase());
					else
						bean.setSession("");
					
					if(rs.getString("course") != null)
						bean.setCourse(rs.getString("course").toUpperCase());
					else
						bean.setCourse("");
					
					list.add(bean);
				}
				
			} catch (Exception e) {
				System.out.println("Exception at getAllSubjects() : "+e);
			}finally {
				ps = null;
				rs = null;
				conn = null;
				return list;
			}
			
		}
		
		//returns the complete profile of admin
		public AdminBean getProfile(int admin_id) {
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			AdminBean bean = new AdminBean();
			
			try {
				
				query = "select * from admin where admin_id=?";
				ps = conn.prepareStatement(query);
				
				ps.setInt(1, admin_id);
				
				rs = ps.executeQuery();
				
				if(rs.next()) {
					bean.setAdmin_id(admin_id);
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
