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
<body onload="setTimer(1)">
	
	<%
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
		ArrayList<QuesAns> list = new quizDao().getQuesAns(id);
	%>
	
	<%
		if(list.size() == 0){
	%>
		
		<br><br><br>
		<h3>No Questions Available</h3>
	<%
		}else{
			for(int i=0;i<list.size();i++){
				
				if(list.get(i).getCategory() == 2){
	%>
<div id="mainQuesDiv<%=i+1%>" style="display:none;">
    <h5 class="overAll-Timer" align="center" id="timerDisplay<%=i+1%>">Time Remaining : <%=list.get(i).getTimer()%>:00</h5>
    <input type="hidden" value="<%=list.get(i).getTimer()%>" id="timer<%=i+1%>">
    <%
    	if(i == list.size()-1){
    %>
    <input type="hidden" value="-1" id="next<%=i+1%>">
    <%
    	}else{
    %>
    <input type="hidden" value="<%=i+2%>" id="next<%=i+1%>">
    <%
    	}
    %>

    <div id = "<%=i+1%>" class="ques-div">
		<div class="form-group">
		  <h6 class="marks">Marks : <%=list.get(i).getMarks()%></h6>
		  <%
		  	if(list.get(i).getNeg_marking() != -1){
		  %>
		  <h6 class="neg-marking">Neg.Marking : <%=String.format("%.2f", (double)(list.get(i).getMarks()*list.get(i).getNeg_marking())/100)%> </h6>
		  <%
		  	}else{
		  %>
		  <h6 class="neg-marking">Neg.Marking : 0 </h6>
		  <%
		  	}
		  %>
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
    <%
    	if(i == list.size()-1){
    %>
    <button  class="btn btn-outline-primary next-button" type="button" onclick="nextFunc(<%=i+1%>)">
         Over Preview </button>
    <%
    	}else{
    %>
    <button  class="btn btn-outline-primary next-button" type="button" onclick="nextFunc(<%=i+1%>)">
        Next -> </button>
    <%
    	}
    %>
    
</div>
	<%
    			}else{
    %>
    <div id="mainQuesDiv<%=i+1%>" style="display:none;">
    <h5 class="overAll-Timer" align="center" id="timerDisplay<%=i+1%>">Time Remaining : <%=list.get(i).getTimer()%>:00</h5>
    <input type="hidden" value="<%=list.get(i).getTimer()%>" id="timer<%=i+1%>">
    <%
    	if(i == list.size()-1){
    %>
    <input type="hidden" value="-1" id="next<%=i+1%>">
    <%
    	}else{
    %>
    <input type="hidden" value="<%=i+2%>" id="next<%=i+1%>">
    <%
    	}
    %>

    <div id = "<%=i+1%>" class="ques-div">
		<div class="form-group">
		  <h6 class="marks">Marks : <%=list.get(i).getMarks()%></h6>
		  <%
		  	if(list.get(i).getNeg_marking() != -1){
		  %>
		  <h6 class="neg-marking">Neg.Marking : <%=String.format("%.2f", (double)(list.get(i).getMarks()*list.get(i).getNeg_marking())/100)%> </h6>
		  <%
		  	}else{
		  %>
		  <h6 class="neg-marking">Neg.Marking : 0 </h6>
		  <%
		  	}
		  %>
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
    <%
    	if(i == list.size()-1){
    %>
    <button  class="btn btn-outline-primary next-button" type="button" onclick="nextFunc(<%=i+1%>)">
        Over Preview </button>
    <%
    	}else{
    %>
    <button  class="btn btn-outline-primary next-button" type="button" onclick="nextFunc(<%=i+1%>)">
        Next -> </button>
    <%
    	}
    %>
</div>
    <%
    			}
			}
		}
	%>
<button type="button" id="QuizOverTrigger" style="display:none;" data-toggle="modal" data-target="#QuizOver">
</button>

<div class="modal fade" id="QuizOver" tabindex="-1" role="dialog" aria-labelledby="QuizOver" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-body">
          Preview is Over Click Okay to Get Back
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" data-dismiss="modal" onclick="window.close();">Okay</button>
        </div>
      </div>
    </div>
</div>

</body>
<script src="javascript/script.js">
</script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>