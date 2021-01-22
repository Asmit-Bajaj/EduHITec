<%@page import="hide.DataHiding"%>
<%@page import="assignment.SubmissionBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="assignment.AssignmentDao"%>
<%@page import="assignment.MainListAssignmentsBean"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("std_id")!=null && request.getParameter("asgid")!=null
	&& request.getParameter("name") != null){
%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<link rel="stylesheet" href="css/style.css">
<style>
	a:hover{
		text-decoration: none;
	}
</style>
<title>EduHITec | Connecting Students and Educator</title>
</head>
<body onload="getAssignmentStatus();">	
<%@include file="student_menu.html"%>
<br><br>
<div class="modal fade" id="addsuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Submission added Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!--Assignment is removed by educator So Redirect back to main section-->
<div class="modal fade" id="redirectAssignmentRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	 This Assignment Has been Removed By The User Right Now !!! <br><br>
        	 !!So We Are Redirecting You Back To The Main Section !! Click Okay Button To Redirect 
        </div>
      </div>
      <div class="modal-footer">
        <a type="button" href="studentAssignmentMainSection.jsp" class="btn btn-success">Okay</a>
      </div>
    </div>
  </div>
</div>


<div class="modal fade" id="error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong try again!!! If Issue persist then try to contact the owner
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>


<div class="modal fade" id="deadlineerror" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	You Cannot make or change submission after deadline!!!! 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="changesuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Submission Modified Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<%
	if(session.getAttribute("addsuccess")!=null){
		session.removeAttribute("addsuccess");
%>
<script>
		$(document).ready(function(){
			    $("#addsuccess").modal("show");   
		});
</script>		

<%
		}else if(session.getAttribute("noallowed")!=null){
			session.removeAttribute("noallowed");
%>
	<script>
		$(document).ready(function(){
			    $("#deadlineerror").modal("show");   
		});
	</script>	
<%
		}else if(session.getAttribute("changesuccess")!=null){
			session.removeAttribute("changesuccess");
%>
<script>
		$(document).ready(function(){
			    $("#changesuccess").modal("show");   
		});
	</script>

<%
		}else if(session.getAttribute("error")!=null){
			session.removeAttribute("error");
%>
<script>
		$(document).ready(function(){
			    $("#error").modal("show");   
		});
	</script>

<%
		}
%>
<%
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("asgid")));
	ArrayList<Object> list = new AssignmentDao().getAssignment(id,(Integer)session.getAttribute("std_id"));
	MainListAssignmentsBean bean = (MainListAssignmentsBean)list.get(0);
	SubmissionBean bean1 = (SubmissionBean)list.get(1);
%>
<a href="studentAssignmentMainSection.jsp" class="m-5"><- Return back To Main Page</a>
	<div class="m-5">
        <h1><%=bean.getTitle()%></h1>
        <h6 style="color:grey;">Posted By <%=request.getParameter("name")%></h6>
        <p style="float:left;">Total Marks : <%=bean.getMarks()%></p><br><br>
        <%
        	if(bean1 == null){
        %>
        <p style="float:left;">Marks Awarded: Not Submitted</p><br>
        <%
        	}else{
        		if(bean1.getMarks() == -1){
        %>
        	<p style="float:left;">Marks Awarded: Not Checked</p><br>
        <% 
        		}else{
        			
        %>
        <p style="float:left;">Marks Awarded: <%=bean1.getMarks()%></p><br>
        <% 			
        		}
        	}
        %>
  
        <p style="float:right;">Deadline : <%=bean.getDeadline()%></p><br>
        <hr style="background-color: black;"><br>
        
        <p style="white-space:pre-wrap;">Instructions : 
