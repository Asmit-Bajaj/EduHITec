package quiz;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

import connnection.EduHITecDb;

public class quizDao {
	private Connection conn = null;
	private PreparedStatement ps = null;
	private ResultSet rs = null;
	private ResultSet rs1 = null;
	private boolean flag = false;
	private String query;

	// returns all the mainlist of quizzes of current educator
	public ArrayList<QuizMainListBean> getAllQuizMainListOfCurrentEducator(int edu_id) {
		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}
		QuizMainListBean bean = null;
		query = "select q.*,s.subjectName,s.code from quizmainlist q, subject s where q.edu_id=? and q.sub_id=s.sub_id";
		ArrayList<QuizMainListBean> list = new ArrayList<>();
		try {
			ps = conn.prepareStatement(query);
			ps.setInt(1, edu_id);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new QuizMainListBean();

				bean.setDesp(rs.getString("desp"));
				bean.setEdu_id(edu_id);
				bean.setInst_id(rs.getInt("inst_id"));
				bean.setQmid(rs.getInt("qmid"));
				bean.setSub_id(rs.getInt("sub_id"));
				bean.setTitle(rs.getString("title"));
				bean.setSubjectName(rs.getString("subjectName"));
				bean.setSubCode(rs.getString("code"));
				list.add(bean);
			}
		} catch (Exception e) {
			System.out.println("Exception at getAllQuizMainListOfCurrentEducator() : " + e);
		} finally {
			conn = null;
			rs = null;
			ps = null;
			return list;
		}
	}

	// gives all the quiz list of current institute
	public ArrayList<QuizMainListBean> getAllQuizMainList(int inst_id) {
		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}
		QuizMainListBean bean = null;
		query = "select q.*,s.subjectName from quizmainlist q, subject s where q.inst_id=? and q.sub_id=s.sub_id";
		ArrayList<QuizMainListBean> list = new ArrayList<>();
		try {
			ps = conn.prepareStatement(query);
			ps.setInt(1, inst_id);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new QuizMainListBean();

				bean.setDesp(rs.getString("desp"));
				bean.setEdu_id(rs.getInt("edu_id"));
				bean.setInst_id(rs.getInt("inst_id"));
				bean.setQmid(rs.getInt("qmid"));
				bean.setSub_id(rs.getInt("sub_id"));
				bean.setTitle(rs.getString("title"));
				bean.setSubjectName(rs.getString("subjectName"));
				list.add(bean);
			}
		} catch (Exception e) {
			System.out.println("Exception at getAllQuizMainList() : " + e);
		} finally {
			conn = null;
			rs = null;
			ps = null;
			return list;
		}
	}

	// get the main quiz title and id for current quiz list cat=1 is for educator
	// and other is for student
	public ArrayList<MainQuizBean> getAllQuizofCurrentList(int qmid, int cat) {
		ArrayList<MainQuizBean> list = new ArrayList<>();
		MainQuizBean bean = null;

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		try {
			if (cat == 1) {
				query = "select * from mainquiz where qmid=?";
			} else {
				query = "select * from mainquiz where qmid=? and ava=1";
			}

			ps = conn.prepareStatement(query);
			ps.setInt(1, qmid);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new MainQuizBean();
				bean.setTitle(rs.getString("title"));
				bean.setQuizid(rs.getInt("quizid"));
				bean.setQmid(qmid);
				list.add(bean);
			}

		} catch (Exception e) {
			System.out.println("Exception at getAllQuizofCurrentList() : " + e);
		} finally {
			ps = null;
			rs = null;
			conn = null;
			return list;
		}
	}

	// returns the unlocked quizzes of current student
	public ArrayList<MainQuizBean> getUnlockedQuizzes(int std_id) {
		ArrayList<MainQuizBean> list = new ArrayList<>();
		MainQuizBean bean = null;

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		try {
			query = "select u.*,mq.* from unlockedquizzes u, mainquiz mq where u.std_id=? and mq.quizid=u.quizid";
			ps = conn.prepareStatement(query);
			ps.setInt(1, std_id);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new MainQuizBean();
				bean.setTitle(rs.getString("title"));
				bean.setQuizid(rs.getInt("quizid"));
				bean.setDate_of_unlock(rs.getString("unlockDate"));

				list.add(bean);
			}

		} catch (Exception e) {
			System.out.println("Exception at getUnlockedQuizzes() : " + e);
		} finally {
			ps = null;
			rs = null;
			conn = null;
			return list;
		}
	}

	public int getQuizValidityForStudent(int quizid) {
		int validity = 0;
		// 1 means that student can attempt this quiz
		// 2 means that student cannot attempt this quiz
		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		try {
			query = "select fromtime,totime from mainquiz where quizid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, quizid);

			rs = ps.executeQuery();
			rs.next();

			if (rs.getString("fromtime") == null) {
				validity = 1;
			} else if (rs.getString("fromtime") != null && rs.getString("totime") == null) {
				query = "select fromtime,totime from mainquiz where quizid=? and now()>=fromtime";
				ps = conn.prepareStatement(query);
				ps.setInt(1, quizid);

				rs = ps.executeQuery();

				if (rs.next()) {
					validity = 1;
				} else {
					validity = 2;
				}
			} else {
				query = "select fromtime,totime from mainquiz where quizid=? and now()>=fromtime and now()<= totime";
				ps = conn.prepareStatement(query);
				ps.setInt(1, quizid);

				rs = ps.executeQuery();

				if (rs.next()) {
					validity = 1;
				} else {
					validity = 2;
				}
			}

		} catch (Exception e) {
			System.out.println("Exception at getQuizValidityForStudent() : " + e);
		} finally {
			ps = null;
			rs = null;
			conn = null;
			return validity;
		}
	}

	// get the current main quiz
	public MainQuizBean getQuiz(int quizid) {

		MainQuizBean bean = null;

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		try {
			query = "select * from mainquiz where quizid=?";
			ps = conn.prepareStatement(query);
			ps.setInt(1, quizid);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new MainQuizBean();
				bean.setTitle(rs.getString("title"));
				bean.setInst(rs.getString("inst"));
				bean.setAttempts(rs.getInt("attempts"));
				bean.setAva(rs.getBoolean("ava"));
				bean.setCode(rs.getString("code"));
				bean.setFrom(rs.getString("fromtime"));
				bean.setTo(rs.getString("totime"));
				bean.setTimer(rs.getInt("timer"));
				bean.setOveralltimer(rs.getInt("overalltimer"));
				bean.setQmid(rs.getInt("qmid"));
				bean.setQuizid(quizid);
				bean.setTimeline(rs.getBoolean("timeline"));
				bean.setWebcam(rs.getBoolean("webcam"));
			}

		} catch (Exception e) {
			System.out.println("Exception at getQuiz() : " + e);
		} finally {
			ps = null;
			rs = null;
			conn = null;
			return bean;
		}
	}

	// returns the quiz having timer for each question
	public ArrayList<QuesAns> getQuesAns(int quizid) {

		ArrayList<QuesAns> list = new ArrayList<>();
		QuesAns bean = null;

		if (conn == null)
			conn = EduHITecDb.getConnection();

		try {
			query = "select * from quesans where quizid = ? order by quesid asc";
			ps = conn.prepareStatement(query);

			ps.setInt(1, quizid);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new QuesAns();

				bean.setCategory(rs.getInt("category"));
				if (rs.getString("ext_opt_attach") != null)
					bean.setExt_opt_attach(rs.getString("ext_opt_attach").split("/"));
				else
					bean.setExt_opt_attach(null);
				if (rs.getString("ext_ques_attach") != null)
					bean.setExt_ques_attach(rs.getString("ext_ques_attach").split("/"));
				else
					bean.setExt_ques_attach(null);

				bean.setFillBlAns(rs.getString("fillBlAns"));
				bean.setMarks(rs.getInt("marks"));
				bean.setNo_of_attch_ques(rs.getInt("no_of_attch_ques"));
				bean.setNo_of_options(rs.getInt("no_of_options"));

				if (rs.getString("options") != null)
					bean.setOptions(rs.getString("options").split("@%"));
				else
					bean.setOptions(null);

				bean.setOptionsAns(rs.getString("optionsAns"));

				if (rs.getString("optionsAttAbslPath") != null)
					bean.setOptionsAttAbslPath(rs.getString("optionsAttAbslPath").split("#"));
				else
					bean.setOptionsAttAbslPath(null);

				bean.setQues(rs.getString("ques"));
				bean.setQuesid(rs.getInt("quesid"));
				bean.setQuizid(quizid);
				bean.setTimer(rs.getInt("timer"));
				bean.setExplanation(rs.getString("explanation"));
				bean.setExplanation_type(rs.getInt("explanation_type"));
				bean.setNeg_marking(rs.getInt("neg_marking"));
				bean.setManualCheck(rs.getBoolean("manualCheck"));
				list.add(bean);
			}

		} catch (Exception e) {
			System.out.println("Exception at getQuizForPreview1() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			return list;
		}

	}

	// returns the overall timer
	public int getOverAllTimer(int qzid) {
		int timer = -1;

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}
		query = "select overalltimer from mainquiz where quizid=?";

		try {
			ps = conn.prepareStatement(query);
			ps.setInt(1, qzid);

			rs = ps.executeQuery();

			if (rs.next()) {
				timer = rs.getInt("overalltimer");
			}

		} catch (Exception e) {
			System.out.println("Exception at getQuizForPreview1() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			return timer;
		}
	}

	// updates the attempt count
	public boolean updateAttemptCount(int qzid, int std_id) {
		flag = false;
		int atp = 0;

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		query = "select attempts from quiz_attempts where std_id = ? and quizid = ?";
		try {
			ps = conn.prepareStatement(query);
			ps.setInt(1, std_id);
			ps.setInt(2, qzid);

			rs = ps.executeQuery();

			if (rs.next()) {
				atp = rs.getInt("attempts");
				query = "update quiz_attempts set attempts=? where std_id=? and quizid=?";
				ps = null;
				ps = conn.prepareStatement(query);

				ps.setInt(1, ++atp);
				ps.setInt(2, std_id);
				ps.setInt(3, qzid);

				if (ps.executeUpdate() > 0)
					flag = true;

			} else {
				query = "insert into quiz_attempts(std_id, quizid, attempts)values(?,?,?)";
				ps = null;
				ps = conn.prepareStatement(query);

				ps.setInt(3, ++atp);
				ps.setInt(1, std_id);
				ps.setInt(2, qzid);

				if (ps.executeUpdate() > 0)
					flag = true;
			}

		} catch (Exception e) {
			System.out.println("Exception at updateAttemptCount() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			return flag;
		}
	}

	// returns the number of attempts for this quiz
	public int getAttempts(int std_id, int qzid) {
		int attempts = 0;

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}
		query = "select attempts from quiz_attempts where quizid=? and std_id=?";

		try {
			ps = conn.prepareStatement(query);
			ps.setInt(1, qzid);
			ps.setInt(2, std_id);

			rs = ps.executeQuery();

			if (rs.next()) {
				attempts = rs.getInt("attempts");
			}

		} catch (Exception e) {
			System.out.println("Exception at getAttempts() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			return attempts;
		}
	}

	// returns all the attempts data for a particular user against the given quiz
	public ArrayList<QuizReviewBean> getMyAttempts(int std_id, int qzid) {
		ArrayList<QuizReviewBean> list = new ArrayList();
		QuizReviewBean bean = null;

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		query = "select * from quizreview where std_id = ? and quizid=? order by date asc";

		try {
			ps = conn.prepareStatement(query);
			ps.setInt(2, qzid);
			ps.setInt(1, std_id);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new QuizReviewBean();
				bean.setDate(rs.getString("date"));
				bean.setObt_marks(rs.getString("obt_marks"));
				bean.setQuizid(qzid);
				bean.setReview_id(rs.getInt("review_id"));
				bean.setStd_id(std_id);
				bean.setTotal_marks(rs.getString("total_marks"));
				list.add(bean);
			}

		} catch (Exception e) {
			System.out.println("Exception at getAttempts() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			return list;
		}
	}

	// gives the review of particular student against the review id
	public ArrayList<StudentQuizReviewBean> getReview(int review_id) {
		ArrayList<StudentQuizReviewBean> list = new ArrayList();
		StudentQuizReviewBean bean = null;

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		query = "select * from studentquizreview where review_id = ? order by quesid asc";

		try {
			ps = conn.prepareStatement(query);
			ps.setInt(1, review_id);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new StudentQuizReviewBean();
				bean.setAns_given(rs.getString("ans_given"));
				bean.setMarks_obt(rs.getString("marks_obt"));
				bean.setQuesid(rs.getInt("quesid"));
				bean.setReview_id(review_id);
				list.add(bean);
			}

		} catch (Exception e) {
			System.out.println("Exception at getReview() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			return list;
		}
	}

	// gives the stats of the current quiz
	public ArrayList<StatsBean> getStats(int qzid) {
		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}

		ArrayList<StatsBean> list = new ArrayList<>();

		StatsBean bean = null;

		query = "select q.*,s.* from quizreview q, " + "student s where q.quizid=? and s.std_id=q.std_id";

		try {
			ps = conn.prepareStatement(query);
			ps.setInt(1, qzid);

			rs = ps.executeQuery();

			while (rs.next()) {
				bean = new StatsBean();
				bean.setDate(rs.getString("date"));
				bean.setEmail(rs.getString("email"));
				bean.setName(rs.getString("name"));
				bean.setObt_marks(rs.getString("obt_marks"));
				bean.setTotal_marks(rs.getString("total_marks"));
				bean.setStd_id(rs.getInt("std_id"));
				bean.setBatch(rs.getString("batch"));
				bean.setBranch(rs.getString("branch"));
				bean.setContact_no(rs.getString("contact_no"));
				bean.setDegree(rs.getString("degree"));
				bean.setStd_class(rs.getString("std_class"));
				bean.setRollno(rs.getString("roll_no"));
				bean.setSection(rs.getString("section"));
				bean.setReview_id(rs.getInt("review_id"));
				list.add(bean);
			}
			// sorting the data
			if (list.size() > 0) {
				Collections.sort(list, new SortbyMarks());
			}
		} catch (Exception e) {
			System.out.println("Exception at getStats() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			return list;
		}
	}

	// gives the graphical data for the quiz
	public ArrayList<GraphicalData> getGraphicalData(int qzid) {
		int m1 = 0;
		int m2 = 0;
		// System.out.println(qzid);

		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}
		ArrayList<GraphicalData> list = new ArrayList<>();
		GraphicalData data = null;
		ps = null;
		rs = null;
		rs1 = null;

		try {
			query = "select quesid from quesans where quizid = ?";
			ps = conn.prepareStatement(query);

			ps.setInt(1, qzid);

			rs = ps.executeQuery();
			// System.out.println("hiii");

			while (rs.next()) {
				query = "select * from studentquizreview where quesid = ?";
				ps = null;
				ps = conn.prepareStatement(query);

				ps.setInt(1, rs.getInt("quesid"));

				rs1 = ps.executeQuery();
				// System.out.println("hi2");
				m1 = 0;
				m2 = 0;

				while (rs1.next()) {
					//
					// System.out.println(rs.getString(1));
					// System.out.println(rs.getString(4));

					if (Double.parseDouble(rs1.getString("marks_obt")) > 0)
						m1++;
					m2++;
				}

				data = new GraphicalData();
				data.setQuesid(rs.getInt("quesid"));

				if (m2 != 0) {
					System.out.println(m1);
					System.out.println(m2);
					data.setPercent((float) (m1 * 100) / m2);
					System.out.println(data.getPercent());
				} else
					data.setPercent(0);
				data.setTotal(m2);
				data.setAttempt(m1);

				list.add(data);
			}
		} catch (Exception e) {
			System.out.println("Exception at getGraphicalData() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			rs1 = null;
			return list;
		}
	}

	//set the lock when student attempt quiz
	public boolean acquireLock(int qzid) {
		if (conn == null) {
			conn = EduHITecDb.getConnection();
		}
		
		try {

			flag = false;
			query = "select qzlock from mainquiz where quizid=?";
			ps = conn.prepareStatement(query);

			ps.setInt(1, qzid);
			rs = ps.executeQuery();

			if (rs.next()) {
				//increase lock count
				query = "update mainquiz set qzlock=? where quizid=?";
				ps = conn.prepareStatement(query);

				ps.setInt(1, rs.getInt("qzlock") + 1);
				ps.setInt(2, qzid);

				if (ps.executeUpdate() > 0)
					flag = true;
			}

		} catch (Exception e) {
			System.out.println("Exception at acquireLock() : " + e);
			e.printStackTrace();
		} finally {
			ps = null;
			conn = null;
			rs = null;
			return flag;
		}
	}
	
	//release the lock when student attempt quiz
		public boolean releaseLock(int qzid) {
			if (conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			try {

				flag = false;
				query = "select qzlock from mainquiz where quizid=?";
				ps = conn.prepareStatement(query);

				ps.setInt(1, qzid);
				rs = ps.executeQuery();

				if (rs.next()) {
					//increase lock count
					query = "update mainquiz set qzlock=? where quizid=?";
					ps = conn.prepareStatement(query);

					ps.setInt(1, rs.getInt("qzlock") - 1);
					ps.setInt(2, qzid);

					if (ps.executeUpdate() > 0)
						flag = true;
				}

			} catch (Exception e) {
				System.out.println("Exception at releaseLock() : " + e);
				e.printStackTrace();
			} finally {
				ps = null;
				conn = null;
				rs = null;
				return flag;
			}
		}
		
		//checks that does this quiz contains any question having manual check set
		public boolean doesThisQuizContainMaunalCheck(int qzid) {
			if (conn == null) {
				conn = EduHITecDb.getConnection();
			}
			
			try {
				flag = false;
				query = "select manualCheck from quesans where quizid=? and manualCheck=?";
				ps = conn.prepareStatement(query);

				ps.setInt(1, qzid);
				ps.setBoolean(2, true);
				rs = ps.executeQuery();

				if (rs.next()) {
					flag = true;
				}

			} catch (Exception e) {
				System.out.println("Exception at doesThisQuizContainMaunalCheck() : " + e);
				e.printStackTrace();
			} finally {
				ps = null;
				conn = null;
				rs = null;
				return flag;
			}
		}
		
		// returns the question for manual check
		public ArrayList<QuesAns> getManualCheckQuesAns(int rvid) {

			ArrayList<QuesAns> list = new ArrayList<>();
			QuesAns bean = null;

			if (conn == null)
				conn = EduHITecDb.getConnection();

			try {
				query = "select sqr.quesid,qa.* from studentquizreview sqr, quesans qa where sqr.review_id = ? and sqr.marks_obt=?"
						+ "and qa.quesid=sqr.quesid order by qa.quesid asc";
				ps = conn.prepareStatement(query);

				ps.setInt(1, rvid);
				ps.setString(2, "NA");

				rs = ps.executeQuery();

				while (rs.next()) {
					bean = new QuesAns();

					bean.setCategory(rs.getInt("category"));
					if (rs.getString("ext_opt_attach") != null)
						bean.setExt_opt_attach(rs.getString("ext_opt_attach").split("/"));
					else
						bean.setExt_opt_attach(null);
					if (rs.getString("ext_ques_attach") != null)
						bean.setExt_ques_attach(rs.getString("ext_ques_attach").split("/"));
					else
						bean.setExt_ques_attach(null);

					bean.setFillBlAns(rs.getString("fillBlAns"));
					bean.setMarks(rs.getInt("marks"));
					bean.setNo_of_attch_ques(rs.getInt("no_of_attch_ques"));
					bean.setNo_of_options(rs.getInt("no_of_options"));

					if (rs.getString("options") != null)
						bean.setOptions(rs.getString("options").split("@%"));
					else
						bean.setOptions(null);

					bean.setOptionsAns(rs.getString("optionsAns"));

					if (rs.getString("optionsAttAbslPath") != null)
						bean.setOptionsAttAbslPath(rs.getString("optionsAttAbslPath").split("#"));
					else
						bean.setOptionsAttAbslPath(null);

					bean.setQues(rs.getString("ques"));
					bean.setQuesid(rs.getInt("quesid"));
					
					bean.setTimer(rs.getInt("timer"));
					bean.setExplanation(rs.getString("explanation"));
					bean.setExplanation_type(rs.getInt("explanation_type"));
					bean.setNeg_marking(rs.getInt("neg_marking"));
					bean.setManualCheck(rs.getBoolean("manualCheck"));
					list.add(bean);
				}

			} catch (Exception e) {
				System.out.println("Exception at getManualQuesAns() : " + e);
				e.printStackTrace();
			} finally {
				ps = null;
				conn = null;
				rs = null;
				return list;
			}

		}
		
		//gives the review of manual check answers
		public ArrayList<StudentQuizReviewBean> getManualCheckReview(int review_id) {
			ArrayList<StudentQuizReviewBean> list = new ArrayList();
			StudentQuizReviewBean bean = null;

			if (conn == null) {
				conn = EduHITecDb.getConnection();
			}

			query = "select * from studentquizreview where review_id = ? and marks_obt=? order by quesid asc";

			try {
				ps = conn.prepareStatement(query);
				ps.setInt(1, review_id);
				ps.setString(2, "NA");

				rs = ps.executeQuery();

				while (rs.next()) {
					bean = new StudentQuizReviewBean();
					bean.setAns_given(rs.getString("ans_given"));
					bean.setMarks_obt(rs.getString("marks_obt"));
					bean.setQuesid(rs.getInt("quesid"));
					bean.setReview_id(review_id);
					list.add(bean);
				}

			} catch (Exception e) {
				System.out.println("Exception at getReview() : " + e);
				e.printStackTrace();
			} finally {
				ps = null;
				conn = null;
				rs = null;
				return list;
			}
		}
		
		//checks whether this review has any manual check left or not
		public boolean doesThisReviewHasAnyManualCheckRem(int rvid) {
			if (conn == null) {
				conn = EduHITecDb.getConnection();
			}

			try {
				flag = false;
				// Check for this review all questions are graded or not
				query = "select quesid from studentquizreview where review_id=? and marks_obt=?";
				ps = conn.prepareStatement(query);

				ps.setInt(1, rvid);
				ps.setString(2, "NA");

				ResultSet rs = ps.executeQuery();

				if (rs.next()) {
					
					// all questions are not checked
					flag = false;
				} else {
					// all questions are checked
					flag = true;
				}
			}catch (Exception e) {
				System.out.println("Exception at doesThisReviewHasAnyManualCheckRem() : "+e);
			}finally {
				conn = null;
				ps = null;
				rs = null;
				return flag;
			}
		}
}

class SortbyMarks implements Comparator<StatsBean> {
	// Used for sorting in descending order of
	// marks
	public int compare(StatsBean a, StatsBean b) {
		double c1 = Double.parseDouble(a.getObt_marks());
		double c2 = Double.parseDouble(b.getObt_marks());

		return Double.compare(c2, c1);
	}
}
