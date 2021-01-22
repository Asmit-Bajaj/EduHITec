package assignment;

public class SubmissionBean {
	private int std_id, asgid, marks,ret_no_of_files;
	private String datetime, feedback;
	private String[] extensions,orgnames,path,ret_orgnames,ret_extensions,ret_path;
	private int no_of_files;
	private String name,rollno;
	private int maxMarks;
	private String email,section,batch,std_class,degree,branch,contact_no;
	
	
	
	public String getSection() {
		return section;
	}
	public void setSection(String section) {
		this.section = section;
	}
	public String getBatch() {
		return batch;
	}
	public void setBatch(String batch) {
		this.batch = batch;
	}
	public String getStd_class() {
		return std_class;
	}
	public void setStd_class(String std_class) {
		this.std_class = std_class;
	}
	public String getDegree() {
		return degree;
	}
	public void setDegree(String degree) {
		this.degree = degree;
	}
	public String getBranch() {
		return branch;
	}
	public void setBranch(String branch) {
		this.branch = branch;
	}
	public String getContact_no() {
		return contact_no;
	}
	public void setContact_no(String contact_no) {
		this.contact_no = contact_no;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public int getRet_no_of_files() {
		return ret_no_of_files;
	}
	public void setRet_no_of_files(int ret_no_of_files) {
		this.ret_no_of_files = ret_no_of_files;
	}
	public String[] getRet_orgnames() {
		return ret_orgnames;
	}
	public void setRet_orgnames(String[] ret_orgnames) {
		this.ret_orgnames = ret_orgnames;
	}
	public String[] getRet_extensions() {
		return ret_extensions;
	}
	public void setRet_extensions(String[] ret_extensions) {
		this.ret_extensions = ret_extensions;
	}
	public String[] getRet_path() {
		return ret_path;
	}
	public void setRet_path(String[] ret_path) {
		this.ret_path = ret_path;
	}
	public int getMaxMarks() {
		return maxMarks;
	}
	public void setMaxMarks(int maxMarks) {
		this.maxMarks = maxMarks;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRollno() {
		return rollno;
	}
	public void setRollno(String rollno) {
		this.rollno = rollno;
	}
	public int getStd_id() {
		return std_id;
	}
	public void setStd_id(int std_id) {
		this.std_id = std_id;
	}
	public int getAsgid() {
		return asgid;
	}
	public void setAsgid(int asgid) {
		this.asgid = asgid;
	}
	public int getMarks() {
		return marks;
	}
	public void setMarks(int marks) {
		this.marks = marks;
	}
	public String[] getPath() {
		return path;
	}
	public void setPath(String[] path) {
		this.path = path;
	}
	public String[] getOrgnames() {
		return orgnames;
	}
	public String[] getExtensions() {
		return extensions;
	}
	public void setExtensions(String[] extensions) {
		this.extensions = extensions;
	}
	public int getNo_of_files() {
		return no_of_files;
	}
	public void setNo_of_files(int no_of_files) {
		this.no_of_files = no_of_files;
	}
	public void setOrgnames(String[] orgnames) {
		this.orgnames = orgnames;
	}
	public String getDatetime() {
		return datetime;
	}
	public void setDatetime(String datetime) {
		this.datetime = datetime;
	}
	public String getFeedback() {
		return feedback;
	}
	public void setFeedback(String feedback) {
		this.feedback = feedback;
	}
	 
}
