<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	System.out.println("FTP Print : ");
        //System.out.println(bbs);
%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="bbs.Bbs"%>
<!-- bbsdao의 클래스 가져옴 -->
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.amazonaws.auth.AWSCredentials"%>
<%@ page import="com.amazonaws.auth.BasicAWSCredentials"%>
<%@ page import="com.amazonaws.regions.Region"%>
<%@ page import="com.amazonaws.services.s3.AmazonS3"%>
<%@ page import="com.amazonaws.services.s3.S3Client"%>
<%@ page import="com.amazonaws.services.s3.model.PutObjectRequest;"%>

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
		System.out.println("FTP Print 2 : ");
		String path = getServletContext().getRealPath("/img/s3/");
		System.out.println("path : ");
                System.out.println(path);

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
				if (bbs.getImgFileName() == null){
					bbs.setImgFileName("");
				} else {
					try{
						String ACCESS_KEY = "AKIAXPZCDDNWXMK3LCGI";
						String SECRET_KEY = "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";
						String BUCKET_NAME = "aerope-web";
						AWSCredentials awsCredentials = new BasicAWSCredentials(ACCESS_KEY, SECRET_KEY);
						AmazonS3 amazonS3 = S3Client.builder().region(Regions.AP_NORTHEAST_2).build();

						if(amazonS3 != null){
							String fileName = bbs.getImgFileName();
                                                        File put_file = new File(path + File.separator + fileName);

							PutObjectRequest putObjectRequest = new PutObjectRequest(BUCKET_NAME, file.getName(), put_file);
							putObjectRequest.setCannedAcl(CannedAccessControlList.PublicRead); // file permission
							amazonS3.putObject(putObjectRequest); // upload file
						} else {
							PrintWriter script = response.getWriter();
	        	                                script.println("<script>");
        	        	                        script.println("alert('글쓰기에 실패했습니다2')");
                	                	        script.println("history.back()");
		                                        script.println("</script>");
						}
					} catch(Exception e) {
						System.out.println(e);
						e.printStackTrace();
					}  finally {
						amazonS3.shutdown();
                                        }

				}
				
				BbsDAO BbsDAO = new BbsDAO();

				int result = BbsDAO.writeFTP(bbs.getBbsTitle(), userID, bbs.getBbsContent(), bbs.getImgFileName());
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
					script.println("location.href='bbsFTP.jsp'");
					//script.println("history.back()");
					script.println("</script>");
				}
			}
		}
	%>
</body>
</html>
