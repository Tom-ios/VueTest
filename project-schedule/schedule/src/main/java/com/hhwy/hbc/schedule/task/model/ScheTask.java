package com.hhwy.hbc.schedule.task.model;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import com.baomidou.mybatisplus.extension.activerecord.Model;

import java.time.LocalDate;
import java.util.Date;
import java.util.HashSet;
import java.io.Serializable;

/**
 * <p>
 * 记录进度作业相关信息
 * </p>
 *
 * @author admin
 * @since 2020-03-05
 */
@TableName("com_sche_task")
public class ScheTask extends Model<ScheTask> {

    private static final long serialVersionUID = 1L;

    private String id;

    /**
     * 作业编码
     */
    private String taskCode;
    /**
     * 作业名称
     */
    private String taskName;
    /**
     * 项目id
     */
    private String projectId;
    /**
     * wbs编码
     */
    private String wbsId;
    /**
     * 日历编码
     */
    private String calendarId;
    /**
     * 资源编码
     */
    private String resourceId;

    /**
     * 只读字段，进度计算后自动赋值
     */
    private java.util.Date planStartDate;

    /**
     * 只读字段，进度计算后自动赋值
     */
    private Date planEndDate;

    /**
     * 可编辑，内容为用户手动输入，和计划完成联动
     */
    private Integer planDuration;

    /**
     * 可编辑，内容为用户手动输入
     */
    private Date actualStartDate;

    /**
     * 可编辑，内容为用户手动输入
     */
    private Date actualEndDate;

    /**
     * 只读字段，为自动计算所得，和实际完成联动
     */
    private Integer actualDuration;

    /**
     * 作业任务状态
     */
    private String taskState;
    
    /**
     * 作业进度状态
     */
    private String scheState;
    
    /**
     * 费用科目
     */
    private String expenseId;

    /**
     * 从资源字典中选择(如果没有则先添加)，或者角色字典中选择
     */
    private String principal;

    /**
     * 提供两种类型可选：1任务作业 2里程碑
            1任务作业：作业工期由人工指定(比如干多少天)，默认作业类型
            2里程碑：不占用时间和资源，不可添加资源
     */
    private String taskType;

    /**
     * 只读字段，为自动计算所得
     */
    private Integer freeFloat;

    private Integer totalFloat;

    private String limitType;

    private Date esDate;

    private Date efDate;

    private Date lsDate;

    private Date lfDate;

    /**
     * 提供三种类型可选：
            1工期百分比——按作业工期算完成百分比，自动计算
            2数量百分比——按作业数量算完成百分比，自动计算
            3实际百分比——人工输入数值[0-100]
     */
    private String scheCalcType;

  

    /**
     * 用户手动输入，占父节点的权重值[0-100]
     */
    private Double weights;

  



    /**
     * 用数字来表示优先级级别（比如1-5级可选），平衡资源时使用
     */
    private Integer taskBalLevel;

    /**
     * 1：是，0：否
     */
    private Integer criticalTask=0;

    private String groupId;

    private String createUser;

    private LocalDate createTime;

    private String updateUser;

    private String updateTime;
    
    @TableField(exist=false)
    private Integer criticalCost;

    //依赖任务项     （前置）
    @TableField(exist=false)
    public HashSet<ScheTask> dependencies = new HashSet<ScheTask>();
    //被依赖任务项  （以他为前置）
    @TableField(exist=false)
    public HashSet<ScheTask> beDependencies = new HashSet<ScheTask>();
    
    
    
    
    
    
    public HashSet<ScheTask> getDependencies() {
		return dependencies;
	}

	public void setDependencies(HashSet<ScheTask> dependencies) {
		this.dependencies = dependencies;
	}

	public HashSet<ScheTask> getBeDependencies() {
		return beDependencies;
	}

	public void setBeDependencies(HashSet<ScheTask> beDependencies) {
		this.beDependencies = beDependencies;
	}

	public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTaskCode() {
        return taskCode;
    }

    public void setTaskCode(String taskCode) {
        this.taskCode = taskCode;
    }

    public String getTaskName() {
        return taskName;
    }

    public void setTaskName(String taskName) {
        this.taskName = taskName;
    }

    public String getProjectId() {
        return projectId;
    }

    public void setProjectId(String projectId) {
        this.projectId = projectId;
    }

    public String getWbsId() {
        return wbsId;
    }

    public void setWbsId(String wbsId) {
        this.wbsId = wbsId;
    }

    public String getCalendarId() {
        return calendarId;
    }

    public void setCalendarId(String calendarId) {
        this.calendarId = calendarId;
    }

    public String getResourceId() {
        return resourceId;
    }

