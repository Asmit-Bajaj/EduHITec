<%@page import="hide.DataHiding"%>
<%@page import="videos.VideoDao"%>
<%@page import="videos.PlaylistVideosBean"%>
<%@page import="videos.VideoPlayListBean"%>
<%@page import="java.util.ArrayList"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("uni_id") != null){
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Connecting Students and Educator</title>
	<style>
        .card {
            max-width: cover;
            margin-left:30px; 
            margin-right: 20px;
            margin-top: 15px;
    		box-shadow: -5px -5px 13px slategrey;
        }
        body{
            /*background-color:aliceblue*/;
            background-color: #8080800f;
        }
        .card-body{
            float: right;
            height:auto;
            margin-left: 10px;
        }
    </style>
</head>
<body>	

<%@include file="educator_menu.html"%>
<!-- Modal for successful addition of video -->
<br>
<a href = "uploadVideos.jsp" style="margin-left:2%;"><- Return back to playlist section</a>
<div class="modal fade" id="addvideo_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Video added Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- if video is deleted successfully -->
<div class="modal fade" id="deletevideo_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Video Removed Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- if video is edited successfully -->
<div class="modal fade" id="editvideo_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Video edited Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- In case if any error occurs -->
<div class="modal fade" id="addvideo_error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong try again!!!
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
			    $("#addvideo_success").modal("show");   
		});
</script>		

<%
		}else if(session.getAttribute("success").equals("2")){
%>
	<script>
		$(document).ready(function(){
			    $("#editvideo_success").modal("show");   
		});
	</script>	
<% 
		}else{
%>
	<script>
		$(document).ready(function(){
			    $("#deletevideo_success").modal("show");   
		});
	</script>	
<% 	
		}
		session.removeAttribute("success");
		
	}else if(session.getAttribute("error")!=null){
%>
<script>
	$(document).ready(function(){
		$("#addvideo_error").modal("show");
		    
	});
</script>

<%
	session.removeAttribute("error");
	}
%>
<%	
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("uni_id")));
	VideoPlayListBean bean = new VideoDao().getPlaylist(id);
