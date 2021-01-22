<%@page import="hide.DataHiding"%>
<%@page import="videos.VideoDao"%>
<%@page import="admin.AdminDao"%>
<%@page import="admin.SubjectBean"%>
<%@page import="quiz.QuizMainListBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="quiz.quizDao"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null){
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="css/style.css">
<style>
		.card{
			 box-shadow: 3px 2px 17px #80808075;
		}
		a:hover {
			text-decoration: none;
		}
</style>

<title>EduHITec | Connecting Students and Educator</title>
</head>
<body>
<%@include file="educator_menu.html"%>
<br>
<br>
 	<div style="margin-right:4%;">
 		<a style="font-size:20px;color:#3aafc1db;float:right;"
 		 href="#" onclick="showAddQuizMainListModal();">
 		 <i class="fa fa-plus" style="font-size:20px;color:#3aafc1db;"></i> ADD A NEW QUIZ LIST</a>
 	</div>
 	<br><br>
 	<h4 style="margin-left:2%;color:darksalmon">My Quiz lists<hr></h4><br>
 		<div style=" margin-right:2%;width:300px !important;
        float:right;">
 		<input class="form-control" id="search" type="text" placeholder="Search By Topic or Subject Name..."
 		 aria-label="Search" onkeyup="searchFilter()">
 	</div><br><br><br>
 	
 	
 	
 	<div class="card-columns" style="margin:3%;">
 	<%
 		ArrayList<QuizMainListBean> mainList = new quizDao().
 		getAllQuizMainListOfCurrentEducator((Integer)session.getAttribute("edu_id"));
 	 	if(mainList.size() == 0){
 	%>
 		<h4>NO QUIZZES LIST AVAILABLE</h4>
 	<% 	
 	}else{
 		for(int i=0;i<mainList.size();i++){	
 	%>
 		<div class="card border-light mb-3" style="border-radius: 10px;">
            <div class="card-body">
              <h5 class="card-title" style="white-space:pre-wrap;"><%=mainList.get(i).getTitle()%></h5>
              <h6 class="card-title" style="white-space:pre-wrap;"><%=mainList.get(i).getSubjectName()%>
              <%
              	if(mainList.get(i).getSubCode() != null && mainList.get(i).getSubCode().equals("") == false){
              %>
<span><%=mainList.get(i).getSubCode()%></span>
              <% 
              	}
              %>
              </h6>
          <p class="card-text" style="white-space:pre-wrap;"><%=mainList.get(i).getDesp()%></p>
              <button type="button" class="btn edit btn-primary m-1" onclick="triggerEditQuizlistModal(`<%=mainList.get(i).getTitle()%>`,`<%=mainList.get(i).getDesp()%>`,<%=mainList.get(i).getQmid()%>)">Edit</button>
              <button type="button" class="btn delete btn-primary m-1" onclick="triggerDeleteQuizlistModal(<%=mainList.get(i).getQmid()%>);">Delete</button>
              <button type="button" class="btn delete btn-primary m-1" onclick="redirectToQuizzes('<%=new DataHiding().encodeMethod
                  (String.valueOf(mainList.get(i).getQmid()))%>');">Open Quizzes</button>
            </div>    
        </div>
 	<% 
 		}
 	}
 	%>	
 	</div>
 	
 	 <%
 		if(session.getAttribute("noValidAdd") != null){
 			session.removeAttribute("noValidAdd");
 			QuizMainListBean bean = (QuizMainListBean)session.getAttribute("bean");
 			session.removeAttribute("bean");
 	%>
 <form action="AddQuizMainList" method="post" class="was-validated" novalidate>	
<div class="modal fade" id="addQuizMainlistModal" tabindex="-1" role="dialog" 
aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
     
    <%
    	ArrayList<SubjectBean> sublist = new AdminDao().getAllSubjects(new VideoDao().getInstId((Integer)session.getAttribute("edu_id")));	
    	if(sublist.size() == 0){
    %>
    	<h3>No Subjects Available Yet!! Please contact the admin to add subject</h3>
    <%
    	}else{
    
    %>

<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br>
  <div class="form-group">
    <label for="selectTopic">Select Subject <span style="color:red;">*</span></label>
    <select class="form-control" id="selectSubject" name="selectSubject" required>
    <%
    		if(bean.getSub_id() != -1){
    	%>
    	<option value="" disabled>-- Select Subject ---</option>
    	<%
    		}else{
    	%>
    	<option value="" disabled selected>-- Select Subject ---</option>
    	<%
    		}
    	%>
     <%
    	for(int i=0;i<sublist.size();i++){
    		if(bean.getSub_id() == sublist.get(i).getSub_id()){
    %>
    <option value=<%=sublist.get(i).getSub_id()%> selected><%=sublist.get(i).getSubjectName()%> 
    
    	<%
    		if(sublist.get(i).getCode() != null && sublist.get(i).getCode().equals("") == false){
    	%>
    		(<%=sublist.get(i).getCode()%>)
    	<%
    		}
    	%>
    	</option>
    <% 			
    		}else{
    %>
    	<option value=<%=sublist.get(i).getSub_id()%>><%=sublist.get(i).getSubjectName()%> 
    	<%
    		if(sublist.get(i).getCode() != null && sublist.get(i).getCode().equals("") == false){
    	%>
    		(<%=sublist.get(i).getCode()%>)
    	<%
    		}
    	%>
    	</option>
    	
    <%
    		}
    	}
    %>
    </select>
    <div class="invalid-feedback">
         Please Select a Subject.
    </div>
  </div>
  
  <div class="form-group">
    <label for="title">Enter Title for Notes List <span style="color:red;">*</span></label>
    <%
    	if(bean.getTitle().isEmpty() ==false){
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"><%=bean.getTitle()%></textarea>
    <%

    	}else{
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
    <%
    	}
    %>
    
    <div class="invalid-feedback">
         Please provide a title.
    </div>
    
  </div>
  
   <div class="form-group">
    <label for="desp">Enter Some description about this list <span style="color:red;">*</span></label>
    <%
    	if(bean.getDesp().isEmpty() == false){
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ><%=bean.getDesp()%></textarea>
    
    <%
    	}else{
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ></textarea>
    <%
    	}
    %>
    <div class="invalid-feedback">
         Please provide a description.
    </div>
    
  </div>

<%
    	}
%>
  </div>
      <div class="modal-footer">
      <%
      	if(sublist.size() > 0){
      %>
      <button class="btn btn-primary" type="submit">AddQuizList</button>
      <%
      	}
      %>
         <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
 
</div>
 </form>
 <script>
		$(document).ready(function(){
			    $("#addQuizMainlistModal").modal("show");   
		});
	</script>
 <%
 		}else{
 %>
<form class="needs-validation" novalidate action="AddQuizMainList" method="post">	
<div class="modal fade" id="addQuizMainlistModal" tabindex="-1" role="dialog" 
aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
     
    <%
    	ArrayList<SubjectBean> sublist = new AdminDao().getAllSubjects(new VideoDao().getInstId((Integer)session.getAttribute("edu_id")));	
    	if(sublist.size() == 0){
    %>
    	<h3>No Subjects Available Yet!! Please contact the admin to add subject</h3>
    <%
    	}else{
    
    %>

<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br>
  <div class="form-group">
    <label for="selectSubject">Select Subject <span style="color:red;">*</span></label>
    <select class="form-control" id="selectSubject" name="selectSubject" required>
    	<option value="" disabled selected>-- Select Subject ---</option>
    <%
    	for(int i=0;i<sublist.size();i++){
    %>
    	<option value=<%=sublist.get(i).getSub_id()%>><%=sublist.get(i).getSubjectName()%> 
    	<%
    		if(sublist.get(i).getCode() != null && sublist.get(i).getCode().equals("") == false){
    	%>
    		(<%=sublist.get(i).getCode()%>)
    	<%
    		}
    	%>
    	</option>
    <% 			
    		
    	}
    %>
    </select>
    <div class="invalid-feedback">
         Please Select a Subject.
    </div>
  </div>
  
  <div class="form-group">
    <label for="title">Enter Title of list <span style="color:red;">*</span></label>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
    <div class="invalid-feedback">
         Please provide a title.
    </div>
  </div>
  
   <div class="form-group">
    <label for="desp">Enter Some description about this list <span style="color:red;">*</span></label>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200"></textarea>
    <div class="invalid-feedback">
         Please provide a description.
    </div>
  </div>

<%
    	}
%>
  </div>
      <div class="modal-footer">
      <%
      	if(sublist.size() > 0){
      %>
      <button class="btn btn-primary" type="submit">AddQuizList</button>
      <%
      	}
      %>
         <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
 
</div>
 </form>
 <%
 		}
 %>

