package assignment;

public class MainListAssignmentsBean {
	private int asgid, amid,marks,no_of_files;
	private String instructions, deadline,title,code;
	private String[] path,extensions,orgNames;
	
	public int getMarks() {
		return marks;
	}
	public void setMarks(int marks) {
		this.marks = marks;
	}
	public String getCode() {
		return code;
	}
	public void setCode(String code) {
		this.code = code;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public int getAsgid() {
		return asgid;
	}
	public void setAsgid(int asgid) {
		this.asgid = asgid;
	}
	public int getAmid() {
		return amid;
	}
	public void setAmid(int amid) {
		this.amid = amid;
	}
	public String getInstructions() {
		return instructions;
	}
	public void setInstructions(String instructions) {
		this.instructions = instructions;
	}
	public String getDeadline() {
		return deadline;
	}
	public void setDeadline(String deadline) {
		this.deadline = deadline;
	}
	public String[] getPath() {
		return path;
	}
	public void setPath(String[] path) {
		this.path = path;
	}
	public int getNo_of_files() {
		return no_of_files;
	}
	public void setNo_of_files(int no_of_files) {
		this.no_of_files = no_of_files;
	}
	public String[] getExtensions() {
		return extensions;
	}
	public void setExtensions(String[] extensions) {
		this.extensions = extensions;
	}
	public String[] getOrgNames() {
		return orgNames;
	}
	public void setOrgNames(String[] orgNames) {
		this.orgNames = orgNames;
	}
	
	
}
