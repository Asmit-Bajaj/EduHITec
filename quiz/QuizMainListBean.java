package quiz;

public class QuizMainListBean {
	private int edu_id, qmid, sub_id,inst_id;
	private String  title, desp;
	private String subjectName;
	private String subCode;
	
	public String getSubCode() {
		return subCode;
	}
	public void setSubCode(String subCode) {
		this.subCode = subCode;
	}
	public String getSubjectName() {
		return subjectName;
	}
	public void setSubjectName(String subjectName) {
		this.subjectName = subjectName;
	}
	public int getEdu_id() {
		return edu_id;
	}
	public void setEdu_id(int edu_id) {
		this.edu_id = edu_id;
	}
	public int getQmid() {
		return qmid;
	}
	public void setQmid(int qmid) {
		this.qmid = qmid;
	}
	public int getSub_id() {
		return sub_id;
	}
	public void setSub_id(int sub_id) {
		this.sub_id = sub_id;
	}
	public int getInst_id() {
		return inst_id;
	}
	public void setInst_id(int inst_id) {
		this.inst_id = inst_id;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getDesp() {
		return desp;
	}
	public void setDesp(String desp) {
		this.desp = desp;
	}
	
}
