
<%
    response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("std_id")!=null){
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<title>EduHITec | Connecting Students and Educator</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body onload="active();">
	<%@include file="student_menu.html"%>
	
	<div class="container-fluid">
        
         <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
            
            <div class="carousel-inner">
                <div class="carousel-item active">
                    <img style="height: 500px;" src="images/Love to learn.jpg" class="d-block w-100" alt="Loading">
                </div>
                <div class="carousel-item">
                    <img style="height: 500px;" src="images/Make things happen.jpg" class="d-block w-100" alt="Loading">
                </div>
            </div>
        </div>


        

        <div class="student-home-main">
            <div class="student-home-header header text-center" style="font-family: 'Dancing Script', cursive">
                Learning Is Earning
            </div>
        </div>



        <div class="student-home-card-deck card-deck">
            <div class="card">
                <img src="images/student-home-1.jpg" class="card-img-top" alt="Loading">
                <div class="card-body">
                    <h5 class="card-title">Learn anything, anywhere, anytime</h5>
                    <p class="card-text">Can access any course of your choice without any constraint. And related video
                        lectures for better understanding.
                </div>
            </div>
            <div class="card">
                <img src="images/student-home-2.jpg" class="card-img-top" alt="Loading">
                <div class="card-body">
                    <h5 class="card-title">Test your knowledge</h5>
                    <p class="card-text">Attempt quizes/tests to judge yourself and Revise the topics as many time as
                        you want. Also check out your report and your profile</p>
                </div>
            </div>
            <div class="card">
                <img src="images/student-home-3.jpg" class="card-img-top" alt="Loading">
                <div class="card-body">
                    <h5 class="card-title">Get your notes</h5>
                    <p class="card-text">Get your course content like Notes, Assignments in pdf etc. format and video
                        lecture playlists of your favorite educator</p>
                </div>
            </div>
        </div>


    </div>
</body>
<script src="javascript/script.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</html>
<%
	}else{
		response.sendRedirect("student_login.jsp");
	}
%>