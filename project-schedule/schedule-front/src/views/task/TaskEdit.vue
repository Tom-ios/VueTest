<template>
  <div ref="pageDiv" class="app-container-task-edit">
    <el-row ref="topDiv" class="clearfix">
      <el-card v-if="showInfoToolbar" :body-style="{ padding: '0px 0px 0px 10px' }">
        <!--  <div slot="header">
          <span>作业步骤信息</span>
        </div> -->
        <el-form ref="form" size="small" label-width="auto" style="margin-top:10px">
          <el-row :gutter="0">
            <el-col :span="5">
              <el-form-item label="计划编制状态：">
                <span>{{ taskInfo.stateName }}</span>
              </el-form-item>
            </el-col>
            <el-col :span="5">
              <el-form-item label="审批状态：">
                <span>{{ taskInfo.approveStateName }}</span>
              </el-form-item>
            </el-col>
            <el-col :span="5">
              <el-form-item label="审批意见：">
                <el-tooltip :content="taskInfo.opinion" placement="bottom" effect="light" popper-class="opinion-tip">
                  <span class="tag-pointer">{{ taskInfo.opinion && taskInfo.opinion.length > 20 ? taskInfo.opinion.substring(0,20) + '...': taskInfo.opinion }}</span>
                </el-tooltip>
              </el-form-item>
            </el-col>
            <!--  <el-col :xl="6" :lg="6" :md="6" :sm="12" :xs="24">
              <el-form-item label="审批次数：">
                <span>{{ taskInfo.aprovalNum }}</span>
              </el-form-item>
            </el-col>  -->
            <el-col :span="9">
              <div style="float:right;font-size: 0;">
                <el-button v-if="taskInfo && taskInfo.stateName==='已完成' && taskApprove" type="primary" size="mini" :loading="buildLoading" @click="buildVersion">生成版本</el-button>
                <el-button type="primary" size="mini" @click="handleTaskChange">调整计划</el-button>
                <template v-if="isCurrentUserCanOpt">
                  <el-button v-show="(!taskInfo.edit || taskInfo.edit.state === '0') && (taskInfo.approveState === '01' || taskInfo.approveState === '04' || taskInfo.approveState === '05' || taskInfo.approveState === '07')" type="primary" size="mini" @click="handleEditComplete(1)">编制完成</el-button>
                  <el-button v-show="taskInfo.edit && taskInfo.edit.state === '1' && (taskInfo.approveState === '01' || taskInfo.approveState === '04' || taskInfo.approveState === '05' || taskInfo.approveState === '07')" type="primary" size="mini" @click="handleEditComplete()">取消完成</el-button>
                  <el-button v-show="taskInfo.approveFlag === 1 && taskInfo.state === '1' && (taskInfo.approveState === '01' || taskInfo.approveState === '04' || taskInfo.approveState === '05' || taskInfo.approveState === '07')" type="primary" size="mini" @click="handleApproval(taskInfo.approveState)">提交审批</el-button>
                  <!-- <el-button v-show="taskInfo.approveState === '02'" type="primary" size="mini" @click="handleApproval(taskInfo.approveState)">撤销审批</el-button> -->
                  <el-button v-show="taskInfo.approveState === '03'" type="primary" size="mini" @click="handleApproveChange">变更</el-button>
                </template>
                <el-button type="primary" size="mini" style="margin-right: 10px" @click="handleApprovalHistory">审批记录</el-button>
              </div>
            </el-col>
          </el-row>
        </el-form>
      </el-card>
      <el-row type="flex" justify="center"><i v-if="showInfoToolbar" class="el-icon-caret-top" style="cursor: pointer;" @click="collapseToolBar" /><i v-else class="el-icon-caret-bottom" style="cursor: pointer;" @click="expandToolBar" /></el-row>
    </el-row>
    <el-card :body-style="{ padding: '0px 0px 0px' }" style="margin-top:3px;">
      <!--  <div slot="header">
        <span>作业计划信息</span>
      </div> -->
      <GanttView ref="ganttView" :cur-level-info="taskInfo" :is-current-user-can-opt="isCurrentUserCanOpt" :max-height="maxHeight" :eidt-status="!taskInfo.edit || taskInfo.edit.state === '0'" :approve-status="taskInfo.approveState" :approve-change="approveChange" :show-info-toolbar="showInfoToolbar" @showBuildVersion="showBuildVersion" @after-approve-change="handleAfterApproveChange" />
    </el-card>
    <el-dialog
      title="审批记录"
      :visible.sync="showApprovalHistory"
      width="50%"
      :close-on-click-modal="false"
      @close="showApprovalHistory=false"
    >
      <!-- <div class="table-wrap"> -->
      <el-table
        :data="approvalHistoryData"
        border
        max-height="460"
        height="460"
      >
        <el-table-column
          v-for="(col,index) in approvalHistoryColumns"
          :key="index"
          :prop="col.value"
          :label="col.title"
          :min-width="col.width?col.width:'100'"
        >
          <template slot-scope="scope">
            <span v-if="approvalHistoryColumns[index].type==='opt'">
              <el-button type="text" @click="toView(scope.row,scope.$index)">查看</el-button>
            </span>
            <span v-else-if="approvalHistoryColumns[index].type==='index'"> {{ scope.$index +1 }}</span>
            <span v-else> {{ scope.row[approvalHistoryColumns[index].value] }}</span>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        v-bind="pagination"
        class="table-pages"
        background
        @size-change="handleSizeChange"
        @current-change="paginationCurrentChange"
      />
      <!-- </div> -->
    </el-dialog>
    <div v-if="dialogComplete">
      <iframe ref="bpmiframe" :src="completeTask" frameborder="no" border="0" height="100%" width="100%" style="position:fixed;top:0;left:0;scrolling:no" />
    </div>
  </div>
