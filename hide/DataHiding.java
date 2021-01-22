package hide;

import java.math.BigInteger;  
import java.nio.charset.StandardCharsets; 
import java.security.MessageDigest;  
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class DataHiding {
	//encode the id
		public String encodeMethod(String arg) {
			String ans = null;
			try {
				//encode the string
				ans = Base64.getEncoder().encodeToString(arg.getBytes("utf-8"));
				System.out.println("encode = "+ans);
				
			}catch (Exception e) {
				System.out.println("Exception at encodeMethod : "+e);
			}finally {
				return ans;
			}
		}
		
		//decode the id
		public String decodeMethod(String arg) {
			String ans = null;
//			System.out.println(arg);
			
			try {
				//decode the string
				byte[] decode = Base64.getDecoder().decode(arg);
				
				ans = new String(decode);
				
			}catch (Exception e) {
				System.out.println("Exception at decodeMethod : "+e);
			}finally {
				return ans;
			}
		}
		
		//to get the SHA code
		public byte[] getSHA(String input) throws NoSuchAlgorithmException {
			 // Static getInstance method is called with hashing SHA  
	        MessageDigest md = MessageDigest.getInstance("SHA-256");  
	  
	        // digest() method called  
	        // to calculate message digest of an input  
	        // and return array of byte 
	        return md.digest(input.getBytes(StandardCharsets.UTF_8)); 
		}
		
		//convert the SHA to hex string
		public String toHexString(byte[] hash) 
	    { 
	        // Convert byte array into signum representation  
	        BigInteger number = new BigInteger(1, hash);  
	  
	        // Convert message digest into hex value  
	        StringBuilder hexString = new StringBuilder(number.toString(16));  
	  
	        // Pad with leading zeros 
	        while (hexString.length() < 32)  
	        {  
	            hexString.insert(0, '0');  
	        }  
	  
	        return hexString.toString();  
	    } 
		
//		public static void main(String[] args) {
//			try {
//				
//				
//			}catch(Exception e) {
//				e.printStackTrace();
//			}
//	}	
}