<%=bean.getInstructions()%>
</p><br><hr>
        
        <div class="text-center">
        <h6>Assignment Files</h6><br>
        <%
        String[] orgname = bean.getOrgNames();
      	String[] extensions = bean.getExtensions();
        	for(int j=0;j<bean.getNo_of_files();j++){
        %>
        <a style="word-wrap: break-word;" href="assignment/EduHItec_assignment_<%=id%><%=j+1%>.<%=extensions[j]%>" target="_blank"><%=orgname[j]%></a><br><br>
        <% 
        	}
        %>
        </div>
        <hr><br>
        <div class="m-5 p-4" style="border-radius: 10px 10px;
        box-shadow: 1px 1px 8px #808080c4;">
            <h4 style="text-align: center;">Your Submission</h4>
            <%
            	if(bean1 == null){
            %>
            <div style="text-align: center;" class="m-4">No Submissions Made Yet</div>
            <div style="text-align: center;" class="m-4">
                <button type="button" class="btn btn-dark" data-toggle="modal" data-target="#AddSubmissionModal">
                    Add Submission
                </button>
            </div>
            <% 		
            	}else if(bean1.getMarks() == -1){
            %>
            <div style="text-align: center;" class="m-4">
            <%
        		for(int i=0;i<bean1.getNo_of_files();i++){
        	%>
        	<a href="assignSubmission/EduHITec_submission_<%=session.getAttribute("std_id")%><%=id%><%=i+1%>.<%=bean1.getExtensions()[i]%>"><%=bean1.getOrgnames()[i]%></a><br><br>
        	<% 
        		}
            	
            %>
            
            </div>
            <div style="text-align: center;" class="m-4">
                <button type="button" class="btn btn-dark" data-toggle="modal" data-target="#ChangeSubmissionModal">
                    Change Submission
                </button>
            </div>
            <% 	
            	}else{
            		
            %>
            <div style="text-align: center;" class="m-4">
            
            <%
        		for(int i=0;i<bean1.getNo_of_files();i++){
        	%>
        	<a style="word-wrap: break-word;" href="assignSubmission/EduHITec_submission_<%=session.getAttribute("std_id")%><%=id%><%=i+1%>.<%=bean1.getExtensions()[i]%>"><%=bean1.getOrgnames()[i]%></a><br><br>
        	<% 
        		}
            	
            %>
            </div>
            <div style="text-align: center;" class="m-4">
            <%
            	if(bean1.getRet_no_of_files() != -1){
            %>
            <hr><h6>Returned Files By the Educator</h6><br>
            <% 
            		for(int j=0;j<bean1.getRet_no_of_files();j++){
            %>
            <a style="word-wrap: break-word;" href="assignmentSubmissionReturnedFiles/EduHITec_submission_<%=session.getAttribute("std_id")%><%=id%><%=j+1%>.<%=bean1.getRet_extensions()[j]%>"><%=bean1.getRet_orgnames()[j]%></a><br><br>
            <%		
            		}
            %>
            	<hr>
            <% 
            	}
            %>
            	<br>
            	<%
            		if(bean1.getFeedback() != null){
            	%>
            	<h6>FeedBack</h6>
   				<p><%=bean1.getFeedback()%></p>
            	<%
            	
            		}
            	%>
                
            </div>
            <% 
            	}
            %> 
        </div>
    </div>
    
    <%
    	if(session.getAttribute("novalidFilesAdd") != null){
    		session.removeAttribute("novalidFilesAdd");
    		
    %>
    <form id="AddSubmissionForm" action="SubmitAssignment" method="post" 
    novalidate class="was-validated" enctype="multipart/form-data" onsubmit="showSpinner(this);">
    <div class="modal fade" id="AddSubmissionModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Add Submission</h5>
          </div>
          <div class="modal-body">
          
          <div class="form-group">
    			 <label for="fileInput">Select Assignment Files <span style="color:red;">*</span></label>
           		 <input type="file" class="form-control-file" id="fileInput" name="file" required multiple>
           		<div class="invalid-feedback">
         			Select Some Files For Assignment.
   				 </div>
  		  </div>
            
            <input type="hidden" value="<%=id%>" name="asgid" >
            <input type="hidden" value="<%=request.getParameter("name")%>" name="name">
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button class="btn btn-primary" type="submit">Add</button>
          </div>
        </div>
      </div>
    </div>
    </form> 
   <script>
		$(document).ready(function(){
			    $("#AddSubmissionModal").modal("show");   
		});
	</script>
    <%
    	}else{
    %>
    
<form class="needs-validation" id="AddSubmissionForm" action="SubmitAssignment"
    method="post" enctype="multipart/form-data" novalidate onsubmit="showSpinner(this);">
    <div class="modal fade" id="AddSubmissionModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Add Submission</h5>
          </div>
          <div class="modal-body">
          
            <div class="form-group">
    			 <label for="fileInput">Select Assignment Files <span style="color:red;">*</span></label>
           		 <input type="file" class="form-control-file" id="fileInput" required name="file" multiple>
           		 
           		 <div class="invalid-feedback">
         			Select Some Files.
   				 </div>
  		  	</div>
  		  
            <input type="hidden" value="<%=id%>" name="asgid" >
            <input type="hidden" value="<%=request.getParameter("name")%>" name="name">
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary" >Add</button>
          </div>
        </div>
      </div>
    </div>
    </form> 
    <%
    	}
    %>
    
