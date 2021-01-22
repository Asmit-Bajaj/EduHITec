<%@page import="admin.AdminBean"%>
<%@page import="admin.EducatorBean"%>
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

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" 
integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@562&display=swap" rel="stylesheet">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<title>EduHITec | My Profile</title>
<link href="css/style.css" rel="stylesheet">
</head>
<body>
<%@include file="admin_menu.html"%>
<!-- Modal for successful updation of Email -->
<div class="modal fade" id="adminUpdateEmailSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Email Updated Successfully !!! <br><br>A Validation link is sent on the email address specified <br>Please
        	ensure to validate email from that link within 10 days!!!<br> Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal for successful updation of Password -->
<div class="modal fade" id="adminUpdatePwdSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Password Updated Successfully !!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal for successful updation of Password -->
<div class="modal fade" id="adminUpdateInfoSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Your Information Updated Successfully !!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal for error during removal of Educator -->
<div class="modal fade" id="Error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Something went wrong at server side !! if problem persist then try to contact the owner
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
		if(session.getAttribute("success").equals("1")){	
%>
<script>
		$(document).ready(function(){
			    $("#adminUpdateEmailSuccess").modal("show");
		    
		});
	</script>	
<%	
		}else if(session.getAttribute("success").equals("2")){
%>
<script>
		$(document).ready(function(){
			    $("#adminUpdatePwdSuccess").modal("show");
		    
		});
	</script>	
<%
		}else if(session.getAttribute("success").equals("3")){
%>
<script>
		$(document).ready(function(){
			    $("#adminUpdateInfoSuccess").modal("show");
		    
		});
	</script>	
<%
		}
		session.removeAttribute("success");
	}else if(session.getAttribute("error") != null){
%>
<script>
		$(document).ready(function(){
			    $("#Error").modal("show");
		    
		});
	</script>
<%
		session.removeAttribute("error");
	}
%>

<%
	if(session.getAttribute("noValidEmail") != null){
		session.removeAttribute("noValidEmail");
%>
	<script>
		alert("This email already exist");
	</script>
<%
	}else if(session.getAttribute("novalidPwd") != null){
		session.removeAttribute("novalidPwd");
%>
<script>
		alert("This old password does not exist");
	</script>
<%
	}else if(session.getAttribute("surpassPwd")!=null){
		session.removeAttribute("surpassPwd");
%>
<script>
		alert("Please do not enter empty password");
	</script>
<% 
	}
