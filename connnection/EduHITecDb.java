package connnection;

import java.sql.Connection;
import java.sql.DriverManager;

public class EduHITecDb {
	private final static String URL = "" ;
	private final static String UNAME = "" ;
	private final static String PWD = "" ;
	private final static String DRIVER = "com.mysql.jdbc.Driver" ;
	private static Connection conn = null;
	
	
	private EduHITecDb() {
		
	}
	
	static {
		try {
			Class.forName(DRIVER);
			conn = DriverManager.getConnection(URL,UNAME,PWD);
			
		}catch (Exception e) {
			System.out.println("Exception at Connection : "+e);
		}
	}
	
	public static Connection getConnection() {
		return conn;
	}
	
	public static void main(String[] args) {
		System.out.println(EduHITecDb.getConnection());
	}
	
}
