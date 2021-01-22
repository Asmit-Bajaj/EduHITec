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
	if(session.getAttribute("std_id")!=null && request.getParameter("qzid")!=null && request.getParameter("rvid")!=null){
		int rvid = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("rvid")));
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
		
		ArrayList<QuesAns>list = new quizDao().getQuesAns(id);
		ArrayList<StudentQuizReviewBean> ans = new quizDao().getReview(rvid);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
<script src='https://kit.fontawesome.com/a076d05399.js'></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
<title>EduHITec | Connecting Students and Educator</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
<%
	for(int i=0;i<list.size();i++){
		if(list.get(i).getCategory() == 2){
%>
<div id="mainQuesDiv<%=i+1%>">
	<div id = "<%=i+1%>" class="ques-div">
		<div class="form-group">
  			<h6 class="marks">Total Marks : <%=list.get(i).getMarks()%></h6>
  			<h6 class="marks" style="white-space: pre-wrap"> Marks Obtained: <%=ans.get(i).getMarks_obt()%>  </h6>
  
  		<%
  			if(list.get(i).getNeg_marking() != -1 && list.get(i).isManualCheck() == false){
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
 
 
 	<h6 class="fill-blank">Answer Given : </h6>
 	<%
 		if(list.get(i).isManualCheck()){
 	%>
 	<div style="white-space: pre-wrap;"><%=ans.get(i).getAns_given()%></div>
 	<h6 class="exp">
 	<%
 		if(ans.get(i).getMarks_obt().equals("NA")){
 	%>
		Correct Answer is : Will Be Checked Manually By The Educator, After Checking Marks will be Awarded
	<%
 		}else{
	%>
		Correct Answer is : Already Checked By The Educator
	<%
 		}
	%>
	</h6>
 	<%	
 		}else{
 	%>
 	<input type="text" readonly class="form-control-plaintext" value="<%=ans.get(i).getAns_given()%>">
 	
 	<%
		if(ans.get(i).getMarks_obt().charAt(0) != '-' && ans.get(i).getMarks_obt().charAt(0) != '0'){
	%>
	<h6 style="color:green;">
		Your Answer is Correct
	</h6>
	<%
		}else{
			if(ans.get(i).getAns_given().equals("")){
	%>
		<h6 style="color:orange;">
			Haven't Answered this question
		</h6>
	<%
			}else{
	%>
		<h6 style="color:red;">
			Your Answer is Incorrect
		</h6>
	<%
			}
	%>
	
	<%	
		}
	%>
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
  			<h6 class="marks">Total Marks : <%=list.get(i).getMarks()%></h6>
  			<h6 class="marks" style="white-space: pre-wrap"> Marks Obtained: <%=ans.get(i).getMarks_obt()%>  </h6>
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
			boolean flag = list.get(i).getOptionsAns().equals(ans.get(i).getAns_given());
	
			for(int j=0;j<list.get(i).getNo_of_options();j++){
		%>
		<div class="form-check">
    			<input class="form-check-input" type="radio" id="quesRadio<%=i+1%><%=j+1%>" name="quesRadio<%=i+1%>"
     			value="" disabled>
    			<label class="form-check-label" for="quesRadio<%=i+1%><%=j+1%>">
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
        		
        					if(!flag && ans.get(i).getAns_given().equals(String.valueOf(j+1))){
        				%>
        					<i class="fa fa-times" style="color:red;font-size:20px;"></i>
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
        		
        					if(flag == false && ans.get(i).getAns_given().equals(String.valueOf(j+1))){
        				%>
        					<i class="fa fa-times" style="color:red;font-size:20px;"></i>
        				<%
        					}
        				}
        				%>
    			</label>
    		</div>     		
<%
	
	}
%>
        

<br>
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
	
%>
<div class="modal fade" id="QuizOver" tabindex="-1" role="dialog" aria-labelledby="QuizOver" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
	<div class="modal-content">
	<div class="modal-body">
 		Review is Over Click Okay to Get Back
	</div>
	<div class="modal-footer">
  		<button type="button" class="btn btn-success" data-dismiss="modal" onclick="window.close();">Okay</button>
	</div>
	</div>
	</div>
</div>
<button type="button" class="btn btn-outline-primary next-button" id="QuizOverTrigger" data-toggle="modal" data-target="#QuizOver">Close Review</button>
<br><br>

</body>
<script src="javascript/script.js"></script>
</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>