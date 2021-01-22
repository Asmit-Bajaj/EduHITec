<%@page import="hide.DataHiding"%>
<%@page import="videos.VideoPlayListBean"%>
<%@page import="java.lang.reflect.Array"%>
<%@page import="videos.VideoDao"%>
<%@page import="admin.AdminDao"%>
<%@page import="admin.SubjectBean"%>
<%@page import="java.util.ArrayList"%>

<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null){
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="css/style.css">
<style>
		.card{
			 box-shadow: 3px 2px 17px #80808075;
		}
		a:hover {
			text-decoration: none;
		}
</style>

<title>EduHITec | Connecting Students and Educator</title>
</head>
<body>
<%@include file="educator_menu.html"%>
<br>
<br>
 	<div style="margin-right:4%;">
 		<a style="font-size:20px;color:#3aafc1db;float:right;" href="#" onclick="showAddVideoPlaylistModal();">
 		<i class="fa fa-plus" style="font-size:20px;color:#3aafc1db;"></i> ADD A NEW PLAYLIST</a>
 	</div>
 	
 	<br><br>
 	<h4 style="margin-left:2%;color:darksalmon">My Playlists <hr></h4><br>
 		<div style=" margin-right:2%;width:300px !important;
        float:right;">
 		<input class="form-control" id="search" type="text" placeholder="Search By Topic or Subject Name..."
 		 aria-label="Search" onkeyup="searchFilter()">
 	</div><br><br><br>
 	<div class="card-columns" style="margin:3%;">
 		
 	<%
 		ArrayList<VideoPlayListBean> playlistList = new VideoDao().getAllCurrentEducatorPlaylist
 		((Integer)session.getAttribute("edu_id"));
 	if(playlistList.size() == 0){
 	%>
 		<h4>NO PLAYLIST AVAILABLE</h4>
 	<% 	
 	}else{
 		for(int i=0;i<playlistList.size();i++){	
 	%>
 		<div class="card border-light mb-3" style="border-radius: 10px;">
            <img class="card-img-top"  alt="Card image cap" src = "data:image/jpeg;base64,<%=playlistList.get(i).getThumbnail()%>" width="239px" height="200px">
            <div class="card-body">
              <h5 class="card-title" style="white-space:pre-wrap;"><%=playlistList.get(i).getTitle()%></h5>
              <h6 class="card-title" style="white-space:pre-wrap;"><%=playlistList.get(i).getSub_name()%> 
              <%
              	if(playlistList.get(i).getSubCode() != null && playlistList.get(i).getSubCode().equals("") == false){
              %>
<span><%=playlistList.get(i).getSubCode()%></span>
              <% 
              	}
              %>
              </h6>
              <p class="card-text" style="white-space:pre-wrap;"><%=playlistList.get(i).getDesp()%></p>
              <p class="card-text"><small class="text-muted">Added on <%=playlistList.get(i).getDate()%></small></p>
              <button type="button" class="btn edit btn-primary m-1" onclick="triggerEditVideoPlaylistModal(`<%=playlistList.get(i).getTitle()%>`,`<%=playlistList.get(i).getDesp()%>`,<%=playlistList.get(i).getUni_id()%>)">Edit</button>
              <button type="button" class="btn delete btn-primary m-1" onclick="triggerDeleteVideoPlaylistModal(<%=playlistList.get(i).getUni_id()%>);">Delete</button>
              <button type="button" class="btn delete btn-primary m-1" onclick="redirectToVideos('<%=new DataHiding().encodeMethod(String.valueOf(playlistList.get(i).getUni_id()))%>');">Open Playlist</button>
            </div>    
        </div>
 	<% 
 		}
 	}
 	%>	
 	</div>
 	
 	<%
 		if(session.getAttribute("noValidAdd") != null){
 			session.removeAttribute("noValidAdd");
 			VideoPlayListBean bean = (VideoPlayListBean)session.getAttribute("bean");
 			session.removeAttribute("bean");
 	%>
 <form class="was-validated" novalidate action="AddPlaylist" method="post" enctype="multipart/form-data">	
<div class="modal fade" id="addPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
     
    <%
    	ArrayList<SubjectBean> sublist = new AdminDao().getAllSubjects(new VideoDao().getInstId((Integer)session.getAttribute("edu_id")));	
    	if(sublist.size() == 0){
    %>
    	<h3>No Subjects Available Yet!! Please contact the admin to add subject</h3>
    <%
    	}else{
    
    %>

<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br>
  <div class="form-group">
    <label for="selectTopic">Select Subject <span style="color:red;">*</span></label>
    <select class="form-control" id="selectTopic" name="selectTopic" required>
    	<%
    		if(bean.getSub_id() != -1){
    	%>
    	<option value="" disabled>-- Select Subject ---</option>
    	<%
    		}else{
    	%>
    	<option value="" disabled selected>-- Select Subject ---</option>
    	<%
    		}
    	%>
    	
    <%
    	for(int i=0;i<sublist.size();i++){
    		if(bean.getSub_id() == sublist.get(i).getSub_id()){
    %>
    <option value=<%=sublist.get(i).getSub_id()%> selected><%=sublist.get(i).getSubjectName()%> 
    
    	<%
    		if(sublist.get(i).getCode() != null && sublist.get(i).getCode().equals("") == false){
    	%>
    		(<%=sublist.get(i).getCode()%>)
    	<%
    		}
    	%>
    	</option>
    <% 			
    		}else{
    %>
    	<option value=<%=sublist.get(i).getSub_id()%>><%=sublist.get(i).getSubjectName()%> 
    	<%
    		if(sublist.get(i).getCode() != null && sublist.get(i).getCode().equals("") == false){
    	%>
    		(<%=sublist.get(i).getCode()%>)
    	<%
    		}
    	%>
    	</option>
    	
    <%
    		}
    	}
    %>
    </select>
    <div class="invalid-feedback">
         Please Select a Subject.
    </div>
  </div>
  
  <div class="form-group">
    <label for="title">Enter Title of Playlist <span style="color:red;">*</span></label>
    <%
    	if(bean.getTitle().isEmpty() ==false){
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"><%=bean.getTitle()%></textarea>
    <%

    	}else{
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
    <%
    	}
    %>
    
    <div class="invalid-feedback">
         Please provide a title.
    </div>
  </div>
  
   <div class="form-group">
    <label for="desp">Enter Some description about this playlist <span style="color:red;">*</span></label>
    <%
    	if(bean.getDesp().isEmpty() == false){
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ><%=bean.getDesp()%></textarea>
    
    <%
    	}else{
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ></textarea>
    <%
    	}
    %>
    <div class="invalid-feedback">
         Please provide a description.
    </div>
  </div>
  
  <div class="form-group">
    <label for="thumbnail">Select Video Thumbnail Photo <span style="color:red;">*</span></label>
    <input type="file" class="form-control-file" id="thumbnail" name="thumbnail" required onchange="return fileValidationForImageFiles(this);">
    <div class="invalid-feedback">
         Please select a thumbnail file with extension only as jpg, jpeg or png.
    </div>
  </div>

<%
    	}
%>
  </div>
      <div class="modal-footer">
      <%
      	if(sublist.size() > 0){
      %>
      <button class="btn btn-primary" type="submit">AddPlaylist</button>
      <%
      	}
      %>
         <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>

 	<%
 		
 	%>
 	<script>
		$(document).ready(function(){
			    $("#addPlaylistModal").modal("show");   
		});
	</script>
		
 	<%
 		}else{
 	%>
 	
 	
 <form class="needs-validation" novalidate action="AddPlaylist" method="post" enctype="multipart/form-data">	
<div class="modal fade" id="addPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
     
    <%
    	ArrayList<SubjectBean> sublist = new AdminDao().getAllSubjects(new VideoDao().getInstId((Integer)session.getAttribute("edu_id")));	
    	if(sublist.size() == 0){
    %>
    	<h3>No Subjects Available Yet!! Please contact the admin to add subject</h3>
    <%
    	}else{
    
    %>

<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br>
  <div class="form-group">
    <label for="selectTopic">Select Subject <span style="color:red;">*</span></label>
    <select class="form-control" id="selectTopic" name="selectTopic" required>
    	<option value="" disabled selected>-- Select Subject ---</option>
    <%
    	for(int i=0;i<sublist.size();i++){
    %>
    	<option value=<%=sublist.get(i).getSub_id()%>><%=sublist.get(i).getSubjectName()%> 
    	<%
    		if(sublist.get(i).getCode() != null && sublist.get(i).getCode().equals("") == false){
    	%>
    		(<%=sublist.get(i).getCode()%>)
    	<%
    		}
    	%>
    	</option>
    <% 			
    		
    	}
    %>
    </select>
    <div class="invalid-feedback">
         Please Select a Subject.
    </div>
  </div>
  
  <div class="form-group">
    <label for="title">Enter Title of Playlist <span style="color:red;">*</span></label>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
    <div class="invalid-feedback">
         Please provide a title.
    </div>
  </div>
  
   <div class="form-group">
    <label for="desp">Enter Some description about this playlist <span style="color:red;">*</span></label>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200"></textarea>
    <div class="invalid-feedback">
         Please provide a description.
    </div>
  </div>
  
  <div class="form-group">
    <label for="thumbnail">Select Video Thumbnail Photo <span style="color:red;">*</span></label>
    <input type="file" class="form-control-file" id="thumbnail" name="thumbnail" required onchange="return fileValidationForImageFiles(this);">
    <div class="invalid-feedback">
         Please select a thumbnail file with extension only as jpg, jpeg or png.
    </div>
  </div>

<%
    	}
%>
  </div>
      <div class="modal-footer">
      <%
      	if(sublist.size() > 0){
      %>
      <button class="btn btn-primary" type="submit">AddPlaylist</button>
      <%
      	}
      %>
         <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
 <%
 		}
 	%>

<div class="modal fade" id="addplaylist_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Playlist added Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
       <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="editplaylist_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Playlist edited Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="deleteplaylist_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Playlist removed Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="playlist_error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong at server side !! if problem persist then try to contact the owner
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<%
	if(session.getAttribute("success")!=null){
		
		if(session.getAttribute("success").equals("1")){
%>
<script>
		$(document).ready(function(){
			    $("#addplaylist_success").modal("show");   
		});
</script>		

<%
		}else if(session.getAttribute("success").equals("2")){
%>
	<script>
		$(document).ready(function(){
			    $("#editplaylist_success").modal("show");   
		});
	</script>	
<% 
		}else{
%>
	<script>
		$(document).ready(function(){
			    $("#deleteplaylist_success").modal("show");   
		});
	</script>	
<% 	
		}
		session.removeAttribute("success");
	}else if(session.getAttribute("error")!=null){
%>
<script>
	$(document).ready(function(){
		$("#playlist_error").modal("show");
		    
	});
</script>

<%
		session.removeAttribute("error");
	}
%>

<%
	if(session.getAttribute("noValidEdit") != null){
		session.removeAttribute("noValidEdit");
		VideoPlayListBean bean = (VideoPlayListBean)session.getAttribute("bean");
		session.removeAttribute("bean");
%>
<div class="modal fade" id="editVideoPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
<form action="EditPlaylist" class="was-validated" novalidate method="post" enctype="multipart/form-data">  
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br><br>

  <div class="form-group">
    <label for="title">Title/Topic <span style="color:red;">*</span></label>
    
    <%
    	if(bean.getTitle().isEmpty() ==false){
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"><%=bean.getTitle()%></textarea>
    <%

    	}else{
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
    <%
    	}
    %>
    
    <div class="invalid-feedback">
         Please provide a title.
    </div>
  </div>
  
   <div class="form-group">
    <label for="desp">Description about this playlist <span style="color:red;">*</span></label>
    <%
    	if(bean.getDesp().isEmpty() == false){
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ><%=bean.getDesp()%></textarea>
    
    <%
    	}else{
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ></textarea>
    <%
    	}
    %>
    
    <div class="invalid-feedback">
         Please provide a description.
    </div>
  </div>
  
  <div class="form-group">
   <label for="thumbnailConfirm">Do you want to change thumbnail photo</label>
    <select class="form-control" id="thumbnailConfirm" onchange="check(this);" name="thumbnailConfirm">
      <option value="0">No</option>
      <option value="1">Yes</option>
    </select>
  </div>
  
  <div class="form-group" id="thumbnailDiv" style="display:none;">
    <label for="editThumbnail">Select New Thumbnail Photo <span style="color:red;">*</span></label>
    <input type="file" class="form-control-file" id="editThumbnail" name="thumbnail" onchange="return fileValidationForImageFiles(this);">
   	<div class="invalid-feedback">
         Please select a thumbnail file with extension only as jpg, jpeg or png.
    </div>
  </div>
  
  <input type="hidden" name="Euid" id="Euid" value="<%=bean.getUni_id()%>">
 
  </div>
      <div class="modal-footer">
      <button class="btn btn-primary" type="submit">Save Changes</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</form>
</div>

<%

%>
<script>
		$(document).ready(function(){
			    $("#editVideoPlaylistModal").modal("show");   
		});
</script>
<%
	}else{
%>
<div class="modal fade" id="editVideoPlaylistModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
<form action="EditPlaylist" class="needs-validation" novalidate method="post" enctype="multipart/form-data">  
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br><br>

  <div class="form-group">
    <label for="title">Title/Topic <span style="color:red;">*</span></label>
    <textarea class="form-control" id="title" name="title" rows="2" required  maxlength="200"></textarea>
    <div class="invalid-feedback">
         Please provide a title.
    </div>
  </div>
  
   <div class="form-group">
    <label for="desp">Description about this playlist <span style="color:red;">*</span></label>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200"></textarea>
    <div class="invalid-feedback">
         Please provide a description.
    </div>
  </div>
  
  <div class="form-group">
   <label for="thumbnailConfirm">Do you want to change thumbnail photo</label>
    <select class="form-control" id="thumbnailConfirm" onchange="check(this);" name="thumbnailConfirm">
      <option value="0">No</option>
      <option value="1">Yes</option>
    </select>
  </div>
  
  <div class="form-group" id="thumbnailDiv" style="display:none;">
    <label for="editThumbnail">Select New Thumbnail Photo <span style="color:red;">*</span></label>
    <input type="file" class="form-control-file" id="editThumbnail" name="thumbnail" onchange="return fileValidationForImageFiles(this);">
   	<div class="invalid-feedback">
         Please select a thumbnail file with extension only as jpg, jpeg or png.
    </div>
  </div>
  
  <input type="hidden" name="Euid" id="Euid" value="">
 
  </div>
      <div class="modal-footer">
      <button class="btn btn-primary" type="submit">Save Changes</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</form>
</div>
<%
	}
%>

<form action="DeletePlaylist" method="post">
<div class="modal fade" id="deleteVideoPlaylistModal" tabindex="-1" role="dialog" 
aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to delete this Playlist ?
        		<input type="hidden" name="Duid" id="Duid" value="">
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        <button class="btn btn-primary" type="submit">Yes</button>
      </div>
    </div>
  </div>
  
</div>
</form>

</body>
<script type="text/javascript">

function check(ele){
	if(ele.value == "1"){
		document.getElementById("thumbnailDiv").style.display="";
		document.getElementById("editThumbnail").setAttribute("required","true");
	}else{
		document.getElementById("thumbnailDiv").style.display="none";
		document.getElementById("editThumbnail").removeAttribute("required");
		document.getElementById("editThumbnail").value="";
	}
}

function redirectToVideos(id){
	window.location.replace("educatorVideoSection.jsp?uni_id="+id);
}

 

function searchFilter(){
	let card = document.getElementsByClassName("card");
	let input = document.getElementById("search").value.toUpperCase();
	let textValue1,a,b,textValue2;
	
	for(let i=0;i<card.length;i++){
		a = card[i].getElementsByTagName("h5")[0];
		b = card[i].getElementsByTagName("h6")[0];
		
		txtValue1 = a.textContent || a.innerText;
		txtValue2 = b.textContent || b.innerText;
		
		if(txtValue1.toUpperCase().indexOf(input) > -1 || txtValue2.toUpperCase().indexOf(input) > -1) {
            card[i].style.display = "";
        } else{
            card[i].style.display = "none";
        }
	}
}

</script>
<script type="text/javascript" src="javascript/script.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>