<div class="modal fade" id="addquizlist_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Quiz list added Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="editquizlist_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Quiz list edited Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="deletequizlist_success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Quiz list removed Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="quizlist_error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong at server side !! if problem persist then try to contact the owner
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
		if(session.getAttribute("success").equals("1")){
%>
<script>
		$(document).ready(function(){
			    $("#addquizlist_success").modal("show");   
		});
</script>		

<%
		}else if(session.getAttribute("success").equals("2")){
%>
	<script>
		$(document).ready(function(){
			    $("#editquizlist_success").modal("show");   
		});
	</script>	
<% 
		}else{
%>
	<script>
		$(document).ready(function(){
			    $("#deletequizlist_success").modal("show");   
		});
	</script>	
<% 	
			
		}
		session.removeAttribute("success");
	}else if(session.getAttribute("error")!=null){
%>
<script>
	$(document).ready(function(){
		$("#quizlist_error").modal("show");
		    
	});
</script>

<%
		session.removeAttribute("error");
	}
%>

<%
	if(session.getAttribute("noValidEdit") != null){
		session.removeAttribute("noValidEdit");
		QuizMainListBean bean = (QuizMainListBean)session.getAttribute("bean");
		session.removeAttribute("bean");
%>
<form action="EditQuizMainList" method="post" class="was-validated" novalidate>
<div class="modal fade" id="editQuizlistModal" tabindex="-1" 
role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br><br>

  <div class="form-group">
    <label for="title">Title/Topic *</label>
    <%
    	if(bean.getTitle().isEmpty() ==false){
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"><%=bean.getTitle()%></textarea>
    <%

    	}else{
    %>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
    <%
    	}
    %>
    
    <div class="invalid-feedback">
         Please provide a title.
    </div>
  </div>
  
  <div class="form-group">
    <label for="desp">Description about this list *</label>
    <%
    	if(bean.getDesp().isEmpty() == false){
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ><%=bean.getDesp()%></textarea>
    
    <%
    	}else{
    %>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlength="200" ></textarea>
    <%
    	}
    %>
    
    <div class="invalid-feedback">
         Please provide a description.
    </div>
  </div>
  
  <input type="hidden" name="Eqmid" id="Eqmid" value="<%=bean.getQmid()%>">
 
  </div>
      <div class="modal-footer">
      <button class="btn btn-primary" type="submit">Save Changes</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
</form>
<script>
	$(document).ready(function(){
		$("#editQuizlistModal").modal("show");
		    
	});
</script>
<%
	}else{
%>
<form class="needs-validation" novalidate action="EditQuizMainList" method="post">
<div class="modal fade" id="editQuizlistModal" tabindex="-1" 
role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-body">
<small class="form-text text-muted">Note: All the mandatory fields are marked by *</small><br><br>

  <div class="form-group">
    <label for="title">Title/Topic <span style="color:red;">*</span></label>
    <textarea class="form-control" id="title" name="title" rows="2" required maxlenght="200"></textarea>
    <div class="invalid-feedback">
         Please provide a title.
    </div>
  </div>
  
   <div class="form-group">
    <label for="desp">Description about this list <span style="color:red;">*</span></label>
    <textarea class="form-control" id="desp" name="desp" rows="5" required maxlenght="200"></textarea>
    <div class="invalid-feedback">
         Please provide a description.
    </div>
  </div>
  
  <input type="hidden" name="Eqmid" id="Eqmid" value="">
 
  </div>
      <div class="modal-footer">
      <button class="btn btn-primary" type="submit">Save Changes</button>
       <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
      </div>
    </div>
  </div>
</div>
</form>

<%
	}
