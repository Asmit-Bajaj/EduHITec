<%@page import="hide.DataHiding"%>
<%@page import="notes.NotesDao"%>
<%@page import="notes.NotesSubjectBean"%>

<%@page import="admin.AdminDao"%>
<%@page import="admin.SubjectBean"%>
<%@page import="java.util.ArrayList"%>

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

<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
        .card:hover{
            cursor: pointer;
             box-shadow: 3px 2px 17px #80808075;
        }
</style>
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Connecting Students and Educator</title>
</head>
<body>
<!-- Notes list is removed by educator -->
<div class="modal fade" id="confirmedNoteslistRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	 This Notes list Has been Removed By The User Right Now !!! <br><br>
        	 !!Please Refresh The Page To See The Updates
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<%@include file="student_menu.html"%>
<br>

 	<div class="form-group p-4" >
 		<label for="filterBy">Filter By</label>
 		<select id="filterBy" onchange="filter(this);" class="form-control">
 			<%
 			ArrayList<SubjectBean> sublist = new AdminDao().getAllSubjects((Integer)session.getAttribute("inst_id"));	
 	    	if(sublist.size() == 0){
 	    %>
 	    	<option disabled>No Subjects Available</option>
 	    <%
 	    	}else{
 	    %>
 	    	<option value="All">All Notes lists</option>
 	    <% 
 	    		for(int i=0;i<sublist.size();i++){
 	    %>
 	    	<option value="<%=sublist.get(i).getSubjectName()%>"><%=sublist.get(i).getSubjectName()%>
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
 	</div>
 	<br>
 	<div>
 		<h4 style="margin-left:2%;color:darksalmon">Notes lists</h4><hr>
 	</div>
 	
 	<br>
 	<div style=" margin-right:2%;width:300px !important;
        float:right;">
 		<input class="form-control" id="search" type="text" placeholder="Search By Topic or Subject Name..."
 		 aria-label="Search" onkeyup="searchFilter()">
 	</div><br><br><br>
 	
 	<div class="card-columns" style="margin:3%;">
 	<%
 		ArrayList<NotesSubjectBean> playlistList = new NotesDao().getAllNoteslist((Integer)session.getAttribute("inst_id"));
 	if(playlistList.size() == 0){
 	%>
 		<h4>NO NOTESLIST AVAILABLE</h4>
 	<% 	
 	}else{
 		for(int i=0;i<playlistList.size();i++){	
 	%>
 		<div class="card m-3 text-center" style="border-radius: 10px;" onclick="getNoteslistStatus('<%=new DataHiding().encodeMethod(String.valueOf(playlistList.get(i).getNpid()))%>');">
             <div class="card-header">
   				 <h5 class="card-title" style="white-space:pre-wrap;"><%=playlistList.get(i).getTitle()%></h5>
 		 	</div>
            <div class="card-body">
              
              <h6 class="card-title" style="white-space:pre-wrap;"><%=playlistList.get(i).getSub_name()%></h6>
              <%
    		if(playlistList.get(i).getCode() != null && playlistList.get(i).getCode().equals("") == false){
    	%>
    		<h6 class="card-title"><%=playlistList.get(i).getCode()%></h6>
    	<%
    		}
    	%>
              <p class="card-text" style="white-space:pre-wrap;"><%=playlistList.get(i).getDesp()%></p>
              <p>Created By : <%=playlistList.get(i).getCreatedBy()%></p>
             </div>
              <div class="card-footer text-muted">
    			<p class="card-text"><small class="text-muted">Added on <%=playlistList.get(i).getDatetime()%></small></p>
  			  </div>
          	  
                
        </div>
 	<% 
 		}
 	}
 	%>	
 	</div>
</body>

<script type="text/javascript">
function filter(){
	let card = document.getElementsByClassName("card");
	let input = document.getElementById("filterBy").value.toUpperCase();
	let textValue1,a,b,textValue2;
	
	if(input == "ALL"){
		for(let j=0;j<card.length;j++){
			card[j].style.display = "";
		}
	}else{
		for(let i=0;i<card.length;i++){
			a = card[i].getElementsByTagName("h5")[0];
			b = card[i].getElementsByTagName("h6")[0];
		
			txtValue1 = a.textContent || a.innerText;
			txtValue2 = b.textContent || b.innerText;
		
			if(txtValue1.toUpperCase().indexOf(input) > -1 || txtValue2.toUpperCase().indexOf(input) > -1) {
            	card[i].style.display = "";
        	} 	else{
            	card[i].style.display = "none";
        	}
		}
	}
}

//to check that notes list exist or not
function getNoteslistStatus(id){
	$.post("CheckNoteslistAvailability",
		    {
		      npid : id
		    },
		    function(data,status){
		    	if(data == 'notremove' && status == 'success'){
		    		window.location.replace("studentNotesSection.jsp?npid="+id);
				}else if(data == "remove" && status == 'success'){
		    			$("#confirmedNoteslistRemove").modal("show");
				}
		    });
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
<script type="text/javascript" src="javascript/script.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>