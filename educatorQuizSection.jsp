<%@page import="hide.DataHiding"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.MainQuizBean"%>
<%@page import="java.util.ArrayList"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("qmid") != null){
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Connecting Students and Educator</title>
</head>
<body>
<%@include file="educator_menu.html"%>

<div class="modal fade" id="addQuizSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div style="white-space:pre-wrap;">
		Quiz added Successfully !!! 
		<%
			if(request.getParameter("cd") != null){
		%>
		This is the Secret code : <%=request.getParameter("cd")%>
    **** Share the above secret code with your students so that they can access this Quiz ****<br>
    
    	<%
			}
    	%>
    	Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="deleteQuizSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Quiz removed Successfully !!! Click Okay Button to close dialog
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
		
		if(session.getAttribute("success").equals("1")){
%>
<script>
		$(document).ready(function(){
			    $("#addQuizSuccess").modal("show");   
		});
</script>		

<%
		}else if(session.getAttribute("success").equals("3")){
%>
			<script>
				$(document).ready(function(){
					    $("#deleteQuizSuccess").modal("show");   
				});
			</script>	
<% 
		}
		session.removeAttribute("success");
	}else if(session.getAttribute("error")!=null){
		session.removeAttribute("error");
%>
<script>
	$(document).ready(function(){
		$("#quizError").modal("show");
		    
	});
</script>

<%
	}
%>

<%
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qmid")));
	ArrayList<MainQuizBean>list = new quizDao().getAllQuizofCurrentList(id,1);
%>

<form action="AddQuiz" method="post" id="addQuiz_form" class="needs-validation" novalidate>
<div class="modal fade" id="addQuizMainmodal" tabindex="-1" role="dialog" 
aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
        <div class="modal-dialog modal-dialog-centered">
          <div class="modal-content">
            <div class="modal-body">
              <div>
              <small class="form-text text-muted">Note : mandatory fields are marked by *</small><br><br>
                 
                      <div class="form-group">
                      <label for="title">Enter Title Of Quiz <span style="color:red;">*</span></label>
                      <textarea class="form-control" id="title" name="title" rows="2" required maxlength="200"></textarea>
                      <div class="invalid-feedback">
        					 Please provide a title.
    					</div>
                       </div>
                        
                    <div class="form-group">
                      <label for="inst">Enter Instructions <span style="color:red;">*</span></label>
                      <textarea class="form-control" id="inst" name="inst" rows="4" required maxlength="1000"></textarea>
                      <div class="invalid-feedback">
        					 Please Provide Instructions.
    					</div>
                    </div>

                    <div class="form-group">
                        <label for="timelineSelect">Is there any timeline for the quiz ? <span style="color:red;">*</span></label>
                            <select class="form-control" name="timelineSelect" id="timelineSelect" onchange="timelineToggler(this)">
                              <option value="0">No</option>
                              <option value="1">Yes</option>
                            </select>
                        <small id="timelineHelp" class="form-text text-muted">
                            when you select a timeline for this quiz then it will be avaliable 
                            only between that period of time
                        </small>
                    </div>

                    <div class="form-group" id="timelineDiv" style="display:none;">
                      Select TimeLine<br><br>
                      <label for="from">from <span style="color:red;">*</span></label>
                      <input class="form-control" type="datetime-local" 
                       id="from" name="from">
                      <label for="to">to <span style="color:red;">*</span></label>
                      <input class="form-control" type="datetime-local" id="to" name="to" value="-1" 
                      >
                      <div class="form-check">
                      <input class="form-check-input" type="checkbox" id="toInfinity" name="toInfinity" value="3" onchange="toCheckToggle(this)">
                      <label class="form-text text-muted" for="toInfinity">There is no 'to' Limit</label>
                    	</div>
                    	<div class="invalid-feedback">
        					 Please Provide valid Values.
    					</div>
    					
    					<div style="color:red;display:none;" id="toinvalid">
        					 to value should be greater than from.
    					</div>
                    </div>
                      
                    <div class="form-group">
                        <label for="availablity">Choose Availability of Quiz ? <span style="color:red;">*</span></label>
                        <select class="form-control" id="availablity" name="ava">
                            <option value="1">Public</option>
                            <option value="0">Private</option>
                        </select>
                        <small id="availablityHelp" class="form-text text-muted">
                            Availability decides to whom this quiz will be avaliable
                            When you select public it will be available for all but a private quiz will be available to those 
                            who have the secret code of quiz.
                        </small> 
                    </div>
                    
                    <div class="form-group">
                        <label for="attemptsSelect">Is there any limit for number of attempts? <span style="color:red;">*</span></label>
                        <select class="form-control" id="attemptsSelect" name="attemptsSelect" onchange="attemptToggle(this);">
                            <option value="0">No</option>
                            <option value="1">Yes</option>
                        </select> 
                    </div>
                    
                    <div class="form-group" style="display:none;" id="attemptsDiv">
                        <label for="attempts">Specify the number of attempts allowed <span style="color:red;">*</span></label>
                        <input class="form-control" type="number" id="attempts" name="attempts" min=1> 
                        <div class="invalid-feedback">
        					 Please Provide Values Here.
    					</div>
                    </div>
                        
                    <div class="form-group">
                      <label for="timer">Select the type of Timer <span style="color:red;">*</span></label>
                      <select class="form-control" id="timer" name="timer" onchange="timerToggle(this)">
                        <option value="1">Overall Timer</option>
                        <option value="2">Timer for each question</option>
                        <option value="3" selected>No Timer</option>
                      </select>
                  <small id="timerHelp" class="form-text text-muted">
                      An 'Overall timer' is a complete timer for the whole quiz whereas timer 'for each question' is a timer for 
                      every question in quiz
                  </small>
                    </div>
                    
                    <div class="form-group" style="display:none;" id="overalltimerDiv">
                        <label for="timer">Specify the time limit (in mins)</label>
                        <input class="form-control" type="number" id="overalltimer" name="overalltimer" min=1> 
                        <div class="invalid-feedback">
        					 Please Provide Values Here.
    					</div>
                    </div>
                    
                    <div class="form-group">
                      <label for="webcam">Do You Want To Enable WebCam Of Students?<span style="color:red;">*</span></label>
                      <select class="form-control" id="webcam" name="webcam" required>
                        <option value="0">No</option>
                        <option value="1">Yes</option>
                        
                      </select>
                  		<small id="webcamHelp" class="form-text text-muted">
                     		Selecting Yes Would Make This Quiz Proctored
                  		</small>
                    </div>
                    
                    <br>
                    <input type="hidden" name="id" value="<%=id%>">
                 
              </div>
            </div>
            <div class="modal-footer">
              <button class="btn btn-primary" type="submit">Add Quiz</button>
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
            </div>
          </div>
        </div>
      </div>
 </form>  
 
    <br>
    <a style="margin-left:5%" href="uploadQuizzes.jsp"><- Return Back to main section</a><br><br>
    <button type="button" class="btn btn-outline-primary" style="float:right;margin-right:3%;"
    data-toggle="modal" data-target="#addQuizMainmodal">
        Add A New Quiz +
    </button>
    
    <br>
    <br>
    <br>

    <div class="text-center" style="margin-top:5%">
    <%
    	if(list.size() == 0){
    %>
    	<div style="color:#0808c3a8;">
           <h4>No Quizzes Available</h4>
        </div>
    <% 
    	}else{
    		for(int i=0;i<list.size();i++){
    %>
    	<div class="quizheading" onclick="window.location.replace('educatorQuizSubSection1.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getQuizid()))%>')">
            <h4><%=list.get(i).getTitle()%></h4>
        </div>
    <% 
    		}
    	}
    %>
        
        
        
    </div>
 

