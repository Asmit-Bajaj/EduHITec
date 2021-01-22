<%@page import="hide.DataHiding"%>
<%@page import="quiz.StudentQuizReviewBean"%>
<%@page import="java.util.ArrayList"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.QuesAns"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("rvid")!=null){
		int rvid = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("rvid")));
		
		
		ArrayList<QuesAns>list = new quizDao().getManualCheckQuesAns(rvid);
		ArrayList<StudentQuizReviewBean> ans = new quizDao().getManualCheckReview(rvid);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
<title>EduHITec | Connecting Students and Educator</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="modal fade" id="Success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Question Graded Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="Error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something Went Wrong !! If Problem Persist Then contact the owner
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>
<%
	if(list.size() == 0){
%>
	<h3 align="center" style="margin-top:5%;">All Questions Are Graded Already</h3>
<%	
	}else{
%>
<%
	for(int i=0;i<list.size();i++){
%>
<div>
	<div class="ques-div">
		<div class="form-group">
  			<h6 class="marks">Total Marks : <%=list.get(i).getMarks()%></h6>
  			<h6 class="marks" style="white-space: pre-wrap" id="mk_<%=list.get(i).getQuesid()%>"> Marks Assigned: <%=ans.get(i).getMarks_obt()%> </h6>
  		<h6 class="neg-marking">Neg.Marking : 0 </h6>
  		
  		<br><br>
  		<span><b>Question.No- <%=i+1%>.</b></span>
  		<p style="white-space: pre-wrap;"><%=list.get(i).getQues()%></p>
  
  		<div class="img-Div">
  			<%
  				for(int j=0;j<list.get(i).getNo_of_attch_ques();j++){
  			%>
  				<img src="quesAns/EduHITec_<%=list.get(i).getQuizid()%><%=list.get(i).getQuesid()%>q<%=j%>.<%=list.get(i).getExt_ques_attach()[j]%>" 
  				alt="image" class="img-actual">
  			<%
  				}
  			%>
  
  		</div>
 	</div>
 
 
 	<h6 class="fill-blank">Answer Given : </h6>
 	
 	<div style="white-space: pre-wrap;"><%=ans.get(i).getAns_given()%></div>
 	
 	<br>
	<button type="button" class="btn btn-outline-primary next-button" id="bt_<%=list.get(i).getQuesid()%>"
	onclick="showAssignMarks('<%=list.get(i).getMarks()%>','<%=new DataHiding().encodeMethod(String.valueOf(rvid))%>','<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getQuesid()))%>','<%=list.get(i).getQuesid()%>');">Assign Marks</button>
	<br>
	
	</div>

	<br>
</div>
<%
	}
%>
<button type="button" class="btn btn-outline-primary next-button" onclick="window.close();">Done</button>
<br><br>

<div class="modal fade" id="AssignMarks" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-body">
        <div class="form-group">
    		<label for="marks">Enter The marks <span style="color:red;">*</span></label>
    		<input type="number" class="form-control" id="marks" placeholder="Enter Marks ... " min="0">
    		<small class="form-text text-muted" id="marksHelp" style="font-weight: bold;">Max Marks : </small>
  		</div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" id="marksButton">Assign Marks</button>
      </div>
    </div>
  </div>
</div>

<%
	}
%>
</body>
<script>
	function showAssignMarks(max,rvid,quid,tpid){
		document.getElementById("marks").value="";
		document.getElementById("marks").setAttribute("max",max);
		document.getElementById("marksHelp").innerHTML = "Max Marks : "+max;
		document.getElementById("marksButton").setAttribute("onclick","gradeQuestion('"+rvid+"','"+quid+"','"+tpid+"')");
		$("#AssignMarks").modal("show");
	}
	
	function gradeQuestion(rvid,quid,tpid){
		$.post("AssignMarksToManualCheck",
			    {
			      rvid : rvid,
			      quid : quid,
			      marks : $("#marks").val()
			    },
			    function(data,status){
			    	if(data != 'notvalid' && status == 'success'){
			    		document.getElementById("mk_"+tpid).innerHTML="Marks Assigned: "+data+" ";
			    		document.getElementById("bt_"+tpid).style.display="none";
			    		$("#AssignMarks").modal("hide");
			    		$("#Success").modal("show");
					}else{
						$("#AssignMarks").modal("hide");
			    		$("#Error").modal("show");
					
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