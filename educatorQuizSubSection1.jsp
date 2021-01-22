<%@page import="hide.DataHiding"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="javax.xml.crypto.Data"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.MainQuizBean"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("qzid") != null){
%>
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
	<%@include file="educator_menu.html"%>
	
	<div class="modal fade" id="editQuizSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Quiz edited Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
       <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>



<div class="modal fade" id="quizError" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong at server side !! if problem persist then try to contact the owner
        </div>
      </div>
      <div class="modal-footer">
       <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>


<%
	if(session.getAttribute("success")!=null){
		
		if(session.getAttribute("success").equals("2")){
%>
	<script>
		$(document).ready(function(){
			    $("#editQuizSuccess").modal("show");   
		});
	</script>	
<% 
		}
		session.removeAttribute("success");
	}else if(session.getAttribute("error")!=null){
%>
<script>
	$(document).ready(function(){
		$("#quizError").modal("show");
		    
	});
</script>

<%
		session.removeAttribute("error");
	}
%>

<%
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
		MainQuizBean bean = new quizDao().getQuiz(id);
%>

	<div style="margin-top:2%;margin-left:2%;">
	<a href="educatorQuizSection.jsp?qmid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQmid()))%>"><- Return Back</a>
	</div>
	<br>
	<h6 align="center">Note: In case Delete Questions/Delete Quiz option is disabled then it means that some students are attempting the quiz</h6>
	<div style="margin:10%;border:1px solid #8080803b;border-radius: 10px;">
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
        <%
        	}
        %>
        

        <div style="margin-top:6%;font-size: large;" class="text-center">
          Operations Allowed
        </div>
        <hr>

        <button type="button" class="btn btn-outline-primary m-1" onclick="window.location.replace(`educatorQuizSubSection2.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>&timer=<%=bean.getTimer()%>`)">Add questions</button>
        <%
        	if(bean.isWebcam()){
        %>
        <button type="button" class="btn btn-outline-primary m-1" onclick="window.location.replace(`livestream1.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>`)">Go To Live Stream</button>
        <%
        	}
        %>
        <button type="button" class="btn btn-outline-primary m-3" data-toggle="modal" data-target="#editQuizMainmodal">Edit Quiz Details</button>
        <button id="deleteQuizButton" type="button" class="btn btn-outline-primary m-1" data-toggle="modal" data-target="#quizDeleteModal">Delete Quiz</button><br>
        <%
        	if(bean.getTimer() == 2){
        %>
        <button type="button" class="btn btn-outline-primary m-1" onclick="window.open(`educatorQuizSubSection3Preview1.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>`
        ,'window','toolbar=yes,scrollbars=yes,resizable=yes');">Preview Quiz</button>
       <%
        	}else{
        %>
        <button type="button" class="btn btn-outline-primary m-1" onclick="window.open(`educatorQuizSubSection3Preview2.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>`
        ,'window','toolbar=yes,scrollbars=yes,resizable=yes');">Preview Quiz</button>
        <%
        	}
       %>
       <a class="btn btn-outline-primary m-3" href="quizStats.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>">Check Attempts</a>
        
            
        <button type="button" class="btn btn-outline-primary m-3" id="deleteQues"
        onclick="window.open(`educatorDeleteQuestion.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>`
            ,'window','toolbar=yes,scrollbars=yes,resizable=yes');">Delete Questions</button>
            
        <button type="button" class="btn btn-outline-primary m-3"
        onclick="window.open(`quizGraphicalData.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(bean.getQuizid()))%>`
            ,'window','toolbar=yes,scrollbars=yes,resizable=yes');">Check Graphical Stat</button>
      </div>
    </div>

<form action="DeleteQuiz" method="post" id="deleteQuizForm"> 
<div class="modal fade" id="quizDeleteModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Are You Sure you want to delete this quiz ?
        		<input type="hidden" name="qzid" value="<%=bean.getQuizid()%>">
        		<input type="hidden" name="qmid" value="<%=bean.getQmid()%>">
        	
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-secondary" data-dismiss="modal">No</button>
        <button class="btn btn-primary" type="submit">Yes</button>
      </div>
    </div>
  </div>
</div>
</form>

