<template>
  <el-card class="mt-10 ml-10 mr-10 min-w">
    <div class="clearfix">
      <div class="fl">
        <el-popover
          v-model="showCustomCol"
          title="自定义列"
          width="120px"
          trigger="click"
        >
          <CustomCol :prop-all-col="allCol" :prop-select-col="selCol" @selectCol="setTableColumn" />
          <el-button slot="reference" size="mini" plain :icon="customIcon" style="margin-right:10px">自定义列</el-button>
        </el-popover>
        <el-button type="text" @click="openTask">全部展开</el-button>
        <el-button type="text" @click="closeTask">全部收起</el-button>
      </div>
      <div class="ml-50 fl">
        <el-button v-if="isFilterCriticalTask" type="primary" @click="handleCalculateCriticalPath(1)">过滤关键活动</el-button>
        <el-button v-else type="primary" @click="handleCalculateCriticalPath(0)">取消过滤关键活动</el-button>
      </div>
      <div class="ml-50 fr">
        <el-checkbox v-model="showGantt" style="margin-right:20px;" @change="initGantt">只显示甘特图</el-checkbox>
        <el-button type="primary" @click="zoomIn()">放大</el-button>
        <el-button type="primary" @click="zoomOut()">缩小</el-button>
      </div>
    </div>
    <div class="mt-10 clearfix">
      <gantt
        ref="gantDiv"
        :drag-branch-free="false"
        :drag-move-date="false"
        :drag-resize-date="false"
        :style="{'width':'100%','height':maxGridHeight+'px'}"
        :tasks="tasks"
        :filter="onBeforeTaskDisplay"
        :gant-columns="tablecolumn"
        :with-out-grid="showGantt"
      />
    </div>
    <div class="clearfix mt-10">
      <div class="clearfix">
        <div style="width: 48%;height:50px;float:left;margin-right:3%;">
          <el-tooltip effect="light" :content="selectRescourse1" placement="top" :disabled="selectRescourse1? false: true">
            <el-input
              v-model="selectRescourse1"
              style="width: 100%;margin-right:50px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
              placeholder="请选择资源"
              clearable
              @keyup.native="value=value.replace(/[^\d]/g,'')"
              @focus="selectResource(1)"
              @clear="clearSelect1"
            />
          </el-tooltip>
          <div style="float:right;">
            <img v-if="timeValue1 === '1'" :src="week" alt="周" style="cursor: pointer;" @click="toggleTime1(2)">
            <img v-if="timeValue1 === '1'" :src="monthOn" alt="月选" style="cursor: pointer;" @click="toggleTime1(1)">
            <img v-if="timeValue1 === '2'" :src="weekOn" alt="周选" style="cursor: pointer;" @click="toggleTime1(2)">
            <img v-if="timeValue1 === '2'" :src="month" alt="月" style="cursor: pointer;" @click="toggleTime1(1)">
          </div>
        </div>
        <div style="width: 49%;height:50px;float:left;">
          <el-tooltip effect="light" :content="selectRescourse2" placement="top" :disabled="selectRescourse2? false: true">
            <el-input
              v-model="selectRescourse2"
              style="width: 100%;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;"
              placeholder="请选择资源"
              clearable
              @keyup.native="value=value.replace(/[^\d]/g,'')"
              @focus="selectResource(2)"
              @clear="clearSelect2"
            />
          </el-tooltip>
          <div style="float:right;">
            <img v-if="timeValue2 === '1'" :src="week" alt="周" style="cursor: pointer;" @click="toggleTime2(2)">
            <img v-if="timeValue2 === '1'" :src="monthOn" alt="月选" style="cursor: pointer;" @click="toggleTime2(1)">
            <img v-if="timeValue2 === '2'" :src="weekOn" alt="周选" style="cursor: pointer;" @click="toggleTime2(2)">
            <img v-if="timeValue2 === '2'" :src="month" alt="月" style="cursor: pointer;" @click="toggleTime2(1)">
          </div>
        </div>
      </div>
      <!-- 折线图 -->
      <div class="mt-10">
        <div v-show="!showline" style="width: 49%;height:300px;float:left;text-align:center;vertical-align:middle;line-height:300px;">选择资源</div>
        <div v-show="showline" id="dataTable1" style="width: 49%;height:300px;float:left;" />
        <div v-show="!showline2" style="width: 49%;height:300px;float:left;margin-left:2%;text-align:center;vertical-align:middle;line-height:300px;">选择资源</div>
        <div v-show="showline2" id="dataTable2" style="width: 49%;height:300px;float:left;margin-left:2%;" />
      </div>
    </div>
    <el-dialog
      title="选择资源"
      :visible.sync="dialogVisible1"
      width="50%"
    >
      <div style="height:440px;position:relative;">
        <resource ref="resourceSel1" key-word="resId" :cur-sel-rows="curSelRows1" select-type="singleSelect" type-url="planlistView" @resourceTypeChange="resourceTypeChange1" />
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="clearSelect1">取 消</el-button>
        <el-button type="primary" @click="handleSetResouce1">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title="选择资源"
      :visible.sync="dialogVisible2"
      width="50%"
    >
      <div style="height:440px;position:relative;">
        <Resource ref="resourceSel2" key-word="resId" :cur-sel-rows="curSelRows2" select-type="multiple" type-url="planlistView" @resourceTypeChange="resourceTypeChange2" />
      </div>
      <span slot="footer" class="dialog-footer">
        <el-button @click="clearSelect2">取 消</el-button>
        <el-button type="primary" @click="handleSetResouce2">确 定</el-button>
      </span>
    </el-dialog>
  </el-card>
