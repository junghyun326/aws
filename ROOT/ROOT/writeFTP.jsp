<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<%
		//login한 사람이라면 userID라는 변수에 해당 아이디가 담기고 그렇지 않으면 null값
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		} else {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인이 필요합니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
	%>

	<!-- 네비게이션  -->
	<nav class="navbar navbar-default">
		<div class="navbar-header">
			<button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="bs-example-navbar-collapse-1" aria-expaned="false">
				<span class="icon-bar"></span> <span class="icon-bar"></span> <span class="icon-bar"></span>
			</button>
		</div>
		<div class="collapse navbar-collapse" id="#bs-example-navbar-collapse-1">
			<ul class="nav navbar-nav">
				<li><a href="main.jsp">영상검색 시스템</a></li>
                                <li><a href="bbs.jsp">메타1</a></li>
                                <li class="active"><a href="bbsFTP.jsp">메타2</a></li>
				<li><a>server</a></li>
			</ul>

			<%
				//login 안된 경우
				if (userID == null) {

			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="login.jsp">로그인</a></li>
						<li><a href="join.jsp">회원가입</a></li>
					</ul></li>
			</ul>
			<%
				} else {
			%>
			<ul class="nav navbar-nav navbar-right">
				<li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><%=userID%>님 회원관리<span class="caret"></span></a>
					<ul class="dropdown-menu">
						<li><a href="logoutAction.jsp">로그아웃</a></li>
					</ul></li>
			</ul>
			<%
				}
			%>
		</div>
	</nav>
	<!-- 게시판 -->
	<div class="container">
		<div class="row">
			<form method="post" action="/writeActionFTP.jsp" enctype="multipart/form-data" onsubmit="return checkForm();" accept-charset="UTF-8">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">FTP 게시판 글쓰기 양식</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><input type="text" id="title" class="form-control" placeholder="글 제목" name="bbsTitle" maxlength="50"/></td>
						</tr>
						<tr>
							<td><textarea id="content" class="form-control" placeholder="글 내용" name="bbsContent" maxlength="2048" style="height: 350px;"></textarea></td>
						</tr>
						<tr>
							<td>
								<input type="file" id="fileName" name="imgFileName" size="74" accept="image/jpg, image/jpeg, image/png, image/gif, video/mp4, video/avi, video/mkv, video/wmv, .pdf, .pptx, .txt, .hwp, .docx, .xlsx" onchange="validateFileType(event)">
								<img id="previewimg" src="#" alt="업로드 이미지" style="display: none; max-width: 50rem; max-height: 50rem;">
								<video id="previewvid" controls style="display: none; max-width: 50rem; max-height: 50rem;"></video>

							</td>
					</tbody>
				</table>	
				<input type="submit" class="btn btn-primary pull-right" value="글쓰기" />
			</form>
		</div>
	</div>
	<script type="text/javascript">
	 	function checkForm() {
			if($('#title').val() == ''){
	 			alert('글 제목을 입력해주세요.');
	 			$('#title').focus();
	 			return false;
			}
			if($('#content').val() == ''){
	 			alert('글 내용을 입력해주세요.');
	 			$('#content').focus();
	 			return false;
			 }
	 	}

		function validateFileType(event){
			var fileName = document.getElementById("fileName").value;
			var idxDot = fileName.lastIndexOf(".") + 1;
			var extFile = fileName.substr(idxDot, fileName.length).toLowerCase();
	 		if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif" || extFile=="mp4" || extFile=="avi" || extFile=="mkv" || extFile=="wmv" || extFile=="pdf" || extFile=="pptx" || extFile=="txt" || extFile=="hwp" || extFile=="docx" || extFile=="xlsx"){
	 			console.log($('#fileName'));
	 			readURL($('#fileName'), extFile);
			}else{
	 			alert("jpg/jpeg/png 파일과 mp4/avi/mkv/wmv 파일만 올릴 수 있습니다.!");
	 			$("#fileName").wrap('<form>').closest('form').get(0).reset();
	 			$("#fileName").unwrap();
	 			return false;
			}
		}

	 	function readURL(input, extFile) {
 			console.log(input[0].files[0]);
	 		var reader = new FileReader();

 			reader.onload = function(e) {
 				console.log(e.target.result);
	 			if (extFile=="jpg" || extFile=="jpeg" || extFile=="png" || extFile=="gif"){
					$("#previewvid").css('display', 'none');
					$("#previewimg").attr("src", e.target.result);
					$("#previewimg").css('display', 'inline-block');
				} else if (extFile=="mp4" || extFile=="avi" || extFile=="mkv" || extFile=="wmv"){
					$("#previewimg").css('display', 'none');
					$("#previewvid").attr("src", e.target.result);
	 				$("#previewvid").attr("type", "video/"+extFile);
					$("#previewvid").attr("src", e.target.result);
					$("#previewvid").css('display', 'inline-block');
				}
 			}
 			reader.readAsDataURL(input[0].files[0]);
	 	}
	</script>

	<!-- 애니매이션 담당 JQUERY -->
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

	<!-- 부트스트랩 JS  -->
	<script src="js/bootstrap.js"></script>
</body>
</html>
