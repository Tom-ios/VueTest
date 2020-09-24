package com.hhwy.hbc.schedule.task.algorithm;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;

import com.hhwy.hbc.schedule.task.model.ScheTask;

 /**
 * <b>类 名 称：</b>LoopAlgorithm<br/>
 * <b>类 描 述：</b>回路检测<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月11日 下午6:12:14<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class LoopAlgorithm extends AlgorithmCalc {

	@Override
	public Object calcPath(List<ScheTask> taskList, Object conditionList) {
		// 已计算关键成本的任务
		HashSet<ScheTask> completed = new HashSet<ScheTask>();
		// 需要计算成本的任务
		HashSet<ScheTask> remaining = new HashSet<ScheTask>(taskList);

		// 前推算法
		// 有些任务的关键成本没有计算出来。
		while (!remaining.isEmpty()) {
			boolean progress = false;
			// find a new task to calculate
			for (Iterator<ScheTask> it = remaining.iterator(); it.hasNext();) {
				ScheTask task = it.next();
				if (completed.containsAll(task.dependencies)) {
					completed.add(task);
					it.remove();
					progress = true;
				}
			}
			if (!progress)
				throw new RuntimeException("Cyclic dependency, algorithm stopped!");
		}
		return true;
	}

}
