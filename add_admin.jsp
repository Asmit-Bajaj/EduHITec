<%@page import="master.MasterDao"%>
<%@page import="master.InstituteBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="admin.AdminBean"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("master")!=null){
%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" 
integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<title>EduHITec | Add Admin</title>
<link href="css/style.css" rel="stylesheet">
</head>
<body>

<!-- Modal for successful addition of Admin -->
<div class="modal fade" id="adminAddSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Admin added Successfully !!! <br><br>A Validation link is sent on the email address specified <br>Please
        	ensure to validate email from that link within 10 days!!!<br> Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<!-- Modal for error during addition of Admin -->
<div class="modal fade" id="adminAddError" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
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
		session.removeAttribute("success");
%>
<script>
		$(document).ready(function(){
			    $("#adminAddSuccess").modal("show");
		    
		});
	</script>	
<%
	}else if(session.getAttribute("error") != null){
%>
<script>
		$(document).ready(function(){
			    $("#adminAddError").modal("show");
		    
		});
	</script>
<%
		session.removeAttribute("error");
	}
%>

<%@include file="master_menu.html"%>
 <h4 style="margin:3%;" align="center">Fill Up The Following Details of Admin :- <hr></h4>
    
    <h6 style="margin-left:3%;">Note : Mandatory fields are marked by 
        <span style="color:red;">*</span>
    </h6>
    
