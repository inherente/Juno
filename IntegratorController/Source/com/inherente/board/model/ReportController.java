package com.inherente.board.model;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;

import com.inherente.board.handler.ReportHandler;
import com.inherente.db.bean.Activity;
import com.inherente.db.bean.BigRBean;
import com.inherente.db.bean.ColumnModel;
import com.inherente.db.bean.DiferenciaV3SAP;
import com.inherente.db.bean.Report;
import com.obelit.db.pool.Reusable;
import com.obelit.db.pool.SimpleConnectionPool;

@ManagedBean (name = "ReportController" )
@SessionScoped
public class ReportController {
	public static final String SUCCESS_JSF_CODE = "success";
	Logger log= Logger.getLogger(ReportController.class.getName());
	private Activity activityBean =new Activity();
	SimpleConnectionPool pool;
	private String reporte;
	Reusable conn;
	ReportHandler handler;
	private Report reportSelected;
	private List<Report > report;
	private List<DiferenciaV3SAP > diferencia;
	private List<BigRBean > rowReport;
	private List< ColumnModel>column;

	public ReportController() {
		log.info("inito");
		pool = new SimpleConnectionPool();
		conn= pool.acquireReusable();
		handler = new ReportHandler(conn.instance());
		init();

	}

	public void init () {
		ColumnModel item;

		column = new ArrayList<ColumnModel>();
		item =new ColumnModel("Name", "name");
		column.add(item);
		item =new ColumnModel("Function", "functionName");
		column.add(item);

		setReport(handler.updateReportCatallog(conn.instance()));
	}

	public String activitie () {
		log.info("ok");
		setReport(handler.updateReportCatallog(conn.instance()));

		log.info("n : " + activityBean.getName());

		return SUCCESS_JSF_CODE;
	}

	@SuppressWarnings("unchecked")
	public String defaulto () {
		Object[] returno =new Object [1 + 1];
		log.info("defaulta"); 
		if (reportSelected== null)log.info("Null Selelction by (defaul).");
		log.info("Selectin "+ (reportSelected==null? "none": reportSelected.getName()));
		returno= handler.wholeDefaultReport(conn.instance(), reportSelected.getName());
		setRowReport((List<BigRBean>) returno[1]);
		setColumn((List<ColumnModel>)returno[0]);

		log.info("n : " + activityBean.getName());

		return SUCCESS_JSF_CODE;
	}

	public String reporte () {
		log.info("reporte");
		handler.diffReport(conn.instance());
		setReport(handler.updateReportCatallog(conn.instance()));

		return SUCCESS_JSF_CODE;
	}

	public Activity getActivityBean() {
		return activityBean;
	}

	public void setActivityBean(Activity activityBean) {
		this.activityBean = activityBean;
	}

	public List< ColumnModel> getColumn() {
		return column;
	}

	public void setColumn(List< ColumnModel> columna) {
		column = null;
		log.info("Model with "+ columna.size() + " column(s)");
		column= columna;
	}

	public List<DiferenciaV3SAP > getDiferencia() {
		return diferencia;
	}

	public void setDiferencia(List<DiferenciaV3SAP > diferencia) {
		this.diferencia = diferencia;
	}

	public List<Report > getReport() {
		return report;
	}

	public void setReport(List<Report > report) {
		this.report = report;
	}

	public String getReporte() {
		return reporte;
	}

	public void setReporte(String reporte) {
		this.reporte = reporte;
	}

	public Report getReportSelected() {
		return reportSelected;
	}

	public void setReportSelected(Report reportSelected) {
		this.reportSelected = reportSelected;
	}

	public List<BigRBean > getRowReport() {
		return rowReport;
	}

	public void setRowReport(List<BigRBean > rowReport) {
		this.rowReport = rowReport;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
