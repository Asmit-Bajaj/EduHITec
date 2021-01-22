package admin;

public class ValidateSubject {
	
	// validate subjectName
				// check for empty string or does it contain any digit or special character
				public boolean validateSubjectName(String subjectName) {
					if (subjectName == null || subjectName.length() > 200 || subjectName.length() == 0)
						return false;

					return subjectName.matches("[a-z A-Z]*");
				}
				
}
