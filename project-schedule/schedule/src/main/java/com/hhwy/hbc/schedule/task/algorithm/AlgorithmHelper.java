package com.hhwy.hbc.schedule.task.algorithm;

import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.hhwy.hbc.schedule.task.model.ScheTask;

 /**
 * <b>类 名 称：</b>AlgorithmHelper<br/>
 * <b>类 描 述：</b>关键路径计算公共类<br/>
 * <b>创 建 人：</b>jsq<br/>
 * <b>修 改 人：</b>jsq<br/>
 * <b>修改时间：</b>2020年3月11日 下午6:11:32<br/>
 * <b>修改备注：</b><br/>
 * @version 1.0.0<br/>
 */
public class AlgorithmHelper {
	/**
	 * @Title: maxCost
	 * @Description:(计算总耗时)
	 * @param tasks
	 * @return 
	 * int
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月11日 下午3:05:11
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月11日 下午3:05:11
	 * @since  1.0.0
	 */
	public static int maxCost(List<ScheTask> tasks) {
		int max = -1;
		for (ScheTask t : tasks) {
			System.out.println("任务名称："+t.getTaskName()+"，关键时间："+t.getCriticalCost()+"，持续时间："+t.getPlanDuration());
			if (t.getCriticalCost() > max)
				max = t.getCriticalCost();
		}
		return max;
	}
	/**
	 * @Title: sortTasks
	 * @Description:(将所有作业按耗时排序)
	 * @param ret 
	 * void
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月11日 下午3:24:20
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月11日 下午3:24:20
	 * @since  1.0.0
	 */
	public static void sortTasks(List<ScheTask> ret) {
		// 按最早完成时间排序
		Collections.sort(ret, new Comparator<ScheTask>() {

			@Override
			public int compare(ScheTask o1, ScheTask o2) {

				int i = o2.getCriticalCost() - o1.getCriticalCost();
				if (i != 0)
					return i;

				if (o1.isDependent(o2))
					return -1;
				if (o2.isDependent(o1))
					return 1;
				return 0;
			}
		});
	}
}