%>
<!-- displays the list of videos available at present in selected video playlist -->
	<div class="container-fluid">
        <div class="header" style="margin-top: 50px;border-radius: 10px;
    box-shadow: -3px -3px 5px darkgrey;margin-bottom: 94px;padding: 36px;background-color:white;">
            <div class="header-1 text-center">
                <h2 style="white-space:pre-wrap;"><b><i>Topic : <%=bean.getTitle()%></i></b></h2>
            </div>
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <h6 style="white-space:pre-wrap;">Subject : <%=bean.getSub_name()%></h6>
            </div>
            
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <p style="white-space:pre-wrap;">Description: <%=bean.getDesp()%></p>
            </div>
            
            <button class="btn btn-primary btn-lg " style="margin:20px" data-toggle="modal" data-target="#addVideo_modal"> ADD Video +  </button>
        </div>
        
       <%
       	ArrayList<PlaylistVideosBean> list = new VideoDao().getPlaylistVideos(id);
       
       	if(list.size() == 0){
       	%>
       		<br><br><h5>No Videos Available Yet Add Some Videos!!</h5>
       	<%
       	}else{
       %>
        <div class="card mb-5" style="padding: 20px;">
        <%
        	for(int i=0;i<list.size();i++){
        %>
            <div class="row no-gutters">
                <div class="col-md-3">
                    <!-- <iframe src="<%=list.get(i).getLink()+"?autoplay=0&showinfo=0&controls=0"%>" allowfullscreen></iframe>-->
                   <img class="card-img-top"  alt="Card image cap" src = "data:image/jpeg;base64,<%=bean.getThumbnail()%>" width="50px" height="150px">
                </div>
                    <div class="card-body">
                        <h5 class="card-title" style="white-space:pre-wrap;"><%=list.get(i).getTitle()%></h5>
                        <p class="card-text" style="white-space:pre-wrap;"><%=list.get(i).getDesp()%></p>
                            <button type="button" class="btn  edit btn-primary m-1" onclick="editVideoModal(`<%=list.get(i).getTitle()%>`,`<%=list.get(i).getDesp()%>`,`<%=list.get(i).getLink()%>`,<%=list.get(i).getVid()%>)">Edit</button>
                            <button type="button" class="btn  delete btn-primary m-1" onclick="deleteVideoConfirm(<%=list.get(i).getVid()%>);">Delete</button>
                    		<button type="button" class="btn  delete btn-primary m-1" onclick="showVideofunc('<%=list.get(i).getLink()%>')">Play Video</button>
                    </div>
            </div>
            <hr>
            <%
        	}
            %>
        </div>
       </div>
        <%
       	}
        %>
  
  <%
  	if(session.getAttribute("novalidLink") != null){
  		session.removeAttribute("novalidLink");
  %>
  	<script>
  		alert("Link is not Valid");
  	</script>
  <%
  	}
  %>
  <%
 		if(session.getAttribute("noValidAdd") != null){
 			session.removeAttribute("noValidAdd");
 			PlaylistVideosBean bean_ = (PlaylistVideosBean)session.getAttribute("bean");
 			session.removeAttribute("bean");
 			
 		
 	%>
<!-- handles the add video operation -->
<form class="was-validated" action="AddVideo" method="post" id="addvideo_form" novalidate>
<div class="modal fade" id="addVideo_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
        	
        		<div class="form-group">
    			<label for="title">Enter Title Of Video <span style="color:red;">*</span></label>
    			
    <%
    	if(bean.getTitle().isEmpty() ==false){
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"><%=bean_.getTitle()%></textarea>
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
    			<label for="desp">Enter some description about video <span style="color:red;">*</span></label>
    			<%
    	if(bean.getDesp().isEmpty() == false){
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ><%=bean_.getDesp()%></textarea>
    
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
    			<label for="link">Provide the embedded link of video <span style="color:red;">*</span></label>
    			<input type="url" class="form-control"  id="link" name="link" required value="<%=bean_.getLink()%>">
    			
    			<div class="invalid-feedback">
         		Please provide a valid Link.
    			</div>
    			
  				</div>
  				
  				<br>
  				<div>
  					<span>In case if don't know how to get embedded link of video</span><br>
  					<span>Please watch the following tutorial videos : </span><br>
  					<span>For Youtube videos : <a href="https://www.youtube.com/watch?v=kiyi-C7NQrQ" target="_blank">Click Here</a></span><br>
  					<span>For GoogleDrive videos : <a href="#">Click Here</a></span><br>
  					<span>Once you get the embed link just copy the link without quotes from 'src' tag and paste it into the above textbox check the below picture for clarity:</span>
  				</div>
  				<br>
  				<img src="images/embed.jpg" alt="embed" width="100%" height="150px">
  				<input type="hidden" name="uni_id" value=<%=id%>>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="submit">Add Video</button>
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
			    $("#addVideo_modal").modal("show");   
		});
	</script>
<%
 		}else{
%>
<form class="needs-validation" action="AddVideo" method="post" id="addvideo_form" novalidate>
<div class="modal fade" id="addVideo_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
        	
        		<div class="form-group">
    			<label for="title">Enter Title Of Video <span style="color:red;">*</span></label>
    			
    
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
    
    			<div class="invalid-feedback">
         Please provide a title.
    </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="desp">Enter some description about video <span style="color:red;">*</span></label>
    			
    
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ></textarea>
    
    <div class="invalid-feedback">
         Please provide a description.
    </div>
    			
  				</div>
  				
  				<div class="form-group">
    			<label for="link">Provide the embedded link of video <span style="color:red;">*</span></label>
    			<input type="url" class="form-control"  id="link" name="link" required>
    			<div class="invalid-feedback">
         		Please provide a valid Link.
    			</div>
  				</div>
  				
  				<br>
  				<div>
  					<span>In case if don't know how to get embedded link of video</span><br>
  					<span>Please watch the following tutorial videos : </span><br>
  					<span>For Youtube videos : <a href="https://www.youtube.com/watch?v=kiyi-C7NQrQ" target="_blank">Click Here</a></span><br>
  					<span>For GoogleDrive videos : <a href="#">Click Here</a></span><br>
  					<span>Once you get the embed link just copy the link without quotes from 'src' tag and paste it into the above textbox check the below picture for clarity:</span>
  				</div>
  				<br>
  				<img src="images/embed.jpg" alt="embed" width="100%" height="150px">
  				<input type="hidden" name="uni_id" value=<%=id%>>
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="submit">Add Video</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
<%
 		}
%>

<!-- Shows the video with background drop for a better user experience -->
<div class="modal fade" id="showvideo">
  <div class="modal-dialog modal-dialog-centered">
  <div class="modal-content">
    	<iframe src="" id="iframeShowVideo" width="100%" height="350" frameborder="0" allowfullscreen></iframe>
   	
   </div>
  </div>
</div>


<!-- Modal for delete video -->
<form action="DeleteVideo" method="post" id="deleteVideoForm">
<div class="modal fade" id="confirmDeleteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to delete this video ?
        		<input type="hidden" name="Dvid" id="Dvid" value="">
        		<input type="hidden" name="uni_id" value="<%=id%>">
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

