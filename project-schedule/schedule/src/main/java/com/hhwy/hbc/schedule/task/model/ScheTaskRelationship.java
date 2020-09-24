package com.hhwy.hbc.schedule.task.model;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.activerecord.Model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * <p>
 * 
 * </p>
 *
 * @author cc
 * @since 2020-03-11
 */
@TableName("com_sche_task_relationship")
public class ScheTaskRelationship extends Model<ScheTaskRelationship> {

    private static final long serialVersionUID = 1L;

    /**
     * 主键
     */
    private String id;

    /**
     * 计划1
     */
    private String taskPreId;

    /**
     * 计划2
     */
    private String taskNextId;

    /**
     * 逻辑关系
     */
    private String relationshipId;

    /**
     * 延时（天）
     */
    private Integer intervalDays;

    /**
     * 创建时间
     */
    private Timestamp createTime;

    /**
     * 创建人
     */
    private String createUser;

    /**
     * 更新人
     */
    private String updateUser;

    /**
     * 更新时间
     */
    private Timestamp updateTime;

    /**
     * 0：未删除；1：删除
     */
    private Integer deleteFlag;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTaskPreId() {
        return taskPreId;
    }

    public void setTaskPreId(String taskPreId) {
        this.taskPreId = taskPreId;
    }

    public String getTaskNextId() {
        return taskNextId;
    }

    public void setTaskNextId(String taskNextId) {
        this.taskNextId = taskNextId;
    }

    public String getRelationshipId() {
        return relationshipId;
    }

    public void setRelationshipId(String relationshipId) {
        this.relationshipId = relationshipId;
    }

    public Integer getIntervalDays() {
        return intervalDays;
    }

    public void setIntervalDays(Integer intervalDays) {
        this.intervalDays = intervalDays;
    }

    public Timestamp getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public Timestamp getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Timestamp updateTime) {
        this.updateTime = updateTime;
    }

    public Integer getDeleteFlag() {
        return deleteFlag;
    }

    public void setDeleteFlag(Integer deleteFlag) {
        this.deleteFlag = deleteFlag;
    }

    @Override
    protected Serializable pkVal() {
        return this.id;
    }

    @Override
    public String toString() {
        return "ScheTaskRelationship{" +
        "id=" + id +
        ", taskPreId=" + taskPreId +
        ", taskNextId=" + taskNextId +
        ", relationshipId=" + relationshipId +
        ", intervalDays=" + intervalDays +
        ", createTime=" + createTime +
        ", createUser=" + createUser +
        ", updateUser=" + updateUser +
        ", updateTime=" + updateTime +
        ", deleteFlag=" + deleteFlag +
        "}";
    }
}
