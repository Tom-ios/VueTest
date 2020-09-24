<template>
  <div ref="pageDiv" class="app-container">
    <el-card ref="cardone" class="box-card">
      <div ref="cardoneheader" slot="header" class="clearfix">
        <span>当前提交计划信息</span>
      </div>
      <div ref="formInlineDiv" class="clearfix">
        <el-form :inline="true" :model="formInline" size="mini" label-width="auto" class="demo-form-inline">
          <el-form-item label="提交人">
            {{ formInline.applyUserName }}
          </el-form-item>
          <el-form-item label="提交时间">
            {{ formInline.applyTime }}
          </el-form-item>
        </el-form>
      </div>
      <div ref="topDiv" class="clearfix">
        <el-row class="clearfix">
          <div style="display:inline;margin-left:20px;">
            <div class="mt-10">
              <el-link :underline="false" class="button-group" @click="openAll">全部展开</el-link>
              <el-link :underline="false" class="ml-10 button-group" @click="closeAll">全部收起</el-link>
              <el-link :underline="false" class="ml-10 button-group" @click="screenFull">{{ screenText }}</el-link>
            </div>
          </div>
        </el-row>
      </div>
      <div>
        <gantt
          ref="gantDiv"
          :drag-branch-free="false"
          :drag-move-date="false"
          :drag-resize-date="false"
          :style="{'width':'100%','height':maxGridHeight+'px'}"
          :tasks="tasks"
          :gant-columns="tablecolumn"
          @clickRow="clickRow"
        />
      </div>
      <div ref="bottomDiv" class="clearfix">
        <el-form :model="approveForm" size="mini" label-width="auto" style="margin-left:10px;margin-top:10px">
          <el-row v-if="!isFweb">
            <el-form-item label="审批意见" :rules="[{required: true, message: '请输入审批意见', trigger: 'blur'}]">
              <el-input
                v-model="approveForm.approvalComments"
                type="textarea"
                :rows="2"
                placeholder="请输入内容"
                maxlength="200"
              />
            </el-form-item>
          </el-row>

          <el-row v-if="!isFweb" type="flex" class="box-card" justify="center" style="margin-top:10px;margin-bottom:10px">
            <el-button v-if="isBack" size="mini" type="primary" :loading="endloading" @click="toEnd">通过</el-button>
            <el-button v-if="isBack" size="mini" type="primary" :loading="backloading" @click="toBack">驳回</el-button>
            <el-button v-if="isCall" size="mini" type="primary" :loading="callloading" @click="toCall">撤回</el-button>
            <el-button size="mini" @click="toList">取 消</el-button>
          </el-row>
          <el-row v-if="isFweb" type="flex" class="box-card" justify="center" style="margin-top:10px;margin-bottom:10px">
            <el-button size="mini" type="primary" :loading="endloading" @click="toSubmit">提交</el-button>
            <el-button size="mini" @click="toCancel">取 消</el-button>
          </el-row>
        </el-form>
      </div>
    </el-card>
    <div v-if="dialogComplete">
      <iframe ref="bpmiframe" :src="completeTask" frameborder="no" border="0" height="100%" width="100%" style="position:fixed;top:0;left:0;scrolling:no" />
    </div>
  </div>

</template>

