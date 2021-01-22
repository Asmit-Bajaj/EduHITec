<%
    response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%

if(session.getAttribute("edu_id")!=null){
	
%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet" href="css/style.css">

<title>EduHITec | Connecting Students and Educator</title>
</head>
<body>
	 <%@include file="educator_menu.html"%>

<div class="container-fluid">
        <div id="carouselExampleIndicators " class="carousel slide" data-ride="carousel">
            <div class="carousel-inner">
                <div class="carousel-item active educator-img-container educator_main_image">
                    <img src="images/Educator_home.jpg" class="d-block w-100" alt="Loading">
                </div>
            </div>
        </div>
        <div class="educator-home-card-deck card-deck">
            <div class="card">
                <div class="educator-home-main">
                    <div class="educator-home-header header text-center" style="background-color: rgb(201, 247, 201);">
                        Inspire, motivate and change the lives of young generation by educating them.
                    </div>
                </div>
            </div>
            <div class="card">
                <div class="educator-home-main">
                    <div class="educator-home-header header text-center" style="background-color: rgb(251, 211, 255);">
                        Educator is always veridical. Be true to yourself and to your students.
                    </div>
                </div>
            </div>
            <div class="card">
                <div class="educator-home-main">
                    <div class="educator-home-header header text-center" style="background-color: rgb(201, 247, 231);">
                        The one who has developed the art of teaching, always have the motivation of learning.
                    </div>
                </div>
            </div>
            <div class="card">
                <div class="educator-home-main">
                    <div class="educator-home-header header text-center" style="background-color: rgb(241, 245, 189);">
                        You're the builders of other profession. So, teach like it's your passion not your profession.
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
<script type="text/javascript" src="javascript/script.js"></script>
</html>

<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>