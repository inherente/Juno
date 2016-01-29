package com.inherente.board.handler;

import java.sql.Connection;
import java.util.logging.Logger;

import com.inherente.db.model.JobManager;
import com.inherente.db.model.JobManagerFactory;


public class CommonHandler {
	Connection conn;
	JobManager jManager;
	Logger log= Logger.getLogger(CommonHandler.class.getName());
	public CommonHandler (Connection con) {
		conn= con;
		jManager = JobManagerFactory.buildJobManager(null);
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

	public boolean logon( String u, String rol) {
		return logon(null, u , rol);
		
	}

	public boolean logon( Connection con, String u, String rol) {
		String member;
		boolean b =false;

		log.info("log-on");
		log.info(u + " ("+ rol + ")");
		if (con == null) con = conn;
		member= jManager.logon( con, u, rol);
		b= member==null || "Null".equalsIgnoreCase(member)? false: true;
		return b;

	}

}
