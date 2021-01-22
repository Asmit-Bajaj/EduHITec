package notes;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Base64.Encoder;

import connnection.EduHITecDb;
import videos.PlaylistVideosBean;
import videos.VideoPlayListBean;


public class NotesDao {
	private PreparedStatement ps,ps2;
	private Connection conn;
	private ResultSet rs,rs2;
	private String query,query2;
	private boolean flag;
	
	//returns all the available notes playlist for current educator
		public ArrayList<NotesSubjectBean> getAllCurrentEducatorNotesSubject(int edu_id){
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			ArrayList<NotesSubjectBean> list = new ArrayList<>();
			
			NotesSubjectBean bean = null;
			
			try {
				query = "select n.*,s.subjectName,s.code from notessubject n, subject s where n.edu_id=? and n.sub_id=s.sub_id";
				ps = conn.prepareStatement(query);
				ps.setInt(1, edu_id);
				
				rs = ps.executeQuery();
				
				while(rs.next()) {
					bean = new NotesSubjectBean();
					bean.setEdu_id(edu_id);
					bean.setSub_id(rs.getInt("sub_id"));
					bean.setNpid(rs.getInt("npid"));
					bean.setSub_name(rs.getString("subjectName"));
					bean.setDesp(rs.getString("desp"));
					bean.setDatetime(rs.getString("datetime"));
					bean.setTitle(rs.getString("title"));
					bean.setCode(rs.getString("code"));
					
					list.add(bean);
				}
				
			}catch (Exception e) {
				System.out.println("Exception at  getAllCurrentEducatorNotesSubject() : "+e);
			}finally {
				ps=null;
				rs =null;
				conn = null;
				return list;
			}
		}
		
		//gets current notes list notes
		public ArrayList<SubjectNotesBean> getNoteslistNotes(int npid){
			
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			ArrayList<SubjectNotesBean> list = new ArrayList<>();
			
			SubjectNotesBean bean = null;
			
			try {
				//Thread.sleep(100000);
				query = "select * from subjectnotes where npid=?";
				ps = conn.prepareStatement(query);
				ps.setInt(1, npid);
				
				rs = ps.executeQuery();
				
				while(rs.next()) {
					bean = new SubjectNotesBean();
					bean.setPath(rs.getString("path"));
					bean.setTitle(rs.getString("title"));
					bean.setNpid(npid);
					bean.setNid(rs.getInt("nid"));
					bean.setExt(rs.getString("ext"));
					list.add(bean);
				}
				
			}catch (Exception e) {
				System.out.println("Exception at  getNoteslistNotes() : "+e);
			}finally {
				ps=null;
				rs =null;
				conn = null;
				return list;
			}
		}
		
		//returns a single Notes list based on list id
				public NotesSubjectBean getNoteslist(int npid){
					if(conn == null) {
						conn = EduHITecDb.getConnection();
					}
					
					NotesSubjectBean bean = null;
					
					try {
						query = "select n.*,s.subjectName,s.code from notessubject n, "
								+ "subject s where n.npid=? and n.sub_id=s.sub_id";
						ps = conn.prepareStatement(query);
						ps.setInt(1, npid);
						
						rs = ps.executeQuery();
						
						if(rs.next()) {
							bean = new NotesSubjectBean();
							//bean.setFac_id(fac_id);
							bean.setSub_id(rs.getInt("sub_id"));
							bean.setSub_name(rs.getString("subjectName"));
							bean.setNpid(rs.getInt("npid"));
							
							bean.setDesp(rs.getString("desp"));
							bean.setDatetime(rs.getString("datetime"));
							bean.setTitle(rs.getString("title"));
							bean.setCode(rs.getString("code"));
						}
						
					}catch (Exception e) {
						System.out.println("Exception at getNoteslist() : "+e);
					}finally {
						ps=null;
						rs =null;
						conn = null;
						return bean;
					}
				}
				
				//returns all the playlist on the basis of institute id
				public ArrayList<NotesSubjectBean> getAllNoteslist(int inst_id){
					if(conn == null) {
						conn = EduHITecDb.getConnection();
					}
					
					NotesSubjectBean bean = null;
					ArrayList<NotesSubjectBean> list = new ArrayList();
					
					try {
						query = "select ns.*,s.subjectName,s.code,e.name from notessubject ns, subject s, educator e where ns.inst_id=? and ns.sub_id=s.sub_id and ns.edu_id=e.edu_id";
						ps = conn.prepareStatement(query);
						ps.setInt(1, inst_id);
						
						rs = ps.executeQuery();
						
						while(rs.next()) {
							bean = new NotesSubjectBean();
							//bean.setFac_id(fac_id);
							bean.setSub_id(rs.getInt("sub_id"));
							bean.setSub_name(rs.getString("subjectName"));
							bean.setNpid(rs.getInt("npid"));
							bean.setCreatedBy(rs.getString("name"));
							bean.setDesp(rs.getString("desp"));
							bean.setDatetime(rs.getString("datetime"));
							bean.setTitle(rs.getString("title"));
							bean.setCode(rs.getString("code"));
							list.add(bean);
						}
						
					}catch (Exception e) {
						System.out.println("Exception at getAllNoteslist() : "+e);
					}finally {
						ps=null;
						rs =null;
						conn = null;
						return list;
					}
				}
}
