package quiz;

public class StudentQuizReviewBean {
	int review_id,quesid;
	String ans_given, marks_obt;
	
	public int getReview_id() {
		return review_id;
	}
	public void setReview_id(int review_id) {
		this.review_id = review_id;
	}
	public int getQuesid() {
		return quesid;
	}
	public void setQuesid(int quesid) {
		this.quesid = quesid;
	}
	public String getAns_given() {
		return ans_given;
	}
	public void setAns_given(String ans_given) {
		this.ans_given = ans_given;
	}
	public String getMarks_obt() {
		return marks_obt;
	}
	public void setMarks_obt(String marks_obt) {
		this.marks_obt = marks_obt;
	}
	
}
