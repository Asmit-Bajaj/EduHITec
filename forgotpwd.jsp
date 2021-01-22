<%@page import="miscellaneous.CheckForgotPwdLinkExist"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
<title>EduHITec | Forgot Password</title>
</head>

<body>

<!-- Modal for successful updation of password -->
<div class="modal fade" id="success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Your Password Updated Successfully !!!!
        </div>
      </div>
    </div>
  </div>
</div>



<!-- error at server-->
<div class="modal fade" id="error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something Went Wrong At Server !! Contact Owner If Problem Persist
        </div>
      </div>
    </div>
  </div>
</div>

<!-- Link Expired Or Not Valid -->
<div class="modal fade" id="nfd" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	This Link Is Not Valid Or Expired !!!!
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-success" onclick="window.close();">Okay</button>
      </div>
    </div>
  </div>
</div>


	<%
		if(request.getParameter("id") != null && request.getParameter("upid") != null && request.getParameter("role") != null){
			boolean flag = new CheckForgotPwdLinkExist().checkLink("http://localhost:8081/EduHITec/forgotpwd.jsp?role="+request.getParameter("role")+
					"&upid="+request.getParameter("upid")+"&id="+request.getParameter("id"));
			
			if(flag == false){
	%>
		<script>
			$("#nfd").modal("show");
		</script>
	<%
			}else{
				if(session.getAttribute("novalid") != null){
				session.removeAttribute("novalid");
	%>
		<script>
			alert("Please Do Not Surpass the Validations");
		</script>
	<%
			}
	%>
<form action="UpdateForgotPwd" method="post" class="needs-validation" novalidate>
			<div class="modal fade" id="forgotPwdModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
			aria-hidden="true" data-keyboard="false" data-backdrop="static">
  	<div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Fill All the Details
<br>Note: All the mandatory fields are marked by *</small><br><br>

   <div class="form-group">
          <label for="pwd">Enter New Password <span style="color:red;">*</span></label>
            <input type="password" class="form-control" id="pwd" placeholder="Password ..." 
            required aria-describedby="pwdHelp" name="pwd" maxlength="50" minlength="8" value="">
            
            <small id="pwdHelp" class="text-muted">
              Password must be 8 characters long
            </small>
            
            <div class="invalid-feedback">
              Please provide a valid password.
            </div>
    </div>
	
	<input type="hidden" name="upid" value="<%=request.getParameter("upid")%>">
	<input type="hidden" name="id" value="<%=request.getParameter("id")%>">
	<input type="hidden" name="role" value="<%=request.getParameter("role")%>">
	
  </div>
      <div class="modal-footer">
      <button class="btn btn-primary" type="submit">Submit</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
</form>

<script>
	$("#forgotPwdModal").modal("show");
</script>
		
	<%		
			}
		}else{
			if(session.getAttribute("success") != null){
				session.removeAttribute("success");
	%>
		<script>
		
			    $("#success").modal("show");
		    
		
		</script>	
	<%
			}else if(session.getAttribute("error") != null){
				session.removeAttribute("error");
	%>
		<script>
			    $("#error").modal("show");
		    
		</script>		
	<%	
			}else{
				response.sendRedirect("index.jsp");
			}
		}
	%>
</body>
<script src="javascript/script.js"></script>
</html>
