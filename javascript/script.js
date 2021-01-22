//selects the role and login as per the role
function loginSelect() {
	let role = document.getElementById("role").value;
	if(role == "admin"){
		document.forms[0].setAttribute('action','adminLogin');
		document.forms[0].submit();
	}else if(role == 'educator'){
		document.forms[0].setAttribute('action','EducatorLogin');
		document.forms[0].submit();
	}else if(role == 'student'){
		document.forms[0].setAttribute('action','StudentLogin');
		document.forms[0].submit();
	}
}



//for admin navbar
function adminOpenNav() {
	document.getElementById("adminSidebar").style.width = "250px";
}

function adminCloseNav() {
     document.getElementById("adminSidebar").style.width = "0";
}

//for educator navbar
function educatorOpenNav() {
    document.getElementById("educatorSidebar").style.width = "250px";
}

function educatorCloseNav() {
    document.getElementById("educatorSidebar").style.width = "0";
}

//JavaScript for disabling form submissions if there are invalid fields
    (function() {
      'use strict';
      window.addEventListener('load', function() {
        // Fetch all the forms we want to apply custom Bootstrap validation styles to
        var forms = document.getElementsByClassName('needs-validation');
        // Loop over them and prevent submission
        var validation = Array.prototype.filter.call(forms, function(form) {
          form.addEventListener('submit', function(event) {
            if (form.checkValidity() === false) {
              event.preventDefault();
              event.stopPropagation();
            }
            form.classList.add('was-validated');
          }, false);
        });
      }, false);
    })();

    //shows password when we have password form
function showPwd(ele){
  
  let x = document.getElementById("pwd");
  console.log(x);
  if (x.type === "password") {
    ele.innerHTML = "Hide Password";
    x.type = "text";
  } else {
    ele.innerHTML = "Show Password";
    x.type = "password";
  }
}

/*It is for video section*/
//to toggle the add video playlist modal
function showAddVideoPlaylistModal() {
	$("#addPlaylistModal").modal("show");
	document.forms[0].className="needs-validation";
	document.forms[0].reset();
}

//clear the form on hide for add videos
$('#addVideo_modal').on('hide.bs.modal',function () {
	document.forms[0].className="needs-validation";
	document.forms[0].reset();
})

//for triggering the edit video playlist modal
function triggerEditVideoPlaylistModal(title,desp,id){
	document.forms[1].reset();
	document.getElementById("thumbnailDiv").style.display="none";
	document.getElementById("editThumbnail").removeAttribute("required");
	let ele = document.getElementById("editVideoPlaylistModal");
	let textarea = ele.getElementsByTagName('textarea');
	console.log(desp);
	textarea[0].value = title;
	textarea[1].value = desp;
	ele.getElementsByTagName('input')[1].value = id;
	$("#editVideoPlaylistModal").modal("show");
}

//for triggering the delete video playlist modal
function triggerDeleteVideoPlaylistModal(id){
	document.forms[2].reset();
	let ele = document.getElementById("deleteVideoPlaylistModal");
	ele.getElementsByTagName('input')[0].value = id;
	$("#deleteVideoPlaylistModal").modal("show");
}

//for edit video modal set the values
function editVideoModal(title,desp,link,vid){
	var ele = document.getElementById("editVideoModal");
	let textarea = ele.getElementsByTagName('textarea');
	let input = ele.getElementsByTagName('input');
	
	textarea[0].value = title;
	textarea[1].value=desp;
	
	input[1].value = vid;
	input[0].value = link;
	$("#editVideoModal").modal("show");
}

//sets the values back to null for edit video modal
$('#editVideoModal').on('hide.bs.modal',function () {
	document.forms[2].className="needs-validation";
	document.forms[2].reset();
})

//set the value back to null
$('#confirmDeleteModal').on('hide.bs.modal',function () {
	document.getElementById("Dvid").value="";
})

//shows confirm modal
function deleteVideoConfirm(vid){
	document.getElementById("Dvid").value=vid;
	 $("#confirmDeleteModal").modal("show");
}

