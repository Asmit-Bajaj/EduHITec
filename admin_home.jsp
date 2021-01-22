<%
    response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("admin_id")==null){
		response.sendRedirect("login.jsp");
	}
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
<body>
	<%@include file="admin_menu.html"%>
	
	 <div class="container admin_profile">
        <div class="row">
            <div class="admin-title-header text-center">

                <svg width="0.6em" height="0.6em" viewBox="0 0 16 16" class="bi bi-award" fill="currentColor" xmlns="http://www.w3.org/2000/svg" style="color:#6DD5FA;">
                    <path fill-rule="evenodd" d="M9.669.864L8 0 6.331.864l-1.858.282-.842 1.68-1.337 1.32L2.6 6l-.306 1.854 1.337 1.32.842 1.68 1.858.282L8 12l1.669-.864 1.858-.282.842-1.68 1.337-1.32L13.4 6l.306-1.854-1.337-1.32-.842-1.68L9.669.864zm1.196 1.193l-1.51-.229L8 1.126l-1.355.702-1.51.229-.684 1.365-1.086 1.072L3.614 6l-.25 1.506 1.087 1.072.684 1.365 1.51.229L8 10.874l1.356-.702 1.509-.229.684-1.365 1.086-1.072L12.387 6l.248-1.506-1.086-1.072-.684-1.365z"/>
                    <path d="M4 11.794V16l4-1 4 1v-4.206l-2.018.306L8 13.126 6.018 12.1 4 11.794z"/>
                </svg>
                Admin's Responsibility
                <svg width="0.6em" height="0.6em" viewBox="0 0 16 16" class="bi bi-award" fill="currentColor" xmlns="http://www.w3.org/2000/svg" style="color:#6DD5FA;">
                    <path fill-rule="evenodd" d="M9.669.864L8 0 6.331.864l-1.858.282-.842 1.68-1.337 1.32L2.6 6l-.306 1.854 1.337 1.32.842 1.68 1.858.282L8 12l1.669-.864 1.858-.282.842-1.68 1.337-1.32L13.4 6l.306-1.854-1.337-1.32-.842-1.68L9.669.864zm1.196 1.193l-1.51-.229L8 1.126l-1.355.702-1.51.229-.684 1.365-1.086 1.072L3.614 6l-.25 1.506 1.087 1.072.684 1.365 1.51.229L8 10.874l1.356-.702 1.509-.229.684-1.365 1.086-1.072L12.387 6l.248-1.506-1.086-1.072-.684-1.365z"/>
                    <path d="M4 11.794V16l4-1 4 1v-4.206l-2.018.306L8 13.126 6.018 12.1 4 11.794z"/>
                </svg>
                
            </div>

            <div class="admin-home-card-deck card-deck" style="margin-left: 3%;">
                <div class="card" style="background-color: rgb(201, 247, 201);">
                    <!-- <div class="card-body"> -->
                        <div class="admin-home-main">
                            <div class="admin-home-header header text-center">
                                Add Educator
                                <br>
                                <svg width="1.5em" height="1.5em" viewBox="0 0 16 16" class="admin-home-icons bi bi-plus-square-fill" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
                                    <path fill-rule="evenodd" d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2zm6.5 4.5a.5.5 0 0 0-1 0v3h-3a.5.5 0 0 0 0 1h3v3a.5.5 0 0 0 1 0v-3h3a.5.5 0 0 0 0-1h-3v-3z"/>
                                  </svg>

                                <br>
                                <div style="font-size: 23px;">
                                Provide mandatory information like User id-password and role(Educator).
                            </div>
                            <!-- </div> -->
                        </div></div>
                </div>
                <div class="card" style="background-color: rgb(251, 211, 255);">
                    <div class="admin-home-main">
                        <div class="admin-home-header header text-center">
                            Add Student
                            <br>
                            <svg width="1.5em" height="1.5em" viewBox="0 0 16 16" class="admin-home-icons bi bi-file-earmark-plus-fill" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd" d="M2 2a2 2 0 0 1 2-2h5.293A1 1 0 0 1 10 .293L13.707 4a1 1 0 0 1 .293.707V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2zm7.5 1.5v-2l3 3h-2a1 1 0 0 1-1-1zM8.5 7a.5.5 0 0 0-1 0v1.5H6a.5.5 0 0 0 0 1h1.5V11a.5.5 0 0 0 1 0V9.5H10a.5.5 0 0 0 0-1H8.5V7z"/>
                              </svg>
                            <br>
                            <div style="font-size: 23px;">
                            Provide mandatory information like User id-password and role(Student).
                            </div>
                        <!-- </div> -->
                    </div></div>
                </div>
                <div class="card"  style="background-color: rgb(201, 247, 231);">
                    <div class="admin-home-main">
                        <div class="admin-home-header header text-center">
                            Add Subject       
                            <br>
                            <svg width="1.5em" height="1.5em" viewBox="0 0 16 16" class="admin-home-icons bi bi-journal-plus" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
                                <path d="M3 0h10a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H3a2 2 0 0 1-2-2v-1h1v1a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V2a1 1 0 0 0-1-1H3a1 1 0 0 0-1 1v1H1V2a2 2 0 0 1 2-2z"/>
                                <path d="M1 5v-.5a.5.5 0 0 1 1 0V5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0V8h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1zm0 3v-.5a.5.5 0 0 1 1 0v.5h.5a.5.5 0 0 1 0 1h-2a.5.5 0 0 1 0-1H1z"/>
                                <path fill-rule="evenodd" d="M8 5.5a.5.5 0 0 1 .5.5v1.5H10a.5.5 0 0 1 0 1H8.5V10a.5.5 0 0 1-1 0V8.5H6a.5.5 0 0 1 0-1h1.5V6a.5.5 0 0 1 .5-.5z"/>
                              </svg>
                            <br>
                            <div style="font-size: 23px;">
                             Provide mandatory information like subject details.
                            </div>

                        <!-- </div> -->
                    </div></div>
                </div>
            
            </div>





            <div class="admin-home-header header text-center">
                <div style="font-family: sans-serif;">
                Admin have the reponsibility to Add/Remove Educator, Student and Subjects and can check the Educator, Student
                and Subjects.
            </div>
 
                <br>
                <div style="font-size: 40px;"> So, do it better than perfect.</div>
            </div>



            <div class="admin-home-card-deck card-deck" style="margin-left: 3%;">
                <div class="card" style="background-color: rgb(255, 247, 179);">
                    <div class="admin-home-main">
                        <div class="admin-home-header header text-center">
                            Check or Remove Educator<br>
                            <svg width="1.5em" height="1.5em" viewBox="0 0 16 16"
                                class="admin-home-icons bi bi-person-bounding-box" fill="currentColor"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd"
                                    d="M1.5 1a.5.5 0 0 0-.5.5v3a.5.5 0 0 1-1 0v-3A1.5 1.5 0 0 1 1.5 0h3a.5.5 0 0 1 0 1h-3zM11 .5a.5.5 0 0 1 .5-.5h3A1.5 1.5 0 0 1 16 1.5v3a.5.5 0 0 1-1 0v-3a.5.5 0 0 0-.5-.5h-3a.5.5 0 0 1-.5-.5zM.5 11a.5.5 0 0 1 .5.5v3a.5.5 0 0 0 .5.5h3a.5.5 0 0 1 0 1h-3A1.5 1.5 0 0 1 0 14.5v-3a.5.5 0 0 1 .5-.5zm15 0a.5.5 0 0 1 .5.5v3a1.5 1.5 0 0 1-1.5 1.5h-3a.5.5 0 0 1 0-1h3a.5.5 0 0 0 .5-.5v-3a.5.5 0 0 1 .5-.5z" />
                                <path fill-rule="evenodd"
                                    d="M3 14s-1 0-1-1 1-4 6-4 6 3 6 4-1 1-1 1H3zm5-6a3 3 0 1 0 0-6 3 3 0 0 0 0 6z" />
                            </svg>
                            <br>
                            <div style="font-size: 23px;">
                                Admin can check the list of educators and can remove them.
                            </div>

                        </div>
                    </div>
                </div>
                <div class="card" style="background-color: rgb(201, 247, 201);">
                    <div class="admin-home-main">
                        <div class="admin-home-header header text-center">
                            Check or Remove Student<br>
                            <svg width="1.5em" height="1.5em" viewBox="0 0 16 16"
                                class="admin-home-icons bi bi-file-earmark-person-fill" fill="currentColor"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd"
                                    d="M2 2a2 2 0 0 1 2-2h5.293A1 1 0 0 1 10 .293L13.707 4a1 1 0 0 1 .293.707V14a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2V2zm7.5 1.5v-2l3 3h-2a1 1 0 0 1-1-1zM11 8a3 3 0 1 1-6 0 3 3 0 0 1 6 0zm2 5.755S12 12 8 12s-5 1.755-5 1.755V14a1 1 0 0 0 1 1h8a1 1 0 0 0 1-1v-.245z" />
                            </svg>
                            <br>
                            <div style="font-size: 23px;">
                                Admin can check the list of Students and can remove them.
                            </div>

                        </div>
                    </div>
                </div>
                <div class="card" style="background-color: rgb(255, 247, 179);">
                    <div class="admin-home-main">
                        <div class="admin-home-header header text-center">
                            Check or Remove Subject
                            <br>
                            <svg width="1.5em" height="1.5em" viewBox="0 0 16 16"
                                class="admin-home-icons bi bi-book-half" fill="currentColor"
                                xmlns="http://www.w3.org/2000/svg">
                                <path fill-rule="evenodd"
                                    d="M12.786 1.072C11.188.752 9.084.71 7.646 2.146A.5.5 0 0 0 7.5 2.5v11a.5.5 0 0 0 .854.354c.843-.844 2.115-1.059 3.47-.92 1.344.14 2.66.617 3.452 1.013A.5.5 0 0 0 16 13.5v-11a.5.5 0 0 0-.276-.447L15.5 2.5l.224-.447-.002-.001-.004-.002-.013-.006-.047-.023a12.582 12.582 0 0 0-.799-.34 12.96 12.96 0 0 0-2.073-.609zM15 2.82v9.908c-.846-.343-1.944-.672-3.074-.788-1.143-.118-2.387-.023-3.426.56V2.718c1.063-.929 2.631-.956 4.09-.664A11.956 11.956 0 0 1 15 2.82z" />
                                <path fill-rule="evenodd"
                                    d="M3.214 1.072C4.813.752 6.916.71 8.354 2.146A.5.5 0 0 1 8.5 2.5v11a.5.5 0 0 1-.854.354c-.843-.844-2.115-1.059-3.47-.92-1.344.14-2.66.617-3.452 1.013A.5.5 0 0 1 0 13.5v-11a.5.5 0 0 1 .276-.447L.5 2.5l-.224-.447.002-.001.004-.002.013-.006a5.017 5.017 0 0 1 .22-.103 12.958 12.958 0 0 1 2.7-.869z" />
                            </svg>
                            <br>
                            <div style="font-size: 23px;">
                                Admin can check the list of Subjects and can remove them.
                            </div>

                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>

</body>
<script type="text/javascript" src="javascript/script.js"></script>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</html>