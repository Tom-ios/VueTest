<template>
  <div ref="pageDiv" class="">
    <el-card ref="cardone" class="box-card">
      <div ref="cardoneheader" slot="header" class="clearfix">
        <span>当前版本信息</span>
      </div>
      <div ref="formInlineDiv" class="clearfix">
        <el-form :inline="true" :model="formInline" size="mini" label-width="auto" class="demo-form-inline" style="margin-left:20px">

          <el-form-item label="当前版本号">
            {{ formInline.versionNo }}
          </el-form-item>

          <el-form-item label="提交人">
            {{ formInline.applyUser }}
          </el-form-item>

          <el-form-item label="提交时间">
            {{ formInline.applyTime }}
          </el-form-item>

          <el-form-item label="提交说明">
            {{ formInline.remark }}
          </el-form-item>

        </el-form>
      </div>
    </el-card>
    <el-card class="box-card">
      <div ref="cardtwoheader" slot="header" class="clearfix">
        <span>wbs计划信息</span>
      </div>
      <div ref="topDiv" class="clearfix">
        <el-row class="clearfix">
          <el-form :model="planform" size="mini" label-width="auto" style="margin-left:10px;margin-top:10px;">
            <el-row :gutter="24">
              <el-col :xl="6" :lg="6" :md="6" :sm="6" :xs="6">
                <el-form-item label="编码">
                  <el-input v-model="planform.wbsCode" placeholder="编码" clearable />
                </el-form-item>
              </el-col>
              <el-col :xl="6" :lg="6" :md="6" :sm="6" :xs="6">
                <el-form-item label="名称">
                  <el-input v-model="planform.wbsName" placeholder="名称" clearable />
                </el-form-item>
              </el-col>
              <el-col :xl="6" :lg="6" :md="6" :sm="6" :xs="6">
                <el-form-item label="级别">
                  <el-select v-model="planform.wbsLevel" placeholder="级别">
                    <el-option
                      v-for="item in planLevelList"
                      :key="item.dictCode"
                      :label="item.name"
                      :value="item.dictCode"
                    />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :xl="6" :lg="6" :md="6" :sm="6" :xs="6">
                <el-button type="primary" size="mini" icon="el-icon-search" @click="searchPlan()">查询</el-button>
              </el-col>
            </el-row>
          </el-form>
        </el-row>

        <el-row class="clearfix">
          <div style="display:inline;margin-left:20px;">
            <div class="mt-10" style="float:right;padding:0px 20px 5px 0px;">
              <el-button type="primary" size="mini" @click="screenFull()">{{ screenText }}</el-button>
              <el-button type="primary" size="mini" icon="el-icon-zoom-in" @click="zoomIn()">放大</el-button>
              <el-button type="primary" size="mini" icon="el-icon-zoom-out" @click="zoomOut()">缩小</el-button>
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
          :filter="onBeforeTaskDisplay"
          @clickRow="clickRow"
        />
      </div>
    </el-card>
  </div>

</template>

