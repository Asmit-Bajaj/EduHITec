<%@page import="hide.DataHiding"%>
<%@page import="assignment.MainListAssignmentsBean"%>
<%@page import="assignment.AssignmentDao"%>
<%@page import="assignment.AssignmentMainListBean"%>
<%@page import="notes.SubjectNotesBean"%>
<%@page import="java.util.ArrayList"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("amid") != null){
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
</head>
<body>	

<%@include file="educator_menu.html"%>
<!-- Modal for successful addition of Assignment -->
<br>
<a href = "uploadAssignment.jsp" style="margin-left:2%"><- Return back to Assignment list section</a>
<div class="modal fade" id="addassignment_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div style="white-space:pre-wrap;">
		Assignment added Successfully !!! 
		This is the Secret code : <%=request.getParameter("cd")%>
    **** Share the above secret code with your students so that they can access this assignment ****<br>
    	Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- if Assignment is deleted successfully -->
<div class="modal fade" id="deleteassignment_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Assignment Removed Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- if Assignment is edited successfully -->
<div class="modal fade" id="editassignment_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Assignment edited Successfully !!! 
        	Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
       <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- In case if any error occurs -->
<div class="modal fade" id="assignment_error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
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
			    $("#addassignment_success").modal("show");   
		});
</script>		

<%
		}else if(session.getAttribute("success").equals("2")){
%>
	<script>
		$(document).ready(function(){
			    $("#editassignment_success").modal("show");   
		});
	</script>	
<% 
		}else{
%>
	<script>
		$(document).ready(function(){
			    $("#deleteassignment_success").modal("show");   
		});
	</script>	
<% 	
		}
		
		session.removeAttribute("success");
	}else if(session.getAttribute("error")!=null){
		session.removeAttribute("error");
%>
<script>
	$(document).ready(function(){
		$("#assignment_error").modal("show");
		    
	});
</script>

<%
	}
%>
<%
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("amid")));
	AssignmentMainListBean bean = new AssignmentDao().getAssignmentlist(id);
%>

	<div class="container-fluid">
        <div class="header" style="margin-top: 50px;border-radius: 10px;
    box-shadow: -3px -3px 5px darkgrey;margin-bottom: 94px;padding: 36px;background-color:white;">
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <h2 style="white-space:pre-wrap;">Subject : <%=bean.getSubjectName()%></h2>
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
            
            <button class="btn btn-primary " style="margin:20px" data-toggle="modal" data-target="#addAssignment_modal"> ADD ASSIGNMENT +  </button>
        </div>
     </div>   
       <%
       	ArrayList<MainListAssignmentsBean> list = new AssignmentDao().getMainListAssignments(id);
       
       	if(list.size() == 0){
       	%>
       		<br><br><h5>No Assignment Available Yet Add Some Assignment!!</h5><br><br>
       	<%
       	}else{
       %>
        <!--  <div class="card-columns text-center" style="margin:3%;">-->
        <%
        	for(int i=0;i<list.size();i++){
        %>
            <div class="card w-75 mx-auto mb-5" style="box-shadow: 4px 2px 9px grey">
  			
                    <div class="card-body">
                    <h3 class="card-title" style="white-space:pre-wrap;float:left;"><%=list.get(i).getTitle()%></h3><br><br>
                    <h6 class="card-subtitle mb-2 text-muted" style="float:left;">Secret Code : <%=list.get(i).getCode()%></h6><br>
                    <h6 class="card-subtitle mb-2 text-muted" style="float:left;">Deadline : <%=list.get(i).getDeadline()%></h6><br><br>
                    <h6 class="card-subtitle mb-2 text-muted " style="float:right">Maximum Marks : <%=list.get(i).getMarks()%></h6><br>
                    <hr style="background-color:black;"><br>
                      <p class="card-text text-center" style="white-space:pre-wrap;"><u>Instructions:</u><br> <%=list.get(i).getInstructions()%></p><br>
                      <hr><br>
                      
                      <div class="text-center">
                      <h5>Assignment Files</h5>
                      <%
                      	String[] orgname = list.get(i).getOrgNames();
                      	String[] extensions = list.get(i).getExtensions();
                      	for(int j=0;j<list.get(i).getNo_of_files();j++){
                      	%>
                      	<a href="assignment/EduHItec_assignment_<%=list.get(i).getAsgid()%><%=j+1%>.<%=extensions[j]%>" target="_blank" style="text-decoration: none;"><%=orgname[j]%></a><br>
                      	<% 
                      	}
                      %>
                      </div>
                      <br><hr><br>
                      <div class="text-center">
                      <button type="button" class="btn  btn-primary m-1 btn-sm" onclick="editAssignmentModal(`<%=list.get(i).getTitle()%>`,`<%=list.get(i).getInstructions()%>`,`<%=list.get(i).getDeadline()%>`,<%=list.get(i).getAsgid()%>,<%=list.get(i).getMarks()%>)">Edit</button>
                      <button type="button" class="btn  btn-primary m-1 btn-sm text-center" onclick="deleteAssignmentConfirm(<%=list.get(i).getAsgid()%>);">Delete</button>
                      <button type="button" class="btn  btn-primary m-1 btn-sm text-center" 
                      onclick="window.open(`assignmentSubmissions.jsp?asgid=<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getAsgid()))%>`,'_blank')">Show and Grade Submissions</button>
                      </div>
                     </div>
            </div>
            
            <%
        	}
            %>
       
       
        <%
       	}
        %>
 
