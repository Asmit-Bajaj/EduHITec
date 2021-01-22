<%@page import="admin.AdminDao"%>
<%@page import="admin.SubjectBean"%>
<%@page import="hide.DataHiding"%>
<%@page import="quiz.MainQuizBean"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.QuizMainListBean"%>
<%@page import="java.util.ArrayList"%>
<%
	response.setHeader("Cache-Control", "no-store, no-cache, must-revalidate"); //HTTP 1.1
	response.setHeader("Pragma", "no-cache"); //HTTP 1.0
	response.setDateHeader("Expires", -1); //prevents caching at the proxy server
%>

<%
	if (session.getAttribute("std_id") != null) {
%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js" integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js" integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM" crossorigin="anonymous"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">

<title>EduHITec | Connecting Students and Educator</title>
<link rel="stylesheet" href="css/style.css">
</head>
<body>
	<%@include file="student_menu.html"%>

	<div class="modal fade" id="quizUnlockSuccess" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
		data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body">
					<div>Quiz Unlocked Successfully Go to Private Quiz Section to
						Check the Quiz!!! Click Okay Button to close dialog</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
				</div>
			</div>
		</div>
	</div>

	<!-- quiz list is removed by educator -->
	<div class="modal fade" id="confirmedQuizlistRemove" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
		data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body text-center">
					<div>
						This Quiz list Has been Removed By The User Right Now !!! <br>
						<br> !!Please Refresh The Page To See The Updates
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
				</div>
			</div>
		</div>
	</div>

	<!-- Quiz is removed by educator -->
	<div class="modal fade" id="confirmedQuizRemove" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
		data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body text-center">
					<div>
						This Quiz Has been Removed By The User Right Now !!! <br> <br>
						!!Please refresh the Page to See The Updates !!
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
				</div>
			</div>
		</div>
	</div>


	<div class="modal fade" id="notfound" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true"
		data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body">
					<div>Quiz Not Found !!!</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
				</div>
			</div>
		</div>
	</div>

	<!-- In case if any error occurs -->
	<div class="modal fade" id="quizUnlockError" tabindex="-1"
		role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true"
		data-keyboard="false" data-backdrop="static">
		<div class="modal-dialog modal-dialog-centered">
			<div class="modal-content">
				<div class="modal-body">
					<div>Something went wrong try again!!!</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
				</div>
			</div>
		</div>
	</div>


	<%
		if (session.getAttribute("success") != null) {
	%>
	<script>
		$(document).ready(function() {
			$("#quizUnlockSuccess").modal("show");
		});
	</script>

	<%
		session.removeAttribute("success");
			} else if (session.getAttribute("nfd") != null) {
	%>
	<script>
		$(document).ready(function() {
			$("#notfound").modal("show");
		});
	</script>
	<%
		session.removeAttribute("nfd");
			} else if (session.getAttribute("error") != null) {
	%>
	<script>
		$(document).ready(function() {
			$("#quizUnlockError").modal("show");

		});
	</script>

	<%
		session.removeAttribute("error");
			}
	%>

	<%
		ArrayList<QuizMainListBean> list = new quizDao()
					.getAllQuizMainList((Integer) session.getAttribute("inst_id"));
			ArrayList<MainQuizBean> list1 = new quizDao()
					.getUnlockedQuizzes((Integer) session.getAttribute("std_id"));
	%>
	<nav>
	<div class="nav nav-tabs nav-fill my-5" id="nav-tab" role="tablist">
		<a class="nav-item nav-link active" id="public-quiz-tab"
			data-toggle="tab" href="#public-quiz" role="tab"
			aria-controls="nav-public-quiz" aria-selected="true"><b>Public
				Quizzes</b></a> 
		<a class="nav-item nav-link" id="private-quiz-tab"
			data-toggle="tab" href="#private-quiz" role="tab"
			aria-controls="nav-private-quiz" aria-selected="false"><b>Private
				Quizzes</b></a> 
		<a class="nav-item nav-link" id="unlock-quiz-tab"
			data-toggle="tab" href="#unlock-quiz" role="tab"
			aria-controls="nav-unlock-quiz" aria-selected="false"><b>Unlock
				Quiz</b></a>
	</div>
	</nav>

	<div class="tab-content" id="nav-tabContent">
		<div class="tab-pane fade show active" id="public-quiz"
			role="tabpanel" aria-labelledby="public-quiz-tab">
			<div class="form-group p-4">
				<label for="filterBy">Filter By</label> <select id="filterBy"
					onchange="filter(this);" class="form-control">
					<%
						ArrayList<SubjectBean> sublist = new AdminDao()
									.getAllSubjects((Integer) session.getAttribute("inst_id"));
							if (sublist.size() == 0) {
					%>
					<option disabled>No Subjects Available</option>
					<%
						} else {
					%>
					<option value="All">All Playlists</option>
					<%
						for (int i = 0; i < sublist.size(); i++) {
					%>
					<option value="<%=sublist.get(i).getSubjectName()%>"><%=sublist.get(i).getSubjectName()%>
						<%
							if (sublist.get(i).getCode() != null && sublist.get(i).getCode().equals("") == false) {
						%> (<%=sublist.get(i).getCode()%>)
						<%
							}
						%>
					</option>
					<%
						}
							}
					%>
				</select>
			</div>

			<%
				if (list.size() == 0) {
			%>
			<h4 style="margin: 3%">No Quiz List Available</h4>
			<%
				} else {
			%>
			<div class="card-columns" style="margin: 3%;">
			<%
						for (int i = 0; i < list.size(); i++) {
			%>
			
				<div class="card mb-3 text-center" style="border-radius: 10px;">
					<div class="card-body">
						<h5 class="card-title" style="white-space: pre-wrap;"><%=list.get(i).getTitle()%></h5>
						<h6 class="card-title" style="white-space: pre-wrap;"><%=list.get(i).getSubjectName()%></h6>
						<p class="card-text" style="white-space: pre-wrap;"><%=list.get(i).getDesp()%></p>
						<button class="btn btn-primary m-1"
							onclick="getQuizlistStatus(`<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getQmid()))%>`)">Open
							Quizzes</button>
					</div>
				</div>
			
				<%
					}
			%>
			</div>
			<% 
						}
				%>
			
		</div>

		<div class="tab-pane fade" id="private-quiz" role="tabpanel"
			aria-labelledby="private-quiz-tab">
			<div class="text-center" style="margin-top: 5%">
				<%
					if (list1.size() == 0) {
				%>
				<div style="color: #0808c3a8;">
					<h4>No Private Quizzes Unlocked Yet</h4>
				</div>
				<%
					} else {
							for (int i = 0; i < list1.size(); i++) {
				%>
				<div class="quizheading"
					onclick="getQuizStatus('<%=new DataHiding().encodeMethod(String.valueOf(list1.get(i).getQuizid()))%>')">
					<h5><%=list1.get(i).getTitle()%>
						<span style="float: right;">Date of Unlock : <%=list1.get(i).getDate_of_unlock()%></span>
					</h5>
				</div>
				<%
					}
						}
				%>
			</div>
		</div>

		<div class="tab-pane fade" id="unlock-quiz" role="tabpanel"
			aria-labelledby="unlock-quiz-tab">
			<form class="form-inline" action="UnlockQuiz" method="post">
				<div class="mx-auto">
					<div class="form-group">
						<label for="SecretCode">Enter Secret Code : </label> <input
							type="text" id="SecretCode" name="SecretCode"
							class="form-control mx-sm-3"
							aria-describedby="SecretCodeHelpInline"> <small
							id="SecretCodeHelpInline" class="text-muted"> Secret Code
							is given by the educator it is Case sensitive </small>
					</div>
					<div class="mx-auto m-5">
						<button type="submit" class="btn btn-primary">Unlock</button>
					</div>
				</div>

			</form>
		</div>
		
	</div>
</body>
<script>
	function filter() {
		let card = document.getElementsByClassName("card");
		let input = document.getElementById("filterBy").value.toUpperCase();
		let textValue1, a, b, textValue2;

		if (input == "ALL") {
			for (let j = 0; j < card.length; j++) {
				card[j].style.display = "";
			}
		} else {
			for (let i = 0; i < card.length; i++) {
				a = card[i].getElementsByTagName("h5")[0];
				b = card[i].getElementsByTagName("h6")[0];

				txtValue1 = a.textContent || a.innerText;
				txtValue2 = b.textContent || b.innerText;

				if (txtValue1.toUpperCase().indexOf(input) > -1
						|| txtValue2.toUpperCase().indexOf(input) > -1) {
					card[i].style.display = "";
				} else {
					card[i].style.display = "none";
				}
			}
		}
	}

	//to check that Quiz exist or not
	function getQuizStatus(id) {
		$.post("CheckQuizAvailability", {
			quizid : id
		}, function(data, status) {
			if (data == "remove" && status == 'success') {
				$("#confirmedQuizRemove").modal("show");
			} else if (data == 'notremove' && status == 'success') {
				window.location
						.replace("studentQuizSubSection2.jsp?qzid=" + id);
			}
		});
	}

	//to check that quiz list exist or not
	function getQuizlistStatus(id) {
		$.post("CheckQuizMainlistAvailability", {
			qmid : id
		}, function(data, status) {
			if (data == "remove" && status == 'success') {
				$("#confirmedQuizlistRemove").modal("show");
			} else if (data == 'notremove' && status == 'success') {
				window.location
						.replace("studentQuizSubSection1.jsp?qmid=" + id);
			}
		});
	}
</script>
<script src="javascript/script.js"></script>
</html>
<%
	} else {
		response.sendRedirect("login.jsp");
	}
%>