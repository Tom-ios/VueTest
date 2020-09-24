package com.hhwy.hbc.schedule.task.service;

import com.hhwy.hbc.schedule.task.model.ScheTaskRelationship;
import com.baomidou.mybatisplus.extension.service.IService;

/**
 * <p>
 *  服务类
 * </p>
 *
 * @author cc
 * @since 2020-03-11
 */
public interface ScheTaskRelationshipService extends IService<ScheTaskRelationship> {

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
	void deleteScheTaskRelationshipByTaskId(String id);

}