<form action="EditQuiz" method="post" id="editQuizForm" class="needs-validation" novalidate>
<div class="modal fade" id="editQuizMainmodal" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-body">
              <div>
              <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
                  
                      <div class="form-group">
                      <label for="title">Title Of Quiz <span style="color:red;">*</span></label>
                      <textarea class="form-control" id="title" name="title" 
                      rows="2" value="<%=bean.getTitle()%>" required maxlength="200"><%=bean.getTitle()%></textarea>
                      <div class="invalid-feedback">
        					 Please provide a title.
    					</div>
                       </div>
                        
                    <div class="form-group">
                      <label for="inst">Instructions <span style="color:red;">*</span></label>
                      <textarea class="form-control" id="inst" name="inst" rows="4" 
                      value="<%=bean.getInst()%>" required maxlength="1000"><%=bean.getInst()%></textarea>
                      <div class="invalid-feedback">
        					 Please Provide Instructions.
    					</div>
                    </div>

                    <div class="form-group">
                        <label for="timelineSelect">Timeline for the quiz</label>
                            <select class="form-control" name="timelineSelect" id="timelineSelect" 
                            onchange="edittimelineToggler(this)">
                            
                            <%
                            	if(bean.isTimeline()){
                            %>
                            <option value="1" selected>Yes</option>
                            <option value="0">No</option>
                            <% 
                            	}else{
                            %>
                            <option value="0" selected>No</option>
                             <option value="1">Yes</option>
                            <%
                            	}
                            %>
                              
                            </select>
                        <small id="timelineHelp" class="form-text text-muted">
                            when you select a timeline for this quiz then it will be avaliable 
                            only between that period of time
                        </small>
                    </div>

					<%
						if(bean.isTimeline()){
					%>
					<div class="form-group" id="timelineDiv">
                      Select TimeLine<br><br>
                      <label for="from">from <span style="color:red;">*</span></label>
                      <%
                      	if(bean.getFrom() != null){
                      %>
                      	<input class="form-control" type="datetime-local" id="from" name="from" value="<%=bean.getFrom().replace(" ", "T")%>">
                      	<label for="to">to *</label>
                      <%
                      	}else{
                      %>
                      <input class="form-control" type="datetime-local" id="from" name="from">
                      <label for="to">to <span style="color:red;">*</span></label>
                      <%
                      	}
                      
                       if(bean.getTo() != null){
                    	%>
                    	<input class="form-control" type="datetime-local" id="to" name="to" value="<%=bean.getTo().replace(" ", "T")%>">
                    	<%
                       }else{
                    	%>
                    	<input class="form-control" type="datetime-local" id="to" name="to" value="-1" disabled>
                    	<%
                       }
                      %>
                      
                      <div class="form-check">
                      <%
                      	if(bean.getTo() == null){
                      	%>
                      	
                      	<input class="form-check-input" type="checkbox" id="toInfinity" name="toInfinity" 
                      	value="3" onchange="edittoCheckToggle(this)" checked>
                      	<%
                      	}else{
                      %>
                      <input class="form-check-input" type="checkbox" id="toInfinity" name="toInfinity" 
                      value="3" onchange="edittoCheckToggle(this)">
                      <%
                      	}
                      %>
                      
                      <label class="form-text text-muted" for="toInfinity">There is no 'to' Limit</label>
                    </div>
                    
                    <div class="invalid-feedback">
        					 Please Provide Values.
    				</div>
                    </div>
					<%
						}else{
					%>
					<div class="form-group" id="timelineDiv" style="display:none;">
                      Select TimeLine<br><br>
                      <label for="from">from <span style="color:red;">*</span></label>
                      <input class="form-control" type="datetime-local" id="from" name="from">
                      <label for="to">to <span style="color:red;">*</span></label>
                    	<input class="form-control" type="datetime-local" id="to" name="to" value="-1">
                    	
                      <div class="form-check">
                      	<input class="form-check-input" type="checkbox" name="toInfinity" id="toInfinity" value="3" onchange="edittoCheckToggle(this)">
                      <label class="form-text text-muted" for="toInfinity">There is no 'to' Limit</label>
                    </div>
                    <div class="invalid-feedback">
        					 Please Provide Values.
    				</div>
                    </div>
					<%
						}
					%>
                    
                      
                    <div class="form-group">
                        <label for="availablity">Availability of Quiz <span style="color:red;">*</span></label>
                        <select class="form-control" id="availablity" name="ava">
                        <%
                        	if(bean.isAva()){
                        %>
                        <option value="1" selected>Public</option>
                        <option value="0" >Private</option>
                        <%
                        	}else{
                        %>
                        <option value="0" selected>Private</option>
                        <option value="1">Public</option>
                        <%
                        	}
                        %>
                            
                            
                        </select>
                        <small id="availablityHelp" class="form-text text-muted">
                            Availability decides to whom this quiz will be avaliable
                            When you select public it will be available for all but a private quiz will be available to those 
                            who have the secret code of quiz.
                        </small> 
                    </div>
                    
                    <div class="form-group">
                        <label for="attemptsSelect">limit for number of attempts <span style="color:red;">*</span></label>
                        <select class="form-control" id="attemptsSelect" name="attemptsSelect" onchange="editattemptToggle(this);">
                        
                        <%
                        	if(bean.getAttempts() != -1){
                        %>
                            <option value="1">Yes</option>
                             <option value="0">No</option>
                        <%
                        	}else{
                        %>
                             <option value="0">No</option>
                             <option value="1">Yes</option>
                             
                             
                        <% 
                        	}
                        %>
                           
                        </select> 
                    </div>
                    
                   <%
                   	if(bean.getAttempts() == -1){
                   	%>
                   	
                   	
                    <div class="form-group" style="display:none;" id="attemptsDiv">
                        <label for="attempts">Specify the number of attempts allowed</label>
                        <input class="form-control" type="number" id="attempts" name="attempts" min=1> 
                        <div class="invalid-feedback">
        					 Please Provide Values.
    				</div>
                    </div>
                    
                    <%
                   	}else{
                   	%>
                   	<div class="form-group" id="attemptsDiv">
                        <label for="attempts">The number of attempts allowed</label>
                        <input class="form-control" type="number" id="attempts" name="attempts" 
                        value="<%=bean.getAttempts()%>" min=1>
                        <div class="invalid-feedback">
        					 Please Provide Values.
    					</div> 
                    </div>
                   	<%
                   	}
                   %>
                   
                   <div class="form-group">
                      <label for="webcam">Do You Want To Enable WebCam Of Students?<span style="color:red;">*</span></label>
                      <select class="form-control" id="webcam" name="webcam" required>
                      <%
                      	if(bean.isWebcam()){
                      %>
                        <option value="0">No</option>
                        <option value="1" selected>Yes</option>
                       <%
                      	}else{
                       %>
                       <option value="0" selected>No</option>
                        <option value="1">Yes</option>
                       <%
                      	}
                       %>
                      </select>
                  		<small id="webcamHelp" class="form-text text-muted">
                     		Selecting Yes Would Make This Quiz Proctored
                  		</small>
                   </div>     
                    
                    <br>
                    <input type="hidden" name="id" value="<%=bean.getQuizid()%>">
              </div>
            </div>
            <div class="modal-footer">
              <button class="btn btn-primary" type="submit">Save Changes</button>
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
 </form>   
    <%
	if(session.getAttribute("noValidEdit") != null){
		session.removeAttribute("noValidEdit");
%>
<script>
	$(document).ready(function(){
		$("#editQuizMainmodal").modal("show");
		    
	});
</script>

<%
	}