<%
	if(session.getAttribute("noValidAdd") != null){
		session.removeAttribute("noValidAdd");
%>
<script>
	$(document).ready(function(){
		$("#addQuizMainmodal").modal("show");
		    
	});
</script>

<%
	}
%>

</body>
<script>
function attemptToggle(ele){
	if(ele.value == "1"){
		document.getElementById("attemptsDiv").style.display = "";
		document.getElementById("attempts").setAttribute('required','true');
	}else{
		document.getElementById("attemptsDiv").style.display = "none";
		document.getElementById("attempts").removeAttribute('required');
	}
}

function timerToggle(ele){
	if(ele.value == "1"){
		document.getElementById("overalltimerDiv").style.display = "";
		document.getElementById("overalltimer").setAttribute('required','true');
	}else{
		document.getElementById("overalltimerDiv").style.display = "none";
		document.getElementById("overalltimer").removeAttribute('required');
	}
}

//clear the form on hide for add videos
$('#addQuizMainmodal').on('hide.bs.modal',function () {
	document.forms[0].className="needs-validation";
	document.forms[0].reset();
})

    function timelineToggler(ele){
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


 	function toCheckToggle(ele){
        let to = document.getElementById("to");
        if(ele.checked){
            to.setAttribute('disabled','true');
            if(to.hasAttribute('required'))
                to.removeAttribute('required');
        }else{
            to.removeAttribute('disabled');
            to.setAttribute('required','true');
            document.getElementById("toinvalid").style.display = "none";
        }
    }
</script>
<script src="javascript/script.js"></script>

</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>