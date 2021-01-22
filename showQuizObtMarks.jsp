<%@page import="quiz.quizDao"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("std_id")!=null && request.getParameter("m") != null && request.getParameter("tot")!=null
	&& request.getParameter("qzid") != null){
		String obt_marks = request.getParameter("m");
		String tot_marks = request.getParameter("tot");
		
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
<body onload="move(<%=Math.round((Double.parseDouble(obt_marks)/Integer.parseInt(tot_marks))*100)%>,<%=tot_marks%>,<%=obt_marks%>);">
	<h4 align="center" style="margin-top:2%">Note :- The fill in the blanks having manual check set are not included while
		marking, so once the educator check the answer, the marks will be awarded by them so if your marks are less than expected then
		it is because of manual check questions</h4>
		
	<div class="marksDiv">
        <h3 align="center">Thank You for Attempting the Quiz</h3>
        <h3 align="center" id="cal_marks">Calculating Your Score.....</h3>

        <div id="ProgressDiv" class="myProgress">
            <div id="myBar" class="zero"></div>
        </div>
        
        
        <div align="center" id="poor" style="display: none;;">
          <h3>Poor Performance <i class='fas fa-dizzy' style='font-size:48px;color:#f44336;'></i></h3>
          <h3>Need A lot of more work to do !!!</h3>
        </div>

        <div align="center" id="avg" style="display: none;;">
          <h3>Average Performance <i class='fas fa-grin-beam-sweat' style='font-size:48px;color:#ff9800;'></i></h3>
          <h3>You can improve More !!!</h3>
        </div>

        <div align="center" id="good" style="display: none;;">
          <h3>Good Performance <i class='fas fa-grin-alt' style='font-size:48px;color:#2196F3;'></i></h3>
        </div>

        <div align="center" id="exc" style="display: none;;">
          <h3>Excellent Performance <i class='fas fa-grin-stars' style='font-size:48px;color:#4CAF50'></i></h3>
          <h3>You performed exceptionally well !!</h3>
        </div>

        <div style="display:none;text-align: center;margin: 5%;" id="go_back">
          <h4>You can review your attempt in the main Section</h4>
          <a href="studentQuizSubSection2.jsp?qzid=<%=request.getParameter("qzid")%>" style="color:blue;" >Click here to Go Back</a>
        </div>
    </div>

</body>
<script>
let i = 0;
//for animating the score of quiz
function move(max_width,tot_marks,obt_marks) {
  setTimeout(1000);
if (i == 0) {
  i = 1;
  var elem = document.getElementById("myBar");
  var width = 0;
  var id = setInterval(frame, 50);

  function frame() {
    if (width == max_width || max_width < 0) {
      clearInterval(id);
      document.getElementById("cal_marks").innerHTML = "Marks Obtained : "+max_width+"%<br>"
      +obt_marks+"/"+tot_marks+"</br>";
      if(max_width < 30)
        document.getElementById("poor").style.display = "";
      else if(max_width >= 30 && max_width < 60)
        document.getElementById("avg").style.display = "";
      else if(max_width >=60 && max_width < 80)
        document.getElementById("good").style.display = "";
      else
        document.getElementById("exc").style.display = "";
      
      document.getElementById("go_back").style.display="";
      i = 0;
    } else {
      width++;
      if(width < 30){
          elem.style.width = width + "%";
          elem.style.backgroundColor = "#f44336";
      }else if(width >= 30 && width <60){
          elem.style.width = width + "%";
          elem.style.backgroundColor = "#ff9800";
         
      }else if(width >= 60 && width < 80){
          elem.style.width = width + "%";
          elem.style.backgroundColor = "#2196F3";
          
      }else{
          elem.style.width = width + "%";
          elem.style.backgroundColor = "#4CAF50";
          
      }
    }
  }
}
}
</script>
</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>