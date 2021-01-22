
<%@page import="student.StudentDao"%>
<%@page import="student.StudentProfileBean"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("std_id")!=null){
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
<title>EduHITec | My Profile</title>
<link href="css/style.css" rel="stylesheet">
</head>
<body>
<%
	StudentProfileBean bean = new StudentDao().getProfile((Integer)session.getAttribute("std_id"));
%>
<!-- Modal for error during updation of educator info -->
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
	if(session.getAttribute("error") != null){
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

<%@include file="educator_menu.html"%>
 <h4 style="margin:3%;" align="center">Edit The Following Form and Click on Save Changes to Save All Info :- <hr></h4>
    
    <h6 style="margin-left:3%;">Note : Mandatory fields are marked by 
        <span style="color:red;">*</span>
    </h6>
    
<%
	if(session.getAttribute("no_validStd") != null){
		session.removeAttribute("no_validStd");
%>
<script>
	alert("Please Enter Correct Value In Each Field");
</script>
<%
	}
%>
<div class="educator-form-box">
    
    <form class="needs-validation" novalidate action="UpdateStudentDetails" method="post">
    	<div class="form-group">
          <label for="name">Full Name <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="name"  pattern="[A-Z a-z]*"
            required aria-describedby="nameHelp" name="name" maxlength="120" minlength="1" value="<%=bean.getName()%>">
            
            <small id="nameHelp" class="text-muted">
              Must be 1-120 characters long.
            </small>
            <div class="invalid-feedback">
              Please provide a valid Name.
            </div>
        </div>
        
        

        <div class="form-row">
          <div class="form-group col-md-6">
            <label for="contact_no">Contact No. <span style="color:red;">*</span></label>
          	<input type="text" class="form-control" id="contact_no" required maxlength="10" 
          	minlength="10" name="contact_no" pattern="[1-9][0-9]*" value="<%=bean.getContact_no()%>">
          	<div class="invalid-feedback">
           	 Please provide a valid contact no.
          	</div>
          </div>
		
			<%
				if(bean.getRoll_no() == null){
			%>
          <div class="form-group col-md-6">
            <label for="roll_no">Roll Number (If exist)</label>
            <input type="text" class="form-control" id="roll_no" value=""
            placeholder="Roll no ..." maxlength="15" name="roll_no" aria-describedby="roll_noHelp">
            <small id="roll_noHelp" class="text-muted">
              Max 15 characters allowed
            </small>
          </div>
          
          <%
				}else{
		%>
				<div class="form-group col-md-6">
            <label for="roll_no">Roll Number (If exist)</label>
            <input type="text" class="form-control" id="roll_no" value="<%=bean.getRoll_no()%>"
            placeholder="Roll no ..." maxlength="15" name="roll_no" aria-describedby="roll_noHelp">
            <small id="roll_noHelp" class="text-muted">
              Max 15 characters allowed
            </small>
          </div>
		<%
				}
          %>

        </div>

        
        <div class="form-group">
          <label for="address">Address <span style="color:red;">*</span></label>
          <input type="text" class="form-control" id="address" placeholder="1234 Main St" 
          required maxlength="300" name="address" value="<%=bean.getAddress()%>">
          <div class="invalid-feedback">
            Please provide a valid address.
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
        
        
        <div class="form-row">
        <%
        	if(bean.getBranch() != null){
        %>
            <div class="form-group col-md-4">
              <label for="branch">Branch(If any)</label>
              <input type="text" class="form-control" id="branch" placeholder="Branch ..." name="branch"
              pattern="[A-Z a-z]*" maxlength="100" aria-describedby="branchHelp" value="<%=bean.getBranch()%>">
              <small id="branchHelp" class="text-muted">
                Can be 100 characters long.
              </small>
            </div>
          <%
        	}else{
        %>
        	<div class="form-group col-md-4">
              <label for="branch">Branch(If any)</label>
              <input type="text" class="form-control" id="branch" placeholder="Branch ..." name="branch"
              pattern="[A-Z a-z]*" maxlength="100" aria-describedby="branchHelp" value="">
              <small id="branchHelp" class="text-muted">
                Can be 100 characters long.
              </small>
            </div>
        <%
        	}
          %>
          
          <%
          	if(bean.getSection() != null){
          %>
            <div class="form-group col-md-4">
              <label for="section">Section(If any)</label>
              <input type="text" class="form-control" id="section" placeholder="Section ..." name="section"
               maxlength="50" aria-describedby="sectionHelp" value="<%=bean.getSection()%>">
              <small id="sectionHelp" class="text-muted">
                Can be 50 characters long.
              </small>
            </div>
	
		<%
          	}else{
         %>
         <div class="form-group col-md-4">
              <label for="section">Section(If any)</label>
              <input type="text" class="form-control" id="section" placeholder="Section ..." name="section"
               maxlength="50" aria-describedby="sectionHelp" value="">
              <small id="sectionHelp" class="text-muted">
                Can be 50 characters long.
              </small>
            </div>
         <%
          	}
		%>
		
		<%
			if(bean.getDegree() != null){
		%>
            <div class="form-group col-md-4">
              <label for="degree">Degree Enrolled In (In case of University Or College)</label>
              <input type="text" class="form-control" id="degree" placeholder="Degree ...." 
              name="degree" value="<%=bean.getDegree()%>" maxlength="200" pattern="[A-Z a-z]*">
              <small id="degreeHelp" class="text-muted">
                Max 200 characters allowed.
              </small>
            </div>
           <%
			}else{
			%>
			<div class="form-group col-md-4">
              <label for="degree">Degree Enrolled In (In case of University Or College)</label>
              <input type="text" class="form-control" id="degree" placeholder="Degree ...." 
              name="degree" value="" maxlength="200" pattern="[A-Z a-z]*">
              <small id="degreeHelp" class="text-muted">
                Max 200 characters allowed.
              </small>
            </div>
			<%
			}
           %>
            
        </div>
        
       <div class="form-row">
       <%
       	if(bean.getStd_class() != null){
       %>
        	<div class="form-group col-md-4">
            	<label for="std_class">Standard/Class (In Case of Schools)</label>
            	<input type="text" class="form-control" id="std_class" name="std_class" 
             	maxlength="50" value="<%=bean.getStd_class()%>" placeholder="Standard/Class ... ">
         	</div>
         	
        <%
       	}else{
       	%>
       	<div class="form-group col-md-4">
            	<label for="std_class">Standard/Class (In Case of Schools)</label>
            	<input type="text" class="form-control" id="std_class" name="std_class" 
             	maxlength="50" value="" placeholder="Standard/Class ... ">
         	</div>
       	<%
       	}
        %>
         	<%
         		if(bean.getBatch() != null){
         	%>
         	<div class="form-group col-md-4">
            	<label for="batch">Batch (If Any)</label>
            	<input type="text" class="form-control" id="batch" name="batch" 
             	maxlength="50" value="<%=bean.getBatch()%>" placeholder="Batch ... ">
         	</div>
         <%
         		}else{
         %>
         <div class="form-group col-md-4">
            	<label for="batch">Batch (If Any)</label>
            	<input type="text" class="form-control" id="batch" name="batch" 
             	maxlength="50" value="" placeholder="Batch ... ">
         	</div>
         <%
         		}
         %>
         	
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
        <div class="text-center">
          <button type="submit" class="btn btn-primary btn-lg">Save Changes</button>
        </div>
      </form>
</div>



</body>
<script src="javascript/script.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>