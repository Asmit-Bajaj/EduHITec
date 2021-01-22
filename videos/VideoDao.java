package videos;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Base64.Encoder;

import connnection.EduHITecDb;

public class VideoDao {
	private PreparedStatement ps,ps2;
	private Connection conn;
	private ResultSet rs,rs2;
	private String query,query2;
	private boolean flag;
	
	//gets the institute id of current educator
	public int getInstId(int edu_id) {
		if(conn == null) {
			conn = EduHITecDb.getConnection();
		}
		int inst_id = 0;
		
		try {
			query = "select * from educator where edu_id=?";
			ps = conn.prepareStatement(query);
			
			ps.setInt(1, edu_id);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				inst_id = rs.getInt("inst_id");
			}
			
		} catch (Exception e) {
			System.out.println("Exception at getInstId() : "+e);
		}finally {
			ps=null;
			rs =null;
			conn = null;
			return inst_id;
		}
	}
	
	//returns all the available playlist for current educator
	public ArrayList<VideoPlayListBean> getAllCurrentEducatorPlaylist(int edu_id){
		if(conn == null) {
			conn = EduHITecDb.getConnection();
		}
		
		ArrayList<VideoPlayListBean> list = new ArrayList<>();
		
		VideoPlayListBean bean = null;
		
		try {
			query = "select v.*,s.subjectName,s.code from videoplaylist v, subject s where v.edu_id=? and v.sub_id=s.sub_id";
			ps = conn.prepareStatement(query);
			ps.setInt(1, edu_id);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				bean = new VideoPlayListBean();
				bean.setEdu_id(edu_id);
				bean.setSub_id(rs.getInt("sub_id"));
				bean.setUni_id(rs.getInt("uni_id"));
				bean.setSub_name(rs.getString("subjectName"));
				bean.setDesp(rs.getString("desp"));
				bean.setDate(rs.getString("date_of_addition"));
				bean.setTitle(rs.getString("topic"));
				bean.setSubCode(rs.getString("code"));
				
				
				byte[] arr = rs.getBytes("thumbnail"); //getting photo in terms of bytes
				Encoder encoder = java.util.Base64.getEncoder();//for converting photo to string
				String thumbnail = encoder.encodeToString(arr);
				
				bean.setThumbnail(thumbnail);
				list.add(bean);
			}
			
		}catch (Exception e) {
			System.out.println("Exception at  getAllCurrentEducatorPlaylist() : "+e);
		}finally {
			ps=null;
			rs =null;
			conn = null;
			return list;
		}
	}
	
	//gets the videos of current playlist
	public ArrayList<PlaylistVideosBean> getPlaylistVideos(int uni_id){
		
		if(conn == null) {
			conn = EduHITecDb.getConnection();
		}
		
		ArrayList<PlaylistVideosBean> list = new ArrayList<>();
		
		PlaylistVideosBean bean = null;
		
		try {
			//Thread.sleep(100000);
			query = "select * from playlistvideos where uni_id=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, uni_id);
			
			rs = ps.executeQuery();
			
			while(rs.next()) {
				bean = new PlaylistVideosBean();
				bean.setDesp(rs.getString("desp"));
				bean.setLink(rs.getString("link"));
				bean.setTitle(rs.getString("title"));
				bean.setUni_id(uni_id);
				bean.setVid(rs.getInt("vid"));
				list.add(bean);
			}
			
		}catch (Exception e) {
			System.out.println("Exception at  getPlaylistVideos() : "+e);
		}finally {
			ps=null;
			rs =null;
			conn = null;
			return list;
		}
	}
	
	
	//returns a single playlist based on playlist id
		public VideoPlayListBean getPlaylist(int uni_id){
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			VideoPlayListBean bean = null;
			
			try {
				query = "select v.*,s.subjectName from videoplaylist v, subject s where v.uni_id=? and v.sub_id=s.sub_id";
				ps = conn.prepareStatement(query);
				ps.setInt(1, uni_id);
				
				rs = ps.executeQuery();
				
				if(rs.next()) {
					bean = new VideoPlayListBean();
					//bean.setFac_id(fac_id);
					bean.setSub_id(rs.getInt("sub_id"));
					bean.setSub_name(rs.getString("subjectName"));
					bean.setUni_id(rs.getInt("uni_id"));
					
					bean.setDesp(rs.getString("desp"));
					bean.setDate(rs.getString("date_of_addition"));
					bean.setTitle(rs.getString("topic"));
					
					
					byte[] arr = rs.getBytes("thumbnail"); //getting photo in terms of bytes
					Encoder encoder = java.util.Base64.getEncoder();//for converting photo to string
					String thumbnail = encoder.encodeToString(arr);
					bean.setThumbnail(thumbnail);
				}
				
			}catch (Exception e) {
				System.out.println("Exception at getPlaylist() : "+e);
			}finally {
				ps=null;
				rs =null;
				conn = null;
				return bean;
			}
		}
		
		//returns all the playlist on the basis of institute id
		public ArrayList<VideoPlayListBean> getAllPlaylist(int inst_id){
			if(conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			VideoPlayListBean bean = null;
			ArrayList<VideoPlayListBean> list = new ArrayList();
			
			try {
				query = "select v.*,s.subjectName,s.code,e.name from videoplaylist v, subject s, educator e where v.inst_id=? and v.sub_id=s.sub_id and v.edu_id=e.edu_id";
				ps = conn.prepareStatement(query);
				ps.setInt(1, inst_id);
				
				rs = ps.executeQuery();
				
				while(rs.next()) {
					bean = new VideoPlayListBean();
					//bean.setFac_id(fac_id);
					bean.setSub_id(rs.getInt("sub_id"));
					bean.setSub_name(rs.getString("subjectName"));
					bean.setUni_id(rs.getInt("uni_id"));
					bean.setCreatedBy(rs.getString("name"));
					bean.setDesp(rs.getString("desp"));
					bean.setDate(rs.getString("date_of_addition"));
					bean.setTitle(rs.getString("topic"));
					bean.setSubCode(rs.getString("code"));
					byte[] arr = rs.getBytes("thumbnail"); //getting photo in terms of bytes
					Encoder encoder = java.util.Base64.getEncoder();//for converting photo to string
					String thumbnail = encoder.encodeToString(arr);
					bean.setThumbnail(thumbnail);
					list.add(bean);
				}
				
			}catch (Exception e) {
				System.out.println("Exception at getAllPlaylist() : "+e);
			}finally {
				ps=null;
				rs =null;
				conn = null;
				return list;
			}
		}
}
