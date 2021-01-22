
<%@page import="login.LoginBean"%>
<%
    response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("admin_id")!=null){
		response.sendRedirect("admin_home.jsp");
	}

	if(session.getAttribute("std_id")!=null){
		response.sendRedirect("student_home.jsp");
	}
	
	if(session.getAttribute("edu_id")!=null){
		response.sendRedirect("educator_home.jsp");
	}
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<title>EduHITec | Login</title>
<link rel="stylesheet" href="css/login.css">
</head>
<body onload="active();" class="text-center">

<div class="modal fade" id="loginError" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
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
<!-- Modal for successful submission of email in case of forgot password -->
<div class="modal fade" id="success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	An Email Has Been Sent To Your Email Address. Follow That link for 
        	further process. Note :- The link is Valid for 2 days Only !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<%
	if(session.getAttribute("error") != null){
		session.removeAttribute("error");
%>
<script>
		$(document).ready(function(){
			    $("#loginError").modal("show");
		    
		});
	</script>	
<%
	}else if(session.getAttribute("success") != null){
		session.removeAttribute("success");
%>
<script>
		$(document).ready(function(){
			    $("#success").modal("show");
		    
		});
	</script>
<%
	}else if(session.getAttribute("novalid1") != null){
		session.removeAttribute("novalid1");
%>
<script>
	alert("Please Do Not SurPass The Validations");
</script>
<%
	}
%>
	<%@include file="index_menu.html"%>
	
	<%
		if(session.getAttribute("bean") != null){
			LoginBean bean = (LoginBean)session.getAttribute("bean");
			session.removeAttribute("bean");
	%>
		<form method="post" class="form-signin needs-validation" novalidate style="margin-top:5%;">
	<h1 class="h3 mb-3 font-weight-normal">Log In</h1><br>
    <label for="email"  class="sr-only"><b>Email</b></label>
    <input type="email" placeholder="Enter Email" name="email" id="email" class="form-control" 
    autofocus required value="<%=bean.getEmail()%>">
    <div class="invalid-feedback">
          Please provide a valid email.
     </div><br>

    <label for="pwd" class="sr-only"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="pwd" id="pwd" required class="form-control" 
    value="<%=bean.getPwd()%>">
    <div class="invalid-feedback">
          Please fill this field.
     </div><br>
    
    <label for="role"><b>Select Your Role</b></label>
    <select id="role" name="role" required class="form-control">
    	<%
    		if(bean.getRole() == null || bean.getRole().length() == 0){
    	%>
    	<option value="" disabled selected>--Select Your Role ---</option>
    	<%
    		}else{
    			
    	%>
    	<option value="" disabled>--Select Your Role ---</option>
    	<%
    		}
    	%>
    	
    	<%
    		if(bean.getRole() != null && bean.getRole().equalsIgnoreCase("admin")){
    	%>
    	<option value='admin' selected>Admin</option>
    	<%
    		}else{
    	%>
    	<option value='admin' >Admin</option>
    	<%
    		}
    	%>
    	
    	<%
    		if(bean.getRole() != null && bean.getRole().equalsIgnoreCase("educator")){
    	%>
    	<option value='educator' selected>Educator</option>
    	<%
    		}else{
    	%>
    	<option value='educator' >Educator</option>
    		
    	<%
    	
    		}
    	%>
    	
    	<%
    		if(bean.getRole() != null && bean.getRole().equalsIgnoreCase("student")){
    	%>
    	<option value='student' selected>Student</option>
    	<%
    		}else{
    	%>
    	<option value='student'>Student</option>
    	<%
    		}
    	%>
    </select><br>
    
    <%
    	if(session.getAttribute("novalid")!=null){
    		session.removeAttribute("novalid");
    %>
    	<h6 style="color: red;">Invalid Id/Password</h6>
    <%
    	}else if(session.getAttribute("validate") != null){
    		session.removeAttribute("validate");
    %>
    <h6 style="color: red;">Please Complete The Email Validation Process First</h6>
    <%
    	}
    %>
    
    <a href="#" data-toggle="modal" data-target="#forgot_pwd">Forgot Password Click Here</a><br>
   <br><button class="btn btn-lg btn-primary btn-block" onclick="loginSelect();">Log in</button>
      
</form>
	<%
		}else{
	%>
	
	<form method="post" class="form-signin needs-validation" novalidate style="margin-top:5%;">
	<h1 class="h3 mb-3 font-weight-normal">Log In</h1><br>
    <label for="email"  class="sr-only"><b>Email</b></label>
    <input type="email" placeholder="Enter Email" name="email" id="email" class="form-control" 
    autofocus required >
    <div class="invalid-feedback">
          Please provide a valid email.
     </div><br>

    <label for="pwd" class="sr-only"><b>Password</b></label>
    <input type="password" placeholder="Enter Password" name="pwd" id="pwd" required class="form-control">
    <div class="invalid-feedback">
          Please fill this field.
     </div><br>
    
    <label for="role"><b>Select Your Role</b></label>
    <select id="role" name="role" required class="form-control">
    	<option value="" disabled selected>--Select Your Role ---</option>
    	<option value='admin'>Admin</option>
    	<option value='educator'>Educator</option>
    	<option value='student'>Student</option>
    </select><br>
    <a href="#" data-toggle="modal" data-target="#forgot_pwd">Forgot Password Click Here</a><br>
    
   <br><button class="btn btn-lg btn-primary btn-block" onclick="loginSelect();">Log in</button>
      
</form>

<%
		}
