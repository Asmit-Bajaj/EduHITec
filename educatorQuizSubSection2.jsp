<%@page import="hide.DataHiding"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("qzid") != null && request.getParameter("timer")!=null){
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
<style>
        .option-box{
            border:0.5px solid #80808052; 
            border-radius: 10px 10px;
        }
</style>
<title>EduHITec | Connecting Students and Educator</title>   
</head>
<body>
<%
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
%>
<div class="modal fade" id="quesSuccess" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Question Added Successfully !!! Click Okay Button to close dialog
        </div>
      </div>
      <div class="modal-footer">
       <a href="educatorQuizSubSection1.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(id))%>" class="btn btn-success">Okay</a>
      </div>
    </div>
  </div>
</div>

<div class="modal fade" id="quesError" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something went wrong at server side !! if problem persist then try to contact the owner
        </div>
      </div>
      <div class="modal-footer">
        <a href="educatorQuizSubSection1.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(id))%>" class="btn btn-success">Okay</a>
      </div>
    </div>
  </div>
</div>

<%
	if(request.getParameter("success")!=null){
		
%>
	<script>
		$(document).ready(function(){
			    $("#quesSuccess").modal("show");   
		});
	</script>	
<% 

	}else if(request.getParameter("error")!=null){
%>
	<script>
		$(document).ready(function(){
			    $("#quesError").modal("show");   
		});
	</script>	
<% 	
		
	}
%>
	<br><br>
	<h6 style="margin-left:3%;">*Note : Incase if you close/refresh/press back button without submitting question
		all your progress will be lost
	</h6>
	
    <form style="margin:5%" method="post" action="AddQuestion" 
    enctype="multipart/form-data" class="needs-validation" novalidate>
        <div class="form-group">
            <label for="ques">Enter question <span style="color:red;">*</span></label>
            <textarea class="form-control" id="ques" name="ques" rows="3" required></textarea>
            <div class="invalid-feedback">
        		Please Provide Question.
    		</div>
        </div>

        <div class="form-group">
            <label for="anyQuesAttachments">Are there any images attached with questions?</label>
            <select class="form-control" id="anyQuesAttachments" name="anyQuesAttachments" onchange="showQuesAttachments(this);">
              <option value="0">No</option>
              <option value="1">Yes</option>
            </select>
        </div>

        <div id="quesAttachmentsDiv" class="form-group" style="display:none;padding:5%;border:0.3px solid #80808052;border-radius: 10px 10px;">
            <label for="quesAttachments">Choose Attachments <span style="color:red;">*</span></label>
            <input type="file" class="form-control-file" id="quesAttachments" name="quesAttachments" multiple="true"  aria-describedby="quesAttachmentsHelp">
            <small id="quesAttachmentsHelp" class="form-text text-muted">*Note :-Selected files should be image only</small>
            <div class="invalid-feedback">
        		Please Select Some files.
    		</div>
        </div>

        <div class="form-group">
            <label for="marks">Enter the number of marks this question contains : <span style="color:red;">*</span></label>
            <input type="number" class="form-control" id="marks" name="marks" required min="1">
            <div class="invalid-feedback">
        		Please Enter Marks.
    		</div>
        </div>
        
        <div class="form-group">
            <label for="neg_marking_sel">Is there any negative marking?</label>
            <select class="form-control" id="neg_marking_sel" name="neg_marking_sel" onchange="showNegMarking(this);">
              <option value="0">No</option>
              <option value="1">Yes</option>
            </select>
        </div>
        
        <div class="form-group" id="neg_markingDiv" style="display:none">
            <label for="neg_marking">Enter the Negative Marking (in percentage) <span style="color:red;">*</span> : </label>
            <input type="number" class="form-control" id="neg_marking" name="neg_marking" min="1">
            <small class="form-text text-muted">Negative marking is in form of percentage that is 50% or 30% so enter value
            accordingly the value entered will be taken in percentage form</small>
            <div class="invalid-feedback">
        		Please Enter Negative Marking.
    		</div>
        </div>

		<%
			if(request.getParameter("timer").equals("2")){
		%>
		<div class="form-group">
            <label for="timer">Enter the time this question contains (in mins) <span style="color:red;">*</span> : </label>
            <input type="number" class="form-control" id="timer" name="timer" required min="1">
            <small id="timerHelp" class="form-text text-muted">
                Why i am getting this option because you had selected the timer for each question option
            </small>
            <div class="invalid-feedback">
        		Please Enter timer.
    		</div>
        </div>
		<%
			}
		%>
        

        <div class="form-group">
            <label for="category">Select The Type of Answers <span style="color:red;">*</span></label>
            <select class="form-control" id="category" name="category" required onchange="showCategory(this);">
              <option selected disabled value="">-- Select Category --</option>
              <option value="1">Choose the correct one type</option>
              <option value="2">Fill in the blank Type</option>
            </select>

            <small id="categoryHelp" class="form-text text-muted">
                Choose the correct one are the mcq type only option is correct.User can select only one option at for a particular question<br>
                Fill in the blank allows the user to enter the right answer which is evaluated against the Correct answer.
            </small>
            
            <div class="invalid-feedback">
        		Please Select An Option.
    		</div>
    		
        </div>
        
		<div class="form-group" id="fillBlMarkSchemeDiv" style="display:none;">
            <label for="fillBlMarkScheme">Select The Marking Scheme for Fill In The Blank <span style="color:red;">*</span></label>
            <select class="form-control" id="fillBlMarkScheme" name="fillBlMarkScheme" onchange="showFillBlSystemOption(this);">
              <option selected disabled value="">-- Select Scheme --</option>
              <option value="1">Manual Checking</option>
              <option value="0">System Checking</option>
            </select>

            <small id="fillBlMarkSchemeHelp" class="form-text text-muted">
                When Manual marking is selected then you have to check the answer given by yourself and allot marks<br>
                In case of system checking you need to enter keywords through which system will recognize the correct answer<br>
                <span style="font-weight: bold;">Note : Max a Student can type 50,000 characters in case of manual check and 
                negative marking does not works in manual check questions</span>
            </small>
            
            <div class="invalid-feedback">
        		Please Select An Option.
    		</div>
        </div>
		        

        <div class="form-group" style="display:none;" id="filBlAnsDiv">
            <label for="filBlAns">Enter the answer <span style="color:red;">*</span></label>
            <input type="text" class="form-control" id="filBlAns" name="filBlAns" aria-describedby="filBlAnsHelp">
            <small id="filBlAnsHelp" class="form-text text-muted">
                If there are multiple ways to give the answer then please seperate them by using '|' symbol without quotes
                for example :- say if the answer 'logical' and 'logical independance' both are correct then specify
                them as <b>logical | logical independance</b> (do not use | in your answers)
            </small>
            <div class="invalid-feedback">
        		Please Enter the Answer.
    		</div>
        </div>

        <div class="form-group" style="display:none;" id="no_of_optionsDiv">
            <label for="filBlAns">How many number of options are there? <span style="color:red;">*</span></label>
            <input type="number" class="form-control" id="no_of_options" name="no_of_options" 
            aria-describedby="no_of_optionsHelp" min="2" max="8" oninput="showMcqOptions(this.value)">
            <small id="no_of_optionsInvalid1" style="display: none;color:red;" >
                Min value value should be 2
            </small>

            <small id="no_of_optionsInvalid2" style="display: none;color:red;">
                Maximum options allowed are 8
            </small>

            <small id="no_of_optionsHelp" class="form-text text-muted">
                At most you can have 8 options and atleast there should be 2 options
            </small>
            <div class="invalid-feedback">
        		Please Enter Some Value.
    		</div>
        </div>

        
        <div class="form-group option-box" style="display:none;" id="optionsDiv1">
            <h5 align="center" style="margin-top:2%;">Option - 1 </h5>
            <div style="margin:3%">
            <div>
                <label for="type1">What type of content does this contains? <span style=color:red;>*</span></label>
                <select class="form-control" id="type1" name="type1" onchange="showActualOptions(this,1);">
                    <option  selected value="" disbaled>-- Select Content Type --</option>
                    <option value="img">Image</option>
                    <option value="textual">Textual</option>
                </select> 
                <div class="invalid-feedback">
        		Please Select An Option
    			</div> 
            </div>

            <br>
                <div style="display: none;" id="textOptionDiv1">
                    <label for="textOption1">Enter Option <span style="color:red;">*</span></label>
                    <textarea class="form-control" id="textOption1" name="textOption1"></textarea>
                    <div class="invalid-feedback">
        				Please Enter Some Value.
    				</div>
                </div>

                <div style="display: none;" id="imgOptionDiv1">
                    <label for="imgOption1">Choose image file <span style="color:red;">*</span></label>
                    <input type="file" class="form-control-file" id="imgOption1" name="imgOption1">
                    <div class="invalid-feedback">
        				Please Select Some Files.
    				</div>
                </div>
            </div>
        </div>

        <div class="form-group option-box" style="display:none;" id="optionsDiv2">
            <h5 align="center" style="margin-top:2%;">Option - 2</h5>
            <div style="margin:3%">
            <div>
                <label for="type2">What type of content does this option contains? <span style=color:red;>*</span></label>
                <select class="form-control" id="type2" name="type2" onchange="showActualOptions(this,2);">
                    <option value="" disbaled selected>-- Select Content Type --</option>
                    <option value="img">Image</option>
                    <option value="textual">Textual</option>
                </select>  
                <div class="invalid-feedback">
        		Please Select An Option
    			</div> 
            </div>

           <br>
            <div style="display: none;" id="textOptionDiv2">
                <label for="textOption2">Enter option <span style="color:red;">*</span></label>
                <textarea class="form-control" id="textOption2" name="textOption2"></textarea>
                <div class="invalid-feedback">
        				Please Enter Some Value.
    				</div>
            </div>

            <div style="display: none;" id="imgOptionDiv2">
                <label for="imgOption2">Choose image file <span style="color:red;">*</span></label>
                <input type="file" class="form-control-file" id="imgOption2" name="imgOption2">
                <div class="invalid-feedback">
        				Please Select Some Files.
    			</div>
            </div>
        </div>
        </div>

        <div class="form-group option-box" style="display:none;" id="optionsDiv3">
            <h5 align="center" style="margin-top:2%;">Option - 3</h5>
            <div style="margin:3%">
            
            <div>
                <label for="type3">What type of content does this option contains? <span style=color:red;>*</span></label>
                <select class="form-control" id="type3" name="type3" onchange="showActualOptions(this,3);">
                    <option value="" disbaled selected>-- Select Content Type --</option>
                    <option value="img">Image</option>
                    <option value="textual">Textual</option>
                </select>
                <div class="invalid-feedback">
        		Please Select An Option
    			</div>   
            </div>

            <br>
            <div style="display: none;" id="textOptionDiv3">
                <label for="textOption3">Enter option <span style="color:red;">*</span></label>
                <textarea class="form-control" id="textOption3" name="textOption3"></textarea>
                <div class="invalid-feedback">
        				Please Enter Some Value.
    				</div>
            </div>

            <div style="display: none;" id="imgOptionDiv3">
                <label for="imgOption3">Choose image file <span style="color:red;">*</span></label>
                <input type="file" class="form-control-file" id="imgOption3" name="imgOption3">
                <div class="invalid-feedback">
        				Please Select Some Files.
    			</div>
            </div>
            </div>
        </div>

        <div class="form-group option-box" style="display:none;" id="optionsDiv4">
            <h5 align="center" style="margin-top:2%;">Option - 4</h5>
            <div style="margin:3%">
            <div>
                <label for="type4">What type of content does this option contains? <span style=color:red;>*</span></label>
                <select class="form-control" id="type4" name="type4" onchange="showActualOptions(this,4);">
                    <option value="" disbaled selected>-- Select Content Type --</option>
                    <option value="img">Image</option>
                    <option value="textual">Textual</option>
                </select>  
                <div class="invalid-feedback">
        		Please Select An Option
    			</div> 
            </div>

            <br>
            <div style="display: none;" id="textOptionDiv4">
                <label for="textOption4">Enter option <span style="color:red;">*</span></label>
                <textarea class="form-control" id="textOption4" name="textOption4"></textarea>
                <div class="invalid-feedback">
        				Please Enter Some Value.
    				</div>
            </div>

            <div style="display: none;" id="imgOptionDiv4">
                <label for="imgOption4">Choose image file <span style="color:red;">*</span></label>
                <input type="file" class="form-control-file" id="imgOption4" name="imgOption4">
                <div class="invalid-feedback">
        				Please Select Some Files.
    			</div>
            </div>
            </div>
        </div>

        
        <div class="form-group option-box" style="display:none;" id="optionsDiv5">
            <h5 align="center" style="margin-top:2%;">Option - 5</h5>
            <div style="margin:3%">
            <div>
                <label for="type5">What type of content does this option contains? <span style=color:red;>*</span></label>
                <select class="form-control" id="type5" name="type5" onchange="showActualOptions(this,5);">
                    <option value="" disbaled selected>-- Select Content Type --</option>
                    <option value="img">Image</option>
                    <option value="textual">Textual</option>
                </select>  
                <div class="invalid-feedback">
        		Please Select An Option
    			</div> 
            </div>

            <br>
            <div style="display: none;" id="textOptionDiv5">
                <label for="textOption5">Enter option <span style="color:red;">*</span></label>
                <textarea class="form-control" id="textOption5" name="textOption5"></textarea>
                <div class="invalid-feedback">
        				Please Enter Some Value.
    				</div>
            </div>

            <div style="display: none;" id="imgOptionDiv5">
                <label for="imgOption5">Choose image file <span style="color:red;">*</span></label>
                <input type="file" class="form-control-file" id="imgOption5" name="imgOption5">
                <div class="invalid-feedback">
        				Please Select Some Files.
    			</div>
            </div>
            </div>
        </div>

        
        <div class="form-group option-box" style="display:none;" id="optionsDiv6">
            <h5 align="center" style="margin-top:2%;">Option - 6</h5>
            <div style="margin:3%">
            <div>
                <label for="type6">What type of content does this option contains? <span style=color:red;>*</span></label>
                <select class="form-control" id="type6" name="type6" onchange="showActualOptions(this,6);">
                    <option value="" disbaled selected>-- Select Content Type --</option>
                    <option value="img">Image</option>
                    <option value="textual">Textual</option>
                </select>  
                <div class="invalid-feedback">
        		Please Select An Option
    			</div> 
            </div>

            <br>
            <div style="display: none;" id="textOptionDiv6">
                <label for="textOption6">Enter option <span style="color:red;">*</span></label>
                <textarea class="form-control" id="textOption6" name="textOption6"></textarea>
                <div class="invalid-feedback">
        				Please Enter Some Value.
    				</div>
            </div>

            <div style="display: none;" id="imgOptionDiv6">
                <label for="imgOption6">Choose image file <span style="color:red;">*</span></label>
                <input type="file" class="form-control-file" id="imgOption6" name="imgOption6">
                <div class="invalid-feedback">
        				Please Select Some Files.
    			</div>
            </div>
            </div>
        </div>

        
        <div class="form-group option-box" style="display:none;" id="optionsDiv7">
            <h5 align="center" style="margin-top:2%;">Option - 7</h5>
            <div style="margin:3%">
            <div>
                <label for="type7">What type of content does this option contains? <span style=color:red;>*</span></label>
                <select class="form-control" id="type7" name="type7" onchange="showActualOptions(this,7);">
                    <option value="" disbaled selected>-- Select Content Type --</option>
                    <option value="img">Image</option>
                    <option value="textual">Textual</option>
                </select>  
                <div class="invalid-feedback">
        		Please Select An Option
    			</div> 
            </div>

            <br>
            <div style="display: none;" id="textOptionDiv7">
                <label for="textOption7">Enter option <span style="color:red;">*</span></label>
                <textarea class="form-control" id="textOption7" name="textOption7"></textarea>
                 <div class="invalid-feedback">
        				Please Enter Some Value.
    				</div>
            </div>

            <div style="display: none;" id="imgOptionDiv7">
                <label for="imgOption7">Choose image file <span style="color:red;">*</span></label>
                <input type="file" class="form-control-file" id="imgOption7" name="imgOption7">
                 <div class="invalid-feedback">
        				Please Select Some Files.
    			</div>
            </div>
            </div>
        </div>

        
        <div class="form-group option-box" style="display:none;" id="optionsDiv8">
            <h5 align="center" style="margin-top:2%;">Option - 8</h5>
            <div style="margin:3%">
            <div>
                <label for="type8">What type of content does this option contains? <span style=color:red;>*</span></label>
                <select class="form-control" id="type8" name="type8" onchange="showActualOptions(this,8)">
                    <option value="" disbaled selected>-- Select Content Type --</option>
                    <option value="img">Image</option>
                    <option value="textual">Textual</option>
                </select>
                 <div class="invalid-feedback">
        		Please Select An Option
    			</div>   
            </div>

            <br>
            <div style="display: none;" id="textOptionDiv8">
                <label for="textOption8">Enter option <span style="color:red;">*</span></label>
                <textarea class="form-control" id="textOption8" name="textOption8"></textarea>
                <div class="invalid-feedback">
        				Please Enter Some Value.
    				</div>
            </div>

            <div style="display: none;" id="imgOptionDiv8">
                <label for="imgOption8">Choose image file <span style="color:red;">*</span></label>
                <input type="file" class="form-control-file" id="imgOption8" name="imgOption8">
                <div class="invalid-feedback">
        				Please Select Some Files.
    			</div>
            </div>
        </div>
        </div>

        <div class="form-group option-box" style="display:none;" id="optionsAns">
            <h5 align="center" style="margin-top:2%;">Select Correct Ans</h5>
            <div style="margin:3%">
            <div>
                <label for="optans">Which of the option is correct? <span style="color:red;">*</span></label>
                <select class="form-control" id="optans" name="optans">
                    <option value="" disabled selected>-- Select Correct Option --</option>
                    <option value="1" disabled>Option - 1</option>
                    <option value="2" disabled>Option - 2</option>
                    <option value="3" disabled>Option - 3</option>
                    <option value="4" disabled>Option - 4</option>
                    <option value="5" disabled>Option - 5</option>
                    <option value="6" disabled>Option - 6</option>
                    <option value="7" disabled>Option - 7</option>
                    <option value="8" disabled>Option - 8</option>
                </select>  
                <div class="invalid-feedback">
        				Please Select an option
    			</div>
            </div>
        </div>
        </div>
        
        
        <div class="form-group">
            <label for="exp_sel">Choose the type of explanation <span style="color:red;">*</span> : </label>
            <select class="form-control" id="exp_sel" name="exp_sel" onchange="showExp(this);" required>
              <option value="" selected disabled>-- Select Type --</option>
              <option value="text">Text</option>
              <option value="link">Link</option>
            </select>
            <div class="invalid-feedback">
        				Please Select an option
    			</div>
        </div>
        
        <div class="form-group" id="expDiv">
        	<div id="expLinkDiv" style="display:none;">
        		<label for="expLink">Enter Link <span style="color:red;">*</span> : </label>
            	<input type="text" class="form-control" id="expLink" name="expLink">
        	</div>
            
            <div id="expTextDiv" style="display:none;">
        		<label for="expText">Enter Explanation <span style="color:red;">*</span> : </label>
            	<textarea class="form-control" id="expText" name="expText"></textarea>
            	
        	</div>
        	<div class="invalid-feedback">
        			Please Enter Some Value
    			</div>
        </div>
        
<div class="modal fade" id="leave" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-body">
        Are you sure you want to leave? All Progress made will be lost 
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">No</button>
        <a class="btn btn-primary" href="educatorQuizSubSection1.jsp?qzid=<%=new DataHiding().encodeMethod(String.valueOf(id))%>">Yes</a>
      </div>
    </div>
  </div>
</div>

        <input type="submit" value="Submit" class="btn btn-primary m-1">
        <button type="button" class="btn btn-secondary" data-toggle="modal" data-target="#leave">Cancel</button>
        
	     <input type="hidden" value="<%=id%>" name="id">
</form>
</body>

<script src="javascript/script.js"></script>
<script>
//to check that Quiz is locked or not
function getQuizLockStatus(id) {
	$.post("CheckQuizLockStatus", {
		quizid : id
	}, function(data, status) {
		if (data == "lock" && status == 'success') {
			$("#quizLock").modal("show");
		}
	});
}

</script>

<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>