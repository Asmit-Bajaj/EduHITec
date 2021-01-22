package quiz;

public class ValidateMainQuiz {
	// validate the title
	public boolean validateTitle(String title) {
		if (title == null || title.length() == 0)
			return false;
		return true;
	}

	// validate the despcription
	public boolean validateInst(String inst) {
		if (inst == null || inst.length() == 0)
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
	public boolean validateToTimeline(String toTimeline) {
		if (toTimeline == null || toTimeline.length() == 0)
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
