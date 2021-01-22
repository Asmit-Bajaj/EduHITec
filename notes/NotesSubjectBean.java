package notes;

public class NotesSubjectBean {
	private int npid, edu_id, sub_id,inst_id;
	private String title, desp, datetime,Sub_name,createdBy;
	private String code;
	
	public String getCreatedBy() {
		return createdBy;
	}
	public void setCreatedBy(String createdBy) {
		this.createdBy = createdBy;
	}
	public String getSub_name() {
		return Sub_name;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public void setSub_name(String sub_name) {
		Sub_name = sub_name;
	}
	
	public int getNpid() {
		return npid;
	}
	public void setNpid(int npid) {
		this.npid = npid;
	}
	public int getEdu_id() {
		return edu_id;
	}
	public void setEdu_id(int edu_id) {
		this.edu_id = edu_id;
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
	public String getDatetime() {
		return datetime;
	}
	public void setDatetime(String datetime) {
		this.datetime = datetime;
	}
	
	
}