%>
	<%
		AdminBean bean = new AdminDao().getProfile((Integer)session.getAttribute("admin_id"));
	%>
	<div class="container admin_profile">
        <div class="row">
            <div class="col-md-4" style="align-content: center;">
                <div class="profile-img">
                    <ul class="list-unstyled components mb-5"
                        style="font-size: 20px; margin:0%; padding-left: 20%; margin-bottom:1px; padding-top: 10px; padding-bottom: 10px;">

                        <span style="align-self: left; font-weight: 600; font-size: large;">Profile Settings</span>
                        <a href="#" class="educator-a_tag" data-toggle="modal" data-target="#editPwd">

                            <button type="button" class="admin_profile_button btn btn-light"
                                style="margin:2%; text-align: left; color:#44b3fd">
                                <svg class="admin_profile_svg" width="1.5em" height="1.5em" viewBox="0 0 16 16"
                                    class="educator-icons bi bi-person-circle" fill="currentColor"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path
                                        d="M13.468 12.37C12.758 11.226 11.195 10 8 10s-4.757 1.225-5.468 2.37A6.987 6.987 0 0 0 8 15a6.987 6.987 0 0 0 5.468-2.63z" />
                                    <path fill-rule="evenodd" d="M8 9a3 3 0 1 0 0-6 3 3 0 0 0 0 6z" />
                                    <path fill-rule="evenodd"
                                        d="M8 1a7 7 0 1 0 0 14A7 7 0 0 0 8 1zM0 8a8 8 0 1 1 16 0A8 8 0 0 1 0 8z" />
                                </svg>
                                Reset Password</a>
                        </button>

                        <br>
                        <a href="#" class="educator-a_tag" data-toggle="modal" data-target="#editEmail">

                            <button type="button" class="admin_profile_button btn btn-light"
                                style="margin:2%; text-align: left; color:#44b3fd">
                                <svg class="admin_profile_svg" width="1.5em" height="1.5em" viewBox="0 0 16 16"
                                    class="educator-icons bi bi-plus-circle-fill" fill="currentColor"
                                    xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd"
                                        d="M16 8A8 8 0 1 1 0 8a8 8 0 0 1 16 0zM8.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3v-3z" />
                                </svg>
                                Change Email</a>
                        </button>
                        </a>
                    </ul>
                </div>
            </div>
            <div class="col-md-6">
                <div class="admin_profile-content">
                    <h4 class="profile_name"
                        style="margin-bottom:5%;color:#333; font-size: xx-large; font-family: 'Dancing Script', cursive">
                        <%=bean.getName()%>
                    </h4>
                    <div class="col-md-12">
                        <div class="admin_profile_details tab-content">
                            <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p style="font-weight: 700;">Email</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><%=bean.getEmail()%></p>
                                    </div>
                                </div>
                                <%
                                	if(bean.getEmp_id() != null){
                                %>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p style="font-weight: 700;">Employee id</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><%=bean.getEmp_id()%></p>
                                    </div>
                                </div>
                                <%
                                	}else{
                                %>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p style="font-weight: 700;">Employee id</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p>-- NA --</p>
                                    </div>
                                </div>
                                <%
                                	}
                                %>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <p style="font-weight: 700;">Contact No.</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><%=bean.getContact_no()%></p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p style="font-weight: 700;">Address</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><%=bean.getAddress()%></p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p style="font-weight: 700;">City</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><%=bean.getCity()%></p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p style="font-weight: 700;">State</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><%=bean.getState()%></p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-6">
                                        <p style="font-weight: 700;">Gender</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><%=bean.getGender()%></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>


                </div>
            </div>

            <div class="col-md-2" style="color:#44b3fd">
                <a href="editAdminProfile.jsp">Edit Profile
                    <svg width="1em" height="1em" viewBox="0 0 16 16" class="bi bi-pencil-fill" fill="currentColor"
                        xmlns="http://www.w3.org/2000/svg">
                        <path fill-rule="evenodd"
                            d="M12.854.146a.5.5 0 0 0-.707 0L10.5 1.793 14.207 5.5l1.647-1.646a.5.5 0 0 0 0-.708l-3-3zm.646 6.061L9.793 2.5 3.293 9H3.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.5h.5a.5.5 0 0 1 .5.5v.207l6.5-6.5zm-7.468 7.468A.5.5 0 0 1 6 13.5V13h-.5a.5.5 0 0 1-.5-.5V12h-.5a.5.5 0 0 1-.5-.5V11h-.5a.5.5 0 0 1-.5-.5V10h-.5a.499.499 0 0 1-.175-.032l-.179.178a.5.5 0 0 0-.11.168l-2 5a.5.5 0 0 0 .65.65l5-2a.5.5 0 0 0 .168-.11l.178-.178z" />
                    </svg>
                </a>
            </div>
        </div>


    </div>
    
<form class="needs-validation" action="UpdateAdminEmail" method="post" novalidate>
<div class="modal fade" id="editEmail" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br><br>

   <div class="form-group">
    <label for="email">Enter New Email <span style="color:red;">*</span></label>
    <input type="email" class="form-control" id="email" name="email" placeholder="Email ..." 
            required>
    <div class="invalid-feedback">
         Please provide valid email.
    </div>
    
    <div id="alreadyExistEmail" style="display: none;
    		width: 100%;
    	margin-top: .25rem;
    	font-size: 80%;
    	color: #dc3545;">
    	This Email address already Exist
    </div>
  </div>
 
  </div>
      <div class="modal-footer">
      <button class="btn btn-primary" type="submit" id="submitEmail">Update Email</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
