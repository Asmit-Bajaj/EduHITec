package assignment;

public class ValidateAssignmentMainList {
	//validate the subject id
	public boolean validateSubject(String subjectName) {
		if(subjectName == null || subjectName.isEmpty())
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
