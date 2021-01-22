<%@page import="admin.SubjectBean"%>
<%@page import="admin.AdminDao"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("admin_id")!=null){
		
%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Add Subject</title>
</head>
<body>

<div class="modal fade" id="addSubjectSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Subject added successfully!!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="addSubjectError" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something Went Wrong at server !!
        	<br>If problem persist then try to contact the owner
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<%
	if(session.getAttribute("success") != null){
		session.removeAttribute("success");
%>
<script>
		$(document).ready(function(){
			    $("#addSubjectSuccess").modal("show");
		    
		});
	</script>	
<%
	}else if(session.getAttribute("error") != null){
		session.removeAttribute("error");
%>
<script>
		$(document).ready(function(){
			    $("#addSubjectError").modal("show");
		    
		});
	</script>
<%
		
	}else if(session.getAttribute("exist") != null){
%>
<script>
		alert("Duplicate Subject Name !!!");
	</script>
<%
	session.removeAttribute("exist");
	}
%>


<%@include file="admin_menu.html"%>



<h4 style="margin:3%;" align="center">Fill Up The Following Details of Subject :- <hr></h4>
    
    <h6 style="margin-left:3%;">Note : Mandatory fields are marked by 
        <span style="color:red;">*</span>
    </h6>
    
<%
	if(session.getAttribute("no_validSub") != null){
		SubjectBean bean = (SubjectBean)session.getAttribute("no_validSub");
		session.removeAttribute("no_validSub");
		
%>
<div class="educator-form-box" style="margin-left: 10%;margin-right: 10%;">
    
    <form class="was-validated" novalidate align="center" action="AddSubject" method="post">
        <div class="form-row">
            <div class="form-group col-md-6">
              <label for="subjectName">Enter Subject Name <span style="color: red;">*</span></label>
              <input type="text" class="form-control" id="subjectName" name="subjectName" 
              placeholder="subject name ..." pattern="[A-Z a-z]*" required maxlength="200"
               value="<%=bean.getSubjectName()%>">
              
              <div class="invalid-feedback">
                Please provide a valid Subject Name.
              </div>
              <div id="alreadyExistName" style="display: none;
    		width: 100%;margin-top: .25rem;font-size: 80%;color: #dc3545;">
    		This Name already Exist
    		</div>
            </div>
            <div class="form-group col-md-6">
              <label for="code">Enter Subject Code</label>
              <input type="text" class="form-control" id="code" name="code" maxlength="100"
              placeholder="subject code ..." value="<%=bean.getCode()%>">
            </div>
          </div>
          <br>
          <div class="form-row">
            <div class="form-group col-md-6">
              <label for="subjectSession">Enter Session (if any) </label>
              <input type="text" class="form-control" id="subjectSession" name="subjectSession" 
              placeholder="subject session ..." maxlength="200" aria-describedby="subjectSessionHelp"
               value="<%=bean.getSession()%>">
              <small id="subjectSessionHelp" class="text-muted">
               	For eg. Jan-June 2019
              </small>
            </div>
            <div class="form-group col-md-6">
              <label for="course">Enter Course (If any) </label>
              <input type="text" class="form-control" id="course" name="course" maxlength="200"
              placeholder="subject course ..." value="<%=bean.getCourse()%>">
              <small id="subjectSessionHelp" class="text-muted">
               	For eg. B.Tech Computer Science
              </small>
            </div>
          </div>
          
          <br><br>
          <button type="submit" class="btn btn-primary" id="submitForm">Submit</button>
      </form>
</div>

    
<%
	}else{

%>    
<div class="educator-form-box" style="margin-left: 10%;margin-right: 10%;">
    
    <form class="needs-validation" novalidate align="center" action="AddSubject" method="post">
        <div class="form-row">
            <div class="form-group col-md-6">
              <label for="subjectName">Enter Subject Name <span style="color: red;">*</span></label>
              <input type="text" class="form-control" id="subjectName" name="subjectName" 
              placeholder="subject name ..." pattern="[A-Z a-z]*" required maxlength="200" value="">
              <div class="invalid-feedback">
                Please provide a valid Subject Name.
              </div>
              <div id="alreadyExistName" style="display: none;
    		width: 100%;margin-top: .25rem;font-size: 80%;color: #dc3545;">
    		This Name already Exist
    		</div>
            </div>
            <div class="form-group col-md-6">
              <label for="code">Enter Subject Code</label>
              <input type="text" class="form-control" id="code" name="code" maxlength="100"
              placeholder="subject code ..." value="">
            </div>
          </div>
          
          <div class="form-row">
            <div class="form-group col-md-6">
              <label for="subjectSession">Enter Session (if any)</label>
              <input type="text" class="form-control" id="subjectSession" name="subjectSession" 
              placeholder="subject session ..." maxlength="200" aria-describedby="subjectSessionHelp"
               value="">
              <small id="subjectSessionHelp" class="text-muted">
               	For eg. Jan-June 2019
              </small>
            </div>
            <div class="form-group col-md-6">
              <label for="course">Enter Course (If any) </label>
              <input type="text" class="form-control" id="course" name="course" maxlength="200"
              placeholder="subject course ..." value="">
              <small id="subjectSessionHelp" class="text-muted">
               	For eg. B.Tech Computer Science
              </small>
            </div>
          </div>
          
          <br><br>
          <button type="submit" class="btn btn-primary" id="submitForm">Submit</button>
      </form>
</div>

<%
	}
%>


</body>
<script type="text/javascript" src="javascript/script.js"></script>
<script>
//to verify this name not exist
$(document).ready(function() {
	$('#subjectName').on('input',function() {
		$.post("CheckSubjectName",
			    {
			      name: $('#subjectName').val()
			    },
			    function(data,status){
			    	if(data == 'exist' && status == 'success'){
						document.getElementById("alreadyExistName").style.display = "";
						document.getElementById("submitForm").setAttribute('disabled','true');
					}else{
						document.getElementById("alreadyExistName").style.display = "none";
						if(document.getElementById("submitForm").hasAttribute('disabled'))
							document.getElementById("submitForm").removeAttribute('disabled');
					}
			    });
		});
});
</script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>