<%
 		if(session.getAttribute("noValidAdd") != null){
 			session.removeAttribute("noValidAdd");
 			MainListAssignmentsBean bean_ = (MainListAssignmentsBean)session.getAttribute("bean");
 			session.removeAttribute("bean");

%>

<!-- handles the add Assignment operation -->
<form action="AddAssignment" method="post" id="addAssignment_form" 
enctype="multipart/form-data" novalidate class="was-validated" onsubmit="showSpinner(this);">
<div class="modal fade" id="addAssignment_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
        	
        		<div class="form-group">
    			<label for="title">Enter Title Of Assignment <span style="color:red;">*</span></label>
    			<%
    				if(bean_.getTitle() != null && bean_.getTitle().length() != 0){
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
    			<label for="inst">Enter Instructions <span style="color:red;">*</span></label>
    			<%
    				if(bean_.getInstructions() != null && bean_.getInstructions().length() != 0){
    			%>
    			<textarea class="form-control" id="inst" name="inst" rows="4" required maxlength="1000"><%=bean_.getInstructions()%></textarea>
    			<%
    				}else{
    			%>
    			<textarea class="form-control" id="inst" name="inst" rows="4" required maxlength="1000"></textarea>
    			<%
    				}
    			%>
    			
    			<div class="invalid-feedback">
         			Please Provide Some Instructions.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="deadline">Enter Deadline <span style="color:red;">*</span></label>
    			<input class="form-control" type="datetime-local" id="deadline" name="deadline" required>
    			<div class="invalid-feedback">
         			Please Provide Deadline.
   				 </div>
  				</div>
        		
        		<div class="form-group">
    			<label for="marks">Enter Total Marks <span style="color:red;">*</span></label>
    			<%
    				if(bean_.getMarks() != -1){
    			%>
    			<input class="form-control" type="number" id="marks" name="marks" value="<%=bean_.getMarks()%>" required min="1" >
    				
    			
    			<%
    				}else{
    			%>
    			<input class="form-control" type="number" id="marks" name="marks" required min="1">
    			<%
    				}
    			%>
    			
    			<div class="invalid-feedback">
         			Please Provide Marks.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="file">Choose Files <span style="color:red;">*</span></label>
    			<input class="form-control-file" type="file" id="file" name="file" required multiple>
    			<div class="invalid-feedback">
         			Select Some Files For Assignment.
   				 </div>
  				</div>
  				<br>
  			<input type="hidden" name="amid" value=<%=id%>>
        	
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="submit">Add Assignment</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
<script>
		$(document).ready(function(){
			    $("#addAssignment_modal").modal("show");   
		});
	</script>
<%
 		}else{
%>
<form action="AddAssignment" method="post" id="addAssignment_form" 
enctype="multipart/form-data" novalidate class="needs-validation" onsubmit="showSpinner(this);">
<div class="modal fade" id="addAssignment_modal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
        	
        		<div class="form-group">
    			<label for="title">Enter Title Of Assignment <span style="color:red;">*</span></label>
    			<textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
    			<div class="invalid-feedback">
         			Please provide a title.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="inst">Enter Instructions <span style="color:red;">*</span></label>
    			<textarea class="form-control" id="inst" name="inst" rows="4" required maxlength="1000"></textarea>
    			<div class="invalid-feedback">
         			Please Provide Some Instructions.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="deadline">Enter Deadline <span style="color:red;">*</span></label>
    			<input class="form-control" type="datetime-local" id="deadline" name="deadline" required >
    			<div class="invalid-feedback">
         			Please Provide Deadline.
   				 </div>
  				</div>
        		
        		<div class="form-group">
    			<label for="marks">Enter Total Marks <span style="color:red;">*</span></label>
    			<input class="form-control" type="number" id="marks" name="marks" required min="1">
    			<div class="invalid-feedback">
         			Please Provide Marks.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="file">Choose Files <span style="color:red;">*</span></label>
    			<input class="form-control-file" type="file" id="file" name="file" required multiple>
    			<div class="invalid-feedback">
         			Select Some Files For Assignment.
   				 </div>
  				</div>
  				<br>
  			<input type="hidden" name="amid" value=<%=id%>>
        	
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-primary" type="submit">Add Assignment</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
<%
 		}
%>


<!-- Modal for delete Assignment -->
<form action="DeleteAssignment" method="post" id="deleteAssignmentForm">
<div class="modal fade" id="confirmAssignmentDeleteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to delete this Assignment ?
        	
        		<input type="hidden" name="Dasgid" id="Dasgid" value="">
        		<input type="hidden" name="Damid" value=<%=id%>>
        	
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        <button class="btn btn-primary" type="sumbit">Yes</button>
      </div>
    </div>
  </div>
</div>
</form>


<%
 		if(session.getAttribute("noValidEdit") != null){
 			session.removeAttribute("noValidEdit");
 			MainListAssignmentsBean bean_ = (MainListAssignmentsBean)session.getAttribute("bean");
 			session.removeAttribute("bean");

%>
<!-- Modal for edit Assignment -->
<form action="EditAssignment" method="post" id="editAssignmentForm" 
enctype="multipart/form-data" novalidate class="was-validated">
<div class="modal fade" id="editAssignmentModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <div><b>Edit The below form and click on save changes to save them</b></div><br>
        	
        		<div class="form-group">
    			<label for="title">Title Of Assignment <span style="color:red;">*</span></label>
    			<%
    				if(bean_.getTitle() != null && bean_.getTitle().length() != 0){
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
         			Please Provide a Title.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="inst">Enter Instructions <span style="color:red;">*</span></label>
    			<%
    				if(bean_.getInstructions() != null && bean_.getInstructions().length() != 0){
    			%>
    			<textarea class="form-control" id="inst" name="inst" rows="4" required maxlength="1000"><%=bean_.getInstructions()%></textarea>
    			<%
    				}else{
    			%>
    			<textarea class="form-control" id="inst" name="inst" rows="4" required maxlength="1000"></textarea>
    			<%
    				}
    			%>
    			<div class="invalid-feedback">
         			Please Provide Instructions.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="marks">Total Marks <span style="color:red;">*</span></label>
    			<%
    				if(bean_.getMarks() != -1){
    			%>
    			<input class="form-control" type="number" id="Emarks" name="marks" value="<%=bean_.getMarks()%>" required min="1" >
    				
    			
    			<%
    				}else{
    			%>
    			<input class="form-control" type="number" id="Emarks" name="marks" required min="1">
    			<%
    				}
    			%>
    			<div class="invalid-feedback">
         			Please Provide Marks.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    				<label for="changedeadline">Do You Want to Change Deadline?</label>
    					<select class="form-control" id="changedeadline" name = "changedeadline" onchange="changeDeadlineFunc(this)" required>
      						<option value="no">No</option>
      						<option value="yes">Yes</option>
    					</select>
  				</div>
  				
  				<div class="form-group" id="changedeadlinediv" style="display:none">
    			<label for="editdeadline">Enter New Deadline <span style="color:red;">*</span></label>
    			<input class="form-control" type="datetime-local" id="editdeadline" name="deadline">
    			<div class="invalid-feedback">
         			Please Provide The Deadline.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    				<label for="changefile">Do You Want to Change the Assignment Files?</label>
    					<select class="form-control" id="changefile" name="changefile" 
    					onchange="changeAssignmentFileFunc(this)" required>
      						<option value="no">No</option>
      						<option value="yes">Yes</option>
    					</select>
  				</div>
  				
  				<div class="form-group" id="editfilediv" style="display:none;">
    			<label for="editfile">Choose Files <span style="color:red;">*</span></label>
    			<input class="form-control-file" type="file" id="editfile" name="file" multiple>
    			<div class="invalid-feedback">
         			Select Some Files For Assignment.
   				 </div>
  				</div>
        		
  				<input type="hidden" name="Easgid" id="Easgid" value="<%=bean_.getAsgid()%>">
  				<input type="hidden" name="Eampid" value=<%=id%>>
        	
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

<script>
		$(document).ready(function(){
			    $("#editAssignmentModal").modal("show");   
		});
</script>
<%
 		}else{
%>

<!-- Modal for edit Assignment -->
<form action="EditAssignment" method="post" id="editAssignmentForm" 
enctype="multipart/form-data" novalidate class="needs-validation">
<div class="modal fade" id="editAssignmentModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <div><b>Edit The below form and click on save changes to save them</b></div><br>
        	
        		<div class="form-group">
    			<label for="title">Title Of Assignment <span style="color:red;">*</span></label>
    			<textarea class="form-control" id="title" name="title" rows="2" maxlength="200" value="" required></textarea>
    			<div class="invalid-feedback">
         			Please Provide a Title.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="inst">Enter Instructions <span style="color:red;">*</span></label>
    			<textarea class="form-control" id="inst" name="inst" rows="4" required maxlength="1000"></textarea>
    			<div class="invalid-feedback">
         			Please Provide Instructions.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    			<label for="marks">Total Marks <span style="color:red;">*</span></label>
    			<input class="form-control" type="number" id="Emarks" name="marks" required min="1">
    			<div class="invalid-feedback">
         			Please Provide Marks.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    				<label for="changedeadline">Do You Want to Change Deadline?</label>
    					<select class="form-control" id="changedeadline" name = "changedeadline" onchange="changeDeadlineFunc(this)" required>
      						<option value="no">No</option>
      						<option value="yes">Yes</option>
    					</select>
  				</div>
  				
  				<div class="form-group" id="changedeadlinediv" style="display:none">
    			<label for="editdeadline">Enter New Deadline <span style="color:red;">*</span></label>
    			<input class="form-control" type="datetime-local" id="editdeadline" name="deadline">
    			<div class="invalid-feedback">
         			Please Provide The Deadline.
   				 </div>
  				</div>
  				
  				<div class="form-group">
    				<label for="changefile">Do You Want to Change the Assignment Files?</label>
    					<select class="form-control" id="changefile" name="changefile" 
    					onchange="changeAssignmentFileFunc(this)" required>
      						<option value="no">No</option>
      						<option value="yes">Yes</option>
    					</select>
  				</div>
  				
  				<div class="form-group" id="editfilediv" style="display:none;">
    			<label for="editfile">Choose Files <span style="color:red;">*</span></label>
    			<input class="form-control-file" type="file" id="editfile" name="file" multiple>
    			
    			<div class="invalid-feedback">
         			Select Some Files For Assignment.
   				 </div>
  				</div>
        		
  				<input type="hidden" name="Easgid" id="Easgid" value="">
  				<input type="hidden" name="Eampid" value=<%=id%>>
        	
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

function changeDeadlineFunc(ele){
	if(ele.value=="yes"){
		document.getElementById("changedeadlinediv").style.display = "";
		document.getElementById("editdeadline").setAttribute('required','');
	}else{
		document.getElementById("changedeadlinediv").style.display = "none";
		document.getElementById("editdeadline").removeAttribute('required');
	}
}

function changeAssignmentFileFunc(ele){
	if(ele.value=="yes"){
		document.getElementById("editfilediv").style.display = "";
		document.getElementById("editfile").setAttribute('required','true');
		document.forms[2].setAttribute("onsubmit","showSpinner(this)");
		
	}else{
		document.getElementById("editfilediv").style.display = "none";
		document.getElementById("editfile").removeAttribute('required');
		document.forms[2].removeAttribute("onsubmit");
	}
}


//shows confirm modal
function deleteAssignmentConfirm(asgid){
	document.getElementById("Dasgid").value=asgid;
	 $("#confirmAssignmentDeleteModal").modal("show");
	 document.forms[1].reset();
}


function editAssignmentModal(title,inst,datetime,asgid,marks){
	document.forms[2].reset();
	document.forms[2].className="needs-validation";
	var ele = document.getElementById("editAssignmentModal");
	let textarea = ele.getElementsByTagName('textarea');
	let input = ele.getElementsByTagName('input');
	
	textarea[0].value = title;
	textarea[1].value = inst;
	input[0].value = marks;
	input[3].value = asgid;
	
	$("#editAssignmentModal").modal("show");
}


$('#addAssignment_modal').on('hide.bs.modal',function () {
	document.forms[0].className="needs-validation";
	document.forms[0].reset();
})

function showSpinner(ele){
	if(ele.checkValidity()){
		$("#spinnerMove").modal("show");
		console.log("hiii");
	}
}
</script>
<script src="javascript/script.js"></script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>