    public void setResourceId(String resourceId) {
        this.resourceId = resourceId;
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

    public Integer getPlanDuration() {
        return planDuration;
    }

    public void setPlanDuration(Integer planDuration) {
        this.planDuration = planDuration;
    }

    public Date getActualStartDate() {
        return actualStartDate;
    }

    public void setActualStartDate(Date actualStartDate) {
        this.actualStartDate = actualStartDate;
    }

    public Date getActualEndDate() {
        return actualEndDate;
    }

    public void setActualEndDate(Date actualEndDate) {
        this.actualEndDate = actualEndDate;
    }

    public Integer getActualDuration() {
        return actualDuration;
    }

    public void setActualDuration(Integer actualDuration) {
        this.actualDuration = actualDuration;
    }

   

    public String getTaskState() {
		return taskState;
	}

	public void setTaskState(String taskState) {
		this.taskState = taskState;
	}

	public String getScheState() {
		return scheState;
	}

	public void setScheState(String scheState) {
		this.scheState = scheState;
	}

	public String getExpenseId() {
		return expenseId;
	}

	public void setExpenseId(String expenseId) {
		this.expenseId = expenseId;
	}

	public String getPrincipal() {
        return principal;
    }

    public void setPrincipal(String principal) {
        this.principal = principal;
    }

    public String getTaskType() {
        return taskType;
    }

    public void setTaskType(String taskType) {
        this.taskType = taskType;
    }

    public Integer getFreeFloat() {
        return freeFloat;
    }

    public void setFreeFloat(Integer freeFloat) {
        this.freeFloat = freeFloat;
    }

    public Integer getTotalFloat() {
        return totalFloat;
    }

    public void setTotalFloat(Integer totalFloat) {
        this.totalFloat = totalFloat;
    }

    public String getLimitType() {
        return limitType;
    }

    public void setLimitType(String limitType) {
        this.limitType = limitType;
    }

    public Date getEsDate() {
        return esDate;
    }

    public void setEsDate(Date esDate) {
        this.esDate = esDate;
    }

    public Date getEfDate() {
        return efDate;
    }

    public void setEfDate(Date efDate) {
        this.efDate = efDate;
    }

    public Date getLsDate() {
        return lsDate;
    }

    public void setLsDate(Date lsDate) {
        this.lsDate = lsDate;
    }

    public Date getLfDate() {
        return lfDate;
    }

    public void setLfDate(Date lfDate) {
        this.lfDate = lfDate;
    }

    public String getScheCalcType() {
        return scheCalcType;
    }

    public void setScheCalcType(String scheCalcType) {
        this.scheCalcType = scheCalcType;
    }

    

    public Double getWeights() {
        return weights;
    }

    public void setWeights(Double weights) {
        this.weights = weights;
    }

   

   


    public Integer getTaskBalLevel() {
        return taskBalLevel;
    }

    public void setTaskBalLevel(Integer taskBalLevel) {
        this.taskBalLevel = taskBalLevel;
    }

    public Integer getCriticalTask() {
        return criticalTask;
    }

    public void setCriticalTask(Integer criticalTask) {
        this.criticalTask = criticalTask;
    }

    public String getGroupId() {
        return groupId;
    }

    public void setGroupId(String groupId) {
        this.groupId = groupId;
    }

    public String getCreateUser() {
        return createUser;
    }

    public void setCreateUser(String createUser) {
        this.createUser = createUser;
    }

    public LocalDate getCreateTime() {
        return createTime;
    }

    public void setCreateTime(LocalDate createTime) {
        this.createTime = createTime;
    }

    public String getUpdateUser() {
        return updateUser;
    }

    public void setUpdateUser(String updateUser) {
        this.updateUser = updateUser;
    }

    public String getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(String updateTime) {
        this.updateTime = updateTime;
    }

    public Integer getCriticalCost() {
    	if(criticalCost==null){
    		return 0;
    	}
		return criticalCost;
	}

	public void setCriticalCost(Integer criticalCost) {
		this.criticalCost = criticalCost;
	}
	public boolean isDependent(ScheTask t){
        //直接依赖
        if(dependencies.contains(t)){
          return true;
        }
        //间接依赖
        for(ScheTask dep : dependencies){
          if(dep.isDependent(t)){
            return true;
          }
        }
        return false;
      }
	@Override
    public boolean equals(Object obj) {  
        if (!(obj instanceof ScheTask))  
            return false;  
        if (obj == this)  
            return true;  
        ScheTask o = (ScheTask) obj;  
        if (this.getId().equals(o.getId())  ) {  
            return true;  
        }  
        return false;  
    }  
    
    @Override
    public int hashCode() {  
    	return this.getId().hashCode();  
    }  
    
	@Override
    protected Serializable pkVal() {
        return this.id;
    }

	@Override
	public String toString() {
		return "ScheTask [id=" + id + ", taskCode=" + taskCode + ", taskName=" + taskName + ", projectId=" + projectId
				+ ", wbsId=" + wbsId + ", calendarId=" + calendarId + ", resourceId=" + resourceId + ", planStartDate="
				+ planStartDate + ", planEndDate=" + planEndDate + ", planDuration=" + planDuration
				+ ", actualStartDate=" + actualStartDate + ", actualEndDate=" + actualEndDate + ", actualDuration="
				+ actualDuration + ", taskState=" + taskState + ", scheState=" + scheState + ", expenseId=" + expenseId
				+ ", principal=" + principal + ", taskType=" + taskType + ", freeFloat=" + freeFloat + ", totalFloat="
				+ totalFloat + ", limitType=" + limitType + ", esDate=" + esDate + ", efDate=" + efDate + ", lsDate="
				+ lsDate + ", lfDate=" + lfDate + ", scheCalcType=" + scheCalcType + ", weights=" + weights
				
				+ ", taskBalLevel=" + taskBalLevel + ", criticalTask=" + criticalTask + ", groupId=" + groupId
				+ ", createUser=" + createUser + ", createTime=" + createTime + ", updateUser=" + updateUser
				+ ", updateTime=" + updateTime + ", criticalCost=" + criticalCost + ", dependencies=" + dependencies
				+ ", beDependencies=" + beDependencies + "]";
	}



  
}
