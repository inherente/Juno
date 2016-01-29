package com.inherente.general.job;

import java.util.logging.Logger;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;



public class StupidLog implements Job {
	static Logger log = Logger.getLogger(StupidLog.class.getName());
	public static void main (String argmument[] ) {
		
		log.info("¡Hello World!");
		
	}
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// TODO Auto-generated method stub
		log.info("¡Hello World!");
	}

}
