package assignment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Base64.Encoder;

import connnection.EduHITecDb;
import notes.NotesSubjectBean;
import notes.SubjectNotesBean;
import videos.VideoPlayListBean;

public class AssignmentDao {
	private PreparedStatement ps,ps2;
	private Connection conn;
	private ResultSet rs,rs2;
	private String query,query2;
	private boolean flag;
	
	//returns all the assignmentMainList of current educator
	public ArrayList<AssignmentMainListBean> getAllCurrentEducatorAssignmentMainList(int edu_id){
		if(conn == null) {
			conn = EduHITecDb.getConnection();
		}
		
		ArrayList<AssignmentMainListBean> list = new ArrayList<>();
		AssignmentMainListBean bean = null;
		
		try {
			query = "select am.*,s.subjectName,s.code "
					+ "from assignmentmainlist am, subject s where am.edu_id=? and am.sub_id=s.sub_id";
			ps = conn.prepareStatement(query);
			ps.setInt(1, edu_id);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				bean = new AssignmentMainListBean();
				bean.setEdu_id(edu_id);
				bean.setSub_id(rs.getInt("sub_id"));
				bean.setAmid(rs.getInt("amid"));
				bean.setSubjectName(rs.getString("subjectName"));
				bean.setDesp(rs.getString("desp"));
				bean.setCode(rs.getString("code"));
				list.add(bean);
			}
			
		}catch (Exception e) {
			System.out.println("Exception at  getAllCurrentEducatorAssignmentMainList() : "+e);
		}finally {
			ps=null;
			rs =null;
			conn = null;
			return list;
		}
	}
	
	//gets assignments of current AssignmentMainList 
			public ArrayList<MainListAssignmentsBean> getMainListAssignments(int amid){
				
				if(conn == null) {
					conn = EduHITecDb.getConnection();
				}
				
				ArrayList<MainListAssignmentsBean> list = new ArrayList<>();
				
				 MainListAssignmentsBean bean = null;
				
				try {
					
					query = "select * from mainlistassignments where amid=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, amid);
					
					rs = ps.executeQuery();
					
					while(rs.next()) {
						bean = new MainListAssignmentsBean();
						bean.setPath(rs.getString("path").split("#"));
						bean.setTitle(rs.getString("title"));
						bean.setDeadline(rs.getString("deadline"));
						bean.setInstructions(rs.getString("instructions"));
						bean.setAmid(amid);
						bean.setMarks(rs.getInt("marks"));
						bean.setCode(rs.getString("code"));
						bean.setAsgid(rs.getInt("asgid"));
						bean.setNo_of_files(rs.getInt("no_of_files"));
						bean.setExtensions(rs.getString("extensions").split("/"));
						bean.setOrgNames(rs.getString("orgnames").split("/"));
						list.add(bean);
					}
					
				}catch (Exception e) {
					System.out.println("Exception at  getMainListAssignments() : "+e);
				}finally {
					ps=null;
					rs =null;
					conn = null;
					return list;
				}
			}
			
			//return a single assignment list
			public AssignmentMainListBean getAssignmentlist(int amid){
				if(conn == null) {
					conn = EduHITecDb.getConnection();
				}
				
				AssignmentMainListBean bean = null;
				
				try {
					query = "select am.*,s.subjectName,s.code from assignmentmainlist am, "
							+ "subject s where am.amid=? and am.sub_id=s.sub_id";
					ps = conn.prepareStatement(query);
					ps.setInt(1, amid);
					
					rs = ps.executeQuery();
					
					if(rs.next()) {
						bean = new AssignmentMainListBean();
						//bean.setFac_id(fac_id);
						bean.setSub_id(rs.getInt("sub_id"));
						bean.setSubjectName(rs.getString("subjectName"));
						bean.setAmid(rs.getInt("amid"));
						
						bean.setDesp(rs.getString("desp"));
						bean.setCode(rs.getString("code"));
					}
					
				}catch (Exception e) {
					System.out.println("Exception at getAssignmentlist() : "+e);
				}finally {
					ps=null;
					rs =null;
					conn = null;
					return bean;
				}
			}
			
			
			public ArrayList<UnlockedAssignmentBean>getUnlockedAssignment(int std_id) {
				UnlockedAssignmentBean bean = null;
				
				ArrayList<UnlockedAssignmentBean> list = new ArrayList();
				
				if(conn == null) {
					conn = EduHITecDb.getConnection();
				}
				
				query = "select sb.code,ua.*,ma.*,am.sub_id,sb.subjectName,ed.name,ed.edu_id from unlockedassignment ua,mainlistassignments ma,"
						+ "assignmentmainlist am,subject sb,educator ed where ua.std_id=? and ma.asgid = ua.asgid and am.amid = ma.amid and "
						+ "sb.sub_id = am.sub_id and ed.edu_id = am.edu_id";
				
				try {
					ps = conn.prepareStatement(query);
					ps.setInt(1, std_id);
					
					rs = ps.executeQuery();
					
					while(rs.next()) {
						bean = new UnlockedAssignmentBean();
						bean.setAsgid(rs.getInt("asgid"));
						bean.setCreatedBy(rs.getString("name"));
						bean.setSubjectName(rs.getString("subjectName"));
						bean.setTitle(rs.getString("title"));
						bean.setEdu_id(rs.getInt("edu_id"));
						bean.setCode(rs.getString("code"));
						
						query = "select marks from asgmnsubmissions where std_id=? and asgid = ?";
						
						ps = conn.prepareStatement(query);
						ps.setInt(1, std_id);
						ps.setInt(2, rs.getInt("asgid"));
						rs2 = ps.executeQuery();
						
						//to check the submission is graded or not or is it due
						if(rs2.next()){
							System.out.println(rs2.getInt("marks"));
							if(rs2.getInt("marks") == -1)
								bean.setStatus("ng");
							else
								bean.setStatus("g");
						}else {
							bean.setStatus("Due");
						}
						
						list.add(bean);
					}
				} catch (Exception e) {
					System.out.println("Exception at getUnlockedAssignment() : "+e);
				}finally {
					conn = null;
					ps =null;
					rs = null;
					return list;
				}
				
			}
			
			//returns the assignment given the assignment id
			public ArrayList<Object> getAssignment(int asgid,int std_id){
				
				if(conn == null) {
					conn = EduHITecDb.getConnection();
				}
				
				 MainListAssignmentsBean bean = null;
				 ArrayList<Object>list = new ArrayList();
				 SubmissionBean bean1 = null;
				 
				try {
					query = "select * from mainlistassignments where asgid=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, asgid);
				
					
					rs = ps.executeQuery();
					
					if(rs.next()) {
						bean = new MainListAssignmentsBean();
						bean.setPath(rs.getString("path").split("#"));
						bean.setTitle(rs.getString("title"));
						bean.setDeadline(rs.getString("deadline"));
						bean.setInstructions(rs.getString("instructions"));
						bean.setAmid(rs.getInt("amid"));
						bean.setMarks(rs.getInt("marks"));
						bean.setCode(rs.getString("code"));
						bean.setAsgid(rs.getInt("asgid"));
						bean.setNo_of_files(rs.getInt("no_of_files"));
						bean.setExtensions(rs.getString("extensions").split("/"));
						bean.setOrgNames(rs.getString("orgnames").split("/"));
						list.add(bean);
//						System.out.println(" I am in first");
					}
					
					query = "select * from asgmnsubmissions where std_id=? and asgid=?";
					ps = conn.prepareStatement(query);
					ps.setInt(1, std_id);
					ps.setInt(2, asgid);
					
					rs = ps.executeQuery();
					
					if(rs.next()) {
						
						bean1 = new SubmissionBean();
						bean1.setAsgid(asgid);
						bean1.setDatetime(rs.getString("datetime"));
						bean1.setFeedback(rs.getString("feedback"));
						bean1.setMarks(rs.getInt("marks"));
						
						String[] arr = rs.getString("orgnames").split("/");
						bean1.setOrgnames(arr);
						bean1.setPath(rs.getString("path").split("#"));
						arr = rs.getString("extensions").split("/");
						bean1.setExtensions(arr);
						bean1.setNo_of_files(rs.getInt("no_of_files"));
						
						bean1.setStd_id(std_id);
						
						bean1.setRet_no_of_files(rs.getInt("ret_no_of_files"));
						if(rs.getString("ret_extensions") != null)
							bean1.setRet_extensions(rs.getString("ret_extensions").split("/"));
						else
							bean1.setRet_extensions(null);
						
						if(rs.getString("ret_orgnames") != null)
							bean1.setRet_orgnames(rs.getString("ret_orgnames").split("/"));
						else
							bean1.setRet_orgnames(null);
						
						if(rs.getString("ret_path") != null)
							bean1.setRet_path(rs.getString("ret_path").split("#"));
						else
							bean1.setRet_path(null);
						list.add(bean1);
					}else {
						list.add(null);
					}
					
				}catch (Exception e) {
					System.out.println("Exception at  getAssignment() : "+e);
				}finally {
					ps=null;
					rs =null;
					conn = null;
					return list;
				}
				
			}
			
			//returns the submission to this assignment
			public ArrayList<SubmissionBean>getAllSubmissions(int asgid){
				SubmissionBean bean = null;
				System.out.println(asgid);
				ArrayList<SubmissionBean>list = new ArrayList<>();
				
				query = "select asm.*,s.*,ma.marks as max_marks from "
						+ "asgmnsubmissions asm,student s,mainlistassignments ma where asm.asgid=? "
						+ "and asm.std_id=s.std_id and ma.asgid=asm.asgid order by asm.marks asc";
				
				if(conn == null) {
					conn = EduHITecDb.getConnection();
				}
				try {
					ps = conn.prepareStatement(query);
					ps.setInt(1, asgid);
					rs = ps.executeQuery();
					
					while(rs.next()) {
						bean = new SubmissionBean();
						bean.setAsgid(asgid);
						bean.setDatetime(rs.getString("datetime"));
						bean.setExtensions(rs.getString("extensions").split("/"));
						bean.setFeedback(rs.getString("feedback"));
						bean.setMarks(rs.getInt("marks"));
						bean.setNo_of_files(rs.getInt("no_of_files"));
						bean.setOrgnames(rs.getString("orgnames").split("/"));
						bean.setPath(rs.getString("path").split("#"));
						bean.setStd_id(rs.getInt("std_id"));
						bean.setName(rs.getString("name"));
						bean.setRollno(rs.getString("roll_no"));
						bean.setMaxMarks(rs.getInt("max_marks"));
						bean.setEmail(rs.getString("email"));
						bean.setContact_no(rs.getString("contact_no"));
						bean.setBatch(rs.getString("batch"));
						bean.setBranch(rs.getString("branch"));
						bean.setDegree(rs.getString("degree"));
						bean.setSection(rs.getString("section"));
						bean.setStd_class(rs.getString("std_class"));
						list.add(bean);
					}
					
				} catch (Exception e) {
					System.out.println("Exception at getAllSubmissions() : "+e);
				}finally {
					ps = null;
					conn = null;
					rs = null;
					return list;
					
				}
			}
			
}
