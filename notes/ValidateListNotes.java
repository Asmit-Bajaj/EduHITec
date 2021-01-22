package notes;

public class ValidateListNotes {
	//validate the title
	public boolean validateTitle(String title) {
		if(title == null || title.length() == 0)
			return false;
		return true;
	}
}