<script>
import { getDictByItemId, getWbsVerData } from '@/api/wbsPlan'
import Gantt from '@/components/Gantt/index.vue'
export default {
  name: 'WbsDetail',
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
      // tableHeight: window.innerHeight > 200 ? window.innerHeight - 210 : 400,
      formInline: {
        versionNo: '',
        applyUser: '0',
        applyTime: '0'
      },
      planform: {
        wbsCode: '',
        wbsName: '',
        wbsLevel: ''
      },
      progressData: [],
      loading: false,
      indexRow: {
        title: '序号'
      },
      planLevelList: '',
      versionId: '',
      wbsLevelInfoId: '',
      treeArr: [],
      saveLoading: false,
      taskName: '',
      tableData: [],
      tablecolumn: [],
      connectTaskInfo: {},
      clickTaskInfo: {},
      isEditPlanTime: false,
      mapId: {},
      // 用来存储关联关系
      screenText: '全屏',
      connectArr: [],
      maxGridHeight: 400,
      tasks: {
        data: [
        ],
        links: []
      },
      curObj: null
    }
  },
  watch: {

  },
  created() {
    var _self = this
    _self.selectPlanLevelList()
    if (_self.rowObj) {
      var rowdata = _self.rowObj
      if (rowdata.id) {
        _self.versionId = rowdata.id
        _self.wbsLevelInfoId = rowdata.wbsLevelId
        _self.$set(_self.formInline, 'versionNo', rowdata.versionNo)
        _self.$set(_self.formInline, 'applyUser', rowdata.applyUserName)
        _self.$set(_self.formInline, 'applyTime', rowdata.applyTime)
        _self.$set(_self.formInline, 'remark', rowdata.remark)
      }
    }
  },
  mounted() {
    this.setTableColumn()
    this.getTreeList()
    this.$nextTick(() => {
      // console.log(this.$refs.pageDiv.clientHeight)
      // console.log(this.$refs.cardoneheader.clientHeight)
      // console.log(this.$refs.formInlineDiv.clientHeight)
      // console.log(this.$refs.cardtwoheader.clientHeight)
      // console.log(this.$refs.topDiv.clientHeight)
      // this.maxGridHeight = this.$refs.pageDiv.clientHeight - this.$refs.cardoneheader.clientHeight - this.$refs.formInlineDiv.clientHeight - this.$refs.cardtwoheader.clientHeight - this.$refs.topDiv.clientHeight - 90
    })
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
  methods: {
    selectPlanLevelList() {
      var this_ = this
      var requestData = { type: 'dict', itemId: '317b8ac10f804307a471cdfddaf7366d' }
      getDictByItemId(requestData).then(res => {
        this_.planLevelList = res
      }).catch(() => {
        this.$message({
          message: '获取计划等级失败',
          type: 'error'
        })
      })
    },
    screenFull() {
      this.$refs.gantDiv.ganttObj.ext.fullscreen.toggle()
    },

    zoomIn() {
      this.$refs.gantDiv.zoomIn()
    },
    zoomOut() {
      this.$refs.gantDiv.zoomOut()
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
        label: '计划工期',
        name: 'planDuration',
        min_width: 50,
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
    getIndex(index) {
      return this.treeArr[index].serialNumber || ' '
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
        versionId: this.versionId,
        type: 2
      }
      this.loading = true
      getWbsVerData(requestData).then(res => {
        this.loading = false
        this.mapId = {}
        this.treeArr = []
        if (res && res.code === '200') {
          this.findTree(res.data, (item) => {
            if (item.parentId === '-1') {
              item.parentId = ''
            }
            item.id = item.oldId
            item.label = item.wbsName
            item.value = item.id
            item.parent = item.parentId || ''
            item.text = item.wbsName
            if (item.planStartDate && item.planEndDate) {
              item.progress = 100
              item.start_date = item.planStartDate.split('-')[2] + '-' + item.planStartDate.split('-')[1] + '-' + item.planStartDate.split('-')[0]
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
          // this.maxGridHeight = this.maxHeight
          this.tasks.data = this.treeArr
          this.tasks.links = linkArr
          this.tasks = JSON.parse(JSON.stringify(this.tasks))
        } else {
          this.maxGridHeight = 100
          this.tableData = []
          this.tasks.data = []
          this.tasks = JSON.parse(JSON.stringify(this.tasks))
        }
      }
      ).catch(() => {
        this.loading = false
      })
    },
    onBeforeTaskDisplay(id, task) {
      var accordNum = 0
      if (this.planform.wbsCode) {
        if (task.wbsCode.indexOf(this.planform.wbsCode) > -1) {
          accordNum++
        }
      } else {
        accordNum++
      }
      if (this.planform.wbsName) {
        if (task.wbsName.indexOf(this.planform.wbsName) > -1) {
          accordNum++
        }
      } else {
        accordNum++
      }
      if (this.planform.wbsLevel) {
        let selobj = {}
        selobj = this.planLevelList.find((item) => {
          return item.dictCode + '' === this.planform.wbsLevel + ''
        })
        if (task.levelName === selobj.name) {
          accordNum++
        }
      } else {
        accordNum++
      }
      if (accordNum === 3) {
        return true
      } else {
        return false
      }
    },
    getFixed(index) {
      if (index < 1) {
        return 'left'
      } else {
        return false
      }
    },
    addClass({ row, columnIndex }) {
      if (columnIndex !== 1) {
        if (row.bgcolor && row.bgcolor === 'red' && this.tablecolumn[columnIndex - 1] && this.tablecolumn[columnIndex - 1].value === 'state2') {
          return 'redBgColor'
        }
        return 'justcenter'
      } else {
        return ''
      }
    },
    getWidth(index) {
      if (index === 0) {
        return 200
      } else if (this.tablecolumn[index].value === 'principalName') {
        return 100
      } else if ((this.tablecolumn[index].value === 'planEndDate' || this.tablecolumn[index].value === 'planStartDate') && this.isEditPlanTime) {
        return 75
      } else {
        return 60
      }
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
    searchPlan: function() {
      this.$refs.gantDiv.ganttObj.refreshData()
    }
  }
}
</script>
<style lang="scss" scoped>
/deep/ .el-dialog__body{
    padding: 0px 20px;
    color: #606266;
    font-size: 14px;
    word-break: break-all;
}
/deep/ .el-card__body{
  padding:0px 0px
}
.el-form-item{
  margin-top: 5px;
  margin-bottom: 5px;
}
</style>
