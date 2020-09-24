<template>
  <div ref="pageDiv" class="clearfix">
    <el-row style="border: 1px solid #EBEEF5;padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
      <div style="float:left;">
        <span class="ml-20"> 任务名称</span>
        <el-input v-model="taskName" placeholder="" size="mini" style="width: 140px;margin-left:5px" clearable @keyup.enter.native="search" />
        <div>
          <div v-if="isManager" style="margin-top:5px;float:left">
            <span style="margin-left:35px;"> 负责人</span>
            <el-select v-model="query.managerment" size="mini" placeholder="全部" clearable style="width:140px;margin-left:5px" filterable>
              <el-option v-for="item in searchManagermentArr" :key="item.value" size="mini" :label="item.label" :value="item.value" />
            </el-select>
          </div>
        </div>
      </div>
      <div style="float:left;margin-left:20px;margin-top:-2px">
        <span>任务状态</span>
        <el-checkbox-group v-model="query.stateCheckList" size="mini" class="ml-10" style="width:265px;margin-top:-8px;display:inline-block;margin-left:5px">
          <el-checkbox v-for="state in taskArr" :key="state.title" :label="state.title" class="stateCheckBox" style="display:inline-block">{{ state.title }}</el-checkbox>
        </el-checkbox-group>
        <div style="margin-top:2px">
          <span>进度状态</span>
          <el-checkbox-group v-model="query.stateCheckList" size="mini" class="ml-10" style="width:265px;display:inline-block;margin-left:5px">
            <el-checkbox v-for="state in stateArr" :key="state.title" :label="state.title" class="stateCheckBox" style="display:inline-block">{{ state.title }}</el-checkbox>
          </el-checkbox-group>
        </div>
      </div>
      <div style="float:left;margin-left:-30px">
        <span class="demonstration">计划起止时间</span>
        <el-date-picker v-model="query.planTime" style="margin-left:5px" size="mini" type="daterange" range-separator="至" value-format="yyyy-MM-dd" />
        <div style="height:30px;margin-top:5px">
          <span class="demonstration">实际起止时间</span>
          <el-date-picker v-model="query.actualTime" style="margin-left:5px" size="mini" type="daterange" range-separator="至" value-format="yyyy-MM-dd" />
        </div>
      </div>
      <el-button type="primary" class="ml-10" style="bottom:10px;position:absolute" size="mini" @click="search">查询</el-button>
    </el-row>
    <el-row class="clearfix">
      <div style="display:inline;margin-left:20px;">
        <div class="mt-10" style="float:right;">
          <el-button type="primary" @click="screenFull()">{{ screenText }}</el-button>
          <el-button type="primary" @click="zoomIn()">放大</el-button>
          <el-button type="primary" @click="zoomOut()">缩小</el-button>
          <el-button v-if="isManager && !isProjectover && !editManagement" type="primary" @click="editMangementFunc">编辑</el-button>
          <span v-if="editManagement || isEditPlanTime" style="margin-left: 10px">
            <el-button type="primary" :loading="saveLoading" @click="saveTable">保存</el-button>
            <el-button style="margin-right: 10px" @click="cancelTable">取消</el-button>
          </span>
          <el-button v-if="isManager && !isProjectover && !editManagement" type="primary" class="mr-10" @click="importPlan">导入进度计划</el-button>
          <el-button v-if="isManager && !isProjectover && !progressWarn && false" type="primary" class="mr-10" @click="progressWarn = true">进度预警设置</el-button>
          <el-button v-if="isManager === false && !isEditPlanTime && !isProjectover" type="primary" class="mr-10" @click="editPlanTime">编辑起止时间</el-button>
        </div>
        <span v-if="editManagement" style="position:relative;top:13px">
          <el-tooltip effect="dark" content="新增根节点" placement="top">
            <el-button icon="el-icon-folder-add" size="mini" circle @click="addNode" />
          </el-tooltip>
          <el-tooltip effect="dark" content="新增子节点" placement="top">
            <el-button icon="el-icon-plus" size="mini" circle @click="addChildren" />
          </el-tooltip>
          <el-tooltip effect="dark" content="编辑" placement="top">
            <el-button icon="el-icon-edit" size="mini" circle @click="edit" />
          </el-tooltip>
          <el-tooltip effect="dark" content="删除" placement="top">
            <el-button icon="el-icon-minus" size="mini" circle @click="del" />
          </el-tooltip>
          <!-- <el-tooltip effect="dark" content="上移" placement="top">
            <el-button icon="el-icon-top" size="mini" circle @click="up" />
          </el-tooltip>
          <el-tooltip effect="dark" content="下移" placement="top">
            <el-button icon="el-icon-bottom" size="mini" circle @click="down" />
          </el-tooltip>
          <el-tooltip effect="dark" content="升级" placement="top">
            <el-button icon="el-icon-caret-top" size="mini" circle @click="upLevel" />
          </el-tooltip>
          <el-tooltip effect="dark" content="降级" placement="top">
            <el-button icon="el-icon-caret-bottom" size="mini" circle @click="downLevel" />
          </el-tooltip> -->
        </span>
      </div>
    </el-row>
    <div class="mt-10">
      <gantt
        ref="gantDiv"
        :drag-branch-free="branchFree"
        :drag-move-date="dragMoveDate"
        :drag-resize-date="dragResizeDate"
        :style="{'width':'100%','height':maxGridHeight+'px'}"
        :tasks="tasks"
        :gant-columns="tablecolumn"
        @doubleClick="doubleClick"
        @addTask="addTask"
        @clickRow="clickRow"
      />
    </div>
    <el-dialog :visible.sync="importLoading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>
    <el-dialog :visible.sync="importListVisible" width="400px" :show-close="false" title="导入进度计划" :close-on-click-modal="false">
      <el-form ref="importForm" :model="fileInfo">
        <el-form-item label="导入方式：" :rules="[{ required: true, message: '请选择导入方式',trigger:'change'}]" prop="importType">
          <el-radio v-model="fileInfo.importType" label="1">追加</el-radio>
          <el-radio v-model="fileInfo.importType" label="2">覆盖</el-radio>
        </el-form-item>
        <el-form-item label="选择文件：" class="mt-20" :rules="[{ required: true, message: '请选择导入文件',trigger:' ' }]" prop="name">
          <el-upload
            ref="uploadPlan"
            action=""
            :on-change="onChange"
            :auto-upload="false"
            :show-file-list="false"
            style="display: inline-block "
            accept=".mpp"
          >
            <div style="float:left">{{ fileInfo.name }}</div>
            <el-button slot="trigger" type="primary" size="mini" style="float:left;margin-left:10px;margin-top:3px">选择文件</el-button>
          </el-upload>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="sureChoseFile('importForm')">确定</el-button>
        <el-button type="primary" @click="cancelChoseFile">取消</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title=""
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
      width="800px"
    >
      <el-form ref="nameForm" :model="formData" :rules="isEditPlanTime?acturalRules:rules">
        <el-row v-if="editManagement" style="padding-left:50px">
          <el-col :span="12">
            <el-form-item label="任务名称：" prop="taskName" style="margin-left:18px;">
              <el-input ref="addNodeInput" v-model="formData.taskName" maxlength="20" style="width:180px" />
            </el-form-item>

            <el-form-item label="计划开始时间：" prop="planeStartTime">
              <el-date-picker
                v-model="formData.planeStartTime"
                style="width:180px"
                value-format="yyyy-MM-dd"
                :picker-options="getPickerOption('planeStartTime')"
                type="date"
              />
            </el-form-item>
            <el-form-item label="实际开始时间：" prop="actualStartTime">
              <el-date-picker
                v-model="formData.actualStartTime"
                value-format="yyyy-MM-dd"
                style="width:180px"
                :picker-options="getPickerOption('actualStartTime')"
                type="date"
              />
            </el-form-item>
            <el-form-item label="前置任务：" style="margin-left:28px;">
              <el-cascader
                v-model="formData.beforeTaskArr"
                :options="taskTreeArr"
                style="width:180px"
                :show-all-levels="false"
                clearable
                :props="{ multiple: false, checkStrictly: true }"
              />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="负责人：" style="margin-left:40px;">
              <el-select v-model="formData.managerment" collapse-tags multiple size="small" placeholder="全部" clearable style="width:180px">
                <el-option v-for="item in searchManagermentArr" :key="item.value" size="small" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
            <el-form-item label="计划结束时间：" prop="planeEndTime">
              <el-date-picker
                v-model="formData.planeEndTime"
                value-format="yyyy-MM-dd"
                style="width:180px"
                :picker-options="getPickerOption('planeEndTime')"
                type="date"
              />
            </el-form-item>
            <el-form-item label="实际结束时间：" prop="actualEndTime">
              <el-date-picker
                v-model="formData.actualEndTime"
                value-format="yyyy-MM-dd"
                style="width:180px"
                :picker-options="getPickerOption('actualEndTime')"
                type="date"
              />
            </el-form-item>
          </el-col>
        </el-row>
        <el-row v-if="isEditPlanTime" style="padding-left:50px">
          <el-col :span="12">
            <el-form-item label="任务名称：" prop="taskName" style="margin-left:18px;">
              <span>{{ formData.taskName }}</span>
            </el-form-item>

            <el-form-item label="计划开始时间：" prop="planeStartTime">
              <span>{{ formData.planeStartTime }}</span>
            </el-form-item>
            <el-form-item label="实际开始时间：" prop="actualStartTime" style="margin-left:-10px">
              <el-date-picker
                v-model="formData.actualStartTime"
                value-format="yyyy-MM-dd"
                style="width:180px"
                type="date"
                :picker-options="getPickerOption('actualStartTime')"
              />
            </el-form-item>
            <el-form-item label="前置任务：" style="margin-left:28px;">
              <span>{{ formData.beforeTask }}</span>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="负责人：" style="margin-left:40px;">
              <span>{{ formData.managermentName }}</span>
            </el-form-item>
            <el-form-item label="计划结束时间：" prop="planeEndTime">
              <span>{{ formData.planeEndTime }}</span>
            </el-form-item>
            <el-form-item label="实际结束时间：" prop="actualEndTime" style="margin-left:-10px">
              <el-date-picker
                v-model="formData.actualEndTime"
                value-format="yyyy-MM-dd"
                style="width:180px"
                type="date"
                :picker-options="getPickerOption('actualEndTime')"
              />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>

      <span slot="footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" :loading="optLoad" @click="nameSubmit">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title="进度预警设置"
      :visible.sync="progressWarn"
      center
      width="700px"
      @close="progress = false"
    >
      <el-form ref="progressWarnForm" :model="progressWarnData">
        <el-form-item label="" style="margin-left:18px;">
          晚于<span style="color:#303133">计划开始</span>时间的天数(大于此时间认为延迟)：
          <el-input-number v-model="progressWarnData.beginWarningDay" maxlength="20" style="width:180px" :min="0" />
          &nbsp;&nbsp;单位：天
        </el-form-item>
        <el-form-item label="" style="margin-left:18px;">
          晚于<span style="color:#303133">计划完成</span>时间的天数(大于此时间认为延迟)：
          <el-input-number v-model="progressWarnData.endWarningDay" maxlength="20" style="width:180px" :min="0" />
          <span>&nbsp;&nbsp;单位：天</span>

        </el-form-item>
      </el-form>

      <span slot="footer">
        <el-button @click="progressWarn = false">取 消</el-button>
        <el-button type="primary" @click="saveProgressWarn">确 定</el-button>
      </span>
    </el-dialog>

  </div>
