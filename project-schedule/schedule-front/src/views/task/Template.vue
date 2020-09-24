<template>
  <div
    style="position:absolute;top: 0;right: 0;bottom: 0;left: 0;height:100%;padding:10px 10px 0px;"
  >
    <el-row>
      <el-col :span="16">
        <el-form :model="searchForm" size="mini" label-width="auto" :inline="true" class="search-form">
          <!--       <el-row :gutter="6">
        <el-col :xl="6" :lg="6" :md="12" :sm="24" :xs="24"> -->
          <el-form-item label="模板名称">
            <el-input v-model="searchForm.tempName" placeholder="" clearable />
          </el-form-item>
          <!-- </el-col> -->
          <!-- <el-col :xl="6" :lg="6" :md="12" :sm="24" :xs="24" class="search-form-middle"> -->
          <el-button type="primary" size="mini" @click="fetchPrimaryData()">查询</el-button>
          <el-button v-if="bfweb" plain size="mini" class="ml-10" @click="resetForm('queryForm')">重置</el-button>
          <!-- </el-col>
      </el-row> -->
          <!-- </el-col> -->
        </el-form>
      </el-col>
      <el-col :span="8">
        <div v-show="!isDetail" class="table-header clearfix">
          <div class="buttons-right">
            <!-- <el-button type="text" size="mini" icon="el-icon-plus" @click="addTemplate">增加 -->
            <el-button type="primary" size="mini" @click="addTemplate">增加
            </el-button>
          </div>
        </div>
      </el-col>
    </el-row>
    <div ref="tablewrap" style="height:40%">
      <!-- <div v-show="!isDetail" class="table-header clearfix">
        <div class="buttons-right">
          <el-button type="primary" size="mini" @click="addTemplate">增加
          </el-button>
        </div>
      </div> -->
      <el-table
        ref="primaryTable"
        :data="primaryTableData"
        border
        size="mini"
        :style="{height: 'calc(100% - 4px)',overflowY:'auto'}"
        highlight-current-row
        @current-change="handleParentTableCurrentChange"
        @row-dblclick="primaryTableDoubleClick"
      >
        <el-table-column label="序号" type="index" />
        <el-table-column label="模板名称" prop="tempName">
          <!--  <template slot-scope="scope">
            <el-link type="primary">{{ scope.row.tempName }}</el-link>
          </template> -->
        </el-table-column>
        <el-table-column label="备注" prop="remark" />
        <el-table-column label="创建人" prop="createUserName" />
        <el-table-column label="创建时间" prop="createTime" />
        <el-table-column label="最近编辑人" prop="updateUserName" />
        <el-table-column label="最近编辑时间" prop="updateTime" />
        <el-table-column v-if="!isDetail" label="操作">
          <template slot-scope="scope">
            <!-- <el-link :underline="false" type="primary" @click="handlePrimaryTemplateEdit(scope.row,scope.$index)">编辑</el-link>&#124; -->
            <el-button type="text" @click="handlePrimaryTemplateCopy(scope.row,scope.$index)">复制增加</el-button>
            <el-button type="text" @click="handlePrimaryTemplateDel(scope.row,scope.$index)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
      <!-- <el-pagination
        v-bind="pagination"
        class="table-pages"
        background
        @size-change="handleSizeChange"
        @current-change="paginationCurrentChange"
      /> -->
    </div>
    <!-- <el-card style="height:calc(60% - 64px);" :body-style="{ height: 'calc(100% - 55px)',padding: '20px 0px 0px' }"> -->
    <el-card style="height:calc(60% - 64px);" :body-style="{ height: 'calc(100% - 39px)',padding: '20px 0px 0px' }">
      <div slot="header">
        <span>模板信息</span>
      </div>
      <el-row>
        <el-col :span="16">
          <el-form
            ref="childSearchForm"
            :inline="true"
            size="mini"
            class="search-form"
            @keyup.enter.native="fetchPrimaryData"
          >
            <el-form-item label="名称">
              <el-input
                v-model="childTableForm.search.taskName"
                placeholder=""
                clearable
              />
            </el-form-item>
            <el-form-item label="作业类型">
              <el-select
                v-model="childTableForm.search.taskType"
                placeholder="全部"
                clearable
                default-first-option
              >
                <!-- <el-option label="里程碑" :value="'0'" />
            <el-option label="作业" :value="'1'" /> -->
                <el-option v-for="item in childTableForm.taskTypeComboxOptions" :key="item.dictCode" size="small" :label="item.name" :value="item.dictCode" />
              </el-select>
            </el-form-item>
            <el-form-item>
              <el-button
                type="primary"
                size="mini"
                @click="handleSearchChildTableData"
              >
                查询
              </el-button>
            </el-form-item>
            <template v-if="false">
              <el-form-item v-show="!isDetail">
                <el-button
                  type="primary"
                  size="mini"
                  @click="downloadTemplate"
                >
                  下载模板
                </el-button>
              </el-form-item>
              <el-form-item>
                <el-button
                  v-show="isEdit"
                  type="primary"
                  @click="importTemplateDialogVisible = true"
                >
                  导入
                </el-button>
              </el-form-item>
            </template>
          </el-form>
        </el-col>
        <el-col v-show="!isDetail" :span="8">
          <div class="table-header clearfix">
            <div class="buttons-right">
              <el-button v-show="!isEdit" type="primary" size="mini" @click="handleChildTableEdit">编辑
              </el-button>
              <el-button v-show="isEdit" type="primary" size="mini" @click="handleSaveChildTableForm('childTableForm')">保存
              </el-button>
              <el-button v-show="isEdit" size="mini" @click="handleChildTableEditCancel">取消
              </el-button>
            </div>
          </div>
        </el-col>
      </el-row>
      <div ref="tablewrap" :style="{height:'calc(100% - ' + childTableForm.childTableHeight +'px)'}">
        <div v-if="!isDetail" class="clearfix">
          <!--    <span v-show="isEdit">
            <el-tooltip effect="dark" content="向前添加" placement="top">
              <el-button icon="el-icon-arrow-left" size="mini" circle @click="handleAddChildTemplate('before')" />
            </el-tooltip>
            <el-tooltip effect="dark" content="向后添加" placement="top">
              <el-button icon="el-icon-arrow-right" size="mini" circle @click="handleAddChildTemplate('backward')" />
            </el-tooltip>
            <el-tooltip effect="dark" content="上移" placement="top">
              <el-button icon="el-icon-top" size="mini" circle @click="handleMoveChildTemplate(-1)" />
            </el-tooltip>
            <el-tooltip effect="dark" content="下移" placement="top">
              <el-button icon="el-icon-bottom" size="mini" circle @click="handleMoveChildTemplate(1)" />
            </el-tooltip>
          </span> -->
          <el-row v-if="isEdit">
            <el-form ref="primaryInfoForm" class="clearfix" :model="templateForm.tempData" label-width="80px" size="small" label-suffix="" :rules="templateForm.rules">
              <el-col :xl="6" :lg="6" :md="6" :sm="12" :xs="24">
                <el-form-item label="名称：" prop="tempName">
                  <el-input v-model.trim="templateForm.tempData.tempName" />
                </el-form-item>
              </el-col>
              <el-col :xl="6" :lg="6" :md="6" :sm="12" :xs="24">
                <el-form-item label="备注：" prop="remark">
                  <el-input v-model.trim="templateForm.tempData.remark" maxlength="100" type="textarea" resize="horizontal" :autosize="{ minRows: 0, maxRows: 2 }" />
                </el-form-item>
              </el-col>
              <el-col :xl="12" :lg="12" :md="12" :sm="12" :xs="24">
                <span style="margin-right:12px;float:right;">
                  <el-button type="primary" size="mini" @click="handleAddChildTemplate('backward')">添加</el-button>
                  <el-button type="primary" size="mini" @click="handleMoveChildTemplate(-1)">上移</el-button>
                  <el-button type="primary" size="mini" @click="handleMoveChildTemplate(1)">下移</el-button>
                </span>
              </el-col>
            </el-form>
          </el-row>
          <!--  <div class="buttons-right">
            <el-button v-show="!isEdit" type="primary" size="mini" @click="handleChildTableEdit">编辑
            </el-button>
            <el-button v-show="isEdit" type="primary" size="mini" @click="handleSaveChildTableForm('childTableForm')">保存
            </el-button>
            <el-button v-show="isEdit" size="mini" @click="handleChildTableEditCancel">取消
            </el-button>
          </div> -->
        </div>
        <el-form ref="childTableForm" :model="childTableForm" style="height:calc(100% - 0px);">
          <el-table
            ref="childTable"
            class="edit-table"
            :highlight-current-row="isEdit"
            border
            :data="childTableForm.data"
            :row-class-name="tableRowClassName"
            size="mini"
            style="margin-top:10px;"
            :style="{height: '100%',overflowY:'auto'}"
            @current-change="handleChildTableCurrentChange"
          >
            <el-table-column label="序号" type="index" />
            <el-table-column label="名称" prop="taskName" label-class-name="require">
              <template slot-scope="scope">
                <template v-if="!isEdit">
                  {{ scope.row.taskName }}
                </template>
                <el-form-item
                  v-else
                  label-width="0px"
                  :prop="`data.${scope.$index}.taskName`"
                  :rules="[{ required: true, message: '名称不能为空'}]"
                >
                  <el-input
                    v-model="scope.row.taskName"
                    size="mini"
                    placeholder=""
                  />
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="作业类型" prop="taskType" label-class-name="require">
              <template slot-scope="scope">
                <template v-if="!isEdit">
                  {{ scope.row.taskTypeName }}
                </template>
                <el-form-item
                  v-else
                  label-width="0px"
                  :prop="`data.${scope.$index}.taskType`"
                  :rules="[{ required: true, message: '类型不能为空'}]"
                >
                  <el-select v-model="scope.row.taskType" size="small" placeholder="请选择" @change="((val)=>{handleSelectTaskType(val, scope.row)})">
                    <el-option v-for="item in childTableForm.taskTypeComboxOptions" :key="item.dictCode" size="small" :label="item.name" :value="item.dictCode" />
                  </el-select>
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="进度计算方式" prop="scheCalcType" label-class-name="require">
              <template slot-scope="scope">
                <template v-if="!isEdit">
                  {{ scope.row.scheCalcTypeName }}
                </template>
                <template v-else-if="scope.row.taskType === '0'" />
                <el-form-item
                  v-else
                  label-width="0px"
                  :prop="`data.${scope.$index}.scheCalcType`"
                  :rules="[{ required: true, message: '计算方式不能为空'}]"
                >
                  <el-select v-model="scope.row.scheCalcType" size="small" placeholder="请选择" @change="((val)=>{handleSelectScheCalcType(val, scope.row)})">
                    <el-option v-for="item in childTableForm.scheCalcTypeComboxOptions" :key="item.dictCode" size="small" :label="item.name" :value="item.dictCode" />
                  </el-select>
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="权值(1~5)" prop="weights" label-class-name="require">
              <template slot-scope="scope">
                <template v-if="!isEdit">
                  {{ scope.row.weights }}
                </template>
                <template v-else-if="scope.row.taskType === '0'" />
                <el-form-item
                  v-else
                  label-width="0px"
                  :prop="`data.${scope.$index}.scheCalcType`"
                >
                  <el-input-number v-model="scope.row.weights" step-strictly :min="1" :max="5" controls-position="right" size="small" />
                </el-form-item>
              </template>
            </el-table-column>
            <!--   <el-table-column label="费用科目编码" prop="expenseCode" label-class-name="require">
              <template slot-scope="scope">
                <template v-if="!isEdit">
                  {{ scope.row.expenseCode }}
                </template>
                <el-form-item
                  v-else
                  label-width="0px"
                  :prop="`data.${scope.$index}.expenseCode`"
                  :rules="[{ required: true, message: '科目编码不能为空'}]"
                >
                  <el-input
                    v-model="scope.row.expenseCode"
                    size="mini"
                    placeholder="请输入费用科目编码"
                  />
                </el-form-item>
              </template>
            </el-table-column>
            <el-table-column label="费用科目" prop="expenseName" label-class-name="require">
              <template slot-scope="scope">
                <template v-if="!isEdit">
                  {{ scope.row.expenseName }}
                </template>
                <el-form-item
                  v-else
                  label-width="0px"
                  :prop="`data.${scope.$index}.expenseName`"
                  :rules="[{ required: true, message: '科目不能为空'}]"
                >
                  <el-select v-model="scope.row.expenseName" size="small" placeholder="请选择" @change="((val)=>{handleSelectExpense(val, scope.row)})">
                    <el-option v-for="item in childTableForm.expenseComboxOptions" :key="item.dictCode" size="small" :label="item.name" :value="item.dictCode" />
                  </el-select>
                </el-form-item>
              </template>
            </el-table-column> -->
            <template v-if="!isDetail && isEdit">
              <el-table-column label="操作">
                <template slot-scope="scope">
                  <el-link :underline="false" type="primary" @click="handleChildTemplateDel(scope.row,scope.$index)">删除</el-link>
                </template>
              </el-table-column>
            </template>
          </el-table>
        </el-form>
      </div>
    </el-card>
    <el-dialog
      :title="templateForm.title"
      :visible.sync="editTemplateDialogVisible"
      :close-on-click-modal="false"
      width="50%"
    >
      <el-form ref="templateForm" :model="templateForm.editMode === 'add' ? templateForm.data : templateForm.tempData" label-width="auto" size="small" label-suffix="" :rules="templateForm.rules">
        <el-row>
          <el-col :xl="24" :lg="24" :md="24" :sm="24" :xs="24">
            <el-form-item label="名称：" prop="tempName">
              <el-input v-if="templateForm.editMode === 'add'" v-model.trim="templateForm.data.tempName" />
              <el-input v-else v-model.trim="templateForm.tempData.tempName" />
            </el-form-item>
          </el-col>
          <el-col :xl="24" :lg="24" :md="24" :sm="24" :xs="24">
            <el-form-item label="备注：">
              <el-input v-if="templateForm.editMode === 'add'" v-model.trim="templateForm.data.remark" maxlength="100" type="textarea" resize="none" />
              <el-input v-else v-model.trim="templateForm.tempData.remark" maxlength="100" type="textarea" resize="none" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <span slot="footer">
        <div style="text-align: center;">
          <el-button type="primary" size="mini" :loading="templateForm.submiting" @click="handleSaveTemplateForm('templateForm')">确 定</el-button>
          <el-button size="mini" @click="editTemplateDialogVisible = false">取 消</el-button>
        </div>
      </span>
    </el-dialog>
    <el-dialog :visible.sync="importLoading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>
    <el-dialog :visible.sync="importTemplateDialogVisible" width="40%" :show-close="false" title="导入作业模板" :close-on-click-modal="false">
      <el-upload
        ref="uploadTemplate"
        :action="action"
        :on-change="handleTemplateFileChange"
        :auto-upload="false"
        :file-list="fileList"
        :on-progress="importTemplateProcess"
        :before-upload="beforeImportTemplate"
        :on-success="importTemplateSuccess"
        :on-error="importTemplateError"
        accept="application/vnd.ms-excel,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
      >
        <el-button slot="trigger" type="primary" size="mini">选择文件</el-button>
        <div slot="tip" class="el-upload__tip" :style="templateFileValidStyleObject">{{ templateFileValidStyleObject.text }}</div>
      </el-upload>
      <span slot="footer" class="dialog-footer">
        <el-button size="mini" type="primary" @click="toImportTemplate">确定</el-button>
        <el-button size="mini" @click="importTemplateDialogVisible = false">取消</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import { getTaskTemplateList, saveTaskTemplate, deleteTaskTemplate } from '@/api/taskTemplate'
