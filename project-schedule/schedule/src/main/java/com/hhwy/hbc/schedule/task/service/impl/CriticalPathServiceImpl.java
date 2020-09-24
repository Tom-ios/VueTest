package com.hhwy.hbc.schedule.task.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;

import com.hhwy.hbc.schedule.task.algorithm.AlgorithmCalc;
import com.hhwy.hbc.schedule.task.model.ScheTask;
import com.hhwy.hbc.schedule.task.service.CriticalPathService;
import com.hhwy.hbc.schedule.task.service.ScheTaskService;

/**
 * <b>类 名 称：</b>CriticalPathServiceImpl<br/>
 * <b>类 描 述：</b>业务层：获取关键路径<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月5日 下午2:49:07<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class CriticalPathServiceImpl implements CriticalPathService{
	
	@Autowired
	private ScheTaskService scheTaskService;
	
	/**
	 * @Title: getCriticalPath
	 * @Description:(业务层：获取关键路径)
	 * @param param
	 * @return 
	 * String
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月5日 下午2:45:48
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月5日 下午2:45:48
	 * @since  1.0.0
	 */
	public String getCriticalPath(Map<String, Object> param) {
		/**
		 * 获取作业数据集合信息（包含逻辑关系）
		 */
		List<ScheTask> taskList = scheTaskService.getData(param);
		/**
		 * 获取作业限制条件信息
		 */
//		List<String> conditionList = scheTaskService.getCondition(taskList.get(0));
		/**
		 * 关键路径计算
		 */
		return null;
	}
	
}
