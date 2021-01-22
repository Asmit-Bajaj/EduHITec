package videos;
import java.net.HttpURLConnection;
import java.net.URL; 

public class ValidatePlaylistVideo {
	//validate the title
		public boolean validateTitle(String title) {
			System.out.println(title.length());
			System.out.println(title);
			if(title == null || title.length() == 0)
				return false;
			return true;
		}
		
		//validate the despcription
		public boolean validateDesp(String desp) {
			if(desp == null || desp.length() == 0)
				return false;
			return true;
		}
		
		//validate the link
		public boolean validateLink(String link) {
			if(link == null || link.length() == 0)
				return false;
			
			 /* Try creating a valid URL */
	        try { 
	            new URL(link).toURI(); 
	        } 
	          
	        // If there was an Exception 
	        // while creating URL object 
	        catch (Exception e) { 
	            return false; 
	        } 
	        
	        HttpURLConnection httpUrlConn;
	        try {
//	        	System.out.println("hii");
	            httpUrlConn = (HttpURLConnection) new URL(link)
	                    .openConnection();
	 
	            // A HEAD request is just like a GET request, except that it asks
	            // the server to return the response headers only, and not the
	            // actual resource (i.e. no message body).
	            // This is useful to check characteristics of a resource without
	            // actually downloading it,thus saving bandwidth. Use HEAD when
	            // you don't actually need a file's contents.
	            httpUrlConn.setRequestMethod("HEAD");
	 
//	            // Set timeouts in milliseconds
	            httpUrlConn.setConnectTimeout(30000);
	            httpUrlConn.setReadTimeout(30000);
	 
	            // Print HTTP status code/message for your information.
	            System.out.println("Response Code: "
	                    + httpUrlConn.getResponseCode());
	            System.out.println("Response Message: "
	                    + httpUrlConn.getResponseMessage());
	 
	            return (httpUrlConn.getResponseCode() == HttpURLConnection.HTTP_OK);
	        } catch (Exception e) {
	            System.out.println("Error: " + e.getMessage());
	            return false;
	        }
			
		}
		
//		public static void main(String[] args) {
//			System.out.println(new ValidatePlaylistVideo().validateLink("http://www.asmit.com"));
//		}
}