<%
ArrayList<InstituteBean> list = new MasterDao().getAllInstitutes();

	if(session.getAttribute("no_validAdmin") != null){
		AdminBean bean = (AdminBean)session.getAttribute("no_validAdmin");
		String name[] = bean.getName().split("/");
		session.removeAttribute("no_validAdmin");
		
%>
	<div class="educator-form-box">
    
    <form class="was-validated" novalidate action="AddAdmin" method="post">
        <div class="form-row">
            <div class="form-group col-md-3">
              <label for="firstname">First Name <span style="color:red;">*</span></label>
              <input type="text" class="form-control" id="firstname" placeholder="First Name ..." name="firstname"
              required pattern="[A-Z a-z]*" maxlength="40" aria-describedby="firstnameHelp" value="<%=name[0]%>">
              <small id="firstnameHelp" class="text-muted">
                Must be 1-40 characters long.
              </small>
              <div class="invalid-feedback">
                Please provide a valid First name.
              </div>
              
            </div>

            <div class="form-group col-md-3">
              <label for="middlename">Middle Name</label>
              <input type="text" class="form-control" id="middlename" placeholder="Middle Name ...." 
              name="middlename" value="<%=name[1]%>">
              <small id="firstnameHelp" class="text-muted">
                Max 40 characters allowed.
              </small>
            </div>
            
            <div class="form-group col-md-3">
                <label for="lastname">Last Name <span style="color:red;">*</span></label>
                <input type="text" class="form-control" id="lastname" placeholder="Last Name ...." 
                name="lastname" value="<%=name[2]%>"
                 required pattern="[A-Z a-z]*" maxlength="40" aria-describedby="lastnameHelp">
                <small id="lastnameHelp" class="text-muted">
                  Must be 1-40 characters long.
                </small>
                <div class="invalid-feedback">
                    Please provide a valid Last Name.
                </div>
            </div>

        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="email">Email <span style="color:red;">*</span></label>
            <input type="email" class="form-control" id="email" name="email" placeholder="Email ..." 
            required value="<%=bean.getEmail()%>">
            <%
            	if(session.getAttribute("email") != null){
            		session.removeAttribute("email");
            %>
            <script>
            	alert("This email address already exist in the system Please use a different email address");
            </script>
            <%
            	}
            %>
            	<div class="invalid-feedback">
                	Please provide a valid email address.
            	</div>
            	<div id="alreadyExistEmail" style="display: none;
    		width: 100%;margin-top: .25rem;font-size: 80%;color: #dc3545;">
    		This Email address already Exist
    		</div>
          </div>

          <div class="form-group col-md-6">
            <label for="emp_id">Employee Id (If exist)</label>
            <input type="text" class="form-control" id="emp_id" value="<%=bean.getEmp_id()%>"
            placeholder="employee id ..." maxlength="10" name="emp_id" aria-describedby="emp_idHelp">
            <small id="emp_idHelp" class="text-muted">
              Max 10 characters allowed
            </small>
          </div>

        </div>

        <div class="form-group">
          <label for="pwd">Password <span style="color:red;">*</span></label>
            <input type="password" class="form-control" id="pwd" placeholder="Password ..." 
            required aria-describedby="pwdHelp" name="pwd" maxlength="50" minlength="8" value="">
            
            <small id="pwdHelp" class="text-muted">
              Password must be 8 characters long
            </small>
            <div class="invalid-feedback">
              Please provide a valid password.
            </div>
        </div>
        <button type="button" class="btn btn-link btn-sm" onclick="showPwd(this);">Show Password</button>
        <br><br>
        
        <div class="form-group">
          <label for="address">Address <span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="address" placeholder="1234 Main St" 
          required maxlength="300" name="address" value="<%=bean.getAddress()%>">
          <div class="invalid-feedback">
            Please provide a valid address.
          </div>
        </div>

        <div class="form-group">
          <label for="contact_no">Contact No. <span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="contact_no" 
          placeholder="Contact number ..." required maxlength="10" 
          minlength="10" name="contact_no" pattern="[1-9][0-9]*" value="<%=bean.getContact_no()%>">
          <div class="invalid-feedback">
            Please provide a valid contact no.
          </div>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="city">City <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="city" 
            required pattern="[A-z a-z]*" maxlength="100" name="city" value="<%=bean.getCity()%>">
            <div class="invalid-feedback">
              Please provide a valid City Name.
            </div>
          </div>
          

          <div class="form-group col-md-4">
            <label for="state">State <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="state" name="state" 
            required pattern="[A-z a-z]*" maxlength="100" value="<%=bean.getState()%>">
            <div class="invalid-feedback">
              Please provide a valid State Name.
            </div>
          </div>
        </div>

        <h6>Select Gender <span style="color:red;">*</span> : </h6>
        <div class="form-check form-check-inline">
        	<%
        		if(bean.getGender().equalsIgnoreCase("male")){
        	%>
        	<input class="form-check-input" type="radio" name="gender" id="g1" value="Male" required checked="checked">
        	<%	
        		}else{
        	%>
        	<input class="form-check-input" type="radio" name="gender" id="g1" value="Male" required>
        	<%
        		}
        	%>
            
            <label class="form-check-label" for="g1" >Male</label>
        </div>

        <div class="form-check form-check-inline">
        
        <%
        if(bean.getGender().equalsIgnoreCase("female")){
        %>
          <input class="form-check-input" type="radio" name="gender" id="g2" value="Female" required checked="checked">
         <%
        }else{
        %>
        <input class="form-check-input" type="radio" name="gender" id="g2" value="Female">
        <%
        }
         %>         
          <label class="form-check-label" for="g2">Female</label>
        </div>
        
        <br><br> 
        <div class="form-group">
    		<label for="institute">Select Institute : </label>
    		<select class="form-control" id="institute" name="institute">
    		<%
        	for(int i=0;i<list.size();i++){
        	%>
      			<option value="<%=list.get(i).getInst_id()%>"><%=list.get(i).getInstituteName()%></option>
      		<%
        	}
			%>
    		</select>
  		</div>
  		<br>
        <div class="text-center">
          <button type="submit" class="btn btn-primary btn-lg" id="submitForm">Submit</button>
        </div>
      </form>
</div>
<%
	}else{
%>

<div class="educator-form-box">
    
    <form class="needs-validation" novalidate action="AddAdmin" method="post">
        <div class="form-row">
            <div class="form-group col-md-3">
              <label for="firstname">First Name <span style="color:red;">*</span></label>
              <input type="text" class="form-control" id="firstname" placeholder="First Name ..." name="firstname"
              required pattern="[A-Z a-z]*" maxlength="40" aria-describedby="firstnameHelp">
              <small id="firstnameHelp" class="text-muted">
                Must be 1-40 characters long.
              </small>
              <div class="invalid-feedback">
                Please provide a valid First name.
              </div>
              
            </div>

            <div class="form-group col-md-3">
              <label for="middlename">Middle Name</label>
              <input type="text" class="form-control" id="middlename" placeholder="Middle Name ...." name="middlename">
              <small id="firstnameHelp" class="text-muted">
                Max 40 characters allowed.
              </small>
            </div>
            
            <div class="form-group col-md-3">
                <label for="lastname">Last Name <span style="color:red;">*</span></label>
                <input type="text" class="form-control" id="lastname" placeholder="Last Name ...." name="lastname"
                 required pattern="[A-Z a-z]*" maxlength="40" aria-describedby="lastnameHelp">
                <small id="lastnameHelp" class="text-muted">
                  Must be 1-40 characters long.
                </small>
                <div class="invalid-feedback">
                    Please provide a valid Last Name.
                </div>
            </div>

        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="email">Email <span style="color:red;">*</span></label>
            <input type="email" class="form-control" id="email" name="email" placeholder="Email ..." required>
            <div class="invalid-feedback">
                Please provide a valid email address.
            </div>
            
            <div id="alreadyExistEmail" style="display: none;
    		width: 100%;margin-top: .25rem;font-size: 80%;color: #dc3545;">
    		This Email address already Exist
    		</div>
    		
          </div>

          <div class="form-group col-md-6">
            <label for="emp_id">Employee Id (If exist)</label>
            <input type="text" class="form-control" id="emp_id" 
            placeholder="employee id ..." maxlength="10" name="emp_id" aria-describedby="emp_idHelp">
            <small id="emp_idHelp" class="text-muted">
              Max 10 characters allowed
            </small>
          </div>

        </div>

        <div class="form-group">
          <label for="pwd">Password <span style="color:red;">*</span></label>
            <input type="password" class="form-control" id="pwd" placeholder="Password ..." 
            required aria-describedby="pwdHelp" name="pwd" maxlength="50" minlength="8">
            
            <small id="pwdHelp" class="text-muted">
              Password must be 8 characters long
            </small>
            <div class="invalid-feedback">
              Please provide a valid password.
            </div>
        </div>
        <button type="button" class="btn btn-link btn-sm" onclick="showPwd(this);">Show Password</button>
        <br><br>
        
        <div class="form-group">
          <label for="address">Address <span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="address" placeholder="1234 Main St" 
          required maxlength="300" name="address">
          <div class="invalid-feedback">
            Please provide a valid address.
          </div>
        </div>

        <div class="form-group">
          <label for="contact_no">Contact No. <span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="contact_no" 
          placeholder="Contact number ..." required maxlength="10" 
          minlength="10" name="contact_no" pattern="[1-9][0-9]*">
          <div class="invalid-feedback">
            Please provide a valid contact no.
          </div>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="city">City <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="city" 
            required pattern="[A-z a-z]*" maxlength="100" name="city">
            <div class="invalid-feedback">
              Please provide a valid City Name.
            </div>
          </div>
          

          <div class="form-group col-md-4">
            <label for="state">State <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="state" name="state" 
            required pattern="[A-z a-z]*" maxlength="100">
            <div class="invalid-feedback">
              Please provide a valid State Name.
            </div>
          </div>
        </div>

        <h6>Select Gender <span style="color:red;">*</span> : </h6>
        <div class="form-check form-check-inline">
            <input class="form-check-input" type="radio" name="gender" id="g1" value="Male" required>
            <label class="form-check-label" for="g1" >Male</label>
        </div>

        <div class="form-check form-check-inline">
          <input class="form-check-input" type="radio" name="gender" id="g2" value="Female" required>
          <label class="form-check-label" for="g2">Female</label>
        </div>
        
        <br><br>
        
        <div class="form-group">
    		<label for="institute">Select Institute : </label>
    		<select class="form-control" id="institute" name="institute">
    		<%
        	for(int i=0;i<list.size();i++){
        	%>
      			<option value="<%=list.get(i).getInst_id()%>"><%=list.get(i).getInstituteName()%></option>
      		<%
        	}
			%>
    		</select>
  		</div>
  		<br>
        <div class="text-center">
          <button type="submit" class="btn btn-primary btn-lg" id="submitForm">Submit</button>
        </div>
      </form>
</div>
<%
	}
%>  


</body>
<script src="javascript/script.js"></script>
<script>
//to verify that email not exist
$(document).ready(function() {
	$('#email').on('input',function() {
		$.post("CheckEmail",
			    {
			      email: $('#email').val(),
			      type:"admin"
			    },
			    function(data,status){
			    	if(data == 'novalid' && status == 'success'){
						document.getElementById("alreadyExistEmail").style.display = "";
						document.getElementById("submitForm").setAttribute('disabled','true');
					}else{
						document.getElementById("alreadyExistEmail").style.display = "none";
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
		response.sendRedirect("master_login.jsp");
	}
%>