%>

<form action="DeleteQuizMainList" method="post">
<div class="modal fade" id="deleteQuizlistModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to delete this list ?
        		<input type="hidden" name="Dqmid" id="Dqmid" value="">
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        <button class="btn btn-primary" type="submit">Yes</button>
      </div>
    </div>
  </div>
</div>
</form>

</body>
<script type="text/javascript">

function showAddQuizMainListModal() {
	$("#addQuizMainlistModal").modal("show");
}


function redirectToQuizzes(id){
	window.location.replace("educatorQuizSection.jsp?qmid="+id);
}

function searchFilter(){
	let card = document.getElementsByClassName("card");
	let input = document.getElementById("search").value.toUpperCase();
	let textValue1,a,b,textValue2;
	
	for(let i=0;i<card.length;i++){
		a = card[i].getElementsByTagName("h5")[0];
		b = card[i].getElementsByTagName("h6")[0];
		
		txtValue1 = a.textContent || a.innerText;
		txtValue2 = b.textContent || b.innerText;
		
		if(txtValue1.toUpperCase().indexOf(input) > -1 || txtValue2.toUpperCase().indexOf(input) > -1) {
            card[i].style.display = "";
        } else{
            card[i].style.display = "none";
        }
	}
}

</script>
<script src="javascript/script.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>