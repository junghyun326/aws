package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

// dao : 데이터베이스 접근 객체의 약자
public class BbsDAO {
	
	// connection:db에접근하게 해주는 객체
	private Connection conn;

	//private PreparedStatement pstmt;
	private ResultSet rs;

	// mysql 처리부분
	public BbsDAO() {
		// 생성자를 만들어준다.
		try {
			Class.forName("com.mysql.jdbc.Driver");
                        String dbURL = "jdbc:mysql://database-1.cs5t3rl5axhv.ap-northeast-2.rds.amazonaws.com/BBS";
                        String dbID = "admin";
                        String dbPassword = "mode1752";
                        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	//현재의 시간을 가져오는 함수
	public String getDate() { 
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류
	}

	public int getCount() {
		String SQL = "SELECT count(*) FROM BBS WHERE bbsAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
                        rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
                        e.printStackTrace();
                }
		return -1;
	}

	public int getFTPCount() {
                String SQL = "SELECT count(*) FROM BBSFTP WHERE bbsAvailable = 1";
                try {
                        PreparedStatement pstmt = conn.prepareStatement(SQL);
                        rs = pstmt.executeQuery();
                        if(rs.next()) {
                                return rs.getInt(1);
                        }
                } catch (Exception e) {
                        e.printStackTrace();
                }
                return -1;
        }

	//bbsID 게시글 번호 가져오는 함수
	public int getNext() { 
		String SQL = "SELECT bbsID FROM BBS ORDER BY bbsID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1;//첫 번째 게시물인 경우
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류
	}

	public int getFTPNext() {
                String SQL = "SELECT bbsID FROM BBSFTP ORDER BY bbsID DESC";
                try {
                        PreparedStatement pstmt = conn.prepareStatement(SQL);
                        rs = pstmt.executeQuery();
                        if(rs.next()) {
                                return rs.getInt(1) + 1;
                        }
                        return 1;//첫 번째 게시물인 경우
                } catch (Exception e) {
                        e.printStackTrace();
                }
                return -1; //데이터베이스 오류
        }

	//실제로 글을 작성하는 함수
	public int write(String bbsTitle, String userID, String bbsContent, String imgFileName) { 
		String SQL = "INSERT INTO BBS VALUES(?, ?, ?, ?, ?, ?)";
		String imgSQL = "INSERT INTO BBSIMAGE VALUES(?, ?)";
		int bbsID = getNext();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6,1);
			
			int result = pstmt.executeUpdate();

			if (imgFileName != ""){
				pstmt = conn.prepareStatement(imgSQL);
				pstmt.setInt(1, bbsID);
				pstmt.setString(2, imgFileName);
				result += pstmt.executeUpdate();
			}
			return result;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return -3; //데이터베이스 오류
	}

	public int writeFTP(String bbsTitle, String userID, String bbsContent, String FileName) {
                String SQL = "INSERT INTO BBSFTP VALUES(?, ?, ?, ?, ?, ?)";
                String ftpSQL = "INSERT INTO BBSFTPFILE VALUES(?, ?)";
                int bbsID = getFTPNext();
                try {
                        PreparedStatement pstmt = conn.prepareStatement(SQL);
                        pstmt.setInt(1, bbsID);
                        pstmt.setString(2, bbsTitle);
                        pstmt.setString(3, userID);
                        pstmt.setString(4, getDate());
                        pstmt.setString(5, bbsContent);
                        pstmt.setInt(6,1);

                        int result = pstmt.executeUpdate();

                        if (FileName != ""){
                                pstmt = conn.prepareStatement(ftpSQL);
                                pstmt.setInt(1, bbsID);
                                pstmt.setString(2, FileName);
                                result += pstmt.executeUpdate();
                        }
                        return result;

                } catch (Exception e) {
                        e.printStackTrace();
                }

                return -3; //데이터베이스 오류
        }

	public ArrayList<Bbs> getList(int pageNumber){
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}