%>  
</body>
<script>

function editattemptToggle(ele){
	if(ele.value == "1"){
		document.getElementById("attemptsDiv").style.display = "";
		document.getElementById("attempts").setAttribute('required','true');
	}else{
		document.getElementById("attemptsDiv").style.display = "none";
		document.getElementById("attempts").removeAttribute('required');
	}
}

function edittimerToggle(ele){
	if(ele.value == "1"){
		document.getElementById("overalltimerDiv").style.display = "";
		document.getElementById("overalltimer").setAttribute('required','true');
	}else{
		document.getElementById("overalltimerDiv").style.display = "none";
		document.getElementById("overalltimer").removeAttribute('required');
	}
}

    function edittimelineToggler(ele){
        if(ele.value == "1"){
            document.getElementById("timelineDiv").style.display = "";
            document.getElementById("from").setAttribute('required','true');
            document.getElementById("to").setAttribute('required','true');
        }else{
            document.getElementById("timelineDiv").style.display = "none";
            document.getElementById("from").removeAttribute('required');
            document.getElementById("to").removeAttribute('required');
        }
    }

 	function edittoCheckToggle(ele){
        let to = document.getElementById("to");
        if(ele.checked){
            to.setAttribute('disabled','true');
            if(to.hasAttribute('required'))
                to.removeAttribute('required');
        }else{
            to.removeAttribute('disabled');
            to.setAttribute('required','true');
        }
    }
var set = setInterval(getQuizLockStatus,500);
 	//to check that Quiz is locked or not
 	function getQuizLockStatus() {
 		$.post("CheckQuizLockStatus", {
 			quizid : `<%=request.getParameter("qzid")%>`
 		}, function(data, status) {
 			if (data == "lock" && status == 'success') {
 				document.getElementById("deleteQues").setAttribute("disabled","true");
 				document.getElementById("deleteQuizButton").setAttribute("disabled","true");
 				
 			} else if (data == 'unlock' && status == 'success') {
 				document.getElementById("deleteQues").removeAttribute("disabled");
 				document.getElementById("deleteQuizButton").removeAttribute("disabled");
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