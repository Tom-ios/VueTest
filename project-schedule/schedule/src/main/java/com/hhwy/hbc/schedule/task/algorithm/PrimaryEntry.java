package com.hhwy.hbc.schedule.task.algorithm;

import java.util.List;

import com.hhwy.hbc.schedule.task.model.ScheTask;

 /**
 * <b>类 名 称：</b>PrimaryEntry<br/>
 * <b>类 描 述：</b>算法入口<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月5日 下午4:18:44<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class PrimaryEntry {
	
	List<ScheTask> taskList;
	Object conditionList;
	
	
	/**
	 * @param taskList
	 * @param conditionList
	 */
	public PrimaryEntry(List<ScheTask> taskList, Object conditionList) {
		super();
		this.taskList = taskList;
		this.conditionList = conditionList;
	}

	/**
	 * @Title: getCalcResult
	 * @Description:(计算方法)
	 * @param calc
	 * @return 
	 * Object
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月11日 下午6:12:40
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月11日 下午6:12:40
	 * @since  1.0.0
	 */
	public Object  getCalcResult(AlgorithmCalc calc){
		return calc.calcPath(taskList, conditionList);
		
	}
}
