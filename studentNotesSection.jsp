<%@page import="hide.DataHiding"%>
<%@page import="notes.NotesSubjectBean"%>
<%@page import="notes.NotesDao"%>
<%@page import="notes.SubjectNotesBean"%>
<%@page import="java.util.ArrayList"%>

<%
	if(session.getAttribute("std_id")!=null && request.getParameter("npid") != null){
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<title>EduHITec | Connecting Students and Educator</title>
	<style>
        .card {
            max-width: cover;
            margin-left:30px; 
            margin-right: 20px;
            margin-top: 15px;
    		box-shadow: -5px -5px 13px slategrey;
        }
        body{
            /*background-color:aliceblue*/;
            background-color: #8080800f;
        }
        .card-body{
            float: right;
            height:auto;
            margin-left: 10px;
        }
    </style>
</head>
<link rel="stylesheet" href="css/style.css">
<body onload="getNoteslistStatus();">	
<!-- Notes list is removed by educator So Redirect back to main section-->
<div class="modal fade" id="redirectNoteslistRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	 This Notes list Has been Removed By The User Right Now !!! <br><br>
        	 !!So We Are Redirecting You Back To The Main Section !! Click Okay Button To Redirect 
        </div>
      </div>
      <div class="modal-footer">
        <a type="button" href="studentNoteslist.jsp" class="btn btn-success">Okay</a>
      </div>
    </div>
  </div>
</div>

<!-- Note is removed by educator -->
<div class="modal fade" id="confirmedNoteRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	 This Note Has been Removed By The User Right Now !!! <br><br>
        	 !!Please refresh the Page to See The Updates !!  
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
<a href = "studentNoteslist.jsp" style="margin-left:2%;"><- Return back to Noteslist section</a>

<%
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("npid")));
	NotesSubjectBean bean = new NotesDao().getNoteslist(id);
%>

	<div class="container-fluid">
        <div class="header" style="margin-top: 50px;border-radius: 10px;
    box-shadow: -3px -3px 5px darkgrey;margin-bottom: 94px;padding: 36px;background-color:white;">
            <div class="header-1 text-center">
                <h2 style="white-space:pre-wrap;"><b><i>Topic : <%=bean.getTitle()%></i></b></h2>
            </div>
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <h6>Subject : <%=bean.getSub_name()%></h6>
            </div>
            
            <div class="header-2 text-center" style="margin-top:20px; margin-bottom: 5px;">
            <p style="white-space:pre-wrap;">Description: <%=bean.getDesp()%></p>
            </div>
        </div>
        
       <%
       	ArrayList<SubjectNotesBean> list = new NotesDao().getNoteslistNotes(id);
       
       	if(list.size() == 0){
       	%>
       		<br><br><h5>No Notes Available!!</h5>
       	<%
       	}else{
       %>
        <div class="card mb-5" style="padding: 20px;">
        <%
        	for(int i=0;i<list.size();i++){
        %>
            <div class="row no-gutters">
                    <div class="card-body text-center">
                        <h4 class="card-title" style="white-space:pre-wrap;"><%=list.get(i).getTitle()%></h4>
                        <button onclick="getNoteStatus(`<%=new DataHiding().encodeMethod(""+list.get(i).getNid())%>`,`notes/EduHItec_notes_<%=list.get(i).getNid()%>.<%=list.get(i).getExt()%>`)" type="button" class="btn btn-primary m-1 btn-sm">Open</button>
                    </div>
            </div>
            <hr>
            <%
        	}
            %>
        </div>
       </div>
        <%
       	}
        %>
</body>
<script>
//var set = setInterval(getNoteslistStatus,500);

//to check that notes list exist or not
function getNoteslistStatus(){
	$.post("CheckNoteslistAvailability",
		    {
		      npid : `<%=request.getParameter("npid")%>`
		    },
		    function(data,status){
		    	if(data == "remove" && status == 'success'){
		    		$("#redirectNoteslistRemove").modal("show");
				}
		    	getNoteslistStatus();
		    });
}

//to check that note exist or not
function getNoteStatus(id,url){
	$.post("CheckNotesAvailability",
		    {
		      nid : id
		    },
		    function(data,status){
		    	if(data == "remove" && status == 'success'){
		    			$("#confirmedNoteRemove").modal("show");
				}else if(data == 'notremove' && status == 'success'){
					window.open(url, '_blank');
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