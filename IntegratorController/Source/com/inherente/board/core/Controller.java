package com.inherente.board.core;


import java.util.ArrayList;// import java.util.HashMap;
import java.util.Date;
import java.util.List;// import java.util.Map;
import java.util.Map;
import java.util.logging.Logger;// import java.sql.Connection

import javax.faces.bean.ManagedBean;
import javax.faces.bean.ManagedProperty;
import javax.faces.bean.RequestScoped;// import javax.faces.bean.SessionScoped;
import javax.faces.context.FacesContext;
import javax.faces.event.ActionEvent;
import javax.faces.event.AjaxBehaviorEvent;

import com.inherente.board.handler.CommonHandler;
import com.inherente.board.model.BasicChart;
import com.inherente.db.bean.Job;
import com.inherente.db.bean.MessageGeneralFlow;
import com.inherente.db.bean.Range;
import com.inherente.db.model.ChartManager;
import com.inherente.db.model.JobManager;
import com.inherente.db.model.JobManagerFactory;
import com.obelit.db.pool.Reusable;
import com.obelit.db.pool.SimpleConnectionPool;

@ManagedBean (name = "Controller" )
@RequestScoped
public class Controller {
	@ManagedProperty ("#{action}") String action;
	public static final String SUCCESS_JSF_CODE = "success";
	Logger log= Logger.getLogger(Controller.class.getName());
	private String nameU;
	private String rol;
	private String claveU;
	SimpleConnectionPool pool;
	Reusable conn;
	CommonHandler handler;
	JobManager jManager;
	ChartManager chartManager;
	private BasicChart basicChart;
	List<Job> job;
	static List<Range>jobData;

	public List< Range>rangeData;
	public List< Job>bookData;
	private List< Job>bookOutData;
	private List< Job>bookPIData;

	private String change;
	private String activitie;
	
    private String jobSelection;
    private String colorSelection;
    private String bookSelection;
    private String rangeSelection;
    private String output;
    public static int counter;

	public Controller() {
		log.info("inito (" + (counter++) + ")");
		pool = new SimpleConnectionPool();
	 	conn= pool.acquireReusable();
	    jManager = JobManagerFactory.buildJobManager(null);
	 	chartManager= JobManagerFactory.buildChartManager(null);
	 	handler = new CommonHandler(conn.instance());
	 //	conn.release();
		init();

	}

