package com.hhwy.hbc.schedule.task.model;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.activerecord.Model;

import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.io.Serializable;
import java.util.Date;

/**
 * <p>
 * 记录WBS计划编制（分级编制）信息
 * </p>
 *
 * @author admin
 * @since 2020-03-17
 */
@TableName("com_sche_wbs")
public class ScheWbs extends Model<ScheWbs> {

    private static final long serialVersionUID = 1L;

    private String id;

    /**
     * WBS编码，根节点和项目共用编码，默认项目编码，父节点编码作为子节点编码的前缀
            （定义一套编码规则即可，如父节点为AB10，则子节点为AB1001..AB1099）
     */
    private String wbsCode;

    /**
     * WBS名称，默认项目名称
     */
    private String wbsName;

    /**
     * 父ID
     */
    private String parentId;

    /**
     * 计划级别：1：一级计划，2：二级计划 .........
     */
    private String level;

    /**
     * 路径，通过.分割，如：01.0101.010101
     */
    private String path;

    /**
     * 项目id
     */
    private String projectId;

    /**
     * 责任人，从资源字典中选择，资源ID
     */
    private String principalId;

    /**
     * 权重
     */
    private Double weights;

    /**
     * 计划开始日期
     */
    private Date planStartDate;

    /**
     * 计划结束日期
     */
    private Date planEndDate;

    /**
     * 计划工期
     */
    private Integer planDuration;

    /**
     * 创建人
     */
    private String createUser;

    /**
     * 创建时间
     */
    private Timestamp createTime;

    /**
     * 更新人
     */
    private String updateUser;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getWbsCode() {
        return wbsCode;
    }

    public void setWbsCode(String wbsCode) {
        this.wbsCode = wbsCode;
    }

    public String getWbsName() {
        return wbsName;
    }

    public void setWbsName(String wbsName) {
        this.wbsName = wbsName;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public String getPrincipalId() {
        return principalId;
    }

    public void setPrincipalId(String principalId) {
        this.principalId = principalId;
    }

    public Double getWeights() {
        return weights;
    }

    public void setWeights(Double weights) {
        this.weights = weights;
    }

    public Date getPlanStartDate() {
        return planStartDate;
    }

    public void setPlanStartDate(Date planStartDate) {
        this.planStartDate = planStartDate;
    }

    public Date getPlanEndDate() {
        return planEndDate;
    }

    public void setPlanEndDate(Date planEndDate) {
        this.planEndDate = planEndDate;
    }

    public void setCreateTime(Timestamp createTime) {
        this.createTime = createTime;
    }

    public Integer getPlanDuration() {
        return planDuration;
    }

    public void setPlanDuration(Integer planDuration) {
        this.planDuration = planDuration;
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

    @Override
    protected Serializable pkVal() {
        return this.id;
    }

    @Override
    public String toString() {
        return "ScheWbs{" +
        "id=" + id +
        ", wbsCode=" + wbsCode +
        ", wbsName=" + wbsName +
        ", parentId=" + parentId +
        ", level=" + level +
        ", path=" + path +
        ", projectId=" + projectId +
        ", principalId=" + principalId +
        ", weights=" + weights +
        ", planStartDate=" + planStartDate +
        ", planEndDate=" + planEndDate +
        ", planDuration=" + planDuration +
        ", createUser=" + createUser +
        ", createTime=" + createTime +
        ", updateUser=" + updateUser +
        "}";
    }
}