<%
 		if(session.getAttribute("noValidEdit") != null){
 			session.removeAttribute("noValidEdit");
 			PlaylistVideosBean bean_ = (PlaylistVideosBean)session.getAttribute("bean");
 			session.removeAttribute("bean");

%>
<!-- Modal for edit video -->

<form action="EditVideo" method="post" id="editVideoForm" class="was-validated" novalidate>
<div class="modal fade" id="editVideoModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <div><b>Edit The below form and click on save changes to save them</b></div>
        	
        		<div class="form-group">
    			<label for="title">Title Of video</label>
    			<%
    	if(bean.getTitle().isEmpty() ==false){
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"><%=bean_.getTitle()%></textarea>
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
    			<label for="desp">Description of video</label>
    			<%
    	if(bean.getTitle().isEmpty() ==false){
    %>
    <textarea class="form-control" id="desp" name="desp" rows="2" required maxlength="200"><%=bean_.getTitle()%></textarea>
    <%

    	}else{
    %>
    <textarea class="form-control" id="desp" name="desp" rows="2" required maxlength="200"></textarea>
    <%
    	}
    %>
    			<div class="invalid-feedback">
         		Please provide a description.
    			</div>
  				</div>
  				
  				<div class="form-group">
    			<label for="link">Embedded link of video</label>
    			<input type="url" class="form-control"  id="link" name="link" value="<%=bean_.getLink()%>"required>
    			<div class="invalid-feedback">
         		Please provide a valid Link.
    			</div>
  				</div>
  				
  				<div>
  					<span>Note* :- Don't know how to get embedded link of video??</span><br>
  					<span>Please watch the following tutorial videos : </span><br>
  					<span>For Youtube videos : <a href="https://www.youtube.com/watch?v=kiyi-C7NQrQ" target="_blank">Click Here</a></span><br>
  					<span>For GoogleDrive videos : <a href="#">Click Here</a></span><br>
  					<span>Once you get the embed link just copy the link without quotes from 'src' tag and paste it into the above textbox check the below picture for clarity:</span>
  				</div>
  				<br>
  				<img src="images/embed.jpg" alt="embed" width="100%" height="150px">
  				<input type="hidden" name="Evid" id="Evid" value="<%=bean_.getVid()%>">
  				<input type="hidden" name="uni_id" value=<%=bean.getUni_id()%>>
        	
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="submit">Save Changes</button>
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
			    $("#editVideoModal").modal("show");   
		});
</script>
<%
 		}else{
%>
<form action="EditVideo" method="post" id="editVideoForm" class="needs-validation" novalidate>
<div class="modal fade" id="editVideoModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <div><b>Edit The below form and click on save changes to save them</b></div>
        	
        		<div class="form-group">
    			<label for="title">Title Of video <span style="color:red;">*</span></label>
    			<textarea class="form-control" id="title" name="title" rows="2" value="" required></textarea>
    			<div class="invalid-feedback">
         		Please provide a title.
    			</div>
  				</div>
  				
  				<div class="form-group">
    			<label for="desp">Description of video <span style="color:red;">*</span></label>
    			<textarea class="form-control" id="desp" name="desp" rows="3" value="" required></textarea>
    				<div class="invalid-feedback">
         			Please provide a description.
    				</div>
  				</div>
  				
  				<div class="form-group">
    			<label for="link">Embedded link of video <span style="color:red;">*</span></label>
    			<input type="url" class="form-control"  id="link" name="link" required>
    			<div class="invalid-feedback">
         		Please provide a valid Link.
    			</div>
  				</div>
  				
  				<div>
  					<span>Note* :- Don't know how to get embedded link of video??</span><br>
  					<span>Please watch the following tutorial videos : </span><br>
  					<span>For Youtube videos : <a href="https://www.youtube.com/watch?v=kiyi-C7NQrQ" target="_blank">Click Here</a></span><br>
  					<span>For GoogleDrive videos : <a href="#">Click Here</a></span><br>
  					<span>Once you get the embed link just copy the link without quotes from 'src' tag and paste it into the above textbox check the below picture for clarity:</span>
  				</div>
  				<br>
  				<img src="images/embed.jpg" alt="embed" width="100%" height="150px">
  				<input type="hidden" name="Evid" id="Evid" value="">
  				<input type="hidden" name="uni_id" value=<%=id%>>
        	
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="submit">Save Changes</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
<%
 		}
%>

</body>
<script src="javascript/script.js"></script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>