	public void init () {
		jobData = new ArrayList< Range>();
		bookData= new ArrayList< Job>();
		bookOutData= new ArrayList< Job>();
		bookPIData= new ArrayList< Job>();// setActivity(new ArrayList< Job>());
		rangeData = new ArrayList< Range>();
		rangeData .add(new Range("0"));
		rangeData .add(new Range("1"));
		basicChart = new BasicChart();
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public String chart () {
		log.info("ockey");

		return SUCCESS_JSF_CODE;
	}

	public String todo () {
		log.info("todok");

		return SUCCESS_JSF_CODE;
	}

	public String reporte () {
		log.info("reporte");

		return SUCCESS_JSF_CODE;
	}

	public String home () {
		log.info("okey");

		return SUCCESS_JSF_CODE;
	}

	public String member () {
		log.info("oka");

		return SUCCESS_JSF_CODE;
	}

	public String control () {
		log.info("oka");
		setBookData (jManager.getJobCatalog(conn.instance(), JobManager.REPLICATION_OPTION));
		setBookOutData(jManager.getJobCatalog(conn.instance(), JobManager.GENERATION_OPTION));
		setBookPIData(jManager.getJobCatalog(conn.instance(), JobManager.SEND_PI_OPTION));

		return SUCCESS_JSF_CODE;
	}

	public String login () {
		log.info("ok");

		return SUCCESS_JSF_CODE;
	}

	public String logout () {
		log.info("okout");

		return SUCCESS_JSF_CODE;
	}

	public String delu () {
		log.info("ok");

		return SUCCESS_JSF_CODE;
	}

	public void anything (AjaxBehaviorEvent event) {
		log.info("ok");
		setOutput("Hello :"+ new Date().toString());// return SUCCESS_JSF_CODE;
	}

	public String logon () {
		log.info("ok");
		handler.logon(getNameU(), getRol());

		return SUCCESS_JSF_CODE;
	}

	public String change (ActionEvent event) {
		String id;// 
		String param = "";
		log.info("change action -"+ action);
		id = (String)event.getComponent().getAttributes().get("action");
		Map<Object,Object> att = FacesContext.getCurrentInstance().getAttributes();// getRequestParameterMap()
		param = (String)att.get("action");

		log.info("change id -"+ id);

		log.info("change aatribute -"+ param);
	 //	jManager.brokeJob(conn.instance(), id, "");

		return SUCCESS_JSF_CODE;
	}

	public String change () {
		String param = "";
		Map<Object,Object> att = FacesContext.getCurrentInstance().getAttributes();// getRequestParameterMap()
		log.info("change action -"+ action);
		param = (String)att.get("action"); // 
		log.info("change attribute -"+ param);
		jManager.brokeJob(conn.instance(), action, "");

		setBookData (jManager.getJobCatalog(conn.instance(), JobManager.REPLICATION_OPTION));
		setBookOutData(jManager.getJobCatalog(conn.instance(), JobManager.GENERATION_OPTION));
		setBookPIData(jManager.getJobCatalog(conn.instance(), JobManager.SEND_PI_OPTION));

		return SUCCESS_JSF_CODE;
	}

	public String getNameU() {
		return nameU;
	}

	public void setNameU(String nameU) {
		this.nameU = nameU;
	}

	public String getRol() {
		return rol;
	}

	public void setRol(String rol) {
		this.rol = rol;
	}

	public String getClaveU() {
		return claveU;
	}

	public void setClaveU(String claveU) {
		this.claveU = claveU;
	}

	public List<Range> getJobData() {
		log.info("<List> Size of "+ jobData.size() + " element(s)");
		return jobData;
	}

	public List< Range> getRangeData() {
		log.info("<List> Size of "+ rangeData.size()+ " element(s)");
		return rangeData;
	}

	public List< Job> getBookData() {
		log.info("<List> Size of "+ bookData.size()+ " element(s)");
		return bookData;
	}
	public void setBookData(List< Job> bookOutData) {
		bookData = bookOutData;
	}

	public String getJobSelection() {
		return jobSelection;
	}

	public void setJobSelection(String jobSelection) {

		this.jobSelection = jobSelection;
	}

	public String getColorSelection() {

		return colorSelection;
	}

	public void setColorSelection(String colorSelection) {
		this.colorSelection = colorSelection;
	}

	public String getRangeSelection() {

		return rangeSelection;
	}

	public void setRangeSelection(String rangeSelection) {
		this.rangeSelection = rangeSelection;
	}

	public String getBookSelection() {
		return bookSelection;
	}

	public void setBookSelection(String bookSelection) {
		this.bookSelection = bookSelection;
	}

	public String getChange() {

		log.info("getChange");
		change= SUCCESS_JSF_CODE;
		return change;
	}

	public void setChange(String change) {
		this.change = change;
	}

	public String getActivitie() {
		return activitie;
	}

	public void setActivitie(String activities) {
		this.activitie = activities;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String action) {
		this.action = action;
	}

	public List< Job> getBookOutData() {
		return bookOutData;
	}

	public void setBookOutData(List< Job> bookOutData) {
		this.bookOutData = bookOutData;
	}

	public List< Job> getBookPIData() {
		return bookPIData;
	}

	public void setBookPIData(List< Job> bookPIData) {
		this.bookPIData = bookPIData;
	}

	public String getOutput() {
		MessageGeneralFlow bean;

		output = "Hello :"+ new Date().toString();
		bean= chartManager.getHourlyMessages(conn.instance(), null);
		bean.complete();
		log.info(bean.toString());
		return output;
	}

	public void setOutput(String output) {
		this.output = output;
	}

	public BasicChart getBasicChart() {
		return basicChart;
	}

	public void setBasicChart(BasicChart basicChart) {
		this.basicChart = basicChart;
	}

}
