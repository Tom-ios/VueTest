<template>
  <div ref="pageDiv" class="clearfix" style="position:relative">
    <div class="mt-10">
      <gantt
        ref="gantDiv"
        :drag-branch-free="false"
        :drag-move-date="false"
        :drag-resize-date="false"
        :style="{'width':'100%','height':maxGridHeight+'px'}"
        :tasks="tasks"
        :gant-columns="tablecolumn"
        :with-out-gant="withOutGant"
        @clickRow="clickGanttGridRow"
        @doubleClick="doubleClickGanttGrid"
      />
      <div v-if="showDetail" ref="rightDetail" :style="{'position':'absolute','width':rightWidth+'px','background':'white','top':'1px','right':'1px','bottom':'1px','padding-left':'5px','padding-right':'20px'}">
        <el-row style="margin-top:10px">
          <span v-if="isOpenEdit&&currentObj && currentObj.operate">
            <label style="font-size:14px;color:#606266;">作业类型：</label>
            <el-select v-model="taskForm.data.taskType" :disabled="editMode === 'detail' || taskForm.data.deleteFlag === '1'" size="small" placeholder="请选择" style="width:20%;" @change="handleTaskTypeChang">
              <el-option v-for="item in taskTypeComboxOptions" :key="item.dictCode" size="small" :label="item.name" :value="item.dictCode" />
            </el-select>
          </span>
          <el-tabs id="tabGroup" ref="tabGroup" v-model="activeName">
            <el-tab-pane v-if="isOpenEdit &&currentObj&& currentObj.operate" label="基本信息" name="first">
              <span v-if="taskForm.data.id &&( currentObj && currentObj.taskMold==='1')">
                <el-form ref="taskForm" :model="taskForm.data" class="form-wrap" label-width="45%" size="small" label-suffix="" :required="true" :rules="taskForm.rules">
                  <el-row class="edit-row" :gutter="0">
                    <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                      <el-form-item label="作业名称：" prop="wbsName">
                        <template v-if="editMode === 'detail'">
                          {{ taskForm.data.wbsName }}
                        </template>
                        <el-input v-else v-model.trim="taskForm.data.wbsName" maxlength="20" style="width:95%;" />
                      </el-form-item>
                    </el-col>
                    <template v-if="taskForm.data.taskType === '1'">
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item label="负责人：" :prop="editMode === 'detail' ? '' : 'principalName'">

                          <div class="el-input el-input--small" @click="taskForm.selVisible = true">
                            <el-input v-model="taskForm.data.principalName" readonly size="small" placeholder="请选择" style="width:95%;" />
                          </div>
                        </el-form-item>
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item label="计算方式：" :prop="editMode === 'detail' ? '' : 'scheCalcType'">
                          <el-select v-model="taskForm.data.scheCalcType" :disabled="editMode === 'detail'" size="small" placeholder="请选择" style="width:95%;">
                            <el-option v-for="item in scheCalcTypeComboxOptions" :key="item.dictCode" :disabled="item.dictCode === '02'" size="small" :label="item.name" :value="item.dictCode" />
                          </el-select>
                        </el-form-item>
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item label="权值：" :prop="editMode === 'detail' ? '' : 'weightValue'">
                          <div class="el-input el-input--small">
                            <el-input-number v-model="taskForm.data.weightValue" controls-position="right" step-strictly :min="1" :max="5" size="small" style="width:95%;" />
                          </div>
                        </el-form-item>
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <!-- <div align="center"> -->
                        <div class="el-form-item  el-form-item--small">
                          <div class=" el-form-item__content" align="center">
                            <div class="el-input el-input--small">
                              <el-radio-group v-model="taskForm.data.setType" style="width:95%;" @change="handleDateTypeRadioChange">
                                <el-radio :label="1">手动设置时间</el-radio>
                                <el-radio :label="0">自动计算时间</el-radio>
                              </el-radio-group>
                            </div>
                          </div>
                        </div>
                      <!-- </div> -->
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item label="计划开始时间：" prop="planStartDate">
                          <el-date-picker
                            v-model="taskForm.data.planStartDate"
                            style="width:95%;"
                            value-format="yyyy-MM-dd"
                            type="date"
                            :picker-options="pickerOptions('planStartDate')"
                            :disabled="taskForm.data.setType === 0"
                            @change="getTaskDuration"
                          />
                        </el-form-item>
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">

                        <el-form-item label="计划工期" prop="planDuration">
                          <template v-if="editMode === 'detail'">
                            {{ taskForm.data.planDuration }}
                          </template>
                          <!-- <span>{{ taskForm.data.planDuration }}</span> -->
                          <template v-else-if="taskForm.data.setType === 1">
                            {{ taskForm.data.planDuration }}
                          </template>
                          <el-input v-else v-model.number="taskForm.data.planDuration" style="width:95%;" @input="handleDurationCalendarChange" />
                        </el-form-item>
                      </el-col>

                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item label="计划结束时间：" prop="planEndDate">
                          <el-date-picker
                            v-model="taskForm.data.planEndDate"
                            style="width:95%;"
                            value-format="yyyy-MM-dd"
                            type="date"
                            :picker-options="pickerOptions('planEndDate')"
                            :disabled="taskForm.data.setType === 0"
                            @change="getTaskDuration"
                          />
                        </el-form-item>

                      </el-col>
                    </template>
                    <template v-else>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item
                          label="计划时间："
                          prop="planDate"
                          :rules="[
                            { required: true, message: '请选择计划日期'}
                          ]"
                        >
                          <el-date-picker
                            v-model="taskForm.data.planDate"
                            style="width:95%;"
                            value-format="yyyy-MM-dd"
                            type="date"
                            :picker-options="pickerOptions('planStartDate')"
                          />
                        </el-form-item>
                      </el-col>
                    </template>
                  </el-row>
                </el-form>
              </span>
              <div v-else style="text-align:center;margin-top:200px">请选择作业</div>
            </el-tab-pane>
            <el-tab-pane v-if="currentObj && taskForm.data.taskType === '1'" label="逻辑关系" :name="!(isOpenEdit &&currentObj&& currentObj.operate)?'first':'second'">
              <div v-if="taskForm.data.id && currentObj.taskType === '1'" class="table-wrap edit-table">
                <div class="table-header clearfix">
                  <div class="buttons-right" style="margin-bottom:15px;">
                    <el-button v-if="(editMode !== 'detail') && isOpenEdit &&currentObj&& currentObj.operate" type="primary" size="mini" @click="logicGridAddRow">新增
                    </el-button>
                  </div>
                </div>
                <el-form ref="logicTableForm" :model="logicGridForm">
                  <el-table
                    v-loading="logicGridForm.loading"
                    :data="logicGridForm.data"
                    row-key="id"
                    size="mini"
                    style="width: 100%;overflow-y:scroll"
                    border
                    :height="maxGridHeight-145"
                  >
                    <el-table-column label="序号" type="index" width="50" />
                    <el-table-column prop="taskPreCode" label="作业编码">
                      <template slot-scope="scope">
                        {{ scope.row.taskPreCode }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="taskPreName" label="作业名称">
                      <template slot-scope="scope">
                        {{ scope.row.taskPreName }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="relationshipId" label="关系类型" :label-class-name="isOpenEdit&&currentObj && currentObj.operate?'require':''">
                      <template slot-scope="scope">
                        <el-form-item
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.relationshipId'"
                          :rules="[{ required: true, message: '关系类型不能为空'}]"
                        >
                          <el-select
                            v-if=" isOpenEdit&&currentObj && currentObj.operate"
                            v-model="scope.row.relationshipId"
                            :disabled="editMode === 'detail'"
                            size="mini"
                            placeholder=""
                            default-first-option
                          >
                            <el-option v-for="item in relationshipComboxOptions" :key="item.dictCode" :disabled="item.dictCode === '3'" size="small" :label="item.name" :value="item.dictCode" />
                          </el-select>
                          <span v-else>{{ scope.row.relationshipName }}</span>
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column prop="intervalDays" label="延时（天）">
                      <template slot-scope="scope">
                        <template v-if="editMode === 'detail' || !(isOpenEdit &&currentObj && currentObj.operate) ">
                          {{ scope.row.intervalDays }}
                        </template>
                        <el-form-item
                          v-else
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.intervalDays'"
                        >
                          <el-input
                            v-model.number="scope.row.intervalDays"
                            size="mini"
                            placeholder="请输入延时天数"
                            oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                          />
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column v-if="editMode !== 'detail' && (isOpenEdi&&currentObj && currentObj.operate) " prop="type" label="操作">
                      <template slot-scope="scope">
                        <el-button icon="el-icon-delete" size="mini" type="danger" @click="logicGridRowDelete(scope.$index)">删除</el-button>
                      </template>
                    </el-table-column>
                  </el-table>
                </el-form>
              </div>
              <div v-else style="text-align:center;margin-top:200px">请选择作业</div>
              <el-dialog
                title="选择作业"
                append-to-body
                :close-on-click-modal="false"
                :visible.sync="showSelectTaskDialog"
                @close="handleSelectTaskDialogClose"
              >
                <div style="height:350px;position:relative;">
                  <TaskTreeGridView :task-tree-data="taskTreeData" :current-task="taskForm.data" :logic-grid-data="logicGridForm.data" @multiple-selection="taskMultipleSelectionMethod" />
                </div>
                <span slot="footer">
                  <el-button type="default" size="mini" @click="handleSelectTaskDialogClose">取消</el-button>
                  <el-button type="primary" size="mini" @click="handleSelectTask">确定</el-button>
                </span>
              </el-dialog>

            </el-tab-pane>
            <el-tab-pane v-if="currentObj && taskForm.data.taskType === '1'" label="资源" :name="!(isOpenEdit && currentObj.operate)?'second':'third'">
              <div v-if="taskForm.data.id && currentObj.taskType === '1'" class="table-wrap edit-table">
                <div class="table-header clearfix">
                  <div class="buttons-right" style="margin-bottom:15px;">
                    <el-button v-if="editMode !== 'detail' && isOpenEdit && currentObj.operate" type="primary" size="mini" @click="resourceGridAddRow">新增
                    </el-button>
                  </div>
                </div>
                <el-form ref="resourceTableForm" :model="resourceGridForm">
                  <el-table
                    v-loading="resourceGridForm.loading"
                    :data="resourceGridForm.data"
                    row-key="id"
                    style="overflow-y:scroll"
                    :height="maxGridHeight-145"
                    :row-style="{height:'15px'}"
                    :cell-style="{padding:'2px'}"
                    size="mini"
                    border
                  >
                    <el-table-column label="序号" type="index" width="50" />
                    <el-table-column prop="resCode" label="资源代码">
                      <template slot-scope="scope">
                        {{ scope.row.resCode }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="resName" label="资源名称">
                      <template slot-scope="scope">
                        {{ scope.row.resName }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="resTypeName" label="资源类型">
                      <template slot-scope="scope">
                        {{ scope.row.resTypeName }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="resModel" label="规格型号">
                      <template slot-scope="scope">
                        {{ scope.row.resModel }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="unitEstimate" label="计量单位">
                      <template slot-scope="scope">
                        {{ scope.row.unitEstimate }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="unitPrice" label="单价（元）" :label-class-name="isOpenEdit && currentObj.operate?'require':''" width="120">
                      <template slot-scope="scope">
                        <template v-if="editMode === 'detail' || !(isOpenEdit && currentObj.operate)">
                          {{ scope.row.unitPrice }}
                        </template>
                        <el-form-item
                          v-else
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.unitPrice'"
                          :rules="priceRule"
                        >
                          <el-input v-model="scope.row.unitPrice" size="mini" placeholder="请输入内容" />
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column prop="amount" label="数量" :label-class-name="isOpenEdit && currentObj.operate?'require':''" width="120">
                      <template slot-scope="scope">
                        <template v-if="editMode === 'detail' || !(isOpenEdit && currentObj.operate)">
                          {{ scope.row.amount }}
                        </template>
                        <el-form-item
                          v-else
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.amount'"
                          :rules="amountRule"
                        >
                          <el-input v-model.number="scope.row.amount" size="mini" placeholder="请输入内容" />
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column prop="startDate" label="开始日期" :label-class-name="isOpenEdit && currentObj.operate?'require':''" min-width="180">
                      <template slot-scope="scope">
                        <el-form-item
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.startDate'"
                          :rules="[{ required: true, message: '请选择开始日期'}]"
                        >
                          <el-date-picker
                            v-if="isOpenEdit && currentObj.operate"
                            v-model="scope.row.startDate"
                            :readonly="editMode === 'detail'"
                            value-format="yyyy-MM-dd"
                            :picker-options="pickerOptions('resourceGridRowBeginDate',scope.row.endDate)"
                            type="date"
                          />
                          <span v-else>
                            {{ scope.row.startDate }}
                          </span>
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column prop="endDate" label="结束日期" :label-class-name="isOpenEdit && currentObj.operate?'require':''" min-width="180">
                      <template slot-scope="scope">
                        <el-form-item
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.endDate'"
                          :rules="[{ required: true, message: '请选择结束日期'}]"
                        >
                          <el-date-picker
                            v-if="isOpenEdit && currentObj.operate"
                            v-model="scope.row.endDate"
                            :readonly="editMode === 'detail'"
                            value-format="yyyy-MM-dd"
                            :picker-options="pickerOptions('resourceGridRowEndDate',scope.row.startDate)"
                            type="date"
                          />
                          <span v-else>
                            {{ scope.row.endDate }}
                          </span>
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <!-- <el-table-column prop="expCost" label="预计费用">
                      <template slot-scope="scope"> -->
                    <!-- {{ scope.row.expCost }} -->
                    <!-- {{ scope.row.unitPrice * scope.row.amount }}
                      </template>
                    </el-table-column> -->
                    <el-table-column v-if="editMode !== 'detail' && (isOpenEdit && currentObj.operate)" label="操作" width="120">
                      <template slot-scope="scope">
                        <el-button icon="el-icon-delete" type="danger" size="mini" @click="resourceGridRowDelete(scope.$index)">删除</el-button>
                      </template>
                    </el-table-column>
                  </el-table>
                </el-form>
              </div>
              <div v-else style="text-align:center;margin-top:200px">请选择作业节点</div>
            </el-tab-pane>
            <div v-if="!currentObj || (!isOpenEdit && currentObj && taskForm.data.taskType === '0')" style="margin-top:200px;text-align:center">请选择作业节点</div>
          </el-tabs>
        </el-row>
      </div>
    </div>
    <el-dialog
      :close-on-click-modal="false"
      title="增加资源"
      :visible.sync="resourceDialogVisible"
      class="select-resource-dialog"
      width="45%"
      :body-style="{ padding: '20px 0px 0px' }"
      @close="cancelSetResource"
    >
      <div style="height:460px;position:relative;">
        <Resource ref="setResource" :cur-sel-rows="setResource.curSelRows" select-type="multiple" @resourceTypeChange="resourceTypeChange" />
      </div>
      <span slot="footer">
        <el-button size="mini" @click="cancelSetResource">取 消</el-button>
        <el-button type="primary" size="mini" @click="handleSetResouce">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import { iterm, getTaskComboBox } from '@/api/taskComboBox'
import Gantt from '@/components/Gantt/index.vue'
import TaskTreeGridView from '../task/TaskTreeGridView.vue'
import Resource from '@/views/systemSet/resource/Resource'
import { getResTaskList } from '@/api/planAdjust/planAdjust'
import { commitTaskTable, getWbsApproveStatus, getTaskDuration } from '@/api/taskEdit'
import { saveTask } from '@/api/planAdjust/planAdjust'
import { mapGetters } from 'vuex'
export default {
  components: {
    Gantt,
    TaskTreeGridView,
    Resource
  },
  props: {
    taskProgressInfo: {
      type: Object,
      default: function() { return {} }
    },
    propsIsOpenEdit: {
      type: Boolean,
      default: false
    },
    propsChangeSelCol: {
      type: Array,
      default: function() { return [] }
    },
    showDetail: {
      type: Boolean,
      default: false
    },
    withOutGant: {
      type: Boolean,
      default: false
    },
    tabType: {
      type: String,
      default: 'res'
    },
    chartType: {
      type: String,
      default: 'res'
    },
    resSelObj: {
      type: Object,
      default: function() {
        return {
        }
      }
    },
    maxHeight: {
      type: Number,
      default: 500
    }
  },
  data() {
    return {
      rightWidth: 0,
      isOpenEdit: false,
      priceRule: [{ required: true, message: '单价不能为空' }, { trigger: 'blur', validator: (rule, value, callback) => {
        const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
        if (MoneyTest.test(value)) {
          callback()
        } else {
          callback(new Error('请输入非负数，最多两位小数'))
        }
      } }],
      amountRule: [{ required: true, message: '数量不能为空' }, { type: 'number', message: '请输入正整数' }, { trigger: 'blur', validator: (rule, value, callback) => {
        if (value > 0) {
          callback()
        } else {
          callback(new Error('请输入正整数'))
        }
      } }],
      projectSetting: {},
      globalParam: { projectId: this.$route.params.id },
      selectTimeScaleValue: '4',
      taskMultipleSelection: [],
      relationshipComboxOptions: null,
      planTypeComboxOptions: null,
      showSelectTaskDialog: false,
      logicGridForm: {
        data: [],
        tempData: [],
        loading: false
      },
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
      activeName: 'first',
      taskTypeComboxOptions: [{
        name: '里程碑',
        dictCode: '0'
      }, {
        name: '作业',
        dictCode: '1'
      }
      ],
      scheCalcTypeComboxOptions: [{
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
      tablecolumn: [],
      searchForm: {
        taskName: '',
        taskCode: '',
        taskType: ''
      },
      maxGridHeight: 500,
      tasks: {
        parent: '',
        data: [
        ],
        links: []
      },
      currentObj: null,
      taskForm: {
        data: {
          wbsName: '',
          wbsCode: '',
          principalId: '',
          principalName: '',
          planStartDate: '',
          taskType: '',
          scheCalcType: '',
          planEndDate: '',
          limitType: '',
          planDuration: '',
          planDate: ''
        },
        tempData: {

        },
        tempTaskType: '',
        rules: {
          planStartDate: [
            { required: false, trigger: 'change', message: '请选择开始日期' }
          ],
          planEndDate: [
            { required: false, trigger: 'change', message: '请选择结束日期' }
          ]
        }
      },
      editTaskDialogVisible: false,
      editMode: '',
      taskTreeData: [],
      resourceDialogVisible: false,
      setResource: {
        curSelRows: [],
        curTabName: 'human'
      },
      allCol: [],
      selCol: []
    }
  },
  computed: {
    gantDiv() {
      return this.$refs.gantDiv
    },
    ...mapGetters([
      'sidebar'
    ])
  },
  watch: {
    'sidebar.opened': {
      handler(v) {
        this.$nextTick(() => {
          if (!v) {
            this.rightWidth = this.rightWidth + 156
          } else {
            this.rightWidth = this.rightWidth - 156
          }
        })
      }
    },
    propsIsOpenEdit(v) {
      this.isOpenEdit = v
    },
    tabType(v) {
      // 变更页签
      this.setTableColumn()
    },
    resSelObj: {
      handler(newObj) {
        this.fetchTaskList()
      },
      deep: true
    },
    propsChangeSelCol: {
      handler(newObj) {
        this.setTableColumn(newObj)
      },
      deep: true
    },
    maxHeight(v) {
      this.maxGridHeight = this.maxHeight
    },

    editTaskDialogVisible(v) {
      if (v) {
        var tasks = this.$refs.gantDiv.ganttObj.getTaskByTime()
        for (let i = tasks.length - 1; i >= 0; i--) {
          if (tasks[i].parent) {
            tasks.splice(i, 1)
          }
        }
        this.taskTreeData = tasks
      }
    },
    resourceDialogVisible(v) {
      if (v) {
        this.setResource.curSelRows = [...this.resourceGridForm.data]
      }
    }
  },
  created() {
    this.getTaskComboBox()
    const vm = this
    this.$nextTick(() => {
      window.clickGridButton = function(id, action) {
        switch (action) {
          case 'edit':
            vm.handleTaskEdit({ id, action })
            break
          case 'delete':
            vm.deleteTaskById(id)
            break
          case 'detail':
            vm.handleTaskDetail({ id, action })
            break
        }
      }
      window.handlePlanTypeCovert = function(value) {
        if (vm.planTypeComboxOptions) { return vm.planTypeComboxOptions.find((element) => (element.dictCode === value)).name }
      }
      window.handleScheCalcTypeCovert = function(value) {
        if (vm.scheCalcTypeComboxOptions) { return vm.scheCalcTypeComboxOptions.find((element) => (element.dictCode === value)).name }
      }
      window.handleTaskTypeCovert = function(value) {
        if (vm.taskTypeComboxOptions) { return vm.taskTypeComboxOptions.find((element) => (element.dictCode === value)).name }
      }
    })
  },
  mounted() {
    this.fetchTaskList()
    this.setTaskGridRowBackGroundColor()
    this.setTaskBackGroundColor()
    this.onGanttGridSelected()
    this.setTableColumn(this.propsChangeSelCol)
    this.rightWidth = this.$refs.pageDiv.clientWidth / 2 - 2
  },
  beforeDestroy() {
    this.$refs.gantDiv.ganttObj.clearAll()
  },
  methods: {
    checkForm(formName, resultArr) { // 封装验证表单的函数
      var _self = this
      return new Promise(function(resolve, reject) {
        if (_self.$refs[formName]) {
          _self.$refs[formName].validate((valid) => {
            if (valid) {
              resolve(formName)
            } else { reject(formName) }
          })
        } else {
          resolve(formName)
        }
      })
    },
    handleDurationCalendarChange(value) {
      if (this.taskForm.data.setType === 0 && this.editMode === 'edit') {
        if (this.taskForm.tempData.planDuration && (value === this.taskForm.tempData.planDuration.toString())) {
          this.taskForm.data.planStartDate = this.taskForm.tempData.planStartDate
          this.taskForm.data.planEndDate = this.taskForm.tempData.planEndDate
        } else {
          this.taskForm.data.planEndDate = null
          this.taskForm.data.planStartDate = null
        }
      }
    },
    handleDateTypeRadioChange(value) {
      if (value) {
        this.$refs.taskForm.clearValidate(['planDuration'])
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = true
        this.taskForm.rules.planDuration[0].required = false
      } else {
        this.$refs.taskForm.clearValidate(['planStartDate', 'planEndDate'])
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = false
        this.taskForm.rules.planDuration[0].required = true
        if (this.editMode === 'edit' && this.taskForm.data.planDuration && this.taskForm.data.planDuration.toString() === this.taskForm.tempData.planDuration.toString()) {
          this.taskForm.data.planStartDate = this.taskForm.tempData.planStartDate
          this.taskForm.data.planEndDate = this.taskForm.tempData.planEndDate
        } else {
          this.taskForm.data.planStartDate = this.taskForm.data.planEndDate = null
        }
      }
    },
    getTaskDuration() {
      if (!this.taskForm.data.planStartDate || !this.taskForm.data.planEndDate) {
        return
      }
      getTaskDuration({ ...this.globalParam, ...{ startTime: this.taskForm.data.planStartDate, endTime: this.taskForm.data.planEndDate }}).then(res => {
        if (res.state === 'success') {
          this.$set(this.taskForm.data, 'planDuration', res.data)
        } else {
          this.$message.error('计算工期时出错')
        }
      }).catch(
      ).finally(() => {
      })
    },

    doubleClickGanttGrid({ id, event }) {
      var task = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
      if (task[0].taskMold === '1') {
        this.handleTaskEdit({ id, action: 'edit' })
      }
    },
    getTaskComboBox() {
      getTaskComboBox({ itemId: iterm.workTypeId }).then(res => {
        this.taskTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化作业类型下拉框失败')
      }).finally(() => {
      })
      getTaskComboBox({ itemId: iterm.calculateTypeId }).then(res => {
        // TODO
        this.scheCalcTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化计算方式下拉框失败')
      }).finally(() => {
      })
      getTaskComboBox({ itemId: iterm.taskTypeId }).then(res => {
        this.planTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化任务类型下拉框失败')
      }).finally(() => {
      })
      getTaskComboBox({ itemId: iterm.logicTypeId }).then(res => {
        this.relationshipComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化逻辑关系下拉框失败')
      }).finally(() => {
      })
    },
    cancelSetResource() {
      this.$refs.setResource.cancelSel()
      this.resourceDialogVisible = false
      this.editTaskDialogVisible = true
    },
    handleSetResouce() {
      this.resourceDialogVisible = false
      // human的humanSelArr
      const humanSelArr = [...this.$refs.setResource.$refs['human'].selResouce]
      var humanTmpArr = []
      humanTmpArr = JSON.parse(JSON.stringify(humanSelArr))
      if (this.resourceGridForm.data) {
        this.resourceGridForm.data.forEach(taskItem => {
          humanTmpArr.forEach(element => {
            if (taskItem.id === element.id) {
              this.setValue(element, ['resCode', 'resName', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'amount', 'startDate', 'endDate', 'bOldResource'], [
                taskItem.resCode, taskItem.resName, taskItem.resType, taskItem.resTypeName, taskItem.unitEstimate, taskItem.unitPrice, taskItem.amount, taskItem.startDate, taskItem.endDate, true
              ])
            }
          })
        })
      }
      humanTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          this.setValue(element, ['resId', 'resCode', 'resName', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice'], [
            element.id, '', element.name, '1', '人力', element.unitName, element.price
          ])
        }
      })

      // material 的处理
      //  material的 materialSelArr
      const materialSelArr = [...this.$refs.setResource.$refs['material'].selResouce]
      var materialTmpArr = []
      materialTmpArr = JSON.parse(JSON.stringify(materialSelArr))
      if (this.resourceGridForm.data) {
        this.resourceGridForm.data.forEach(taskItem => {
          materialTmpArr.forEach(element => {
            if (taskItem.id === element.id) {
              this.setValue(element, ['resCode', 'resName', 'resModel', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'amount', 'startDate', 'endDate', 'bOldResource'], [
                taskItem.resCode, taskItem.resName, taskItem.resModel, taskItem.resType, taskItem.resTypeName, taskItem.unitEstimate, taskItem.unitPrice, taskItem.amount, taskItem.startDate, taskItem.endDate, true
              ])
            }
          })
        })
      }
      materialTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          this.setValue(element, ['resId', 'resCode', 'resName', 'resModel', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice'], [
            element.id, element.resourceCode, element.resourceName, element.resourceType, '2', '材料', element.unitName, element.price
          ])
        }
      })

      // device 的处理
      //  devicedeviceSelArr
      const deviceSelArr = [...this.$refs.setResource.$refs['device'].selResouce]
      var deviceTmpArr = []
      deviceTmpArr = JSON.parse(JSON.stringify(deviceSelArr))
      if (this.resourceGridForm.data) {
        this.resourceGridForm.data.forEach(taskItem => {
          deviceTmpArr.forEach(element => {
            if (taskItem.id === element.id) {
              this.setValue(element, ['resCode', 'resName', 'resModel', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'amount', 'startDate', 'endDate', 'bOldResource'], [
                taskItem.resCode, taskItem.resName, taskItem.resModel, taskItem.resType, taskItem.resTypeName, taskItem.unitEstimate, taskItem.unitPrice, taskItem.amount, taskItem.startDate, taskItem.endDate, true
              ])
            }
          })
        })
      }
      deviceTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          this.setValue(element, ['resId', 'resCode', 'resName', 'resModel', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice'], [
            element.id, element.resourceCode, element.resourceName, element.resourceType, '3', '设备', element.unitName, element.price
          ])
        }
      })

      this.resourceGridForm.data = [...humanTmpArr, ...materialTmpArr, ...deviceTmpArr]
      this.editTaskDialogVisible = true
    },
    setValue(obj, keyArr, valueArr) {
      for (let i = 0; i < keyArr.length; i++) {
        this.$set(obj, keyArr[i], valueArr[i])
      }
    },
    handleTaskEdit({ id, action }) {
      if (this.activeName !== 'first') {
        this.activeName = 'first'
      }
      this.editMode = action
      const curTask = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
      this.taskForm.tempData = curTask[0]
      this.taskForm.tempTaskType = curTask[0].taskType
      // 作业基本信息
      this.taskForm.data = { ...curTask[0], ...{ planDate: '' }} || {}
      this.taskForm.data.wbsName = this.taskForm.data.text
      if (this.taskForm.data.taskType === '0') {
        this.taskForm.data.planDate = this.taskForm.data.planStartDate
      }
      if (this.taskForm.data.setType) {
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = true
      } else {
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = false
      }
      this.$nextTick(() => {
        if (this.$refs.taskForm) {
          this.$refs.taskForm.clearValidate()
        }
      })
      // 逻辑关系
      this.logicGridForm.data = curTask[0].relateList || []
      this.logicGridForm.tempData = [...this.logicGridForm.data]
      // 资源
      this.resourceGridForm.data = curTask[0].resourceList || []
      this.editTaskDialogVisible = true
    },
    handleTaskEditSubmit(callBack) {
      const vm = this
      let validPromise
      if (this.taskForm.data.taskType === '1') { // 作业
        validPromise = this.checkForm('taskForm')
          .then((value) => {
            if (value) {
              return this.checkForm('logicTableForm')
            } else {
              if (vm.taskForm.data.id) {
                this.gantDiv.ganttObj.selectTask(vm.taskForm.data.id)
                this.gantDiv.ganttObj.showTask(vm.taskForm.data.id)
              }
            }
          })
          .catch((e) => {
            if (e === 'taskForm') {
              this.activeName = 'first'
            } else {
              this.activeName = 'second'
            }
            // 此处为失败状态的回调， error即为以上reject函数里的error;

          // return true
          }).finally(() => {
          // 此处不管成功还是失败，都会执行，使用情况比较少。
          })
          .then((value) => {
            if (value) {
              return this.checkForm('resourceTableForm')
            }
          })
          .catch((e) => {
            // 此处为失败状态的回调， error即为以上reject函数里的error;
            if (e === 'logicTableForm') {
              this.activeName = 'second'
            } else {
              this.activeName = 'third'
            }
          }).finally(() => {
          // 此处不管成功还是失败，都会执行，使用情况比较少。
          })
      } else { // 里程碑
        validPromise = this.checkForm('taskForm')
      }
      validPromise.then((value) => {
        if (value) {
          if (this.taskForm.data.taskType === '0') {
            this.logicGridForm.data = []
            this.resourceGridForm.data = []
            this.taskForm.data.planStartDate = this.taskForm.data.planDate
            this.taskForm.data.planEndDate = this.taskForm.data.planDate
            this.taskForm.data.principalId = ''
            this.taskForm.data.principalName = ''
            this.taskForm.data.scheCalcType = ''
            this.taskForm.data.planDuration = ''
            this.taskForm.data.weightValue = ''
            this.taskForm.data.weights = ''
            this.taskForm.data.taskPreCodes = ''
          }
          // 前置任务
          const links = this.gantDiv.ganttObj.getLinks()
          for (let i = this.logicGridForm.tempData.length - 1; i >= 0; i--) {
            let flag = true
            for (let j = this.logicGridForm.data.length - 1; j >= 0; j--) {
              if (this.logicGridForm.tempData[i].id === this.logicGridForm.data[j].id) {
                flag = false
              }
            }
            if (flag) {
              if (this.logicGridForm.tempData[i].id) {
                this.gantDiv.ganttObj.deleteLink(this.logicGridForm.tempData[i].id)
              } else {
                for (let j = 0, len = links.length; j < len; j++) {
                  if (links[j].source === this.logicGridForm.tempData[i].taskPreId && links[j].target === this.taskForm.data.id) {
                    this.gantDiv.ganttObj.deleteLink(links[j].id)
                  }
                }
              }
            }
            // TODO update
          }
          for (let i = this.logicGridForm.data.length - 1; i >= 0; i--) {
            if (!this.logicGridForm.data[i].id) {
              this.gantDiv.ganttObj.addLink({
                source: this.logicGridForm.data[i].taskPreId,
                target: this.taskForm.data.id,
                type: this.logicGridForm.data[i].relationshipId
              })
            }
          }

          let taskPreCodes = ''
          for (let i = 0, len = this.logicGridForm.data.length; i < len; i++) {
            this.logicGridForm.data[i].intervalDays = this.logicGridForm.data[i].intervalDays || 0
            if (i === len - 1) {
              taskPreCodes += this.logicGridForm.data[i].taskPreCode
            } else {
              taskPreCodes += this.logicGridForm.data[i].taskPreCode + ','
            }
          }

          this.taskForm.data.taskPreCodes = taskPreCodes

          Object.assign(this.taskForm.data, { text: this.taskForm.data.wbsName,
            relateList: this.logicGridForm.data,
            resourceList: this.resourceGridForm.data,
            unscheduled: !(this.taskForm.data.planStartDate && this.taskForm.data.planEndDate),
            duration: this.DateMinus(this.taskForm.data.planStartDate, this.taskForm.data.planEndDate)
          })
          if (this.taskForm.data.planStartDate && this.taskForm.data.planEndDate) {
            this.taskForm.data.duration = this.DateMinus(this.taskForm.data.planStartDate, this.taskForm.data.planEndDate)
            // this.taskForm.data.start_date = this.taskForm.data.planStartDate.split('-')[2] + '-' + this.taskForm.data.planStartDate.split('-')[1] + '-' + this.taskForm.data.planStartDate.split('-')[0]
            this.taskForm.data.start_date = new Date(this.taskForm.data.planStartDate)
          }
          // const parentTask = this.gantDiv.ganttObj.getTaskBy('id', this.taskForm.data.parent)
          if (this.editMode === 'add') {
            this.gantDiv.ganttObj.addTask(this.taskForm.data, this.taskForm.data.parent, this.taskForm.data._index)
            // var tempFormData = JSON.parse(JSON.stringify(vm.taskForm.data))
            // tempFormData.id = vm.getUUID()
            // if (!parentTask[0].parent) {
            //   if (!parentTask[0].childList) {
            //     parentTask[0].childList = []
            //   }
            //   parentTask[0].childList.splice(vm.taskForm.data._index || parentTask[0].childList.length, 0, tempFormData)
            // } else {
            //   this.gantDiv.ganttObj.eachParent(function(task) {
            //     if (!task.parent) {
            //       vm.taskTreeDataEdit(task.childList, (item) => {
            //         if (item.id === vm.taskForm.data.parent) {
            //           if (!item.childList) {
            //             item.childList = []
            //           }
            //           // item.childList.push(vm.taskForm.data)
            //           item.childList.splice(vm.taskForm.data._index || item.childList.length, 0, tempFormData)
            //         }
            //       })
            //     }
            //   }, this.taskForm.data.parent)
            // }
          } else if (this.editMode === 'edit') {
            for (var key in this.taskForm.data) {
              if (key === 'start_date') {
                if (this.taskForm.data.planStartDate) {
                  this.gantDiv.ganttObj.getTask(this.taskForm.data.id)[key] = new Date(this.taskForm.data.planStartDate)
                }
              } else if (key === 'end_date') {
                if (this.taskForm.data.planEndDate) {
                  const d = new Date(new Date(this.taskForm.data.planEndDate).getTime() + 24 * 60 * 60 * 1000)
                  const ed = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate()
                  this.taskForm.data.end_date = new Date(ed)
                  this.gantDiv.ganttObj.getTask(this.taskForm.data.id)[key] = new Date(ed)
                }
              } else {
                this.gantDiv.ganttObj.getTask(this.taskForm.data.id)[key] = this.taskForm.data[key]
                this.gantDiv.ganttObj.updateTask(this.taskForm.data.id)
              }
            }

            // if (!parentTask[0].parent) {
            //   parentTask[0].childList.forEach((val, key) => {
            //     if (val.id === vm.taskForm.data.id) {
            //       Object.assign(val, vm.taskForm.data)
            //     }
            //   })
            // } else {
            //   this.gantDiv.ganttObj.eachParent(function(task) {
            //     if (!task.parent) {
            //       vm.taskTreeDataEdit(task.childList, (item) => {
            //         if (item.id === vm.taskForm.data.parent && item.childList) {
            //           item.childList.forEach((val, key) => {
            //             if (val.id === vm.taskForm.data.id) {
            //               Object.assign(val, vm.taskForm.data)
            //             }
            //           })
            //         }
            //       })
            //     }
            //   }, this.taskForm.data.parent)
            // }
            // this.taskForm.tempData = {}
            // 作业类型 作业->里程碑 解除逻辑关系
            /*  if ((this.taskForm.data.taskType === '0') && (this.taskForm.tempTaskType === '1')) {
              const workTasks = vm.gantDiv.ganttObj.getTaskBy('taskType', '1')
              for (let i = workTasks.length - 1; i >= 0; i--) {
                if (workTasks[i].relateList && workTasks[i].relateList.length > 0) {
                  let flag = false
                  for (let i = 0, len = workTasks[i].relateList.length; i < len; i++) {
                    if (vm.taskForm.data.id === workTasks[i].relateList[i].taskNextId) {
                      workTasks[i].relateList.splice(i, 1)
                      flag = true
                    }
                  }
                  if (flag) {
                    vm.gantDiv.ganttObj.updateTask(workTasks[i].id)
                  }
                }
              }
            } */
            if ((this.taskForm.data.taskType === '0') && (this.taskForm.tempTaskType === '1')) {
              this.gantDiv.ganttObj.eachTask(function(task) {
                if (!task.parent && task.childList) {
                  vm.taskTreeDataEdit(task.childList, (item) => {
                    if (item.childList) {
                      item.childList.forEach((val, key) => {
                        if (val.relateList && val.relateList.length > 0) {
                          for (let i = val.relateList.length - 1; i >= 0; i--) {
                            if (vm.taskForm.data.id === val.relateList[i].taskPreId) {
                              val.relateList.splice(i, 1)
                            }
                          }
                        }
                      })
                    }
                  })
                }
              })
            }
            this.taskForm.tempTaskType = ''
          }
          // this.gantDiv.ganttObj.getTask(this.taskForm.data.parent).childList.forEach((val, key) => {
          //   if (val.id === this.taskForm.data.id) {
          //     Object.assign(val, this.gantDiv.ganttObj.getTask(this.taskForm.data.id))
          //   }
          // })
          this.editTaskDialogVisible = false
          if (callBack && callBack instanceof Function) {
            callBack(true)
          }
        }
      }).catch((err) => {
        if (vm.taskForm.data.id) {
          this.gantDiv.ganttObj.selectTask(vm.taskForm.data.id)
          this.gantDiv.ganttObj.showTask(vm.taskForm.data.id)
          console.log('-----校验', err)
        }
      })
    },
    handleTaskTypeChang(v) {
      if (v === '0') {
        this.activeName = 'first'
      } else {
        //
      }
      this.$refs.taskForm.clearValidate()
    },
    pickerOptions(param, beginDate) {
      const _self = this
      return {
        disabledDate(time) {
          switch (param) {
            case 'planEndDate':
              if (_self.taskForm.data.planStartDate) {
                return time.getTime() + (1000 * 60 * 60 * 24) < (new Date(_self.taskForm.data.planStartDate).getTime())
              } else {
                return false
              }
            case 'planStartDate':
              if (_self.taskForm.data.planEndDate) {
                return (new Date(_self.taskForm.data.planEndDate).getTime()) < time.getTime()
              } else {
                return false
              }

            case 'resourceGridRowEndDate':
              return (new Date(beginDate).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
            case 'resourceGridRowBeginDate':
              return (new Date(beginDate).getTime()) <= time.getTime()
          }
        }
      }
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
    taskTreeDataEdit(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.childList) {
          this.taskTreeDataEdit(obj.childList, callBack)
        }
      })
    },
    fetchTaskList() {
      var param = {
        projectId: this.$route.params.id,
        startDate: this.resSelObj.startDate,
        endDate: this.resSelObj.endDate
      }
      if (this.tabType === 'res') {
        param.statisFlag = 0
        param.resId = this.resSelObj.selectId
      } else {
        param.statisFlag = 1
        if (this.chartType === 'cost') {
          delete param.startDate
          delete param.endDate
          param.resId = this.resSelObj.selectId
        }
      }
      getResTaskList(param).then(res => {
        var treeData = []
        this.tasks.links = []
        if (res.state === 'success') {
          this.convertTreeData('', res.data, (item, parent) => {
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
              }
            }
          })
          this.tasks.data = treeData
        } else {
          this.$message.error('获取列表数据失败')
        }
      }).catch(
      )
    },
    resourceTypeChange({ activeName }) {
      this.setResource.curTabName = activeName
    },
    taskMultipleSelectionMethod(tasks) {
      var tasks_ = []
      for (let i = 0, len = tasks.length; i < len; i++) {
        if (tasks[i].relateList && tasks[i].relateList.length > 0 && this.editMode === 'edit') {
          for (let j = 0, len = tasks[i].relateList.length; j < len; j++) {
            if (tasks[i].relateList[j].taskPreId === this.taskForm.data.id) {
              return this.$message.warning('当前作业已设为“' + tasks[i].wbsName + '”前置，不能互为前置')
            }
          }
        }
        tasks_.push({
          taskPreCode: tasks[i].wbsCode,
          taskPreName: tasks[i].wbsName,
          taskPreId: tasks[i].id
        })
      }
      this.taskMultipleSelection = tasks_
    },
    handleSelectTask() {
      this.showSelectTaskDialog = false
      this.taskMultipleSelection.forEach((item, index, array) => {
        item.relationshipId = '0'
      })
      this.logicGridForm.data.push(...this.taskMultipleSelection)
    },
    handleSelectTaskDialogClose() {
      this.showSelectTaskDialog = false
      this.editTaskDialogVisible = true
    },
    logicGridAddRow() {
      this.editTaskDialogVisible = false
      this.showSelectTaskDialog = true
    },
    logicGridRowDelete(index) {
      this.logicGridForm.data.splice(index, 1)
    },
    resourceGridAddRow() {
      this.editTaskDialogVisible = false
      this.resourceDialogVisible = true
    },
    resourceGridRowDelete(index) {
      this.resourceGridForm.data.splice(index, 1)
    },
    screenFull() {
      this.$refs.gantDiv.ganttObj.ext.fullscreen.toggle()
    },
    searchTaskByParam() {
      this.$refs.gantDiv.ganttObj.refreshData()
    },
    setTableColumn(arr) {
      const me = this
      if (!this.$refs.gantDiv || !this.$refs.gantDiv.ganttObj) {
        return
      }
      if (this.allCol.length === 0) {
        this.allCol = [{
          name: 'wbs',
          label: '序号',
          min_width: 150,
          template: function(obj) {
            return ('<span style="margin-left:10px">') + me.$refs.gantDiv.ganttObj.getWBSCode(me.$refs.gantDiv.ganttObj.getTask(obj.id)) + ('</span>')
          },
          align: 'left',
          disabled: true
        }, {
          label: '编码',
          name: 'wbsCode',
          min_width: 200,
          resize: true,
          align: 'left',
          template: function(obj) {
            if (obj.wbsCode) {
              return ('<span class="tag-pointer" title="' + obj.wbsCode + '">') + obj.wbsCode + ('</span>')
            }
          }
        }, {
          label: '名称',
          name: 'text',
          width: 200,
          tree: true,
          resize: true,
          align: 'left',
          disabled: true,
          template: function(obj) {
            if (!obj.parent) {
              return ('<span style="font-weight:700">') + obj.text + ('</span>')
            } else {
              return obj.text
            }
          }
        },
        {
          label: '类型',
          name: 'taskMold',
          min_width: 50,
          align: 'center',
          resize: true,
          template: function(obj) {
            if (obj.taskMold) {
              if (obj.taskMold === '0') {
                return window.handlePlanTypeCovert(obj.taskMold)
              } else {
                return window.handleTaskTypeCovert(obj.taskType)
              }
            }
          }
        },
        {
          label: '前置任务',
          name: 'taskPreCodes',
          min_width: 150,
          align: 'left',
          resize: true,
          template: function(obj) {
            if (obj.taskPreCodes) {
              return ('<span class="tag-pointer" title="' + obj.taskPreCodes + '">') + obj.taskPreCodes + ('</span>')
            }
          }
        },
        {
          label: '使用量',
          name: 'resCount',
          min_width: 100,
          align: 'center'
        },
        {
          label: '计划工期',
          name: 'duration',
          min_width: 100,
          align: 'center',
          resize: true,
          template: function(obj) {
            return obj.planDuration
          }
        },
        {
          label: '计划开始时间',
          name: 'planStartDate',
          min_width: 100,
          align: 'center',
          resize: true
        }, {
          label: '计划结束时间',
          name: 'planEndDate',
          min_width: 100,
          align: 'center',
          resize: true
        }]
      }
      if (this.selCol.length === 0) {
        this.selCol = [{
          name: 'wbs',
          label: '序号',
          width: 150,
          template: this.gantDiv.ganttObj.getWBSCode,
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
          label: '使用量',
          name: 'resCount',
          min_width: 100,
          align: 'center'
        }, {
          label: '计划工期',
          name: 'planDuration',
          width: 100,
          align: 'center',
          resize: true,
          template: function(obj) {
          // if (!obj.unscheduled) {
            return obj.planDuration
          // } else {
          // return null
          // }
          }
        },
        {
          label: '计划开始时间',
          name: 'planStartDate',
          width: 100,
          align: 'center',
          resize: true
        }, {
          label: '计划结束时间',
          name: 'planEndDate',
          width: 100,
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
      if (this.tabType === 'cost') {
        this.tablecolumn.splice(5, 1, {
          label: '累计费用(元)',
          name: 'resAmount',
          min_width: 100,
          align: 'center'
        })
      }
    },
    addTask({ obj, event }) {
      // this.currentObj = obj
      // if (this.$refs.taskForm) {
      //   this.resetForm('taskForm')
      // }
      this.taskForm.data = {
        wbsName: '',
        wbsCode: '',
        principalId: '',
        principalName: '',
        planStartDate: '',
        taskMold: '1',
        taskType: '1',
        scheCalcType: '',
        planEndDate: '',
        limitType: '',
        expenseId: '',
        calendarId: '',
        costCode: '',
        // duration: '',
        planDuration: '',
        parent: obj.parent,
        _index: event,
        // ------------//
        // wbsId: obj.parent,
        wbsId: this.currentObj.taskMold === '0' ? this.currentObj.oldId : this.currentObj.wbsId,
        projectId: '' + this.globalParam.projectId,

        /* 权值 时间 */
        weightValue: 1,
        setType: 0,
        taskPreCodes: ''
      }
      /* resove plan start end date valid TODO review (replace with watch) */
      if (this.taskForm.data.setType) {
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = true
      } else {
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = false
      }
      this.$nextTick(() => {
        if (this.$refs.taskForm) {
          this.$refs.taskForm.clearValidate()
        }
      })
      this.logicGridForm.data = []
      this.resourceGridForm.data = []
      if (this.activeName !== 'first') {
        this.activeName = 'first'
      }
      this.editMode = 'add'
      this.editTaskDialogVisible = true
    },
    setTaskGridRowBackGroundColor() {
      this.$refs.gantDiv.ganttObj.templates.grid_row_class = function(start, end, task) {
        if (task.taskMold === '0') {
          return 'task-grid-wbs-row-background-color'
        }
        return ''
      }
    },
    setTaskBackGroundColor() {
      this.$refs.gantDiv.ganttObj.templates.task_class = function(start, end, task) {
        if (task.taskMold === '0') {
          return 'medium'
        }
      }
    },
    onGanttGridSelected() {
      this.$refs.gantDiv.ganttObj.attachEvent('onBeforeTaskSelected', function(id) {
        return true
      })
    },
    validateTaskGrid() {
      var warningHtml
      var workTasks = this.$refs.gantDiv.ganttObj.getTaskBy('taskMold', '1')
      if (!workTasks || workTasks.length === 0) {
        // warningHtml = '<span style="color: #f56c6c;">还未添加任何作业，请先添加作业</span>'
        warningHtml = '<span>还未添加任何作业，请先添加作业</span>'
        this.$alert(warningHtml, '提示', {
          confirmButtonText: '确定',
          dangerouslyUseHTMLString: true,
          type: 'warning'
        })
        return false
      }
      var validTasks = this.$refs.gantDiv.ganttObj.getTaskBy(function(task) {
        return (!task.weights && (task.taskType === '1')) || (task.taskType === '0' && !task.planStartDate)
      })
      if (validTasks && validTasks.length > 0) {
        warningHtml = `第<strong>${validTasks[0].$wbs}</strong>行<b>${validTasks[0].text}</b>权重为空，请自动生成权重后再保存`
        if (!validTasks[0].planStartDate && (validTasks[0].taskType === '0')) {
          warningHtml = `第<strong>${validTasks[0].$wbs}</strong>行<b>${validTasks[0].text}</b>计划时间为空`
        }
        this.$alert(warningHtml, '提示', {
          confirmButtonText: '确定',
          dangerouslyUseHTMLString: true,
          type: 'warning'
        })
        return false
      }
      var templateTasks = this.$refs.gantDiv.ganttObj.getTaskBy('add_from_template', true)
      for (let i = 0, len = templateTasks.length; i < len; i++) {
        if ((!templateTasks[i].principalId || !templateTasks[i].planDuration) && templateTasks[i].taskType === '1') {
          warningHtml = `第<strong>${templateTasks[i].$wbs}</strong>行<b>${templateTasks[i].text}</b>${!templateTasks[i].principalId ? '负责人为空' : '工期为空'}，请设置${!templateTasks[i].principalId ? '负责人' : '工期'}后再保存`
          // <span style="color: #f56c6c;"></span>
          this.$alert(warningHtml, '提示', {
            confirmButtonText: '确定',
            dangerouslyUseHTMLString: true,
            type: 'warning'
          })
          return false
        }
      }
      return true
    },
    saveTaskTable(type, task) {
      this.handleTaskEditSubmit(() => {
        var flag = false
        getWbsApproveStatus(this.globalParam).then(res => {
          flag = res
          if (!flag) {
            return this.$message.warning('待WBS审核通过后才能进行此操作')
          }
          if (!this.validateTaskGrid()) {
            return
          }
          let request = []
          if (!task) {
            var tmp = this.$refs.gantDiv.ganttObj.serialize().data
            tmp.forEach(element => {
              if (element.taskMold !== '0') {
                request.push(element)
              }
            })
          } else {
            request = task
          }
          saveTask(request, { headers: {}, params: {
            projectId: this.globalParam.projectId,
            period: this.selectTimeScaleValue
          }}).then(res => {
            if (res.state === 'success') {
              if (this.currentObj) {
                this.currentObj = null
              }
              this.editTaskDialogVisible = false
              this.fetchTaskList()
            } else {
              this.$message.error('保存作业失败')
            }
            this.$emit('changeResource')
          }).catch(() => {
          }).finally(() => {
          })
        })
      })
    },
    async commitTaskTable() {
      var flag = false
      await getWbsApproveStatus(this.globalParam).then(res => {
        flag = res
      })
      if (!flag) {
        return this.$message.warning('待WBS审核通过后才能进行此操作')
      }
      if (!this.validateTaskGrid()) {
        return
      }
      this.$prompt('说明：提交后，当前作业自动生成一个新版本', '提交说明', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /^(?=.{1,200}$)[\s\S]*.*[^\s][\s\S]*$/,
        inputType: 'textarea',
        inputErrorMessage: '输入不能为空，最多可输入200字符'
      }).then(({ value }) => {
        var tasks = this.$refs.gantDiv.ganttObj.getTaskByTime()
        for (let i = tasks.length - 1; i >= 0; i--) {
          if (tasks[i].parent) {
            tasks.splice(i, 1)
          }
        }
        commitTaskTable({ remark: value,
          projectId: this.globalParam.projectId,
          submitFlag: 1
        }, tasks, { headers: {}}).then(res => {
          if (res.state === 'success') {
            this.$message.success('提交成功')
            // this.fetchTaskList()
          } else {
            this.$message.error('提交失败')
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
    },

    // date1:小日期 date2:大日期
    DateMinus(startDate, endDate) {
      var sdate = new Date(startDate)
      var now = new Date(endDate)
      var days = now.getTime() - sdate.getTime()
      var day = parseInt(days / (1000 * 60 * 60 * 24))
      return day + 1
    },

    clickGanttGridRow({ id, row }) {
      if (this.$refs.gantDiv.ganttObj.getSelectedId() !== id) {
        this.$refs.gantDiv.ganttObj.selectTask(id)
        this.$refs.gantDiv.ganttObj.showTask(id)
      }
      if (this.isOpenEdit && this.currentObj && this.currentObj.id && this.currentObj.taskMold === '1') {
        this.handleTaskEditSubmit(() => {
          const currenTask = this.gantDiv.ganttObj.getTaskBy('id', id)
          this.currentObj = currenTask[0] || { }
          if (currenTask[0].taskMold === '1') {
            if (this.isOpenEdit) {
              if (currenTask[0].operate === false) {
                this.$message.warning('只有创建人和负责人才可编辑哦')
              } else {
                this.handleTaskEdit({ id, action: 'edit' })
              }
            } else {
              this.handleTaskEdit({ id, action: 'edit' })
            }
          }
        })
      } else {
        const currenTask = this.gantDiv.ganttObj.getTaskBy('id', id)
        this.currentObj = currenTask[0] || { }
        if (currenTask[0].taskMold === '1') {
          if (this.isOpenEdit) {
            if (currenTask[0].operate === false) {
              this.$message.warning('只有创建人和负责人才可编辑哦')
            } else {
              this.handleTaskEdit({ id, action: 'edit' })
            }
          } else {
            this.handleTaskEdit({ id, action: 'edit' })
          }
        }
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.el-icon-arrow-down {
  font-size: 10px;
}
.ml-10 {
  margin-left:10px;
}
.mt-10{
  margin-top:10px;
}

.button-group {
  vertical-align:baseline;
  line-height: 100%;
  height:100%;
}
.el-date-editor.el-input {
    width: 140px;
}

.edit-table .el-form-item--mini.el-form-item, .edit-table .el-form-item--small.el-form-item {
  margin-top: 18px;
}

/deep/ .select-resource-dialog .el-dialog__body {
    padding: 0px 20px;
    color: #727f99;
    font-size: 14px;
    word-break: break-all;
}

 #edit-task-dialog /deep/ .el-tabs__content {
  height: 350px;
}
</style>
<style>

.gantt_grid_data .task-grid-wbs-row-background-color,
.gantt_grid_data .task-grid-wbs-row-background-color.odd {
background-color:#DCDFE6;
}
.table-header .buttons-right {
    float: right;
    padding-right: 20px;
}
.medium {
			border: 2px solid #34c461;
			color: #34c461;
			background: #34c461;
		}
.medium .gantt_task_progress {
  background: #23964d;
}
</style>
