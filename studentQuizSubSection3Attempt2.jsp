<%@page import="livestream.LivestreamDao"%>
<%@page import="hide.DataHiding"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.QuesAns"%>
<%@page import="java.util.ArrayList"%>

<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("std_id")!=null && request.getParameter("qzid")!=null && request.getParameter("cam") != null){
		int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
		ArrayList<QuesAns> list = new quizDao().getQuesAns(id);
		
		if(list.size() == 0){
%>
				<script>
					window.alert("No Questions Available In Quiz");
					window.location.replace("studentQuizSubSection2.jsp?qzid="+`<%=request.getParameter("qzid")%>`);
				</script>
<%
					
	}else{
		int validity = new quizDao().getQuizValidityForStudent(id);
		int timer = new quizDao().getOverAllTimer(id);
		int cam = 1;
		
		if(request.getParameter("cam").equalsIgnoreCase("false")){
			cam = 0;
		}
		
		if(validity != 1){
			response.sendRedirect("studentQuizSubSection2.jsp?qzid="+request.getParameter("qzid"));
		}else{
			if(cam == 1){
				new LivestreamDao().addUserToStream((Integer)session.getAttribute("std_id"), id);
			}
			new quizDao().acquireLock(id);
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<link rel="stylesheet" href="css/style.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<title>EduHITec | Connecting Students and Educator</title>
</head>
<%
	if(cam == 1){
%>
<body onload="getVideo()">
<%
	}else{
%>
<body>
<%
	}
%>
<div id="instructions" class="text-center inst">
        <h5>Please Note the given Instructions carefully :-</h5><br><br><br>
        <span>1. The quiz will going to take place in full screen mode</span><br><br>
        <span>2. Once the quiz is started do not try to press esc key as it will
            take you out of the quiz mode and it may lead to <b>disqualification</b></span><br><br>
        <br><br>
        <span>3. This Quiz Will Be Proctored By Webcam Please Allow Your Browser To Access Your Webcam</span><br><br>
        <h6>All The Best !!!!</h6><br><br>
        <%
        	if(cam == 1){
        %>
        <button type="button" id="startBtn" 
        class="btn btn-outline-primary" onclick="startQuiz();" style="display:none;">Click Here To Start Quiz</button>
        <%
        	}else{
        %>
        <button type="button" id="startBtn" 
        class="btn btn-outline-primary" onclick="startQuiz();">Click Here To Start Quiz</button>
        <%
        	}
        %>
</div>

 <div id="container" style="display:none;">
            <video autoplay="true" id="videoElement" >
            
            </video>
        </div>

        <canvas  id="myCanvas" width="400" height="350" style="display:none;"></canvas>  

<div class="modal fade" id="videoBlocked" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
    <div class="modal-dialog modal-dialog-centered">
      <div class="modal-content">
        <div class="modal-body text-center">
          <div>
              Please Allow The Permission For Camera !!!!
          </div>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-success" onclick="getVideo();">Dismiss</button>
        </div>
      </div>
    </div>
</div>

<form action="disqualifyServlet" method="post" id="dq">
	<input type="hidden" name="qzid" value="<%=id%>">
</form>

<div class="alert warning-alert" style="display:none;" id="warning-alertDiv">
        <h4 style="font-family:Quicksand;">Please return back 
        to full screen mode in <span id="warning-trigger">10</span> seconds 
        otherwise it will lead to disqualification</h4><br><br>
        <button type="button" class="btn btn-outline-primary" onclick="startQuiz();">Click Here To Resume Quiz</button>
</div>

	<%
		
		if(list.size() == 0){
	%>
		<br><br><br>
		<h3>No Questions Available</h3>
		<br>
		<button type="button" class="btn btn-primary" onclick="window.close();">Click Here To Exit</button>
	<%
		}else{
	%>
<div id="quizMainStudent" style="display:none;">

<%
		if(timer != -1){
%>
<div class="overAll-Timer">
    <h5 align="center" id="timerDisplay">Time Remaining : <%=timer%>:00</h5>
</div>
<%
		}
%>

<form action="ComputeMarks" method="post">
	<%
			for(int i=0;i<list.size();i++){
				
				if(list.get(i).getCategory() == 2){
	%>
<div id="mainQuesDiv<%=i+1%>">
	<input type="hidden" value="2" name="QuesType<%=i+1%>">
     <div id = "<%=i+1%>" class="ques-div">
		<div class="form-group">
		  <h6 class="marks">Marks : <%=list.get(i).getMarks()%></h6>
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
		 <%
		 	}
		 %>

	</div>		
</div>

    <br>

	<%
    			}else{
    %>
<div id="mainQuesDiv<%=i+1%>">    
    <div id = "<%=i+1%>" class="ques-div">
    <input type="hidden" value="1" name="QuesType<%=i+1%>">
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
            <input class="form-check-input" type="radio" id="quesRadio<%=i+1%>" name="ans<%=i+1%>"
             value="<%=j+1%>" onChange="showClear(<%=i+1%>);">
            <label class="form-check-label" for="quesRadio<%=i+1%>">
                <%
                	if(list.get(i).getOptions()[j].equals("-1")){
                %>
                <div class="img-Div-option">
                	<img src="quesAns/EduHITec_<%=list.get(i).getQuizid()%><%=list.get(i).getQuesid()%>a<%=j+1%>.<%=list.get(i).getExt_opt_attach()[count-1]%>" alt="" 
                	class="img-actual">
                </div>
                <%
                	count++;
                	}else{
                %>
                <%=list.get(i).getOptions()[j]%>
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
    </div>
    <br>
</div>
    <%
    				
				}
			}
	%>
	
<button type="button" id="QuizOverTrigger" data-toggle="modal" data-target="#QuizOver" style="display:none;"></button>
<br><br>
 <button  class="btn btn-outline-primary next-button" type="button" data-toggle="modal" data-target="#Submit-Quiz">
Submit Quiz</button>

<div class="modal fade" id="QuizOver" tabindex="-1" role="dialog" aria-labelledby="QuizOver" aria-hidden="true"
 data-keyboard="false" data-backdrop="static">
    <div class="modal-dialog modal-dialog-centered" role="document">
      <div class="modal-content">
        <div class="modal-body">
          Time Over Thank You for Attempting the Quiz !!!
        </div>
        <div class="modal-footer">
        <%
		if(timer != -1){
	%>
          <input type="submit" class="btn btn-success" value="Okay">
          <%
		}
          %>
        </div>
      </div>
    </div>
</div>

<div class="modal fade" id="Submit-Quiz" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
 data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-body">
      <%
      	if(timer != -1){
      %>
        Are you sure you want to submit the quiz as their is some time left ?
       <%
      	}else{
      	%>
      	 Are you sure you want to submit the quiz ?
      	<%
      	}
       %>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <input type="submit" class="btn btn-primary" value="Submit Quiz">
      </div>
    </div>
  </div>
</div>
	<input type="hidden" value="<%=id%>" name="qzid">
	
</form>
</div>
<%
		}
%>
</body>


<script>
var trigger = 0;

function startQuiz(){
	<%
	if(timer != -1){
	%>
	openFullscreen(document.documentElement,2,trigger,<%=timer%>);
	<%
		}else{
	%>
	openFullscreen(document.documentElement,3,trigger);
	<%
		}
	%>
	trigger = 1;
}

document.onkeydown = function(e) {
	  if(event.keyCode == 123) {
	     return false;
	  }
	  if(e.ctrlKey && e.shiftKey && e.keyCode == 'I'.charCodeAt(0)) {
	     return false;
	  }
	  if(e.ctrlKey && e.shiftKey && e.keyCode == 'C'.charCodeAt(0)) {
	     return false;
	  }
	  if(e.ctrlKey && e.shiftKey && e.keyCode == 'J'.charCodeAt(0)) {
	     return false;
	  }
	  if(e.ctrlKey && e.keyCode == 'U'.charCodeAt(0)) {
	     return false;
	  }
	}


document.addEventListener("fullscreenchange", function (event) {
	
    if (document.fullscreenElement) {
        // fullscreen is activated
    } else {
        //document.getElementById("instructions").style.display = "";
        document.getElementById("quizMainStudent").style.display ="none";
        document.getElementById("warning-alertDiv").style.display = "";
        document.getElementById("warning-trigger").innerHTML = 10;
        //document.exitFullscreen();
        warningTimer(); 
    }
});

/*document.addEventListener('contextmenu', function(e) {
	  e.preventDefault();
	});
*/
function countChar(val) {
    var len = val.value.length;
    if (len >= 10000) {
      val.value = val.value.substring(50, 10000);
    } else {
      $('#charNum').text("Characters Left ("+(50000 - len)+"/50000)");
    }
};

canvas = document.getElementById("myCanvas");
ctx = canvas.getContext('2d');

var video = document.querySelector("#videoElement");
var x ;
//to start stream
function getVideo(){
    $("#videoBlocked").modal("hide");
if (navigator.mediaDevices.getUserMedia) {
  navigator.mediaDevices.getUserMedia({ video: { facingMode: "user"}} )
    .then(function (stream) {
    	document.getElementById("startBtn").style.display="";
        console.log(stream);
        video.srcObject = stream;
        snapshot();
    }).catch(function (error) {
        $("#videoBlocked").modal("show");
      console.log("please allow the camera to work");
    });
}else{
    console.log("not supported");
}
}


window.addEventListener("beforeunload", function (e) {
    stop();  
});

//to stop stream
function stop() {
	$.ajax({ 
	      type: "POST", 
	      url: "RemoveUser", 
	      data: {  
	    	  std_id : `<%=new DataHiding().encodeMethod(""+(Integer)session.getAttribute("std_id"))%>`,
	          qzid : `<%=new DataHiding().encodeMethod(String.valueOf(id))%>`
	      } 
	  }).done(function(o) {
	  	console.log("removed the stream");  
	  }); 
	  
	if(video.srcObject != null){
  		var stream = video.srcObject;
  		var tracks = stream.getTracks();

  		for (var i = 0; i < tracks.length; i++) {
    		var track = tracks[i];
    		track.stop();
  		}

  		video.srcObject = null;
	}
}

function snapshot() {
        // Draws current image from the video element into the canvas
        ctx.drawImage(video, 0,0, canvas.width, canvas.height);
        console.log("image drawn");
        var dataURL = canvas.toDataURL(); 
        $.ajax({ 
            type: "POST", 
            url: "StoreImage", 
            data: {  
                imgBase64: dataURL,
                std_id : `<%=new DataHiding().encodeMethod(""+(Integer)session.getAttribute("std_id"))%>`,
                qzid : `<%=new DataHiding().encodeMethod(String.valueOf(id))%>`
            } 
        }).done(function(o) {
        	
        	setTimeout(snapshot,3000);
        	//setTimeout(snapshot,2000);
        	//setTimeout(snapshot,1000);
        	//setTimeout(snapshot,500);
        	//setTimeout(snapshot,200);
            console.log('saved');  
        }); 
}
</script>
<script src="javascript/script.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>
</html>
<%
		}
		}
	}else{
		response.sendRedirect("login.jsp");
	}
%>