//sets the src attribute to null so that video stops
$('#showvideo').on('hide.bs.modal',function () {
	$('#showvideo iframe').attr('src',"");
})


//shows the video as the modal triggers
function showVideofunc(link){  
     $("#iframeShowVideo").attr("src",link+"?rel=0&amp;showinfo=0");  
	 $("#showvideo").modal("show");
}

//for checking the extension of file if valid then true else false
function fileValidationForImageFiles(ele) { 
	var fileInput = 
		ele; 
	
	var filePath = fileInput.value; 

	// Allowing file type 
	var allowedExtensions = 
			/(\.jpg|\.jpeg|\.png)$/i; 
	
	if (!allowedExtensions.exec(filePath)) { 
		
		fileInput.value = ''; 
		return false; 
	} 
	else 
	{ 
		return true; 
	} 
}

/*This is for Notes*/
//for showing edit notes list
function triggerEditNoteslistModal(title,desp,id){
	document.forms[1].reset();
	document.forms[1].className="needs-validation";
	let ele = document.getElementById("editNoteslistModal");
	let textarea = ele.getElementsByTagName('textarea');
	console.log(desp);
	textarea[0].value = title;
	textarea[1].value = desp;
	ele.getElementsByTagName('input')[0].value = id;
	$("#editNoteslistModal").modal("show");
}

//for showing the delete notes modal
function triggerDeleteNoteslistModal(id){
	document.forms[2].reset();
	let ele = document.getElementById("deleteNoteslistModal");
	ele.getElementsByTagName('input')[0].value = id;
	$("#deleteNoteslistModal").modal("show");
}

//set the value back to null
$('#confirmDeleteNoteModal').on('hide.bs.modal',function () {
	document.getElementById("Dnid").value="";
})

//shows confirm modal
function deleteNoteConfirm(nid){
	document.getElementById("Dnid").value=nid;
	 $("#confirmDeleteNoteModal").modal("show");
}

//add note modal reset
$('#addNote_modal').on('hide.bs.modal',function () {
	document.forms[0].reset();
	document.forms[0].className="needs-validation";
})

/*For Assignments*/
//add assignment list modal show
function showAddAssignmentListModal() {
	$("#addAssignmentlistModal").modal("show");
	document.forms[0].className="needs-validation";
	document.forms[0].reset();
}

//for edit assignment list modal show
function triggerEditAssignmentlistModal(desp,id){
	document.forms[1].reset();
	document.forms[1].className="needs-validation";
	let ele = document.getElementById("editAssignmentlistModal");
	let textarea = ele.getElementsByTagName('textarea');
	console.log(desp);
	textarea[0].value = desp;
	ele.getElementsByTagName('input')[0].value = id;
	$("#editAssignmentlistModal").modal("show");
}

//for delete assignment list modal
function triggerDeleteAssignmentlistModal(id){
	document.forms[2].reset();
	let ele = document.getElementById("deleteAssignmentlistModal");
	ele.getElementsByTagName('input')[0].value = id;
	$("#deleteAssignmentlistModal").modal("show");
}



//for grading the assignment
$('#AltMarksModal').on('hide.bs.modal',function () {
	document.forms[0].reset();
	document.getElementById("returnFilesDiv").style.display = "none";
	document.getElementById("returnFiles").removeAttribute("required");
})


function AltMarksModalShow(asgId,stdId){
	document.getElementById("stdId").value=stdId;
	 $("#AltMarksModal").modal("show");
	 
}

function returnFilesFunc(ele){
	if(ele.value == "1"){
		document.getElementById("returnFilesDiv").style.display = "";
		document.getElementById("returnFiles").setAttribute("required","true");
		document.getElementById("gradeAssignmentForm").setAttribute("onsubmit","showSpinner(this);");
		
	}else{
		document.getElementById("returnFilesDiv").style.display = "none";
		document.getElementById("returnFiles").removeAttribute("required");
		document.getElementById("gradeAssignmentForm").removeAttribute("onsubmit");
	}
}

