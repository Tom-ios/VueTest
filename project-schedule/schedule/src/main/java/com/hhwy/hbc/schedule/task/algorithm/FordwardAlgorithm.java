package com.hhwy.hbc.schedule.task.algorithm;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.hhwy.hbc.schedule.helper.DateUtils;
import com.hhwy.hbc.schedule.task.model.ScheTask;

 /**
 * <b>类 名 称：</b>FordwardAlgorithm<br/>
 * <b>类 描 述：</b>前推计算<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月5日 下午3:53:35<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class FordwardAlgorithm  extends AlgorithmCalc{

	@Override
	public Object calcPath(List<ScheTask> taskList, Object conditionList) {
		//项目开始时间
		Date planStartDate = new Date(2020, 03, 9);
		Map<String,Integer> criticalCostMap = new HashMap<String,Integer>();
		// 已计算关键成本的任务
		HashSet<ScheTask> completed = new HashSet<ScheTask>();
		// 需要计算成本的任务
		HashSet<ScheTask> remaining = new HashSet<ScheTask>(taskList);
		// 前推算法
		// 有些任务的关键成本没有计算出来。
		while (!remaining.isEmpty()) {

			// find a new task to calculate
			for (Iterator<ScheTask> it = remaining.iterator(); it.hasNext();) {
				ScheTask task = it.next();
				if (completed.containsAll(task.dependencies)) {

					// all dependencies calculated, critical cost is max
					// dependency critical cost, plus our cost
					// 计算所有依赖项，关键成本为最大依赖项关键成本,加上我们的成本
					int critical = 0;
					for (ScheTask t : task.dependencies) {
						if (criticalCostMap.get(t.getId()) > critical) {
							critical = criticalCostMap.get(t.getId());
						}
					}
					//存放关键成本，便于后续取到
					criticalCostMap.put(task.getId(), critical+ task.getPlanDuration());
					// 关键路径耗时
					task.setCriticalCost(critical + task.getPlanDuration());

					task.setPlanStartDate(DateUtils.getDatePlusNotWeekend(planStartDate, critical));
					// 最早开始时间
					task.setEsDate(DateUtils.getDatePlusNotWeekend(planStartDate, critical));
					task.setPlanEndDate(
							DateUtils.getDatePlusNotWeekend(planStartDate, critical + task.getPlanDuration()));
					// 最早完成时间
					task.setEfDate(DateUtils.getDatePlusNotWeekend(planStartDate, critical + task.getPlanDuration()));

					// 将作业移除
					completed.add(task);
					it.remove();
					// note we are making progress
				}
			}
		}
		// 总耗时
		int maxCost = AlgorithmHelper.maxCost(taskList);
		System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
		System.out.println("总时长："+maxCost);
		System.out.println("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&");
		List<ScheTask> ret= new ArrayList<>(completed);
		AlgorithmHelper.sortTasks(ret);
		return completed;
	}
	
}