import { iterm, getTaskComboBox } from '@/api/taskComboBox'
import { getTentantFlag } from '@/api/user'
import { mapGetters } from 'vuex'
import store from '@/store'
export default {
  name: 'TaskTemplate',
  components: {
  },
  props: {
    isDetail: {
      type: Boolean,
      default: false
    }
  },
  data() {
    var vm = this
    return {
      searchForm: {
      },
      editTemplateDialogVisible: false,
      primaryTableData: [],
      primaryTableCurrentRow: {},
      primaryTableCurrentTempRow: {},
      childTableForm: {
        isSearchChildData: false,
        isSearchChildData_: false,
        // searchCount: 0,
        // oldSearchCount: 0,
        search: {
          taskName: '',
          taskType: ''
        },
        searchTemp: {
          taskName: '',
          taskType: ''
        },
        cacheData: [],
        data: [],
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
        taskTypeComboxOptions: [
          {
            name: '里程碑',
            dictCode: '0'
          }, {
            name: '作业',
            dictCode: '1'
          }
        ],
        expenseComboxOptions: [
          {
            name: '科目一',
            dictCode: '0'
          }, {
            name: '科目二',
            dictCode: '1'
          }, {
            name: '科目三',
            dictCode: '2'
          }
        ],
        currentRow: null,
        childTableHeight: 57
      },
      isEdit: false,
      templateForm: {
        title: '',
        editMode: '',
        submiting: false,
        tentantId: null,
        data: {
          tempName: ''
        },
        tempData: {
          tempName: '',
          remark: ''
        },
        rules: {
          tempName: [
            { required: true, message: '请输入模板名称', trigger: 'blur' },
            { max: 50, message: '最多可输入50个字符', trigger: 'blur' },
            {
              validator(rule, value, callback) {
                if (vm.templateForm.editMode === 'edit' && vm.templateForm.data.tempName === value) {
                  callback()
                }
                if (vm.isEdit && vm.primaryTableCurrentTempRow.tempName === value) {
                  callback()
                }
                getTaskTemplateList({ ...vm.globalParam, ... { tempName: value, tentantId: vm.tentantId }}).then(res => {
                  if (res.state === 'success') {
                    if (res.data.some(item => item.tempName === value)) {
                      callback(new Error('模板名称不能重复'))
                    } else {
                      callback()
                    }
                  } else {
                    vm.$message.error('模板名称唯一校验出错')
                  }
                })
              },
              trigger: 'blur'
            }
          ]
        }
      },
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0,
        pageSizes: [10, 20, 50, 100],
        layout: 'total, sizes, prev, pager, next, jumper'
      },
      importTemplateDialogVisible: false,
      fileList: [],
      templateFileValidStyleObject: {
        text: '只能上传xls/xlsx文件'
      },
      action: `${process.env.VUE_APP_BASE_API}project-schedule/scheTask/upload`,
      importLoading: false,
      progressPercent: 0,
      bfweb: process.env.VUE_APP_BFWEB === 'true'

    }
  },
  computed: {
    /* filterChildTableData: {
      get: function() {
        var vm = this
        if (this.childTableForm.isSearchChildData) {
          vm.childTableForm.isSearchChildData = false
          vm.childTableForm.searchCount += 1
          vm.childTableForm.cacheData = vm.childTableForm.data.filter(function(iterm) {
            return vm.onBeforeChildTableDisplay(iterm)
          })
          return vm.childTableForm.cacheData
        } else if (vm.childTableForm.searchCount > 0) {
          return vm.childTableForm.cacheData
        } else {
          return vm.childTableForm.data
        }
      },
      set: function(newValue) {
      }
    } */
    searchCount() {
      return this.childTableForm.searchCount
    },
    ...mapGetters([
      'userId'
    ])
  },
  watch: {
    searchCount: {
      handler(val, oldVal) {
        this.childTableForm.oldSearchCount = oldVal || 0
      },
      immediate: true
    },
    isEdit: {
      handler(val, oldVal) {
        if (val) {
          this.childTableForm.childTableHeight = 85
        } else {
          this.childTableForm.childTableHeight = 57
        }
      }
    }
  },
  mounted() {
  },
  async created() {
    await this.initParam()
    this.fetchPrimaryData()
    this.getTaskComboBox()
  },
  methods: {
    async initParam() {
      let tentantFlag
      await getTentantFlag().then(res => {
        tentantFlag = res.data
      })
      if (tentantFlag) {
        /*  await getUserInfo(this.userId).then(res => {
          this.tentantId = res.tentantId
        }) */
        this.tentantId = store.getters.tentantId
      }
    },
    fetchPrimaryData(isRefreshChild) {
      const param = { ... this.searchForm, ...{ pageSize: this.pagination.pageSize, pageIndex: this.pagination.currentPage }}
      if (this.tentantId) {
        param.tentantId = this.tentantId
      }
      getTaskTemplateList(param).then(res => {
        if (res.state === 'success') {
          this.primaryTableData = res.data
          if (this.primaryTableData && this.primaryTableData.length > 0 && this.primaryTableCurrentRow) {
            if (JSON.stringify(this.primaryTableCurrentRow) === '{}') {
              this.$refs.primaryTable.setCurrentRow(this.primaryTableData[0])
            } else {
              this.$refs.primaryTable.setCurrentRow(this.primaryTableData.find((element) => (element.id === this.primaryTableCurrentRow.id)))
            }
          }
          // this.pagination.total = res.total
        } else {
          this.$message.error('查询模板列表失败')
        }
      })
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val
      this.fetchPrimaryData()
    },
    paginationCurrentChange(currentPage) {
      this.pagination.currentPage = currentPage
      this.fetchPrimaryData()
    },
    addTemplate() {
      this.templateForm.data = {
        tempName: '',
        remark: ''
      }
      if (this.$refs.templateForm) {
        // this.resetForm('templateForm')
        this.$refs['templateForm'].clearValidate()
      }
      this.templateForm.editMode = 'add'
      this.templateForm.title = '新增模板'
      this.editTemplateDialogVisible = true
    },
    handleSaveTemplateForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.templateForm.submiting = true
          // if (this.templateForm.editMode === 'add') {
          // this.primaryTableData.push(this.templateForm.data)
          let data
          if (this.templateForm.editMode === 'add') {
            data = { ...this.globalParam, ...this.templateForm.data }
            if (this.tentantId) {
              data.tentantId = this.tentantId
            }
          } else {
            data = { ...this.globalParam, ...this.templateForm.tempData }
          }
          saveTaskTemplate(null, data).then(res => {
            if (res.state === 'success') {
              this.$message.success('保存成功')
              this.fetchPrimaryData()
            } else {
              this.$message.error('保存失败')
            }
          }).catch(() => {
          }).finally(() => {
          })
          // } else {
          //   console.log(this.templateForm.data)
          // }
          this.templateForm.submiting = false
          this.editTemplateDialogVisible = false
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    handlePrimaryTemplateEdit(row, index) {
      if (this.$refs.templateForm) {
        this.$refs['templateForm'].resetFields()
      }
      // this.resetForm('templateForm')
      this.templateForm.data = row
      this.templateForm.editMode = 'edit'
      this.templateForm.title = '编辑模板'
      this.templateForm.tempData = { ...row }
      this.editTemplateDialogVisible = true
    },
    handlePrimaryTemplateCopy(row, index) {
      // this.resetForm('templateForm')
      if (this.$refs.templateForm) {
        this.$refs['templateForm'].resetFields()
      }
      this.templateForm.data = row
      this.templateForm.editMode = 'copy'
      this.templateForm.title = '复制增加'
      this.templateForm.tempData = { ...row }
      this.templateForm.tempData.id = null
      this.editTemplateDialogVisible = true
    },
    handlePrimaryTemplateDel(row, index) {
      this.$confirm(`确定要删除该模板吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        deleteTaskTemplate(row.id).then(res => {
          if (res.state === 'success') {
            this.fetchPrimaryData()
            this.$message.success('删除成功')
          } else {
            this.$message.error('删除失败')
          }
        }).catch(() => {
        }).finally(() => {
        })
      }).catch(() => {
      })
    },
    handleChildTableEdit() {
      this.isEdit = true
    },
    handleChildTableEditCancel() {
      this.isEdit = false
      console.log(this.$refs)
      if (this.$refs.templateForm) {
        console.log('清空')
        this.$refs['templateForm'].resetFields()
      }
      this.fetchPrimaryData()
    },
    handleChildTemplateDel(row, index) {
      this.childTableForm.data.splice(index, 1)
    },
    handleAddChildTemplate(operate) {
      const childTableRowData = {
        taskName: '',
        taskType: '1',
        scheCalcType: '01',
        weights: '',
        taskTypeName: this.childTableForm.taskTypeComboxOptions.find((element) => (element.dictCode === '1')).name,
        scheCalcTypeName: this.childTableForm.scheCalcTypeComboxOptions.find((element) => (element.dictCode === '01')).name
      /*   ,
        expenseCode: '',
        expenseName: '' */
      }
      switch (operate) {
        case 'before':
          if (this.childTableForm.currentRow) {
            this.childTableForm.data.splice(this.childTableForm.currentRow.index, 0, childTableRowData)
          } else {
            this.childTableForm.data.unshift(childTableRowData)
          }
          break
        case 'backward':
          if (this.childTableForm.currentRow) {
            this.childTableForm.data.splice(this.childTableForm.currentRow.index + 1, 0, childTableRowData)
          } else {
            this.childTableForm.data.push(childTableRowData)
          }
          break
      }
    },
    // handleMoveChildTemplate(operate) {
    //   switch (operate) {
    //     case 'moveUp':
    //       if (!this.childTableForm.currentRow) {
    //         return this.$message({
    //           message: '请先选择要移动的作业',
    //           type: 'warning'
    //         })
    //       }
    //       /*    for (let i = 0, len = this.childTableForm.data.length; i < len; i++) {
    //         if (Object.is(this.childTableForm.data[i], this.childTableForm.currentRow)) {
    //           if (i > 0) {
    //             const template = this.childTableForm.data[i - 1]
    //             this.childTableForm.data[i - 1] = this.childTableForm.data[i]
    //             this.childTableForm.data[i] = template
    //             this.$set(this.childTableForm.data)
    //             console.log(111111)
    //           }
    //         }
    //       } */
    //       // console.log(this.childTableForm.data.splice(this.childTableForm.currentRow.index, 1)[0])
    //       break
    //     case 'moveDown':
    //       break
    //   }
    // },
    handleMoveChildTemplate(change) {
      if (!this.childTableForm.currentRow) {
        return this.$message({
          message: '请先选择要移动的作业',
          type: 'warning'
        })
      }
      const index = this.childTableForm.currentRow.index
      if ((index + change) >= 0 && ((index + change) <= this.childTableForm.data.length)) {
        this.childTableForm.data.splice(index, 1)[0]
        this.childTableForm.data.splice(index + change, 0, this.childTableForm.currentRow)
      }
    },
    resetForm(formName) {
      this.$nextTick(() => {
        this.$refs[formName].resetFields()
        this.fetchPrimaryData()
      })
    },
    handleParentTableCurrentChange(currentRow, oldCurrentRow) {
      this.primaryTableCurrentTempRow = { ...currentRow }
      this.primaryTableCurrentRow = currentRow || {}
      this.childTableForm.search = this.childTableForm.searchTemp = {
        taskName: '',
        taskType: ''
      }
      this.childTableForm.data = this.primaryTableCurrentRow.detList || []
      this.childTableForm.data.forEach((item, index, array) => {
        item.taskTypeName = this.childTableForm.taskTypeComboxOptions.find((element) => (element.dictCode === item.taskType)).name
        if (item.scheCalcType) {
          item.scheCalcTypeName = this.childTableForm.scheCalcTypeComboxOptions.find((element) => (element.dictCode === item.scheCalcType)).name
        }
      })
      this.templateForm.tempData.tempName = currentRow.tempName
      this.templateForm.tempData.remark = currentRow.remark
    },
    handleChildTableCurrentChange(currentRow, oldCurrentRow) {
      if (this.isEdit) {
        this.childTableForm.currentRow = currentRow
      }
    },
    tableRowClassName({ row, rowIndex }) {
      // 把每一行的索引放进row
      row.index = rowIndex
      // if ((this.childTableForm.searchCount - this.childTableForm.oldSearchCount === 1) && !this.onBeforeChildTableDisplay(row)) {
      if (this.childTableForm.isSearchChildData_ && !this.onBeforeChildTableDisplay(row)) {
        this.childTableForm.isSearchChildData = false
        return 'hidden-row'
      }
      return ''
    },
    handleSaveChildTableForm(formName) {
      const validChildTableForm = new Promise((resolve, reject) => {
        this.$refs[formName].validate(valid => {
          if (valid) { resolve(formName) } else { reject(formName) }
        })
      })
      const validPrimaryForm = new Promise((resolve, reject) => {
        this.$refs['primaryInfoForm'].validate(valid => {
          if (valid) { resolve(formName) } else { reject(formName) }
        })
      })
      Promise.all([validChildTableForm, validPrimaryForm]).then((value) => {
        this.primaryTableCurrentRow.tempName = this.templateForm.tempData.tempName
        this.primaryTableCurrentRow.remark = this.templateForm.tempData.remark
        this.primaryTableCurrentRow.detList = this.childTableForm.data
        saveTaskTemplate(null, this.primaryTableCurrentRow).then(res => {
          if (res.state === 'success') {
            this.isEdit = false
            this.childTableForm.data = res.data.detList
            this.$message.success('保存成功')
          } else {
            this.$message.error('保存失败')
          }
        }).catch(() => {
        }).finally(() => {
        })
      }).catch((e) => {
        console.log('error submit!!')
        return false
      }).finally(() => {
      })
      // this.$refs[formName].$refs['primaryInfoForm'].validate((valid) => {
      //   if (valid) {
      //     this.primaryTableCurrentRow.detList = this.childTableForm.data
      //     saveTaskTemplate(null, this.primaryTableCurrentRow).then(res => {
      //       if (res.state === 'success') {
      //         this.isEdit = false
      //         this.childTableForm.data = res.data.detList
      //         this.$message.success('保存成功')
      //       } else {
      //         this.$message.error('保存失败')
      //       }
      //     }).catch(() => {
      //     }).finally(() => {
      //     })
      //   } else {
      //     console.log('error submit!!')
      //     return false
      //   }
      // })
    },
    downloadTemplate() {
      window.location.href = process.env.VUE_APP_BASE_API + 'project-schedule/scheTask/download'
    },
    handleTemplateFileChange(file, fileList) {
      // this.fileList = fileList
      this.templateFileValidStyleObject = {
        color: '',
        text: '只能上传xls/xlsx文件'
      }
      if (fileList.length > 0) {
        this.fileList = [fileList[fileList.length - 1]]
      }
    },
    toImportTemplate() {
      if (this.fileList.length) {
        this.progressPercent = 0
        this.importLoading = true
        this.$refs.uploadTemplate.submit()
      } else {
        this.templateFileValidStyleObject = {
          color: '#f56c6c',
          text: '请先选择要导入的文件'
        }
      }
    },
    beforeImportTemplate(file) {
    },
    importTemplateSuccess(response, file, fileList) {
      file.status = 'ready'
      this.importLoading = false
      if (response && (response.taskTempData || response.istemplent || response.isexcel || response.isdata)) {
        if (response.taskTempData) {
          this.importTemplateDialogVisible = false
          return this.childTableForm.data.splice(0, 0, ...response.taskTempData)
        }
        let message = ''
        if (response.istemplent) {
          message = response.istemplent
        }
        if (response.isexcel) {
          message = response.isexcel
        }
        if (response.isdata) {
          message = response.isdata
        }
        this.$alert('<span style="color: #f56c6c;">' + message + '</span>', '导入错误', {
          confirmButtonText: '确定',
          dangerouslyUseHTMLString: true
        })
      } else {
        this.importTemplateDialogVisible = false
        this.$message({
          type: 'success',
          message: '导入成功!'
        })
      }
    },
    importTemplateError(error_, file, fileList) {
    },
    importTemplateProcess(event, file, fileList) {
      // this.progressPercent = file.percentage.toFixed(0)
      // this.progressPercent = event.percent.toFixed(0)
      this.progressPercent = Math.floor(event.percent)
    },
    onBeforeChildTableDisplay(row) {
      if (!row.taskName) {
        return true
      }
      var count = 0
      if (this.childTableForm.searchTemp.taskName) {
        if (row.taskName.indexOf(this.childTableForm.searchTemp.taskName) > -1) {
          count++
        }
      } else {
        count++
      }
      if (this.childTableForm.searchTemp.taskType) {
        if (row.taskType === this.childTableForm.searchTemp.taskType) {
          count++
        }
      } else {
        count++
      }
      if (count === 2) {
        return true
      } else {
        return false
      }
    },
    handleSearchChildTableData() {
      // this.childTableForm.searchCount += 1
      if (this.isEdit) {
        this.$refs['childTableForm'].validate((valid) => {
          if (valid) {
            this.childTableForm.isSearchChildData_ = this.childTableForm.isSearchChildData = true
            this.childTableForm.searchTemp = { ...this.childTableForm.search }
          } else {
            return this.$message({
              showClose: true,
              message: '请完成编辑后再查询',
              type: 'warning'
            })
          }
        })
      } else {
        this.childTableForm.isSearchChildData_ = this.childTableForm.isSearchChildData = true
        this.childTableForm.searchTemp = { ...this.childTableForm.search }
      }
    },
    handleSelectTaskType(value, row) {
      if (value === '0') {
        row.scheCalcType = row.scheCalcTypeName = row.weights = null
      }
      row.taskTypeName = this.childTableForm.taskTypeComboxOptions.find((element) => (element.dictCode === value)).name
    },
    handleSelectScheCalcType(value, row) {
      row.scheCalcTypeName = this.childTableForm.scheCalcTypeComboxOptions.find((element) => (element.dictCode === value)).name
    },
    handleSelectExpense(value, row) {
      row.expenseName = this.childTableForm.expenseComboxOptions.find((element) => (element.dictCode === value)).name
    },
    primaryTableDoubleClick(row, column, event) {
      if (this.isDetail) {
        this.$emit('after-template-selection', JSON.parse(JSON.stringify(row.detList)))
      }
    },
    getTaskComboBox() {
      getTaskComboBox({ itemId: iterm.workTypeId }).then(res => {
        this.childTableForm.taskTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化作业类型下拉框失败')
      }).finally(() => {
      })
      getTaskComboBox({ itemId: iterm.calculateTypeId }).then(res => {
        // TODO
        this.childTableForm.scheCalcTypeComboxOptions = res.filter(function(item, index) {
          if (item.dictCode !== '02') {
            return item
          }
        })
      }).catch(() => {
        this.$message.error('初始化计算方式下拉框失败')
      }).finally(() => {
      })
    }
  }
}
</script>
<style lang="scss" scoped>
/deep/ .table-header .buttons-right {
  float: right !important;
  padding-right: 20px !important;
}
/deep/ .el-card__header {
    padding: 10px 20px;
    border-bottom: 1px solid #EBEEF5;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}
/deep/ .el-table::before {
  z-index: auto;
 }
</style>
<style>
.search-form{
    padding-left: 12px;
}

label{
    font-weight: normal;
}

.edit-table .el-form-item--mini.el-form-item, .edit-table .el-form-item--small.el-form-item {
  margin-top: 18px;
}

.el-table .hidden-row {
    display: none;
  }

.table-header .buttons-right {
  float: right;
  padding-right: 20px;
}
</style>