//for trigerring the edit quiz modal
function triggerEditQuizlistModal(title,desp,id){
	document.forms[1].reset();
	let ele = document.getElementById("editQuizlistModal");
	let textarea = ele.getElementsByTagName('textarea');
	console.log(desp);
	textarea[0].value = title;
	textarea[1].value = desp;
	ele.getElementsByTagName('input')[0].value = id;
	$("#editQuizlistModal").modal("show");
}

//for trigerring the delete quiz modal
function triggerDeleteQuizlistModal(id){
	document.forms[2].reset();
	let ele = document.getElementById("deleteQuizlistModal");
	ele.getElementsByTagName('input')[0].value = id;
	$("#deleteQuizlistModal").modal("show");
}

var x;

//for full screen
var elem; 

var wt_timer;


/* Function to open fullscreen mode */
function openFullscreen(elem1,type,trigger,timer) {
elem = elem1;

  if (elem.requestFullscreen) {
	  console.log("hii chrome");
	  console.log(trigger);
      if(trigger == 0){
    	if(type == 1)
    		setTimer(1);
    	else if(type == 2)
    		setOverAllTimer(timer);
        trigger++;
      }else{
        document.getElementById("warning-alertDiv").style.display = "none";
          clearInterval(wt_timer);
      }
      document.getElementById("instructions").style.display = "none";
      document.getElementById("quizMainStudent").style.display ="";
    elem.requestFullscreen();
    
  } else if (elem.mozRequestFullScreen) { /* Firefox */
	  console.log("hii me");
      if(trigger == 0){
    	  
    	  if(type == 1)
      		setTimer(1);
      	else if(type == 2)
      		setOverallTimer();
        trigger++;
      }else{
        document.getElementById("warning-alertDiv").style.display = "none";
          clearInterval(wt_timer);
      }
      document.getElementById("instructions").style.display = "none";
      document.getElementById("quizMainStudent").style.display ="";

  elem.mozRequestFullScreen();
  } else if (elem.webkitRequestFullscreen) { /* Chrome, Safari & Opera */
	  console.log("hii Firefox");
      if(trigger == 0){
    	  
    	  if(type == 1)
      		setTimer(1);
      	else if(type == 2)
      		setOverallTimer(timer);
        trigger++;
      }else{
        document.getElementById("warning-alertDiv").style.display = "none";
          clearInterval(wt_timer);
      }
      document.getElementById("instructions").style.display = "none";
      document.getElementById("quizMainStudent").style.display ="";
      elem.webkitRequestFullscreen();
  } else if (elem.msRequestFullscreen) { /* IE/Edge */
	  console.log("hii IE");
      if(trigger == 0){
    	  
    	  if(type == 1)
      		setTimer(1);
      	else if(type == 2)
      		setOverallTimer();
        trigger++;
      }else{
          clearInterval(wt_timer);
          document.getElementById("warning-alertDiv").style.display = "none";
      }
    document.getElementById("instructions").style.display = "none";
    document.getElementById("quizMainStudent").style.display ="";

    elem.msRequestFullscreen();
  }
}

//Warning timer for exiting the full screen
function warningTimer(){
    let wt = 10;
    
    // Update the count down every 1 second
    wt_timer = setInterval(function() {
        if(wt != 10)
            document.getElementById("warning-trigger").innerHTML = wt;
        wt--;
      if (wt == 0) {
        clearInterval(wt_timer);
        document.getElementById("dq").submit();
      }
    }, 1000);
}


//shows the clear section
function showClear(current){
	console.log("hii");
	console.log(document.getElementById("clear"+current));
    document.getElementById("clear"+current).style.display="";
}

//hides the clear section
function hideClear(current){
    document.getElementById("clear"+current).style.display="none";
}

//clear the radio inputs current div
function clearFunc(current){
    let input = document.getElementById("mainQuesDiv"+current).getElementsByTagName("input");
    console.log("hii");
    for(let i=0;i<input.length;i++){
        if(input[i].type == 'radio'){
            input[i].checked = false;
        }
    }
    hideClear(current);
}

