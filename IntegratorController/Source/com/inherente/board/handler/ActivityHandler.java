package com.inherente.board.handler;

import java.sql.Connection;
import java.util.List;
import java.util.logging.Logger;

import com.inherente.db.bean.Activity;

import com.inherente.db.model.ActivityManager;
import com.inherente.db.model.JobManagerFactory;


public class ActivityHandler {
	Connection conn;
	ActivityManager jManager;
	Logger log= Logger.getLogger(ActivityHandler.class.getName());
	private List< Activity>bookData;
	public ActivityHandler (Connection con) {
		conn= con;
		jManager = JobManagerFactory.buildActivityManager(null);
		setBookData (jManager.getActivityCatalog(con));
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public boolean addAdcivity( String u, String rol) {
		return addAdcivity(null, u , rol, null);
		
	}

	public boolean addAdcivity( Connection con, String name, String funName, String displayName) {
		boolean b =false;

		log.info("log-on");
		log.info(name + " ("+ null + ")");
		if (con == null) con = conn;
		jManager.addActivity( con, "0", name, funName, displayName);
		return b;

	}

	public List< Activity> updateAdcivityGalerry( Connection con) {
		List< Activity> returnV;
		

		log.info("log-on");
		if (con == null) con = conn;
		returnV= jManager.getActivityCatalog( con);
		setBookData(returnV);
		return returnV;

	}

	public List< Activity> getBookData() {
		return bookData;
	}

	public void setBookData(List< Activity> bookData) {
		this.bookData = bookData;
	}
	

}
