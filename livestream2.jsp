<%@page import="livestream.LivestreamDao"%>
<%@page import="livestream.UserBean"%>
<%@page import="hide.DataHiding"%>
<%@page import="quiz.MainQuizBean"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.QuizMainListBean"%>
<%@page import="java.util.ArrayList"%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("qzid") != null 
	&& request.getParameter("std_id") != null){
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Connecting Students and Educator</title>
</head>
<body onload="snapshot();">
<%@include file="student_menu.html"%>
<br><br>
<a href="livestream1.jsp?qzid=<%=request.getParameter("qzid")%>" style="margin:2%"><- Return Back</a>

<br><br>
<div align="center">
	  <img src=""  width="298px" height="298px" id="showStream" style="display:none;margin:5%;">
</div>  
<div class="modal fade" id="userLeftModal" tabindex="-1" role="dialog" 
aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-body text-center">
          <div>
              User left The Stream !!!!
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" onclick="window.location.replace('livestream1.jsp?qzid=<%=request.getParameter("qzid")%>')">Dismiss</button>
        </div>
      </div>
    </div>
</div>

</body>
<script>
function snapshot(){
	$.ajax({ 
        type: "POST", 
        url: "GetImage", 
        data: {  
        	std_id : `<%=request.getParameter("std_id")%>`,
            qzid : `<%=request.getParameter("qzid")%>`
        } 
    }).done(function(o) {
    	console.log(o);
    	if(o == "nf"){
    		document.getElementById("showStream").style.display = "none";
    		$("#userLeftModal").modal("show");
    		//console.log("hii");
    	}else{
    		document.getElementById("showStream").src=o;
    		document.getElementById("showStream").style.display="";
    	}
    	setTimeout(snapshot,2000);
    	//setTimeout(snapshot,1000);
    	//setTimeout(snapshot,500);
    	//setTimeout(snapshot,100);
    	//setTimeout(snapshot,50);
    }); 
	    
}
</script>
<script src="javascript/script.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>