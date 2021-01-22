<%@page import="hide.DataHiding"%>
<%@page import="admin.SubjectBean"%>
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
<div class="modal fade" id="subjectRemoveSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Subject Removed Successfully !!! 
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="editSubjectSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Subject edited successfully!!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<!-- Modal for login status -->
<div class="modal fade" id="instituteLock" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	Cannot Remove This Subject Right Now As Some Students/Educators Are Logged In Right Now<br>
        	Removing Subject Will Cause Alot Of Inconvenience
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="subjectRemoveError" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
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
	if(session.getAttribute("success")!=null){
		
		if(session.getAttribute("success").equals("1")){
%>
		<script>
		$(document).ready(function(){
		    $("#subjectRemoveSuccess").modal("show");	    
	});
		</script>
<%
		}else if(session.getAttribute("success").equals("2")){
%>
<script>
		$(document).ready(function(){
		    $("#editSubjectSuccess").modal("show");	    
	});
		</script>
<%
		}
		session.removeAttribute("success");
	}else if(session.getAttribute("error")!=null){
		session.removeAttribute("error");
%>
	<script>
		$(document).ready(function(){
		    $("#subjectRemoveError").modal("show");	    
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
<% 
	ArrayList<SubjectBean> list = new AdminDao().getAllSubjects(new AdminDao().
			inst_id((Integer)session.getAttribute("admin_id")));
%>

<!-- Displaying the list of all the subjects -->
<%@include file="admin_menu.html"%><br><br>
<br>

	<%
		if(list.size() == 0){
	%>
	
	<h3 align="center">No Subjects Available</h3>
	<%
		}else{
	%>
	<h3 align="center">List Of All The Subjects</h3><br><br>
	<div class="table-responsive-xl" style="margin-left:2%;margin-right:2%;">
	<table class="table table-fluid" id="mytable">
		<thead>
			<tr class="table-tr table-header shadow-sm p-3 round">
				<th class="table-th" scope="col">SNo. </th>
				<th class="table-th" scope="col">Subject Name</th>
				<th class="table-th" scope="col">Subject Code</th>
				<th class="table-th" scope="col">Subject Session</th>
				<th class="table-th" scope="col">Subject Course</th>
				<th class="table-th" scope="col">Operations</th>
			</tr>
		</thead>
		
		<tbody id="subjectTable">
		<%
			for(int i=0;i<list.size();i++){
		%>
		<tr class="table-tr shadow-sm p-3 mb bg-white round">
			<td class="table-td"><%=i+1%></td>
			<td class="table-td"><%=list.get(i).getSubjectName()%></td>
			<%
				if(list.get(i).getCode()==null ||list.get(i).getCode().equals("")){
			%>
			<td class="table-td">-- NA --</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getCode()%></td>
			<%
				}
			%>
			<%
				if(list.get(i).getSession()==null ||list.get(i).getSession().equals("")){
			%>
			<td class="table-td">-- NA --</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getSession()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getCourse()==null ||list.get(i).getCourse().equals("")){
			%>
			<td class="table-td">-- NA --</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getCourse()%></td>
			<%
				}
			%>
			<td  class="table-td"><button type="button" class="btn btn-primary btn-sm m-1" style="height:35px !important"
			 onclick="getStatus(<%=i+1%>)">Remove</button>
			 <button type="button" class="btn btn-primary btn-sm m-1" style="height:35px !important"
			 onclick="showEditSubjectModal('<%=list.get(i).getSubjectName()%>','<%=list.get(i).getSession()%>','<%=list.get(i).getCourse()%>','<%=list.get(i).getCode()%>','<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getSub_id()))%>');">Edit</button></td>
			 
		</tr>
<%
			}
		%>
		</tbody>
	</table>
	</div>
	<br><br>
	<%
		}
	%>
	
	<%
		for(int i=0;i<list.size();i++){
	%>
<div class="modal fade" id="confirm<%=i+1%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to remove <span><%=list.get(i).getSubjectName()%> subject</span> ?
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        <form action="RemoveSubject" method="post">
        	<input type="hidden" name="id" value=<%=list.get(i).getSub_id()%>>
        	<button class="btn btn-primary" type="submit">Yes</button>
        </form>
      </div>
    </div>
  </div>
</div>
	
	<%
		}
	%>



<%
	if(session.getAttribute("no_validSub") != null){
		SubjectBean bean = (SubjectBean)session.getAttribute("no_validSub");
		session.removeAttribute("no_validSub");
		
%>
<form action="EditSubject" method="post">
<div class="modal fade" id="editSubjectModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
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
              <label for="subjectSession">Enter Session (if any) <span style="color: red;">*</span></label>
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
          <input type="hidden" name="id" id="id" value="<%=new DataHiding().encodeMethod(String.valueOf(bean.getSub_id()))%>">
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button class="btn btn-primary" type="submit" id="submitForm">Save Changes</button>	
      </div>
    </div>
  </div>
</div>
</form>

<%
	}else{
%>
<form action="EditSubject" method="post">
<div class="modal fade" id="editSubjectModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div class="form-row">
            <div class="form-group col-md-6">
              <label for="subjectName">Enter Subject Name <span style="color: red;">*</span></label>
              <input type="text" class="form-control" id="subjectName" name="subjectName" 
              placeholder="subject name ..." pattern="[A-Z a-z]*" required maxlength="200"
               value="">
              
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
          
          <br>
          
          <div class="form-row">
            <div class="form-group col-md-6">
              <label for="subjectSession">Enter Session (if any) <span style="color: red;">*</span></label>
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
          <input type="hidden" name="id" id="id" value="">
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">Cancel</button>
        <button class="btn btn-primary" type="submit" id="submitForm">Save Changes</button>	
      </div>
    </div>
  </div>
</div>
</form>
<%
	}
%>
</body>
<script>
$(document).ready(function () {
    $('#mytable').DataTable();
    $('.dataTables_length').addClass('bs-select');
}); 

//check educator and student status
function getStatus(i_id){
	$.post("CheckInstituteLoggedIn",
		    function(data,status){
		    	if(data == 'loggedOut' && status == 'success'){
		    		$("#confirm"+i_id).modal("show");
				}else if(data == "loggedIn" && status == 'success'){
					$("#instituteLock").modal("show");
				}
		    });
}

function showEditSubjectModal(name,session,course,code,id) {
	$("#editSubjectModal").modal("show");
	document.forms[0].className="needs-validation";
	document.forms[0].reset();
	document.getElementById("subjectName").value=name;
	document.getElementById("code").value=code;
	document.getElementById("subjectSession").value=session;
	document.getElementById("course").value=course;
	document.getElementById("id").value=id;
	document.getElementById("alreadyExistName").style.display = "none";
}

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