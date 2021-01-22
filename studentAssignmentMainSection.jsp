<%@page import="hide.DataHiding"%>
<%@page import="assignment.AssignmentDao"%>
<%@page import="assignment.UnlockedAssignmentBean"%>
<%@page import="admin.SubjectBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="admin.AdminDao"%>
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
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">

<title>EduHITec | Connecting Students and Educator</title>
<style>
  .assignmentDiv{
    border:1px solid #dadce0;
    padding:1%;
    border-radius: 10px 10px;
    box-shadow: 3px 3px 6px #808080c4;
    color:#737373;
    text-align: center;
  }

  .assignmentDiv:hover{
    background-color:#8080800d;
    cursor:pointer;
  }
</style>
<link rel="stylesheet" href="css/style.css">
</head>
<body>	
<%@include file="student_menu.html"%>
<div class="modal fade" id="assignmentUnlockSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Assignment Unlocked Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- Assignment is removed by educator -->
<div class="modal fade" id="confirmedAssignmentRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	 This Assignment Has been Removed By The User Right Now !!! <br><br>
        	 !!Please refresh the Page to See The Updates !!  
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>



<div class="modal fade" id="notfound" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Assignment Not Found OR The Assignment Deadline Is Over
        </div>
      </div>
      <div class="modal-footer">
         <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- In case if any error occurs -->
<div class="modal fade" id="assignment_error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong try again!!! If Issue persist then try to contact the owner
        </div>
      </div>
      <div class="modal-footer">
        <a href="studentAssignmentMainSection.jsp?active=2" class="btn btn-success">Okay</a>
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
			    $("#assignmentUnlockSuccess").modal("show");   
		});
</script>		
	
<%
	}else if(session.getAttribute("nfd") != null){
		session.removeAttribute("nfd");
%>
	<script>
		$(document).ready(function(){
			    $("#notfound").modal("show");   
		});
	</script>	
<% 	
	}else if(session.getAttribute("error")!=null){
		session.removeAttribute("error");
%>
<script>
	$(document).ready(function(){
		$("#assignment_error").modal("show");
		    
	});
</script>

<%
	}
%>

  <nav>
    <div class="nav nav-tabs nav-fill my-5" id="nav-tab" role="tablist">
      <a class="nav-item nav-link active" id="nav-Myassignment-tab" data-toggle="tab" href="#nav-Myassignment" role="tab" aria-controls="nav-home" aria-selected="true"><b>My Assignments</b></a>
      <a class="nav-item nav-link" id="nav-UnlockAssignment-tab" data-toggle="tab" href="#nav-UnlockAssignment" role="tab" aria-controls="nav-profile" aria-selected="false"><b>Unlock Assignment</b></a>
      
    </div>
  </nav>

