package com.hhwy.hbc.schedule.template.model;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import java.time.LocalDateTime;
import java.io.Serializable;

/**
 * <p>
 * 记录WBS模板相关信息
 * </p>
 *
 * @author admin
 * @since 2020-03-17
 */
@TableName("com_sche_task_temp")
public class ScheTaskTemp extends Model<ScheTaskTemp> {

    private static final long serialVersionUID = 1L;

    private String id;

    /**
     * 模板名称
     */
    private String tempName;

    private String remark;

    private String createUser;

    private LocalDateTime createTime;

    private String projectId;

    private String updateUser;

    private LocalDateTime updateTime;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTempName() {
        return tempName;
    }

    public void setTempName(String tempName) {
        this.tempName = tempName;
    }

    public String getRemark() {
        return remark;
    }

    public void setRemark(String remark) {
        this.remark = remark;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
        this.createTime = createTime;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    protected Serializable pkVal() {
        return null;
    }

    @Override
    public String toString() {
        return "ScheTaskTemp{" +
        "id=" + id +
        ", tempName=" + tempName +
        ", remark=" + remark +
        ", createUser=" + createUser +
        ", createTime=" + createTime +
        ", projectId=" + projectId +
        ", updateUser=" + updateUser +
        ", updateTime=" + updateTime +
        "}";
    }
}
