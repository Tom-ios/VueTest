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
 * <b>类 名 称：</b>BackStepAlgorithm<br/>
 * <b>类 描 述：</b>后推计算<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月5日 下午3:53:35<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class BackStepAlgorithm  extends AlgorithmCalc{

	@Override
	public Object calcPath(List<ScheTask> taskList, Object conditionList) {
		Date planStartDate = new Date(2020, 03, 9);
		int maxCost = 71;
		ScheTask ta = taskList.get(0);
		// 项目最晚完成时间
		Date dateMax = DateUtils.getDatePlus(ta.getPlanStartDate(), maxCost);
		// 已计算关键成本的任务
		HashSet<ScheTask> completed = new HashSet<ScheTask>();
		// 需要计算成本的任务
		HashSet<ScheTask> remaining = new HashSet<ScheTask>(taskList);

		Map<String,Integer> criticalCostMap = new HashMap<String,Integer>();
		
		// 后推算法
		// 有些任务的关键成本没有计算出来。
		while (!remaining.isEmpty()) {

			for (Iterator<ScheTask> it = remaining.iterator(); it.hasNext();) {
				ScheTask task = it.next();
				if (completed.containsAll(task.beDependencies)) {
					// 计算所有被依赖项，关键成本为最小依赖项关键成本,减去成本
					int critical = maxCost;
					for (ScheTask t : task.beDependencies) {
//						if (t.getCriticalCost() - t.getPlanDuration() < critical) {
//							critical = t.getCriticalCost() - t.getPlanDuration();
//						}
						if (criticalCostMap.get(t.getId()) - t.getPlanDuration() < critical) {
							critical = criticalCostMap.get(t.getId()) - t.getPlanDuration();
						}
					}

					criticalCostMap.put(task.getId(), critical);
					
					// 最晚开始时间
					task.setLsDate(DateUtils.getDatePlusNotWeekend(planStartDate, critical - task.getPlanDuration()));
					// 最晚完成时间
					task.setLfDate(DateUtils.getDatePlusNotWeekend(planStartDate, critical));
					// task.setCriticalCost(critical);
					// 将作业移除
					completed.add(task);
					it.remove();
				}
			}
		}
		
		List<ScheTask> ret = new ArrayList<>(completed);
		AlgorithmHelper.sortTasks(ret);
		return ret;
	}

}
