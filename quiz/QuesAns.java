package quiz;

public class QuesAns {
	private int quesid, quizid,no_of_attch_ques,category,no_of_options,marks,timer,neg_marking,explanation_type;
	private String ques,fillBlAns,optionsAns,explanation;
	private String[] quesAttAbslPath,options,optionsAttAbslPath,ext_ques_attach, ext_opt_attach;
	private boolean manualCheck;
	
	public boolean isManualCheck() {
		return manualCheck;
	}
	public void setManualCheck(boolean manualCheck) {
		this.manualCheck = manualCheck;
	}
	public int getNeg_marking() {
		return neg_marking;
	}
	public void setNeg_marking(int neg_marking) {
		this.neg_marking = neg_marking;
	}
	public int getExplanation_type() {
		return explanation_type;
	}
	public void setExplanation_type(int explanation_type) {
		this.explanation_type = explanation_type;
	}
	public String getExplanation() {
		return explanation;
	}
	public void setExplanation(String explanation) {
		this.explanation = explanation;
	}
	public int getQuesid() {
		return quesid;
	}
	public void setQuesid(int quesid) {
		this.quesid = quesid;
	}
	public int getQuizid() {
		return quizid;
	}
	public void setQuizid(int quizid) {
		this.quizid = quizid;
	}
	public int getNo_of_attch_ques() {
		return no_of_attch_ques;
	}
	public void setNo_of_attch_ques(int no_of_attch_ques) {
		this.no_of_attch_ques = no_of_attch_ques;
	}
	public int getCategory() {
		return category;
	}
	public void setCategory(int category) {
		this.category = category;
	}
	public int getNo_of_options() {
		return no_of_options;
	}
	public void setNo_of_options(int no_of_options) {
		this.no_of_options = no_of_options;
	}
	public int getMarks() {
		return marks;
	}
	public void setMarks(int marks) {
		this.marks = marks;
	}
	public int getTimer() {
		return timer;
	}
	public void setTimer(int timer) {
		this.timer = timer;
	}
	public String getQues() {
		return ques;
	}
	public void setQues(String ques) {
		this.ques = ques;
	}
	public String getFillBlAns() {
		return fillBlAns;
	}
	public void setFillBlAns(String fillBlAns) {
		this.fillBlAns = fillBlAns;
	}
	public String getOptionsAns() {
		return optionsAns;
	}
	public void setOptionsAns(String optionsAns) {
		this.optionsAns = optionsAns;
	}
	public String[] getQuesAttAbslPath() {
		return quesAttAbslPath;
	}
	public void setQuesAttAbslPath(String[] quesAttAbslPath) {
		this.quesAttAbslPath = quesAttAbslPath;
	}
	public String[] getOptions() {
		return options;
	}
	public void setOptions(String[] options) {
		this.options = options;
	}
	public String[] getOptionsAttAbslPath() {
		return optionsAttAbslPath;
	}
	public void setOptionsAttAbslPath(String[] optionsAttAbslPath) {
		this.optionsAttAbslPath = optionsAttAbslPath;
	}
	public String[] getExt_ques_attach() {
		return ext_ques_attach;
	}
	public void setExt_ques_attach(String[] ext_ques_attach) {
		this.ext_ques_attach = ext_ques_attach;
	}
	public String[] getExt_opt_attach() {
		return ext_opt_attach;
	}
	public void setExt_opt_attach(String[] ext_opt_attach) {
		this.ext_opt_attach = ext_opt_attach;
	}
	
	
}
