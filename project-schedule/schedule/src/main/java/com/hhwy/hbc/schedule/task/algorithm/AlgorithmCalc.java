package com.hhwy.hbc.schedule.task.algorithm;

import java.util.List;

import com.hhwy.hbc.schedule.task.model.ScheTask;

/**
 * <b>类 名 称：</b>AlgorithmCalc<br/>
 * <b>类 描 述：</b>关键路径计算算法<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月5日 下午3:40:51<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public abstract class AlgorithmCalc {
	/**
	 * @Title: calc
	 * @Description:(计算算法)
	 * @param param
	 * @return 
	 * List<String>
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月5日 下午2:45:48
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月5日 下午2:45:48
	 * @since  1.0.0
	 */
	public abstract Object calcPath(List<ScheTask> taskList,Object conditionList);
	
}
