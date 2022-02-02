<%@page import="javax.security.auth.callback.ConfirmationCallback"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="main.ImgDAO"%>
<%@ page import="main.Img"%>
<%@ page import="java.util.ArrayList"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- 뷰포트 -->
<meta name="viewport" content="width=device-width" initial-scale="1">
<!-- 스타일시트 참조  -->
<link rel="stylesheet" href="css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.css">
<title>jsp 게시판 웹사이트</title>
<style type="text/css">
  body {
    padding-bottom: 10rem;
  }

  .item {
    height: 60rem;
    width: 114rem;
  }
  .img_div {
    display: block;
    line-height: 60rem;
    vertical-align: middle;
    text-align: center;
  }

  .item img {
    max-height: 100%;
    max-width: 100%;
    margin: auto;
  }
</style>
</head>
<body>
<%
  String userID = null;
  if (session.getAttribute("userID") != null) {
    userID = (String) session.getAttribute("userID");
  }
%>
<!-- 네비게이션  -->
<nav class="navbar navbar-default">
  <div class="navbar-header">
    <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1" aria-expaned="false">
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
      <span class="icon-bar"></span>
    </button>
  </div>

  <div class="collapse navbar-collapse" id="#bs-example-navbar-collapse-1">
    <ul class="nav navbar-nav">
      <li><a href="main.jsp">영상검색 시스템</a></li>
      <li><a href="bbs.jsp">메타1</a></li>
      <li><a href="bbsFTP.jsp">메타2</a></li>
      <li><a>server</a></li>
    </ul>
    <%
      if (userID == null) {
    %>
    <ul class="nav navbar-nav navbar-right">
      <li class="dropdown">
	<a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">접속하기<span class="caret"></span></a>
	<ul class="dropdown-menu">
	  <li class="active"><a href="login.jsp">로그인</a></li>
	  <li><a href="join.jsp">회원가입</a></li>
	</ul>
      </li>
    </ul>
    <%
      } else {
    %>
    <ul class="nav navbar-nav navbar-right">
      <li class="dropdown"><a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><%=userID%>님 회원관리<span class="caret"></span></a>
	<ul class="dropdown-menu">
	  <li><a href="logoutAction.jsp">로그아웃</a></li>
	</ul>
      </li>
    </ul>
    <%
      }
    %>
  </div> 
</nav>
<div class="container">
  <div class="jumbotron">
    <h1>영상 검색 시스템</h1>
    <p><a class="btn btn-primary btn-pull" href="#" role="button">자세히 알아보기</a></p>
  </div>
</div>
<div class="container">
  <div id="myCarousel" class="carousel slide" data-ride="carousel">
    <ol class="carousel-indicators">
      <%
	ImgDAO imgDAO = new ImgDAO();
	ArrayList<Img> list = imgDAO.getList();
	for (int i = 0; i < list.size(); i++) {
	  if(i == 0) {
      %>
      <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
      <%
	  } else {
      %>
      <li data-target="#myCarousel" data-slide-to="<%=i%>"></li>
      <%
	  }
	}
      %>
    </ol>
    <div class="carousel-inner">
      <%
	for (int i = 0; i < list.size(); i++) {
	  if(i == 0) {
      %>
      <div class="item active">
	<div class="img_div">
	  <img src="<%=list.get(i).getImgPath()+list.get(i).getImgName()%>">
	</div>
      </div>
      <%
	  } else {
      %>
      <div class="item">
	<div class="img_div">
	  <img src="<%=list.get(i).getImgPath()+list.get(i).getImgName()%>">
	</div>
      </div>
      <%
	  }
	}
      %>
    </div>
    <a class="left carousel-control" href="#myCarousel" data-slide="prev">
      <span class="glyphicon glyphicon-chevron-left"></span>
    </a>
    <a class="right carousel-control" href="#myCarousel" data-slide="next">
      <span class="glyphicon glyphicon-chevron-right"></span>
    </a>
  </div>
</div>

<!-- 애니매이션 담당 JQUERY -->
<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

<!-- 부트스트랩 JS  -->
<script src="js/bootstrap.js"></script>

</body>
</html>
