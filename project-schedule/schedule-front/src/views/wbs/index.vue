<template>
  <div ref="pageDiv" class="app-container">
    <el-tabs
      v-model="activeName"
      type="border-card"
      class="h-100"
      @tab-click="handleClick"
    >
      <el-tab-pane label="WBS信息" name="wbsplanedit" class="h-100">
        <WbsEdit
          v-if="!changeWbsImportProcess"
          ref="wbsEditTab"
          :max-height="maxHeight"
          :is-manager="isManager"
          :is-change="isChange"
          :wbs-level-id="wbsLevelId"
          :sche-level-users="scheLevelUsers"
          :now-edit-level-id="nowEditLevelId"
          :now-edit-level="nowEditLevel"
          :now-edit-level-state="nowEditLevelState"
          :is-show-finish-btn="isShowFinishBtn"
          :max-level="maxLevel"
          @getWbsLevelDataList="getWbsLevelDataList"
        />
        <!-- wbs编制方式为导入 -->
        <div v-else class="importBox">
          <el-row>
            <el-form :model="searchform" size="mini" label-width="auto" style="margin-left:10px;margin-top:3px;">
              <el-row :gutter="6">
                <el-col :xl="4" :lg="4" :md="4" :sm="4" :xs="4">
                  <el-form-item label="名称">
                    <el-input v-model="searchform.wbsName" placeholder="名称" clearable />
                  </el-form-item>
                </el-col>
                <el-col :xl="4" :lg="4" :md="4" :sm="4" :xs="4">
                  <el-form-item label="级别">
                    <el-select v-model="searchform.levelCode" placeholder="级别" clearable>
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
                  <el-button type="primary" size="mini" icon="el-icon-search" @click="searchNode">查询</el-button>

                  <el-button v-if="!editWbsImport" type="primary" size="mini" @click="startEdit">编辑</el-button>
                  <span v-if="editWbsImport" style="margin-left: 10px">
                    <el-button type="primary" :loading="saveLoading" size="mini" @click="saveEdit">保存</el-button>
                    <el-button style="margin-right: 10px" size="mini" @click="cancelEdit">取消</el-button>
                  </span>
                  <span v-if="!editWbsImport" style="margin-left: 10px">
                    <el-button type="primary" size="mini" @click="finishImport">导入完成</el-button>
                  </span>
                </el-col>
              </el-row>
            </el-form>
          </el-row>
          <el-row v-if="editWbsImport">
            <el-button type="text" style="font-size:14px;margin-left:10px;" @click="expandAll">全部展开</el-button>
            <el-button type="text" style="font-size:14px;" @click="collapseAll">全部收起</el-button>
            <el-button type="text" style="font-size:14px;" @click="addNewNode">新增同级节点</el-button>
            <el-button type="text" style="font-size:14px;" @click="addNewChildNode">新增子节点</el-button>
            <el-button type="text" style="font-size:14px;" @click="deleteNode">删除</el-button>
            <el-button type="text" style="font-size:14px;" @click="shiftUpNode">上移</el-button>
            <el-button type="text" style="font-size:14px;" @click="shiftDownNode">下移</el-button>

            <el-button type="primary" size="mini" style="float:right;" @click="importDialogVisible = true">导入</el-button>
            <el-button type="primary" size="mini" style="float:right;" @click="handleGenerateWeights(1)">自动生成权重</el-button>
          </el-row>
          <el-row>
            <el-table
              ref="wbsDataRef"
              :data="wbsData"
              style="width: 100%;margin-bottom: 20px;"
              row-key="id"
              highlight-current-row
              :header-cell-class-name="getHeaderClassImport"
              border
              default-expand-all
              :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
              @row-click="rowClick"
            >
              <el-table-column type="index" label="序号" width="60" align="center" />
              <el-table-column prop="wbsCode" label="编码" header-align="center" />
              <el-table-column prop="wbsName" label="名称" align="center">
                <template slot-scope="scope">
                  <p v-if="!editWbsImport">{{ scope.row.wbsName }}</p>
                  <el-input v-else v-model="scope.row.wbsName" />
                </template>
              </el-table-column>
              <el-table-column align="center" label="级别" width="150">
                <template slot-scope="scope">
                  <p v-if="!editWbsImport">{{ planLevelList[scope.row.levelCode - 1].name }}</p>
                  <el-select v-else v-model="scope.row.levelCode" clearable @change="verifyLevelRule(scope.$index,scope.row)">
                    <el-option
                      v-for="item in planLevelList"
                      :key="item.dictCode"
                      :label="item.name"
                      :value="item.dictCode"
                    />
                  </el-select>
                </template>
              </el-table-column>
              <el-table-column prop="weights" label="权重(%)" align="center" width="150" />
              <el-table-column align="center" label="权值" width="150">
                <template slot-scope="scope">
                  <p v-if="!editWbsImport">{{ scope.row.weightValue }}</p>
                  <el-input-number v-else v-model="scope.row.weightValue" controls-position="right" :min="1" :max="5" @change="toInteger(scope.$index, scope.row)" />
                </template>
              </el-table-column>
            </el-table>
          </el-row>
        </div>
      </el-tab-pane>
      <el-tab-pane label="编制进展" name="wbsplaneditprocess" class="h-100">
        <div ref="processDiv" :style="{'height': scrollerHeight+'px','overflow':'auto'}" class="clearfix">
          <el-card v-if="showWbsImportProcess" :body-style="{ padding: '0px 0px 0px' }">
            <div ref="cardoneheader" slot="header" class="clearfix">
              <span>wbs导入进展</span>
            </div>
            <!-- 表格 -->
            <div ref="tablewrap">
              <el-table ref="wbsImportTable" :data="wbsImportData" border size="mini">
                <el-table-column label="最近编辑人员" prop="editUserName" width="110" align="center" />
                <el-table-column label="最近编辑时间" prop="editTime" align="center" />
                <el-table-column label="最近提交审批时间" prop="completeTime" align="center" />
                <el-table-column label="编制状态" prop="state" width="80" align="center">
                  <template slot-scope="scope">
                    <span v-if="scope.row.state === '1'">已完成</span>
                    <span v-else>未完成</span>
                  </template>
                </el-table-column>
                <el-table-column label="审批状态" prop="approvalStateName" width="80" align="center" />
                <el-table-column label="审批次数" prop="approvalNum" width="80" align="center" />
                <el-table-column label="操作" width="160">
                  <template slot-scope="scope">
                    <span>
                      <el-link :underline="false" type="primary" @click="toChangeWbsImport(scope.row)">变更</el-link>
                      |
                    </span>
                    <el-link :underline="false" type="primary" @click="showScheApproveList(scope.row)">审批记录</el-link>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </el-card>
          <el-card :body-style="{ padding: '0px 0px 0px' }">
            <div ref="cardoneheader" slot="header" class="clearfix">
              <span>wbs整体进展</span>
            </div>
            <!-- 表格 -->
            <div ref="tablewrap">
              <el-table ref="table" :data="progressData" border size="mini">
                <el-table-column label="序号" type="index" width="60" align="center" />
                <el-table-column label="级别" prop="levelName" width="100" align="center" />
                <el-table-column label="最近编辑人员" prop="updateUser" width="110" align="center" />
                <el-table-column label="最近编辑时间" prop="updateTime" align="center" />
                <el-table-column label="最近提交审批时间" prop="applyTime" align="center" />
                <el-table-column label="编制状态" prop="compileStateName" width="80" align="center" />
                <el-table-column label="审批状态" prop="stateName" width="80" align="center" />
                <el-table-column label="审批次数" prop="aprovalNum" width="80" align="center" />
                <el-table-column label="操作" width="160">
                  <template slot-scope="scope">
                    <span v-if="scope.row.approval == '1' && scope.row.inProcess == '1' && (scope.row.stateName== '未提交'||scope.row.stateName== '退回'||scope.row.stateName== '变更退回'||scope.row.stateName== '变更未提交'||!scope.row.stateName) && scope.row.compileStateName== '已完成'">
                      <el-link :underline="false" type="primary" @click="toOperation(scope.row,'1')">提交审批</el-link>
                      |
                    </span>
                    <span v-if="scope.row.stateName == '审批通过' ">
                      <el-link :underline="false" type="primary" @click="toChange(scope.row)">变更</el-link>
                      |
                    </span>
                    <el-link :underline="false" type="primary" @click="toViewFlow(scope.row)">审批记录</el-link>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </el-card>
          <el-card :body-style="{ padding: '0px 0px 0px' }" style="margin-top:3px;">
            <div ref="cardtwoheader" slot="header" class="clearfix">
              <span>wbs当前用户进展</span>
            </div>
            <!-- 表格 -->
            <div ref="nowtablewrap">
              <el-table ref="nowtable" :data="nowProgressData" border size="mini">
                <el-table-column label="序号" type="index" width="60" align="center" />
                <el-table-column label="级别" prop="levelName" width="100" align="center" />
                <el-table-column label="是否正在编辑" prop="state" width="160" align="center">
                  <template slot-scope="scope">
                    <span v-if="scope.row.inProcess == 1">
                      是
                    </span>
                    <span v-if="scope.row.inProcess == 0 ">
                      否
                    </span>
                  </template>
                </el-table-column>
                <el-table-column label="最近编辑人员" prop="editUser" align="center" />
                <el-table-column label="最近编辑时间" prop="editTime" align="center" />
                <el-table-column label="操作" width="140" align="center">
                  <template slot-scope="scope">
                    <span v-if="scope.row.state == '1' && scope.row.inProcess == 1">
                      <el-link :underline="false" type="primary" @click="editFinish(scope.row)">取消完成</el-link>
                    </span>
                    <span v-if="scope.row.state == '0' && scope.row.inProcess == 1">
                      <el-link :underline="false" type="primary" @click="editFinish(scope.row)">编制完成</el-link>
                    </span>
                  </template>
                </el-table-column>
              </el-table>
            </div>
          </el-card>
        </div>
      </el-tab-pane>

    </el-tabs>
    <el-dialog :visible.sync="auditHistoryVisble" width="50%" :show-close="true" title="审批记录" :close-on-click-modal="false">
      <wbsAuditHistoryView v-if="auditHistoryVisble" :wbs-level-id="flowLevelId" :level-name="flowLevelName" />
    </el-dialog>

    <!-- <el-dialog
      title="导入进度计划"
      :visible.sync="importDialogVisible"
      width="350px"
    >
      <p style="float:left;line-height:6px;margin-right:10px;">
        <span style="color:red;font-size:16px;">*</span>
        选择文件
      </p>
      <el-upload
        action=""
        :on-change="onChange"
        :auto-upload="false"
      >
        <el-button size="small" type="primary">点击上传</el-button>
      </el-upload>
      <span slot="footer" class="dialog-footer">
        <el-button @click="importDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="sureUpload">确 定</el-button>
      </span>
    </el-dialog> -->
    <el-dialog :visible.sync="importLoading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>
    <el-dialog :visible.sync="importDialogVisible" width="400px" :show-close="false" title="导入进度计划" :close-on-click-modal="false">
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
        <el-button type="primary" size="mini" @click="sureUpload">确定</el-button>
        <el-button size="mini" @click="cancelImport">取消</el-button>
      </span>
    </el-dialog>

    <el-dialog
      title="审批记录"
      :visible.sync="scheApproveDialogVisible"
      width="80%"
    >
      <el-table
        :data="scheApproveList"
        border
        size="mini"
        max-height="460"
        height="460"
      >
        <el-table-column label="提交人" prop="applyUserName" />
        <el-table-column label="提交审批时间" prop="applyTime" />
        <el-table-column label="提交说明" prop="remark" />
        <el-table-column label="当前状态" prop="stateName" />
        <el-table-column label="审批通过时间" prop="completeTime" />
        <el-table-column label="审批人" prop="approvalUserName" />
        <!-- <el-table-column label="操作">
          <template slot-scope="scope">
            <el-link :underline="false" type="primary" @click="handleBpmImg(scope.$index, scope.row)">查看</el-link>
          </template>
        </el-table-column> -->
      </el-table>
    </el-dialog>

    <el-dialog
      title="级别设置"
      :visible.sync="setLevelDialogVisible"
      style="width:100%;margin-left:40px;margin-top:10px"
    >
      <el-table
        ref="wbsTable"
        :data="paramsData.scheWbsLevelList"
        border
        stripe
        :header-cell-class-name="getHeaderClass"
        :cell-class-name="addClass"
        style="width:90%;margin-left:40px;margin-top:10px"
        row-key="id"
        empty-text="暂无数据"
      >
        <el-table-column
          type="index"
          label="序号"
          width="60"
        />
        <el-table-column
          v-for="(col,index) in levelColumn"
          :key="index"
          :prop="col.value"
          :label="col.title"
          :min-width="col.width?col.width:'100'"
        >
          <template slot-scope="scope">
            <span v-if="levelColumn[index].type==='select'">
              <el-select v-model="scope.row[levelColumn[index].key]" @change="changeApprove(scope.row,scope.$index)">
                <el-option
                  v-for="item in approvalArr"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </span>
            <span v-else-if="levelColumn[index].type==='opt'">
              <el-button v-if="scope.row.type === 0 && scope.row.level != 1 && scope.row.levelName !== '一级计划'" type="text" @click="delLevel(scope.$index, scope.row)">删除</el-button>
            </span>
            <div
              v-else-if="levelColumn[index].type==='click'"
              style="height: 30px;border: #DCDFE6 1px solid; border-radius: 4px;background: white; line-height: 30px;"
              @click="showRoleList(scope.$index, scope.row, levelColumn[index].key)"
            >
              {{ scope.row[levelColumn[index].key] }}
            </div>
            <span v-else> {{ scope.row[levelColumn[index].key] }}</span>
          </template>
        </el-table-column>
      </el-table>
      <span slot="footer" class="dialog-footer">
        <el-button @click="setLevelDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="sureFinishImport">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title="角色选择"
      :visible.sync="showRoles"
      width="800px"
      :close-on-click-modal="false"
      @close="showRoles = false"
    >
      <div style="height:500px">
        <PersonPermission style="height:500px" select-type-mode="single" @selectRow="selectRoles" />
      </div>
    </el-dialog>
    <SelectPerople ref="human" :visible.sync="humanDialogVisible" sel-type="single" :is-fweb="true" :b-project-select="true" :add-account="false" @sure="closeHumanDialog" />
    <div v-if="dialogComplete">
      <iframe ref="bpmiframe" :src="completeTask" frameborder="no" border="0" height="100%" width="100%" style="position:fixed;top:0;left:0;scrolling:no;z-index:2" />
    </div>

  </div>

