package notes;

import javax.servlet.http.Part;

public class ValidateNotesList {
	public boolean validateSubject(String subjectName) {
		if(subjectName == null || subjectName.isEmpty())
			return false;
		return true;
	}
	
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
	
}
