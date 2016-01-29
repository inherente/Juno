package com.inherente.general.job;


import java.util.logging.Logger;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class SalesOrderGenerator extends WindowsCommand implements Job {
	static Logger log = Logger.getLogger(SalesOrderGenerator.class.getName());
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		log.info("¡Hello !");
		commandLine(null);

	}

	@Override
	public boolean commandLine(String command) {
		// TODO Auto-generated method stub
		command(null);
		return false;
	}

}
