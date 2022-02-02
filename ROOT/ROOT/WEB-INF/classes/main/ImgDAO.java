package main;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ImgDAO {
	// dao : 데이터베이스 접근 객체의 약자로서
	// 실질적으로 db에서 회원정보 불러오거나 db에 회원정보 넣을때

	private Connection conn; // connection:db에접근하게 해주는 객체
	private PreparedStatement pstmt;
	private ResultSet rs;

	// mysql에 접속해 주는 부분
	public ImgDAO() {
		try {
			Class.forName("com.mysql.jdbc.Driver");
			String dbURL = "jdbc:mysql://database-1.cs5t3rl5axhv.ap-northeast-2.rds.amazonaws.com/BBS";
			String dbID = "admin";
			String dbPassword = "mode1752";
			conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace(); // 오류가 무엇인지 출력
		}
	}

        public ArrayList<Img> getList(){
                String SQL = "SELECT imgID, imgPath, imgName FROM IMG";
                ArrayList<Img> list = new ArrayList<Img>();
		try {
                        PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Img img = new Img();
				img.setImgID(rs.getInt(1));
				img.setImgPath(rs.getString(2));
				img.setImgName(rs.getString(3));
				list.add(img);
			}
		} catch (Exception e) {
                        e.printStackTrace();
                }
                return list;
	}
}
