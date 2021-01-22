<%@page import="hide.DataHiding"%>
<%@page import="quiz.MainQuizBean"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.QuizMainListBean"%>
<%@page import="java.util.ArrayList"%>

<%
	if(session.getAttribute("std_id")!=null && request.getParameter("qmid")!=null){
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

<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Connecting Students and Educator</title>
</head>
<body onload="getQuizlistStatus();">
<%@include file="student_menu.html"%>
<!-- Quiz is removed by educator -->
	<div class="modal fade" id="confirmedQuizRemove" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
		data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body text-center">
					<div>
						This Quiz Has been Removed By The User Right Now !!! <br> <br>
						!!Please refresh the Page to See The Updates !!
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- Quiz list is removed by educator So Redirect back to main section-->
<div class="modal fade" id="redirectQuizlistRemove" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body text-center">
        <div>
        	 This Quiz list Has been Removed By The User Right Now !!! <br><br>
        	 !!So We Are Redirecting You Back To The Main Section !! Click Okay Button To Redirect 
        </div>
      </div>
      <div class="modal-footer">
        <a type="button" href="studentQuizMainSection.jsp" class="btn btn-success">Okay</a>
      </div>
    </div>
  </div>
</div>


	<%
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qmid")));
		ArrayList<MainQuizBean> list = new quizDao().getAllQuizofCurrentList(id, 2);
	%>
	<br>
	
	<a href="studentQuizMainSection.jsp" style="margin:2%"><- Return Back</a>
	<div class="text-center" style="margin-top:5%">
    <%
    	if(list.size() == 0){
    %>
    	<div style="color:#0808c3a8;">
           <h4>No Public Quizzes Available in This List</h4>
        </div>
    <% 
    	}else{
    		for(int i=0;i<list.size();i++){
    %>
    	<div class="quizheading" onclick="getQuizStatus('<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getQuizid()))%>')">
            <h4><%=list.get(i).getTitle()%></h4>
        </div>
    <% 
    		}
    	}
    %>
    </div>
</body>
<script>
//to check that Quiz exist or not
function getQuizStatus(id) {
	$.post("CheckQuizAvailability", {
		quizid : id
	}, function(data, status) {
		if (data == "remove" && status == 'success') {
			$("#confirmedQuizRemove").modal("show");
		} else if (data == 'notremove' && status == 'success') {
			window.location.replace("studentQuizSubSection2.jsp?qzid=" + id);
		}
	});
}

//to check that quiz list exist or not
function getQuizlistStatus() {
	$.post("CheckQuizMainlistAvailability", {
		qmid : `<%=request.getParameter("qmid")%>`
	}, function(data, status) {
		if (data == "remove" && status == 'success') {
			$("#redirectQuizlistRemove").modal("show");
		}
		getQuizlistStatus();
	});
}
</script>
<script src="javascript/script.js"></script>
</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>