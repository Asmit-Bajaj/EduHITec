package quiz;

public class QuizReviewBean{
	private int review_id, std_id, quizid;
	private String date, obt_marks, total_marks;
	public int getReview_id() {
		return review_id;
	}
	public void setReview_id(int review_id) {
		this.review_id = review_id;
	}
	public int getStd_id() {
		return std_id;
	}
	public void setStd_id(int std_id) {
		this.std_id = std_id;
	}
	public int getQuizid() {
		return quizid;
	}
	public void setQuizid(int quizid) {
		this.quizid = quizid;
	}
	public String getDate() {
		return date;
	}
	public void setDate(String date) {
		this.date = date;
	}
	public String getObt_marks() {
		return obt_marks;
	}
	public void setObt_marks(String obt_marks) {
		this.obt_marks = obt_marks;
	}
	public String getTotal_marks() {
		return total_marks;
	}
	public void setTotal_marks(String total_marks) {
		this.total_marks = total_marks;
	}
	
}
