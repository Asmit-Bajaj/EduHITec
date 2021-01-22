package notes;

public class SubjectNotesBean {
	private int nid;
	private String title, path;
	private int npid;
	private String ext;
	
	public String getExt() {
		return ext;
	}
	public void setExt(String ext) {
		this.ext = ext;
	}
	public int getNpid() {
		return npid;
	}
	public void setNpid(int npid) {
		this.npid = npid;
	}
	public int getNid() {
		return nid;
	}
	public void setNid(int nid) {
		this.nid = nid;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getPath() {
		return path;
	}
	public void setPath(String path) {
		this.path = path;
	}
}
