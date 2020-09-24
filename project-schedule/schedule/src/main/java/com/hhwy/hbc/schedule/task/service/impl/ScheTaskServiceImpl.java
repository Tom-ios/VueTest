package com.hhwy.hbc.schedule.task.service.impl;

import cn.hutool.core.lang.UUID;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.hhwy.hbc.schedule.helper.UUIDUtil;
import com.hhwy.hbc.schedule.task.mapper.ScheTaskMapper;
import com.hhwy.hbc.schedule.task.model.ScheTask;
import com.hhwy.hbc.schedule.task.model.ScheTaskRelationship;
import com.hhwy.hbc.schedule.task.service.ScheTaskRelationshipService;
import com.hhwy.hbc.schedule.task.service.ScheTaskService;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * <p>
 * 记录进度作业相关信息 服务实现类
 * </p>
 *
 * @author admin
 * @since 2020-03-05
 */
@Service
public class ScheTaskServiceImpl extends ServiceImpl<ScheTaskMapper, ScheTask> implements ScheTaskService {
	@Autowired
	private ScheTaskMapper scheTaskMapper;
	
	@Autowired
	private ScheTaskRelationshipService scheTaskRelationshipService;
	
	/**
	 * @Title: getData
	 * @Description:(获取作业数据集合信息（包含逻辑关系信息）)
	 * @param param
	 * @return 
	 * List<ScheTask>
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月5日 下午2:45:48
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月5日 下午2:45:48
	 * @since  1.0.0
	 */
	@Override
	public List<ScheTask> getData(Map<String, Object> param) {
		String projectId=(String) param.get("projectId");
		if(StringUtils.isEmpty(projectId)){
			return new ArrayList<ScheTask>();
		}
		List<ScheTask> scheTasks=scheTaskMapper.selectScheTasks(param);
		return scheTasks;
	}

	/**
	 * @Title: getCondition
	 * @Description:(获取作业限制条件信息）)
	 * @param param
	 * @return 
	 * List<String>
	 * <b>创 建 人：</b>jsq<br/>
	 * <b>创建时间:</b>2020年3月5日 下午2:45:48
	 * <b>修 改 人：</b>jsq<br/>
	 * <b>修改时间:</b>2020年3月5日 下午2:45:48
	 * @since  1.0.0
	 */
	@Override
	public List<Map<String,Object>> getCondition(List<ScheTask> taskList) {
		// TODO Auto-generated method stub
		return null;
	}
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
	@Override
	public ScheTask saveScheTask(ScheTask scheTask) {
		this.save(scheTask);
		
		HashSet<ScheTask> dependencies = scheTask.getDependencies();
		if(CollectionUtils.isNotEmpty(dependencies)){
			handScheTaskRelationship(dependencies,scheTask);
			
		}
		return scheTask;
	}
	
	/**
	 * @Title: handScheTaskRelationship
	 * @Description:(处理前置任务关系保存)
	 * @param dependencies
	 * @param scheTask 
	 * void
	 * <b>创 建 人：</b>pengle<br/>
	 * <b>创建时间:</b>2020年3月12日 下午3:55:20
	 * <b>修 改 人：</b>pengle<br/>
	 * <b>修改时间:</b>2020年3月12日 下午3:55:20
	 * @since  1.0.0
	 */
	public void handScheTaskRelationship(HashSet<ScheTask> dependencies, ScheTask scheTask){
		
		List<ScheTaskRelationship> list=new ArrayList<ScheTaskRelationship>();
		for (ScheTask scheTask2 : dependencies) {
			ScheTaskRelationship scheTaskRelationship=new ScheTaskRelationship();
			scheTaskRelationship.setId(UUIDUtil.get32UUID());
			scheTaskRelationship.setTaskPreId(scheTask2.getId());
			scheTaskRelationship.setTaskNextId(scheTask.getId());
			scheTaskRelationship.setDeleteFlag(0);
		}
		
		scheTaskRelationshipService.saveBatch(list);
	}

	@Override
	public void deleteScheTaskById(String id) {
		this.removeById(id);
		scheTaskRelationshipService.deleteScheTaskRelationshipByTaskId(id);
		
	}

	@Override
	public List<ScheTask> saveListScheTask(List<ScheTask> scheTasks) {
		this.saveOrUpdateBatch(scheTasks);
		return scheTasks;
	}
	
}
