package quiz;

public class GraphicalData {
	private int quesid;
	private float percent;
	private int total;
	private int attempt;
	
	public int getQuesid() {
		return quesid;
	}
	public int getTotal() {
		return total;
	}
	public void setTotal(int total) {
		this.total = total;
	}
	public int getAttempt() {
		return attempt;
	}
	public void setAttempt(int attempt) {
		this.attempt = attempt;
	}
	public void setQuesid(int quesid) {
		this.quesid = quesid;
	}
	public float getPercent() {
		return percent;
	}
	public void setPercent(float percent) {
		this.percent = percent;
	}
	
	
	
}
