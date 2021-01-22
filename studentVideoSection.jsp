<%@page import="hide.DataHiding"%>
<%@page import="videos.VideoDao"%>
<%@page import="videos.PlaylistVideosBean"%>
<%@page import="videos.VideoPlayListBean"%>
<%@page import="java.util.ArrayList"%>

<%
	if(session.getAttribute("std_id")!=null && request.getParameter("uni_id") != null){
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
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
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
            background-color: #8080800f;
        }
        .card-body{
            float: right;
            height:auto;
            margin-left: 10px;
        }
    </style>
<link rel="stylesheet" href="css/style.css">
</head>
<body onload="getVideoPlaylistStatus();">	
<!-- Playlist is removed by educator So Redirect back to main section-->
<div class="modal fade" id="redirectVideoPlaylistRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	 This Video Playlist Has been Removed By The User Right Now !!! <br><br>
        	 !!So We Are Redirecting You Back To The Main Section !! Click Okay Button To Redirect 
        </div>
      </div>
      <div class="modal-footer">
        <a type="button" href="studentVideoPlaylist.jsp" class="btn btn-success">Okay</a>
      </div>
    </div>
  </div>
</div>

<!-- Video is removed by educator -->
<div class="modal fade" id="confirmedVideoRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	 This Video Has been Removed By The User Right Now !!! <br><br>
        	 !!Please refresh the Page to See The Updates !!  
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<%@include file="student_menu.html"%>

<br>
<a href = "studentVideoPlaylist.jsp" style="margin-left:2%;"><- Return back to playlist section</a>

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
            <h6>Subject : <%=bean.getSub_name()%></h6>
            </div>
            
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <p style="white-space:pre-wrap;">Description: <%=bean.getDesp()%></p>
            </div>
        </div>
        
       <%
       	ArrayList<PlaylistVideosBean> list = new VideoDao().getPlaylistVideos(id);
       
       	if(list.size() == 0){
       	%>
       		<br><br><h5>No Videos Available Yet !!</h5>
       	<%
       	}else{
       %>
        <div class="card mb-5" style="padding: 20px;">
        <%
        	for(int i=0;i<list.size();i++){
        %>
            <div class="row no-gutters">
                <div class="col-md-3">
                   <img class="card-img-top"  alt="Card image cap" src = "data:image/jpeg;base64,<%=bean.getThumbnail()%>" width="50px" height="150px">
                </div>
                    <div class="card-body">
                        <h5 class="card-title" style="white-space:pre-wrap;"><%=list.get(i).getTitle()%></h5>
                        <p class="card-text" style="white-space:pre-wrap;"><%=list.get(i).getDesp()%></p>
                        <button type="button" class="btn  delete btn-primary m-1" onclick="getVideoStatus('<%=new DataHiding().encodeMethod(""+list.get(i).getVid())%>','<%=list.get(i).getLink()%>')">Play Video</button>
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
   


<!-- Shows the video with background drop for a better user experience -->
<div class="modal fade" id="showvideo">
  <div class="modal-dialog modal-dialog-centered">
  <div class="modal-content">
    	<iframe src="" id="iframeShowVideo" width="100%" height="350" frameborder="0" allowfullscreen></iframe>
   </div>
  </div>
</div>

</body>
<script>
//sets the src attribute to null so that video stops
$('#showvideo').on('hide.bs.modal',function () {
	$('#showvideo iframe').attr('src',"");
})

//to check that playlist exist or not
function getVideoPlaylistStatus(){
	$.post("CheckVideoPlaylistAvailability",
		    {
		      uni_id : `<%=request.getParameter("uni_id")%>`
		    },
		    function(data,status){
		    	if(data == "remove" && status == 'success'){
		    		
		    		$("#redirectVideoPlaylistRemove").modal("show");
				}else{
		    		getVideoPlaylistStatus();
				}
		    });
}


//to check that video exist or not
function getVideoStatus(id,link){
	$.post("CheckVideoAvailability",
		    {
		      vid : id
		    },
		    function(data,status){
		    	if(data == 'notremove' && status == 'success'){
		    		$("#iframeShowVideo").attr("src",link+"?rel=0&amp;showinfo=0");  
		    		 $("#showvideo").modal("show");
				}else if(data == "remove" && status == 'success'){
		    			$("#confirmedVideoRemove").modal("show");
				}
		    });
}
</script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>