</template>

<script>
import { getDictByItemId, getWbsLevelData, getCurrentUserLevel, saveScheEdit, saveWbsVersion, submitApproval, getWbsRuleCode, wbsImport, importWbsSave, importMMPEditMsg, getProjectWbsLevels, editMMPAccomplish, getWbsImportData } from '@/api/wbsPlan'
import { getProjectParams } from '@/api/projectSet'
import WbsAuditHistoryView from './WbsAuditHistoryView.vue'
import WbsEdit from './WbsEdit.vue'
import PersonPermission from '@/views/projectSet/resource/PersonPermission'
import SelectPerople from '@/components/SelectPeople'
import { mapGetters } from 'vuex'
export default {
  name: 'WbsDetail',
  components: {
    WbsAuditHistoryView,
    WbsEdit,
    PersonPermission,
    SelectPerople
  },
  props: {

  },
  data() {
    return {
      editFinish: null,
      changeFlag: false,
      scheApproveDialogVisible: false,
      scheApproveList: [], // wbs导入审批记录数组
      wbsImportData: [], // 导入进展数据
      // 级别设置
      curRoleRow: {},
      showRoles: false,
      humanDialogVisible: false,
      setLevelDialogVisible: false,
      levelColumn: [
        {
          title: '级别',
          key: 'levelName',
          width: 60
        },
        {
          title: '编制角色',
          key: 'roleName',
          width: 150,
          type: 'click'
        },
        {
          title: '是否需要审批',
          key: 'approval',
          type: 'select',
          width: 100
        },
        {
          title: '审批上级',
          key: 'approveUserName',
          width: 100,
          type: 'click'
        },
        {
          title: '操作',
          type: 'opt',
          width: 80
        }

      ],
      approvalArr: [{ label: '是', value: 1 }, { label: '否', value: 0 }],
      paramsData: {
        scheWbsLevelList: []
      },
      tempId: '', // 编码规则id
      progressPercent: 0,
      importLoading: false,
      showWbsImportProcess: false, // 显示wbs导入进展
      changeWbsImportProcess: false, // 显示wbs变更表格
      searchform: {
        wbsName: '',
        levelCode: ''
      },
      editWbsImport: false,
      dataBeforEdit: [],
      wbsDataCopyArr: [],
      wbsData: [],
      currentNode: '',
      importDialogVisible: false,
      fileInfo: {
        name: ''
      },
      wbsTree: [],

      // tableHeight: window.innerHeight > 200 ? window.innerHeight - 210 : 400,
      activeName: 'wbsplanedit',
      selectTimeScaleValue: 1,
      progressData: [],
      nowProgressData: [],
      loading: false,
      maxLevel: '1',
      indexRow: {
        title: '序号'
      },
      rowObj: {},
      // showAddRootIcon: false,
      isManager: false,
      isChange: false,
      editManagement: false,
      isShowFinishBtn: true,
      branchFree: false,
      dragMoveDate: false,
      dragResizeDate: false,
      flowLevelId: '', // 计划级别id(查看审批记录用)
      flowLevelName: '', // 计划级别名称(查看审批记录用)
      nowEditLevelId: '', // 当前正在编辑的计划级别code
      nowEditLevel: '', // 当前正在编辑的计划级别名称
      nowEditLevelState: '', // 当前正在编辑的计划级别审批状态
      wbsLevelId: '', // 当前正在编辑的计划级别主键ID
      scheLevelUsers: '', // 当前级别对应角色的全部人员
      wbsLevelInfoId: '',
      emptyText: '请导入进度计划',
      treeArr: [],
      saveLoading: false,
      taskName: '',
      tableData: [],
      tablecolumn: [],
      // 选择人员data
      data: [],
      clickTaskInfo: {},
      screenText: '全屏',
      connectArr: [],
      maxGridHeight: 200,
      tasks: {
        data: [
        ],
        links: []
      },
      planLevelList: '',
      optLoad: false,
      dialogVisible: false,
      auditHistoryVisble: false,
      versionHistoryVisble: false,
      versionHistoryInfoVisble: false,
      editMode: '',
      formData: {
        wbsCode: '',
        levelSort: '',
        levelId: '',
        levelName: '',
        sortCode: '',
        principalId: '',
        principalName: '',
        wbsName: '',
        text: '',
        planStartDate: '',
        planDuration: '',
        planEndDate: '',
        parentId: '',
        parent: ''
      },
      dialogComplete: false,
      completeTask: '',
      rules: {
        wbsName: [
          { required: true, message: '请输入任务名称', tigger: ' ' }
        ]
      },
      curObj: null,
      maxHeight: 400,
      scrollerHeight: 400

    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  watch: {
    dialogVisible(v) {
      if (!v) {
        this.resetForm('nameForm')
      }
    },
    editManagement(v) {
      if (!v) {
        this.curObj = null
      }
    },
    'wbsData': {
      handler(newVal, oldVal) {
        console.log('监听', oldVal, newVal)
      },
      deep: true
    }
  },
  created() {
    this.porjectWbsData()
    this.selectPlanLevelList()
    this.getWbsLevelDataList()
    window.tohiddenIFrame = () => {
      this.dialogComplete = false
    }
  },
  mounted() {
    this.$nextTick(() => {
      this.editFinish = this.debounce(this.toFinish, 300)
      this.maxHeight = this.$refs.pageDiv.clientHeight - this.$refs.cardoneheader.offsetHeight - this.$refs.cardtwoheader.offsetHeight - this.$refs.tablewrap.offsetHeight - this.$refs.nowtablewrap.offsetHeight - 180
      this.scrollerHeight = this.$refs.pageDiv.clientHeight - 58
    })
  },
  methods: {
    toInteger(index, row) {
      // console.log(row)
      if (row.weightValue === 'undefined' || row.weightValue === undefined || row.weightValue === '' || row.weightValue === null || row.weightValue === 'null') {
        // console.log(1)
        this.$message.info('只能输入整数')
        this.$nextTick(() => {
          row.weightValue = 1
        })
      } else {
        // console.log(2)
        const reg = /^[0-9]+$/
        if (!reg.test(row.weightValue)) {
          this.$message.info('只能输入整数')
          this.$nextTick(() => {
            row.weightValue = parseInt(row.weightValue)
          })
        }
      }
    },
    // 审批记录
    showScheApproveList() {
      this.scheApproveDialogVisible = true
    },
    // 确定完成导入
    sureFinishImport() {
      var data = {
        scheWbsLevels: this.paramsData.scheWbsLevelList,
        projectId: this.$route.params.id
      }

      // 处理level的序号
      var requiredLevel = ''
      for (let i = 0; i < this.paramsData.scheWbsLevelList.length; i++) {
        this.paramsData.scheWbsLevelList[i].sort = i + 1
        var levelField = ''
        if (!this.paramsData.scheWbsLevelList[i].scheRoleLevelList || this.paramsData.scheWbsLevelList[i].scheRoleLevelList.length === 0) {
          levelField = '角色'
        }
        if (this.paramsData.scheWbsLevelList[i].approval === 1 && !this.paramsData.scheWbsLevelList[i].approveUser) {
          levelField = levelField ? levelField + '、审批上级' : '审批上级'
        }
        if (levelField) {
          requiredLevel = requiredLevel + (requiredLevel ? ',第' : '第') + (i + 1) + '行的' + levelField
        }
      }

      if (requiredLevel) {
        this.$alert('请填写' + requiredLevel, '提示', {
          center: true,
          showConfirmButton: false
        })
        return
      } else {
        editMMPAccomplish(data).then(async res => {
          this.setLevelDialogVisible = false
          this.$message.success('导入完成')
          this.changeWbsImportProcess = false
          this.porjectWbsData()
          this.selectPlanLevelList()
          this.getWbsLevelDataList()
          window.tohiddenIFrame = () => {
            this.dialogComplete = false
          }
          this.$nextTick(() => {
            this.maxHeight = this.$refs.pageDiv.clientHeight - this.$refs.cardoneheader.offsetHeight - this.$refs.cardtwoheader.offsetHeight - this.$refs.tablewrap.offsetHeight - this.$refs.nowtablewrap.offsetHeight - 180
            this.scrollerHeight = this.$refs.pageDiv.clientHeight - 58
          })
        })
      }
    },
    cancelImport() {
      this.$refs.uploadPlan.clearFiles()
      this.fileInfo = {
        name: ''
      }
      this.importDialogVisible = false
    },
    // 获取项目wbs编制方式 和 获取项目tempId
    porjectWbsData() {
      // var params = {
      //   projectId: this.$route.params.id
      // }
      // getWbsEditType(params).then(res => {
      //   console.log('wbs编制方式', res)
      //   if (res && res === 1) {
      //     this.changeWbsImportProcess = true
      //   }
      // })
      // 获取wbs树
      var params = {
        projectId: this.$route.params.id,
        wbsName: this.searchform.wbsName,
        level: this.searchform.levelCode
      }
      getWbsImportData(params).then(res => {
        // console.log('wbsdata', res)
        if (res && res.code === '200') {
          this.wbsData = res.data || []
          this.wbsDataCopyArr = []
          this.findTree(this.wbsData, el => {
            // if (el.children) {
            //   this.$set(el, 'children', el.children)
            // } else {
            //   this.$set(el, 'children', [])
            // }
            this.wbsDataCopyArr.push(el)
          }) // 保存数据
        }
      })
      // 获取项目所有信息
      getProjectParams({ projectId: this.$route.params.id }).then(res => {
        // console.log('项目信息', res)
        if (res) {
          if (res.data.wbsEditType && res.data.wbsEditType === '1') { // wbs编制方式为导入
            if (res.data.wbsEditState === '1') { // 导入已完成
              this.changeWbsImportProcess = false
            } else { // 导入未完成
              this.changeWbsImportProcess = true
            }
            this.showWbsImportProcess = true
          }
          this.tempId = res.data.wbsCodeRule
        }
      })
    },
    // 树变数组
    getWbsTree() {
      var arr = []
      this.findTree(this.wbsData, (item) => {
        arr.push(item)
      })
      return arr
    },
    // 自动生成权重
    handleGenerateWeights(type) {
      var vm = this
      if (type === 1) {
        if (!vm.wbsData || vm.wbsData.length === 0) {
          return this.$message({
            message: '请先导入数据',
            type: 'info'
          })
        } else {
          var flag = true
          this.wbsDataCopyArr.forEach(el => {
            if (el.weightValue === undefined || el.weightValue === null) {
              flag = false
            }
          })
          if (flag) {
            vm.$confirm(`将按计划权值生成权重，是否生成？`, '提示', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              type: 'warning',
              dangerouslyUseHTMLString: true
            }).then(() => {
              vm.wbsTree = vm.getWbsTree()
              vm.caclWeight()
              this.$message.success('成功生成权重')
            })
          } else {
            return this.$message({
              message: '请填写好所有数据的权值',
              type: 'info'
            })
          }
        }
      } else {
        vm.wbsTree = vm.getWbsTree()
        vm.caclWeight()
        this.$message.success('成功生成权重')
      }
    },
    caclWeight() {
      const vm = this
      var rootWeightValue = 0
      for (let i = 0; i < vm.wbsTree.length; i++) {
        if (vm.wbsTree[i].parentId === '' || vm.wbsTree[i].parentId === '-1') {
          rootWeightValue += vm.wbsTree[i].weightValue
        }
        if (vm.wbsTree[i].children && vm.wbsTree[i].children.length > 1) {
          var childrenNodes = vm.wbsTree[i].children
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
            for (let m = 0; m < vm.wbsTree.length; m++) {
              if (vm.wbsTree[m].id === childrenNodes[j].id) {
                vm.wbsTree[m].weights = childrenNodes[j].weights
              }
            }
          }
          vm.wbsTree[i].children = childrenNodes
          // }
        } else if (vm.wbsTree[i].children && vm.wbsTree[i].children.length === 1) {
          vm.wbsTree[i].children[0].weights = parseFloat(100).toFixed(2)
        }
      }
      if (rootWeightValue > 0) {
        var rootProportion = parseFloat(100 / rootWeightValue).toFixed(6)
        var allbrotherWeights = 0
        var lastOneWeights = 0
        var lastIndex = 0
        for (let i = 0; i < vm.wbsTree.length; i++) {
          if (vm.wbsTree[i].parentId === '' || vm.wbsTree[i].parentId === '-1') {
            lastIndex = i
            lastOneWeights = parseFloat(rootProportion * Number(vm.wbsTree[i].weightValue)).toFixed(2)
            vm.wbsTree[i].weights = lastOneWeights
            allbrotherWeights = parseFloat(allbrotherWeights) + parseFloat(lastOneWeights)
          }
        }

        vm.wbsTree[lastIndex].weights = parseFloat(100 + parseFloat(lastOneWeights) - parseFloat(allbrotherWeights)).toFixed(2)
      }
      vm.wbsData = vm.toTree(vm.wbsTree)
    },
    // 级别设置
    selectRoles({ row }) {
      this.paramsData.scheWbsLevelList.forEach(element => {
        if (element.level === this.curRoleRow.level) {
          var dict = { roleId: row.id, rowName: row.roleName }
          element.scheRoleLevelList = [dict]
          this.$set(element, 'roleName', row.roleName)
        }
      })
      this.showRoles = false
    },
    closeHumanDialog(data) {
      this.paramsData.scheWbsLevelList.forEach(element => {
        if (element.level === this.curRoleRow.level) {
          if (data && data[0] && data.length > 0) {
            element.approveUser = data[0].userId
            this.$set(element, 'approveUserName', data[0].userName)
          } else {
            element.approveUser = ''
            this.$set(element, 'approveUserName', '')
          }
        }
      })
      this.humanDialogVisible = false
    },
    finishImport() {
      // if (!this.paramsData.scheWbsLevelList || this.paramsData.scheWbsLevelList.length === 0) {
      //   this.paramsData.scheWbsLevelList = [{ 'levelName': '一级计划', 'wbsLevel': '1', 'projectId': this.$route.params.id, 'type': 0, 'approval': 1, 'scheRoleLevelList': []
      //   }, { 'levelName': '作业', 'wbsLevel': null, 'projectId': this.$route.params.id, 'type': 1, 'approval': 1, 'scheRoleLevelList': []
      //   }]
      // }
      if (!this.wbsData || this.wbsData.length === 0) {
        return this.$message({
          message: '请导入WBS数据',
          type: 'info'
        })
      } else {
        var param = {
          projectId: this.$route.params.id
        }
        getProjectWbsLevels(param).then(res => {
          console.log(res)
          if (res && res.code === '200') {
            this.paramsData.scheWbsLevelList = res.data
            this.setLevelDialogVisible = true
          }
        })
      }
    },
    changeApprove(item, index) {
      if (item.approval === 0) {
        item.approveUser = ''
        this.$set(this.paramsData.scheWbsLevelList[index], 'approveUserName', '')
      }
    },
    delLevel(index, row) {
      this.paramsData.scheWbsLevelList.splice(index, this.paramsData.scheWbsLevelList.length - (index + 1))
    },
    showRoleList(index, row, key) {
      if (key === 'roleName') {
        this.curRoleRow = row
        this.showRoles = true
      } else if (key === 'approveUserName') {
        this.curRoleRow = row
        this.humanDialogVisible = true
      }
      console.log(this.curRoleRow)
    },
    getHeaderClass({ row, rowIndex, column, columnIndex }) {
      if (columnIndex === 4 || columnIndex === 0) {
        return 'tableHeader'
      } else {
        return 'must'
      }
    },
    getHeaderClassImport({ row, rowIndex, column, columnIndex }) {
      if (this.editWbsImport && (columnIndex === 2 || columnIndex === 3 || columnIndex === 5)) {
        return 'must'
      } else {
        return 'tableHeader'
      }
    },
    addClass({ row, columnIndex }) {
      return 'justcenter'
    },
    // 校验
    verifyLevelRule(index, row) {
      var parentLevel = ''
      // let treeIndex = 0
      var parentNode = {}
      var flag = true
      var limit = ''
      var childrenlimit = ''
      var empty = true
      if (!row.parentId || row.parentId === '-1') {
        // 根节点
        if (row.levelCode !== '1') {
          this.$message({ showClose: true, message: '根节点只能添加一级计划', type: 'info' })
          row.levelCode = '1'
        }
      } else {
        console.log('123', this.wbsData)
        this.findTree(this.wbsData, el => {
          if (el.id === row.parentId) {
            parentLevel = el.levelCode
            parentNode = el
            console.log('parentNode', parentNode)
          }
        })
        if (parentLevel && Number(parentLevel) > Number(row.levelCode)) {
          this.$message({ showClose: true, message: '计划级别不能小于父计划级别', type: 'info' })
          row.levelCode = ''
        } else if (parentLevel && Number(row.levelCode) - Number(parentLevel) > 1) {
          this.$message({ showClose: true, message: '不能跨级添加子计划', type: 'info' })
          row.levelCode = ''
        }
        // 判断父节点下所有子节点都为同一级别
        console.log('parentNode', parentNode)
        if (parentNode.children && parentNode.children.length > 1) {
          for (var j = 0; j < parentNode.children.length; j++) {
            if (parentNode.children[j].id === row.id) {
              j++ // 跳过当前修改的节点
            }
            if (parentNode.children[j].levelCode !== '') {
              limit = Number(parentNode.children[j].levelCode)
              empty = false
              break
            }
          }
          if (!empty) {
            parentNode.children.forEach(el => {
              if (limit !== '' && el.levelCode !== '' && Number(el.levelCode) !== limit) {
                flag = false
              }
            })
            if (!flag) {
              this.$message({ showClose: true, message: '该节点下已存在其他级别的计划', type: 'info' })
              row.levelCode = ''
            }
          }
        }
        if (row.children && row.children.length >= 1) {
          console.log('/*/*/4564', row)
          // 遍历孩子，孩子可能有还未选择级别的
          for (var k = 0; k < row.children.length; k++) {
            if (row.children[k].levelCode !== '') {
              childrenlimit = Number(row.children[k].levelCode)
              break
            }
          }
          if (childrenlimit !== '' && Math.abs(Number(childrenlimit - Number(row.levelCode)) > 1)) {
            this.$message({ showClose: true, message: '不能跨级添加计划', type: 'info' })
            row.levelCode = ''
          }
        }
      }
    },
    // wbs导入变更
    async startEdit() {
      // this.searchform.wbsName = ''
      // this.searchform.levelCode = ''
      // await this.searchNode() // 调用查询保证返回所有节点
      // await this.findTree(this.wbsData, el => {
      //   var obj = {}
      //   Object.assign(obj, el) // 逐层深拷贝
      //   // delete obj.children
      //   this.dataBeforEdit.push(obj)
      // })
      this.dataBeforEdit = []
      this.wbsDataCopyArr = []
      this.editWbsImport = true
      this.dataBeforEdit = await this.getWbsTree()
      console.log('开始', this.dataBeforEdit)
    },
    async cancelEdit() {
      console.log('取消', this.dataBeforEdit)
      this.wbsData = await this.toTree(this.dataBeforEdit)
      this.editWbsImport = false
    },
    async saveEdit() {
      // if (!this.wbsData || this.wbsData.length === 0) {
      //   return this.$message({ message: '保存的数据为空', type: 'info' })
      // } else {
      // this.searchform.wbsName = ''
      // this.searchform.levelCode = ''
      // this.searchNode() // 调用查询保证返回所有节点
      this.wbsDataCopyArr = await this.getWbsTree()
      // console.log('*/*/*/', this.wbsDataCopyArr)
      var flag = true
      var str = ''
      for (let i = 0; i < this.wbsDataCopyArr.length; i++) {
        if (this.wbsDataCopyArr[i].wbsName === '') {
          str = '第' + (i + 1) + '行的' + '名称'
          flag = false
          break
        } else if (!this.wbsDataCopyArr[i].levelCode || this.wbsDataCopyArr[i].levelCode === '' || !this.wbsDataCopyArr[i].levelCode === null) {
          str = '第' + (i + 1) + '行的' + '级别'
          flag = false
          break
        } else if (this.wbsDataCopyArr[i].weightValue === '' || this.wbsDataCopyArr[i].weightValue === undefined || this.wbsDataCopyArr[i].weightValue === 'undefined' || this.wbsDataCopyArr[i].weightValue === null) {
          str = '第' + (i + 1) + '行的' + '权值'
          flag = false
          break
        }
      }
      if (flag) {
        this.wbsDataCopyArr = await this.getWbsTree()
        // console.log('保存的数据', this.wbsDataCopyArr)
        // console.log('现在的数据', this.wbsData)
        // 保存之前调用自动计算权值
        this.wbsTree = this.wbsDataCopyArr
        await this.caclWeight() // 计算权重
        var data = {}
        this.wbsDataCopyArr.forEach(el => {
          delete el.children // 删除孩子属性
        })
        data.saveList = this.wbsDataCopyArr
        data.projectId = this.$route.params.id
        if (this.changeFlag) {
          data.changeFlag = 'changed'
        }
        importWbsSave(data).then(res => {
          if (res && res.code === '200') {
            this.$message({ message: '保存成功', type: 'success' })
            this.wbsData = res.data.tree
            this.editWbsImport = false
            // 保存数据
          } else {
            return this.$message({ message: '保存失败', type: 'error' })
          }
        })
      } else {
        // this.wbsData = this.toTree(this.wbsDataCopyArr)
        return this.$message({ message: `请编辑好必填项:${str}`, type: 'info' })
      }
      // }
    },
    toChangeWbsImport(row) {
      if (row.approvalState === '01') {
        return this.$message({ message: '未提交审批,不允许变更', type: 'error' })
      } else {
        console.log('progressData', this.progressData)
        var flag = true
        this.progressData.forEach(el => {
          if (el.state === '02' || el.state === '05' || el.stateName === '变更审批中' || el.stateName === '校验审批中') {
            flag = false
          }
        })
        if (flag) {
          this.changeFlag = true
          this.activeName = 'wbsplanedit'
          this.changeWbsImportProcess = true
          console.log('变更')
        } else {
          return this.$message({ message: '校验审批中与变更审批中,不允许变更', type: 'error' })
        }
      }
    },
    forArr(arr, isExpand) { // 展开收起
      arr.forEach(i => {
        this.$refs.wbsDataRef.toggleRowExpansion(i, isExpand)
        if (i.children) {
          this.forArr(i.children, isExpand)
        }
      })
    },
    findTree(arr, callBack) { // 树形递归遍历
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    toTree(data) { // 数组转换为树
      const me = this
      data.forEach(function(item) {
        delete item.children
      })
      console.log('data---', data)
      var map = {}
      data.forEach(function(item) {
        map[item.id] = item
      })
      var val = []
      data.forEach(function(item) {
        var parent = map[item.parentId]
        if (parent) {
          (parent.children || (me.$set(parent, 'children', []))).push(item)
        } else {
          val.push(item)
        }
      })
      console.log('0000', val)
      return val
    },
    async searchNode() {
      if (this.editWbsImport) {
        return this.$message({ message: '请先保存再进行查询', type: 'info' })
      } else {
        if (this.searchform.wbsName === '' && this.searchform.levelCode === '') {
          this.wbsData = this.toTree(this.wbsDataCopyArr)
        } else {
          console.log('this.wbsDataCopyArr', this.wbsDataCopyArr)
          this.wbsData = await this.toTree(this.wbsDataCopyArr)
          this.wbsData = this.deepSearch(this.wbsData)
        }
      }
    },
    deepSearch(nodes) {
      // 如果已经没有节点了，结束递归
      if (!(nodes && nodes.length)) {
        return
      }
      const newChildren = []
      for (const node of nodes) {
        if (this.searchform.wbsName !== '' && this.searchform.levelCode === '') {
          console.log(1)
          if (node.wbsName.indexOf(this.searchform.wbsName) >= 0) {
            // 如果自己（节点）符合条件，直接加入到新的节点集
            newChildren.push(node)
            // 并接着处理其 children
            node.children = this.deepSearch(node.children)
          } else {
            // 如果自己不符合条件，需要根据子集来判断它是否将其加入新节点集
            // 根据递归调用 deal() 的返回值来判断
            const subs = this.deepSearch(node.children)
            if (subs && subs.length) {
              // 1. 如果子孙集中有符合要求的节点（返回 [...])，加入
              node.children = subs
              newChildren.push(node)
            }
            // 2. 否则，不加入（因为整个子集都没有符合条件的）
          }
        } else if (this.searchform.wbsName === '' && this.searchform.levelCode !== '') {
          console.log(2)
          if (node.levelCode === this.searchform.levelCode) {
            newChildren.push(node)
            node.children = this.deepSearch(node.children)
          } else {
            const subs = this.deepSearch(node.children)
            if (subs && subs.length) {
              node.children = subs
              newChildren.push(node)
            }
          }
        } else {
          if (node.wbsName.indexOf(this.searchform.wbsName) >= 0 && node.levelCode === this.searchform.levelCode) {
            newChildren.push(node)
            node.children = this.deepSearch(node.children)
          } else {
            const subs = this.deepSearch(node.children)
            if (subs && subs.length) {
              node.children = subs
              newChildren.push(node)
            }
          }
        }
      }
      return newChildren.length ? newChildren : void 0
    },
    expandAll() {
      this.forArr(this.wbsData, true)
    },
    collapseAll() {
      this.forArr(this.wbsData, false)
    },
    rowClick(row, col, event) {
      this.$refs.wbsDataRef.setCurrentRow(row)
      this.currentNode = row
    },
    // 获取编码
    async getCodetoNode(childFlag, nodeList, isChild, tempId, projectType, Professional, codeType, tentantId) {
      var dictCode = ''
      var params = {
        childFlag: childFlag,
        nodeList: nodeList,
        isChild: isChild,
        tempId: tempId || '',
        Professional: Professional,
        projectType: projectType,
        codeType: codeType,
        tentantId: tentantId
      }
      await getWbsRuleCode(params).then(res => {
        // console.log(res)
        if (res && res.messageCode === '200') {
          dictCode = res.code
        } else {
          this.$message({
            message: '获取wbs编码失败',
            type: 'error'
          })
        }
      })
      return dictCode
    },
    // 通过选中节点增加同级节点
    async addNodeById(arr, row) {
      if (row.parentId === '-1') {
        var ID = this.GenNonDuplicateID(20)
        var nodelist = []
        for (let i = 0; i < arr.length; i++) {
          nodelist.push(arr[i].wbsCode)
        }
        var a = []
        var newNode = {
          id: ID,
          wbsName: '',
          wbsCode: await this.getCodetoNode('1', nodelist, '1', this.tempId, '', '', '1', this.tentantId),
          levelCode: '',
          weights: '0',
          weightValue: '',
          parentId: '-1',
          // path: ID,
          children: []
        }
        this.$set(newNode, 'children', a)
        arr.push(newNode)
      } else {
        arr.forEach(async(i, index) => {
          if (i.id === row.id) {
            var ID = this.GenNonDuplicateID(20)
            var nodelist = []
            for (let i = 0; i < arr.length; i++) {
              nodelist.push(arr[i].wbsCode)
            }
            var b = []
            var newNode = {
              id: ID,
              wbsName: '',
              wbsCode: await this.getCodetoNode('1', nodelist, '2', this.tempId, '', '', '1', this.tentantId),
              levelCode: '',
              weights: '0',
              weightValue: '1',
              // path: row.path,
              parentId: row.parentId,
              children: []
            }
            // arr.splice(index + 1, 0, newNode)
            this.$set(newNode, 'children', b)
            arr.push(newNode)
          }
          if (i.children) {
            this.addNodeById(i.children, row)
          }
        })
      }
    },
    addChildNodeById(arr, row) {
      arr.forEach(async i => {
        if (i.id === row.id) {
          console.log('i,ichildren', i, i.children)
          if (i.children === null || i.children === undefined || i.children === 'undefined' || i.children === '') {
            var a = []
            this.$set(i, 'children', a)
          }
          var childFlag = ''
          var nodelist = []
          var len = i.children ? i.children.length : 0
          if (len === 0) {
            nodelist.push(i.wbsCode)
            childFlag = '2'
          } else {
            for (let j = 0; j < len; j++) {
              if (i.children && i.children[j]) {
                nodelist.push(i.children[j].wbsCode)
              }
            }
            childFlag = '1'
          }
          // console.log(isChild)
          var ID = this.GenNonDuplicateID(20)
          var newNode = {
            id: ID,
            wbsName: '',
            wbsCode: await this.getCodetoNode(childFlag, nodelist, '2', this.tempId, '', '', '1', this.tentantId),
            parentId: row.id,
            levelCode: '',
            weights: '0',
            weightValue: '1',
            // path: '',
            children: []
          }
          if (i.children) {
            this.$set(i, 'children', i.children)
            i.children.push(newNode)
          }
          // this.$set(i.children, i.children.length, newNode)
        }
        if (i.children) {
          this.addChildNodeById(i.children, row)
        }
      })
      return arr
    },
    async addNewNode() {
      if (this.wbsData && this.wbsData.length !== 0) {
        if (this.currentNode !== '') {
          this.addNodeById(this.wbsData, this.currentNode)
          this.wbsDataCopyArr = await this.getWbsTree() // 保存数据
        } else {
          // alert('请选择一个节点！')
          this.$message({
            type: 'info',
            message: '请选择一个节点！'
          })
        }
      } else {
        var ID = this.GenNonDuplicateID(20)
        var nowNode = {
          id: ID,
          wbsName: '',
          wbsCode: await this.getCodetoNode('1', [], '1', this.tempId, '', '', '1', this.tentantId),
          parentId: '-1',
          levelCode: '',
          weights: '0',
          weightValue: '1',
          // path: '',
          children: []
        }
        this.wbsData.push(nowNode)
        this.wbsDataCopyArr = await this.getWbsTree()
        // setTimeout(() => {
        //   this.wbsDataCopyArr = this.getWbsTree()
        // }, 500)
      }
    },
    async addNewChildNode() {
      if (this.currentNode !== '') {
        const a = await this.addChildNodeById(this.wbsData, this.currentNode)
        console.log('---', a)
        // this.wbsData = JSON.parse(JSON.stringify(a))
        // this.$nextTick(() => {
        //   a.forEach(element => {
        //     this.wbsData.forEach(wbsEle => {
        //       if(element.id === wbsEle.id){
        //         this.$set(wbsEle, 'children', element.children)
        //       }
        //     })
        //   })
        // })
        // // this.wbsData = []
        // this.$forceUpdate()
        this.wbsDataCopyArr = await this.getWbsTree()// 保存数据
        // this.wbsData = this.toTree(this.wbsDataCopyArr)
        // this.wbsData = await this.toTree(this.wbsDataCopyArr)
        // setTimeout(() => {
        //   this.wbsDataCopyArr = this.getWbsTree()
        // }, 500)
      } else {
        // alert('请选择一个节点！')
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }

      // console.log('------dfdfd', this.wbsData)
      // // this.wbsData = JSON.parse(JSON.stringify(this.wbsData))
      // console.log('------dfdfd111', JSON.stringify(this.wbsData))
    },
    deleteSearchById(arr, id) {
      arr.forEach((i, index) => {
        if (i.id === id) {
          arr.splice(index, 1)
        }
        if (i.children) {
          this.deleteSearchById(i.children, id)
        }
      })
    },
    async deleteNode() {
      if (this.currentNode !== '') {
        await this.deleteSearchById(this.wbsData, this.currentNode.id)
        // this.wbsDataCopyArr = this.getWbsTree()
        console.log('删除节点保存数组', this.wbsDataCopyArr)
        setTimeout(() => {
          this.wbsDataCopyArr = this.getWbsTree()
        }, 500)
        this.currentNode = ''
      } else {
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    moveUpNodeNById(arr, id) {
      arr.forEach((i, index) => {
        if (i.id === id) {
          if (index === 0) {
            this.$message({
              type: 'info',
              message: '该节点已为第一个节点'
            })
            return
          } else {
            arr.splice(index, 1)
            arr.splice(index - 1, 0, i)
          }
        }
        if (i.children) {
          this.moveUpNodeNById(i.children, id)
        }
      })
    },
    async shiftUpNode() {
      if (this.currentNode !== '') {
        console.log('上移节点', this.currentNode) // 上移操作
        await this.moveUpNodeNById(this.wbsData, this.currentNode.id)
        // this.wbsDataCopyArr = this.getWbsTree()// 移动后的树重新存到copy数组中保存
        setTimeout(() => {
          this.wbsDataCopyArr = this.getWbsTree()
        }, 500)
      } else {
        // alert('请选择一个节点！')
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    moveDownNodeNById(arr, id) {
      try {
        arr.forEach((i, index) => {
          if (i.id === id) {
            if (index === arr.length - 1) {
              this.$message({
                type: 'info',
                message: '该节点已为最后一个节点'
              })
              return
            } else {
              arr.splice(index, 1)
              arr.splice(index + 1, 0, i)
              throw new Error('ending')
            }
          }
          if (i.children) {
            this.moveDownNodeNById(i.children, id)
          }
        })
      } catch (e) {
        if (e.message !== 'ending') {
          throw e
        }
      }
    },
    async shiftDownNode() {
      if (this.currentNode !== '') {
        console.log('下移节点', this.currentNode) // 下移操作
        await this.moveDownNodeNById(this.wbsData, this.currentNode.id)
        // this.wbsDataCopyArr = this.getWbsTree()// 移动后的树重新存到copy数组中保存
        setTimeout(() => {
          this.wbsDataCopyArr = this.getWbsTree()
        }, 500)
      } else {
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    onChange(file) {
      this.fileInfo = { ...this.fileInfo, ...file }
      console.log(this.fileInfo)
    },
    resetFileInfo() {
      this.fileInfo = { }
    },
    sureUpload() {
      if (this.wbsData && this.wbsData.length !== 0) {
        this.$confirm('导入会覆盖之前的数据您确定导入吗?', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$refs.importForm.validate((valid) => {
            if (valid) {
              if (this.fileInfo.name.substring(this.fileInfo.name.length - 3, this.fileInfo.name.length) !== 'mpp') {
                this.$alert('导入格式不对')
                return
              }
              this.importDialogVisible = false
              this.progressPercent = 0
              this.importLoading = true
              const formFile = new FormData()
              formFile.append('file', this.fileInfo.raw)
              formFile.append('projectId', this.$route.params.id)
              var onUploadProgress = progressEvent => {
                var complete = (progressEvent.loaded / progressEvent.total * 100 | 0)
                this.progressPercent = complete
              }
              wbsImport(formFile, onUploadProgress).then(res => { // 导入接口
                this.resetFileInfo()
                this.importLoading = false
                if (res && res.code === '200') {
                  this.$message({
                    type: 'success',
                    message: '导入成功!'
                  })
                  var insertTreeArr = []
                  this.findTree(res.data.importWbsNodes, (item) => {
                    insertTreeArr.push(item)
                  })
                  this.wbsDataCopyArr = []
                  this.wbsDataCopyArr = insertTreeArr
                  this.wbsData = this.toTree(insertTreeArr)
                } else {
                  let message = ''
                  if (res.data && res.data.validatelist) {
                    res.data.validatelist.forEach(item => {
                      message += item + '<br/>'
                    })
                  }
                  this.$alert(message, '导入错误', {
                    confirmButtonText: '确定',
                    dangerouslyUseHTMLString: true
                  })
                }
              }).catch(() => {
                this.resetFileInfo()
                this.importLoading = false
              })
            } else {
              return
            }
          })
        }).catch(() => {
          this.$message({
            type: 'info',
            message: '已取消导入'
          })
        })
      } else {
        this.$refs.importForm.validate((valid) => {
          if (valid) {
            if (this.fileInfo.name.substring(this.fileInfo.name.length - 3, this.fileInfo.name.length) !== 'mpp') {
              this.$alert('导入格式不对')
              return
            }
            this.importDialogVisible = false
            this.progressPercent = 0
            this.importLoading = true
            const formFile = new FormData()
            formFile.append('file', this.fileInfo.raw)
            formFile.append('projectId', this.$route.params.id)
            var onUploadProgress = progressEvent => {
              var complete = (progressEvent.loaded / progressEvent.total * 100 | 0)
              this.progressPercent = complete
            }
            wbsImport(formFile, onUploadProgress).then(async res => { // 导入接口
              this.resetFileInfo()
              this.importLoading = false
              if (res && res.code === '200') {
                this.$message({
                  type: 'success',
                  message: '导入成功!'
                })
                var insertTreeArr = []
                this.findTree(res.data.importWbsNodes, (item) => {
                  insertTreeArr.push(item)
                })
                this.wbsDataCopyArr = []
                // await Object.assign(this.wbsDataCopyArr, insertTreeArr)
                this.wbsDataCopyArr = insertTreeArr
                this.wbsData = this.toTree(insertTreeArr)
              } else {
                let message = ''
                if (res.data && res.data.validatelist) {
                  res.data.validatelist.forEach(item => {
                    message += item + '<br/>'
                  })
                }
                this.$alert(message, '导入错误', {
                  confirmButtonText: '确定',
                  dangerouslyUseHTMLString: true
                })
              }
            }).catch(() => {
              this.resetFileInfo()
              this.importLoading = false
            })
          } else {
            return
          }
        })
      }
    },

    GenNonDuplicateID(randomLength) {
      return Number(Math.random().toString().substr(3, randomLength) + Date.now()).toString(36)
    },
    closeVersionHistoryDialog() {
      // this.getTreeList()
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
    getWbsLevelDataList() {
      var _self = this
      var requestData = {
        projectId: _self.$route.params.id ? _self.$route.params.id : '1'
      }
      _self.loading = true
      _self.nowEditLevelId = ''
      _self.nowEditLevel = ''
      _self.nowEditLevelState = ''
      _self.wbsLevelId = ''
      _self.scheLevelUsers = ''
      // _self.nowEditLevelSort = 0
      getWbsLevelData(requestData).then((ref) => {
        if (ref && ref.code === '200') {
          var newDataArr = []
          var leveldata = ref.data
          // var dataIndex = 0
          leveldata.forEach(item => {
            // dataIndex++
            if (item.inProcess === 1) {
              _self.nowEditLevelId = item.level + ''
              _self.nowEditLevel = item.levelName
              _self.nowEditLevelState = item.stateName
              _self.wbsLevelId = item.id
              _self.scheLevelUsers = item.scheLevelUsers
              // _self.nowEditLevelSort = dataIndex
              // if (item.levelName === '一级计划') {
              //   _self.showAddRootIcon = true
              // }
            }
            newDataArr.push({
              id: item.id,
              // changeNO: item.scheWbsLevelInfo ? item.scheWbsLevelInfo.id : '',
              projectId: item.projectId,
              wbsLevelId: item.id,
              level: item.level,
              levelName: item.levelName,
              // inEdit: item.inEdit,
              // inChange: item.inChange,
              updateUser: item.scheEdit ? item.scheEdit.editUserName : '',
              updateTime: item.scheEdit ? item.scheEdit.editTime : '',
              applyTime: item.scheApprove ? item.scheApprove.applyTime : '',
              wbsLevelInfoId: item.scheApprove ? item.scheApprove.id : '',
              state: item.scheApprove ? item.scheApprove.state : '',
              stateName: item.stateName,
              inProcess: item.inProcess,
              compileStateName: item.compileStateName,
              aprovalNum: item.aprovalNum,
              approval: item.approval + ''
            })
          })
          if (leveldata.length > 0 && leveldata[leveldata.length - 1]) {
            this.maxLevel = leveldata[leveldata.length - 1].level
          }

          _self.progressData = newDataArr
        } else {
          alert('获取wbs级别信息失败')
        }
      }).finally(() => {
        _self.loading = false
        _self.getScheWbsCompileData()
      })
    },
    getScheWbsCompileData() {
      var _self = this
      var requestData = {
        // wbsLevelInfoId: '1',
        projectId: _self.$route.params.id ? _self.$route.params.id : '1'
      }
      _self.loading = true
      getCurrentUserLevel(requestData).then((ref) => {
        console.log('ref', ref)
        if (ref && ref.code === '200' && ref.data && ref.data.length > 0) {
          var newDataArr = []
          var userLeveldata = ref.data
          _self.isManager = false
          _self.isChange = false
          userLeveldata.forEach(item => {
            if ((!_self.nowEditLevelState || _self.nowEditLevelState === '未提交' || _self.nowEditLevelState === '退回' || _self.nowEditLevelState === '变更退回' || _self.nowEditLevelState === '变更未提交') && item.inProcess === 1 && (!item.scheEdit || (item.scheEdit && item.scheEdit.state === '0'))) {
              _self.isManager = true
            }
            if (((_self.nowEditLevelState === '未提交' || _self.nowEditLevelState === '退回' || _self.nowEditLevelState === '变更退回' || _self.nowEditLevelState === '变更未提交') && item.level === this.nowEditLevelId && item.scheEdit && item.scheEdit.editUser && item.scheEdit.editUser.indexOf(this.userId) > -1)) {
              _self.isShowFinishBtn = true
            } else {
              _self.isShowFinishBtn = false
            }
            newDataArr.push({
              id: item.scheEdit ? item.scheEdit.id : '',
              projectId: item.projectId,
              level: item.level,
              levelName: item.levelName,
              wbsLevelId: item.scheEdit ? item.scheEdit.wbsLevelId : '',
              editUser: item.scheEdit ? item.scheEdit.editUserName : '',
              editTime: item.scheEdit ? item.scheEdit.editTime : '',
              state: item.scheEdit ? item.scheEdit.state : '0',
              inProcess: item.inProcess
            })
          })
          _self.nowProgressData = newDataArr
        } else {
          // 没有当前级别编制用户
          this.isShowFinishBtn = false
        }
      }).finally(() => {
        _self.loading = false
        // _self.$nextTick(() => {
        //   _self.maxGridHeight = _self.$refs.pageDiv.clientHeight - _self.$refs.cardoneheader.clientHeight - _self.$refs.tablewrap.clientHeight - _self.$refs.cardtwoheader.clientHeight - _self.$refs.nowtablewrap.clientHeight - _self.$refs.cardthreeheader.clientHeight - _self.$refs.topDiv.clientHeight - 122
        // })
      })
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
    toFinish: function(row) {
      var _self = this
      if (!_self.nowEditLevelState || _self.nowEditLevelState === '未提交' || _self.nowEditLevelState === '退回' || _self.nowEditLevelState === '变更退回' || _self.nowEditLevelState === '变更未提交') {
        row.wbsLevelId = _self.wbsLevelId
        if (this.isChange) {
          row.changeFlag = '1'
        } else {
          delete row.changeFlag
        }
        saveScheEdit(row).then((ref) => {
          if (ref && ref.code === '200') {
            _self.$message({ showClose: true, message: '操作成功!', type: 'success' })
            // 刷新整体进展和用户进展
            _self.getWbsLevelDataList()
          }
        }).catch((err) => {
          console.error(err)
        })
      } else {
        _self.$message({ showClose: true, message: '数据已提交审批，不能取消', type: 'info' })
      }
    },
    toViewFlow: function(obj) {
      console.log(obj)
      this.flowLevelId = obj.id
      this.flowLevelName = obj.levelName
      this.auditHistoryVisble = true
    },
    toVersionView: function() {
      this.versionHistoryVisble = true
    },

    toChange: function(row) {
      this.changeWbsImportProcess = false
      var _self = this
      var hasPermissions = false
      if (_self.changeEditLevelId && _self.changeEditLevelId !== row.level) {
        _self.$message({
          type: 'info',
          message: '不能重复操作'
        })
        return
      }
      // 判断是不是存在审批中的计划
      for (let m = 0; m < _self.progressData.length; m++) {
        if (_self.progressData[m].stateName && (_self.progressData[m].stateName === '审批中' || _self.progressData[m].stateName === '变更审批中')) {
          _self.$message({
            type: 'info',
            message: '有正在审批中的计划，不能变更该计划'
          })
          return
        }
      }
      // 判断用户是否有变更权限
      for (let i = 0; i < _self.nowProgressData.length; i++) {
        if (_self.nowProgressData[i].level === row.level) {
          hasPermissions = true
          _self.nowEditLevelId = row.level
          _self.changeEditLevelId = row.level
          _self.nowEditLevel = row.levelName
          // _self.nowEditLevelState = row.level
          _self.wbsLevelId = row.id
          _self.nowProgressData[i].state = '0'
          _self.nowProgressData[i].inProcess = 1
          break
        }
      }
      if (hasPermissions) {
        // 修改当前编辑计划为变更计划
        _self.isManager = true
        _self.isChange = true
        _self.activeName = 'wbsplanedit'
        // 触发编辑事件
        this.$refs.wbsEditTab.editMangementFunc()
      } else {
        _self.$message({
          type: 'info',
          message: '没有变更该级别的权限'
        })
      }
    },
    toOperation: function(row, submitstate) {
      var _self = this
      var hasPermissions = false
      // 判断用户是否有变更权限
      for (let i = 0; i < _self.nowProgressData.length; i++) {
        if (_self.nowProgressData[i].level === row.level) {
          hasPermissions = true
          break
        }
      }
      if (hasPermissions) {
        if (process.env.VUE_APP_BFWEB === 'true') {
          // 调用贵州院流程流转
          console.log('弹出流程界面')
          var wbsid = ''
          if (!row.wbsLevelInfoId || (row.state === '03' && (row.stateName === '未提交' || row.stateName === '变更未提交'))) {
            wbsid = this.GenNonDuplicateID(20)
          } else {
            wbsid = row.wbsLevelInfoId
          }
          _self.dialogComplete = true
          _self.completeTask = process.env.VUE_APP_BASE_API + 'view/progress/progress/wbs/wbsAudit?id=' + wbsid + '&wbsLevelId=' + row.id + '&projectId=' + _self.$route.params.id
        } else {
          if (submitstate === '1') {
            _self.$prompt('<span style="color:red">*</span> 说明：提交后，当前计划将进入审批流程', '提交说明', {
              confirmButtonText: '确定',
              cancelButtonText: '取消',
              inputType: 'textarea',
              dangerouslyUseHTMLString: true,
              inputValidator: function(obj) {
                if (obj == null || obj === '') return '请输入提交说明'
              }
            }).then(({ value }) => {
              // _self.saveTable('1')
              row.remark = value
              if (row.state === '03' && (row.stateName === '未提交' || row.stateName === '变更未提交')) {
                delete row.wbsLevelInfoId
              }
              submitApproval(row).then(res => {
                _self.$message({ showClose: true, message: '提交成功!', type: 'success' })
              }).finally(() => {
                _self.saveLoading = false
                _self.isManager = false
                _self.isChange = false
                _self.editManagement = false
                _self.changeEditLevelId = ''
                // 刷新整体进展和用户进展
                _self.getWbsLevelDataList()
              })
            }).catch(() => {
              _self.$message({
                type: 'info',
                message: '取消输入'
              })
            })
          } else {
            _self.$alert('撤回操作')
          }
        }
      } else {
        _self.$message({
          type: 'info',
          message: '没有提交审批该级别的权限'
        })
      }
    },
    submitVersion: function() {
      var _self = this
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
            sortCode: itemNode.sortCode,
            parentId: itemNode.parentId,
            path: itemNode.path,
            planDuration: itemNode.planDuration,
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
        _self.saveLoading = true
        saveWbsVersion(savedata).then(res => {
          _self.$message({ showClose: true, message: '保存成功!', type: 'success' })
        }).finally(() => {
          _self.saveLoading = false
        })
      }).catch(() => {
        _self.$message({
          type: 'info',
          message: '取消输入'
        })
      })
    },
    handleClick(tab, event) {
      if (this.activeName === 'wbsplanedit') {
        //
      } else {
        if (this.showWbsImportProcess) {
          this.changeFlag = false
          this.wbsImportData = []
          importMMPEditMsg(this.$route.params.id).then(res => {
            console.log(res)
            if (res && res.code === '200') {
              this.wbsImportData.push(res.data)
              this.scheApproveList = res.data.scheApproveList // 审批记录
            }
          })
        }
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

/deep/.el-tabs--border-card>.el-tabs__content{
    padding: 10px;
}
.h-100 {
  height:100%
}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
/deep/ table th.must div:before  {
			content: '*';
			color: #ff1818;

}
/deep/ table th.must{
	text-align: center;
  font-size:13px;

}
/deep/ .justcenter{
  text-align: center;
}
.importBox{
  max-height: calc(100vh - 100px);
  overflow: auto;
}
</style>
