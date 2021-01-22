package file;

import javax.servlet.http.Part;

public class FileOperations {
	//extract the fileName from part
	public static String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
//        System.out.println(contentDisp+"\n");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length()-1);
            }
        }
        return "";
    }
	
	//get the extension
	public static String getExtension(String name) {
		String extension = "";
		for(int i=name.length()-1;i>=0;i--) {
			if(name.charAt(i) == '.') {
				break;
			}else {
				extension = name.charAt(i)+extension;
			}
		}
		
		return extension;
	}
	
}
