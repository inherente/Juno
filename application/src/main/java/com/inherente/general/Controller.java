package com.inherente.general;

import java.util.logging.Logger;
import static org.quartz.JobBuilder.newJob;
import static org.quartz.TriggerBuilder.newTrigger;
import static org.quartz.SimpleScheduleBuilder.simpleSchedule;


import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerException;
import org.quartz.Trigger;
import org.quartz.impl.StdSchedulerFactory;

public class Controller {
	static Logger log = Logger.getLogger(Controller.class.getName());
	Trigger trigger = null; 
	Scheduler anScheduler;
	JobDetail job = null;

	public Controller () {
		trigger = newTrigger().withIdentity("myTrigger", "groupo")
			      .startNow()
			      .withSchedule(simpleSchedule()
			          .withIntervalInSeconds(60)
			          .repeatForever())
			      .build();
	}

	public void doIt () {
		if (anScheduler == null) {
			try {
				anScheduler = StdSchedulerFactory.getDefaultScheduler();
			} catch (SchedulerException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
					
		}
		try {
			anScheduler.start();// JobDetail otherJob = new JobDetail("jobName",com.inherente.general.job.StupidLog.class);

			job= newJob(com.inherente.general.job.SalesOrderGenerator.class).withIdentity("jobo", "groupo").build();
			anScheduler.scheduleJob(job, trigger);// anScheduler.shutdown();
		} catch (SchedulerException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		log.info("done");

		
	}
	public static void main (String argmument[] ) {
		
		log.info("¡Hello World!");
		new Controller().doIt();
		
	}

}
