<template>
  <div id="wbsEditDiv" ref="wbsEditDiv" class="pageDiv clearfix">
    <el-card :body-style="{ padding: '0px 0px 0px' }">
      <div v-if="showInfoToolbar" ref="cardthreeheader" slot="header" class="clearfix">
        <span style="font-size:14px;margin-left:-10px">当前级别：{{ nowEditLevel }}</span>
      </div>
      <div ref="topDiv" class="clearfix">
        <el-row v-if="showInfoToolbar" class="clearfix">
          <el-form :model="planform" size="mini" label-width="auto" style="margin-left:10px;margin-top:3px;">
            <el-row :gutter="6">
              <el-col :xl="4" :lg="4" :md="4" :sm="4" :xs="4">
                <el-form-item label="名称">
                  <el-input v-model="planform.wbsName" placeholder="名称" clearable />
                </el-form-item>
              </el-col>
              <el-col :xl="4" :lg="4" :md="4" :sm="4" :xs="4">
                <el-form-item label="级别">
                  <el-select v-model="planform.wbsLevel" placeholder="级别" clearable>
                    <el-option
                      v-for="item in planLevelList"
                      :key="item.dictCode"
                      :label="item.name"
                      :value="item.dictCode"
                    />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :xl="12" :lg="12" :md="12" :sm="12" :xs="12">
                <el-button type="primary" size="mini" icon="el-icon-search" @click="searchPlan()">查询</el-button>

                <el-button type="primary" size="mini" @click="toVersionView">版本记录</el-button>
                <el-button v-if="isManager && !editManagement" type="primary" size="mini" @click="editMangementFunc">编辑</el-button>
                <span v-if="editManagement" style="margin-left: 10px">
                  <el-button type="primary" :loading="saveLoading" size="mini" @click="saveTable">保存</el-button>
                  <el-button style="margin-right: 10px" size="mini" @click="cancelTable">取消</el-button>
                </span>
                <el-button v-if="editManagement" type="primary" size="mini" :loading="submitLoading" @click="submitVersion">提交版本</el-button>
                <span v-if="!editManagement&&isManager" style="margin-left: 10px">
                  <el-button type="primary" size="mini" @click="editFinish('0')">编制完成</el-button>
                </span>
                <span v-if="!editManagement&&!isManager&&isShowFinishBtn" style="margin-left: 10px">
                  <el-button type="primary" size="mini" @click="editFinish('1')">取消完成</el-button>
                </span>
              </el-col>
            </el-row>
          </el-form>
        </el-row>
        <el-row type="flex" justify="center"><i v-if="showInfoToolbar" class="el-icon-caret-top" style="cursor: pointer;" @click="collapseToolBar" /><i v-else class="el-icon-caret-bottom" style="cursor: pointer;" @click="expandToolBar" /></el-row>
        <el-row class="clearfix">
          <div style="display:inline;margin-left:20px;">
            <div class="mt-10" style="float:right;padding:0px 10px 5px 0px;">
              <!-- <el-button v-if="editManagement" type="primary" size="mini" @click="importWbs">导入</el-button>
              <el-button v-if="editManagement" type="primary" size="mini" @click="setCodeRule">选择编码规则</el-button> -->
              <el-button v-if="editManagement" type="primary" size="mini" @click="toWeight()">自动生成权重</el-button>
              <el-button type="primary" size="mini" @click="zoomIn()">放大</el-button>
              <el-button type="primary" size="mini" style="margin-right: 10px;" @click="zoomOut()">缩小</el-button>
              <el-select
                v-if="editManagement"
                v-model="selectTimeScaleValue"
                size="mini"
                style="width:80px"
                @change="handleChangTimeScale"
              >
                <el-option label="年/季" :value="'1'" />
                <el-option label="年/月" :value="'2'" />
                <el-option label="季/月" :value="'3'" />
                <el-option label="月/周" :value="'4'" />
                <el-option label="周/天" :value="'5'" />
              </el-select>
              <!-- <el-button type="primary" size="mini" @click="screenFull()">{{ screenText }}</el-button>
              <el-button type="primary" size="mini" icon="el-icon-zoom-in" @click="zoomIn()">放大</el-button>
              <el-button type="primary" size="mini" icon="el-icon-zoom-out" @click="zoomOut()">缩小</el-button> -->

            </div>
            <div class="ml-10" style="float:left;padding:10px 0px 5px 10px;">
              <el-popover
                v-model="showCustomCol"
                title="自定义列"
                width="120px"
                trigger="click"
              >
                <CustomCol :prop-all-col="allCol" :prop-select-col="selCol" @selectCol="setTableColumn" />
                <el-button slot="reference" size="mini" plain :icon="customIcon">自定义列</el-button>
              </el-popover>
              <el-link :underline="false" class="button-group" @click="openAll">全部展开</el-link>
              <el-link :underline="false" class="ml-10 button-group" @click="closeAll">全部收起</el-link>
              <el-link v-if="editManagement" :underline="false" class="ml-10 button-group" @click="addNode">新增同级节点</el-link>
              <el-link v-if="editManagement" :underline="false" class="ml-10 button-group" @click="addChildren">新增子节点</el-link>
              <el-link v-if="editManagement" :underline="false" class="ml-10 button-group" @click="delNode">删除</el-link>
              <el-link v-if="editManagement" :underline="false" class="ml-10 button-group" @click="up">上移</el-link>
              <el-link v-if="editManagement" :underline="false" class="ml-10 button-group" @click="down">下移</el-link>
            </div>
          </div>
        </el-row>
      </div>
      <div :style="{'position':'relative'}">
        <gantt
          ref="gantDiv"
          :drag-branch-free="branchFree"
          :drag-move-date="dragMoveDate"
          :drag-resize-date="dragResizeDate"
          :style="{'width':'100%','height':maxGridHeight+'px'}"
          :tasks="tasks"
          :gant-columns="tablecolumn"
          :filter="onBeforeTaskDisplay"
          :moverow="onAfterTaskMove"
          @addTask="addTask"
          @clickRow="clickRow"
        />
        <div v-if="showDetail" :style="{'position':'absolute','width':rightWidth+'px','background':'white','top':'1px','right':'1px','bottom':'1px','padding-left':'5px','padding-right':'20px'}">
          <div v-if="curObj && curObj.id">
            <el-form v-if="editManagement && curObj.levelName === nowEditLevel && curObj.operate " ref="nameForm" :model="formData" style="margin-top:10px" label-width="33%" size="small" label-suffix="" :rules="planrules">
              <el-row class="edit-row" :gutter="0">
                <el-col :span="12">
                  <el-form-item label="名称：" prop="wbsName" :rules="planrules.name" style="margin-left:18px;">
                    <el-input v-model="formData.wbsName" maxlength="20" style="width:180px" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="编码：" prop="wbsCode" style="margin-left:18px;">
                    <el-input v-model="formData.wbsCode" maxlength="20" style="width:180px" readonly />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row class="edit-row" :gutter="0">
                <el-col :span="12">
                  <el-form-item label="级别：" prop="levelName" style="margin-left:18px;">

                    {{ formData.levelName }}
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                <!-- <el-form-item label="计划工期：" prop="planDuration" style="margin-left:18px;">
              <el-input-number v-model="formData.planDuration" controls-position="right" :min="1" :precision="0" size="small" style="width:180px" />
            </el-form-item> -->
                </el-col>
              </el-row>
              <el-row class="edit-row" :gutter="0">
                <el-col :span="12">
                  <el-form-item v-if="!formData.prinHide && (Number(formData.levelSort)!== Number(maxLevel))" label="下级负责人：" prop="principalName" style="margin-left:18px;">
                    <div class="el-input el-input--small" @click="selVisible = true">
                      <el-input v-model="formData.principalName" readonly placeholder="请选择" style="width:180px;" />
                    </div>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="权值：" prop="weightValue" style="margin-left:18px;">
                    <el-input-number v-model="formData.weightValue" controls-position="right" :precision="0" :min="1" :max="5" size="small" style="width:180px" />
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row class="edit-row">
                <el-col :span="24">
                  <el-form-item label="" label-width="0px" prop="forceTime" style="margin-left:18px;">
                    <el-checkbox v-model="formData.forceTime">设置必须开始/结束时间（建议不设置，系统会根据作业时间自动计算）</el-checkbox>
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row v-if="formData.forceTime == '1'" class="edit-row" :gutter="0">
                <el-col :span="12">
                  <el-form-item label="计划开始时间：" prop="planStartDate" :rules="formData.forceTime?planrules.planStartDate:[{ required: false, message: '请填写计划开始时间', trigger: 'change' }]" style="margin-left:18px;">
                    <el-date-picker
                      v-model="formData.planStartDate"
                      style="width:180px"
                      value-format="yyyy-MM-dd"
                      :picker-options="getPickerOption('planStartDate')"
                      type="date"
                      @change="DateMinus"
                    />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="计划结束时间：" prop="planEndDate" :rules="formData.forceTime?planrules.planEndDate:[{ required: false, message: '请填写计划结束时间', trigger: 'change' }]" style="margin-left:18px;">
                    <el-date-picker
                      v-model="formData.planEndDate"
                      value-format="yyyy-MM-dd"
                      style="width:180px"
                      :picker-options="getPickerOption('planEndDate')"
                      type="date"
                      @change="DateMinus"
                    />
                  </el-form-item>
                </el-col>
              </el-row>
            </el-form>
            <el-form v-else ref="detailForm" :model="formData" style="margin-top:10px" label-width="33%" size="small">
              <el-row class="edit-row" :gutter="0">
                <el-col :span="12">
                  <el-form-item label="名称：" prop="wbsName" style="margin-left:18px;">
                    {{ formData.wbsName }}
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="编码：" style="margin-left:18px;">
                    {{ formData.wbsCode }}
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row class="edit-row" :gutter="0">
                <el-col :span="12">
                  <el-form-item label="级别：" prop="levelName" style="margin-left:18px;">
                    {{ formData.levelName }}
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row class="edit-row" :gutter="0">
                <el-col :span="12">
                  <el-form-item v-if="!formData.prinHide && (Number(formData.levelSort)!== Number(maxLevel))" label="下级负责人：" prop="principalName" style="margin-left:18px;">
                    <div class="el-input el-input--small" @click="selVisible = true">
                      {{ formData.principalName }}
                    </div>
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="权值：" style="margin-left:18px;">
                    {{ formData.weightValue }}
                  </el-form-item>
                </el-col>
              </el-row>
              <el-row v-if="formData.forceTime == '1'" class="edit-row" :gutter="0">
                <el-col :span="12">
                  <el-form-item label="计划开始时间：" style="margin-left:18px;">
                    {{ formData.planStartDate }}
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="计划结束时间：" style="margin-left:18px;">
                    {{ formData.planEndDate }}
                  </el-form-item>
                </el-col>
              </el-row>
            </el-form>
          </div>
          <div v-else style="height:100%">
            <div style="display: flex;align-items: center;justify-content: center;height:100%"> 请选择WBS节点</div>
          </div>
        </div>
      </div></el-card>
    <el-dialog :visible.sync="importLoading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>
    <el-dialog :visible.sync="importListVisible" width="400px" :show-close="false" title="导入进度计划" :close-on-click-modal="false">
      <el-form ref="importForm" :model="fileInfo">
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
        <el-button type="primary" size="mini" @click="sureChoseFile('importForm')">确定</el-button>
        <el-button type="primary" size="mini" @click="cancelChoseFile">取消</el-button>
      </span>
    </el-dialog>
    <!-- <el-dialog
      title=""
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
      width="800px"
    >

      <span slot="footer">
        <el-button size="mini" @click="toCancel">取 消</el-button>
        <el-button type="primary" :loading="optLoad" size="mini" @click="nameSubmit">确 定</el-button>
      </span>
    </el-dialog> -->
    <el-dialog :visible.sync="versionHistoryVisble" width="60%" :show-close="true" title="版本记录" :close-on-click-modal="true" @close="closeVersionHistoryDialog">
      <el-dialog :visible.sync="versionHistoryInfoVisble" width="80%" :show-close="true" title="版本详情" :close-on-click-modal="true" append-to-body>
        <WbsVersionHistoryInfo v-if="versionHistoryInfoVisble" :row-obj="rowObj" />
      </el-dialog>
      <wbsVersionHistoryView v-if="versionHistoryVisble" :wbs-level-id="wbsLevelId" :wbs-level-code="nowEditLevelId" :level-name="nowEditLevel" :edit-management="editManagement" @toViewHistoryInfo="toViewHistoryInfo" />
    </el-dialog>
    <!-- <el-dialog :visible.sync="codeRuleVisible" width="80%" :show-close="true" title="选择编码规则" :close-on-click-modal="true">
      <SelectCodeRule v-if="codeRuleVisible" @setSelectValue="getBackData" />
    </el-dialog> -->
    <SelectPerople ref="sel" :visible.sync="selVisible" sel-type="multiple" :is-fweb="true" :b-project-select="true" :init-datas="principalArr" :add-account="false" :url-param="{'wbsLevelId':wbsLevelId}" @sure="handleSel" />

  </div>

