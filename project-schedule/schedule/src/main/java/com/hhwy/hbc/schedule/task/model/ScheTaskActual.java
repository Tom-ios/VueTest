package com.hhwy.hbc.schedule.task.model;

import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.activerecord.Model;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.io.Serializable;

/**
 * <p>
 * 
 * </p>
 *
 * @author admin
 * @since 2020-03-17
 */
@TableName("com_sche_task_actual")
public class ScheTaskActual extends Model<ScheTaskActual> {

    private static final long serialVersionUID = 1L;

    private String id;

    private String taskId;

    private String startDate;

    private String endDate;

    /**
     * 实际开始时间，可编辑，内容为用户手动输入
     */
    private LocalDateTime actualStartDate;

    /**
     * 实际完成时间，可编辑，内容为用户手动输入
     */
    private LocalDateTime actualEndDate;

    /**
     * 实际工期，只读字段，为自动计算所得，和实际完成联动
     */
    private Integer actualDuration;

    /**
     * 暂停日期
     */
    private LocalDate suspendDate;

    /**
     * 复工日期
     */
    private LocalDate retworkDate;

    /**
     * 延期原因
     */
    private String delayReason;

    private Double grandTotalPercent;

    private LocalDateTime createTime;

    private String createUser;

    private String updateUser;

    private LocalDateTime updateTime;

    /**
     * 附件
     */
    private String groupId;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTaskId() {
        return taskId;
    }

    public void setTaskId(String taskId) {
        this.taskId = taskId;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public LocalDateTime getActualStartDate() {
        return actualStartDate;
    }

    public void setActualStartDate(LocalDateTime actualStartDate) {
        this.actualStartDate = actualStartDate;
    }

    public LocalDateTime getActualEndDate() {
        return actualEndDate;
    }

    public void setActualEndDate(LocalDateTime actualEndDate) {
        this.actualEndDate = actualEndDate;
    }

    public Integer getActualDuration() {
        return actualDuration;
    }

    public void setActualDuration(Integer actualDuration) {
        this.actualDuration = actualDuration;
    }

    public LocalDate getSuspendDate() {
        return suspendDate;
    }

    public void setSuspendDate(LocalDate suspendDate) {
        this.suspendDate = suspendDate;
    }

    public LocalDate getRetworkDate() {
        return retworkDate;
    }

    public void setRetworkDate(LocalDate retworkDate) {
        this.retworkDate = retworkDate;
    }

    public String getDelayReason() {
        return delayReason;
    }

    public void setDelayReason(String delayReason) {
        this.delayReason = delayReason;
    }

    public Double getGrandTotalPercent() {
        return grandTotalPercent;
    }

    public void setGrandTotalPercent(Double grandTotalPercent) {
        this.grandTotalPercent = grandTotalPercent;
    }

    public LocalDateTime getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDateTime createTime) {
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

    public LocalDateTime getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(LocalDateTime updateTime) {
        this.updateTime = updateTime;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    @Override
    protected Serializable pkVal() {
        return this.id;
    }

    @Override
    public String toString() {
        return "ScheTaskActual{" +
        "id=" + id +
        ", taskId=" + taskId +
        ", startDate=" + startDate +
        ", endDate=" + endDate +
        ", actualStartDate=" + actualStartDate +
        ", actualEndDate=" + actualEndDate +
        ", actualDuration=" + actualDuration +
        ", suspendDate=" + suspendDate +
        ", retworkDate=" + retworkDate +
        ", delayReason=" + delayReason +
        ", grandTotalPercent=" + grandTotalPercent +
        ", createTime=" + createTime +
        ", createUser=" + createUser +
        ", updateUser=" + updateUser +
        ", updateTime=" + updateTime +
        ", groupId=" + groupId +
        "}";
    }
}