//shows the next question
function nextFunc(currentDiv){
    let nextDiv = document.getElementById("next"+currentDiv).value;
    console.log("next Div :- "+nextDiv);
    if(nextDiv == '-1'){
        document.getElementById("QuizOverTrigger").click();
        clearInterval(x);
    }else{
        document.getElementById("mainQuesDiv"+currentDiv).style.display="none";
        document.getElementById("mainQuesDiv"+nextDiv).style.display="";
        setTimer(nextDiv);
    }
}

//sets the timer for each question
function setTimer(count){
	
    clearInterval(x);
    
    if(count == '1'){
		document.getElementById("mainQuesDiv1").style.display = "";
	}
    console.log(document.getElementById("timer"+count));
    // Set the date we're counting down to
    let countDownDate = new Date();
    countDownDate.setMinutes(countDownDate.getMinutes()+Number(document.getElementById("timer"+count).value));
    
    // Update the count down every 1 second
      x = setInterval(function() {
    
      // Get today's date and time
      var now = new Date().getTime();
        
      // Find the distance between now and the count down date
      var distance = countDownDate - now;
        
      // Time calculations for days, hours, minutes and seconds
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);
        
      if(seconds < 10)
      	document.getElementById("timerDisplay"+count).innerHTML = "Time Remaining : "+minutes+":0"+seconds;
      else 
    	  document.getElementById("timerDisplay"+count).innerHTML = "Time Remaining : "+minutes+":"+seconds;
    	  
        
      // If the count down is over, write some text 
      if (distance < 1) {
        clearInterval(x);
        nextFunc(count);
      }
    }, 1000);
}

function setOverAllTimer(timer){
    // Set the date we're counting down to
    let countDownDate = new Date();
    countDownDate.setMinutes(countDownDate.getMinutes()+Number(timer));
    
    // Update the count down every 1 second
      var y = setInterval(function() {
    
      // Get today's date and time
      var now = new Date().getTime();
        
      // Find the distance between now and the count down date
      var distance = countDownDate - now;
        
      // Time calculations for days, hours, minutes and seconds
      var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
      var seconds = Math.floor((distance % (1000 * 60)) / 1000);
        
      // Output the result in an element with id="demo"
      if(seconds < 10)
      	document.getElementById("timerDisplay").innerHTML = "Time Remaining : "+minutes+":0"+seconds;
      else 
    	  document.getElementById("timerDisplay").innerHTML = "Time Remaining : "+minutes+":"+seconds;
    	  
        
      // If the count down is over, write some text 
      if (distance < 1) {
        clearInterval(y);
        document.getElementById("QuizOverTrigger").click();
      }
    }, 1000);
}



//show question attachment div 
function showQuesAttachments(ele){
    if(ele.value=="1"){
        document.getElementById("quesAttachmentsDiv").style.display="";
        document.getElementById("quesAttachments").setAttribute('required','true');
    }else{
        document.getElementById("quesAttachmentsDiv").style.display="none";
        document.getElementById("quesAttachments").removeAttribute('required');
        document.getElementById("quesAttachments").value="";
    }
}

//reset explanation if type is changed
function resetExp(){
		let div = document.getElementById("expDiv").getElementsByTagName("div");
		let ele;
		
		for(let i=0;i<div.length;i++){
			div[i].style.display ="none";
		}
		
		
		document.getElementById("expText").value="";
		document.getElementById("expLink").value="";
		
}

//show explanation when option is selected
function showExp(ele){
	resetExp();
	if(ele.value == 'text'){
		document.getElementById("expTextDiv").style.display="";
		document.getElementById("expText").setAttribute('required','true');
		
	}else{
		document.getElementById("expLinkDiv").style.display="";
		document.getElementById("expLink").setAttribute('required','true');	
	}
}

//show neg marking div if option is selected
function showNegMarking(ele){
	if(ele.value == "1"){
		document.getElementById("neg_markingDiv").style.display = "";
		document.getElementById("neg_marking").setAttribute('required','true');
		
	}else{
		document.getElementById("neg_markingDiv").style.display = "none";
		document.getElementById("neg_marking").removeAttribute('required');
		document.getElementById("neg_marking").value="";
	}
	
}