	public ArrayList<Bbs> getFTPList(int pageNumber){
                String SQL = "SELECT * FROM BBSFTP WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
                ArrayList<Bbs> list = new ArrayList<Bbs>();
                try {
                        PreparedStatement pstmt = conn.prepareStatement(SQL);
                        pstmt.setInt(1, getFTPNext() - (pageNumber -1) * 10);
                        System.out.println(getFTPNext() - (pageNumber -1) * 10);
                        rs = pstmt.executeQuery();
                        while (rs.next()) {
                                Bbs bbs = new Bbs();
                                bbs.setBbsID(rs.getInt(1));
                                bbs.setBbsTitle(rs.getString(2));
                                bbs.setUserID(rs.getString(3));
                                bbs.setBbsDate(rs.getString(4));
                                bbs.setBbsContent(rs.getString(5));
                                bbs.setBbsAvailable(rs.getInt(6));
                                list.add(bbs);
                        }
                } catch (Exception e) {
                        e.printStackTrace();
                }
                return list;
        }

	public boolean nextPage (int pageNumber) {
		String SQL = "SELECT * FROM BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber -1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean nextFTPPage (int pageNumber) {
                String SQL = "SELECT * FROM BBSFTP WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
                ArrayList<Bbs> list = new ArrayList<Bbs>();
                try {
                        PreparedStatement pstmt = conn.prepareStatement(SQL);
                        pstmt.setInt(1, getFTPNext() - (pageNumber -1) * 10);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                                return true;
                        }
                } catch (Exception e) {
                        e.printStackTrace();
                }
                return false;
        }

	public Bbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BBS WHERE bbsID = ?";
		String imgSQL = "SELECT imgFileName FROM BBSIMAGE WHERE bbsID= ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			Bbs bbs = new Bbs();
			if (rs.next()) {
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
			}
			pstmt = conn.prepareStatement(imgSQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				bbs.setImgFileName(rs.getString(1));
			}
			return bbs;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public Bbs getBbsFTP(int bbsID) {
                String SQL = "SELECT * FROM BBSFTP WHERE bbsID = ?";
                String fileSQL = "SELECT FTPFileName FROM BBSFTPFILE WHERE bbsID= ?";
                try {
                        PreparedStatement pstmt = conn.prepareStatement(SQL);
                        pstmt.setInt(1, bbsID);
                        rs = pstmt.executeQuery();
                        Bbs bbs = new Bbs();
                        if (rs.next()) {
                                bbs.setBbsID(rs.getInt(1));
                                bbs.setBbsTitle(rs.getString(2));
                                bbs.setUserID(rs.getString(3));
                                bbs.setBbsDate(rs.getString(4));
                                bbs.setBbsContent(rs.getString(5));
                                bbs.setBbsAvailable(rs.getInt(6));
                        }
                        pstmt = conn.prepareStatement(fileSQL);
                        pstmt.setInt(1, bbsID);
                        rs = pstmt.executeQuery();
                        if (rs.next()) {
                                bbs.setImgFileName(rs.getString(1));
                        }
                        return bbs;
                } catch (Exception e) {
                        e.printStackTrace();
                }
                return null;
        }

	public int update(int bbsID, String bbsTitle, String bbsContent, String imgFileName) {
		String SQL = "UPDATE BBS SET bbsTitle = ?, bbsContent = ? WHERE bbsID = ?";
		String imgSQL = "UPDATE BBSIMAGE SET imgFileName = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);

			int result = pstmt.executeUpdate();

			pstmt = conn.prepareStatement(imgSQL);
			pstmt.setString(1, imgFileName);
			pstmt.setInt(2, bbsID);

			result += pstmt.executeUpdate();

			return result;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}
	
	//삭제 함수
	public int delete(int bbsID) {
		String SQL = "UPDATE BBS SET bbsAvailable = 0 WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // 데이터베이스 오류
	}

	public int deleteFTP(int bbsID) {
                String SQL = "UPDATE BBSFTP SET bbsAvailable = 0 WHERE bbsID = ?";
                try {
                        PreparedStatement pstmt = conn.prepareStatement(SQL);
                        pstmt.setInt(1, bbsID);
                        return pstmt.executeUpdate();
                } catch (Exception e) {
                        e.printStackTrace();
                }
                return -1; // 데이터베이스 오류
        }

}
