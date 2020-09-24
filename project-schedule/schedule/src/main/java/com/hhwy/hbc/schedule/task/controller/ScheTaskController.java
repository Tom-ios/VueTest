package com.hhwy.hbc.schedule.task.controller;


import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hhwy.hbc.schedule.helper.UUIDUtil;
import com.hhwy.hbc.schedule.task.model.ScheTask;
import com.hhwy.hbc.schedule.task.service.ScheTaskService;

/**
 * <p>
 * 记录进度作业相关信息 前端控制器
 * </p>
 *
 * @author admin
 * @since 2020-03-05
 */
@RestController
@RequestMapping("/scheTask")
public class ScheTaskController {
	
	@Autowired
	public ScheTaskService scheTaskService;
	
	@GetMapping
	public List<ScheTask> getData(@RequestParam Map<String, Object> params){
		return scheTaskService.getData(params);
	}
	@PostMapping
	public ScheTask saveScheTask(@RequestBody ScheTask scheTask){
		if(StringUtils.isEmpty(scheTask.getId())){
			scheTask.setId(UUIDUtil.get32UUID());
		}
	
		return scheTaskService.saveScheTask(scheTask);
	}
	
	@DeleteMapping("/{id}")
	public void deleteScheTaskById(@PathVariable String id){
		 scheTaskService.deleteScheTaskById(id);
		
	}
	
	@PostMapping("/saveListScheTask")
	public  List<ScheTask> saveListScheTask(@RequestBody List<ScheTask> scheTasks){
		return scheTaskService.saveListScheTask(scheTasks);
		
	}
	
}

