package quiz;

public class ValidateQuizMainList {
	public boolean validateSubject(String subjectName) {
		if (subjectName == null || subjectName.isEmpty())
			return false;
		return true;
	}

	// validate the title
	public boolean validateTitle(String title) {
		System.out.println(title.length());
		System.out.println(title);
		if (title == null || title.length() == 0)
			return false;
		return true;
	}

	// validate the despcription
	public boolean validateDesp(String desp) {
		if (desp == null || desp.length() == 0)
			return false;
		return true;
	}

	// validate from timeline
	public boolean validateFromTimeline(String fromTimeline) {
		if (fromTimeline == null || fromTimeline.length() == 0)
			return false;
		return true;
	}

	// validate to timeline
	public boolean validateTromTimeline(String tromTimeline) {
		if (tromTimeline == null || tromTimeline.length() == 0)
			return false;
		return true;
	}

	// validate to attempts
	public boolean validateAttempts(String attempts) {
		if (attempts == null || attempts.length() == 0)
			return false;
		return true;
	}

	// validate overall timer
	public boolean validateOverallTimer(String overallTimer) {
		if (overallTimer == null || overallTimer.length() == 0)
			return false;
		return true;
	}
}
