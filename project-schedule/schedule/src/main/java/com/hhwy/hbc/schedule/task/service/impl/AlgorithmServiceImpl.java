package com.hhwy.hbc.schedule.task.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;

import com.hhwy.hbc.schedule.task.algorithm.BackStepAlgorithm;
import com.hhwy.hbc.schedule.task.algorithm.FordwardAlgorithm;
import com.hhwy.hbc.schedule.task.algorithm.FreeFloatAlgorithm;
import com.hhwy.hbc.schedule.task.algorithm.LoopAlgorithm;
import com.hhwy.hbc.schedule.task.algorithm.PrimaryEntry;
import com.hhwy.hbc.schedule.task.model.ScheTask;
import com.hhwy.hbc.schedule.task.service.AlgorithmService;

 /**
 * <b>类 名 称：</b>AlgorithmServiceImpl<br/>
 * <b>类 描 述：</b>关键路径算法逻辑<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月5日 下午4:10:05<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
@Service
public class AlgorithmServiceImpl implements AlgorithmService{
	
	/**
	 * 关键路径计算
	 */
	public String calcStart(List<ScheTask> taskList,Object conditionList){
		String path ="";
		//算法入口
		PrimaryEntry entry =  new PrimaryEntry(taskList,conditionList);
		
		//回路检测法
		try {
			entry.getCalcResult(new LoopAlgorithm());
		} catch (Exception e) {
			e.printStackTrace();
			return "作业之间存在回路，请检查!";
		}
	    //前推法
		entry.getCalcResult(new FordwardAlgorithm());
		//后推法
		entry.getCalcResult(new BackStepAlgorithm());
		//...时差计算
		//...关键活动
		List<ScheTask> list=(List<ScheTask>) entry.getCalcResult(new FreeFloatAlgorithm());
		
		for (ScheTask scheTask : list) {
			path+=scheTask.getTaskName()+"-->";
		}
		//...关键路径
		
		return path;
	}
}
