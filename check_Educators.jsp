<%@page import="admin.EducatorBean"%>
<%@page import="admin.AdminDao"%>

<%@page import="java.util.ArrayList"%>
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
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<title>EduHITec | Connecting Students and Educator</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<%
	if(session.getAttribute("exist1") !=null){
		session.removeAttribute("exist1");
%>

	<script>
		alert("This Email Already Exist In The System Please Use A Different Email Address");
	</script>
	
<%
	}else if(session.getAttribute("exist2") != null){
		session.removeAttribute("exist2");
%>

	<script>
		alert("This Email Is Already in Active State");
	</script>
	
<%
	}else if(session.getAttribute("no_valid") != null){
		session.removeAttribute("no_valid");
%>
	<script>
		alert("Please Provide A Valid Email");
	</script>
	
<%
	}
%>

<!-- Modal for successful removal of Educator -->
<div class="modal fade" id="educatorRemoveSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Educator Removed Successfully !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Cannot remove Educator as logged in -->
<div class="modal fade" id="educatorLoggedInRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Cannot Remove Educator Right Now As Educator Is Logged In !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Cannot deactivate Educator as logged in -->
<div class="modal fade" id="educatorLoggedInDeact" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Cannot Deactivate Educator Right Now As Educator Is Logged In !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal for successful deactivation of Educator -->
<div class="modal fade" id="educatorDeactivateSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Account Deactivated Successfully !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal for successful reactivation of Educator -->
<div class="modal fade" id="educatorActivateSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Account Activated Successfully !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal for successful updation of email of Educator -->
<div class="modal fade" id="educatorUpdateEmailSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Email Updated Successfully !!! <br><br>A Validation Link is sent on the email <br>
        	Please make sure to validate email within 10 days !! <br>
        	Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>



<!-- Modal for server error while adding educator -->
<div class="modal fade" id="Error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
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
	
if(session.getAttribute("success")!=null){
	if(session.getAttribute("success").equals("1")){
		session.removeAttribute("success");
%>
		<script>
		$(document).ready(function(){
		    $("#educatorRemoveSuccess").modal("show");	    
	});
		</script>
<%
		}else if(session.getAttribute("success").equals("2")){
			session.removeAttribute("success");
%>

		<script>
		$(document).ready(function(){
		    $("#educatorDeactivateSuccess").modal("show");	    
	});
		</script>
<%
		}else if(session.getAttribute("success").equals("3")){
			session.removeAttribute("success");
%>
<script>
		$(document).ready(function(){
		    $("#educatorActivateSuccess").modal("show");	    
	});
		</script>
<%
		}else if(session.getAttribute("success").equals("4")){
			session.removeAttribute("success");
%>
<script>
		$(document).ready(function(){
		    $("#educatorUpdateEmailSuccess").modal("show");	    
	});
		</script>
<%
		}
	}else if(session.getAttribute("error") != null){
		session.removeAttribute("error");
%>
<script>
		$(document).ready(function(){
		    $("#Error").modal("show");	    
	});
		</script>
<%
	}else if(session.getAttribute("logEduDeact") != null){
	session.removeAttribute("logEduDeact");
%>
<script>
		$(document).ready(function(){
		    $("#educatorLoggedInDeact").modal("show");	    
	});
		</script>
<%
	}else if(session.getAttribute("logEduRemove") != null){
		session.removeAttribute("logEduRemove");
%>
<script>
		$(document).ready(function(){
		    $("#educatorLoggedInRemove").modal("show");	    
	});
		</script>
<%
	}
%>
<%
	ArrayList<EducatorBean> list = new admin.AdminDao().getAllEducators(new AdminDao().inst_id((Integer)session.getAttribute("admin_id")));
%>

