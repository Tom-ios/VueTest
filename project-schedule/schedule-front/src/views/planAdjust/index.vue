<template>
  <div id="planAdjust" class="pageDiv">
    <el-card :body-style="{ padding: '10px' }">
      <div class="clearfix">
        <el-button type="primary" @click="setWarnValue">设置预警阙值</el-button>
        <el-radio-group v-model="tabName" style="float:right" @change="tabChange">
          <el-radio-button label="资源汇总" />
          <el-radio-button label="费用汇总" />
        </el-radio-group>

      </div>
      <div class="clearfix">
        <el-input
          v-if="tabType==='res'"
          v-model="selectRes.selectName"
          style="width:500px;display:block;margin-top:10px;margin-bottom:-20px;display:inline-block"
          placeholder="请选择资源"
          clearable
          @keyup.native="value=value.replace(/[^\d]/g,'')"
          @focus="showResource = true"
          @clear="clearSelect"
        />
        <el-checkbox v-if="(tabType==='cost'|| (selectRes.selectId && selectRes.selectId.indexOf(',')<0)) && !hideJD" v-model="JSWData" style="float:right;padding:15px 20px 0;">仅显示预警区间</el-checkbox>
      </div>
      <div v-if="tabType==='cost'|| selectRes.selectId" style="margin-top:10px">
        <BarChart
          ref="warbResBar"
          :click-type="clickParam.chartType"
          :j-s-w-data="JSWData"
          :p-warn-value="(tabType==='res'?clickParam.warnValue:projectParam.costThresholdValue)"
          :select-res="selectRes"
          :warn-show="true"
          style="width:calc(50% - 10px);height:300px;display:inline-block"
          :tab-type="tabType"
          chart-type="date"
          :props-option="leftOption"
          @hideJSWD="hideJSWD"
          @clickBar="clickBar"
        />
        <BarChart
          ref="CostBar"
          :click-type="clickParam.chartType"
          :j-s-w-data="JSWData"
          :select-res="selectRes"
          style="width:calc(50% - 10px);height:300px;display:inline-block"
          :tab-type="tabType"
          chart-type="cost"
          :props-option="rightOption"
          @hideJSWD="hideJSWD"
          @clickBar="clickBar"
        />
      </div>
      <div v-else :style="{height:NoSelResHeight +'px','text-align':'center','padding-top':'180px','fontSize':'14px','color':'gray'}">
        请选择资源
      </div>
    </el-card>
    <el-card v-if="tabType==='cost'|| selectRes.selectId" :body-style="{ padding: '10px' }" class="mt-10">
      <el-row v-if="tabType==='res'" style="font-size:13px;display:inline-block">
        <span>资源名称:</span> <span>{{ clickParam.seriesName }}</span>
        <span style="margin-left:20px">使用量预警阙值:</span> <span v-if="clickParam.dateUnit==='week'">{{ (!clickParam.warnValue && clickParam.warnValue !=0 )?'-':clickParam.warnValue }}/周</span> <span v-else>{{ (!clickParam.warnValue && clickParam.warnValue !=0 )?'-': Number(clickParam.warnValue) *4 }}/月 </span>
        <span style="margin-left:20px">时间:</span> <span> {{ clickParam.name }}</span>
        <span style="margin-left:20px">累计使用总量:</span> <span>{{ clickParam.value }}</span>
      </el-row>
      <el-row v-else style="font-size:13px;display:inline-block">
        <span v-if="clickParam.chartType==='date'">
          <span>费用预警阈值:</span> <span v-if="clickParam.dateUnit==='week'">{{ projectParam.costThresholdValue ===''?'-':projectParam.costThresholdValue }}元/每周</span>
          <span v-else>{{ projectParam.costThresholdValue ===''?'-':Number(projectParam.costThresholdValue)*4 }}元/每月</span>
          <span style="margin-left:20px">时间:</span> <span> {{ clickParam.name }}</span>
          <span style="margin-left:20px">费用合计:</span> <span>{{ clickParam.value }}</span>元
        </span>
        <span v-else>
          <span>资源名称:</span> <span>{{ clickParam.name }}</span>
          <span style="margin-left:20px">费用合计:</span> <span>{{ clickParam.value }}</span>元
        </span>
      </el-row>
      <el-button v-show="bEdit" type="primary" size="mini" style="float:right;margin-right:10px;margin-top:-3px" @click="handleGanttTableEdit">编辑</el-button>
      <el-button v-show="isOpenEdit" type="primary" style="float:right;margin-right:8px;margin-top:-3px" size="mini" @click="saveTaskTable">保存</el-button>
      <el-button v-show="isOpenEdit" style="float:right;margin-right:8px;margin-top:-3px" size="mini" @click="handleCancelGanttEdit">取消</el-button>
      <el-checkbox v-show="!isOpenEdit" v-model="showGant" :disabled="showDetail" style="float:right;padding-right:8px">显示甘特图</el-checkbox>
      <el-checkbox v-show="!isOpenEdit" v-model="showDetail" style="float:right;padding-right:8px">显示资源/前置</el-checkbox>
      <el-popover
        v-model="showCustomCol"
        title="自定义列"
        width="120px"
        trigger="click"
      >
        <CustomCol :prop-all-col="allCol" :prop-select-col="selCol" style="padding:0px 10px 0px" @selectCol="setTableColumn" />
        <el-button slot="reference" size="mini" plain :icon="customIcon" style="float:right;margin-right:20px;margin-top:-3px">自定义列</el-button>
      </el-popover>

      <TaskList
        ref="taskList"
        :task-progress-info="taskProgressInfo"
        :props-is-open-edit="isOpenEdit"
        :show-detail="showDetail"
        :props-change-sel-col="changeSelCol"
        :with-out-gant="!showGant"
        :chart-type="clickParam.chartType"
        :res-sel-obj="clickParam"
        style="margin-top:15px;font-size:14px"
        :tab-type="tabType"
        @changeResource="changeResource"
      />
    </el-card>
    <el-dialog
      title="选择资源"
      :visible.sync="showResource"
      width="900px"
      @close="cancelResource"
    >
      <div style="height:460px;position:relative">
        <resource ref="resourceSel" :show-tree-tool-bar="false" :cur-sel-rows="selResData" :limit-enable-select="false" select-type="multiple" listurl="/project-schedule/planAdjust/queryResourceList" />
      </div>
      <span slot="footer">
        <span style="font-size:12px;float:left;margin-left:10px;margin-top:10px;color:#909399"> 说明：最多允许选择3个资源；为清晰查看资源预警情况，建议只选择1个资源。</span>
        <el-button @click="cancelResource">取 消</el-button>
        <el-button type="primary" @click="checkResouce">确 定</el-button>
      </span>
    </el-dialog>

  </div>
