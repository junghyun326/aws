<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<!-- bbsdao의 클래스 가져옴 -->
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%
	//System.out.println(bbs);
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>jsp 게시판 웹사이트</title>
</head>
<body>
	<%
		String path = getServletContext().getRealPath("/img/bbs/");

		File f = new File(path);
		if (!f.exists()) {
			f.mkdirs();
		}

		Bbs bbs = new Bbs();
		String encType = "UTF-8";
		int maxSize = 100 * 1024 * 1024;

		try {
			MultipartRequest mr = new MultipartRequest(request, path, maxSize, encType, new DefaultFileRenamePolicy());
			bbs.setBbsTitle(mr.getParameter("bbsTitle"));
			bbs.setBbsContent(mr.getParameter("bbsContent"));
			bbs.setImgFileName(mr.getFilesystemName("imgFileName"));
		} catch (Exception e) {
			e.printStackTrace();
		}

		System.out.println("path : ");
		System.out.println(path);
                System.out.println("Title : ");
                System.out.println(bbs.getBbsTitle());
                System.out.println("Content : ");
                System.out.println(bbs.getBbsContent());
                System.out.println("ImgFileName : ");
                System.out.println(bbs.getImgFileName());

		String userID = null;
		if (session.getAttribute("userID") != null) {//유저 세션이 존재하는 회원들은 
			userID = (String) session.getAttribute("userID");//유저 아이디에 해당 세션값을 넣어준다.
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} else {

			if (bbs.getBbsTitle() == null || bbs.getBbsContent() == null || bbs.getBbsTitle() == "" ||  bbs.getBbsContent() == "") {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				BbsDAO BbsDAO = new BbsDAO();
				if (bbs.getImgFileName() == null){bbs.setImgFileName("");}
				int result = BbsDAO.write(bbs.getBbsTitle(), userID, bbs.getBbsContent(), bbs.getImgFileName());
				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다1')");
					script.println("history.back()");
					script.println("</script>");
				} else if (result < -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다3')");
					script.println("history.back()");
					script.println("</script>");
				} else {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='bbs.jsp'");
					//script.println("history.back()");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>
