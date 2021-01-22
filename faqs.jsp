<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css"
        integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
    <link href="https://fonts.googleapis.com/css2?family=Dancing+Script:wght@562&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | FAQS</title>
</head>
<body onload="active();">
	<%@include file="index_menu.html"%>
	 
	 <!-- Contributed By Kritika Rana -->
	 
	<div class="container-fluid">
        <div class="faq-header text-center" style="background: url(images/cover-photo_1.jpg);">
            <h1>Frequently Asked Questions</h1>
        </div>

        
        <div class="faq-main">
            
            <button class="faq-button faq-col col">How to login as admin/educator/student ?</button>
            <div class="faq-content">
                <br>
                <p class="faq-p">Following are few simple steps to login :-</p>
                <p class="faq-p">
                	<ol>
                    	<li class="faq-li">Just click on the "Login" which is given on the top(navigation bar).</li>
                    	<li class="faq-li">Enter your email and password.</li>
                    	<li class="faq-li">Select your role i.e, Admin/Educator/Student. </li>
                    	<li class="faq-li">Enter/Submit.</li>
                	</ol>
                </p>
            </div>
            <button class="faq-button faq-col col">What are the authorities of Admin ?</button>
            <div class="faq-content">
                <br>
                <p class="faq-p">Admin can add/update/remove the Educator, Student and courses or subject.
                    <br>These authorities are only and only provided to the Admin</p>
            </div>
            <button class="faq-button faq-col col">What is the role of Student ?</button>
            <div class="faq-content">
                <br>
                <p class="faq-p">Following are the roles of a student :-</p>
                <p class="faq-p">
                <ol>
                    <li class="faq-li"> Student can begin any course of choice with a ease without any constraint.</li>
                    <li class="faq-li"> Student can attempt Quiz and can check out their grades.</li>
                    <li class="faq-li"> Student View assignments.</li>
                    <li class="faq-li"> Student can view/download the lecture notes and can view the related videos of a subject
                    </li>
                    <li class="faq-li">Student can also give a feedback or ranking to a particular quiz after attempting it.
                    </li>
                </ol>
                </p>
            </div>
            <button class="faq-button faq-col col">What are the Role and resposibility of a Educator ?</button>
            <div class="faq-content">
                <br>
                <p class="faq-p">Following are the roles and responsibilities of an educator :-</p>
                <p class="faq-p">
                <ol>
                    <li class="faq-li">Educator have the responsibility to add the course content like notes, video tutorials
                        and assignments.</li>
                    <li class="faq-li">Educator have to map Quiz againts standards.</li>
                    <li class="faq-li">Educator can show/generate student's performance report.</li>
                </ol>
                </p>
            </div>
            <button class="faq-button faq-col col">Can I(student) view the course content again and again ?</button>
            <div class="faq-content">
                <br>
                <p class="faq-p">
                    Yes, Student can re-access the course content. And can revise anything at anytime.
                </p>
            </div>
            <button class="faq-button faq-col col">Are courses alloted to educators or they can upload contents of any subject
                ? </button>
            <div class="faq-content">
                <br>
                <p class="faq-p">
                    No, none of the educator is alloted to a particular subject.
                    <br> Educators are free to upload the notes,
                    assignments, practice test, and video lectures of the subjects of their choice.
                </p>
            </div>
        </div>
    </div>
    <%@include file="index_footer.html"%>
</body>
<script type="text/javascript">
function active(){
	document.getElementById("faqs").className = "nav-item active";
}

var coll = document.getElementsByClassName("col");
var i;

for (i = 0; i < coll.length; i++) {
    coll[i].addEventListener("click", function () {
        this.classList.toggle("active");
        var content = this.nextElementSibling;
        if (content.style.maxHeight) {
            content.style.maxHeight = null;
        } else {
            content.style.maxHeight = content.scrollHeight + "px";
        }
    });
}
</script>
<script src="https://getbootstrap.com/docs/4.0/assets/js/vendor/holder.min.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</html>