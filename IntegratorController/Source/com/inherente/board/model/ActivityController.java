package com.inherente.board.model;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import javax.faces.bean.ManagedBean;
import javax.faces.bean.SessionScoped;

import com.inherente.board.handler.ActivityHandler;
import com.inherente.db.bean.Activity;
import com.inherente.db.bean.ColumnModel;
import com.obelit.db.pool.Reusable;
import com.obelit.db.pool.SimpleConnectionPool;

@ManagedBean (name = "ActivityController" )
@SessionScoped
public class ActivityController {
	public static final String SUCCESS_JSF_CODE = "success";
	Logger log= Logger.getLogger(ActivityController.class.getName());
	private Activity activityBean =new Activity();
	SimpleConnectionPool pool;
	Reusable conn;
	ActivityHandler handler;
	private List< Activity>activity;
	private List< ColumnModel>column;

	public ActivityController() {
		log.info("inito");
		pool = new SimpleConnectionPool();
		conn= pool.acquireReusable();
		handler = new ActivityHandler(conn.instance());
		init();

	}

	public void init () {
		ColumnModel item;

		column = new ArrayList<ColumnModel>();
		item =new ColumnModel("Name", "name");
		column.add(item);
		item =new ColumnModel("Function", "functionName");
		column.add(item);

		setActivity(handler.updateAdcivityGalerry(conn.instance()));
	}

	public String activitie () {
		log.info("ok");
		handler.addAdcivity(conn.instance(), activityBean.getName(), activityBean.getFunctionName(), activityBean.getName());
		setActivity(handler.updateAdcivityGalerry(conn.instance()));

		log.info("n : " + activityBean.getName());

		return SUCCESS_JSF_CODE;
	}

	public Activity getActivityBean() {
		return activityBean;
	}

	public void setActivityBean(Activity activityBean) {
		this.activityBean = activityBean;
	}

	public List< Activity> getActivity() {
		return activity;
	}

	public void setActivity(List< Activity> activity) {
		this.activity = activity;
	}

	public List< ColumnModel> getColumn() {
		return column;
	}

	public void setColumn(List< ColumnModel> column) {
		this.column = column;
	}

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub

	}

}
