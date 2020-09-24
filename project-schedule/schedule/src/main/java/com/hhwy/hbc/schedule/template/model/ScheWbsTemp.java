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
@TableName("com_sche_wbs_temp")
public class ScheWbsTemp extends Model<ScheWbsTemp> {

    private static final long serialVersionUID = 1L;

    private String id;

    /**
     * 模板名称
     */
    private String name;

    /**
     * 工程类型
     */
    private String engType;

    /**
     * 专业
     */
    private String profeType;

    /**
     * 默认模板，0：否，1：是
     */
    private Integer isDefault;

    /**
     * 备注
     */
    private String remark;

    private String createUser;

    private LocalDateTime createTime;


    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEngType() {
        return engType;
    }

    public void setEngType(String engType) {
        this.engType = engType;
    }

    public String getProfeType() {
        return profeType;
    }

    public void setProfeType(String profeType) {
        this.profeType = profeType;
    }

    public Integer getIsDefault() {
        return isDefault;
    }

    public void setIsDefault(Integer isDefault) {
        this.isDefault = isDefault;
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

    @Override
    protected Serializable pkVal() {
        return null;
    }

    @Override
    public String toString() {
        return "ScheWbsTemp{" +
        "id=" + id +
        ", name=" + name +
        ", engType=" + engType +
        ", profeType=" + profeType +
        ", isDefault=" + isDefault +
        ", remark=" + remark +
        ", createUser=" + createUser +
        ", createTime=" + createTime +
        "}";
    }
}