<%
    	if(session.getAttribute("novalidFilesEdit") != null){
    		session.removeAttribute("novalidFilesEdit");
    		
%>

<form id="ChangeSubmissionForm" action="ChangeSubmission" 
method="post" enctype="multipart/form-data" class="was-validated" novalidate onsubmit="showSpinner(this);"> 
    <div class="modal fade" id="ChangeSubmissionModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Change Submission</h5>
          </div>
          <div class="modal-body">
          
            <div class="form-group">
    			 <label for="fileInput">Select Assignment Files <span style="color:red;">*</span></label>
           		 <input type="file" class="form-control-file" id="fileInput" required name="file" multiple>
           		 
           		 <div class="invalid-feedback">
         			Select Some Files.
   				 </div>
  		  	</div>
  		  	
            <input type="hidden" value="<%=id%>" name="asgid">
           <input type="hidden" value="<%=request.getParameter("name")%>" name="name">
           
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button class="btn btn-primary" type="submit">Change</button>
          </div>
        </div>
      </div>
    </div>
  </form>     
  <script>
		$(document).ready(function(){
			    $("#ChangeSubmissionModal").modal("show");   
		});
	</script>
    <%
    	}else{
    %>
<form id="ChangeSubmissionForm" action="ChangeSubmission"
 method="post" enctype="multipart/form-data" class="needs-validation" novalidate onsubmit="showSpinner(this);"> 
    <div class="modal fade" id="ChangeSubmissionModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="exampleModalLabel">Change Submission</h5>
          </div>
          <div class="modal-body">
          
            <div class="form-group">
    			 <label for="fileInput">Select Assignment Files <span style="color:red;">*</span></label>
           		 <input type="file" class="form-control-file" id="fileInput" required name="file" multiple>
           		 
           		 <div class="invalid-feedback">
         			Select Some Files.
   				 </div>
  		  	</div>
  		  	
            <input type="hidden" value="<%=id%>" name="asgid">
           <input type="hidden" value="<%=request.getParameter("name")%>" name="name">
           
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            <button class="btn btn-primary" type="submit">Change</button>
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
<script type="text/javascript">
function showSpinner(ele){
	if(ele.checkValidity()){
		$("#spinnerMove").modal("show");
	}
}
//to check that assignment exist or not
function getAssignmentStatus(){
	$.post("CheckAssignmentAvailability",
		    {
		      asgid : `<%=request.getParameter("asgid")%>`
		    },
		    function(data,status){
		    	if(data == "remove" && status == 'success'){
		    			$("#redirectAssignmentRemove").modal("show");
				}
		    	getAssignmentStatus();
		    });
}
</script>
<script type="text/javascript" src="javascript/script.js"></script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>