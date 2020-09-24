package com.hhwy.hbc.schedule.task.controller;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hhwy.hbc.schedule.task.model.ScheTask;
import com.hhwy.hbc.schedule.task.service.ScheTaskService;
import com.hhwy.hbc.schedule.task.service.ScheWbsService;


/**
 * <p>
 *  进度计划管理控制器
 * </p>
 *
 * @author admin
 * @since 2020-03-13
 */
@RestController
@RequestMapping("/schePlanTask")
public class SchePlanController {
	
	@Autowired 
	private ScheTaskService taskService;
	
	@Autowired 
	private ScheWbsService wbsService;
	
	
	/********************作业处理方法*************************/
	/**
	 * @Title: getData
	 * @Description:(作业处理方法)
	 * @param params
	 * @return 
	 * List<ScheTask>
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月13日 下午4:28:20
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月13日 下午4:28:20
	 * @since  1.0.0
	 */
	@GetMapping("/getTaskData")
	public List<ScheTask> getTaskData(@RequestParam Map<String, Object> params){
		return null;
	}
	
	
	
	
	
	/********************WBS处理方法*************************/
	/**
	 * @Title: getData
	 * @Description:(WBS处理方法)
	 * @param params
	 * @return 
	 * List<ScheTask>
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月13日 下午4:28:20
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月13日 下午4:28:20
	 * @since  1.0.0
	 */
	@GetMapping("/getWbsData")
	public List<ScheTask> getWbsData(@RequestParam Map<String, Object> params){
		return null;
	}
	
	//...................
}