</template>

<script>
import { importProgressPlan, getPlanList, getUserList, saveTask, savePlanList } from '@/api/progressManage'
import { addNode, updateNodeName, deleteNode, shiftUp, shiftDown, upgrade, demotion, saveProgressWarn, getProgressWarn } from '@/api/progressManage'
import Gantt from '@/components/Gantt/index.vue'
export default {
  components: {
    Gantt

  },
  props: {
    bim: {
      type: Object,
      default: function() { return {} }
    },
    isManager: {
      type: Boolean,
      default: true
    },
    maxHeight: {
      type: Number,
      default: 400
    },
    isProjectover: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      deleteArr: [],
      taskTreeArr: [],
      bLast: false,
      emptyText: '请导入进度计划',
      treeArr: [],
      loading: false,
      saveLoading: false,
      taskName: '',
      query: {
        actualTime: null,
        planTime: null,
        managerment: '',
        linkModel: '',
        stateCheckList: ['未开始', '进行中', '已完成', '提前', '正常', '延迟']
      },
      tmpQuery: {
        actualTime: null,
        planTime: null,
        managerment: '',
        linkModel: '',
        stateCheckList: ['未开始', '进行中', '已完成', '提前', '正常', '延迟']
      },
      progressPercent: 0,
      importLoading: false,
      // 导入列表框
      importListVisible: false,
      fileInfo: {
        name: '',
        importType: '1'
      },
      workStates: [{
        'title': '未开始', key: '2' }, {
        'title': '进行中', key: '3' }, {
        'title': '已完成', key: '4' }, {
        'title': '提前', key: '2' }, {
        'title': '正常', key: '3' }, {
        'title': '延迟', key: '4' }],
      taskArr: [{
        'title': '未开始', key: '2' }, {
        'title': '进行中', key: '3' }, {
        'title': '已完成', key: '4' }],
      stateArr: [{
        'title': '提前', key: '2' }, {
        'title': '正常', key: '3' }, {
        'title': '延迟', key: '4' }],
      // 负责人
      editManagement: false,
      branchFree: false,
      dragMoveDate: false,
      dragResizeDate: false,
      managermentArr: [],
      searchManagermentArr: [],
      tableData: [],
      tablecolumn: [],
      // 选择人员data
      data: [],
      connectTaskInfo: {},
      clickTaskInfo: {},
      isEditPlanTime: false,
      mapId: {},
      // 用来存储关联关系
      connectArr: [],
      screenText: '全屏',
      maxGridHeight: 400,
      tasks: {
        data: [
        ],
        links: []
      },
      optLoad: false,
      dialogVisible: false,
      editMode: '',
      formData: {
        taskName: '',
        text: '',
        status: '',
        status1: '',
        status2: '',
        planeStartTime: '',
        planeDuration: '',
        planeEndTime: '',
        actualStartTime: '',
        actualEndTime: '',
        managerment: '',
        managementName: '',
        parentId: '',
        parent: ''
      },
      rules: {
        taskName: [
          { required: true, message: '请输入任务名', tigger: ' ' }
        ]
      },
      acturalRules: {

      },
      curObj: null,
      progressWarn: false,
      progressWarnData: {
        warningDay: '',
        beginWarningDay: '',
        endWarningDay: ''
      }
    }
  },
  watch: {
    dialogVisible(v) {
      if (v) {
        var arr = []

        this.$refs.gantDiv.ganttObj.eachTask(function(task) {
          arr.push(task)
        })

        this.taskTreeArr = this.convertToTreeData(arr, '')
      } else {
        this.resetForm('nameForm')
      }
    },
    maxHeight(v) {
      this.maxGridHeight = this.maxHeight
    },
    query: {
      handler(newValue, oldValue) {
        this.getTreeList()
      },
      deep: true,
      immediate: true
    },
    isManager(v) {
      this.setTableColumn()
    },
    editManagement(v) {
      if (!v) {
        this.curObj = null
      }
    }
  },
  mounted() {
    this.setTableColumn()
    this.getMember()
    getProgressWarn({ projectId: this.$route.params.id }).then(res => {
      if (res.length > 0) {
        res.forEach(element => {
          if (element.type === '1') {
            this.progressWarnData.beginWarningDay = element.warningDay
          } else {
            this.progressWarnData.endWarningDay = element.warningDay
          }
        })
      }
    })
  },
  methods: {
    saveProgressWarn() {
      const me = this
      var requestData = []
      if (me.progressWarnData.beginWarningDay) {
        requestData.push({ warningDay: me.progressWarnData.beginWarningDay, projectId: this.$route.params.id, type: 1 })
      }
      if (me.progressWarnData.endWarningDay) {
        requestData.push({ warningDay: me.progressWarnData.endWarningDay, projectId: this.$route.params.id, type: 2 })
      }
      saveProgressWarn(requestData).then(res => {
        this.progressWarn = false
      })
    },
    convertToTreeData(data, pid) {
      const result = []
      let temp = []
      for (let i = 0; i < data.length; i++) {
        if (data[i].parentId === pid) {
          const obj = { ...data[i] }
          temp = this.convertToTreeData(data, data[i].id)
          if (temp.length > 0) {
            obj.children = temp
          }
          result.push(obj)
        }
      }
      return result
    },
    getPath(id, pathArr, findArr) {
      pathArr = JSON.parse(JSON.stringify(pathArr))
      var parentId = ''
      this.findTree(findArr, (element) => {
        if (element.id === id) {
          parentId = element.parentId
        }
      })
      if (parentId) {
        pathArr.unshift(parentId)
        pathArr = this.getPath(parentId, pathArr, findArr)
      }

      return pathArr
    },
    screenFull() {
      this.$refs.gantDiv.ganttObj.ext.fullscreen.toggle()
    },
    GenNonDuplicateID(randomLength) {
      return Number(Math.random().toString().substr(3, randomLength) + Date.now()).toString(36)
    },
    addTask({ obj, event }) {
      this.curObj = obj
      this.formData = {
        beforeTaskArr: [],
        taskName: '',
        text: '',
        status: '',
        status1: '',
        status2: '',
        start_date: '',
        end_date: '',
        planeStartTime: '',
        planeDuration: '',
        planeEndTime: '',
        actualStartTime: '',
        actualEndTime: '',
        managerment: '',
        managementName: '',
        parent: this.curObj.parent,
        parentId: this.curObj.parent
      }
      this.dialogVisible = true
      this.editMode = 'add'
    },
    zoomIn() {
      this.$refs.gantDiv.zoomIn()
    },
    zoomOut() {
      this.$refs.gantDiv.zoomOut()
    },
    doubleClick({ id, event }) {
      this.editMode = 'update'
      if (this.editManagement || this.isEditPlanTime) {
        const curTask = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
        this.formData = { ...curTask['0'], ...{}} || { }
        this.formData.taskName = this.formData.text
        this.dialogVisible = true
      }
    },

    editMangementFunc() {
      var selectId = this.$refs.gantDiv.ganttObj.getSelectedId()
      this.editManagement = !this.editManagement
      this.dragMoveDate = this.editManagement
      this.dragResizeDate = this.editManagement
      this.branchFree = this.editManagement
      setTimeout(() => {
        this.$nextTick(() => {
          if (selectId) {
            this.$refs.gantDiv.ganttObj.selectTask(selectId)
          }
        })
      }, 0)
    },
    delMidNode({ leftCurNode, data }) {
      for (let i = 0; i < this.connectArr.length; i++) {
        if (this.connectArr[i].id === leftCurNode.id) {
          for (let j = 0; j < this.connectArr[i].taskSection.length; j++) {
            if (this.connectArr[i].taskSection[j].sectionId === data.id) {
              this.connectArr[i].taskSection.splice(j, 1)
              j--
            }
          }
        }
      }
    },
    clickGridButton(id, action) {
      switch (action) {
        case 'edit':
          this.$refs.gantDiv.ganttObj.showLightbox(id)
          break
        case 'add':
          this.$refs.gantDiv.ganttObj.createTask(null, id)
          break
        case 'delete':
          this.$refs.gantDiv.ganttObj.confirm({
            title: this.$refs.gantDiv.ganttObj.locale.labels.confirm_deleting_title,
            text: this.$refs.gantDiv.ganttObj.locale.labels.confirm_deleting,
            callback: function(res) {
              if (res) { this.$refs.gantDiv.ganttObj.deleteTask(id) }
            }
          })
          break
      }
    },
    setTableColumn() {
      const me = this
      if (this.isManager) {
        this.tablecolumn = [{
          name: 'wbs',
          label: '序号',
          width: 40,
          template: this.$refs.gantDiv.ganttObj.getWBSCode,
          align: 'center'
        }, {
          label: '任务名称',
          name: 'text',
          min_width: 260,
          tree: true,
          resize: true
        },
        {
          label: '任务状态',
          name: 'state1',
          min_width: 50,
          align: 'center',
          resize: true

        }, {
          label: '进度状态',
          name: 'state2',
          min_width: 50,
          align: 'center',
          resize: true,
          template: function(obj) {
            if (obj.state2 === '延迟') {
              return ('<div style="background:red;width:50px;height:100%">') + obj.state2 + ('</div>')
            } else {
              return obj.state2
            }
          }

        }, {
          label: '负责人',
          key: 'managerment',
          name: 'managermentName',
          componetType: 'select',
          min_width: 90,
          align: 'center',
          resize: true
        }, {
          label: '前置任务',
          name: 'beforeTask',
          min_width: 90,
          align: 'center',
          resize: true,
          template: function(obj) {
            if (obj.beforeSource && me.$refs.gantDiv.ganttObj.isTaskExists(obj.beforeSource)) {
              return me.$refs.gantDiv.ganttObj.getWBSCode(me.$refs.gantDiv.ganttObj.getTask(obj.beforeSource))
            } else {
              return ''
            }
          }
        }, {
          label: '计划工期',
          name: 'duration',
          min_width: 50,
          align: 'center',
          resize: true,
          template: function(obj) {
            if (!obj.unscheduled) {
              return parseFloat(obj.duration) + 1
            } else {
              return ' '
            }
          }
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
          label: '实际工期',
          name: 'actualDuration',
          min_width: 50,
          align: 'center',
          resize: true

        }, {
          label: '实际开始时间',
          name: 'actualStartTime',
          min_width: 100,
          align: 'center',
          resize: true
        }, {
          label: '实际完成时间',
          name: 'actualEndTime',
          min_width: 100,
          align: 'center',
          resize: true
        }]
      } else {
        this.tablecolumn = [{
          name: 'wbs',
          label: '序号',
          width: 40,
          template: this.$refs.gantDiv.ganttObj.getWBSCode,
          align: 'center'
        }, {
          label: '任务名称',
          name: 'text',
          min_width: 200,
          tree: true,
          resize: true
        }, {
          label: '任务状态',
          name: 'state1',
          min_width: 50,
          align: 'center',
          resize: true
        }, {
          label: '进度状态',
          name: 'state2',
          min_width: 60,
          align: 'center',
          resize: true
        }, {
          label: '计划工期',
          name: 'duration',
          min_width: 50,
          align: 'center',
          resize: true,
          template: function(obj) {
            if (!obj.unscheduled) {
              return parseFloat(obj.duration) + 1
            } else {
              return ' '
            }
          }
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
          label: '实际工期',
          name: 'actualDuration',
          min_width: 50,
          align: 'center',
          resize: true
        }, {
          label: '实际开始时间',
          name: 'actualStartTime',
          componetType: 'selectTime',
          required: true,
          min_width: 100,
          align: 'center',
          resize: true
        }, {
          label: '实际完成时间',
          name: 'actualEndTime',
          componetType: 'selectTime',
          min_width: 100,
          align: 'center',
          resize: true
        }]
      }
    },
    getPickerOption(flag) {
      const self = this
      return {
        disabledDate(time) {
          if (flag === 'actualStartTime') {
            if (self.formData.actualEndTime) {
              return new Date(self.formData.actualEndTime).getTime() < time.getTime()
            } else {
              // return time.getTime() <= new Date().getTime() - (1000 * 60 * 60 * 24)
            }
          } else if (flag === 'actualEndTime') {
            if (self.formData.actualStartTime) {
              return (new Date(self.formData.actualStartTime).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
            }
          } else if (flag === 'planeStartTime') {
            if (self.formData.planeEndTime) {
              return new Date(self.formData.planeEndTime).getTime() < time.getTime()
            } else {
              // return time.getTime() <= new Date().getTime() - (1000 * 60 * 60 * 24)
            }
          } else if (flag === 'planeEndTime') {
            if (self.formData.planeStartTime) {
              return (new Date(self.formData.planeStartTime).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
            }
          }
          // return time
        }
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
    editPlanTime() {
      if (this.tableData.length === 0) {
        this.$alert('请导入进度计划')
        return
      }
      this.isEditPlanTime = true
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
      if (JSON.stringify(this.query) === JSON.stringify(this.tmpQuery) && (!this.taskName.trim())) {
        this.emptyText = '请导入进度计划'
      } else {
        this.emptyText = '暂无数据'
      }
      var state1 = []
      var state2 = []
      this.query.stateCheckList.forEach(item => {
        this.workStates.forEach(element => {
          if (item === element.title) {
            if (item === '未开始' || item === '进行中' || item === '已完成') {
              state1.push(element.key)
            } else if (item === '提前' || item === '正常' || item === '延迟') {
              state2.push(element.key)
            }
          }
        })
      })
      var [LPlaneStartTime, RPlaneStartTime, LActualStartTime, RActualStartTime] = ['', '', '', '']
      if (this.query.planTime && this.query.planTime.length === 2) {
        LPlaneStartTime = this.query.planTime[0]
        RPlaneStartTime = this.query.planTime[1]
      }
      if (this.query.actualTime && this.query.actualTime.length === 2) {
        LActualStartTime = this.query.actualTime[0]
        RActualStartTime = this.query.actualTime[1]
      }
      var requestData = {
        projectId: this.$route.params.id,
        taskName: this.taskName ? this.taskName.trim() : '',
        managerment: this.query.managerment,
        linkModel: this.query.linkModel,
        'state1': state1,
        'state2': state2,
        LPlaneStartTime: LPlaneStartTime,
        RPlaneStartTime: RPlaneStartTime,
        LActualStartTime: LActualStartTime,
        RActualStartTime: RActualStartTime
      }
      if (this.$route.query.look) {
        requestData.warnState = '1'
      }
      this.loading = true
      getPlanList(requestData).then(res => {
        this.loading = false
        this.mapId = {}
        this.treeArr = []
        this.beforeTaskArr = []
        this.deleteArr = []
        if (res) {
          this.findTree(res, (item) => {
            this.findTree(res, newItem => {
              if (item.beforeTask === newItem.serialNumber) {
                item.beforeSource = newItem.id
                item.beforeTaskArr = this.getPath(item.beforeSource, [], res)
                item.beforeTaskArr.push(item.beforeSource)
              }
            })

            if (!item.parentId) {
              item.parentId = ''
            }
            item.label = item.taskName
            item.value = item.id
            item.parent = item.parentId || ''
            item.text = item.taskName
            if (item.planeStartTime && item.planeEndTime) {
              item.progress = 100
              item.start_date = item.planeStartTime.split('-')[2] + '-' + item.planeStartTime.split('-')[1] + '-' + item.planeStartTime.split('-')[0]
              item.end_date = item.planeEndTime.split('-')[2] + '-' + item.planeEndTime.split('-')[1] + '-' + item.planeEndTime.split('-')[0]
            } else {
              item.start_date = ''
              item.end_date = ''
              item.duration = '0'
              item.unscheduled = true
            }
            if (item.id === this.clickTaskInfo.id) {
              this.clickTaskInfo = item
            }
            if (item.managerment) {
              item.managerment = item.managerment.split(',')
            } else {
              item.managerment = []
            }
            this.treeArr.push(item)

            if (item.taskModel && item.taskModel.figureId) {
              var arr = item.taskModel.figureId.split(',')
              arr.forEach(id => {
                var bHas = false
                for (var key in this.mapId) {
                  if (key === id) {
                    bHas = true
                    this.mapId[id] = this.mapId[id] + ',' + item.state
                  }
                }
                if (!bHas) {
                  this.mapId[id] = item.state
                }
              })
            }
            if (item.state2.indexOf('延迟') > -1) {
              item.bgcolor = 'red'
              item.color = 'red'
            }
          })
          this.tableData = JSON.parse(JSON.stringify(res))
          var linkArr = []
          this.treeArr.forEach(item => {
            var source = this.getIdByBeforeTask(item.beforeTask)
            item.beforeTaskId = source
            linkArr.push({ id: item.id, source: source, target: item.id, type: '0' })
          })
          this.maxGridHeight = this.maxHeight
          this.tasks.data = this.treeArr
          this.tasks.links = linkArr
          this.tasks = JSON.Parse(JSON.stringify(this.tasks))
        } else {
          this.maxGridHeight = 100
          this.tableData = []
          this.tasks.data = []
          this.tasks = JSON.Parse(JSON.stringify(this.tasks))
        }
      }
      ).catch(() => {
        this.loading = false
      }).finally(() => {
        if (this.curObj) {
          this.$refs.gantDiv.ganttObj.selectTask(this.curObj.id)
        }
      })
    },
    getIdByBeforeTask(beforeTask) {
      for (let i = 0; i < this.treeArr.length; i++) {
        if (this.treeArr[i].serialNumber === beforeTask) {
          return this.treeArr[i].id
        }
      }
    },
    getIdByTaskNum(arr, taskNum) {
      for (let i = 0; i < arr.length; i++) {
        if (arr[i].serialNumber === taskNum) {
          return arr[i].id
        }
        if (arr[i].children) {
          this.getIdByTaskNum(arr[i].children, taskNum)
        }
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
      } else if (this.tablecolumn[index].value === 'managerment') {
        return 100
      } else if ((this.tablecolumn[index].value === 'planeEndTime' || this.tablecolumn[index].value === 'planeStartTime') && this.isEditPlanTime) {
        return 75
      } else if ((this.tablecolumn[index].value === 'actualEndTime' || this.tablecolumn[index].value === 'actualStartTime') && this.isEditPlanTime) {
        return 120
      } else {
        return 60
      }
    },
    getBeforeTaskById(id, arr) {
      var num = ''
      arr.forEach(element => {
        if (element.id === id) {
          num = element.serialNumber
        }
      })
      return num
    },
    saveTable() {
      var arrList = []
      var isValid = false
      var requireCol = ''
      var i = 0
      this.$refs.gantDiv.ganttObj.eachTask(function(task) {
        i = i + 1
        var itemNode = task
        itemNode.serialNumber = i
        if (!itemNode.actualStartTime && itemNode.actualEndTime) {
          this.$alert('请选择任务序号为【' + itemNode.serialNumber + '】的实际开始时间',)
          if (!requireCol) {
            requireCol = itemNode.serialNumber
          } else {
            requireCol = requireCol + '、' + itemNode.serialNumber
          }
          isValid = true
          return
        }
        var tmpObj = { id: itemNode.id,
          managerment: itemNode.managerment ? itemNode.managerment.join(',') : '',
          managermentName: itemNode.managermentName,
          actualDuration: itemNode.actualDuration,
          actualStartTime: itemNode.actualStartTime,
          actualEndTime: itemNode.actualEndTime
        }
        tmpObj = { ...itemNode, ...tmpObj }
        if (tmpObj.actualDuration === '') {
          delete tmpObj.actualDuration
        }
        if (tmpObj.planeDuration === '') {
          delete tmpObj.planeDuration
        }
        arrList.push(tmpObj)
      })
      if (isValid) {
        this.$alert('请填写第' + requireCol + '行【实际开始时间】')
        return
      }
      arrList.forEach(element => {
        if (element.beforeTaskArr && element.beforeTaskArr.length > 0) {
          element.beforeTask = this.getBeforeTaskById(element.beforeTaskArr[element.beforeTaskArr.length - 1], arrList)
        } else {
          if (element.hasOwnProperty('beforeTask')) {
            delete element.beforeTask
          }
        }
      })
      this.saveLoading = true
      if (this.isManager) {
        saveTask({ saveList: arrList, deleteList: this.deleteArr }).then(res => {
          if (this.isManager) {
            this.editMangementFunc()
          } else {
            this.isEditPlanTime = false
          }
          this.getTreeList()
        }).catch(() => {
        }).finally(() => {
          this.saveLoading = false
        })
      } else {
        savePlanList(arrList).then(res => {
          if (this.isManager) {
            this.editManagement = false
          } else {
            this.isEditPlanTime = false
          }
          this.getTreeList()
        }).catch(() => {
        }).finally(() => {
          this.saveLoading = false
        })
      }
    },
    cancelTable() {
      if (this.isManager) {
        this.editMangementFunc()
      } else {
        this.isEditPlanTime = false
      }
      this.treeArr = []
      this.findTree(this.tableData, (item) => {
        this.treeArr.push(item)
      })
      var linkArr = []
      this.treeArr.forEach(item => {
        var source = this.getIdByBeforeTask(item.beforeTask)
        item.beforeTaskId = source
        linkArr.push({ id: item.id, source: source, target: item.id, type: '0' })
      })
      this.tasks.data = this.treeArr
      this.tasks.links = linkArr
    },
    sureChoseFile(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          if (this.fileInfo.name.substring(this.fileInfo.name.length - 3, this.fileInfo.name.length) !== 'mpp') {
            this.$alert('导入格式不对')
            return
          }
          this.importListVisible = false
          this.progressPercent = 0
          this.importLoading = true
          const formFile = new FormData()
          formFile.append('file', this.fileInfo.raw)
          formFile.append('projectId', this.$route.params.id)
          formFile.append('type', this.fileInfo.importType)
          var onUploadProgress = progressEvent => {
            var complete = (progressEvent.loaded / progressEvent.total * 100 | 0)
            this.progressPercent = complete
          }
          importProgressPlan(formFile, onUploadProgress).then(res => {
            this.resetFileInfo()
            this.importLoading = false
            if (res && (res.data || res.istemplent || res.isexcel || res.isdata)) {
              let message = ''
              if (res.data) {
                res.data.forEach(item => {
                  message += item + '<br/>'
                })
              }
              this.$alert(message, '导入错误', {
                confirmButtonText: '确定',
                dangerouslyUseHTMLString: true
              })
            } else {
              this.$message({
                type: 'success',
                message: '导入成功!'
              })
              this.getTreeList()
            }
          }).catch(() => {
            this.resetFileInfo()
            this.importLoading = false
          })
        } else {
          return
        }
      })
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
    cancelChoseFile() {
      this.importListVisible = false
      this.resetFileInfo()
      this.resetForm('importForm')
    },
    resetFileInfo() {
      this.fileInfo = { importType: '1' }
    },
    // 导入进度计划
    importPlan() {
      this.importListVisible = true
    },
    // 导入mpp文件
    onChange(file) {
      this.fileInfo = { ...this.fileInfo, ...file }
    },
    getMember() {
      var dict = {
        'projectId': this.$route.params.id,
        'member': 'XMCY'
      }
      getUserList(dict).then(res => {
        this.managermentArr = []
        if (!res) return
        res.forEach(element => {
          this.managermentArr.push({
            label: element.userName,
            value: element.id
          })
        })
      })
      const searchDict = {
        'projectId': this.$route.params.id
      }
      this.searchManagermentArr = []
      getUserList(searchDict).then(res => {
        this.searchManagermentArr = []
        if (!res) return
        res.forEach(element => {
          this.searchManagermentArr.push({
            label: element.userName,
            value: element.id
          })
        })
      })
    },
    search() {
      this.getTreeList()
    },
    addNode() {
      this.addTask({ obj: { parent: '' }})
    },
    clickRow({ id, row }) {
      if (this.editManagement) {
        const curTask = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
        this.curObj = curTask['0'] || { }
        this.curObj.taskName = this.formData.text
        this.formData = { ...this.curObj, ...{}}
      }
    },
    addChildren() {
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      const me = this
      this.addTask({ obj: { parent: me.curObj.id }})
    },
    edit() {
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      this.doubleClick({ id: this.curObj.id })
    },
    setNodeInput(dialogMode) {
      this.dialogVisible = true
      this.dialogMode = dialogMode
      this.$nextTick(() => {
        this.$refs.addNodeInput.focus()
      })
    },
    eachArr(arr, v) {
      arr.forEach((item) => {
        if (item.data) {
          v.push(item.id)
        }
        if (item.children.length > 0) {
          this.eachArr(item.children, v)
        }
        if (item.leafChildren && item.leafChildren.length > 0) {
          this.eachArr(item.leafChildren, v)
        }
      })
    },
    filter(data, id) {
      var newData = data.filter(x => x.id !== id)
      newData.forEach(x => x.children && (x.children = this.filter(x.children, id)))
      return newData
    },
    del() {
      var selectId = this.$refs.gantDiv.ganttObj.getSelectedId()
      var userTasks = this.$refs.gantDiv.ganttObj.getTaskBy('id', selectId)
      this.curObj = userTasks[0]
      if (this.curObj) {
        this.$confirm(`确定要删除该节点么?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          dangerouslyUseHTMLString: true
        }).then(() => {
          // 首先遍历一下  把存在的link和任务中的的beforeSOurce 删除 否则getTask(id)报错
          // var links = this.$refs.gantDiv.ganttObj.getLinks()
          // links.forEach(element => {
          //   if (element.source === this.curObj.id || element.target === this.curObj.id) {
          //     this.$refs.gantDiv.ganttObj.deleteLink(element.id)
          //   }
          // })
          var me = this
          this.$refs.gantDiv.ganttObj.eachTask(function(task) {
            if (task.beforeSource === me.curObj.id) {
              delete task.beforeSource
              // this.$refs.gantDiv.ganttObj.getTask(me.curObj.id)['beforeSource'] = ''
              // this.$refs.gantDiv.ganttObj.updateTask(me.curObj.id)
            }
          })
          this.deleteArr.push(selectId)
          this.$refs.gantDiv.ganttObj.unselectTask(this.curObj.id)
          this.$refs.gantDiv.ganttObj.deleteTask(this.curObj.id)
          this.curObj = null
        }).catch(() => {
        })
      } else {
        this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
    },
    getParentNode() {

    },
    up() {
      if (this.bShowLoad) {
        return
      }
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('shiftUp')
      }
    },
    down() {
      if (this.bShowLoad) {
        return
      }
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('shiftDown')
      }
    },
    upLevel() {
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('upgrade')
      }
    },
    downLevel() {
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        var upNode = null
        var isExit = false
        this.findTree(this.tableData, element => {
          if (element.id === this.curObj.parentId) {
            isExit = true
            const children = element.children
            for (var i = 0; i < children.length; i++) {
              if (children[i].id === this.curObj.id) {
                if (i > 0) {
                  upNode = children[i - 1]
                }
              }
            }
          }
        })
        if (!isExit) {
          for (var j = 0; j < this.tableData.length; j++) {
            if (this.tableData[j].id === this.curObj.id) {
              if (j > 0) {
                upNode = this.tableData[j - 1]
              }
            }
          }
        }
        if (upNode && upNode.modelRelationList && upNode.modelRelationList.length > 0) {
          this.$alert('此流水段的上级节点已关联模型，如需调整层级关系，请在模型浏览页面中【取消关联】模型')
          return
        }
        this.optData('demotion')
      }
    },
    // type 操作类型 isOriginParent是否为祖先节点
    optData(type) {
      this.optLoad = true
      var requestData = {}
      if (type === 'addNode' || type === 'addChild') {
        if (type === 'addNode') {
          requestData = { projectId: this.$route.params.id, sectionName: this.form.label, parentId: '-1', sort: this.tableData.length + 1, leafNode: 1, addNode: 0 }
        } else if (type === 'addChild') {
          requestData = { projectId: this.$route.params.id, sectionName: this.form.label, parentId: this.curObj.id, sort: this.curObj.children ? this.curObj.children.length + 1 : 1, leafNode: 1, addNode: 1, path: this.curObj.path }
        }
        addNode(requestData).then(res => {
          this.dialogVisible = false
          this.form = { label: '' }
          this.optNodeOver()
        })
      } else if (type === 'edit') {
        requestData = { id: this.curObj.id, sectionName: this.form.label }
        updateNodeName(requestData).then(res => {
          this.form = { label: '' }
          this.optNodeOver()
        })
      } else if (type === 'del') {
        requestData = { sectionName: this.form.label, id: this.curObj.id, parentId: this.curObj.parentId, projectId: this.$route.params.id }
        deleteNode(requestData).then(res => {
          this.dialogVisible = false
          this.getList()
          this.form = { label: '' }
          this.curObj = null
          this.optLoad = false
        })
      } else if (type === 'shiftUp') {
        requestData = { id: this.curObj.id }
        shiftUp(requestData).then(res => {
          this.optNodeOver()
        })
      } else if (type === 'shiftDown') {
        requestData = { id: this.curObj.id }
        shiftDown(requestData).then(res => {
          this.optNodeOver()
        })
      } else if (type === 'upgrade') {
        requestData = { id: this.curObj.id }
        upgrade(requestData).then(res => {
          this.optNodeOver()
        })
      } else if (type === 'demotion') {
        requestData = { id: this.curObj.id }
        demotion(requestData).then(res => {
          this.optNodeOver()
        })
      }
    },
    optNodeOver() {
      this.optLoad = false
      this.dialogVisible = false
      this.getList(() => {
        this.$nextTick(() => {
          if (!this.curObj) {
            return
          }
          // 直接设置this.curObj无法设置上
          this.findTree(this.tableData, element => {
            if (element.id === this.curObj.id) {
              this.curObj = element
              this.$refs.treeTable.setCurrentRow(element)
            }
          })
        })
      })
    },
    nameSubmit() {
      this.$refs.nameForm.validate((valid) => {
        if (valid) {
          this.formData = { ...this.formData }
          this.formData.text = this.formData.taskName
          this.formData.label = this.formData.taskName
          if (this.formData.planeStartTime && this.formData.planeEndTime) {
            this.formData.progress = 100
            var a = this.formData.planeStartTime.split('-')[2] + '-' + this.formData.planeStartTime.split('-')[1] + '-' + this.formData.planeStartTime.split('-')[0]
            this.formData.start_date = a
            this.formData.end_date = this.formData.planeEndTime.split('-')[2] + '-' + this.formData.planeEndTime.split('-')[1] + '-' + this.formData.planeEndTime.split('-')[0]
            this.formData.unscheduled = false
          } else {
            this.formData.unscheduled = true
            this.formData.duration = ' '
          }
          var managermentName = ''
          if (this.formData.managerment) {
            this.formData.managerment.forEach(userId => {
              this.searchManagermentArr.forEach(userObj => {
                if (userObj.value === userId) {
                  if (managermentName === '') {
                    managermentName = userObj.label
                  } else {
                    managermentName = managermentName + ',' + userObj.label
                  }
                }
              })
            })
            this.formData.managermentName = managermentName
          }
          if (this.formData.beforeTaskArr && this.formData.beforeTaskArr.length > 0) {
            this.formData.beforeSource = this.formData.beforeTaskArr[ this.formData.beforeTaskArr.length - 1]
          } else {
            this.formData.beforeSource = ''
          }
          var curLink = this.$refs.gantDiv.ganttObj.getLink(this.formData.id)
          if (curLink) {
            curLink.source = this.formData.beforeSource // changes link's data
            this.$refs.gantDiv.ganttObj.updateLink(this.formData.id)
          }
          if (this.formData.planeStartTime && this.formData.planeEndTime) {
            this.formData.planeDuration = this.DateMinus(this.formData.planeStartTime, this.formData.planeEndTime)
          }
          if (this.formData.actualStartTime && this.formData.actualEndTime) {
            this.formData.actualDuration = this.DateMinus(this.formData.actualStartTime, this.formData.actualEndTime)
          } else {
            this.formData.actualDuration = ''
          }
          if (this.editMode === 'add') {
            this.formData.projectId = this.$route.params.id
            this.formData.parentId = this.formData.parent || ''
            this.formData.id = this.GenNonDuplicateID(20)
            this.formData.value = this.formData.id
            this.formData.taskName = this.formData.text
            this.$refs.gantDiv.ganttObj.addTask(this.formData, this.formData.parentId, 0)
          } else {
            for (var key in this.formData) {
              if (key !== 'id') {
                if (key === 'start_date') {
                  if (this.formData.planeStartTime) {
                    this.$refs.gantDiv.ganttObj.getTask(this.formData.id)[key] = new Date(this.formData.planeStartTime)
                  }
                } else if (key === 'end_date') {
                  if (this.formData.planeEndTime) {
                    this.$refs.gantDiv.ganttObj.getTask(this.formData.id)[key] = new Date(this.formData.planeEndTime)
                  }
                } else {
                  this.$refs.gantDiv.ganttObj.getTask(this.formData.id)[key] = this.formData[key]
                  this.$refs.gantDiv.ganttObj.updateTask(this.formData.id)
                }
              }
            }
          }
          this.dialogVisible = false
        }
      })
    }

  }

}
</script>

<style lang="scss" scoped>
app-container{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 0
}
.upContainer {
  height: 50%;
}
.downContainer {
  height: 70%;
}
.el-icon-arrow-down {
  font-size: 10px;
}
.ml-10 {
  margin-left:10px;
}
.mr-10 {
  margin-right:20px;
}
.mr-20 {
  margin-right:20px;
}
.ml-20 {
  margin-left:20px;
}
.mt-10{
  margin-top:10px;
}
.mt-20{
  margin-top:20px;
}

.stateCheckBox{
  width:45px;
  margin-top:15px;
}
.textCenter{
  position: absolute;
  top: 25%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #808080;
}
.el-checkbox{
  display: block;
  font-weight:normal;
}
.font-14{
  font-size: 14px;
}
.el-date-editor.el-input {
    width: 140px;
}
/deep/ .el-checkbox__label{
  font-weight:normal;
}
/deep/ table th.must div:before  {
			content: '*';
			color: #ff1818;

}
/deep/ table th.must{
	text-align: center;
  font-size:13px;

}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
/deep/ .justcenter{
  text-align: center;
}
/deep/ .el-checkbox__label{
  line-height: 16px
}
 /deep/ .el-table td.redBgColor{
  background: red;
  text-align: center;
}

</style>
