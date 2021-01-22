<%@page import="hide.DataHiding"%>
<%@page import="quiz.QuizReviewBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.MainQuizBean"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("std_id")!=null && request.getParameter("qzid")!=null){
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
<body onload="getQuizStatus();">
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
					<a type="button" href="studentQuizMainSection.jsp" class="btn btn-success">Okay</a>
				</div>
			</div>
		</div>
	</div>
	
<%@include file="student_menu.html"%>
	<%
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
	
		MainQuizBean bean = new quizDao().getQuiz(id);
		int validity = new quizDao().getQuizValidityForStudent(id);
		int atp = new quizDao().getAttempts((Integer)session.getAttribute("std_id"), id);
		ArrayList<QuizReviewBean> list = new quizDao().getMyAttempts((Integer)session.getAttribute("std_id"), id);
	%>
	
	<div style="margin-top:2%;margin-left:2%;">
		<a href="studentQuizMainSection.jsp"><- Return Back</a>
	</div>
	
	<div style="margin:4%;border:1px solid #8080803b;border-radius: 10px;">
      <div class="text-center" style="margin-top:1%;margin-bottom:2%;padding:2%;color:#000080">
        <h3><%=bean.getTitle()%></h3>
        <%
        	if(bean.getCode() != null){
        %>
        <h6>Secret Code : <%=bean.getCode()%></h6>  	
        <%
        	}
      
        if(bean.isTimeline()){
        		if(bean.getFrom() != null){
        %>
        <div style="margin-top: 5%;">This quiz is scheduled on <%=bean.getFrom()%></div>
        <% 
        		}	
        		if(bean.getTo() != null){
        			
        %>
        <div style="margin-top: 1%;">Available till <%=bean.getTo()%></div>
        	
        <% 		}
        	}
        %>
        
        
        <div style="margin-top: 1%;">General Instructions:
        <br><%=bean.getInst()%></div>
        
        <%
        	if(bean.getTimer() == 1){
        %>
        <div style="margin-top: 1%;">Time limit : <%=bean.getOveralltimer()%> mins</div>
        <% 
        	}else if(bean.getTimer() == 2){
        %>
        <div style="margin-top: 1%;">Time limit : Timer for each question</div>
        <%
        	}
        %>
        
        <%
        	if(bean.getAttempts() != -1){
        %>
        <div style="margin-top: 1%;">No of attempts allowed : <%=bean.getAttempts()%></div>
        <div style="margin-top: 1%;">Attempts Remaining: <%=bean.getAttempts() - atp%></div>
        <%
        	}
        %>
             
        <%
        	if(bean.getTimer() == 2 && validity==1 && (bean.getAttempts() == -1 || (bean.getAttempts() != -1 && atp < bean.getAttempts()))){
        		
        %>
        <br>
        <a class="btn btn-outline-primary m-1" href="studentQuizSubSection3Attempt1.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>&cam=<%=bean.isWebcam()%>">
        Attempt Quiz Now</a>
       <%
        	}else if(validity == 1 && (bean.getAttempts() == -1 || (bean.getAttempts() != -1 && atp < bean.getAttempts()))){
        %>
        <br>
        <a class="btn btn-outline-primary m-1" href="studentQuizSubSection3Attempt2.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>&cam=<%=bean.isWebcam()%>">
        Attempt Quiz Now</a>
        <%
        	}else{
        %>
        	<br>
        	<h5>This quiz is not available</h5>
        	<h5>Either you have crossed the attempts limit OR this quiz has passed its Time-line</h5><br>
        	<button type="button" class="btn btn-outline-primary m-1" onclick="window.location.replace('studentQuizMainSection.jsp')">Go Back to Main Section</button>
        <%
        	}
       %>
        
      </div>
    </div>
    
    <div style="margin:3%">
		<h3>Your Attempts Reviews</h3>
		<hr> 
    </div>
    
<div class="table-responsive-xl" style="margin-left:2%;margin-right:2%;overflow: auto;">
		<table class="table">
			<thead>
				<tr class="table-tr table-header shadow-sm p-3 round">
					<th class="table-th" scope="col">Attempt.No</th>
					<th class="table-th" scope="col">Date</th>
					<th class="table-th" scope="col">Marks</th>
					<th class="table-th" scope="col">Review</th>
				</tr>
			</thead>
		
		<tbody>
		<%
			for(int i=0;i<list.size();i++){
		%>
		<tr class="table-tr shadow-sm p-3 mb bg-white round">
			<td class="table-td"><%=i+1%></td>
			<td class="table-td"><%=list.get(i).getDate()%></td>
			<td class="table-td"><%=list.get(i).getObt_marks()%> out of <%=list.get(i).getTotal_marks()%>.0</td>
			<td class="table-td"><button type="button" class="btn btn-sm btn-primary" 
			onclick="window.open('studentQuizReview.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getQuizid()))%>&rvid=<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getReview_id()))%>')">Review</button></td>
		</tr>
<%
			}
		%>
		</tbody>
	</table>
</div>	
    
    
</body>
<script>
//to check that Quiz exist or not
function getQuizStatus(id) {
	$.post("CheckQuizAvailability", {
		quizid : `<%=request.getParameter("qzid")%>`
	}, function(data, status) {
		if (data == "remove" && status == 'success') {
			$("#confirmedQuizRemove").modal("show");
		}
		getQuizStatus();
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