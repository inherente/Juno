package com.inherente.board.handler;

import java.sql.Connection;
import java.util.List;
import java.util.logging.Logger;


import com.inherente.db.bean.DiferenciaV3SAP;
import com.inherente.db.bean.Report;

import com.inherente.db.model.JobManagerFactory;
import com.inherente.db.model.ReportManager;


public class ReportHandler {
	Connection conn;
	ReportManager jManager;
	Logger log= Logger.getLogger(ReportHandler.class.getName());
	private List< Report>bookData;
	public ReportHandler (Connection con) {
		conn= con;
		jManager = JobManagerFactory.buildReportManager(null);// setBookData (jManager.getActivityCatalog(con));
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public List< DiferenciaV3SAP> updateReportGalerry( Connection con) {
		List< DiferenciaV3SAP> returnV;
		
		log.info("log-on");
		if (con == null) con = conn;
		returnV= jManager.diferenciaV3SAP(con, null);
	 //	setBookData(returnV);
		return returnV;

	}

	public List< Report> updateReportCatallog( Connection con) {
		List< Report> returnV= null;
		
		log.info("log-on");
		if (con == null) con = conn;
		returnV= jManager.getReportCatalog(con);

	 //	setBookData(returnV);
		return returnV;

	}


	public List< DiferenciaV3SAP> diffReport( Connection con) {
		List< DiferenciaV3SAP> returnV= null;//	Object[] returno= null;

		log.info("log-on");
		if (con == null) con = conn;
		returnV= jManager.diferenciaV3SAP(con, null);
		log.info("-unchequed");
	 //	if (returno != null && returno.length> 1) returnV= (List<DiferenciaV3SAP>) returno[1];
		return returnV;

	}

	public Object[] wholeDiffReport( Connection con) {
		Object[] returno =new Object [1 + 1];//	List< DiferenciaV3SAP> returnV= null;

		log.info("log-on");
		if (con == null) con = conn;
		returno= jManager.reporteDiferenciaV3SAP(con, null);// returnV= ((List< DiferenciaV3SAP>) returno[1]);
		log.info("-unchequed");
	 //	if (returno != null && returno.length> 1) returnV= (List<DiferenciaV3SAP>) returno[1];
		return returno;

	}

	public Object[] wholeDefaultReport( Connection con, String name) {
		Object[] returno =new Object [1 + 1];//	List< DiferenciaV3SAP> returnV= null;

		log.info("log-er");
		if (con == null) con = conn;
		returno= jManager.reporteDiferencial(con, name);// returnV= ((List< DiferenciaV3SAP>) returno[1]);
		log.info("-unchequed");

		return returno;

	}

	public List< Report> getBookData() {
		return bookData;
	}

	public void setBookData(List< Report> bookData) {
		this.bookData = bookData;
	}
	

}