//shows the category when option is changed
function showCategory(ele){
    if(ele.value == "2"){
        resetMcqOptionsDiv();

        document.getElementById("fillBlMarkSchemeDiv").style.display="";
        document.getElementById("fillBlMarkScheme").setAttribute('required','true');
        
        document.getElementById("no_of_optionsDiv").style.display="none";
        document.getElementById("no_of_options").removeAttribute('required');
        document.getElementById("no_of_options").value="";
        
    }else{
    	document.getElementById("fillBlMarkSchemeDiv").style.display="none";
        document.getElementById("fillBlMarkScheme").removeAttribute('required');
        resetFillBl();
        
        document.getElementById("no_of_optionsDiv").style.display="";
        document.getElementById("no_of_options").setAttribute('required','true');
    }
}

//shows fill in the blank div when marking scheme is computer based
function showFillBlSystemOption(ele){
	if(ele.value == "0"){
		document.getElementById("filBlAnsDiv").style.display="";
        document.getElementById("filBlAns").setAttribute('required','true');
	}else{
		resetFillBl();
	}
}

//resets the fill up blank div
function resetFillBl(){
	document.getElementById("filBlAnsDiv").style.display="none";
    document.getElementById("filBlAns").removeAttribute('required');
    document.getElementById("filBlAns").value="";
}

//reset the mcq options
function resetMcqOptionsDiv(){
    for(let i=1;i<=8;i++){
        let ele = document.getElementById("optionsDiv"+i);
        ele.style.display="none";

        let input = ele.getElementsByTagName("input");
        let select = ele.getElementsByTagName("select");

        for(let j=0;j<input.length;j++){
            input[j].value="";
            if(input[j].hasAttribute('required')){
                input[j].removeAttribute('required');
            }
        }

        for(let k=0;k<select.length;k++){
            if(select[k].hasAttribute('required')){
                select[k].removeAttribute('required');
            }

            select[k].selectedIndex=0;
        }
    }

    document.getElementById("optionsAns").style.display="none";
    let opt = document.getElementById("optans").options;
    console.log(opt);
    if(document.getElementById("optans").hasAttribute('required')){
        document.getElementById("optans").removeAttribute('required');
        document.getElementById("optans").selectedIndex=0;
    }

    
    for(let i=0;i<opt.length;i++){
        opt[i].setAttribute('disabled','true');
    }
}

//show mcq div
function showMcqOptions(value){
    resetMcqOptionsDiv();
    document.getElementById("no_of_optionsInvalid1").style.display="none";
    document.getElementById("no_of_optionsInvalid2").style.display="none";

    if(value < 2){
        document.getElementById("no_of_optionsInvalid1").style.display="";
        
    }else if(value > 8){
        document.getElementById("no_of_optionsInvalid2").style.display="";
        
    }else{
        for(let i=1;i<=value;i++){
            document.getElementById("optionsDiv"+i).style.display="";
            document.getElementById("type"+i).setAttribute('required','true');
        }
        document.getElementById("optionsAns").style.display="";
        document.getElementById("optans").setAttribute('required','true');

        let opt = document.getElementById("optans").options;

        for(let i=1;i<=value;i++){
            opt[i].removeAttribute('disabled');
        }
    }
}

//show actual options by resetting the things
function showActualOptions(ele,value){
    if(ele.value == "img"){
        document.getElementById("textOptionDiv"+value).style.display="none";
        document.getElementById("textOption"+value).removeAttribute('required');

        document.getElementById("imgOptionDiv"+value).style.display="";
        document.getElementById("imgOption"+value).setAttribute('required','true');
    }else{
        document.getElementById("imgOptionDiv"+value).style.display="none";
        document.getElementById("imgOption"+value).removeAttribute('required');

        document.getElementById("textOptionDiv"+value).style.display="";
        document.getElementById("textOption"+value).setAttribute('required','true');
    }
}