<script>
import { getApproveById, callApproval, backApproval, endApproval, getApprovalTree } from '@/api/wbsApprove'
import Gantt from '@/components/Gantt/index.vue'
import { getProgrameSettings } from '@/api/taskEdit'
export default {
  name: 'ApproveDetailVm',
  components: {
    Gantt
  },
  props: {
    rowObj: {
      type: Object,
      default: null
    }
  },
  data() {
    return {
      selectTimeScaleValue: '2',
      formInline: {
        wbsLevelId: '',
        projectId: '',
        applyUser: '',
        applyUserName: '',
        applyTime: '',
        approvalComments: '',
        operate: ''
      },
      approveForm: {
        approvalComments: ''
      },
      indexRow: {
        title: '序号'
      },
      loading: false,
      endloading: false,
      backloading: false,
      callloading: false,
      versionId: '',
      wbsLevelInfoId: '',
      treeArr: [],
      tableData: [],
      tablecolumn: [],
      connectTaskInfo: {},
      clickTaskInfo: {},
      // 用来存储关联关系
      screenText: '全屏',
      maxGridHeight: 400,
      tasks: {
        data: [
        ],
        links: []
      },
      dialogComplete: false,
      completeTask: '',
      isCall: false,
      isBack: false,
      isFweb: false,
      curObj: null
    }
  },
  watch: {

  },
  beforeDestroy() {
    this.treeArr = []
    this.tasks = {
      data: [
      ],
      links: []
    }
    if (this.$refs.gantDiv) {
      this.$refs.gantDiv.ganttObj.clearAll()
    }
  },
  created() {
    if (this.$route.query.id) {
      getApproveById(this.$route.query.id).then(res => {
        if (res && res.code === '200') {
          this.formInline = res.data
          if (res.data.state === '02' || res.data.state === '06') {
            this.approveForm.approvalComments = ''
          } else {
            this.approveForm.approvalComments = this.formInline.opinion
          }

          if (res.data.operate) {
            this.isCall = res.data.operate.call
            this.isBack = res.data.operate.back
          }
          this.getTreeList()
          this.$nextTick(() => {
            this.maxGridHeight = this.$refs.pageDiv.clientHeight - this.$refs.cardoneheader.clientHeight - this.$refs.formInlineDiv.clientHeight - this.$refs.bottomDiv.clientHeight - this.$refs.topDiv.clientHeight - 90
            console.log(this.maxGridHeight)
          })
        } else {
          this.$message({
            message: '获取审批详情信息失败',
            type: 'warning'
          })
        }
      })
    }
    if (process.env.VUE_APP_BFWEB === 'true') {
      this.isFweb = true
    } else {
      this.isFweb = false
    }
    window.tohiddenIFrame = () => {
      this.dialogComplete = false
    }
  },
  methods: {
    screenFull() {
      this.$refs.gantDiv.ganttObj.ext.fullscreen.toggle()
    },
    setTableColumn() {
      this.tablecolumn = [{
        name: 'wbs',
        label: '序号',
        width: 40,
        template: this.$refs.gantDiv.ganttObj.getWBSCode,
        align: 'center'
      }, {
        label: '名称',
        name: 'text',
        min_width: 260,
        tree: true,
        resize: true,
        template: function(obj) {
          if (!obj.parentId || obj.parentId === '-1') {
            return ('<span style="font-weight:700">') + obj.text + ('</span>')
          } else {
            return obj.text
          }
        }
      },
      {
        label: '编码',
        name: 'wbsCode',
        min_width: 100,
        align: 'center',
        resize: true
      },
      {
        label: '级别',
        name: 'levelName',
        min_width: 100,
        align: 'center',
        resize: true
      }, {
        label: '计划开始时间',
        name: 'start_date',
        min_width: 100,
        align: 'center',
        resize: true
      }, {
        label: '计划完成时间',
        name: 'end_date',
        min_width: 100,
        align: 'center',
        resize: true
      }, {
        label: '计划工期',
        name: 'planDuration',
        min_width: 50,
        align: 'center',
        resize: true
      }, {
        label: '权重比例',
        name: 'weights',
        min_width: 100,
        align: 'center',
        resize: true
      }, {
        label: '负责人',
        name: 'principalName',
        min_width: 100,
        align: 'center',
        resize: true
      }]
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    // 获取任务列表数据
    getTreeList() {
      var requestData = {
        id: this.$route.query.id
      }
      this.loading = true
      getApprovalTree(requestData).then(res => {
        this.loading = false
        this.treeArr = []
        if (res && res.code === '200') {
          this.findTree(res.data, (item) => {
            if (item.parentId === '-1') {
              item.parentId = ''
            }
            item.label = item.wbsName
            item.value = item.id
            item.parent = item.parentId || ''
            item.text = item.wbsName
            if (item.planStartDate && item.planEndDate) {
              item.progress = 100
              item.start_date = item.planStartDate.split(' ')[0].split('-')[2] + '-' + item.planStartDate.split(' ')[0].split('-')[1] + '-' + item.planStartDate.split(' ')[0].split('-')[0]
              const d = new Date(new Date(item.planEndDate).getTime() + 24 * 60 * 60 * 1000)
              item.end_date = d.getDate() + '-' + (d.getMonth() + 1) + '-' + d.getFullYear()
            } else {
              item.start_date = ''
              item.end_date = ''
              item.duration = '0'
              item.unscheduled = true
            }
            if (item.id === this.clickTaskInfo.id) {
              this.clickTaskInfo = item
            }

            this.treeArr.push(item)
          })
          this.tableData = JSON.parse(JSON.stringify(res.data))
          var linkArr = []
          this.treeArr.forEach(item => {
            linkArr.push({ id: item.id, source: '', target: item.id, type: '0' })
          })
          this.tasks.data = this.treeArr
          this.tasks.links = linkArr
          this.tasks = JSON.parse(JSON.stringify(this.tasks))
        } else {
          this.maxGridHeight = 100
          this.tableData = []
          this.tasks.data = []
          this.tasks = JSON.parse(JSON.stringify(this.tasks))
        }
        this.setTableColumn()
      }).catch(() => {
        this.loading = false
      }).finally(() => {
        this.initTimeScaleValue()
      })
    },
    initTimeScaleValue() {
      var requestData = { projectId: this.formInline.projectId }

      getProgrameSettings(requestData).then(res => {
        if (res.state === 'success') {
          if (res.data && res.data.period) {
            this.selectTimeScaleValue = res.data.period
            if (this.selectTimeScaleValue === '1') {
              this.$refs.gantDiv.setZoom('years-quarters')
            } else if (this.selectTimeScaleValue === '2') {
              this.$refs.gantDiv.setZoom('months')
            } else if (this.selectTimeScaleValue === '3') {
              this.$refs.gantDiv.setZoom('quarters-months')
            } else if (this.selectTimeScaleValue === '4') {
              this.$refs.gantDiv.setZoom('weeks')
            } else {
              this.$refs.gantDiv.setZoom('days')
            }
          } else {
            this.selectTimeScaleValue = '2'
          }
        } else {
          this.$message.error('初始化项目参数信息出错')
        }
      }).catch(
      )
    },
    clickRow({ id, row }) {
      if (this.editManagement) {
        this.treeArr.forEach(element => {
          if (element.id === id) {
            this.curObj = element
          }
        })
      }
    },
    openAll() {
      this.$refs.gantDiv.ganttObj.eachTask(function(task) {
        task.$open = true
      })
      this.$refs.gantDiv.ganttObj.render()
    },
    closeAll() {
      this.$refs.gantDiv.ganttObj.eachTask(function(task) {
        task.$open = false
      })
      this.$refs.gantDiv.ganttObj.render()
    },
    toList() {
      this.$router.push({ path: `/approve/list/` + this.formInline.projectId })
    },
    // toSaveApprove(passType) {
    //   console.log('cuowu')
    //   if (this.approveForm.approvalComments) {
    //     this.formInline.approvalComments = this.approveForm.approvalComments
    //     this.saveLoading = true
    //     updateApproval(this.formInline).then(res => {
    //       if (res && res.code === '200') {
    //       // this.$message({ showClose: true, message: '保存成功!', type: 'success' })
    //       // this.toList()
    //         if (passType === 'end') {
    //           this.toEnd()
    //         } else {
    //           this.toBack()
    //         }
    //       }
    //     }).catch(() => {
    //     }).finally(() => {
    //       this.saveLoading = false
    //     })
    //   }
    // },
    toEnd() {
      if (this.approveForm.approvalComments) {
        var requestData = {
          id: this.$route.query.id ? this.$route.query.id : '',
          opinion: this.approveForm.approvalComments
        }
        this.endloading = true
        endApproval(requestData).then(res => {
          this.endloading = false
          if (res && res.code === '200') {
            this.toList()
            this.$message({
              showClose: true,
              message: '审批通过',
              type: 'success'
            })
          } else {
            this.$message({
              showClose: true,
              message: '操作失败',
              type: 'error'
            })
          }
        })
      } else {
        this.$message({
          showClose: true,
          message: '请填写审批意见',
          type: 'warning'
        })
      }
    },
    toBack() {
      if (this.approveForm.approvalComments) {
        var requestData = {
          id: this.$route.query.id ? this.$route.query.id : '',
          opinion: this.approveForm.approvalComments
        }
        this.backloading = true
        backApproval(requestData).then(res => {
          this.backloading = false
          if (res && res.code === '200') {
            this.toList()
            this.$message({
              showClose: true,
              message: '驳回成功',
              type: 'success'
            })
          } else {
            this.$message({
              showClose: true,
              message: '驳回失败',
              type: 'warning'
            })
          }
        })
      } else {
        this.$message({
          showClose: true,
          message: '请填写审批意见',
          type: 'warning'
        })
      }
    },
    toCall: function() {
      this.callloading = true
      callApproval({ id: this.$route.query.id }).then(res => {
        this.callloading = false
        if (res && res.code === '200') {
          this.toList()
          this.$message({
            showClose: true,
            message: '撤回成功',
            type: 'success'
          })
        } else {
          this.$message({
            showClose: true,
            message: '撤回失败',
            type: 'warning'
          })
        }
      })
    },
    toSubmit() {
      // this.endloading = true
      this.dialogComplete = true
      if (this.formInline.type === '1' || this.formInline.type === 1) {
        this.completeTask = process.env.VUE_APP_BASE_API + 'view/progress/progress/wbs/taskAudit?id=' + this.$route.query.id + '&projectId=' + this.formInline.projectId
      } else {
        this.completeTask = process.env.VUE_APP_BASE_API + 'view/progress/progress/wbs/wbsAudit?id=' + this.$route.query.id + '&wbsLevelId=' + this.formInline.wbsLevelId + '&projectId=' + this.formInline.projectId
      }
      // this.completeTask = process.env.VUE_APP_BASE_API + 'view/progress/progress/wbs/wbsAudit?id=' + this.$route.query.id + '&wbsLevelId=' + this.formInline.wbsLevelId + '&projectId=' + this.formInline.projectId
      // window.open(process.env.VUE_APP_BASE_API + 'view/progress/progress/wbs/wbsAudit?id=' + this.$route.query.id + '&wbsLevelId=' + this.formInline.wbsLevelId + '&projectId=' + this.formInline.projectId, '_blank', 'left=200,top=200,width=810,height=410')
      // this.endloading = false
    },
    toCancel() {
      var mainframe = top.Mainframe
      if (mainframe) {
        mainframe.closeDialog('dialog_todo')
      }
    }
  }
}
</script>
<style lang="scss" scoped>
.app-container{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 0px;
}

/deep/ .el-card__body{
  padding: 10px;
}
.el-form-item{
  margin-bottom: 5px;
}
</style>
