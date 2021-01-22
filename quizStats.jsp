<%@page import="hide.DataHiding"%>
<%@page import="quiz.quizDao"%>
<%@page import="quiz.StatsBean"%>
<%@page import="java.util.ArrayList"%>
<%
	response.setHeader( "Cache-Control", "no-store, no-cache, must-revalidate");  //HTTP 1.1
    response.setHeader("Pragma","no-cache"); //HTTP 1.0
    response.setDateHeader ("Expires", -1); //prevents caching at the proxy server
%>

<%
	if(session.getAttribute("edu_id")!=null && request.getParameter("qzid")!=null){
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
<link rel="stylesheet" href="https://cdn.datatables.net/1.10.19/css/jquery.dataTables.min.css">
<link rel="stylesheet" href="css/style.css">
<title>EduHITec | Connecting Students and Educator</title>     
</head>
<body>
<div class="modal fade" id="Error" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Something Went Wrong While Updating The Table Data !! If Problem Persist Then contact the owner
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-success" data-dismiss="modal">Okay</button>
      </div>
    </div>
  </div>
</div>

<%
	quizDao dao = new quizDao();
	int id = Integer.parseInt(new DataHiding().decodeMethod(request.getParameter("qzid")));
	boolean isManualCheck = dao.doesThisQuizContainMaunalCheck(id);
	ArrayList<StatsBean> list = dao.getStats(id);
	
	for(int i=0;i<list.size();i++){
		if(dao.doesThisReviewHasAnyManualCheckRem(list.get(i).getReview_id())){
			list.get(i).setAll(true);
		}else{
			list.get(i).setAll(false);
		}
	}
%>
<br>
<a style="margin-left:2%;" href="educatorQuizSubSection1.jsp?qzid=<%=request.getParameter("qzid")%>"><- Return Back</a>
<h3 align="center">List Of All Attempts</h3><br><br>
	
	<div class="table-responsive-xl" style="margin-left:2%;margin-right:2%;">
		<table class="table table-fluid" id="mytable">
			<thead>
				<tr class="table-tr table-header shadow-sm p-3 round">
					<th class="table-th" scope="col">SNo.</th>
					<th class="table-th" scope="col">Roll.No</th>
					<th class="table-th" scope="col">Full Name</th>
					<th class="table-th" scope="col">Email</th>
					<th class="table-th" scope="col">Branch</th>
					<th class="table-th" scope="col">Class/Standard</th>
					<th class="table-th" scope="col">Section</th>
					<th class="table-th" scope="col">Degree Enrolled In</th>
					<th class="table-th" scope="col">Batch</th>
					<th class="table-th" scope="col">Contact No.</th>
					<th class="table-th" scope="col">Obtained Marks</th>
					<th class="table-th" scope="col">Total Marks</th>
					<th class="table-th" scope="col">Date and Time</th>
					<%
						if(isManualCheck){
					%>
					<th class="table-th" scope="col">Actions</th>
					<%
						}
					%>
				</tr>
			</thead>
			
		<tbody id="quizSubmissionsTable">
		<%
			for(int i=0;i<list.size();i++){
		%>
			<tr class="table-tr shadow-sm p-3 mb bg-white round">
				<td class="table-td"><%=i+1%></td>
				<%
				if(list.get(i).getRollno() == null || list.get(i).getRollno().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getRollno()%></td>
			<%
				}
			%>
			<td class="table-td"><%=list.get(i).getName()%></td>
					<td class="table-td"><%=list.get(i).getEmail()%></td>
					<%
				if(list.get(i).getBranch() == null || list.get(i).getBranch().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getBranch()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getStd_class() == null || list.get(i).getStd_class().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getStd_class()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getSection() == null || list.get(i).getSection().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getSection()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getDegree() == null || list.get(i).getDegree().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getDegree()%></td>
			<%
				}
			%>
			
			<%
				if(list.get(i).getBatch() == null || list.get(i).getBatch().equals("")){
			%>
			<td class="table-td">--NA--</td>
			<%
				}else{
			%>
			<td class="table-td"><%=list.get(i).getBatch()%></td>
			<%
				}
			%>
			<td class="table-td"><%=list.get(i).getContact_no()%></td>
			<td class="table-td" id="obt_<%=list.get(i).getReview_id()%>"><%=list.get(i).getObt_marks()%></td>
			<td class="table-td"><%=list.get(i).getTotal_marks()%></td>
			<td class="table-td"><%=list.get(i).getDate()%></td>
			<%
						if(isManualCheck){
							if(list.get(i).isAll() == false){
			%>
			<td class="table-td" id="rv_<%=list.get(i).getReview_id()%>"><button id="bt_<%=list.get(i).getReview_id()%>" type="button" class="btn btn-outline-primary" style="height:120px !important;"
        	onclick="openWindow('<%=new DataHiding().encodeMethod(String.valueOf(list.get(i).getReview_id()))%>','<%=list.get(i).getReview_id()%>');">Check Manual Set Answers</button></td>
				
			<%				}else{
			
			%>
			<td class="table-td" id="rv_<%=list.get(i).getReview_id()%>">All Questions Are Graded</td>
			<%
							}
						}
			%>
			</tr>
<%
			}
%>
		</tbody>
		
	</table>
	
	</div>
	<br><br><br>
</body>
<script src="https://cdn.datatables.net/1.10.19/js/jquery.dataTables.min.js"></script>
<script>
var win;
var x;

function openWindow(rvid,tpid){
	win = window.open("CheckManualAnswers.jsp?rvid="+rvid,'window','toolbar=yes,scrollbars=yes,resizable=yes');
	document.getElementById("bt_"+tpid).setAttribute("disabled","true");
	x = setInterval(function(){
		if(win.closed){
			clearInterval(x);
			document.getElementById("bt_"+tpid).removeAttribute("disabled");
			updateTable(rvid,tpid);	
		}
	},1);
}

function updateTable(rvid,tpid){
	$.post("UpdateAssignManualAnswerTable",
		    {
		      rvid : rvid,
		    },
		    function(data,status){
		    	if(status == 'success'){
		    		if(data == "error"){
		    			$("#Error").modal("show");
		    		}else{
		    			
		    			let obj = JSON.parse(data);
		    			document.getElementById("obt_"+tpid).innerHTML = obj.marks;
		    			if(obj.isAll == "yes"){
		    				document.getElementById("bt_"+tpid).style.display = "none";
		    				document.getElementById("rv_"+tpid).innerHTML = "All Questions Are Graded";
		    			}
		    		}
				}else{
		    		$("#Error").modal("show");
				}
		    });	
}

$(document).ready(function () {
    $('#mytable').DataTable();
    $('.dataTables_length').addClass('bs-select');
}); 
</script>


<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

</html>
<%
	}else{
		response.sendRedirect("login.jsp");
	}
%>