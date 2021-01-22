package assignment;

public class ValidateAssignment {
	// validate the title
	public boolean validateTitle(String title) {
		if (title == null || title.length() == 0)
			return false;
		return true;
	}

	// validate the instructions
	public boolean validateInst(String inst) {
		if (inst == null || inst.length() == 0)
			return false;
		return true;
	}

	// validate the instructions
	public boolean validateDeadline(String deadline) {
		if (deadline == null || deadline.length() == 0)
			return false;
		return true;
	}

	// validate the Marks
	public boolean validateMarks(String marks) {
		if (marks == null || marks.length() == 0)
			return false;
		return true;
	}

	// validate the amid
	public boolean validateAmid(String amid) {
		if (amid == null || amid.length() == 0)
			return false;
		return true;
	}
}
