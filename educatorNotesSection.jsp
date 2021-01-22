<%@page import="hide.DataHiding"%>
<%@page import="notes.SubjectNotesBean"%>
<%@page import="notes.NotesDao"%>
<%@page import="notes.NotesSubjectBean"%>
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
	if(session.getAttribute("edu_id")!=null && request.getParameter("npid") != null){
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
<!-- Modal for successful addition of Notes -->
<br>
<a href = "uploadNotes.jsp" style="margin-left:2%;"><- Return back to Notes list section</a>
<div class="modal fade" id="addnote_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Note added Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
       <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- if Note is deleted successfully -->
<div class="modal fade" id="deletenote_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Note Removed Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>


<!-- In case if any error occurs -->
<div class="modal fade" id="note_error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong try again!!! if problem persist then try to contact the owner
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
			    $("#addnote_success").modal("show");   
		});
</script>		

<% 
		}else{
%>
	<script>
		$(document).ready(function(){
			    $("#deletenote_success").modal("show");   
		});
	</script>	
<% 	
		}
		session.removeAttribute("success");
		
	}else if(session.getAttribute("error")!=null){
%>
<script>
	$(document).ready(function(){
		$("#note_error").modal("show");
		    
	});
</script>

<%
		session.removeAttribute("error");
	}
%>
<%
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("npid")));
	NotesSubjectBean bean = new NotesDao().getNoteslist(id);
%>
<!-- displays the list of Notes available at present in selected Notes playlist -->
	<div class="container-fluid">
        <div class="header" style="margin-top: 50px;border-radius: 10px;
    box-shadow: -3px -3px 5px darkgrey;margin-bottom: 94px;padding: 36px;background-color:white;">
            <div class="header-1 text-center">
                <h2 style="white-space:pre-wrap;"><b><i>Topic : <%=bean.getTitle()%></i></b></h2>
            </div>
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <h6 style="white-space:pre-wrap;">Subject : <%=bean.getSub_name()%></h6>
            </div>
            
            <%
            	if(bean.getCode() != null && bean.getCode().equals("") == false){
            %>
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <h6 style="white-space:pre-wrap;">Subject Code : <%=bean.getCode()%></h6>
            </div>
            <%
            	}
            %>
            
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <p style="white-space:pre-wrap;">Description: <%=bean.getDesp()%></p>
            </div>
            
            <button class="btn btn-primary btn-lg " style="margin:20px" data-toggle="modal" data-target="#addNote_modal"> ADD NOTE +  </button>
        </div>
        
       <%
       	ArrayList<SubjectNotesBean> list = new NotesDao().getNoteslistNotes(id);
       
       	if(list.size() == 0){
       	%>
       		<br><br><h5>No Notes Available Yet Add Some Notes!!</h5><br><br>
       	<%
       	}else{
       %>
        <div class="card mb-5 text-center" style="padding: 20px;">
        <%
        	for(int i=0;i<list.size();i++){
        %>
            <div class="row no-gutters">
                    <div class="card-body">
                      <h5 class="card-title" style="white-space:pre-wrap;"><%=list.get(i).getTitle()%></h5>
                      <button type="button" class="btn  delete btn-primary m-1 btn-sm" onclick="deleteNoteConfirm(<%=list.get(i).getNid()%>);">Delete</button>
   <a class="btn  delete btn-primary m-1 btn-sm" href="notes/EduHItec_notes_<%=list.get(i).getNid()%>.<%=list.get(i).getExt()%>" target="_blank">Open Note</a>
                      
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
 		if(session.getAttribute("noValidAdd") != null){
 			session.removeAttribute("noValidAdd");
 			SubjectNotesBean bean_ = (SubjectNotesBean)session.getAttribute("bean");
 			session.removeAttribute("bean");

%>
<form action="AddNote" method="post" onsubmit="showSpinner(this);" id="addNote_form" enctype="multipart/form-data" class="was-validated" novalidate>
<!-- handles the add Note operation -->
<div class="modal fade" id="addNote_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
        	
        		<div class="form-group">
    			<label for="title">Enter Title Of Note <span style="color:red;">*</span></label>
    			<%
    				if(bean.getTitle() != null && bean.getTitle().length() != 0){
    			%>
    			<textarea class="form-control" id="title" name="title" rows="2" required>
    				<%=bean.getTitle()%>
    			</textarea>
    			<%
    				}else{
    			%>
    			<textarea class="form-control" id="title" name="title" rows="2" required></textarea>
    			<%
    				}
    			%>
    			<div class="invalid-feedback">
         			Please provide a title.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="file">Choose File <span style="color:red;">*</span></label>
    			<input class="form-control-file" type="file" id="file" name="file" required>
    			<div class="invalid-feedback">
         			Please select a file.
   				 </div>
  				</div>
  				<br>
  			<input type="hidden" name="npid" value=<%=bean.getNpid()%>>
        	
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="submit">Add Note</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
<script>
		$(document).ready(function(){
			    $("#addNote_modal").modal("show");   
		});
	</script>
<%
 		}else{
%>
<form action="AddNote" method="post" onsubmit="showSpinner(this);" class="needs-validation" novalidate id="addNote_form" enctype="multipart/form-data">
<div class="modal fade" id="addNote_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
        	
        		<div class="form-group">
    			<label for="title">Enter Title Of Note <span style="color:red;">*</span></label>
    			<textarea class="form-control" id="title" name="title" rows="2" required ></textarea>
    			<div class="invalid-feedback">
         			Please provide a title.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="file">Choose File <span style="color:red;">*</span></label>
    			<input class="form-control-file" type="file" id="file" name="file" 
    			required>
    			<div class="invalid-feedback">
         			Please select a file.
   				 </div>
  				</div>
  				<br>
  			<input type="hidden" name="npid" value=<%=id%>>
        	
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary">Add Note</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
<%
 		}
%>


<!-- Modal for delete Note -->
<form action="DeleteNote" method="post" id="deleteNoteForm">
<div class="modal fade" id="confirmDeleteNoteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to delete this note ?
        	
        		<input type="hidden" name="Dnid" id="Dnid" value="">
        		<input type="hidden" name="Dnpid" value=<%=bean.getNpid()%>>
        	
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

<div class="modal fade" id="spinnerMove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
 aria-hidden="true" data-keyboard="false" data-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-body">
              <div>
                <div class="progress">
                   
                    <div class="progress-bar progress-bar-striped bg-primary progress-bar-animated" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                  </div><br>
                  <div align="center">
                  Uploading File .... <br>
                  Please be Patient It will Take Some Time To Upload Depending On The Size Of File<br>
                  Please Do Not Refresh The Page or Stop Loading 
                </div>
            </div>
            
          </div>
        </div>
      </div>
</div>


</body>
<script>
	function showSpinner(ele){
		if(ele.checkValidity())
			$("#spinnerMove").modal("show");
	}
</script>
<script src="javascript/script.js"></script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>