<%@page import="livestream.LivestreamDao"%>
<%@page import="livestream.UserBean"%>
<%@page import="hide.DataHiding"%>
<%@page import="quiz.MainQuizBean"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.QuizMainListBean"%>
<%@page import="java.util.ArrayList"%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("qzid") != null){
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
<body>
<%@include file="student_menu.html"%>

	<%
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
		ArrayList<UserBean> list = new LivestreamDao().getConnectedUsers(id);
	%>
	<br>
	
	<a href="educatorQuizSubSection1.jsp?qzid=<%=request.getParameter("qzid")%>" style="margin:2%"><- Return Back</a>
	
	<div class="text-center" style="margin-top:5%">
    <%
    	if(list.size() == 0){
    %>
    	<div style="color:#0808c3a8;">
           <h4>No Active Users Yet</h4>
        </div>
    <% 
    	}else{
    		for(int i=0;i<list.size();i++){
    %>
    	<div class="quizheading" 
    	onclick="window.location.replace('livestream2.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getQuizid()))%>&std_id=<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getStd_id()))%>')">
            <h4><%=list.get(i).getName()%></h4>
        </div>
    <% 
    		}
    	}
    %>
    </div>
</body>
<script>
//to check that Quiz exist or not
function getQuizStatus(qzid,std_id) {
	$.post("CheckUserExist", {
		quizid : qzid,
		std_id: std_id
	}, function(data, status) {
		if (data == "remove" && status == 'success') {
			$("#confirmedQuizRemove").modal("show");
		} else if (data == 'notremove' && status == 'success') {
			//window.location.replace("livestream2.jsp?qzid=" + id+);
		}
	});
}

//var set = setInterval(getQuizlistStatus,500);
//to check that quiz list exist or not
function getQuizlistStatus() {
	$.post("CheckQuizMainlistAvailability", {
		qmid : `<%=request.getParameter("qmid")%>`
	}, function(data, status) {
		if (data == "remove" && status == 'success') {
			$("#redirectQuizlistRemove").modal("show");
		} 
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