</form>

<form class="needs-validation" action="ChangeAdminPwd" method="post" novalidate>
<div class="modal fade" id="editPwd" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br><br>

   <div class="form-group">
          <label for="oldpwd">Enter Old Password <span style="color:red;">*</span></label>
            <input type="password" class="form-control" id="oldpwd" placeholder="Old Password ..." 
            required aria-describedby="oldpwdHelp" name="oldpwd" maxlength="50" minlength="8" value="">
            
            <small id="oldpwdHelp" class="text-muted">
              Password must be 8 characters long
            </small>
            <div class="invalid-feedback">
              Please provide a valid password.
            </div>
            
            <div id="pwdNotExist" style="display: none;
    			width: 100%;
    			margin-top: .25rem;
    			font-size: 80%;
    			color: #dc3545;">
    		Please Enter the Correct Old Password
    	</div>
    </div>
    
    <div class="form-group">
          <label for="newpwd">Enter New Password <span style="color:red;">*</span></label>
            <input type="password" class="form-control" id="newpwd" placeholder="New Password ..." 
            required aria-describedby="newpwdHelp" name="newpwd" maxlength="50" minlength="8" value="" disabled>
            
            <small id="newpwdHelp" class="text-muted">
              Password must be 8 characters long
            </small>
            <div class="invalid-feedback">
              Please provide a valid password.
            </div>
    </div>
    
       <br><br>
 
  </div>
      <div class="modal-footer">
      <button class="btn btn-primary" type="submit" id="submitPwd" disabled>Update Password</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
</form>

</body>

<script>
//to verify that email not exist
$(document).ready(function() {
	$('#email').on('input',function() {
		$.post("CheckEmailAdmin",
			    {
			      email: $('#email').val()
			    },
			    function(data,status){
			    	if(data == 'novalid' && status == 'success'){
						document.getElementById("alreadyExistEmail").style.display = "";
						document.getElementById("submitEmail").setAttribute('disabled','true');
					}else{
						document.getElementById("alreadyExistEmail").style.display = "none";
						if(document.getElementById("submitEmail").hasAttribute('disabled'))
							document.getElementById("submitEmail").removeAttribute('disabled');
					}
			    });
		});
});

$(document).ready(function() {
	$('#oldpwd').on('input',function() {
		$.post("CheckAdminPwd",
			    {
			      pwd: $('#oldpwd').val()
			    },
			    function(data,status){
			    	if(data == 'novalid' && status == 'success'){
						document.getElementById("pwdNotExist").style.display = "";
						document.getElementById("submitPwd").setAttribute('disabled','true');
						document.getElementById("newpwd").setAttribute("disabled",'true');
					}else if(data == 'valid' && status=="success"){
						document.getElementById("pwdNotExist").style.display = "none";
						document.getElementById("newpwd").removeAttribute("disabled");
						if(document.getElementById("submitPwd").hasAttribute('disabled'))
							document.getElementById("submitPwd").removeAttribute('disabled');
					}
			    });
		});
});

//to reset email form
$('#editEmail').on('hide.bs.modal',function () {
	document.forms[0].reset();
	document.forms[0].className="needs-validation";
	//document.getElementById("email").value="";
	document.getElementById("alreadyExistEmail").style.display = "none";
	if(document.getElementById("submitEmail").hasAttribute('disabled'))
		document.getElementById("submitEmail").removeAttribute('disabled');
})

//to reset pwd form
$('#editPwd').on('hide.bs.modal',function () {
	document.forms[1].reset();
	document.forms[1].className="needs-validation";
	document.getElementById("pwdNotExist").style.display = "none";
	//document.getElementById("oldpwd").value="";
	
	document.getElementById("submitPwd").setAttribute('disabled','true');
	document.getElementById("newpwd").setAttribute("disabled",'true');
	
})

</script>
<script src="javascript/script.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>

</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>