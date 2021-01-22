
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/css/bootstrap.min.css" integrity="sha384-9aIt2nRpC12Uk9gS9baDl411NQApFmC26EwAOH8WgZl5MYYxFfc+NcPb1dKGj7Sk" crossorigin="anonymous">
<title>EduHITec | Confirm Email</title>
</head>

<body>

<!-- Modal for successful confirmation of Student -->
<div class="modal fade" id="Success" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Your Email Validated Successfully !!!!
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-success" onclick="window.close();">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- account is in deactivate state -->
<div class="modal fade" id="Error2" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	This Link Has Already Expired !!!
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-success" onclick="window.close();">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- account is already in active state -->
<div class="modal fade" id="Error1" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	This Link Is Not Valid !!!!
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-success" onclick="window.close();">Okay</button>
      </div>
    </div>
  </div>
</div>

<!-- error from server -->
<div class="modal fade" id="Error3" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" data-keyboard="false" data-backdrop="static">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content">
      <div class="modal-body">
        <div>
        	Error Occurred from server Please try to contact the owner !!!
        </div>
      </div>
      <div class="modal-footer">
        <button class="btn btn-success" onclick="window.close();">Okay</button>
      </div>
    </div>
  </div>
</div>

	<%
		if(request.getParameter("id") != null && request.getParameter("upid") != null){
	%>
		<form action="ConfirmStudent" method="post">
			<input type="hidden" name="id" value="<%=request.getParameter("id")%>">
			<input type="hidden" name="upid" value="<%=request.getParameter("upid")%>">
		</form>
		
		<script>
			document.forms[0].submit();
		</script>
	<%
		}else{
			if(request.getParameter("success") != null){
	%>
		<script>
		$(document).ready(function(){
			    $("#Success").modal("show");
		    
		});
		</script>	
	<%
			}else if(request.getParameter("error") != null && request.getParameter("error").equals("1")){
	%>
		<script>
		$(document).ready(function(){
			    $("#Error1").modal("show");
		    
		});
		</script>	
	<%
			}else if(request.getParameter("error") != null && request.getParameter("error").equals("2")){
	%>
				<script>
				$(document).ready(function(){
					    $("#Error2").modal("show");
				    
				});
				</script>	
	<%	
			}else if(request.getParameter("error") != null && request.getParameter("error").equals("3")){
				%>
				<script>
				$(document).ready(function(){
					    $("#Error3").modal("show");
				    
				});
				</script>
				
			<%
			}else{
				response.sendRedirect("index.jsp");
			}
		}
	%>
</body>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.0/js/bootstrap.min.js" integrity="sha384-OgVRvuATP1z7JjHLkuOU7Xw704+h835Lr+6QL9UvYjZE3Ipu6Tp75j7Bh/kR0JKI" crossorigin="anonymous"></script>
</html>
