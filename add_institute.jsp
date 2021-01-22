
<%@page import="master.InstituteBean"%>
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
<title>EduHITec | Add Institute</title>
<link href="css/style.css" rel="stylesheet">
</head>
<body>

<!-- Modal for successful addition of Institute -->
<div class="modal fade" id="institueAddSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Institute Added Successfully !!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<!-- Modal for error during addition of Institute -->
<div class="modal fade" id="instituteAddError" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
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
			    $("#institueAddSuccess").modal("show");
		    
		});
	</script>	
<%
	}else if(session.getAttribute("error") != null){
%>
<script>
		$(document).ready(function(){
			    $("#institueAddError").modal("show");
		    
		});
	</script>
<%
		session.removeAttribute("error");
	}
%>

<%@include file="master_menu.html"%>
 <h4 style="margin:3%;" align="center">Fill Up The Following Details of Institute :- <hr></h4>
    
    <h6 style="margin-left:3%;">Note : Mandatory fields are marked by 
        <span style="color:red;">*</span>
    </h6>
    
<%
	if(session.getAttribute("no_validIns") != null){
		InstituteBean bean = (InstituteBean)session.getAttribute("no_validIns");
		session.removeAttribute("no_validIns");
		
%>
	<div class="educator-form-box">
    
    <form class="was-validated" novalidate action="AddInstitute" method="post">
        <div class="form-group">
          <label for="name">Institute Name <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="name" placeholder="Name ..." 
            required aria-describedby="pwdHelp" name="name" maxlength="1000" value="<%=bean.getInstituteName()%>">
            
            <div class="invalid-feedback">
              Please provide a valid name.
            </div>
            
            <div id="alreadyExistName" style="display: none;
    		width: 100%;margin-top: .25rem;font-size: 80%;color: #dc3545;">
    		This Name already Exist
    		</div>
            
        </div>
		
		<div class="form-group">
          <label for="code">Institute Code (If Any) </label>
            <input type="text" class="form-control" id="code" placeholder="Code ..." 
           aria-describedby="codeHelp" name="code" maxlength="50" value="<%=bean.getCode()%>">
            
            <div class="invalid-feedback">
              Please provide a valid code.
            </div>
            
        </div>
       
        <div class="form-group">
          <label for="address">Address <span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="address" placeholder="1234 Main St" 
          required maxlength="5000" name="address" value="<%=bean.getAddress()%>">
          <div class="invalid-feedback">
            Please provide a valid address.
          </div>
        </div>

        <div class="form-group">
          <label for="contact_no">Contact No.<span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="contact_no" 
          placeholder="Contact number ..." required maxlength="20" 
          name="contact_no" pattern="[0-9][0-9]*" value="<%=bean.getContact_no()%>">
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
            required pattern="[A-z a-z]*" maxlength="200" value="<%=bean.getState()%>">
            <div class="invalid-feedback">
              Please provide a valid State Name.
            </div>
          </div>
        </div>

        <fieldset class="form-group">
    <div class="row">
      <legend class="col-form-label col-sm-2 pt-0">Select Type Of Institute : </legend>
      <div class="col-sm-10">
        <div class="form-check">
          <input class="form-check-input" type="radio" name="type" id="gridRadios1" value="university" checked>
          <label class="form-check-label" for="gridRadios1">
            University
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="type" id="gridRadios2" value="college">
          <label class="form-check-label" for="gridRadios2">
            College
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="type" id="gridRadios3" value="school">
          <label class="form-check-label" for="gridRadios3">
            School
          </label>
        </div>
        
        <div class="form-check">
          <input class="form-check-input" type="radio" name="type" id="gridRadios4" value="coaching">
          <label class="form-check-label" for="gridRadios4">
            Coaching
          </label>
        </div>
        
      </div>
    </div>
  </fieldset>
        
        <br><br>
        <div class="text-center">
          <button type="submit" class="btn btn-primary btn-lg" id="submitForm">Submit</button>
        </div>
      </form>
</div>
<%
	}else{
%>

<div class="educator-form-box">
    
    <form class="needs-validation" novalidate action="AddInstitute" method="post">
        <div class="form-group">
          <label for="name">Institute Name <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="name" placeholder="Name ..." 
            required aria-describedby="pwdHelp" name="name" maxlength="1000" value="">
            
            <div class="invalid-feedback">
              Please provide a valid name.
            </div>
            
             <div id="alreadyExistName" style="display: none;
    		width: 100%;margin-top: .25rem;font-size: 80%;color: #dc3545;">
    		This Name already Exist
    		</div>
    		
        </div>
		
		<div class="form-group">
          <label for="code">Institute Code (If Any) </label>
            <input type="text" class="form-control" id="code" placeholder="Code ..." 
            aria-describedby="codeHelp" name="code" maxlength="50" value="">
            
            <div class="invalid-feedback">
              Please provide a valid code.
            </div>
            
        </div>
       
        <div class="form-group">
          <label for="address">Address <span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="address" placeholder="1234 Main St" 
          required maxlength="5000" name="address" value="">
          <div class="invalid-feedback">
            Please provide a valid address.
          </div>
        </div>

        <div class="form-group">
          <label for="contact_no">Contact No.<span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="contact_no" 
          placeholder="Contact number ..." required maxlength="20" 
          name="contact_no" pattern="[0-9][0-9]*" value="">
          <div class="invalid-feedback">
            Please provide a valid contact no.
          </div>
        </div>

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="city">City <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="city" 
            required pattern="[A-z a-z]*" maxlength="100" name="city" value="">
            <div class="invalid-feedback">
              Please provide a valid City Name.
            </div>
         	</div>
          

          <div class="form-group col-md-4">
            <label for="state">State <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="state" name="state" 
            required pattern="[A-z a-z]*" maxlength="200" value="">
            <div class="invalid-feedback">
              Please provide a valid State Name.
            </div>
          </div>
        </div>

        <fieldset class="form-group">
    <div class="row">
      <legend class="col-form-label col-sm-2 pt-0">Select Type Of Institute : </legend>
      <div class="col-sm-10">
        <div class="form-check">
          <input class="form-check-input" type="radio" name="type" id="gridRadios1" value="university" checked>
          <label class="form-check-label" for="gridRadios1">
            University
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="type" id="gridRadios2" value="college">
          <label class="form-check-label" for="gridRadios2">
            College
          </label>
        </div>
        <div class="form-check">
          <input class="form-check-input" type="radio" name="type" id="gridRadios3" value="school">
          <label class="form-check-label" for="gridRadios3">
            School
          </label>
        </div>
        
        <div class="form-check">
          <input class="form-check-input" type="radio" name="type" id="gridRadios4" value="coaching">
          <label class="form-check-label" for="gridRadios4">
            Coaching
          </label>
        </div>
        
      </div>
    </div>
  </fieldset>
        
        <br><br>
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
	$('#name').on('input',function() {
		$.post("CheckInstituteName",
			    {
			      name: $('#name').val(),
			    },
			    function(data,status){
			    	if(data == 'novalid' && status == 'success'){
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
		response.sendRedirect("master_login.jsp");
	}
%>