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

<link rel="stylesheet" href="css/style.css">
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
<title>EduHITec | Connecting Students and Educator</title>
</head>
<body>
	<div class="marksDiv">
		<h3 align="center">You have been Disqualified You lose one Attempt<i class='fas fa-dizzy' style='font-size:48px;color:#f44336;'></i></h3>
		 <a href="studentQuizMainSection.jsp" style="color:blue;">Click here to Go Back</a>
	</div>
</body>
</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>