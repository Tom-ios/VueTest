package com.hhwy.hbc.schedule.task.service;

import java.util.List;

import com.hhwy.hbc.schedule.task.model.ScheTask;

public interface AlgorithmService{
	public String calcStart(List<ScheTask> taskList,Object conditionList);
}
