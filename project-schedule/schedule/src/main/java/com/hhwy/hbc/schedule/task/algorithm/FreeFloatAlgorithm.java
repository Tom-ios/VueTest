package com.hhwy.hbc.schedule.task.algorithm;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;

import org.apache.commons.collections.CollectionUtils;

import com.hhwy.hbc.schedule.helper.DateUtils;
import com.hhwy.hbc.schedule.task.model.ScheTask;

public class FreeFloatAlgorithm  extends AlgorithmCalc{

	@Override
	public Object calcPath(List<ScheTask> taskList, Object conditionList) {
		List<ScheTask> list=new ArrayList<ScheTask>();
		if(CollectionUtils.isNotEmpty(taskList)){
			for (ScheTask scheTask : taskList) {
				int betwenday=0;
				try {
					betwenday = DateUtils.daysBetween(scheTask.getEsDate(), scheTask.getLsDate());
					scheTask.setFreeFloat(betwenday);
					if(betwenday==0){
						scheTask.setCriticalTask(1);
						list.add(scheTask);
					}
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
			
		}
		return list;
	}

}