</template>

<script>
import GanttView from './GanttView'
// import ResourceHistogram from './ResourceHistogramView'
import { getRecentTaskEditList, getApprovalHistoryList } from '@/api/taskView'
import { setTaskEditStatus, setTaskEditComplete, setTaskApprovalStatus, getWbsApproveStatus, getCurrentUserOptPermission, getCriticalPath, checkSavePerson } from '@/api/taskEdit'

export default {
  name: 'TaskEdit',
  components: {
    GanttView
    // ResourceHistogram
  },
  data() {
    return {
      buildLoading: false,
      taskApprove: false,
      showInfoToolbar: true,
      globalParam: { projectId: this.$route.params.id },
      opinionVisible: false,
      approveChange: false,
      taskInfo: {
        applyUser: '',
        applyUserName: '',
        applyTime: '',
        submitTime: '',
        projectId: '',
        state: '',
        stateName: '',
        approveState: '',
        approveStateName: '',
        aprovalNum: '',
        opinion: '',
        edit: {
          state: ''
        }
      },
      showApprovalHistory: false,
      dialogComplete: false,
      completeTask: '',
      approvalHistoryColumns: [{
        title: '提交人', value: 'applyUserName', width: 100 }, {
        title: '提交审批时间', value: 'applyTime', width: 150 }, {
        title: '提交说明', value: 'remark', width: 100 }, {
        title: '当前状态', value: 'stateName', width: 100 }, {
        title: '审批通过时间', value: 'completeTime', width: 150 }, {
        title: '审批人', value: 'approvalUserName', width: 100 }
      // { title: '操作', type: 'opt', width: 100 }
      ],
      approvalHistoryData: [{
        applyUser: 'jrodan',
        applyUserName: 'jrodan',
        applyTime: '2020-01-01',
        remark: '...',
        stateName: '通过',
        completeTime: '2020-01-01 11:30:30'
      }],
      indexRow: {
        title: '序号'
      },
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0,
        pageSizes: [10, 20, 50, 100],
        layout: 'total, sizes, prev, pager, next, jumper'
      },
      isManager: false,
      maxHeight: 500,
      isCurrentUserCanOpt: false
    }
  },

  created() {
    this.getCurrentUserOptPermission()
    this.fetchTaskRecentStatus(true)
    window.tohiddenIFrame = () => {
      this.dialogComplete = false
    }
  },
  methods: {
    // 审批状态
    //  Approval_No_Submit="未提交";
    //  Approval_Process="审批中";
    //  Approval_Pass="审批通过";
    //  Approval_Back="退回";
    //  Approval_Change_No_Submit="变更未提交";
    //  Approval_Change_Process="变更审批中";
    //  Approval_Change_Back="变更退回";

    // //审批状态Code
    //  Approval_No_Submit_01="01";
    //  Approval_Process_02="02";
    //  Approval_Pass_03="03";
    //  Approval_Back_04="04";
    //  Approval_Change_No_Submit_05="05";
    //  Approval_Change_Process_06="06";
    //  Approval_Change_Back_07="07";
    showBuildVersion(v) {
      this.taskApprove = v
    },
    // 计算关键路径
    handleCalculateCriticalPath() {
      return getCriticalPath({ projectId: this.$route.params.id }).then(res => {
        if (res.state === 'success') {
          if (res.code === '501') {
            this.$message.warning(res.msg)
            return false
          }
          return true
        } else {
          this.$message.error('操作失败')
          return false
        }
      })
    },
    buildVersion() { // 调用编制完成去自动审批
    // 自动计算时间 防止生成的极限数据出现了没有填写时间的数据 （request）
    // answer:不走审批流程的作业，最后一个人点击【编制完成】时，自动计算关键路径，有问题则提示并不能执行编制完成；点击【生成版本】时，自动计算关键路径，有问题则提示并不生成基线版本
      this.buildLoading = true
      this.handleCalculateCriticalPath().then(res => {
        if (res) {
          this.$refs.ganttView.fetchTaskList()
          this.handleEditComplete(1, true)
        }
      }).catch(() => {
        this.buildLoading = false
      })
    },
    collapseToolBar() {
      this.showInfoToolbar = false
      this.maxHeight = this.$refs.pageDiv.clientHeight - 80
    },
    expandToolBar() {
      this.showInfoToolbar = true
      this.maxHeight = this.$refs.pageDiv.clientHeight - 200
    },
    GenNonDuplicateID(randomLength) {
      return Number(Math.random().toString().substr(3, randomLength) + Date.now()).toString(36)
    },
    paginationCurrentChange(currentPage) {
      this.pagination.currentPage = currentPage
      this.fetchApprovalHistoryData()
    },
    handleApprovalHistory(v) {
      this.fetchApprovalHistoryData()
      this.showApprovalHistory = true
    },
    handlerowOperate({ index, row }) {
      setTaskEditStatus({ ... row, ...
      { state: row.state === '1' ? '0' : '1' }
      }, { headers: {}}).then(res => {
        if (res.state === 'success') {
          this.$message.success('修改状态成功')
        } else {
          this.$message.error('查询编辑历史失败')
        }
      })
    },
    fetchTaskRecentStatus(isCalculateHeight) {
      getRecentTaskEditList(this.globalParam).then(res => {
        if (res.state === 'success' && res.data) {
          this.taskInfo = res.data
          if (isCalculateHeight) {
            this.$nextTick(() => {
              // this.maxHeight = this.$refs.pageDiv.clientHeight - this.$refs.topDiv.$el.offsetHeight - 10 - 50 - 42 - 43 - 40 - 3
              this.maxHeight = this.$refs.pageDiv.clientHeight - this.$refs.topDiv.$el.offsetHeight - 50 - 39 - 10 - 20 - 3
            })
          }
        } else {
          this.$message.error('查询作业进展失败')
        }
      })
    },
    fetchApprovalHistoryData() {
      getApprovalHistoryList({ ...this.globalParam, ...{ pageSize: this.pagination.pageSize, pageIndex: this.pagination.currentPage, type: 1 }}).then(res => {
        if (res.state === 'success') {
          this.approvalHistoryData = res.rows
          this.pagination.total = res.total
        } else {
          this.$message.error('查询审批历史失败')
        }
      })
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val
      this.fetchApprovalHistoryData()
    },
    async handleEditComplete(status, buildVersion) {
      var flag = false
      await getWbsApproveStatus(this.globalParam).then(res => {
        flag = res
      })
      if (!flag) {
        this.buildLoading = false
        return this.$message.warning('待WBS审核通过后才能进行此操作')
      }
      if (status === 1 && !this.$refs.ganttView.validTaskIsNull()) {
        return
      }
      if (buildVersion) {
        this.taskInfo.edit.buildVerFlag = '1'
        // 生成版本调用编制完成
        setTaskEditComplete(this.taskInfo.edit).then(res => {
          if (res) {
            this.taskInfo.edit = res
            this.fetchTaskRecentStatus()
            this.$message.success('操作成功')
          } else {
            this.buildLoading = false
            this.$message.error('操作失败')
          }
        }).finally(() => {
          this.buildLoading = false
        })
      } else {
        // 直接调用编制完成
        // 是否审批 staus = 1编制完成 否则取消编制完成
        if (status === 1) {
          // 非审批 && 最后一个编辑  => 自动计算时间=> 编制完成接口
          if (!this.$refs.ganttView.bApprove) {
            checkSavePerson(this.taskInfo.edit).then(res => {
              if (res.data) {
                this.handleCalculateCriticalPath().then(res => {
                  if (res) {
                    setTaskEditComplete(this.taskInfo.edit).then(res => {
                      if (res) {
                        this.taskInfo.edit = res
                        this.fetchTaskRecentStatus()
                        this.$message.success('操作成功')
                        this.$refs.ganttView.fetchTaskList()
                      } else {
                        this.$message.error('操作失败')
                      }
                    }).finally(() => {
                      this.buildLoading = false
                    })
                  }
                })
              } else {
                setTaskEditComplete(this.taskInfo.edit).then(res => {
                  if (res) {
                    this.taskInfo.edit = res
                    this.fetchTaskRecentStatus()
                    this.$message.success('操作成功')
                    this.$refs.ganttView.fetchTaskList()
                  } else {
                    this.$message.error('操作失败')
                  }
                }).finally(() => {
                  this.buildLoading = false
                })
              }
            })
          } else {
            setTaskEditComplete(this.taskInfo.edit).then(res => {
              if (res) {
                this.taskInfo.edit = res
                this.fetchTaskRecentStatus()
                this.$message.success('操作成功')
                this.$refs.ganttView.fetchTaskList()
              } else {
                this.$message.error('操作失败')
              }
            })
          }
        } else {
          setTaskEditComplete(this.taskInfo.edit).then(res => {
            if (res) {
              this.taskInfo.edit = res
              this.fetchTaskRecentStatus()
              this.$message.success('操作成功')
              this.$refs.ganttView.fetchTaskList()
            } else {
              this.$message.error('操作失败')
            }
          })
        }
      }
    },
    async handleTaskChange() {
      const isCanApproval = await this.$refs.ganttView.handleCalculateCriticalPath('approval')
      if (!isCanApproval) {
        return
      }
      this.$router.push(`/planAdjust/${this.$route.params.id}`)
    },
    async handleApproval(status) {
      var flag = false
      await getWbsApproveStatus(this.globalParam).then(res => {
        flag = res
      })
      if (!flag) {
        return this.$message.warning('待WBS审核通过后才能进行此操作')
      }
      const isCanApproval = await this.$refs.ganttView.handleCalculateCriticalPath('approval')
      if (!isCanApproval) {
        return
      }
      if (status === '01' || status === '04' || status === '05' || status === '07') {
        if (process.env.VUE_APP_BFWEB === 'true') {
          // 调用贵州院流程流转
          console.log('弹出流程界面')
          var wbsid = ''
          if (!this.taskInfo.approveId) {
            wbsid = this.GenNonDuplicateID(20)
          } else {
            wbsid = this.taskInfo.approveId
          }
          this.dialogComplete = true
          this.completeTask = process.env.VUE_APP_BASE_API + 'view/progress/progress/wbs/taskAudit?id=' + wbsid + '&wbsLevelId=' + this.taskInfo.id + '&projectId=' + this.globalParam.projectId
        } else {
          this.$prompt((status === '01' || status === '04' || status === '05' || status === '07') ? '<span style="color:red">*</span>说明：提交后，当前计划将进入审批流程' : '<span style="color:red">*</span>说明：变更后，当前计划将重新进入审批流程', (status === '01' || status === '05') ? '提交说明' : '变更说明', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            inputPattern: /^(?=.{1,200}$)[\s\S]*.*[^\s][\s\S]*$/,
            inputType: 'textarea',
            inputErrorMessage: '输入不能为空，最多可输入200字符',
            dangerouslyUseHTMLString: true
          }).then(({ value }) => {
            setTaskApprovalStatus({ projectId: this.globalParam.projectId, type: 1, submitFlag: 1, remark: value, approveId: this.taskInfo.approveId }).then(res => {
              if (res) {
                this.taskInfo.approveState = res.data.state
                this.fetchTaskRecentStatus()
                this.$message.success('提交成功')
              } else {
                this.$message.error('提交作业审批失败')
              }
            }).catch(() => {
            }).finally(() => {
            })
          }).catch(() => {
            this.$message({
              type: 'info',
              message: '取消输入'
            })
          })
        }
      }
    },
    handleAfterApproveChange() {
      getRecentTaskEditList(this.globalParam).then(res => {
        if (res.state === 'success') {
          this.approveChange = false
          this.taskInfo = res.data
        } else {
          this.$message.error('查询作业进展失败')
        }
      })
    },
    async handleApproveChange() {
      var flag = false
      await getWbsApproveStatus(this.globalParam).then(res => {
        flag = res
      })
      if (!flag) {
        return this.$message.warning('待WBS审核通过后才能进行此操作')
      }
      this.approveChange = true
    },
    getCurrentUserOptPermission() {
      getCurrentUserOptPermission(this.globalParam).then(res => {
        this.isCurrentUserCanOpt = res
      }).catch(
      ).finally(() => {
      })
    }
  }
}
</script>
<style lang="scss" scoped>
/deep/ .d2-crud .d2-crud-body{
  padding: 0 !important;
}
</style>
<style>
.opinion-tip{
  max-width: 30%;
}
.tag-pointer{
  cursor: pointer;
}
.app-container-task-edit{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 10px;
}
</style>
