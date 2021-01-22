package quiz;

import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import connnection.EduHITecDb;
import file.FileOperations;
import hide.DataHiding;

@MultipartConfig(maxFileSize = 567898989)
@WebServlet(urlPatterns= {"/AddQuestion"})
public class AddQuestion extends HttpServlet {
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		Connection conn = EduHITecDb.getConnection();
		PreparedStatement ps = null;
		int quizid = Integer.parseInt(req.getParameter("id"));
		int quesid = -1;
		
		
		System.out.println(quizid);
		
		String path = "H:\\java\\EduHITec\\WebContent\\quesAns\\";
		String fileName = "EduHITec_";
		String query = "insert into quesans(quizid, ques, no_of_attch_ques, quesAttAbslPath, "
				+ "category, fillBlAns, no_of_options, options, optionsAttAbslPath, "
				+ "optionsAns, marks, timer,neg_marking,explanation_type,explanation,manualCheck)values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
		
		//setting mandatory fields first
		try {
			ps = conn.prepareStatement(query,Statement.RETURN_GENERATED_KEYS);
			ps.setInt(1, quizid);
			ps.setString(2, req.getParameter("ques"));
			ps.setInt(3, -1);
			ps.setString(4, null);
			
			int category = Integer.parseInt(req.getParameter("category"));
			ps.setInt(5, category);
			
			//if manual check is enabled then set manual check field as true else false
			if(category == 2) {
				if(req.getParameter("fillBlMarkScheme")!= null && req.getParameter("fillBlMarkScheme").equals("1")) {
					ps.setBoolean(16, true);
					ps.setString(6, null);
				}else {
					ps.setBoolean(16, false);
					ps.setString(6, req.getParameter("filBlAns"));
				}
			}else {
				ps.setBoolean(16, false);
				ps.setString(6, null);
			}
			
			ps.setInt(7,-1);
			ps.setString(8, null);
			ps.setString(9, null);
			ps.setString(10, null);
			ps.setInt(11, Integer.parseInt(req.getParameter("marks")));
			if(req.getParameter("timer") == null) {
				ps.setInt(12,-1);
			}else {
				ps.setInt(12, Integer.parseInt(req.getParameter("timer")));
			}
			
			if(req.getParameter("neg_marking_sel").equals("1")) {
				ps.setInt(13, Integer.parseInt(req.getParameter("neg_marking")));
			}else {
				ps.setInt(13, -1);
			}
			
			//1 for text 2 for link
			if(req.getParameter("exp_sel").equals("text")) {
				ps.setInt(14, 1);
				ps.setString(15, req.getParameter("expText"));
			}else {
				ps.setInt(14, 2);
				ps.setString(15, req.getParameter("expLink"));
			}
			
			
			
			if(ps.executeUpdate() > 0) {
				//now looking for attachments with question
				System.out.println("yes");
				ResultSet rs = ps.getGeneratedKeys();
				System.out.println("middle");
				rs.next();
				quesid = rs.getInt(1);
				System.out.println("nooo");
				
				if(req.getParameter("anyQuesAttachments").equals("1")) {
					query = "update quesans set no_of_attch_ques=?,quesAttAbslPath=?,ext_ques_attach=? where quesid=?";
					
					int count = 0;
					
					List<Part> fileParts = req.getParts().stream().
							filter(part -> "quesAttachments".equals(part.getName())).collect(Collectors.toList()); 
					// Retrieves <input type="file" name="file" multiple="true">
					
					String extensions = "";
					String ext = "";
					String absPath = "";
					
					//for storing the attachments related to questions
					
					 for (Part filePart : fileParts) {
						
						 String name = FileOperations.extractFileName(filePart);
						 ext = FileOperations.getExtension(name);
						 
						 if(count == 0)
							 extensions = extensions+ext;
						else
							  extensions = extensions+"/"+ext;
						 
						 InputStream file = filePart.getInputStream();
							
							int i = 0;
							FileOutputStream writer = new FileOutputStream(path+fileName+quizid+quesid+"q"+count+"."+ext);
							while ((i = file.read()) != -1) {
								writer.write((char) i);
							}
							file.close();
							writer.close();
							if(count == 0)
								absPath = absPath+path+fileName+quizid+quesid+"q"+count+"."+ext;
							else
								absPath = absPath+"#"+path+fileName+quizid+quesid+"q"+count+"."+ext;
						 count++;
					}
					
					ps = conn.prepareStatement(query);
					ps.setInt(1, count);
					ps.setString(2, absPath);
					ps.setString(3, extensions);
					ps.setInt(4, quesid);
					
					if(ps.executeUpdate() <= 0) {
						resp.sendRedirect("educatorQuizSubSection2.jsp?qzid="+quizid+"&error=1");
					}
				}
				
				//now if category is 1 update for mcq options
				if(category == 1) {
					String options = "";
					String extensions = "";
					String ext = "";
					String absPath = "";
					int count = 0;
					System.out.println("hii");
					
					for(int i=0;i<Integer.parseInt(req.getParameter("no_of_options"));i++) {
						
						if(req.getParameter("type"+(i+1)).equals("textual")) {
							if(i == 0)
								options+=req.getParameter("textOption"+(i+1));
							else
								options+="@%"+req.getParameter("textOption"+(i+1));
						}else {
							if(i == 0)
								options+="-1";
							else
								options+="@%"+"-1";
							
							Part filePart = req.getPart("imgOption"+(i+1));
							
							String name = FileOperations.extractFileName(filePart);
							 ext = FileOperations.getExtension(name);
							 
							if(count == 0)
								 extensions = extensions+ext;
							else
								  extensions = extensions+"/"+ext;
							 
							 InputStream file = filePart.getInputStream();
								
								int j = 0;
								FileOutputStream writer = new FileOutputStream(path+fileName+quizid+quesid+"a"+(i+1)+"."+ext);
								while ((j = file.read()) != -1) {
									writer.write((char) j);
								}
								file.close();
								writer.close();
								if(count == 0)
									absPath = absPath+path+fileName+quizid+quesid+"a"+(i+1)+"."+ext;
								else
									absPath = absPath+"#"+path+fileName+quizid+quesid+"a"+(i+1)+"."+ext;
								count++;
						}
					}
					
					query = "update quesans set options=?,optionsAttAbslPath=?,optionsAns=?,ext_opt_attach=?,no_of_options=? where quesid=?";
					
					ps = conn.prepareStatement(query);
					
					ps.setString(1, options);
					
					if(absPath.equals(""))
						ps.setString(2, null);
					else
						ps.setString(2, absPath);
					
					ps.setString(3, req.getParameter("optans"));
					
					if(extensions.equals(""))
						ps.setString(4, null);
					else
						ps.setString(4, extensions);
					
					ps.setInt(5, Integer.parseInt(req.getParameter("no_of_options")));
					ps.setInt(6, quesid);
					
					if(ps.executeUpdate() > 0) {
						resp.sendRedirect("educatorQuizSubSection2.jsp?qzid="+new DataHiding().encodeMethod(String.valueOf(quizid))+"&success=1"+"&timer=0");
					}else{
						resp.sendRedirect("educatorQuizSubSection2.jsp?qzid="+new DataHiding().encodeMethod(String.valueOf(quizid))+"&error=1"+"&timer=0");
					}
				}else {
					resp.sendRedirect("educatorQuizSubSection2.jsp?qzid="+new DataHiding().encodeMethod(String.valueOf(quizid))+"&success=1"+"&timer=0");
				}
			}else{
				resp.sendRedirect("educatorQuizSubSection2.jsp?qzid="+new DataHiding().encodeMethod(String.valueOf(quizid))+"&error=1"+"&timer=0");
			}
			
		} catch (Exception e) {
			System.out.println("Exception at AddQuestion : "+e);
			e.printStackTrace();
			resp.sendRedirect("educatorQuizSubSection2.jsp?qzid="+new DataHiding().encodeMethod(String.valueOf(quizid))+"&error=1"+"&timer=0");
		}
	}
}
