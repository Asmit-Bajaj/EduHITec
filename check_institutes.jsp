<%@page import="master.MasterDao"%>
<%@page import="master.InstituteBean"%>
<%@page import="java.util.ArrayList"%>
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
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<title>EduHITec | Connecting Students and Educator</title>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- Modal for successful removal of institute -->
<div class="modal fade" id="instituteRemoveSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Institute Removed Successfully !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal for successful updation of info of institute -->
<div class="modal fade" id="instituteUpdateSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Information Updated Successfully !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Cannot remove Institute as logged in -->
<div class="modal fade" id="LoggedInRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Cannot Remove Institute Right Now As Some Users Are Logged In !!! <br><br>Click Okay Button to close dialog!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>


<!-- Modal for server error -->
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
		session.removeAttribute("success");
%>
		<script>
		$(document).ready(function(){
		    $("#instituteRemoveSuccess").modal("show");	    
	});
		</script>
<%
	}else if(session.getAttribute("error") != null){
		session.removeAttribute("error");
%>
<script>
		$(document).ready(function(){
		    $("#Error").modal("show");	    
	});
		</script>
<%
	}else if(session.getAttribute("logEduRemove") != null){
		session.removeAttribute("logEduRemove");
%>
<script>
		$(document).ready(function(){
		    $("#LoggedInRemove").modal("show");	    
	});
		</script>
<%
	}else if(session.getAttribute("update") != null){
		session.removeAttribute("update");
%>
	<script>
	$(document).ready(function(){
		$("#instituteUpdateSuccess").modal("show"); 
	});
		
	</script>
<% 
	}
%>
<%
	ArrayList<InstituteBean> list = new MasterDao().getAllInstitutes();
%>

<!-- Displaying the list of all the educators -->
<%@include file="master_menu.html"%><br><br>
<br>

	<%
		if(list.size() == 0){
	%>
	
	<h3 align="center">No Institute Available</h3>
	<%
		}else{
	%>
	
	<h3 align="center">List Of All The Institutes</h3><br><br>

	<div class="table-responsive-xl" style="margin-left:2%;margin-right:2%;">
	<table class="table table-fluid" id="mytable">
		<thead>
		<tr class="table-tr table-header shadow-sm p-3 round">
			<th class="table-th" scope="col">SNo.</th>
			<th class="table-th" scope="col">Institute Id.</th>
			<th class="table-th" scope="col">Full Name</th>
			<th class="table-th" scope="col">Code</th>
			<th class="table-th" scope="col">Address</th>
			<th class="table-th" scope="col">Contact No.</th>
			<th class="table-th" scope="col">City</th>
			<th class="table-th" scope="col">State</th>
			<th class="table-th" scope="col">Type</th>
			<th class="table-th" scope="col">Actions</th>
		</tr>
		</thead>
		
		<tbody id="educatorTable">
		<%
			for(int i=0;i<list.size();i++){
		%>
		<tr class="table-tr shadow-sm p-3 mb bg-white round">
			<td class="table-td"><%=i+1%></td>
			<td class="table-td"><%=list.get(i).getInst_id()%></td>
			<td class="table-td"><%=list.get(i).getInstituteName()%></td>
			<%
				if(list.get(i).getCode() == null || list.get(i).getCode().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getCode()%></td>
			<%
				}
			%>
			
			<td class="table-td"><%=list.get(i).getAddress()%></td>
			<td class="table-td"><%=list.get(i).getContact_no()%></td>
			<td class="table-td"><%=list.get(i).getCity()%></td>
			<td class="table-td"><%=list.get(i).getState()%></td>
			<td class="table-td"><%=list.get(i).getType()%></td>
			<td class="table-td"><button type="button" class="btn btn-primary btn-sm m-1" style="height:35px !important" 
			  onclick="getStatus(<%=list.get(i).getInst_id()%>,<%=i+1%>);">Remove</button>
			 <button type="button" class="btn btn-primary btn-sm m-1" style="height:50px !important" 
			  onclick="setEditValues('<%=list.get(i).getInstituteName()%>','<%=list.get(i).getCode()%>','<%=list.get(i).getAddress()%>','<%=list.get(i).getCity()%>','<%=list.get(i).getState()%>','<%=list.get(i).getContact_no()%>','<%=list.get(i).getInst_id()%>');">Edit Info</button>
			
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
<form action="RemoveInstitute" method="post">
<div class="modal fade" id="confirm<%=i+1%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to remove <span><%=list.get(i).getInstituteName()%></span> ?
        </div>
        <br>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        	<input type="hidden" name="id" value="<%=list.get(i).getInst_id()%>">
        	<input type="submit" class="btn btn-primary" value="Yes"> 
      </div>
    </div>
  </div>
</div>
 </form>
<%
		}
%>

<form class="needs-validation" novalidate action="EditInstitute" method="post">
<div class="modal fade" id="editInfoModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br><br>

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
	</div>
      <div class="modal-footer">
      <input type="hidden" name="inst_id" id="inst_id">
      <button class="btn btn-primary" type="submit" id="submitForm">Save Changes</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
        
</form>
</body>
<script>
$(document).ready(function () {
    $('#mytable').DataTable();
    $('.dataTables_length').addClass('bs-select');
}); 


function setEditValues(name,code,address,city,state,contact_no,id){
	document.getElementById("name").value = name;
	if(code != "null")
		document.getElementById("code").value = code;
	else
		document.getElementById("code").value = "";
	document.getElementById("city").value = city;
	document.getElementById("address").value = address;
	document.getElementById("state").value = state;
	document.getElementById("contact_no").value = contact_no;
	document.getElementById("inst_id").value = id;
	$("#editInfoModal").modal("show");
}

//clear the form on hide for add videos
$('#editInfoModal').on('hide.bs.modal',function () {
	document.forms[0].className="needs-validation";
	document.getElementById("alreadyExistName").style.display = "none";
	document.getElementById("submitForm").removeAttribute('disabled');
	document.forms[0].reset();
})

function getStatus(id,i_id){
		$.post("LoggedIn",
			    {
			      inst_id : id
			    },
			    function(data,status){
			    	if(data == 'loggedOut' && status == 'success'){
			    			$("#confirm"+i_id).modal("show");
					}else if(data == "loggedIn" && status == 'success'){
			    			$("#LoggedInRemove").modal("show");
					}
			    });
}

//to verify that email not exist
$(document).ready(function() {
	$('#name').on('input',function() {
		$.post("CheckInstituteName",
			    {
			      name: $('#name').val()
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
<script type="text/javascript" src="javascript/script.js"></script>
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>

</html>

<%
	}else{
		response.sendRedirect("master_login.jsp");
	}
%>