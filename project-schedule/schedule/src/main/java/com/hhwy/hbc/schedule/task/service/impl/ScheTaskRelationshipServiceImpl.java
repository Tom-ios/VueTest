package com.hhwy.hbc.schedule.task.service.impl;

import com.hhwy.hbc.schedule.task.model.ScheTaskRelationship;
import com.hhwy.hbc.schedule.task.mapper.ScheTaskRelationshipMapper;
import com.hhwy.hbc.schedule.task.service.ScheTaskRelationshipService;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;

import org.springframework.stereotype.Service;

/**
 * <p>
 *  服务实现类
 * </p>
 *
 * @author cc
 * @since 2020-03-11
 */
@Service
public class ScheTaskRelationshipServiceImpl extends ServiceImpl<ScheTaskRelationshipMapper, ScheTaskRelationship> implements ScheTaskRelationshipService {

	/**
	 * @Title: deleteScheTaskRelationshipByTaskId
	 * @Description:(通过作业id删除关系)
	 * @param id 
	 * void
	 * <b>创 建 人：</b>pengle<br/>
	 * <b>创建时间:</b>2020年3月12日 下午4:33:02
	 * <b>修 改 人：</b>pengle<br/>
	 * <b>修改时间:</b>2020年3月12日 下午4:33:02
	 * @since  1.0.0
	 */
	@Override
	public void deleteScheTaskRelationshipByTaskId(String id) {
		
		deleteTaskRelationByPreId(id);
		deleteTaskRelationByNextId(id);
	}
	
	/**
	 * @Title: deleteTaskRelationByPreId
	 * @Description:(删除作业自己的前置任务关系)
	 * @param preId 
	 * void
	 * <b>创 建 人：</b>pengle<br/>
	 * <b>创建时间:</b>2020年3月12日 下午4:35:44
	 * <b>修 改 人：</b>pengle<br/>
	 * <b>修改时间:</b>2020年3月12日 下午4:35:44
	 * @since  1.0.0
	 */
	public  void deleteTaskRelationByPreId(String preId){
		QueryWrapper<ScheTaskRelationship> queryWrapper=new QueryWrapper<ScheTaskRelationship>();
		queryWrapper.eq("task_pre_id", preId);
		this.remove(queryWrapper);
	}
	
	/**
	 * @Title: deleteTaskRelationByNextId
	 * @Description:(删除以当前作业为前缀的任务关系)
	 * @param nextId 
	 * void
	 * <b>创 建 人：</b>pengle<br/>
	 * <b>创建时间:</b>2020年3月12日 下午4:36:41
	 * <b>修 改 人：</b>pengle<br/>
	 * <b>修改时间:</b>2020年3月12日 下午4:36:41
	 * @since  1.0.0
	 */
	public  void deleteTaskRelationByNextId(String nextId){
		QueryWrapper<ScheTaskRelationship> queryWrapper=new QueryWrapper<ScheTaskRelationship>();
		queryWrapper.eq("task_next_id", nextId);
		this.remove(queryWrapper);
	}

}