</template>

<script>
import { month, week, monthOn, weekOn } from './imagePath'
// import { getTaskList } from '@/api/taskView'
import { mapGetters } from 'vuex'
// import { getHumanList, getResourceList } from '@/api/resource'
import { getReport, getResourceStatisticsInfo } from '@/api/scheAnalysis/scheAnalysis'
import Gantt from '@/components/Gantt/index.vue'
import { getCriticalPath } from '@/api/taskEdit'
import CustomCol from '@/components/CustomCol/index.vue'
import Resource from '@/views/systemSet/resource/Resource'
import { getProjectPeriod } from '@/api/progressReport'
import { queryResourceList } from '@/api/resource'
export default {
  name: 'PlanListView',
  components: {
    Gantt,
    CustomCol,
    Resource
  },
  data() {
    return {
      /* resource */
      bPeriod: false,
      curTabName1: 'human',
      curTabName2: 'human',
      curSelRows1: [],
      curSelRows2: [],
      select_radio: '',
      multipleSelection: [],
      month: month,
      week: week,
      monthOn: monthOn,
      weekOn: weekOn,
      selectRescourse1: '请选择资源',
      selectRescourse2: '请选择资源',
      myChart1: {},
      myChart2: {},
      option1: {},
      option2: {},
      showline: false,
      showline2: false,
      timeValue1: '1',
      timeValue2: '1',
      maxHeight: 320,
      resourceGridForm: {
        data: [{
          id: '',
          code: 'M-0001',
          resName: '马',
          resType: '1',
          resModel: '',
          unitEstimate: '匹',
          unitPrice: 100,
          amount: 100,
          startDate: '2020-01-01',
          endDate: '2020-01-01',
          expCost: 1400
        }],
        loading: false
      },
      // *** //
      isFilterCriticalTask: true,
      dialogVisible1: false,
      dialogVisible2: false,
      globalParam: { projectId: this.$route.params.id },
      showGantt: false,
      taskVersionInfo: null,
      currentObj: null,
      maxGridHeight: 300,
      tasks: {
        parent: '',
        data: [],
        links: []
      },
      tablecolumn: [],
      planTypeComboxOptions: [
        {
          name: 'WBS',
          dictCode: '0'
        }, {
          name: '作业',
          dictCode: '1'
        }
      ],
      taskTypeComboxOptions: [
        {
          name: '里程碑',
          dictCode: '0'
        }, {
          name: '作业',
          dictCode: '1'
        }
      ],
      scheCalcTypeComboxOptions: [
        {
          name: '工期百分比',
          dictCode: '01'
        }, {
          name: '资源百分比',
          dictCode: '02'
        }, {
          name: '实际百分比',
          dictCode: '03'
        }
      ],
      showCustomCol: false,
      allCol: [],
      selCol: []
    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ]),
    customIcon() {
      return this.showCustomCol ? 'el-icon-caret-top' : 'el-icon-caret-bottom'
    }
  },
  watch: {
    // 观察option的变化
    option1: {
      handler(newVal, oldVal) {
        if (this.myChart1) {
          if (newVal) {
            this.myChart1.setOption(newVal)
          } else {
            this.myChart1.setOption(oldVal)
          }
        } else {
          this.init('dataTable1', 1)
        }
      },
      deep: true // 对象内部属性的监听，关键。
    },
    option2: {
      handler(newVal, oldVal) {
        if (this.myChart2) {
          if (newVal) {
            this.myChart2.setOption(newVal)
          } else {
            this.myChart2.setOption(oldVal)
          }
        } else {
          this.init('dataTable2', 2)
        }
      },
      deep: true // 对象内部属性的监听，关键。
    }
  },
  async created() {
    this.fetchTaskList()
    const vm = this
    this.$nextTick(() => {
      window.handlePlanTypeCovert = function(value) {
        return vm.planTypeComboxOptions.find((element) => (element.dictCode === value)).name
      }
      window.handleScheCalcTypeCovert = function(value) {
        return vm.scheCalcTypeComboxOptions.find((element) => (element.dictCode === value)).name
        // vm.handleScheCalcTypeCovert(value)
      }
      window.handleTaskTypeCovert = function(value) {
        return vm.taskTypeComboxOptions.find((element) => (element.dictCode === value)).name
        // vm.handleTaskTypeCovert(value)
      }
    })
    this.getProjectPeriod()
  },

  mounted() {
    this.setTableColumn()
    this.setTaskGridRowBackGroundColor()
    var param1 = {
      projectId: this.$route.params.id,
      resType: '1',
      resName: '',
      groupName: ''
    }
    queryResourceList(param1).then(res => {
      console.log('资源', res)
      this.curSelRows1 = []
      this.curSelRows2 = []
      if (res.data && res.data.length !== 0) {
        var flag = true
        this.select_radio = []
        this.findTree(res.data, el => {
          if (!el.isLeaf && flag) {
            flag = false
            this.select_radio.push(el)
            this.multipleSelection.push(el)
            this.curSelRows1.push(el)
            this.curSelRows2.push(el)
          }
        })
        this.sure(1)
        this.sure(2)
      }
    })
    var param = {
      projectId: this.$route.params.id,
      resType: '1',
      resName: '',
      groupName: ''
    }
    queryResourceList(param).then(res => {
      console.log('资源', res)
      if (res.data && res.data.length !== 0) {
        var flag = true
        this.select_radio = []
        this.findTree(res.data, el => {
          if (!el.isLeaf && flag) {
            flag = false
            this.select_radio.push(el)
          }
        })
        this.sure(1)
        this.sure(2)
      }
    })
  },
  methods: {
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    getProjectPeriod() {
      getProjectPeriod({ projectId: this.$route.params.id }).then(res => {
        if (res.data === '2' || res.data === '3' || res.data === '4') {
          this.bPeriod = true
        } else {
          this.bPeriod = false
        }
        this.selCol = []
        this.allCol = []
        this.setTableColumn()
      })
    },
    setTaskGridRowBackGroundColor() {
      this.$refs.gantDiv.ganttObj.templates.grid_row_class = function(start, end, task) {
        if (task.taskMold === '0') {
          return 'task-grid-wbs-row-background-color'
        }
        return ''
      }
    },
    initGantt() {
      console.log(this.showGantt)
      console.log(this.$refs.gantDiv)
      this.$refs.gantDiv.ganttObj.render()
    },
    toggleTime1(type) {
      if (type === 1) {
        this.timeValue1 = '1'
      } else {
        this.timeValue1 = '2'
      }
      if (this.showline) {
        this.sure(1)
      }
    },
    toggleTime2(type) {
      if (type === 1) {
        this.timeValue2 = '1'
      } else {
        this.timeValue2 = '2'
      }
      if (this.showline2) {
        this.sure(2)
      }
    },
    setTableColumn(arr) {
      if (!this.$refs.gantDiv || !this.$refs.gantDiv.ganttObj) {
        return
      }
      if (this.allCol.length === 0) {
        if (this.bPeriod) {
          this.allCol = [
            {
              title: '序号',
              disabled: true,
              template: this.gantDiv.ganttObj.getWBSCode,
              align: 'left',
              name: 'wbs',
              tree: true
            },
            {
              title: '名称',
              key: 'wbsName',
              width: 320,
              align: 'left',
              disabled: true
            },
            {
              title: '编码',
              key: 'wbsCode',
              align: 'center',
              width: 130
            },
            {
              title: '类型',
              key: 'taskMoldName',
              align: 'center',
              width: 100
            },
            {
              title: '作业状态',
              key: 'taskStateName',
              align: 'center',
              width: 80
            },
            {
              title: '进度状态',
              key: 'scheStateName',
              align: 'center',
              width: 80
            },
            {
              title: '本期完成比例',
              key: 'currFinishPercent',
              align: 'center',
              width: 80,
              type: 'percent'
            },
            {
              title: '上期累计完成比例',
              key: 'lastSumFinishPercent',
              align: 'center',
              width: 100,
              type: 'percent'
            },
            {
              title: '累计完成比例',
              key: 'currSumFinishPercent',
              align: 'center',
              width: 100,
              type: 'percent'
            },

            {
              title: '作业类型',
              key: 'taskTypeName',
              align: 'center',
              width: 80
            },
            {
              title: '权重比例',
              key: 'weights',
              align: 'center',
              width: 80
            },
            {
              title: '计划工期',
              key: 'planDuration',
              align: 'center',
              width: 80
            },
            {
              title: '计划开始时间',
              key: 'planStartDate',
              align: 'center',
              width: 100
            },
            {
              title: '计划结束时间',
              key: 'planEndDate',
              align: 'center',
              width: 100
            },

            {
              title: '进度计算方式',
              key: 'scheCalcTypeName',
              align: 'center',
              width: 100
            },
            {
              title: '实际工期',
              key: 'realDuration',
              align: 'center',
              width: 80
            },
            {
              title: '剩余工期',
              key: 'remainDuration',
              align: 'center',
              width: 80
            },

            {
              title: '实际开始时间',
              key: 'realStartDate',
              align: 'center',
              width: 100
            },
            {
              title: '实际完成时间',
              key: 'realEndDate',
              align: 'center',
              width: 100
            },

            {
              title: '负责人',
              key: 'principalName',
              align: 'center',
              width: 80
            }
          ]
        } else {
          this.allCol = [
            {
              title: '序号',
              disabled: true,
              template: this.$refs.gantDiv.ganttObj.getWBSCode,
              align: 'left',
              name: 'wbs'
            },
            {
              title: '名称',
              key: 'wbsName',
              align: 'left',
              width: 320,
              disabled: true,
              tree: true
            },
            {
              title: '编码',
              key: 'wbsCode',
              align: 'center',
              width: 80
            },
            {
              title: '类型',
              key: 'taskMoldName',
              align: 'center',
              width: 100
            },
            {
              title: '作业状态',
              key: 'taskStateName',
              align: 'center',
              width: 80
            },
            {
              title: '进度状态',
              align: 'center',
              key: 'scheStateName',
              width: 80
            },
            {
              title: '累计完成比例',
              key: 'currSumFinishPercent',
              align: 'center',
              width: 100,
              type: 'percent'
            },
            {
              title: '作业类型',
              key: 'taskTypeName',
              align: 'center',
              width: 80
            },
            {
              title: '权重比例',
              key: 'weights',
              align: 'center',
              width: 80
            },
            {
              title: '计划工期',
              key: 'planDuration',
              align: 'center',
              width: 80
            },
            {
              title: '计划开始时间',
              key: 'planStartDate',
              align: 'center',
              width: 100
            },
            {
              title: '计划结束时间',
              key: 'planEndDate',
              align: 'center',
              width: 100
            },

            {
              title: '进度计算方式',
              key: 'scheCalcTypeName',
              align: 'center',
              width: 100
            },
            {
              title: '实际工期',
              key: 'realDuration',
              align: 'center',
              width: 80
            },
            {
              title: '剩余工期',
              key: 'remainDuration',
              align: 'center',
              width: 80
            },
            {
              title: '实际开始时间',
              key: 'realStartDate',
              align: 'center',
              width: 100
            },
            {
              title: '实际完成时间',
              key: 'realEndDate',
              align: 'center',
              width: 100
            },

            {
              title: '负责人',
              align: 'center',
              key: 'principalName',
              width: 80
            }
          ]
        }
        this.allCol.forEach(element => {
          element.name = element.key
          element.label = element.title
        })
      }
      if (this.selCol.length === 0) {
        this.selCol = [{
          name: 'wbs',
          label: '序号',
          width: 150,
          template: this.$refs.gantDiv.ganttObj.getWBSCode,
          align: 'left'
        }, {
          label: '名称',
          name: 'text',
          width: 200,
          tree: true,
          resize: true,
          align: 'left',
          template: function(obj) {
            if (!obj.parent) {
              return ('<span style="font-weight:700">') + obj.text + ('</span>')
            } else {
              return obj.text
            }
          }
        }, {
          label: '作业状态',
          name: 'taskStateName',
          min_width: 100,
          align: 'center',
          resize: true
        },
        {
          label: '进度状态',
          name: 'scheStateName',
          min_width: 100,
          align: 'center',
          resize: true
        },
        {
          label: '累计完成比例',
          name: 'currSumFinishPercent',
          min_width: 100,
          align: 'center',
          resize: true,
          template: function(obj) {
            return obj.currSumFinishPercent + '%'
          }
        },
        {
          label: '实际工期',
          name: 'realDuration',
          min_width: 80,
          align: 'center',
          resize: true
        }, {
          label: '剩余工期',
          name: 'remainDuration',
          min_width: 80,
          align: 'center',
          resize: true
        }, {
          label: '实际开始时间',
          name: 'realStartDate',
          min_width: 100,
          align: 'center',
          resize: true
        },
        {
          label: '实际完成时间',
          name: 'realEndDate',
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
      }
      let tmpArr = []
      if (!arr) {
        this.selCol.forEach(element => {
          tmpArr.push(element.label)
        })
      } else {
        tmpArr = arr
      }

      var selArr = []
      this.allCol.forEach(itemCol => {
        tmpArr.forEach(label => {
          if (itemCol.label === label) {
            selArr.push(itemCol)
          }
        })
      })
      this.tablecolumn = [...selArr]
    },
    convertTreeData(parent, arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj, parent)
        if (obj.childList) {
          this.tasks.parent = obj.id
          this.convertTreeData(obj.id, obj.childList, callBack)
          this.tasks.parent = ''
        }
      })
    },
    fetchTaskList() {
      var param = {}
      if (this.taskVersionInfo) {
        param = this.taskVersionInfo
      } else {
        param = this.globalParam
      }
      getReport(param, Boolean(this.taskVersionInfo)).then(res => {
        // console.log(res)
        var treeData = []
        // var links = []
        this.tasks.links = []
        if (res.state === 'success') {
          this.convertTreeData('', res.data.trees, (item, parent) => {
            item.parent = parent || ''
            if (item.planStartDate && item.planEndDate) {
              item.start_date = item.planStartDate.split(' ')[0].split('-')[2] + '-' + item.planStartDate.split(' ')[0].split('-')[1] + '-' + item.planStartDate.split(' ')[0].split('-')[0]
              item.duration = this.DateMinus(item.planStartDate, item.planEndDate)
            } else {
              item.start_date = ''
              item.end_date = ''
              item.duration = '0'
              item.unscheduled = true
            }
            item.text = item.wbsName
            treeData.push(item)
            if (Array.isArray(item.relateList) && item.relateList.length) {
              for (let i = 0, len = item.relateList.length; i < len; i++) {
                this.tasks.links.push({ id: item.relateList[i].id, source: item.relateList[i].taskPreId, target: item.relateList[i].taskNextId, type: item.relateList[i].relationshipId })
                // links.push({ id: item.relateList[i].id, source: item.relateList[i].taskPreId, target: item.relateList[i].taskNextId, type: item.relateList[i].relationshipId })
              }
            }
          })
          this.tasks.data = treeData
          console.log(this.tasks)
        } else {
          this.$message.error('初始化作业列表失败')
        }
      }).catch()
    },
    onBeforeTaskDisplay(id, task) {
      if (task.taskMold === '0') {
        return true
      }
      var count = 0
      if (!this.isFilterCriticalTask) {
        if (task.criticalTask === '1') {
          count++
        }
      } else {
        count++
      }
      if (count === 1) {
        return true
      } else {
        return false
      }
    },
    searchTaskByParam() {
      this.$refs.gantDiv.ganttObj.refreshData()
    },
    handleCalculateCriticalPath(criticalTask) {
      console.log(111)
      // if (criticalTask === 1) {
      //   this.isFilterCriticalTask = false
      // } else if (criticalTask === 0) {
      //   this.isFilterCriticalTask = true
      // }
      var param
      if (criticalTask < 2) {
        param = { ...this.globalParam, ...{ criticalTask: criticalTask }}
        // return this.searchTaskByParam()
      } else {
        param = this.globalParam
      }
      if (!this.isFilterCriticalTask) {
        this.isFilterCriticalTask = true
        this.searchTaskByParam()
      }
      getCriticalPath(param).then(res => {
        console.log(res)
        var treeData = []
        // var links = []
        this.tasks.links = []
        if (res.state === 'success') {
          if (res.code === '501') {
            this.fetchTaskList()
            return this.$message.warning(res.msg)
          }
          this.convertTreeData('', res.data, (item, parent) => {
            item.parent = parent || ''
            if (item.planStartDate && item.planEndDate) {
              item.start_date = item.planStartDate.split(' ')[0].split('-')[2] + '-' + item.planStartDate.split(' ')[0].split('-')[1] + '-' + item.planStartDate.split(' ')[0].split('-')[0]
              item.duration = this.DateMinus(item.planStartDate, item.planEndDate)
              item.unscheduled = false
            } else {
              item.start_date = ''
              item.end_date = ''
              item.duration = '0'
              item.unscheduled = true
            }
            item.text = item.wbsName
            treeData.push(item)
            if (Array.isArray(item.relateList) && item.relateList.length) {
              for (let i = 0, len = item.relateList.length; i < len; i++) {
                this.tasks.links.push({ id: item.relateList[i].id, source: item.relateList[i].taskPreId, target: item.relateList[i].taskNextId, type: item.relateList[i].relationshipId })
                // links.push({ id: item.relateList[i].id, source: item.relateList[i].taskPreId, target: item.relateList[i].taskNextId, type: item.relateList[i].relationshipId })
              }
            }
          })
          this.tasks.data = treeData
          /* 清空当前选中节点 */
          if (this.currentObj) {
            this.currentObj = null
          }
          var message = '计算成功'
          if (criticalTask === 1) {
            message = '过滤成功'
            this.isFilterCriticalTask = false
          } else if (criticalTask === 0) {
            message = '取消过滤成功'
            this.isFilterCriticalTask = true
          }
          this.$message.success(message)
          // this.isFilterCriticalTask = false
        } else {
          this.$message.error('操作失败')
        }
      })
    },
    openTask() {
      // this.$refs.gantDiv.ganttObj.config.open_tree_initially = false
      if (this.currentObj) {
        this.$refs.gantDiv.ganttObj.open(this.currentObj.id)
      } else {
        this.$refs.gantDiv.ganttObj.eachTask(function(task) {
          task.$open = true
        })
        this.$refs.gantDiv.ganttObj.render()
      }
    },
    closeTask() {
      if (this.currentObj) {
        this.$refs.gantDiv.ganttObj.close(this.currentObj.id)
      } else {
        this.$refs.gantDiv.ganttObj.eachTask(function(task) {
          task.$open = false
        })
        this.$refs.gantDiv.ganttObj.render()
      }
    },
    // date1:小日期 date2:大日期
    DateMinus(startDate, endDate) {
      var sdate = new Date(startDate)
      var now = new Date(endDate)
      var days = now.getTime() - sdate.getTime()
      var day = parseInt(days / (1000 * 60 * 60 * 24))
      return day + 1
    },
    zoomIn() {
      this.$refs.gantDiv.zoomIn()
    },
    zoomOut() {
      this.$refs.gantDiv.zoomOut()
    },
    selectResource(type) {
      console.log('this.curSelRows1', this.curSelRows1)
      console.log('this.curSelRows1', this.curSelRows2)
      if (type === 1) {
        this.dialogVisible1 = true
      } else {
        this.dialogVisible2 = true
      }
    },
    cancel(type) {
      if (type === 1) {
        this.dialogVisible1 = false
      } else {
        this.dialogVisible2 = false
      }
    },
    init(echartsName, type) {
      var echarts = require('echarts')
      if (type === 1) {
        this.myChart1 = echarts.init(document.getElementById(echartsName))
        this.myChart1.setOption(this.option1, true)
      } else {
        this.myChart2 = echarts.init(document.getElementById(echartsName))
        this.myChart2.setOption(this.option2, true)
      }
    },
    clearSelect1() {
      this.selectRescourse1 = '请选择资源'
      this.curSelRows1 = []
      this.showline = false
      this.$refs.resourceSel1.cancelSel()
      this.dialogVisible1 = false
    },
    clearSelect2() {
      this.selectRescourse2 = '请选择资源'
      this.curSelRows2 = []
      this.showline2 = false
      this.$refs.resourceSel2.cancelSel()
      this.dialogVisible2 = false
    },
    /* resource */
    resourceTypeChange1({ activeName }) {
      this.curTabName1 = activeName
    },
    resourceTypeChange2({ activeName }) {
      this.curTabName2 = activeName
    },
    async sure(type) {
      var endValue = 100
      if (type === 1) {
        if (this.select_radio === '') {
          this.showline = false
          return
        }
        // console.log('sure1', this.select_radio)
        this.selectRescourse1 = this.select_radio[0].name ? this.select_radio[0].name : this.select_radio[0].resourceName
        var params = {
          projectId: this.$route.params.id,
          period: this.timeValue1,
          resIds: this.select_radio[0].id,
          isCaculate: 0
        }
        // console.log('params', params)
        var xplan = []
        var yplan = []
        var xactual = []
        var yactual = []
        await getResourceStatisticsInfo(params).then(res => {
          console.log(res)
          if (res && res.state === 'success') {
            res.data.actualStaticsList.forEach(el => {
              xactual.push(el.xName)
              yactual.push(el.yTotal)
            })
            res.data.planStatisticsList.forEach(el => {
              xplan.push(el.xName)
              yplan.push(el.yTotal)
            })
          }
        }).catch()
        // console.log(xplan, yplan, xactual, yactual)
        this.showline = true
        this.dialogVisible1 = false
        this.$nextTick(() => {
          console.log('xplan', xplan)
          if (xplan.length > 0) {
            if (xplan.length > 5) {
              endValue = Math.round(5 / xplan.length * 100)
            } else {
              endValue = 100
            }
          }
          // const myChart1 = echarts.init(document.getElementById('dataTable1'))
          this.option1 = {
            title: {
              text: '资源曲线',
              top: '20px',
              textStyle: {
                fontSize: 16
              }
            },
            tooltip: {
              trigger: 'axis',
              formatter(params) {
              // console.log('params', params)
                if (params.length === 2) {
                  var relVal2 = params[0].name + '<br/>'
                  relVal2 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(0).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(0).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
                  return relVal2
                } else if (params.length === 1) {
                  var relVal3 = params[0].name + '<br/>'
                  relVal3 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(0).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
                  return relVal3
                } else {
                  return ''
                }
              }
            },
            legend: {
              // x: '200px',
              y: '20px',
              data: ['计划使用总量', '实际使用总量']
            },
            grid: {
              left: '3%',
              right: '4%',
              bottom: '8%',
              containLabel: true
            },
            xAxis: {
              type: 'category',
              boundaryGap: true,
              axisLabel: {
                interval: 0,
                formatter: function(value) {
                  let valueText = ''
                  if (value.length > 10) {
                    valueText = value.substring(0, 10) + '\n' + value.substring(10)
                  } else {
                    valueText = value
                  }
                  return valueText
                }
              },
              data: xplan
            },
            yAxis: {
              type: 'value'
            },
            dataZoom: [
              {
                start: 0, // 默认为0
                end: endValue, // 默认为100
                type: 'slider',
                show: true,
                xAxisIndex: [0]
              },
              {
                type: 'inside',
                show: true,
                yAxisIndex: [0],
                filterMode: 'empty'
              }
            ],
            series: [
              {
                name: '计划使用总量',
                type: 'line',
                data: yplan
              },
              {
                name: '实际使用总量',
                type: 'line',
                itemStyle: {
                  normal: {
                    color: '#0000FF',
                    lineStyle: {
                      color: '#0000FF'
                    }
                  }
                },
                data: yactual
              }
            ]
          }
          console.log('option1', this.option1)
          // myChart1.setOption(option1)
          this.init('dataTable1', 1)
        })
      } else {
        if (!this.multipleSelection || this.multipleSelection.length === 0) {
          this.showline2 = false
          return
        }
        // console.log('参数', this.multipleSelectionHuman, this.multipleSelectionMaterial, this.multipleSelectionDevice)
        var str1 = this.multipleSelection.map(function(obj, index) {
          return obj.id
        }).join(',')
        // var str2 = this.multipleSelectionMaterial.map(function(obj, index) {
        //   return obj.id
        // }).join(',')
        // var str3 = this.multipleSelectionDevice.map(function(obj, index) {
        //   return obj.id
        // }).join(',')
        var str4 = this.multipleSelection.map(function(obj, index) {
          return obj.name ? obj.name : obj.resourceName
        }).join(',')
        // var str5 = this.multipleSelectionMaterial.map(function(obj, index) {
        //   return obj.resourceName
        // }).join(',')
        // var str6 = this.multipleSelectionDevice.map(function(obj, index) {
        //   return obj.resourceName
        // }).join(',')
        this.selectRescourse2 = str4
        var param = {
          projectId: this.$route.params.id,
          period: this.timeValue2,
          resIds: str1,
          isCaculate: 1
        }
        // console.log('param', param)
        var xplan2 = []
        var yplan2 = []
        var xactual2 = []
        var yactual2 = []
        await getResourceStatisticsInfo(param).then(res => {
          console.log(res)
          if (res && res.state === 'success') {
            res.data.actualStaticsList.forEach(el => {
              xactual2.push(el.xName)
              yactual2.push(el.yTotal)
            })
            res.data.planStatisticsList.forEach(el => {
              xplan2.push(el.xName)
              yplan2.push(el.yTotal)
            })
          }
        }).catch()
        // console.log(xplan2, yplan2, xactual2, yactual2)
        this.showline2 = true
        this.dialogVisible2 = false
        this.$nextTick(() => {
          if (xplan2.length > 0) {
            if (xplan2.length > 5) {
              endValue = Math.round(5 / xplan2.length * 100)
            } else {
              endValue = 100
            }
          }
          // const myChart2 = echarts.init(document.getElementById('dataTable2'))
          this.option2 = {
            title: {
              text: '资金曲线',
              top: '20px',
              textStyle: {
                fontSize: 16
              }
            },
            tooltip: {
              trigger: 'axis',
              formatter(params) {
              // console.log('params', params)
                if (params.length === 2) {
                  var relVal2 = params[0].name + '<br/>'
                  relVal2 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                  return relVal2
                } else if (params.length === 1) {
                  var relVal3 = params[0].name + '<br/>'
                  relVal3 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                  return relVal3
                } else {
                  return ''
                }
              }
            },
            legend: {
              // x: '200px',
              y: '20px',
              data: ['计划费用(元)', '实际费用(元)']
            },
            grid: {
              left: '3%',
              right: '4%',
              bottom: '8%',
              containLabel: true
            },
            xAxis: {
              type: 'category',
              boundaryGap: true,
              axisLabel: {
                interval: 0,
                formatter: function(value) {
                  let valueText = ''
                  if (value.length > 10) {
                    valueText = value.substring(0, 10) + '\n' + value.substring(10)
                  } else {
                    valueText = value
                  }
                  return valueText
                }
              },
              data: xplan2
            },
            yAxis: {
              type: 'value'
            },
            dataZoom: [
              {
                start: 0, // 默认为0
                end: endValue, // 默认为100
                type: 'slider',
                show: true,
                xAxisIndex: [0]
              },
              {
                type: 'inside',
                show: true,
                yAxisIndex: [0],
                filterMode: 'empty'
              }
            ],
            series: [
              {
                name: '计划费用(元)',
                type: 'line',
                data: yplan2
              },
              {
                name: '实际费用(元)',
                type: 'line',
                itemStyle: {
                  normal: {
                    color: '#0000FF',
                    lineStyle: {
                      color: '#0000FF'
                    }
                  }
                },
                data: yactual2
              }
            ]
          }
          // myChart2.setOption(option2)
          this.init('dataTable2', 2)
        })
      }
    },
    handleSetResouce1() {
      this.select_radio = [...this.$refs.resourceSel1.$refs[this.$refs.resourceSel1['activeName']].selResouce]
      console.log(this.select_radio)
      if (!this.select_radio) {
        console.log('11122')
        this.$message({
          type: 'error',
          message: '请选择资源节点!'
        })
        return
      } else {
        this.curSelRows1 = []
        this.curSelRows1 = this.select_radio
        this.dialogVisible1 = false
        this.sure(1)
        // if (this.curTabName1 === 'human') {
        //   console.log('处理人力字段')
        //   console.log(this.select_radio)
        // } else if (this.curTabName1 === 'meterial') {
        //   console.log('处理材料字段')
        // } else if (this.curTabName1 === 'device') {
        //   console.log('处理设备字段')
        // }
      }
    },
    handleSetResouce2() {
      this.multipleSelection = [...this.$refs.resourceSel2.$refs['human'].selResouce, ...this.$refs.resourceSel2.$refs['material'].selResouce, ...this.$refs.resourceSel2.$refs['device'].selResouce]
      console.log('*/*/*/*/', this.multipleSelection)
      var humanTmpArr = JSON.parse(JSON.stringify(this.multipleSelection))
      console.log('humanTmpArr', humanTmpArr)
      if (!this.multipleSelection || this.multipleSelection.length === 0) {
        return this.$message({
          type: 'error',
          message: '请选择资源节点!'
        })
      } else {
        this.curSelRows2 = []
        this.curSelRows2 = this.multipleSelection
        this.dialogVisible2 = false
        this.sure(2)
      }
    }
  }
}
</script>

<style>
.min-w {
  min-width: 1200px;
}
.mt-10 {
  margin-top: 10px;
}
.mt-20 {
  margin-top: 20px;
}
.ml-10 {
  margin-left: 10px;
}
.mr-10 {
  margin-right: 10px;
}
.ml-50 {
  margin-left: 50px;
}
.fl {
  float: left;
}
.fr {
  float: right;
}
.el-dialog__body {
  padding-top: 0;
}
.h_percent100{
  height:100%;
}
.h-200 {
  height: 200px;
}
.gantt_grid_data .task-grid-wbs-row-background-color,
.gantt_grid_data .task-grid-wbs-row-background-color.odd {
  background-color:#DCDFE6;
}

</style>