</template>

<script>
import BarChart from './BarChart'
import resource from '@/views/systemSet/resource/Resource'
import TaskList from './TaskList'
import { getProjectParams } from '@/api/projectSet'
import { getResource } from '@/api/planAdjust/planAdjust'
import CustomCol from '@/components/CustomCol/index.vue'
import { getRecentTaskEditList } from '@/api/taskView'
export default {
  components: {
    resource,
    BarChart,
    TaskList,
    CustomCol
  },
  data() {
    return {
      taskProgressInfo: {
      },
      isOpenEdit: false,
      allRes: [],
      showGant: false,
      showDetail: false,
      hideJD: false,
      leftOption: {
        title: {
          text: '资源使用情况统计',
          left: 'center'
        },
        click: true

      },
      rightOption: {
        title: {
          text: '费用统计',
          left: 'center'
        },
        click: false

      },

      tabName: '资源汇总',
      selResData: [],
      selectRes: {
        selectName: '',
        selectId: ''
      },
      clickParam: {
        seriesName: '-',
        selectId: '',
        startDate: '',
        endDate: '',
        name: '',
        value: '',
        warnValue: 0,
        cost: '-',
        chartType: 'date',
        dateUnit: 'week'

      },
      projectParam: {
        costThresholdValue: '',
        scheWbsLevelList: []
      },
      clickBarObj: {
        startDate: '',
        endDate: '',
        selectResId: ''
      },
      showResource: false,
      JSWData: false,
      NoSelResHeight: 500,
      showCustomCol: false,
      allCol: [],
      selCol: [],
      changeSelCol: []

    }
  },
  computed: {
    bEdit() {
      //       作业走审批流程时，只有(计划编制状态==已完成) and (审批状态==未提交 or 审批状态==变更未提交)时，允许编辑，否则不触发弹框；
      // 作业不走审批流程时，只有(计划编制状态==已完成)时，允许编辑，否则不触发弹框
      if (this.projectParam && this.projectParam.scheWbsLevelList.length > 0 && this.projectParam.scheWbsLevelList[this.projectParam.scheWbsLevelList.length - 1].approval) {
        // zuoye编辑条件
        if (!this.isOpenEdit && (this.taskProgressInfo.state === '1' && (this.taskProgressInfo.approveState === '01' || this.taskProgressInfo.approveState === '05'))) {
          return true
        } else {
          return false
        }
      } else {
        if (!this.isOpenEdit && this.taskProgressInfo.state === '1') {
          return true
        } else {
          return false
        }
      }
    },
    tabType() {
      return this.tabName === '资源汇总' ? 'res' : 'cost'
    },
    customIcon() {
      return this.showCustomCol ? 'el-icon-caret-top' : 'el-icon-caret-bottom'
    }
  },
  watch: {
    isOpenEdit(v) {
      if (v) {
        this.showDetail = true
      }
    },
    showDetail(v) {
      this.showGant = v
    },
    showResource(v) {
      if (v) {
        // 防止数据传过去以后界面还没渲染就执行相关界面操作
        this.$nextTick(() => {
          this.selResData = [...this.selResData]
        })
      }
    }
  },
  mounted() {
    this.getTaskProgress()
    this.initCustomCol()
    this.getProjectSet()
    this.NoSelResHeight = window.innerHeight - 138
    getResource({ projectId: this.$route.params.id }).then(res => {
      this.allRes = res.data
      if (res.data.length > 0) {
        res.data.forEach(element => {
          element.id = element.resId
        })
        this.selResData = [res.data[0]]
        this.$set(this.selectRes, 'selectId', res.data[0].resId)
        this.$set(this.selectRes, 'selectName', res.data[0].resName)
      }
    })
  },
  methods: {
    getTaskProgress() {
      getRecentTaskEditList({ projectId: this.$route.params.id }).then(res => {
        if (res.state === 'success') {
          this.taskProgressInfo = res.data
        } else {
          this.$message.error('查询作业进展状态失败')
        }
      })
    },
    initCustomCol() {
      if (this.allCol.length === 0) {
        this.allCol = [{
          name: 'wbs',
          label: '序号',
          disabled: true
        }, {
          label: '编码',
          name: 'wbsCode'
        }, {
          label: '名称',
          name: 'text',
          disabled: true

        },
        {
          label: '类型',
          name: 'taskMold'

        },
        {
          label: '前置任务',
          name: 'taskPreCodes'

        },
        {
          label: '使用量',
          name: 'resCount'

        },
        {
          label: '计划工期',
          name: 'duration'

        },
        {
          label: '计划开始时间',
          name: 'planStartDate'

        }, {
          label: '计划结束时间',
          name: 'planEndDate'

        }]
      }
      if (this.selCol.length === 0) {
        this.selCol = [{
          name: 'wbs',
          label: '序号'

        }, {
          label: '名称',
          name: 'text'

        }, {
          label: '使用量',
          name: 'resCount',
          min_width: 100,
          align: 'center'
        }, {
          label: '计划工期',
          name: 'planDuration'

        },
        {
          label: '计划开始时间',
          name: 'planStartDate'

        }, {
          label: '计划结束时间',
          name: 'planEndDate'

        }]
      }
    },
    setTableColumn(arr) {
      this.changeSelCol = [...arr]
    },
    clearSelect() {
      this.selResData = []
      this.selectRes = {
        selectId: '',
        selectName: ''
      }
    },
    hideJSWD(v) {
      this.hideJD = v
      if (v) {
        this.JSWData = false
      }
    },
    // 保存更改资源信号
    changeResource() {
      this.$refs.warbResBar.getStatic(false)
      this.$refs.CostBar.getStatic(false)
      this.isOpenEdit = false
    },
    getProjectSet() {
      getProjectParams({ projectId: this.$route.params.id }).then(res => {
        this.projectParam = Object.assign({}, this.projectParam, res.data)
      })
    },
    tabChange(tabName) {

    },
    clickBar(clickParam) {
      if (this.tabType === 'res') {
        this.dealClickParam(clickParam)
        this.allRes.forEach(resItem => {
          if (resItem.resId === clickParam.seriesId) {
            this.$set(this.clickParam, 'warnValue', resItem.warnValue)
            this.$nextTick(() => {
              this.$refs.warbResBar.setMyChart()
            })
          }
        })
      } else {
        this.dealClickParam(clickParam)
      }
    },
    dealClickParam(clickParam) {
      this.clickParam = Object.assign({}, this.clickParam)
      Object.keys(this.clickParam).forEach(key => { this.clickParam[key] = clickParam[key] })
      this.clickParam.chartType = clickParam.chartType
      if (this.clickParam.chartType !== 'cost') {
        var date = clickParam.name
        date = date.replace(/\./g, '-')
        if (date && date.indexOf('~') > -1) {
          this.$set(this.clickParam, 'startDate', date.split('~')[0])
          this.$set(this.clickParam, 'endDate', date.split('~')[1])
          this.clickParam.dateUnit = 'week'
        } else {
          this.clickParam.dateUnit = 'month'
          const firstday = (date + '-' + '01')
          const lastDay = date + '-' + this.getLastDay(date.split('-')[0], date.split('-')[1])
          this.clickParam.name = (firstday + '~' + lastDay).replace(/\-/g, '.')
          this.$set(this.clickParam, 'startDate', firstday)
          this.$set(this.clickParam, 'endDate', lastDay)
        }
      }
      this.$set(this.clickParam, 'selectId', clickParam.seriesId)
    },
    getLastDay(year, month) {
      var new_year = year // 取当前的年份
      var new_month = month++// 取下一个月的第一天，方便计算（最后一天不固定）
      if (month > 12) { // 如果当前大于12月，则年份转到下一年
        new_month -= 12 // 月份减
        new_year++ // 年份增
      }
      var new_date = new Date(new_year, new_month, 1) // 取当年当月中的第一天
      return (new Date(new_date.getTime() - 1000 * 60 * 60 * 24)).getDate()// 获取当月最后一天日期
    },
    cancelResource() {
      this.$refs.resourceSel.cancelSel()
      this.showResource = false
    },
    setWarnValue() {
      this.$router.push({ path: '/planAdjust/setWarning/' + this.$route.params.id, query: { costThresholdValue: this.projectParam.costThresholdValue }})
    },
    checkResouce() {
      let strId = ''
      let strName = ''
      // human的humanSelArr
      const humanSelArr = [...this.$refs.resourceSel.$refs['human'].selResouce]
      const materialSelArr = [...this.$refs.resourceSel.$refs['material'].selResouce]
      const deviceSelArr = [...this.$refs.resourceSel.$refs['device'].selResouce]
      if (humanSelArr.length + materialSelArr.length + deviceSelArr.length > 3) {
        this.$message({
          message: '所选资源不能超过三个',
          type: 'warning'
        })
        return
      }
      this.showResource = false
      this.selResData = []
      this.dealSelArr(humanSelArr, '1')
      this.dealSelArr(materialSelArr, '2')
      this.dealSelArr(deviceSelArr, '3')
      // 处理选中的显示
      this.selResData.forEach(element => {
        const name = element.name || element.resourceName
        strId = strId ? strId + ',' + element.id : element.id
        strName = strName ? strName + ',' + name : name
      })
      this.$set(this.selectRes, 'selectId', strId)
      this.$set(this.selectRes, 'selectName', strName)
    },
    dealSelArr(arr, resType) {
      if (arr instanceof Array && arr.length > 0) {
        arr.forEach(element => {
          element['resType'] = resType
          if (resType === '1') {
            element.resourceName = element.name
          }
          this.selResData.push(element)
        })
      }
    },
    handleGanttTableEdit() {
      this.isOpenEdit = !this.isOpenEdit
    },
    handleCancelGanttEdit() {
      this.isOpenEdit = !this.isOpenEdit
    },
    saveTaskTable() {
      this.$refs.taskList.saveTaskTable()
    }
  }
}
</script>
<style lang="scss" scoped>
#planAdjust.pageDiv{
  padding:10px;
  position:absolute;
  height:100%;
  width:100%;
  overflow:scroll;
}
.w-200{
  width:200px
}
.mt-20{
  margin-top:20px
}
.mt-10{
  margin-top:10px
}
/deep/ .el-checkbox {
    color: #606266;
    font-weight: 500;
    font-size: 14px;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    margin-right: 10px;
}
</style>