<!-- Displaying the list of all the educators -->
<%@include file="admin_menu.html"%><br><br>
<br>

	<%
		if(list.size() == 0){
	%>
	
	<h3 align="center">No Educator Available</h3>
	<%
		}else{
	%>
	
	<h3 align="center">List Of All The Educators</h3><br><br>

	<div class="table-responsive-xl" style="margin-left:2%;margin-right:2%;">
	<table class="table table-fluid" id="mytable">
		<thead>
		<tr class="table-tr table-header shadow-sm p-3 round">
			<th class="table-th" scope="col">SNo.</th>
			<th class="table-th" scope="col">Full Name</th>
			<th class="table-th" scope="col">Email</th>
			<th class="table-th" scope="col">Employee Id</th>
			<th class="table-th" scope="col">Address</th>
			<th class="table-th" scope="col">Contact No.</th>
			<th class="table-th" scope="col">Status</th>
			<th class="table-th" scope="col">City</th>
			<th class="table-th" scope="col">State</th>
			<th class="table-th" scope="col">Gender</th>
			<th class="table-th" scope="col">Actions</th>
		</tr>
		</thead>
		
		<tbody id="educatorTable">
		<%
			for(int i=0;i<list.size();i++){
		%>
		<tr class="table-tr shadow-sm p-3 mb bg-white round">
			<td class="table-td"><%=i+1%></td>
			<td class="table-td"><%=list.get(i).getName()%></td>
			<td class="table-td"><%=list.get(i).getEmail()%></td>
			<%
				if(list.get(i).getEmp_id() == null || list.get(i).getEmp_id().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getEmp_id()%></td>
			<%
				}
			%>
			
			<td class="table-td"><%=list.get(i).getAddress()%></td>
			<td class="table-td"><%=list.get(i).getContact_no()%></td>
			<%
				if(list.get(i).isStatus()){
			%>
			<td class="table-td" style="color: #0fa20f;
    font-weight: bold;">Active</td>
			<%
				}else{
			%>
			<td class="table-td" style="color: #ff0000cf;
    font-weight: bold;">Deactivated</td>
			<%	
				}
			%>
			<td class="table-td"><%=list.get(i).getCity()%></td>
			<td class="table-td"><%=list.get(i).getState()%></td>
			<td class="table-td"><%=list.get(i).getGender()%></td>
			<td class="table-td"><button type="button" class="btn btn-primary btn-sm m-1" style="height:35px !important" 
			  onclick="getStatus(<%=list.get(i).getEdu_id()%>,`rm`,<%=i+1%>);">Remove</button>
			 <%
			 	if(list.get(i).isStatus() == false){
			 %>
			 <button type="button" class="btn btn-primary btn-sm m-1" style="height: 50px !important;
    width: 92px !important;" data-toggle="modal"
			 data-target="#activate<%=i+1%>">Re-activate</button>
			 <%
			 	}else{
			 %>
			 	<button type="button" class="btn btn-primary btn-sm m-1" style="height:50px !important" 
			 	onclick="getStatus(<%=list.get(i).getEdu_id()%>,'deact',<%=i+1%>);">Deactivate Account</button>
			 <%
			 	}
			 
			 if(list.get(i).isValidate_email() == false){
			%>
			<button type="button" class="btn btn-primary btn-sm m-1" style="height:50px !important" data-toggle="modal"
			 data-target="#updateEmail<%=i+1%>">Update Email</button>
			<%
			 }
			 %>
			 
			 </td>
		</tr>
<%
			}
		%>
		</tbody>
	</table>
	</div>
	<br><br><br>
	<%
		}
	%>
	
	<%
		for(int i=0;i<list.size();i++){
	%>
<form action="RemoveEducator" method="post">
<div class="modal fade" id="confirm<%=i+1%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to remove <span><%=list.get(i).getName()%></span> ?
        </div>
        <br>
        <div class="form-check">
    	<input type="checkbox" class="form-check-input" 
    	id="removeContent<%=i+1%>" name="removeContent" onchange="showWarning(`<%=i+1%>`);" value="yes">
    		<label class="form-check-label" for="removeContent<%=i+1%>">Remove All The Content</label>
  		</div>
  		<div>
  			<span style="display: none;color:red;font-size: 13px" id="warn<%=i+1%>">This Will Remove All The Content Created By This Educator
  			and It Cannot Be Recovered Back</span>
  		</div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        	<input type="hidden" name="id" value="<%=list.get(i).getEdu_id()%>">
        	<input type="submit" class="btn btn-primary" value="Yes"> 
      </div>
    </div>
  </div>
</div>
 </form>
<%
	if(list.get(i).isStatus()){
%>
<div class="modal fade" id="deactivate<%=i+1%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to Deactivate <span><%=list.get(i).getName()%></span> ?
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        <form action="DeactivateEducator" method="post">
        	<input type="hidden" name="id" value="<%=list.get(i).getEdu_id()%>">
        	<input type="submit" class="btn btn-primary" value="Yes">
        </form>
      </div>
    </div>
  </div>
</div>
<%
	}else{
%>
<div class="modal fade" id="activate<%=i+1%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to Activate <span><%=list.get(i).getName()%></span> ?
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        <form action="ReActivateEducator" method="post">
        	<input type="hidden" name="id" value="<%=list.get(i).getEdu_id()%>">
        	<input type="submit" class="btn btn-primary" value="Yes">
        </form>
      </div>
    </div>
  </div>
</div>

	<%
	}

	if(list.get(i).isValidate_email() == false){
%>
<div class="modal fade" id="updateEmail<%=i+1%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
    <form class="needs-validation" novalidate action="UpdateEmailEducator" method="post">
      <div class="modal-body">
        <div>
        	<div class="form-group">
    			<label for="email">Enter New Email Address</label>
    			<input type="email" class="form-control" id="email" name="email" placeholder="Email ..." required>
    			<div class="invalid-feedback">
                Please provide a valid email address.
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
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">Close</button>
        	<input type="hidden" name="id" id="id" value="<%=list.get(i).getEdu_id()%>">
        	<input type="submit" class="btn btn-primary" value="Submit" id="submitEmail">
      </div>
      </form>
    </div>
    
  </div>
</div>
<%
	}
}
	%>
</body>

<script>

$(document).ready(function () {
    $('#mytable').DataTable();
    $('.dataTables_length').addClass('bs-select');
}); 

//to verify that email not exist
$(document).ready(function() {
	$('#email').on('input',function() {
		$.post("CheckEmailEducator",
			    {
			      email: $('#email').val(),
			      edu_id : $("#id").val()
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

function showWarning(id){
	if(document.getElementById("removeContent"+id).checked){
		document.getElementById("warn"+id).style.display = "";
	}else{
		document.getElementById("warn"+id).style.display = "none";
	}
}

function getStatus(id,modalId,i_id){
		$.post("CheckEducatorLoggenIn",
			    {
			      edu_id : id
			    },
			    function(data,status){
			    	if(data == 'loggedOut' && status == 'success'){
			    		if(modalId == 'rm')
			    			$("#confirm"+i_id).modal("show");
			    		else
			    			$("#deactivate"+i_id).modal("show");
					}else if(data == "loggedIn" && status == 'success'){
						if(modalId == 'rm')
			    			$("#educatorLoggedInRemove").modal("show");
			    		else
			    			$("#educatorLoggedInDeact").modal("show");
					}
			    });
}
</script>
<script type="text/javascript" src="javascript/script.js"></script>
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>

</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>