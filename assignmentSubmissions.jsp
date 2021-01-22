<%@page import="hide.DataHiding"%>
<%@page import="assignment.AssignmentDao"%>
<%@page import="assignment.SubmissionBean"%>
<%@page import="java.util.ArrayList"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("asgid") != null){
%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Connecting Students and Educator</title>
</head>
<body>

<div class="modal fade" id="marksAssignSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Assignment Graded Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="marksAssignError" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong from server side try again!!!
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
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
			    $("#marksAssignSuccess").modal("show");   
		});
</script>		

<%
		}else if(session.getAttribute("error") != null){
%>
	<script>
		$(document).ready(function(){
			    $("#marksAssignError").modal("show");   
		});
	</script>	
<% 
			session.removeAttribute("error");
		}
%>

	<%
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("asgid")));
		ArrayList<SubmissionBean>list = new AssignmentDao().getAllSubmissions(id);
	%>
	<br><br>
	
	<br>
	
	<h3 align="center">All Submissions</h3><br><br>
	<%
				if(list.size() == 0){
			%>
			<h3 align="center">No Submissions Available.</h3>
			<%
				}else{
				
			%>
	<div class="table-responsive-xl" style="margin-left:2%;margin-right:2%;overflow: auto;">
		<table class="table table-fluid" id="mytable">
		<thead>
			<tr class="table-tr table-header shadow-sm p-3 round">
				<th class="table-th" scope="col">SNo.</th>
				<th class="table-th" scope="col">Roll.No</th>
				<th class="table-th" scope="col">Full Name</th>
				<th class="table-th" scope="col">Email</th>
				<th class="table-th" scope="col">Branch</th>
			<th class="table-th" scope="col">Class/Standard</th>
			<th class="table-th" scope="col">Section</th>
			<th class="table-th" scope="col">Degree Enrolled In</th>
			<th class="table-th" scope="col">Batch</th>
			<th class="table-th" scope="col">Contact No.</th>
				<th class="table-th" scope="col">Submitted Files</th>
				<th class="table-th" scope="col">Date and Time of Submission.</th>
				<th class="table-th" scope="col">Marks Assigned</th>
				<th class="table-th" scope="col">Max Marks</th>
			</tr>
		</thead>
		
		<tbody>
			<%
				for(int i=0;i<list.size();i++){
			%>
				<tr class="table-tr shadow-sm p-3 mb bg-white round">
					<td class="table-td"><%=i+1%></td>
					<%
				if(list.get(i).getRollno() == null || list.get(i).getRollno().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getRollno()%></td>
			<%
				}
			%>
					
					<td class="table-td"><%=list.get(i).getName()%></td>
					<td class="table-td"><%=list.get(i).getEmail()%></td>
					<%
				if(list.get(i).getBranch() == null || list.get(i).getBranch().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getBranch()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getStd_class() == null || list.get(i).getStd_class().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getStd_class()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getSection() == null || list.get(i).getSection().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getSection()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getDegree() == null || list.get(i).getDegree().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getDegree()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getBatch() == null || list.get(i).getBatch().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getBatch()%></td>
			<%
				}
			%>
			<td class="table-td"><%=list.get(i).getContact_no()%></td>
					<td class="table-td" style="display:block;">
						<%
							for(int j=0;j<list.get(i).getNo_of_files();j++){
						%>
						<a href="assignSubmission/EduHITec_submission_<%=list.get(i).getStd_id()%><%=list.get(i).getAsgid()%><%=j+1%>.<%=list.get(i).getExtensions()[j]%>" target="_blank" style="text-decoration: none;"><%=list.get(i).getOrgnames()[j]%></a>
						<br>		
						<% 
							}
						%>
					</td>
					<td class="table-td"><%=list.get(i).getDatetime()%></td>
					<%
						if(list.get(i).getMarks() == -1){
					%>
						<td class="table-td">
						<button type="button" class="btn btn-primary m-1 btn-sm text-center" style="height:50px !important"
						onclick="AltMarksModalShow(`<%=list.get(i).getAsgid()%>`,`<%=list.get(i).getStd_id()%>`)">Grade Assignment</button>
						</td>
					<% 
						}else{
					%>
						<td class="table-td"><%=list.get(i).getMarks()%></td>
					<% 	
						}
					%>
					<td class="table-td"><%=list.get(i).getMaxMarks()%></td>
				</tr>
			<%
				}
				
			%>
		
			</tbody>
		</table>
	</div>
	<%
				}
	%>
	
	<%
		if(session.getAttribute("noValidGrade") != null){
			session.removeAttribute("noValidGrade");
			int std_id = ((SubmissionBean)session.getAttribute("bean")).getStd_id();
	%>
<form action="GradeAssignment" class="was-validated" 
id="gradeAssignmentForm" method="post" enctype="multipart/form-data" novalidate>
	<div class="modal fade" id="AltMarksModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
        	
        		<div class="form-group">
    			<label for="altmarks">Assign Marks <span style="color:red">*</span></label>
    			<%
    				if(list.size() != 0){
    			%>
    			<input type="number" class="form-control" id="altmarks" name="altmarks" required min="1" max=<%=list.get(0).getMaxMarks()%>>
    			<% 
    				}
    			%>
    			<div class="invalid-feedback">
    				Please Fill this field
    			</div>
  				</div>
  				
  				<div class="form-group">
    			<label for="feedback">Provide Some Feedback</label>
    			<textarea class="form-control" id="feedback" name="feedback" rows="2" value=""></textarea>
  				</div>
  				
  				<div class="form-group">
    				<label for="returnFilesConfirm">Do you want to return the checked files to the student?</label>
    				<select class="form-control" id="returnFilesConfirm" name="returnFilesConfirm" onchange="returnFilesFunc(this);">
      				<option value="0">No</option>
      				<option value="1">Yes</option>
    				</select>
  				</div>
 
 				<div class="form-group" id="returnFilesDiv" style="display:none;">
    				<label for="returnFiles">Choose Files <span style="color:red;">*</span></label>
    				<input type="file" class="form-control-file" id="returnFiles" name="returnFiles" multiple>
    				<div class="invalid-feedback">
    				Select Some Files
    				</div>
  				</div>
  				
  				<input type="hidden" name="stdId" id="stdId" value="<%=std_id%>">
  				<input type="hidden" name="asgId" id="asgId" value="<%=id%>">
        	
        </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">Assign Marks</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
<script>
		$(document).ready(function(){
			    $("#AltMarksModal").modal("show");   
		});
</script>

<%
		}else{
%>
<form action="GradeAssignment" class="needs-validation" 
id="gradeAssignmentForm" method="post" enctype="multipart/form-data" novalidate>
	<div class="modal fade" id="AltMarksModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" 
	aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
        	
        		<div class="form-group">
    			<label for="altmarks">Assign Marks <span style="color:red">*</span></label>
    			<%
    				if(list.size() != 0){
    			%>
    			<input type="number" class="form-control" id="altmarks" name="altmarks" required min="1" max=<%=list.get(0).getMaxMarks()%>>
    			<% 
    				}
    			%>
    			<div class="invalid-feedback">
    				Please Fill this field
    			</div>
  				</div>
  				
  				<div class="form-group">
    			<label for="feedback">Provide Some Feedback</label>
    			<textarea class="form-control" id="feedback" name="feedback" rows="2" value=""></textarea>
  				</div>
  				
  				<div class="form-group">
    				<label for="returnFilesConfirm">Do you want to return the checked files to the student?</label>
    				<select class="form-control" id="returnFilesConfirm" name="returnFilesConfirm" onchange="returnFilesFunc(this);">
      				<option value="0">No</option>
      				<option value="1">Yes</option>
    				</select>
  				</div>
 
 				<div class="form-group" id="returnFilesDiv" style="display:none;">
    				<label for="returnFiles">Choose Files <span style="color:red;">*</span></label>
    				<input type="file" class="form-control-file" id="returnFiles" name="returnFiles" multiple>
    				<div class="invalid-feedback">
    					Select Some Files
    				</div>
  				</div>
  				
  				<input type="hidden" name="stdId" id="stdId" value="">
  				<input type="hidden" name="asgId" id="asgId" value="<%=id%>">
        	
        </div>
      </div>
      <div class="modal-footer">
        <button type="submit" class="btn btn-primary">Assign Marks</button>
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>
</form>
<%
		}
%>


<div class="modal fade" id="spinnerMove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel"
 aria-hidden="true" data-keyboard="false" data-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-body">
              <div>
                <div class="progress">
                    <div class="progress-bar progress-bar-striped bg-primary progress-bar-animated" role="progressbar" style="width: 100%" aria-valuenow="100" aria-valuemin="0" aria-valuemax="100"></div>
                  </div><br>
                  <div align="center">
                  Uploading Files .... <br>
                  Please be Patient It will Take Some Time To Upload Depending On The Size Of Files<br>
                  Please Do Not Refresh The Page or Stop Loading 
                </div>
            </div>
            
          </div>
        </div>
      </div>
</div>

</body>
<script>
function showSpinner(ele){
	if(ele.checkValidity()){
		$("#spinnerMove").modal("show");
	}
}

$(document).ready(function () {
    $('#mytable').DataTable();
    $('.dataTables_length').addClass('bs-select');
}); 
</script>
<script src="javascript/script.js"></script>
<script type="text/javascript" src="javascript/script.js"></script>
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>