package com.hhwy.hbc.schedule.task.service;

import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.extension.service.IService;
import com.hhwy.hbc.schedule.task.model.ScheTask;

/**
 * <p>
 * 记录进度作业相关信息 服务类
 * </p>
 *
 * @author admin
 * @since 2020-03-05
 */
public interface ScheTaskService extends IService<ScheTask> {
	public List<ScheTask> getData(Map<String, Object> param);
	
	public List<Map<String,Object>> getCondition(List<ScheTask> taskList);

	/**
	 * @Title: saveScheTask
	 * @Description:(作业保存)
	 * @param scheTask
	 * @return 
	 * ScheTask
	 * <b>创 建 人：</b>pengle<br/>
	 * <b>创建时间:</b>2020年3月12日 下午1:58:07
	 * <b>修 改 人：</b>pengle<br/>
	 * <b>修改时间:</b>2020年3月12日 下午1:58:07
	 * @since  1.0.0
	 */
	public ScheTask saveScheTask(ScheTask scheTask);

	/**
	 * @Title: deleteScheTaskById
	 * @Description:(通过id删除作业)
	 * @param id 
	 * void
	 * <b>创 建 人：</b>pengle<br/>
	 * <b>创建时间:</b>2020年3月12日 下午4:23:56
	 * <b>修 改 人：</b>pengle<br/>
	 * <b>修改时间:</b>2020年3月12日 下午4:23:56
	 * @since  1.0.0
	 */
	public void deleteScheTaskById(String id);

	/**
	 * @Title: saveListScheTask
	 * @Description:(批量保存作业数据)
	 * @param scheTasks 
	 * void
	 * <b>创 建 人：</b>pengle<br/>
	 * <b>创建时间:</b>2020年3月12日 下午5:29:33
	 * <b>修 改 人：</b>pengle<br/>
	 * <b>修改时间:</b>2020年3月12日 下午5:29:33
	 * @return 
	 * @since  1.0.0
	 */
	public List<ScheTask> saveListScheTask(List<ScheTask> scheTasks);
}