%>

<form class="needs-validation" action="ForgotPwd" method="post" novalidate>
<div class="modal fade" id="forgot_pwd" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Fill All the Details
<br>Note: All the mandatory fields are marked by *</small><br><br>

   <div class="form-group">
    <label for="fpemail">Enter Your Log In Email <span style="color:red;">*</span></label>
    <input type="email" class="form-control" id="fpemail" name="fpemail" placeholder="Email ..." 
            required>
    <div class="invalid-feedback">
         Please provide a valid email.
    </div>
  	</div>

	<div class="form-group">
    	<label for="fprole"><b>Select Your Role</b></label>
    	<select id="fprole" name="fprole" id="fprole" required class="form-control" onchange="checkCredentials();">
    		<option value="" disabled selected>--Select Your Role ---</option>
    		<option value='admin'>Admin</option>
    		<option value='educator'>Educator</option>
    		<option value='student'>Student</option>
    	</select>
  </div>
  
   <div id="notExist" style="display: none;
    			width: 100%;
    			margin-top: .25rem;
    			font-size: 80%;
    			color: #dc3545;">
    		This User Does Not Exist
    </div>
  </div>
      <div class="modal-footer">
      <button class="btn btn-primary" type="submit" id="submitForm">Submit</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
</form>

</body>
<script type="text/javascript">
function active(){
	document.getElementById("Login").className = "nav-item active";
}

$('#fpemail').on('input',function() {
	$.post("CheckForgotPwdEmail",
		    {
		      role : $('#fprole').val(),
		      email : $('#fpemail').val()
		    },
		    function(data,status){
		    	if(data == 'novalid' && status == 'success'){
					document.getElementById("notExist").style.display = "";
					document.getElementById("submitForm").setAttribute('disabled','true');
				}else if(data == 'valid' && status=="success"){
					document.getElementById("notExist").style.display = "none";
					if(document.getElementById("submitForm").hasAttribute('disabled'))
						document.getElementById("submitForm").removeAttribute('disabled');
				}
		    });
});

function checkCredentials(){
	
		$.post("CheckForgotPwdEmail",
			    {
			      role : $('#fprole').val(),
			      email : $('#fpemail').val()
			    },
			    function(data,status){
			    	if(data == 'novalid' && status == 'success'){
						document.getElementById("notExist").style.display = "";
						document.getElementById("submitForm").setAttribute('disabled','true');
					}else if(data == 'valid' && status=="success"){
						document.getElementById("notExist").style.display = "none";
						if(document.getElementById("submitForm").hasAttribute('disabled'))
							document.getElementById("submitForm").removeAttribute('disabled');
					}
			    });
}
</script>
<script type="text/javascript" src="javascript/script.js"></script>
<script src="https://getbootstrap.com/docs/4.0/assets/js/vendor/holder.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</html>