<%@page import="hide.DataHiding"%>
<%@page import="java.util.ArrayList"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.QuesAns"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("qzid")!=null){
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
		ArrayList<QuesAns> list = new quizDao().getQuesAns(id);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
<title>EduHITec | Connecting Students and Educator</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<div class="modal fade" id="deleteQues" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Question Deleted Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
       <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Server Error !! If error persist contact the owner
        </div>
      </div>
      <div class="modal-footer">
       <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="quizLock" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
		data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body">
					<div>Sorry For The Inconvenience But Some Students are Attempting This Quiz Right Now<br>
					So We Need To Close This Window</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" onclick="window.close();">Okay</button>
				</div>
			</div>
		</div>
	</div>

<%
	if(session.getAttribute("success")!=null){
		
%>
	<script>
		$(document).ready(function(){
			    $("#deleteQues").modal("show");   
		});
	</script>	
<% 
		
		session.removeAttribute("success");
	}else if(session.getAttribute("error")!=null){
%>
<script>
	$(document).ready(function(){
		$("#error").modal("show");
		    
	});
</script>

<%
		session.removeAttribute("error");
	}
%>

	<%
		if(list.size() == 0){
	%>
		
		<br><br><br>
		<h3>No Questions Available</h3>
	<%
		}else{
			for(int i=0;i<list.size();i++){
%>
<div class="modal fade" id="confirm<%=i+1%>" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to delete question - <span><%=i+1%></span> ?
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        <form action="DeleteQuestion" method="post">
        	<input type="hidden" name="id" value="<%=list.get(i).getQuesid()%>">
        	<input type="hidden" name="qzid" value="<%=list.get(i).getQuizid()%>">
        	<input type="submit" class="btn btn-primary" value="Yes">
        </form>
      </div>
    </div>
  </div>
</div>
<%				
				if(list.get(i).getCategory() == 2){
	%>
<div id="mainQuesDiv<%=i+1%>">
     <div id = "<%=i+1%>" class="ques-div">
		<div class="form-group">
		  <button type="button" class="btn btn-link" style="float:right;margin-right:2%;"
		  data-toggle="modal" data-target="#confirm<%=i+1%>">Delete</button>
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
		 
		 
         <%
		 	if(list.get(i).isManualCheck()){
		 %>
		 <h6 class="fill-blank">Enter your answer : </h6>
        <textarea class="form-control" id="fill-blank" name="ans<%=i+1%>" rows="20" maxlength="50000"
        onkeyup="countChar(this)"></textarea>
        <small id="charNum" class="form-text text-muted">Characters Left (50000/50000)</small>
		 <%
		 	}else{
		 %>
		 	<h6 class="fill-blank">Enter your answer : </h6>
         	<input type="text" class="form-control" name="ans<%=i+1%>" value="">
         	<h6 class="exp">
				Correct Ans is : <%=list.get(i).getFillBlAns()%>
			</h6>
		 <%
		 	}
		 %>
		
		<br>
        <h6 >Explanation : </h6>
        <div style="margin:2%">
            <%
            	if(list.get(i).getExplanation_type() == 1){
            %>
            <%=list.get(i).getExplanation()%>
            <%
            	}else{
            %>
            <a href="<%=list.get(i).getExplanation()%>"><%=list.get(i).getExplanation()%></a>
            <%
            	}
            %>
        </div>
    </div>

    <br>
</div>
	<%
    			}else{
    %>
<div id="mainQuesDiv<%=i+1%>">    
    <div id = "<%=i+1%>" class="ques-div">
		<div class="form-group">
		  <button type="button" class="btn btn-link" style="float:right;margin-right:2%;"
		  data-toggle="modal" data-target="#confirm<%=i+1%>">Delete</button>
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
         <h6 style = "color:#8f05f7fc;margin-top:4%;">Select the correct one : </h6>
        <%
        	int count=1;
        	for(int j=0;j<list.get(i).getNo_of_options();j++){
        %>
        	<div class="form-check">
            <input class="form-check-input" type="radio" id="quesRadio<%=i+1%>" name="quesRadio<%=i+1%>"
             value="" onChange="showClear(<%=i+1%>);">
            <label class="form-check-label" for="quesRadio<%=i+1%>">
                <%
                	if(list.get(i).getOptions()[j].equals("-1")){
                %>
                <div class="img-Div-option">
                	<img src="quesAns/EduHITec_<%=list.get(i).getQuizid()%><%=list.get(i).getQuesid()%>a<%=j+1%>.<%=list.get(i).getExt_opt_attach()[count-1]%>" alt="" 
                	class="img-actual">
                	<%
                	if(list.get(i).getOptionsAns().equals(String.valueOf(j+1))){
                %>
                <i class="fa fa-check" aria-hidden="true" style="color:green;font-size:20px;"></i>
                <%
                	}
                %>
                </div>
                <%
                	count++;
                	}else{
                %>
                <%=list.get(i).getOptions()[j]%>
                		<%
                	if(list.get(i).getOptionsAns().equals(String.valueOf(j+1))){
                %>
                <i class="fa fa-check" aria-hidden="true" style="color:green;font-size:20px;"></i>
                <%
                	}
                %>
                <%
                	}
                %>
                
                
            	</label>
            
        	</div>     		
        <%
        	
        	}
        %>
                
        
        <br>
        <div class="clear-section" style="display:none;" id="clear<%=i+1%>" onclick="clearFunc(<%=i+1%>);">
            <b>Clear Section</b>
        </div>

        <br><br>

        <h6 class="exp">Explanation : </h6>
        <div style="margin:2%">
            <%
            	if(list.get(i).getExplanation_type() == 1){
            %>
            <%=list.get(i).getExplanation()%>
            <%
            	}else{
            %>
            <a href="<%=list.get(i).getExplanation()%>"><%=list.get(i).getExplanation()%></a>
            <%
            	}
            %>
        </div>
    </div>
    <br>
</div>
    <%
    			}
			}
		}
	%>
	
</body>
<script>
var set = setInterval(getQuizLockStatus,500);
	//to check that Quiz is locked or not
	function getQuizLockStatus() {
		$.post("CheckQuizLockStatus", {
			quizid : `<%=request.getParameter("qzid")%>`
		}, function(data, status) {
			if (data == "lock" && status == 'success') {
				$("#quizLock").modal("show");
			} 
		});
	}
</script>
<script src="javascript/script.js">
</script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>