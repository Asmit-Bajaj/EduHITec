package quiz;

public class MainQuizBean {
	private int qmid, quizid, timer; 
	private boolean timeline, ava;
	private String title, inst, from, to,code;
	private int attempts,overalltimer;
	private String date_of_unlock;
	private boolean webcam;
	
	
	
	public boolean isWebcam() {
		return webcam;
	}

	public void setWebcam(boolean webcam) {
		this.webcam = webcam;
	}

	public String getDate_of_unlock() {
		return date_of_unlock;
	}
	
	public void setDate_of_unlock(String date_of_unlock) {
		this.date_of_unlock = date_of_unlock;
	}
	
	public int getOveralltimer() {
		return overalltimer;
	}
	public void setOveralltimer(int overalltimer) {
		this.overalltimer = overalltimer;
	}
	public int getAttempts() {
		return attempts;
	}
	public void setAttempts(int attempts) {
		this.attempts = attempts;
	}
	public int getQmid() {
		return qmid;
	}
	public void setQmid(int qmid) {
		this.qmid = qmid;
	}
	public int getQuizid() {
		return quizid;
	}
	public void setQuizid(int quizid) {
		this.quizid = quizid;
	}
	public int getTimer() {
		return timer;
	}
	public void setTimer(int timer) {
		this.timer = timer;
	}
	public boolean isTimeline() {
		return timeline;
	}
	public void setTimeline(boolean timeline) {
		this.timeline = timeline;
	}
	public boolean isAva() {
		return ava;
	}
	public void setAva(boolean ava) {
		this.ava = ava;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getInst() {
		return inst;
	}
	public void setInst(String inst) {
		this.inst = inst;
	}
	public String getFrom() {
		return from;
	}
	public void setFrom(String from) {
		this.from = from;
	}
	public String getTo() {
		return to;
	}
	public void setTo(String to) {
		this.to = to;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	
}
