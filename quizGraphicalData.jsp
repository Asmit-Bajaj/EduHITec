<%@page import="hide.DataHiding"%>
<%@page import="javax.xml.crypto.Data"%>
<%@page import="quiz.GraphicalData"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.StatsBean"%>
<%@page import="java.util.ArrayList"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("qzid")!=null){
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Connecting Students and Educator</title>
</head>
<body>
	<h3 align="center" style="margin-top:2%">Graphical Data showing percentage of accurate answer out of 100%</h3>
<%
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
	ArrayList<GraphicalData> list = new quizDao().getGraphicalData(id);
%>

<%
	for(int i=1;i<=list.size();i++){
%>
<p style="margin-left:1%;">Ques- <%=i%> (<%=list.get(i-1).getAttempt()%> out of <%=list.get(i-1).getTotal()%>)</p>
<div class="container">
	<%
		int flag = (i-1)%4;
	
		if(flag == 0){
	%><div class="skills green" 
		style="width:<%=String.format("%.2f",(double)list.get(i-1).getPercent())%>%;"><%=String.format("%.2f",(double)list.get(i-1).getPercent())%>
	  </div>
	<%
		}else if(flag == 1) {
	%>
	<div class="skills blue" 
	style="width:<%=String.format("%.2f",(double)list.get(i-1).getPercent())%>%;"><%=String.format("%.2f",(double)list.get(i-1).getPercent())%>
	</div>
	
	<%
		}else if(flag == 2){
	%><div class="skills red" 
			style="width:<%=String.format("%.2f",(double)list.get(i-1).getPercent())%>%;"><%=String.format("%.2f",(double)list.get(i-1).getPercent())%>
	</div>
	<%
		}else{
	%><div class="skills grey" 
			style="width:<%=String.format("%.2f",(double)list.get(i-1).getPercent())%>%;"><%=String.format("%.2f",(double)list.get(i-1).getPercent())%>
	</div>
	<%
		
		}
  	%>
</div>
	
<%
	}
%>
</body>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>