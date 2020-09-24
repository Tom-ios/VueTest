package com.hhwy.hbc.schedule.task.mapper;

import java.util.List;
import java.util.Map;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.hhwy.hbc.schedule.task.model.ScheTask;

/**
 * <p>
 * 记录进度作业相关信息 Mapper 接口
 * </p>
 *
 * @author admin
 * @since 2020-03-05
 */
public interface ScheTaskMapper extends BaseMapper<ScheTask> {

	List<ScheTask> selectScheTasks(Map<String, Object> param);

}