<div class="tab-content" id="nav-tabContent">
    <div class="tab-pane fade show active" id="nav-Myassignment" role="tabpanel" aria-labelledby="nav-Myassignment-tab">
      <div class="m-2 p-5 form-group" >
      	<label for="#filterBySubject">Filter By Subjects</label>
      	<select class="form-control" id="filterBySubject" onchange="searchFilter()">
      <%
      		ArrayList<SubjectBean> list = new AdminDao().getAllSubjects((Integer)session.getAttribute("inst_id"));
      		if(list.isEmpty()){
      %>
      	<option disabled>-- No Subjects Found Contact Admin ---</option>
      <%	
      		}else{
      %>
      	<option disabled>--- Select Subject ---</option>
      	<option value="ALL SUBJECTS">ALL SUBJECTS</option>
      <%
      		for(int i=0;i<list.size();i++){
      %>
        <option><%=list.get(i).getSubjectName()%>
        <%
    		if(list.get(i).getCode() != null && list.get(i).getCode().equals("") == false){
    	%>
    		(<%=list.get(i).getCode()%>)
    	<%
    		}
    	%>
        </option>
      <%
      		}
      	}
      %>
      </select>
      </div><br>
      <%
      	ArrayList<UnlockedAssignmentBean> list2 = new AssignmentDao().getUnlockedAssignment((Integer)session.getAttribute("std_id"));
      
      	if(list2.isEmpty()){
      %>
          <h3 align="center">No Assignments Available</h3>
      <% 
      	}else{
      		for(int i=0;i<list2.size();i++){
      %>
<div class="m-5 assignmentDiv p-4" onclick="getAssignmentStatus('<%=new DataHiding().encodeMethod(String.valueOf(list2.get(i).getAsgid()))%>','<%=list2.get(i).getCreatedBy()%>')">
      	<%
      		if(list2.get(i).getCode() != null && list2.get(i).getCode().equals("") == false){
      	%>
          <h6><%=list2.get(i).getSubjectName()%> (<%=list2.get(i).getCode()%>) : <b><%=list2.get(i).getTitle()%>
          </b> posted By <%=list2.get(i).getCreatedBy()%>
          <%
          	if(list2.get(i).getStatus().equalsIgnoreCase("due")){
          %>
          <span style="color:red; margin-left:2%;">Due</span>
          <%
          	}else{
          		if(list2.get(i).getStatus().equalsIgnoreCase("g")){
          	%>
          	<span style="color:green; margin-left:2%;">Submitted And Graded</span>
          	<%
          		}else{
          	%>
          	<span style="color:green; margin-left:2%;">Submitted But Not Graded Yet</span>
          	<%
          		}
          	}
          %>
          </h6>
          <%
      		}else{
      		%>
      		 <h6><%=list2.get(i).getSubjectName()%> : <b><%=list2.get(i).getTitle()%>
          </b> posted By <%=list2.get(i).getCreatedBy()%></h6>
      		<%
      		}
          %>
      	</div>
      <% 
      		}
      	}
      %>
    </div> 
     
     
 <div class="tab-pane fade" id="nav-UnlockAssignment" role="tabpanel" 
    aria-labelledby="nav-UnlockAssignment-tab">
    
    <form class="form-inline" action="UnlockAssignment" method="post">
      <div class="mx-auto">
        <div class="form-group">
           <label for="SecretCode">Enter Secret Code : </label>
           
            <input type="text" id="SecretCode" name="SecretCode" class="form-control mx-sm-3" aria-describedby="SecretCodeHelpInline">
           <small id="SecretCodeHelpInline" class="text-muted">
            Secret Code is given by educator it is Case sensitive
            </small>
        </div>
        <div class="mx-auto m-5">        
          <button type="submit" class="btn btn-primary">Unlock</button>
        </div>
      </div>
      
    </form>
    
  </div>
</div>
</body>
<script>

function searchFilter(){
	let div = document.getElementsByClassName("assignmentDiv");
	let input = document.getElementById("filterBySubject").value.toUpperCase();
	let textValue1,a;
	
	if(input.indexOf("ALL SUBJECTS") > -1){
		for(let i=0;i<div.length;i++){
	          div[i].style.display = "";
		}
	}else{
	for(let i=0;i<div.length;i++){
		a = div[i].getElementsByTagName("h6")[0];
		txtValue1 = a.textContent || a.innerText;
		
		if(txtValue1.toUpperCase().indexOf(input) > -1) {
            div[i].style.display = "";
        } else{
            div[i].style.display = "none";
        }
	}
	}
}

//to check that assignment exist or not
function getAssignmentStatus(id,name){
	$.post("CheckAssignmentAvailability",
		    {
		      asgid : id
		    },
		    function(data,status){
		    	if(data == "remove" && status == 'success'){
		    			$("#confirmedAssignmentRemove").modal("show");
				}else if(data == 'notremove' && status == 'success'){
					window.location.replace("studentAssignmentSubSection.jsp?asgid="+id+"&name="+name);
				}
		    });
}
</script>
<script type="text/javascript" src="javascript/script.js"></script>

</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>