</template>

<script>
import { getDictByItemId, getWbsData, saveScheEdit, saveScheWbs, saveWbsVersion, importWbsDet, getCompileState, getWbsRuleCode } from '@/api/wbsPlan'
import { getProgrameSettings, getTaskDuration } from '@/api/taskEdit'
import Gantt from '@/components/Gantt/index.vue'
import WbsVersionHistoryView from './WbsVersionHistoryView.vue'
import WbsVersionHistoryInfo from './WbsVersionHistoryInfo.vue'
import SelectPerople from '@/components/SelectPeople'
import CustomCol from '@/components/CustomCol/index.vue'
import { getGlobalDepartmentMap } from '@/api/GlobalProjectInfo'
import { mapGetters } from 'vuex'
export default {
  name: 'WbsDetail',
  components: {
    Gantt,
    WbsVersionHistoryView,
    WbsVersionHistoryInfo,
    SelectPerople,
    CustomCol
  },
  props: {
    maxHeight: {
      type: Number,
      default: 500
    },
    maxLevel: {
      type: String,
      default: ''
    },
    isManager: {
      type: Boolean,
      default: false
    },
    isChange: {
      type: Boolean,
      default: false
    },
    wbsLevelId: {
      type: String,
      default: ''
    },
    nowEditLevelId: {
      type: String,
      default: ''
    },
    nowEditLevel: {
      type: String,
      default: ''
    },
    nowEditLevelState: {
      type: String,
      default: ''
    },
    isShowFinishBtn: {
      type: Boolean,
      default: false
    },
    scheLevelUsers: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      rightWidth: 0,
      editFinish: null,
      tentantId: this.$store.getters.tentantId, // 企业id
      showInfoToolbar: true,
      // tableHeight: window.innerHeight > 200 ? window.innerHeight - 210 : 400,
      selectTimeScaleValue: '2',
      selectWbsCodeRule: '',
      planform: {
        wbsName: '',
        wbsLevel: ''
      },
      progressData: [],
      nowProgressData: [],
      loading: false,
      // pagination: {
      //   currentPage: 1,
      //   pageSize: 20,
      //   total: 0
      // },
      indexRow: {
        title: '序号'
      },
      showDetail: false,
      rowObj: {},
      showAddRootIcon: false,
      // isManager: false,
      editManagement: false,
      branchFree: false,
      dragMoveDate: false,
      dragResizeDate: false,
      emptyText: '请导入进度计划',
      treeArr: [],
      saveLoading: false,
      submitLoading: false,
      progressPercent: 0,
      importLoading: false,
      // 导入列表框
      importListVisible: false,
      fileInfo: {
        name: ''
      },
      taskName: '',
      tableData: [],
      tablecolumn: [],
      // 选择人员data
      data: [],
      clickTaskInfo: {},
      screenText: '全屏',
      connectArr: [],
      maxGridHeight: 400,
      tasks: {
        data: [
        ],
        links: []
      },
      planLevelList: '',
      searchManagermentArr: '',
      optLoad: false,
      dialogVisible: false,
      auditHistoryVisble: false,
      versionHistoryVisble: false,
      versionHistoryInfoVisble: false,
      // codeRuleVisible: false,
      selVisible: false,
      editMode: '',
      formData: {
        wbsCode: '',
        levelSort: '',
        levelId: '',
        levelName: '',
        sortCode: '',
        principalId: '',
        principalName: '',
        createUser: '',
        weights: '',
        weightValue: '',
        wbsName: '',
        text: '',
        planStartDate: '',
        planDuration: '',
        forceTime: '',
        planEndDate: '',
        operate: '',
        haveTask: '',
        parentId: '',
        parent: ''
      },

      planrules: {
        wbsName: [
          { required: true, message: '请输入任务名称', tigger: 'blur' }
        ],
        planStartDate: [
          { required: true, message: '请选择计划开始时间', trigger: 'blur' }
        ],
        planEndDate: [
          { required: true, message: '请选择计划结束时间', trigger: 'blur' }
        ]
      },
      curObj: null,
      showCustomCol: false,
      allCol: [],
      selCol: []

    }
  },
  computed: {
    ...mapGetters([
      'sidebar'
    ]),
    userId() {
      return this.$store.state.user.userId
    },
    customIcon() {
      return this.showCustomCol ? 'el-icon-caret-top' : 'el-icon-caret-bottom'
    },
    gantDiv() {
      return this.$refs.gantDiv
    },
    principalArr() {
      var userArr = []
      if (this.formData.principalId) {
        const arr = this.formData.principalId.split(',')
        arr.forEach(userId => {
          userArr.push({ 'userId': userId })
        })
      }
      return userArr
    }
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
    maxHeight(v) {
      this.maxGridHeight = this.maxHeight
    },
    isManager(v) {
      this.isManager = v
    },
    isChange(v) {
      this.isChange = v
    },
    wbsLevelId(v) {
      if (!v) {
        this.wbsLevelId = v
      }
    },
    nowEditLevelId(v) {
      if (!v) {
        this.nowEditLevelId = v
      }
      console.log('wwwatchnwo', v)
    },
    nowEditLevel(v) {
      if (!v) {
        this.nowEditLevel = v
      }
    },
    nowEditLevelState(v) {
      if (!v) {
        this.nowEditLevelState = v
      }
    },
    isShowFinishBtn(v) {
      this.isShowFinishBtn = v
    },

    editManagement(v) {
      if (!v) {
        this.curObj = null
      }
    },
    'formData.forceTime': {
      handler: function(v) {
        if (!v) {
          this.formData.planStartDate = ''
          this.formData.planEndDate = ''
        }
      }

    }
  },
  created() {
    this.selectPlanLevelList()
    // const vm = this
    this.$nextTick(() => {
      if (process.env.VUE_APP_BFWEB === 'true') {
        getGlobalDepartmentMap().then(res => {
          if (res) {
            if (res.departmentId) {
              this.tentantId = res.departmentId
            }
            if (res.subDepartmentId) {
              this.tentantId = this.departmentId ? this.departmentId + ',' + res.subDepartmentId : res.subDepartmentId
            }
          }
          this.getTreeList()
        })
      } else {
        this.getTreeList()
      }
      this.setTaskGridRowBackGroundColor()
    })
  },
  mounted() {
    this.setTableColumn()
    this.editFinish = this.debounce(this.toFinish, 300)
    this.rightWidth = this.$refs.wbsEditDiv.clientWidth / 2 - 3
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
    collapseToolBar() {
      this.showInfoToolbar = false
      this.maxGridHeight = this.maxGridHeight + 68
    },
    expandToolBar() {
      this.showInfoToolbar = true
      this.maxGridHeight = this.maxGridHeight - 68
    },
    closeVersionHistoryDialog() {
      this.getTreeList()
    },
    toViewHistoryInfo(obj) {
      this.rowObj = obj
      this.versionHistoryInfoVisble = true
    },
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
    handleSel(sel) {
      let userId = ''
      let userName = ''
      sel.forEach(element => {
        if (userId) {
          userId += (',' + element.userId)
          userName += (',' + element.userName)
        } else {
          userId += element.userId
          userName += element.userName
        }
      })
      this.formData.principalId = userId
      this.formData.principalName = userName
    },

    handleChangTimeScale(v) {
      if (this.$refs.gantDiv) {
        if (v === '1') {
          this.$refs.gantDiv.setZoom('years-quarters')
        } else if (v === '2') {
          this.$refs.gantDiv.setZoom('months')
        } else if (v === '3') {
          this.$refs.gantDiv.setZoom('quarters-months')
        } else if (v === '4') {
          this.$refs.gantDiv.setZoom('weeks')
        } else {
          this.$refs.gantDiv.setZoom('days')
        }
      }
    },
    GenNonDuplicateID(randomLength) {
      return Number(Math.random().toString().substr(3, randomLength) + Date.now()).toString(36)
    },
    screenFull() {
      this.$refs.gantDiv.ganttObj.ext.fullscreen.toggle()
    },
    addTask({ obj, event }, callback) {
      // this.curObj = obj
      this.formData = {
        id: this.GenNonDuplicateID(20),
        wbsName: '',
        text: '',
        wbsCode: obj.wbsCode,
        levelId: this.wbsLevelId,
        levelName: this.nowEditLevel,
        levelSort: this.nowEditLevelId,
        weights: '',
        weightValue: '',
        planStartDate: '',
        planDuration: '',
        start_date: '',
        end_date: '',
        unscheduled: true,
        forceTime: 0,
        planEndDate: '',
        principalId: '',
        principalName: '',
        createUser: this.$store.state.user.userId,
        sortCode: obj.sortCode,
        serialNumber: obj.serialNumber ? obj.serialNumber : 1,
        operate: true,
        haveTask: false,
        parent: obj.parent,
        parentId: obj.parent,
        $open: true
      }
      this.dialogVisible = true
      this.editMode = 'add'
      if (callback instanceof Function) {
        callback()
      }
    },
    initTimeScaleValue() {
      var requestData = { projectId: this.$route.params.id }

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
          this.selectWbsCodeRule = res.data.wbsCodeRule
        } else {
          this.$message.error('初始化项目参数信息出错')
        }
      }).catch(
      ).finally(() => {
      })
    },
    zoomIn() {
      this.$refs.gantDiv.zoomIn()
    },
    zoomOut() {
      this.$refs.gantDiv.zoomOut()
    },
    doubleClick({ id, event }) {
      if (this.editManagement) {
        this.editMode = 'update'
        const curTask = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
        if (curTask[0].operate) {
          if (curTask[0].levelName === this.nowEditLevel) {
            this.formData = { ...curTask[0] } || {}
            const children = this.$refs.gantDiv.ganttObj.getChildren(this.formData.id)
            let leafNode = false
            if (children && children.length > 0) {
              for (let i = 0; i < children.length; i++) {
                const item = this.$refs.gantDiv.ganttObj.getTask(children[i])
                if (Number(this.nowEditLevelId) !== Number(item.levelSort)) {
                  // 不相等说明就是当前级别叶子节点
                  leafNode = true
                }
              }
            } else {
              leafNode = true
            }
            this.formData.prinHide = !leafNode
            this.dialogVisible = true
          } else {
            this.$message({
              showClose: true,
              type: 'info',
              message: '当前编辑的计划为' + this.nowEditLevel
            })
          }
        } else {
          this.$message.warning('只有创建人和负责人才可编辑')
        }
      }
    },
    setTableColumn(arr) {
      if (!this.$refs.gantDiv || !this.$refs.gantDiv.ganttObj) {
        return
      }
      if (this.allCol.length === 0) {
        this.allCol = [{
          name: 'wbs',
          label: '序号',
          width: 40,
          disabled: true,
          template: this.$refs.gantDiv.ganttObj.getWBSCode

        },
        {
          label: '编码',
          name: 'wbsCode',
          width: 100,
          resize: true

        },
        {
          label: '名称',
          name: 'text',
          min_width: 300,
          tree: true,
          resize: true,
          disabled: true,
          template: function(obj) {
            if (!obj.parentId || obj.parentId === '-1') {
              return ('<span style="font-weight:700">') + obj.text + ('</span>')
            } else {
              return obj.text
            }
          }
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
          label: '权值',
          name: 'weightValue',
          min_width: 60,
          align: 'center',
          resize: true
        }, {
          label: '下级负责人',
          key: 'principalId',
          name: 'principalName',
          componetType: 'select',
          min_width: 90,
          align: 'center',
          resize: true
        }]
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
        },
        {
          label: '级别',
          name: 'levelName',
          min_width: 100,
          align: 'center',
          resize: true
        },
        {
          label: '下级负责人',
          name: 'principalName',
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
    },
    getPickerOption(flag) {
      const _self = this
      return {
        disabledDate(time) {
          if (flag === 'planStartDate') {
            if (_self.formData.planEndDate) {
              return new Date(_self.formData.planEndDate).getTime() < time.getTime() // || time.getTime() <= new Date().getTime() - (1000 * 60 * 60 * 24)
            } else {
              // return time.getTime() <= new Date().getTime() - (1000 * 60 * 60 * 24)
            }
          } else if (flag === 'planEndDate') {
            if (_self.formData.planStartDate) {
              return (new Date(_self.formData.planStartDate).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
            }
          }
        }
      }
    },
    editMangementFunc() {
      this.showDetail = true
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
        projectId: this.$route.params.id ? this.$route.params.id : '1',
        wbsName: this.planform.wbsName,
        level: this.planform.wbsLevel,
        tentantId: this.tentantId
      }
      this.loading = true
      getWbsData(requestData).then(res => {
        this.loading = false
        this.treeArr = []
        this.deleteArr = []
        if (res && res.code === '200') {
          this.findTree(res.data, (item) => {
            if (item.parentId === '-1') {
              item.parentId = ''
            }

            item.label = item.wbsName
            item.value = item.id
            item.parent = item.parentId || ''
            item.text = item.wbsName
            if (item.forceTime && item.forceTime + '' === '1') { item.forceTime = true } else { item.forceTime = false }
            if (item.planStartDate && item.planEndDate) {
              item.progress = 100
              item.start_date = item.planStartDate.split(' ')[0].split('-')[2] + '-' + item.planStartDate.split(' ')[0].split('-')[1] + '-' + item.planStartDate.split(' ')[0].split('-')[0]
              // item.end_date = item.planEndDate.split(' ')[0].split('-')[2] + '-' + item.planEndDate.split(' ')[0].split('-')[1] + '-' + item.planEndDate.split(' ')[0].split('-')[0]
              item.duration = item.planDuration
              item.unscheduled = false
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
          // if (!this.curObj && this.treeArr.length > 0) {
          //   this.curObj = this.treeArr[0]
          // }
          this.tasks.data = this.treeArr
          this.tasks.links = linkArr
          this.tasks = JSON.parse(JSON.stringify(this.tasks))
        } else {
          this.maxGridHeight = 100
          this.tableData = []
          this.tasks.data = []
          this.tasks = JSON.parse(JSON.stringify(this.tasks))
        }
      }).catch(() => {
        this.loading = false
      }).finally(() => {
        if (this.curObj) {
          this.$refs.gantDiv.ganttObj.selectTask(this.curObj.id)
          this.$refs.gantDiv.ganttObj.showTask(this.curObj.id)
        }
        this.initTimeScaleValue()
      })
    },
    onAfterTaskMove(id, parent, tindex) {
      const nowTask = this.$refs.gantDiv.ganttObj.getTask(id)
      if (nowTask && parent && parent !== '-1') {
        const parentTask = this.$refs.gantDiv.ganttObj.getTask(parent)
        if (Number(parentTask.levelSort) + 1 === Number(nowTask.levelSort) || Number(parentTask.levelSort) === Number(nowTask.levelSort)) {
          return true
        }
        // else {
        //   this.$message({
        //     showClose: true,
        //     message: '不能将' + nowTask.levelName + '移动到' + parentTask.levelName + '下！',
        //     type: 'error'
        //   })
        // }
      } else if (nowTask && Number(nowTask.levelSort) === 1 && (parent === '-1' || parent === '')) {
        return true
      }
      return false
    },
    onBeforeTaskDisplay(id, task) {
      var accordNum = 0
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
      if (accordNum === 2) {
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
      } else if (this.tablecolumn[index].value === 'principalId') {
        return 100
      } else if ((this.tablecolumn[index].value === 'planEndDate' || this.tablecolumn[index].value === 'planStartDate')) {
        return 75
      } else {
        return 60
      }
    },
    // date1:小日期 date2:大日期
    DateMinus() {
      if (this.formData.planStartDate && this.formData.planEndDate) {
        getTaskDuration({ projectId: this.$route.params.id, startTime: this.formData.planStartDate, endTime: this.formData.planEndDate }).then(res => {
          if (res.state === 'success') {
            this.$set(this.formData, 'planDuration', res.data)
          } else {
            this.$message.error('计算工期时出错')
          }
        })
      }
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
          formFile.append('id', this.templateId)
          var currentIndex = 0
          if (this.curObj) {
            formFile.append('selectId', this.curObj.id)
            for (let i = 0; i < this.treeArr.length; i++) {
              if (this.treeArr[i].id === this.curObj.id) {
                currentIndex = i
                break
              }
            }
          }

          var onUploadProgress = progressEvent => {
            var complete = (progressEvent.loaded / progressEvent.total * 100 | 0)
            this.progressPercent = complete
          }
          importWbsDet(formFile, onUploadProgress).then(res => {
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
              var insertTreeArr = []
              this.findTree(res.scheWbsTempDets, (item) => {
                if (item.parentId === '-1') {
                  item.parentId = ''
                }
                item.level = item.level + ''
                insertTreeArr.push(item)
              })
              if (this.curObj) {
                insertTreeArr.unshift(currentIndex + 1, 0)
                Array.prototype.splice.apply(this.treeArr, insertTreeArr)
              } else {
                this.treeArr = this.treeArr.concat(insertTreeArr)
              }
              this.templateTable = this.toTree(this.treeArr)
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

    cancelChoseFile() {
      this.importListVisible = false
      this.resetFileInfo()
      this.resetForm('importForm')
    },
    resetFileInfo() {
      this.fileInfo = { }
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
    // 导入mpp文件
    onChange(file) {
      this.fileInfo = { ...this.fileInfo, ...file }
    },
    saveTable(isSubmit, submitMessage) {
      if (this.formData && this.formData.id && this.curObj && this.curObj.levelName === this.nowEditLevel && this.curObj.operate) {
        this.editMode = 'update'
        this.nameSubmit(() => {
          this.saveData(isSubmit, submitMessage)
        })
      } else {
        this.saveData(isSubmit, submitMessage)
      }
    },
    saveData(isSubmit, submitMessage) {
      var _self = this
      _self.treeArr = this.getTreeArrFromGantSer()
      _self.calcWeight()
      var savedata = {}
      var arrList = []
      var curLevelLeafNode = []
      for (let i = 0; i < _self.treeArr.length; i++) {
        var itemNode = _self.treeArr[i]
        if (!itemNode.parentId)itemNode.parentId = '-1'
        var tmpObj = { id: itemNode.id,
          wbsCode: itemNode.wbsCode,
          levelId: itemNode.levelId,
          level: itemNode.level,
          wbsName: itemNode.wbsName,
          principalId: itemNode.principalId,
          principalName: itemNode.principalName,
          weights: itemNode.weights,
          weightValue: itemNode.weightValue,
          sortCode: i + 1,
          parentId: itemNode.parentId,
          path: itemNode.path,
          planDuration: itemNode.planDuration,
          forceTime: itemNode.forceTime,
          createTime: itemNode.createTime,
          createUser: itemNode.createUser,
          planStartDate: itemNode.planStartDate,
          planEndDate: itemNode.planEndDate
        }
        const children = itemNode.children
        let isLeaf = Number(itemNode.levelSort) === Number(this.nowEditLevelId)
        if (children) {
          children.forEach(element => {
            // eslint-disable-next-line eqeqeq
            if (element.levelSort == Number(this.nowEditLevelId)) {
              isLeaf = false
            }
          })
        } else {
          // eslint-disable-next-line eqeqeq
          if (itemNode.levelSort != this.nowEditLevelId) {
            isLeaf = false
          }
        }
        if (isLeaf) {
          curLevelLeafNode.push(itemNode.principalId || '')
        }
        arrList.push(tmpObj)
      }
      if (curLevelLeafNode.length === 0) {
        savedata.setPrincipalFlag = '0'
      } else {
        var principalValid = true
        if (curLevelLeafNode[0]) {
          curLevelLeafNode.forEach(value => {
            if (!value) {
              principalValid = false
            }
          })
          savedata.setPrincipalFlag = '1'
        } else {
          curLevelLeafNode.forEach(value => {
            if (value) {
              principalValid = false
            }
          })
          savedata.setPrincipalFlag = '0'
        }
        if (!principalValid) {
          this.$message.warning('存在未设置下级负责人的计划，请设置下级负责人或全部清空')
          return
        }
      }
      savedata.saveList = arrList
      savedata.projectId = _self.$route.params.id
      savedata.period = this.selectTimeScaleValue
      if (this.isChange) {
        savedata.changeFlag = '1'
      } else {
        delete savedata.changeFlag
      }
      if (isSubmit === '1') {
        savedata.type = '1'
        savedata.remark = submitMessage
      } else {
        savedata.type = '0'
      }
      savedata.wbsLevelId = _self.wbsLevelId
      _self.saveLoading = true
      saveScheWbs(savedata).then(res => {
        if (res && res.code === '200') {
          this.formData = {}
          this.curObj = null
          // 隐藏保存按钮
          _self.editManagement = false
          _self.$message({ showClose: true, message: '操作成功!', type: 'success' })
          // 刷新整体进展和用户进展
          _self.getTreeList()
          _self.$emit('getWbsLevelDataList')
          this.showDetail = false
        } else {
          this.$alert('保存失败')
        }
      }).catch(() => console.log('promise catch err')).finally(() => {
        this.saveLoading = false
      })
    },
    async addNode() {
      if (this.curObj && this.curObj.parent && this.curObj.parent !== '-1') {
        // 判断当前计划级别
        const parentTask = this.$refs.gantDiv.ganttObj.getTask(this.curObj.parent)
        // 没有负责人根本无法点击编辑
        if (parentTask.principalId) {
          if (parentTask.principalId.indexOf(this.userId) === -1) {
            return this.$message({
              showClose: true,
              message: '只有负责人能编制下级计划',
              type: 'error'
            })
          }
        }
        //
        if (Number(this.curObj.levelSort) !== Number(this.nowEditLevelId)) {
          return this.$message({
            showClose: true,
            message: this.curObj.levelName + '的同级节点不能为' + this.nowEditLevel,
            type: 'error'
          })
        }
        if (Number(parentTask.levelSort) + 1 === Number(this.nowEditLevelId) || Number(parentTask.levelSort) === Number(this.nowEditLevelId)) {
          this.editMode = 'update'
          this.nameSubmit(() => {
            this.getNextTempCode('nextNode').then(nextcode => {
              // 在nextTempCode中重新组织了treeArr为修改gantt后的数据
              var curIndex1 = 0
              for (let i = 0; i < this.treeArr.length; i++) {
                if (this.treeArr[i].id === this.curObj.id) {
                  if (this.treeArr[i].children && this.treeArr[i].children.length > 0) {
                    curIndex1 = i + this.treeArr[i].children.length
                  } else {
                    curIndex1 = i
                  }
                  break
                }
              }
              this.addTask({ obj: { parent: this.curObj.parentId, sortCode: curIndex1 + 1, serialNumber: curIndex1 + 1, wbsCode: nextcode }}, () => {
                this.$refs.gantDiv.ganttObj.addTask(this.formData, this.formData.parent, this.formData.sortCode)
                this.$refs.gantDiv.ganttObj.selectTask(this.formData.id)
                this.$refs.gantDiv.ganttObj.showTask(this.formData.id)
                this.curObj = this.$refs.gantDiv.ganttObj.getTaskBy('id', this.formData.id)[0]
              })
            })
          })
        } else {
          return this.$message({
            showClose: true,
            message: this.curObj.levelName + '的同级节点不能为' + this.nowEditLevel,
            type: 'error'
          })
        }
      } else {
        // 判断当前计划级别只能为一级
        if (Number(this.nowEditLevelId) > 1) {
          return this.$message({
            showClose: true,
            message: '根节点只能添加一级计划',
            type: 'error'
          })
        } else {
          const nextcode = await this.getNextTempCode('addNode')
          // 在nextTempCode中重新组织了treeArr为修改gantt后的数据
          // 获取根节点数量
          var allNodeSum = 0
          if (this.treeArr && this.treeArr.length > 0)allNodeSum = this.treeArr.length
          if (!this.curObj) {
            this.addTask({ obj: { parent: '-1', sortCode: allNodeSum, serialNumber: allNodeSum, wbsCode: nextcode }}, () => {
              this.curObj = { ...this.formData }
              this.$refs.gantDiv.ganttObj.addTask(this.formData, this.formData.parent, this.formData.sortCode)
              this.$refs.gantDiv.ganttObj.selectTask(this.formData.id)
              this.$refs.gantDiv.ganttObj.showTask(this.formData.id)
              this.curObj = this.$refs.gantDiv.ganttObj.getTaskBy('id', this.formData.id)[0]
            })
          } else {
            this.editMode = 'update'
            this.nameSubmit(() => {
              this.addTask({ obj: { parent: '-1', sortCode: allNodeSum, serialNumber: allNodeSum, wbsCode: nextcode }}, () => {
                this.$refs.gantDiv.ganttObj.addTask(this.formData, this.formData.parent, this.formData.sortCode)
                this.$refs.gantDiv.ganttObj.selectTask(this.formData.id)
                this.$refs.gantDiv.ganttObj.showTask(this.formData.id)
                this.clickRow({ id: this.formData.id, row: this.formData })
              })
            })
          }
        }
      }
    },
    clickRow({ id, row }) {
      if (this.$refs.gantDiv.ganttObj.getSelectedId() !== id) {
        this.$refs.gantDiv.ganttObj.selectTask(id)
        this.$refs.gantDiv.ganttObj.showTask(id)
      }

      if (this.editManagement && this.formData.id && this.curObj) {
        this.editMode = 'update'
        // console.log('tag00000', this.curObj.levelName, this.nowEditLevel, this.curObj.text, this.curObj.operate)
        if (this.curObj.levelName === this.nowEditLevel && this.curObj.operate) {
          this.nameSubmit(() => {
            this.$nextTick(() => {
              const curTask = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
              this.curObj = { ...curTask[0] } || {}
              const children = this.$refs.gantDiv.ganttObj.getChildren(this.curObj.id)
              let leafNode = false
              if (children && children.length > 0) {
                for (let i = 0; i < children.length; i++) {
                  const item = this.$refs.gantDiv.ganttObj.getTask(children[i])
                  if (Number(this.nowEditLevelId) !== Number(item.levelSort)) {
                  // 不相等说明就是当前级别叶子节点
                    leafNode = true
                  }
                }
              } else {
                leafNode = true
              }

              this.curObj.prinHide = !leafNode
              this.formData = { ... this.curObj }
              this.$set(this.formData, 'wbsName', this.curObj.wbsName)
              this.$set(this.formData, 'planStartDate', this.curObj.planStartDate || '')
              this.$set(this.formData, 'planEndDate', this.curObj.planEndDate || '')
              this.dialogVisible = true
            })
          })
        } else {
          this.$nextTick(() => {
            const curTask = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
            this.curObj = { ...curTask[0] } || {}
            const children = this.$refs.gantDiv.ganttObj.getChildren(this.curObj.id)
            let leafNode = false
            if (children && children.length > 0) {
              for (let i = 0; i < children.length; i++) {
                const item = this.$refs.gantDiv.ganttObj.getTask(children[i])
                if (Number(this.nowEditLevelId) !== Number(item.levelSort)) {
                  // 不相等说明就是当前级别叶子节点
                  leafNode = true
                }
              }
            } else {
              leafNode = true
            }
            this.curObj.prinHide = !leafNode
            this.formData = { ... this.curObj }
            this.$set(this.formData, 'wbsName', this.curObj.wbsName)
            // 主要是为了绑定没有设置强制时间没有这开始时间和结束时间
            this.$set(this.formData, 'planStartDate', this.curObj.planStartDate || '')
            this.$set(this.formData, 'planEndDate', this.curObj.planEndDate || '')
            this.dialogVisible = true
          })
        }
      } else {
        const currenTask = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
        this.curObj = currenTask[0] || { }
        const children = this.$refs.gantDiv.ganttObj.getChildren(this.curObj.id)
        let leafNode = false
        if (children && children.length > 0) {
          for (let i = 0; i < children.length; i++) {
            const item = this.$refs.gantDiv.ganttObj.getTask(children[i])
            if (Number(this.nowEditLevelId) !== Number(item.levelSort)) {
              // 不相等说明就是当前级别叶子节点
              leafNode = true
            }
          }
        } else {
          leafNode = true
        }
        this.curObj.prinHide = !leafNode
        this.formData = { ...this.curObj }
        this.$set(this.formData, 'planStartDate', this.curObj.planStartDate || '')
        this.$set(this.formData, 'planEndDate', this.curObj.planEndDate || '')
      }
    },
    async addChildren() {
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      if (Number(this.curObj.levelSort) + 1 === Number(this.nowEditLevelId) || Number(this.curObj.levelSort) === Number(this.nowEditLevelId)) {
        const me = this
        // 没有负责人根本无法点击编辑
        if (me.curObj.principalId && Number(me.nowEditLevelId) === (Number(me.curObj.levelSort) + 1)) {
          if (me.curObj.principalId.indexOf(me.userId) === -1) {
            return this.$message({
              showClose: true,
              message: '只有负责人能编制下级计划',
              type: 'error'
            })
          }
        }

        const children = this.$refs.gantDiv.ganttObj.getChildren(me.curObj.id)
        if (children && children.length > 0) {
          for (let i = 0; i < children.length; i++) {
            const item = this.$refs.gantDiv.ganttObj.getTask(children[i])
            if (Number(this.nowEditLevelId) !== Number(item.levelSort)) {
              return this.$message({
                showClose: true,
                message: '该节点下已存在其他级别的计划',
                type: 'error'
              })
            }
          }
        }
        // 1. nameSbumit先更新editMOde = "update" 在addTask EditMode=add
        this.editMode = 'update'
        if (this.curObj.levelName === this.nowEditLevel && this.curObj.operate) {
          this.nameSubmit(() => {
            this.getNextTempCode('childrenNode').then(nextcode => {
              var nextIndex = 0
              var curIndex1 = 0
              for (let i = 0; i < this.treeArr.length; i++) {
                if (this.treeArr[i].id === this.curObj.id) {
                  curIndex1 = i
                  break
                }
              }

              if (this.curObj.children) {
                nextIndex = this.curObj.children.length
              }
              this.addTask({ obj: { parent: me.curObj.id, sortCode: nextIndex, serialNumber: curIndex1 + nextIndex, wbsCode: nextcode }}, () => {
              // 2.此时在addTask方法中 editMode = "add"
                this.$refs.gantDiv.ganttObj.addTask(this.formData, this.formData.parent, this.formData.sortCode)
                this.$refs.gantDiv.ganttObj.selectTask(this.formData.id)
                this.$refs.gantDiv.ganttObj.showTask(this.formData.id)
                this.curObj = this.$refs.gantDiv.ganttObj.getTaskBy('id', this.formData.id)[0]
              })
            })
          })
        } else {
          this.getNextTempCode('childrenNode').then(nextcode => {
            var nextIndex = 0
            var curIndex1 = 0
            for (let i = 0; i < this.treeArr.length; i++) {
              if (this.treeArr[i].id === this.curObj.id) {
                curIndex1 = i
                break
              }
            }

            if (this.curObj.children) {
              nextIndex = this.curObj.children.length
            }
            this.addTask({ obj: { parent: me.curObj.id, sortCode: nextIndex, serialNumber: curIndex1 + nextIndex, wbsCode: nextcode }}, () => {
              // 2.此时在addTask方法中 editMode = "add"
              this.$refs.gantDiv.ganttObj.addTask(this.formData, this.formData.parent, this.formData.sortCode)
              this.$refs.gantDiv.ganttObj.selectTask(this.formData.id)
              this.$refs.gantDiv.ganttObj.showTask(this.formData.id)
              this.curObj = this.$refs.gantDiv.ganttObj.getTaskBy('id', this.formData.id)[0]
            })
          })
        }
      } else {
        return this.$message({
          showClose: true,
          message: this.curObj.levelName + '下不能添加' + this.nowEditLevel,
          type: 'error'
        })
      }
    },
    addPrevNode() {
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      this.optData('prevNode')
    },
    addNextNode() {
      if (!this.curObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      this.optData('nextNode')
    },
    eachArr(arr, v) {
      arr.forEach((item) => {
        v(item)
        if (item.children) {
          this.eachArr(item.children, v)
        }
      })
    },
    filter(data, id) {
      var newData = data.filter(x => x.id !== id)
      newData.forEach(x => x.children && (x.children = this.filter(x.children, id)))
      return newData
    },
    delNode(selectId) {
      var _self = this
      if (_self.curObj) {
        if (_self.curObj.operate && !_self.curObj.haveTask) {
          _self.$confirm(`确定要删除该节点么?`, '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
            dangerouslyUseHTMLString: true
          }).then(() => {
            _self.$refs.gantDiv.ganttObj.unselectTask(_self.curObj.id)
            _self.$refs.gantDiv.ganttObj.deleteTask(_self.curObj.id)
            _self.curObj = null
            _self.formData = {}
          })
        } else {
          if (!_self.curObj.operate) {
            _self.$message.warning('只有创建人和负责人才可删除')
          } else {
            _self.$message.warning('该计划或子计划已经填写作业不可删除')
          }
        }
      } else {
        _self.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
    },
    up() {
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
        this.optData('demotion')
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
    beforeDestroy() {
      this.$refs.gantDiv.ganttObj.clearAll()
    },
    // type 操作类型 isOriginParent是否为祖先节点
    async optData(type) {
      var _self = this
      var curIndex1 = 0
      var parentIndex = 0
      // var parentLevelSort = 0
      var operatorArr = []
      Object.assign(operatorArr, _self.treeArr)
      var rootNodeSum = 0

      for (let i = 0; i < operatorArr.length; i++) {
        if (!operatorArr[i].parentId || operatorArr[i].parentId === '-1') {
          rootNodeSum++
        }
        if (operatorArr[i].id === _self.curObj.parent) {
          parentIndex = i
        }
        if (operatorArr[i].id === _self.curObj.id) {
          curIndex1 = i
          // break
        }
      }
      if (type === 'prevNode') {
        if (curIndex1 === 0 || curIndex1 === parentIndex + 1) {
          _self.addTask({ obj: { parent: _self.curObj.parentId, sortCode: 0, serialNumber: curIndex1 }})
        } else {
          _self.addTask({ obj: { parent: _self.curObj.parentId, sortCode: curIndex1 - parentIndex - 1, serialNumber: _self.curObj.sortCode - 1 }})
        }
      } else if (type === 'nextNode') {
        const nextcode = await this.getNextTempCode(type)
        _self.addTask({ obj: { parent: _self.curObj.parentId, sortCode: curIndex1 - parentIndex, serialNumber: _self.curObj.sortCode + 1, wbsCode: nextcode }})
      } else if (type === 'shiftUp') {
        if (curIndex1 === 0 || (curIndex1 === parentIndex + 1 && parentIndex !== 0)) { // || (curIndex1 === parentIndex + 1 && parentIndex !== 0 && rootNodeSum > 0)
          _self.$message({
            type: 'info',
            message: '第一个节点'
          })
        } else {
          // 获取上一个兄弟节点位置
          var preBrotherNodeIndex = 0
          for (let i = 0; i < operatorArr.length; i++) {
            // if (_self.curObj.parentId === '' && _self.curObj.parentId === '-1') {
            //   // 根节点单独处理
            // } else {
            if (operatorArr[i].parentId === _self.curObj.parentId) {
              if (curIndex1 === i) {
                break
              } else {
                preBrotherNodeIndex = i
              }
            }
            // }
          }
          if (preBrotherNodeIndex > 0 || (rootNodeSum > 0 && (_self.curObj.parentId === '-1' || _self.curObj.parentId === ''))) {
            // 重新排序影响的节点
            var curChildrenArr = _self.treeArr[curIndex1].children
            var operChildrenArr = _self.treeArr[preBrotherNodeIndex].children
            var childIndex = 0
            if (curChildrenArr) {
              _self.eachArr(curChildrenArr, (item) => {
                for (let j = 0; j < _self.treeArr.length; j++) {
                  if (_self.treeArr[j].id === item.id) {
                    childIndex++
                    operatorArr[preBrotherNodeIndex + childIndex] = _self.treeArr[j]
                  }
                }
              })
              childIndex++
              operatorArr[childIndex + preBrotherNodeIndex] = _self.treeArr[preBrotherNodeIndex]
              operatorArr[preBrotherNodeIndex] = _self.treeArr[curIndex1]
            } else {
              childIndex++
              operatorArr[preBrotherNodeIndex + childIndex] = _self.treeArr[preBrotherNodeIndex]// 上移是把上访节点放到最下边了，这样不准确
              operatorArr[preBrotherNodeIndex] = _self.treeArr[curIndex1]
            }

            if (operChildrenArr) {
              _self.eachArr(operChildrenArr, (item) => {
                for (let k = 0; k < _self.treeArr.length; k++) {
                  if (_self.treeArr[k].id === item.id) {
                    childIndex++
                    operatorArr[preBrotherNodeIndex + childIndex] = _self.treeArr[k]
                  }
                }
              })
            }
          } else {
            _self.$message({
              type: 'info',
              message: '第一个节点'
            })
          }
        }

        _self.tasks.data = operatorArr
        _self.treeArr = operatorArr
        for (let i = 0; i < _self.treeArr.length; i++) {
          _self.$set(_self.treeArr[i], 'sortCode', i + 1)
        }
      } else if (type === 'shiftDown') {
        // 获取下一个兄弟节点位置
        var nextBrotherNodeIndex = 0
        for (let i = 0; i < operatorArr.length; i++) {
          if (operatorArr[i].parentId === _self.curObj.parentId) {
            if (i > curIndex1) {
              nextBrotherNodeIndex = i
              break
            }
          }
        }
        if (nextBrotherNodeIndex > 0) {
          // 重新排序影响的节点
          curChildrenArr = _self.treeArr[nextBrotherNodeIndex].children// nextBrotherNodeIndex
          operChildrenArr = _self.treeArr[curIndex1].children// curIndex1
          childIndex = 0
          if (operChildrenArr) {
            _self.eachArr(operChildrenArr, (item) => {
              for (let j = 0; j < _self.treeArr.length; j++) {
                if (_self.treeArr[j].id === item.id) {
                  childIndex++
                  operatorArr[curIndex1 + childIndex] = _self.treeArr[j]// curIndex1
                }
              }
            })
            childIndex++
            operatorArr[childIndex + curIndex1] = _self.treeArr[curIndex1]// curIndex1
            operatorArr[curIndex1] = _self.treeArr[nextBrotherNodeIndex]// curIndex1   nextBrotherNodeIndex  //
          } else {
            childIndex++
            operatorArr[curIndex1] = _self.treeArr[nextBrotherNodeIndex]
            operatorArr[curIndex1 + childIndex] = _self.treeArr[curIndex1]
          }

          if (curChildrenArr) {
            _self.eachArr(curChildrenArr, (item) => {
              for (let k = 0; k < _self.treeArr.length; k++) {
                if (_self.treeArr[k].id === item.id) {
                  childIndex++
                  operatorArr[childIndex] = _self.treeArr[k]
                }
              }
            })
          }
        } else {
          _self.$message({
            type: 'info',
            message: '最后一个节点'
          })
        }
        // operatorArr[curIndex1] = operatorArr.splice(curIndex1 + 1, 1, operatorArr[curIndex1])[0]
        // }
        _self.tasks.data = operatorArr
        _self.treeArr = operatorArr
        for (let i = 0; i < _self.treeArr.length; i++) {
          _self.$set(_self.treeArr[i], 'sortCode', i + 1)
        }
      }
    },
    // 获取到修改过gantt数据的实时树
    getTreeArrFromGantSer() {
      var tasks = this.$refs.gantDiv.ganttObj.serialize()
      var data = this.convertToTreeData(tasks.data, '')
      var arr = []
      this.findTree(data, (item) => {
        arr.push(item)
      })
      return arr
    },
    convertToTreeData(data, pid) {
      const result = []
      let temp = []
      for (let i = 0; i < data.length; i++) {
        if (data[i].hasOwnProperty('children')) {
          delete data[i].children
        }
        if (data[i].parentId === '-1') {
          data[i].parentId = ''
        }
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
    getNextTempCode(addtype) {
      this.treeArr = this.getTreeArrFromGantSer()
      var nodeList = []
      var childFlag = '1'
      var isChild = '1'
      // ischild nodeList传的是父级1 子级2
      // childFlag 生成同级1子级 2
      return new Promise((resolve, reject) => {
        if (addtype === 'addNode') {
        // 获取parentId为‘’或-1的{childFlag:1,nodeList{parentId为‘’或-1的},isChild:1}

          for (let i = 0; i < this.treeArr.length; i++) {
            if (this.treeArr[i].parentId === '' || this.treeArr[i].parentId === '-1') {
              nodeList.push(this.treeArr[i].wbsCode)
            }
          }
        // childFlag = 1
        // isChild = 1
        } else if (addtype === 'childrenNode') {
        // 判断是否有子节点，有获取所有子节点{childFlag:1,nodeList{所有子},isChild:2},没有的话用父节点｛childFlag:2,nodeList{父},isChild:1｝
          var childrenNodes = this.curObj.children
          if (childrenNodes && childrenNodes.length > 0) {
            for (let i = 0; i < childrenNodes.length; i++) {
              nodeList.push(childrenNodes[i].wbsCode)
            }
            childFlag = '2'
            isChild = '2'
          } else {
            nodeList.push(this.curObj.wbsCode)
            childFlag = '2'
            isChild = '1'
          }
        } else {
        // 获取所有兄弟节点{childFlag:1,nodeList{所有兄弟},isChild:2}
          if (this.curObj.parentId === '' || this.curObj.parentId === '-1') {
            for (let i = 0; i < this.treeArr.length; i++) {
              if (this.treeArr[i].parentId === '' || this.treeArr[i].parentId === '-1') {
                nodeList.push(this.treeArr[i].wbsCode)
              }
            }
          // childFlag = 1
          // isChild = 1
          } else {
            var parentRow = ''
            for (let i = 0; i < this.treeArr.length; i++) {
              if (this.treeArr[i].id === this.curObj.parentId) {
                parentRow = this.treeArr[i]
              }
            }
            var brotherNodes = parentRow.children
            if (brotherNodes && brotherNodes.length > 0) {
              for (let i = 0; i < brotherNodes.length; i++) {
                nodeList.push(brotherNodes[i].wbsCode)
              }
              // childFlag = 1
              isChild = '2'
            }
          }
        }
        var requestParam = { codeType: '1', childFlag: childFlag, nodeList: nodeList, isChild: isChild, tempId: this.selectWbsCodeRule }
        getWbsRuleCode(requestParam).then(res => {
          if (res && res.messageCode === '200') {
            resolve(res.code)
          } else {
            this.$message({
              message: res.message,
              type: 'error'
            })
          }
        }).catch(() => {
          this.$message({
            message: '获取wbs编码失败',
            type: 'error'
          })
        })
      })
    },
    setTaskGridRowBackGroundColor() {
      var _self = this
      _self.$refs.gantDiv.ganttObj.templates.grid_row_class = function(start, end, task) {
        if (task.levelName !== _self.nowEditLevel) {
          return 'task-grid-wbs-row-background-color'
        }
        return ''
      }
    },
    cancelTable() {
      this.editManagement = false
      this.showDetail = false
      this.formData = {}
      this.curObj = null
      // this.editMangementFunc()
      this.treeArr = []
      this.findTree(this.tableData, (item) => {
        this.treeArr.push(item)
      })
      var linkArr = []
      this.treeArr.forEach(item => {
        linkArr.push({ id: item.id, source: '', target: item.id, type: '0' })
      })
      this.tasks.data = this.treeArr
      this.tasks.links = linkArr
    },
    toCancel() {
      this.dialogVisible = false
      // this.resetForm('nameForm')
    },
    nameSubmit(callBack) {
      this.$refs['nameForm'].validate((valid) => {
        if (valid) {
          this.formData = { ...this.formData }
          this.formData.$open = this.$refs.gantDiv.ganttObj.getTaskBy('id', this.formData.id)[0].$open
          this.formData.text = this.formData.wbsName
          this.formData.levelName = this.formData.levelName

          if (this.formData.forceTime && this.formData.planStartDate && this.formData.planEndDate) {
            this.formData.progress = 100
            this.formData.start_date = this.formData.planStartDate.split('-')[2] + '-' + this.formData.planStartDate.split('-')[1] + '-' + this.formData.planStartDate.split('-')[0]
            // this.formData.end_date = this.formData.planEndDate.split('-')[2] + '-' + this.formData.planEndDate.split('-')[1] + '-' + this.formData.planEndDate.split('-')[0]
            // 要包含最后一天不能设置结束时间 要通过duration去计算
            this.formData.duration = this.formData.planDuration
            this.formData.planDuration = this.formData.duration
            this.formData.unscheduled = false
          } else {
            this.formData.planStartDate = ''
            this.formData.planEndDate = ''
            this.formData.planDuration = ''
            this.formData.start_date = ''
            this.formData.duration = ' '
            this.formData.unscheduled = true
          }

          if (this.editMode === 'add') {
            this.formData.projectId = this.$route.params.id
            this.formData.parentId = this.formData.parent || ''
            this.formData.id = this.GenNonDuplicateID(20)
            var curIndex = this.formData.sortCode
            this.$refs.gantDiv.ganttObj.addTask(this.formData, this.formData.parentId, curIndex)
          } else {
            for (var key in this.formData) {
              if (key === 'start_date') {
                if (this.formData.planStartDate) {
                  this.formData.start_date = this.$refs.gantDiv.ganttObj.getTask(this.formData.id)[key] = new Date(this.formData.planStartDate)
                } else {
                  delete this.formData.start_date
                }
              } else if (key === 'end_date') {
                if (this.formData.planEndDate) {
                  const d = new Date(new Date(this.formData.planEndDate).getTime() + 24 * 60 * 60 * 1000)
                  const ed = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate()
                  this.formData.end_date = new Date(ed)
                  this.$refs.gantDiv.ganttObj.getTask(this.formData.id)[key] = new Date(ed)
                }
              } else {
                this.$refs.gantDiv.ganttObj.getTask(this.formData.id)[key] = this.formData[key]
              }
            }
            this.$refs.gantDiv.ganttObj.updateTask(this.formData.id)
          }
          const parentTaskArr = this.$refs.gantDiv.ganttObj.getTaskBy('id', this.formData.parentId)
          if (parentTaskArr.length > 0) {
            if (Number(parentTaskArr[0].levelSort) === Number(this.nowEditLevelId)) {
              this.$refs.gantDiv.ganttObj.getTask(this.formData.parentId).principalId = ''
              this.$refs.gantDiv.ganttObj.getTask(this.formData.parentId).principalName = ''
              this.$refs.gantDiv.ganttObj.updateTask(this.formData.parentId)
            }
          }
          this.dialogVisible = false
          if (callBack instanceof Function) {
            callBack()
          }
        } else {
          if (this.formData.id) {
            this.$nextTick(() => {
              this.$refs.gantDiv.ganttObj.selectTask(this.formData.id)
              this.$refs.gantDiv.ganttObj.showTask(this.formData.id)
              this.curObj = this.$refs.gantDiv.ganttObj.getTaskBy('id', this.formData.id)[0]
            })
          }
        }
      })
    },
    importWbs: function() {
      this.importListVisible = true
    },
    toWeight: function() {
      var vm = this
      if (this.formData && this.formData.id && this.curObj && this.curObj.levelName === this.nowEditLevel && this.curObj.operate) {
        this.editMode = 'update'
        this.nameSubmit(() => {
          vm.treeArr = this.getTreeArrFromGantSer()
          if (vm.treeArr && vm.treeArr.length > 0) {
            vm.$confirm(`将按计划权值生成权重，是否生成?`, '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning',
              dangerouslyUseHTMLString: true
            }).then(() => {
              this.calcWeight()
              vm.$message.success('成功生成权重')
            })
          } else {
            vm.$message({
              type: 'info',
              message: '请编制计划信息'
            })
          }
        })
      } else {
        vm.treeArr = this.getTreeArrFromGantSer()
        if (vm.treeArr && vm.treeArr.length > 0) {
          vm.$confirm(`将按权值生成权重，是否生成?`, '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
            dangerouslyUseHTMLString: true
          }).then(() => {
            this.calcWeight()
            vm.$message.success('成功生成权重')
          })
        } else {
          vm.$message({
            type: 'info',
            message: '请编制计划信息'
          })
        }
      }
    },
    calcWeight() {
      const vm = this
      var rootWeightValue = 0
      for (let i = 0; i < vm.treeArr.length; i++) {
        if (vm.treeArr[i].parentId === '' || vm.treeArr[i].parentId === '-1') {
          rootWeightValue += vm.treeArr[i].weightValue
        }
        if (vm.treeArr[i].children && vm.treeArr[i].children.length > 1) {
          var childrenNodes = vm.treeArr[i].children
          var weightSum = childrenNodes.reduce(function(prev, cur, index, arr) {
            return prev + cur.weightValue
          }, 0)
          var proportion = parseFloat(100 / weightSum).toFixed(6)
          var lastWeights = 0
          for (let j = 0, len = childrenNodes.length; j < len; j++) {
            if (j === (childrenNodes.length - 1) && childrenNodes.length > 1) {
              childrenNodes[j].weights = parseFloat(100 - lastWeights).toFixed(2)
            } else {
              childrenNodes[j].weights = parseFloat(proportion * Number(childrenNodes[j].weightValue)).toFixed(2)
              lastWeights = parseFloat(lastWeights) + parseFloat(childrenNodes[j].weights)
            }
            for (let m = 0; m < vm.treeArr.length; m++) {
              if (vm.treeArr[m].id === childrenNodes[j].id) {
                vm.treeArr[m].weights = childrenNodes[j].weights
              }
            }
          }
          vm.treeArr[i].children = childrenNodes
          // }
        } else if (vm.treeArr[i].children && vm.treeArr[i].children.length === 1) {
          vm.treeArr[i].children[0].weights = parseFloat(100).toFixed(2)
        }
      }
      if (rootWeightValue > 0) {
        var rootProportion = parseFloat(100 / rootWeightValue).toFixed(6)
        var allbrotherWeights = 0
        var lastOneWeights = 0
        var lastIndex = 0
        for (let i = 0; i < vm.treeArr.length; i++) {
          if (vm.treeArr[i].parentId === '' || vm.treeArr[i].parentId === '-1') {
            lastIndex = i
            lastOneWeights = parseFloat(rootProportion * Number(vm.treeArr[i].weightValue)).toFixed(2)
            vm.treeArr[i].weights = lastOneWeights
            allbrotherWeights = parseFloat(allbrotherWeights) + parseFloat(lastOneWeights)
          }
        }

        vm.treeArr[lastIndex].weights = parseFloat(100 + parseFloat(lastOneWeights) - parseFloat(allbrotherWeights)).toFixed(2)
      }
      vm.tasks.data = vm.treeArr
      if (this.formData.id) {
        vm.treeArr.forEach(element => {
          if (element.id === this.formData.id) {
            this.formData.weights = element.weights
          }
        })
      }
      vm.$refs.gantDiv.ganttObj.clearAll()
      vm.$refs.gantDiv.ganttObj.parse(vm.tasks)
    },
    toFinish: function(nowState) {
      var _self = this
      if (_self.editManagement) {
        _self.$message({ showClose: true, message: '计划数据正在编辑中', type: 'info' })
      } else if (!_self.nowEditLevelState || _self.nowEditLevelState === '未提交' || _self.nowEditLevelState === '退回' || _self.nowEditLevelState === '变更未提交' || _self.nowEditLevelState === '变更退回') {
        var requestData = { projectId: this.$route.params.id }
        getCompileState(requestData).then((ref) => {
          if (ref && ref.id && ref.scheEdit) {
            if (ref.scheEdit.state + '' === nowState) {
              if (this.isChange) {
                ref.scheEdit.changeFlag = '1'
              } else {
                delete ref.scheEdit.changeFlag
              }
              saveScheEdit(ref.scheEdit).then((ref) => {
                if (ref && ref.data) {
                  _self.$message({ showClose: true, message: '操作成功!', type: 'success' })
                  // _self.isManager = !_self.isManager
                  _self.$emit('getWbsLevelDataList')
                // 刷新整体进展和用户进展
                // _self.getWbsLevelDataList()
                }
              }).catch((err) => {
                console.error(err)
              })
            } else {
              _self.$message({ showClose: true, message: '已执行过该操作，请刷新页面!', type: 'info' })
            }
          } else {
            _self.$message({ showClose: true, message: '操作失败!', type: 'info' })
          }
        }).catch((err) => {
          console.error(err)
        })
        // row.wbsLevelId = _self.wbsLevelId
      } else {
        _self.$message({ showClose: true, message: '数据已提交审批，不能取消', type: 'info' })
      }
    },
    toVersionView: function() {
      this.versionHistoryVisble = true
    },
    searchPlan: function() {
      this.$refs.gantDiv.ganttObj.refreshData()
    },

    submitVersion: function() {
      var _self = this
      _self.treeArr = this.getTreeArrFromGantSer()
      if (_self.treeArr && _self.treeArr.length > 0) {
        _self.$prompt('<span style="color:red">*</span>说明：提交后，当前实例自动生成一个新版本', '提交说明', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          inputType: 'textarea',
          dangerouslyUseHTMLString: true,
          inputValidator: function(obj) {
            if (obj == null || obj === '') return '请输入提交说明'
          }
        }).then(({ value }) => {
          var savedata = {}
          var arrList = []
          for (let i = 0; i < _self.treeArr.length; i++) {
            var itemNode = _self.treeArr[i]
            if (!itemNode.parentId)itemNode.parentId = '-1'
            var tmpObj = { id: itemNode.id,
              levelId: itemNode.levelId,
              wbsCode: itemNode.wbsCode,
              level: itemNode.level,
              wbsName: itemNode.wbsName,
              principalId: itemNode.principalId,
              weights: itemNode.weights,
              weightValue: itemNode.weightValue,
              sortCode: itemNode.sortCode,
              parentId: itemNode.parentId,
              path: itemNode.path,
              planDuration: itemNode.planDuration,
              forceTime: itemNode.forceTime,
              createTime: itemNode.createTime,
              createUser: itemNode.createUser,
              planStartDate: itemNode.planStartDate,
              planEndDate: itemNode.planEndDate
            }
            arrList.push(tmpObj)
          }
          savedata.saveList = arrList
          savedata.projectId = _self.$route.params.id
          savedata.wbsLevelId = _self.wbsLevelId
          savedata.remark = value
          _self.submitLoading = true
          saveWbsVersion(savedata).then(res => {
            _self.$message({ showClose: true, message: '保存成功!', type: 'success' })
          }).finally(() => {
            _self.submitLoading = false
          })
        }).catch(() => {
          _self.$message({
            type: 'info',
            message: '取消输入'
          })
        })
      } else {
        _self.$message({
          type: 'info',
          message: '请编制计划信息'
        })
      }
    }
  }

}
</script>

<style lang="scss" scoped>
#wbsEditDiv .pageDiv{
  width: 100%;
  height: 100%;
  position: absolute;
}

.el-form-item{
  margin-bottom: 5px;
}
/deep/ .el-card__header {
    padding: 5px 20px;
    border-bottom: 1px solid #EBEEF5;
    box-sizing: border-box;
}
/deep/ .gantt_grid_data .task-grid-wbs-row-background-color,
.gantt_grid_data .task-grid-wbs-row-background-color.odd {
background-color:#DCDFE6!important;
}
</style>
