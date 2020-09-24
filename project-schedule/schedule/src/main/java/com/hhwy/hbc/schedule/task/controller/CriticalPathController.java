package com.hhwy.hbc.schedule.task.controller;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hhwy.hbc.schedule.task.algorithm.AlgorithmCalc;
import com.hhwy.hbc.schedule.task.model.ScheTask;
import com.hhwy.hbc.schedule.task.service.AlgorithmService;
import com.hhwy.hbc.schedule.task.service.ScheTaskService;

/**
 * <b>类 名 称：</b>CriticalPathController<br/>
 * <b>类 描 述：</b>关键路径计算控制器<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>创建时间：</b>2020年3月5日 下午2:39:43<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月5日 下午2:39:43<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
@RestController
@RequestMapping("/criticalPath")
public class CriticalPathController {
	
	@Autowired
	private ScheTaskService scheTaskService;
	
	@Autowired
	public AlgorithmService algorithmService;
	
	/**
	 * @Title: getCriticalPath
	 * @Description:(控制层：获取关键路径)
	 * @param param
	 * @return 
	 * String
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月5日 下午2:45:48
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月5日 下午2:45:48
	 * @since  1.0.0
	 */
	@GetMapping("/getCriticalPath")
	public String getCriticalPath(@RequestParam Map<String,Object> param){
		/**
		 * 获取作业数据集合信息（包含逻辑、限制条件关系）
		 */
		List<ScheTask> taskList = scheTaskService.getData(param);
		/**
		 * 获取外部公共限制条件信息
		 */
		List<Map<String,Object>> conditionList = scheTaskService.getCondition(taskList);
		/**
		 * 关键路径计算
		 */
		String path = algorithmService.calcStart(taskList, conditionList);
		
		return path;
	}
}
