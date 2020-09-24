<template>
  <div ref="pageDiv" class="clearfix wbsTemDiv">
    <el-card class="box-card">
      <div ref="formInlinediv" class="clearfix">
        <el-form ref="formInline" :model="formInline" size="mini" :inline="true" label-width="auto" :rules="rules" style="margin-top:10px">
          <el-row style="padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
            <el-form-item label="模板名称：" prop="name" style="margin-left:18px;">
              <el-input v-model="formInline.name" placeholder="" size="mini" style="width: 160px;margin-left:5px" clearable />
            </el-form-item>
            <el-form-item label="行业：" prop="profeType">
              <el-select v-model="formInline.profeType" placeholder="行业" size="mini" style="width: 160px;margin-left:5px" clearable @change="selectProjectTypeList('')">
                <el-option
                  v-for="item in profeTypeList"
                  :key="item.dictCode"
                  :label="item.name"
                  :value="item.dictCode"
                />
              </el-select>
            </el-form-item>
            <el-form-item label="项目类型：" prop="engType">
              <el-select v-model="formInline.engType" placeholder="项目类型" size="mini" style="width: 160px;margin-left:5px" clearable>
                <el-option
                  v-for="item in projectTypeList"
                  :key="item.dictCode"
                  :label="item.name"
                  :value="item.dictCode"
                />
              </el-select>
            </el-form-item>
          </el-row>
          <el-row style="padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
            <el-form-item label="备注：" prop="remark" style="margin-left:18px;">
              <el-input v-model="formInline.remark" type="textarea" :rows="1" placeholder="" size="mini" style="width: 700px;margin-left:5px" clearable />
            </el-form-item>
          </el-row>
          <!-- <el-row :gutter="24">
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8">
              <el-form-item label="模板名称">
                <el-input v-model="formInline.name" />
              </el-form-item>
            </el-col>
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8">
              <el-form-item label="行业">
                <el-select v-model="formInline.profeType" placeholder="请选择项目类型" @change="selectProjectTypeList()">
                  <el-option
                    v-for="item in profeTypeList"
                    :key="item.value"
                    :label="item.name"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8">
              <el-form-item label="项目类型">
                <el-select v-model="formInline.engType" placeholder="请选择项目类型">
                  <el-option
                    v-for="item in projectTypeList"
                    :key="item.value"
                    :label="item.name"
                    :value="item.value"
                  />
                </el-select></el-form-item>
            </el-col>

          </el-row>
          <el-row :gutter="24">
            <el-col :xl="24" :lg="24" :md="24" :sm="24" :xs="24">
              <el-form-item label="备注">
                <el-input
                  v-model="formInline.remark"
                  type="textarea"
                  :rows="1"
                  placeholder="请输入内容"
                /></el-form-item>
            </el-col>
          </el-row> -->
        </el-form>
      </div>
    </el-card>
    <el-card :body-style="{ padding: '0px' }" class="box-card">
      <!-- <div ref="cardtwoheader" slot="header" class="clearfix">
        <span>wbs信息</span>
      </div> -->
      <div ref="topDiv" class="clearfix">
        <!-- <el-row class="clearfix">
          <el-form :model="planform" size="mini" label-width="auto" style="margin-left:10px;margin-top:10px">
            <el-row :gutter="6">
              <el-col :xl="4" :lg="4" :md="4" :sm="4" :xs="4">
                <el-form-item label="编码">
                  <el-input v-model="planform.wbsCode" placeholder="编码" />
                </el-form-item>
              </el-col>
              <el-col :xl="4" :lg="4" :md="4" :sm="4" :xs="4">
                <el-form-item label="名称">
                  <el-input v-model="planform.wbsName" placeholder="名称" />
                </el-form-item>
              </el-col>
              <el-col :xl="4" :lg="4" :md="4" :sm="4" :xs="4">
                <el-form-item label="级别">
                  <el-select v-model="planform.wbsLevel" placeholder="级别">
                    <el-option
                      v-for="item in planLevelList"
                      :key="item.value"
                      :label="item.name"
                      :value="item.value"
                    />
                  </el-select>
                </el-form-item>
              </el-col>
              <el-col :xl="12" :lg="12" :md="12" :sm="12" :xs="12">
                <el-button type="primary" size="mini" icon="el-icon-search" @click="searchPlan()">查询</el-button>
                |
                <el-button type="primary" size="mini" @click="importTemplate">导入</el-button>
                <el-button type="primary" size="mini" @click="setCodeRule">设置编码</el-button>
                <el-button type="primary" size="mini" @click="exportTemplate">导出</el-button>
                <el-button type="primary" size="mini" @click="toWeight()">自动生成权重</el-button>
              </el-col>
            </el-row>
          </el-form>
        </el-row> -->
        <el-row class="clearfix">
          <div class="mt-10" style="float:right;padding:10px 10px 5px 0px;">
            <span style="font-size:14px;margin-right:10px;">当前编码规则：{{ formInline.wbsCodeRuleName? formInline.wbsCodeRuleName:"-" }}</span>
            <el-button type="primary" size="mini" @click="importTemplate">导入</el-button>
            <el-button type="primary" size="mini" @click="setCodeRule">选择编码规则</el-button>
            <el-button type="primary" size="mini" @click="toWeight()">自动生成权重</el-button>

          </div>
          <div class="ml-10" style="padding:10px 0px 0px 10px;">
            <el-link :underline="false" class="button-group" @click="openAll">全部展开</el-link>
            <el-link :underline="false" class="ml-10 button-group" @click="closeAll">全部收起</el-link>
            <el-link :underline="false" class="ml-10 button-group" @click="addNode">新增同级节点</el-link>
            <el-link :underline="false" class="ml-10 button-group" @click="addChildren">新增子节点</el-link>
            <el-link :underline="false" class="ml-10 button-group" @click="deletePlan">删除</el-link>
            <el-link :underline="false" class="ml-10 button-group" @click="up">上移</el-link>
            <el-link :underline="false" class="ml-10 button-group" @click="down">下移</el-link>

            <!-- <a href="javascript:void(0)" style="font-size:12px;text-decoration:underline;" @click="addNode">新增同级节点</a>
            <a href="javascript:void(0)" style="font-size:12px;text-decoration:underline;" @click="addChildren">新增子节点</a>
            <a href="javascript:void(0)" style="font-size:12px;text-decoration:underline;" @click="deletePlan">删除</a>
            <a href="javascript:void(0)" style="font-size:12px;text-decoration:underline;" @click="up">上移</a>
            <a href="javascript:void(0)" style="font-size:12px;text-decoration:underline;" @click="down">下移</a>
            <a href="javascript:void(0)" style="font-size:12px;text-decoration:underline;" @click="openAll">全部展开</a>
            <a href="javascript:void(0)" style="font-size:12px;text-decoration:underline;" @click="closeAll">全部收起</a> -->
            <!-- <el-tooltip effect="dark" content="新增根节点" placement="top">
              <el-button icon="el-icon-folder-add" size="mini" circle @click="addNode" />
            </el-tooltip>
            <el-tooltip effect="dark" content="新增子节点" placement="top">
              <el-button icon="el-icon-plus" size="mini" circle @click="addChildren" />
            </el-tooltip>
            <el-tooltip effect="dark" content="上方添加节点" placement="top">
              <el-button icon="el-icon-circle-plus-outline" size="mini" circle @click="addPrevNode" />
            </el-tooltip>
            <el-tooltip effect="dark" content="下方添加节点" placement="top">
              <el-button icon="el-icon-circle-plus" size="mini" circle @click="addNextNode" />
            </el-tooltip>
            <el-tooltip effect="dark" content="上移" placement="top">
              <el-button icon="el-icon-top" size="mini" circle @click="up" />
            </el-tooltip>
            <el-tooltip effect="dark" content="下移" placement="top">
              <el-button icon="el-icon-bottom" size="mini" circle @click="down" />
            </el-tooltip>
            <el-tooltip effect="dark" content="升级" placement="top">
              <el-button icon="el-icon-upload2" size="mini" circle @click="upLevel" />
            </el-tooltip>
            <el-tooltip effect="dark" content="降级" placement="top">
              <el-button icon="el-icon-download" size="mini" circle @click="downLevel" />
            </el-tooltip>
            <el-tooltip effect="dark" content="展开" placement="top">
              <el-button icon="el-icon-caret-bottom" size="mini" circle @click="openAll" />
            </el-tooltip>
            <el-tooltip effect="dark" content="收起" placement="top">
              <el-button icon="el-icon-caret-top" size="mini" circle @click="closeAll" />
            </el-tooltip> -->
          </div>

        </el-row>
      </div>
      <el-row class="clearfix">
        <el-table
          ref="tableTree"
          v-loading="loading"
          :data="templateTable"
          row-key="id"
          element-loading-text="拼命加载中，请稍候"
          border
          :max-height="maxHeight"
          default-expand-all
          highlight-current-row
          :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
          @current-change="handleCurrentChange"
        >
          <el-table-column label="序号" type="index" align="left" width="55" />
          <el-table-column v-if="false" prop="id" label="主键Id" />
          <el-table-column v-if="false" prop="parentId" label="父Id" />
          <el-table-column v-if="false" prop="tempWbsId" label="tempWbsId" />
          <el-table-column prop="tempCode" label="编码" width="300" align="left">
            <template slot-scope="scope">
              <span v-if="forbidden">
                <el-input v-model="scope.row.tempCode" style="width:160px;" placeholder="请输入编码" readonly @blur="verifyTempCode(scope.$index,scope.row)" />
              </span>
              <span v-else>{{ scope.row['tempCode'] }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="tempName" label="名称" align="center">
            <template slot-scope="scope">
              <span v-if="forbidden">
                <el-input v-model="scope.row.tempName" placeholder="请输入名称" @blur="verifyTempName(scope.$index,scope.row)" />
              </span>
              <span v-else>{{ scope.row['tempName'] }}</span>
            </template>
          </el-table-column>

          <el-table-column prop="level" label="级别" width="160" align="center">
            <template slot-scope="scope">
              <span v-if="forbidden">
                <el-select v-model="scope.row.level" placeholder="请输入级别" @change="verifyLevelRule(scope.$index,scope.row)">
                  <el-option
                    v-for="item in planLevelList"
                    :key="item.dictCode"
                    :label="item.name"
                    :value="item.dictCode"
                  />
                </el-select>
              </span>
              <span v-else>{{ scope.row['level'] }}</span>
            </template>
          </el-table-column>
          <el-table-column prop="weights" label="权重（%）" width="100" align="center" />
          <el-table-column prop="weightValue" label="权值" width="160" align="center">
            <template slot-scope="scope">
              <span v-if="forbidden">
                <el-input-number v-model="scope.row.weightValue" controls-position="right" :precision="0" :min="1" :max="5" size="small" @change="changeWeightsVal(scope.$index,scope.row)" />
              </span>
              <span v-else>{{ scope.row['weightValue'] }}</span>
            </template>
          </el-table-column>
          <!-- <el-table-column label="操作" align="center">
            <template slot-scope="scope">
              <el-link :underline="false" type="primary" @click="deletePlan(scope.$index, scope.row)">删除</el-link>
            </template>
          </el-table-column> -->
        </el-table>

      </el-row>
      <div ref="bottomDiv" class="clearfix">
        <el-row type="flex" class="box-card" justify="center" style="margin-top:10px;margin-bottom:10px">
          <el-button size="mini" type="primary" :loading="submiting" @click="toSave">保 存</el-button>
          <el-button size="mini" @click="goback">取 消</el-button>
        </el-row>
      </div>
    </el-card>
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
    <el-dialog :visible.sync="codeRuleVisible" width="90%" :show-close="true" title="选择编码规则" :close-on-click-modal="true">
      <SelectCodeRule v-if="codeRuleVisible" :sel-professional="selProfessional" :sel-project-type="selProjectType" @setSelectValue="getBackData" @closeCodeRule="closeCodeRule" />
    </el-dialog>
  </div>

</template>

<script>
import { getDictByItemId, getWbsTempById, getScheWbsTempDet, saveWbsTempData, importWbsDet, getWbsRuleCode } from '@/api/wbsPlan'// getScheWbsTempDet,
import SelectCodeRule from './SelectCodeRule.vue'
import { mapGetters } from 'vuex'
export default {
  name: 'WbsDetail',
  components: {
    SelectCodeRule
  },
  props: {
    templateId: {
      type: String,
      default: ''
    },
    templateCopy: {
      type: String,
      default: ''
    },
    toTemplateList: {
      type: Function,
      default: null
    }
  },
  data() {
    return {
      forbidden: true,
      submiting: false,
      // tableHeight: window.innerHeight > 200 ? window.innerHeight - 210 : 400,
      formInline: {
        id: '',
        name: '',
        engType: '',
        profeType: '',
        isDefault: '',
        wbsCodeRule: '',
        remark: ''
      },
      planform: {
        wbsCode: '',
        wbsName: '',
        wbsLevel: ''
      },
      selProfessional: '',
      selProjectType: '',
      planLevelList: [],
      projectTypeList: [],
      profeTypeList: [],
      templateTable: [],
      loading: false,
      treeArr: [],
      saveLoading: false,
      progressPercent: 0,
      importLoading: false,
      // 导入列表框
      importListVisible: false,
      codeRuleVisible: false,
      fileInfo: {
        name: ''
      },
      maxHeight: 400,
      // tableData: [],
      // 选择人员data
      data: [],
      clickTaskInfo: {},
      // 用来存储关联关系
      screenText: '全屏',
      auditHistoryVisble: false,
      versionHistoryVisble: false,
      currentRow: null,
      // currentParentRow: null,
      rules: {
        name: [
          { required: true, message: '请输入模板名称', tigger: 'blur' }
        ],
        profeType: [
          { required: true, message: '请输入行业', tigger: 'change' }
        ],
        engType: [
          { required: true, message: '请输入项目类型', tigger: 'change' }
        ]
      }

    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  created() {
    this.selectPlanLevelList()
    // this.selectProjectTypeList()
    this.selectProfeTypeList()
    if (this.templateId) { // this.$route.params.id
      getWbsTempById(this.templateId).then(res => {
        if (res && res.code === '200') {
          // this.formInline = res.data
          this.formInline = { ...res.data } || {}
          if (this.templateCopy === '1') {
            this.$set(this.formInline, 'id', '')
            this.$set(this.formInline, 'isDefault', '')
          }
          if (this.formInline.profeType) {
            this.selectProjectTypeList(this.formInline.engType)
          }
        } else {
          this.$message({
            message: '获取wbs模板信息失败',
            type: 'warning'
          })
        }
      })
    }
  },
  mounted() {
    this.getTreeList()
    // this.getMember()
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
    selectProfeTypeList() {
      var this_ = this
      var requestData = { type: 'dict', itemId: '158e8a0a508341beb9dc31423ece82e8' }
      getDictByItemId(requestData).then(res => {
        this_.profeTypeList = res
      }).catch(() => {
        this.$message({
          message: '获取行业失败',
          type: 'error'
        })
      })
    },
    selectProjectTypeList(selectEngType) {
      var this_ = this
      var selectProfeType = this.formInline.profeType
      if (selectProfeType) {
        var selectContent = ''
        for (let i = 0; i < this.profeTypeList.length; i++) {
          if (this.profeTypeList[i].dictCode === selectProfeType) {
            selectContent = this.profeTypeList[i].content1
            break
          }
        }

        var requestData = { itemId: '82ad9e44e8364057945c88927fde13e6', content1: selectContent }
        getDictByItemId(requestData).then(res => {
          this_.projectTypeList = res
          if (selectEngType) {
            this.$set(this.formInline, 'engType', selectEngType)
          }
        }).catch(() => {
          this.$message({
            message: '获取项目类型失败',
            type: 'error'
          })
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
          formFile.append('tempId', this.formInline.wbsCodeRule)
          formFile.append('projectType', this.formInline.engType)
          formFile.append('professional', this.formInline.profeType)
          formFile.append('tentantId', this.tentantId)
          if (this.currentRow) {
            formFile.append('parentCode', this.currentRow.tempCode)
          }
          // var currentIndex = 0
          if (this.currentRow) {
            formFile.append('selectId', this.currentRow.id)
            // for (let i = 0; i < this.treeArr.length; i++) {
            //   if (this.treeArr[i].id === this.currentRow.id) {
            //     currentIndex = i
            //     break
            //   }
            // }
          }

          var onUploadProgress = progressEvent => {
            var complete = (progressEvent.loaded / progressEvent.total * 100 | 0)
            this.progressPercent = complete
          }
          importWbsDet(formFile, onUploadProgress).then(res => {
            this.resetFileInfo()
            this.importLoading = false
            if (res && res.data && res.data.id) {
              this.$message({
                type: 'success',
                message: '导入成功!'
              })
              var insertTreeArr = []
              this.findTree(res.data.scheWbsTempDets, (item) => {
                if (item.parentId === '-1') {
                  item.parentId = ''
                }
                item.level = item.level + ''
                insertTreeArr.push(item)
              })
              // if (this.currentRow) {
              //   insertTreeArr.unshift(currentIndex + 1, 0)
              //   Array.prototype.splice.apply(this.treeArr, insertTreeArr)
              // } else {
              //   this.treeArr = this.treeArr.concat(insertTreeArr)
              // }
              this.treeArr = []
              Object.assign(this.treeArr, insertTreeArr)
              // this.treeArr = insertTreeArr
              this.templateTable = this.toTree(insertTreeArr)
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
    setCurrent(row) {
      this.$refs.tableTree.setCurrentRow(row)
    },
    handleCurrentChange(val) {
      this.currentRow = val
      // this.currentParentRow = val
    },
    GenNonDuplicateID(randomLength) {
      return Number(Math.random().toString().substr(3, randomLength) + Date.now()).toString(36)
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    toTree(data) {
      data.forEach(function(item) {
        delete item.children
      })
      var map = {}
      data.forEach(function(item) {
        map[item.id] = item
      })
      var val = []
      data.forEach(function(item) {
        var parent = map[item.parentId]
        if (parent) {
          (parent.children || (parent.children = [])).push(item)
        } else {
          val.push(item)
        }
      })
      return val
    },
    addNode() {
      if (this.currentRow) {
        this.optData('nextNode')
      } else {
        this.optData('addNode')
      }
    },
    addChildren() {
      if (!this.currentRow) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }

      // if(this.currentRow.id){

      // }
      this.optData('childrenNode')
    },
    addPrevNode() {
      if (!this.currentRow) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      this.optData('prevNode')
    },
    addNextNode() {
      if (!this.currentRow) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      this.optData('nextNode')
    },
    up() {
      if (!this.currentRow) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('shiftUp')
      }
    },
    down() {
      if (!this.currentRow) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('shiftDown')
      }
    },
    upLevel() {
      if (!this.currentRow) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('upgrade')
      }
    },
    downLevel() {
      if (!this.currentRow) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('demotion')
      }
    },
    forArr(arr, isExpand) {
      arr.forEach(i => {
        this.$refs.tableTree.toggleRowExpansion(i, isExpand)
        if (i.children) {
          this.forArr(i.children, isExpand)
        }
      })
    },
    openAll() {
      // var operatorarr = []
      // if (this.currentRow) {
      //   operatorarr.push(this.currentRow)
      //   this.forArr(operatorarr, true)
      // } else {
      this.forArr(this.templateTable, true)
      // }
    },
    closeAll() {
      // var operatorarr = []
      // if (this.currentRow) {
      //   operatorarr.push(this.currentRow)
      //   this.forArr(operatorarr, false)
      // } else {
      this.forArr(this.templateTable, false)
      // }
    },
    getNextTempCode(addtype) {
      var nodeList = []
      var childFlag = '1'
      var isChild = '1'
      return new Promise((resolve, reject) => {
        if (addtype === 'addNode') {
        // 获取parentId为‘’或-1的{childFlag:1,nodeList{parentId为‘’或-1的},isChild:1}

          for (let i = 0; i < this.treeArr.length; i++) {
            if (this.treeArr[i].parentId === '' || this.treeArr[i].parentId === '-1') {
              nodeList.push(this.treeArr[i].tempCode)
            }
          }
        // childFlag = 1
        // isChild = 1
        } else if (addtype === 'childrenNode') {
        // 判断是否有子节点，有获取所有子节点{childFlag:1,nodeList{所有子},isChild:2},没有的话用父节点｛childFlag:2,nodeList{父},isChild:2｝
          var childrenNodes = this.currentRow.children
          if (childrenNodes && childrenNodes.length > 0) {
            for (let i = 0; i < childrenNodes.length; i++) {
              nodeList.push(childrenNodes[i].tempCode)
            }
            // childFlag = 1
            isChild = '2'
          } else {
            nodeList.push(this.currentRow.tempCode)
            childFlag = '2'
            isChild = '2'
          }
        } else {
        // 获取所有兄弟节点{childFlag:1,nodeList{所有兄弟},isChild:2}
          if (this.currentRow.parentId === '' || this.currentRow.parentId === '-1') {
            for (let i = 0; i < this.treeArr.length; i++) {
              if (this.treeArr[i].parentId === '' || this.treeArr[i].parentId === '-1') {
                nodeList.push(this.treeArr[i].tempCode)
              }
            }
          // childFlag = 1
          // isChild = 1
          } else {
            var parentRow = ''
            for (let i = 0; i < this.treeArr.length; i++) {
              if (this.treeArr[i].id === this.currentRow.parentId) {
                parentRow = this.treeArr[i]
              }
            }
            var brotherNodes = parentRow.children
            if (brotherNodes && brotherNodes.length > 0) {
              for (let i = 0; i < brotherNodes.length; i++) {
                nodeList.push(brotherNodes[i].tempCode)
              }
              // childFlag = 1
              isChild = '2'
            }
          }
        }
        var requestParam = { codeType: '1', childFlag: childFlag, nodeList: nodeList, isChild: isChild, tempId: this.formInline.wbsCodeRule, projectType: this.formInline.engType, professional: this.formInline.profeType }
        getWbsRuleCode(requestParam).then(res => {
          if (res && res.messageCode === '200') {
            resolve(res.code)
          }
        }).catch(() => {
          this.$message({
            message: '获取wbs编码失败',
            type: 'error'
          })
        })
      })
    },
    // type 操作类型 isOriginParent是否为祖先节点
    async optData(type, tcode) {
      var curIndex1 = 0
      var parentIndex = 0
      var operatorArr = this.treeArr
      var currentParentRow = {}
      var changeParentId = ''
      var rootRow = []
      if (this.currentRow) {
        for (let i = 0; i < operatorArr.length; i++) {
          if (!operatorArr[i].parentId || operatorArr[i].parentId === '-1') {
            rootRow.push(operatorArr[i])
          }
          if (operatorArr[i].id + '' === this.currentRow.parentId + '') {
            parentIndex = i
            currentParentRow = operatorArr[i]
          }
          if (operatorArr[i].id === this.currentRow.id) {
            curIndex1 = i
            // break
          }
        }
      }
      if (type === 'addNode' || type === 'childrenNode' || type === 'prevNode' || type === 'nextNode') {
        var tmpObj = {
          id: this.GenNonDuplicateID(20),
          tempCode: await this.getNextTempCode(type),
          level: '',
          tempName: '',
          tempWbsId: '',
          weights: '',
          weightValue: '1',
          sortCode: '',
          parentId: '',
          path: '',
          children: null
        }
        if (type === 'addNode') {
          tmpObj.parentId = '-1'
          tmpObj.sortCode = '1'
          this.templateTable.push(tmpObj)
          operatorArr.splice(curIndex1, 0, tmpObj)
          this.treeArr = operatorArr
          for (let i = 0; i < this.treeArr.length; i++) {
            this.$set(this.treeArr[i], 'sortCode', i + 1)
          }
        } else if (type === 'childrenNode') {
          tmpObj.parentId = this.currentRow.id
          tmpObj.sortCode = curIndex1 + 1
          if (this.currentRow.children) {
            this.currentRow.children.push(tmpObj)
          } else {
            var carr = [tmpObj]
            this.currentRow.children = carr
          }
          operatorArr.splice(curIndex1, 0, tmpObj)
          this.treeArr = operatorArr
          for (let i = 0; i < this.treeArr.length; i++) {
            this.$set(this.treeArr[i], 'sortCode', i + 1)
          }
          this.templateTable = this.toTree(this.treeArr)
        } else if (type === 'prevNode') {
          var nowIndex1 = curIndex1 < 1 ? 0 : curIndex1 - 1
          tmpObj.parentId = this.currentRow.parentId
          operatorArr.splice(nowIndex1, 0, tmpObj)
          this.treeArr = operatorArr
          for (let i = 0; i < this.treeArr.length; i++) {
            this.$set(this.treeArr[i], 'sortCode', i + 1)
          }
          this.templateTable = this.toTree(this.treeArr)
        } else if (type === 'nextNode') {
          tmpObj.parentId = this.currentRow.parentId
          operatorArr.splice(curIndex1 + 1, 0, tmpObj)
          this.treeArr = operatorArr
          for (let i = 0; i < this.treeArr.length; i++) {
            this.$set(this.treeArr[i], 'sortCode', i + 1)
          }
          this.templateTable = this.toTree(this.treeArr)
        }
      } else if (type === 'shiftUp') {
        if (curIndex1 === 0 || (curIndex1 === parentIndex + 1 && parentIndex !== 0)) {
          this.$message({
            showClose: true,
            type: 'info',
            message: '第一个节点'
          })
        } else {
          // 插入位置应该是上一个兄弟节点的位置

          var brotherNodes = currentParentRow && currentParentRow.length > 0 ? currentParentRow.children : rootRow
          var brotherId = brotherNodes[0].id
          var brotherIndex = 0
          for (let i = 1; i < brotherNodes.length; i++) {
            if (this.currentRow.id === brotherNodes[i].id) {
              // 当前选择节点
              brotherId = brotherNodes[i - 1].id
              break
            }
          }
          for (let j = 0; j < operatorArr.length; j++) {
            if (operatorArr[j].id === brotherId) {
              brotherIndex = j
              break
            }
          }
          operatorArr[curIndex1] = operatorArr.splice(brotherIndex, 1, operatorArr[curIndex1])[0]
        }

        this.treeArr = operatorArr
        for (let i = 0; i < this.treeArr.length; i++) {
          this.$set(this.treeArr[i], 'sortCode', i + 1)
        }
        this.templateTable = this.toTree(this.treeArr)
      } else if (type === 'shiftDown') {
        brotherNodes = currentParentRow && currentParentRow.length > 0 ? currentParentRow.children : rootRow
        if (brotherNodes && brotherNodes.length > 1) {
          brotherId = ''
          brotherIndex = 0
          for (let i = 0; i < brotherNodes.length; i++) {
            if (this.currentRow.id === brotherNodes[i].id) {
              // 当前选择节点
              if (brotherNodes[i + 1]) {
                brotherId = brotherNodes[i + 1].id
                break
              } else {
                this.$message({
                  showClose: true,
                  type: 'info',
                  message: '最后一个节点'
                })
                break
              }
            }
          }
          if (brotherId) {
            // 插入位置应该是下一个兄弟节点的位置
            for (let j = 0; j < operatorArr.length; j++) {
              if (operatorArr[j].id === brotherId) {
                brotherIndex = j
                break
              }
            }
            operatorArr[curIndex1] = operatorArr.splice(brotherIndex, 1, operatorArr[curIndex1])[0]
            this.treeArr = operatorArr
            for (let i = 0; i < this.treeArr.length; i++) {
              this.$set(this.treeArr[i], 'sortCode', i + 1)
            }
            this.templateTable = this.toTree(this.treeArr)
          }
        } else {
          this.$message({
            showClose: true,
            type: 'info',
            message: '最后一个节点'
          })
        }
      } else if (type === 'upgrade') { // 升级
        if (this.currentRow.parentId === '-1') {
          this.$message({
            showClose: true,
            type: 'info',
            message: '根节点'
          })
        } else {
          operatorArr[curIndex1] = operatorArr.splice(parentIndex, 1, operatorArr[curIndex1])[0]
          changeParentId = currentParentRow.parentId
          operatorArr[parentIndex].parentId = changeParentId
          this.treeArr = operatorArr
          for (let i = 0; i < this.treeArr.length; i++) {
            this.$set(this.treeArr[i], 'sortCode', i + 1)
          }
          this.templateTable = this.toTree(this.treeArr)
        }
      } else if (type === 'demotion') {
        brotherNodes = currentParentRow.children
        if (brotherNodes && brotherNodes.length === 1) {
          this.$message({
            showClose: true,
            type: 'info',
            message: '无法降级'
          })
        } else {
          brotherId = ''
          brotherIndex = 0
          for (let i = 1; i < brotherNodes.length; i++) {
            if (this.currentRow.id === brotherNodes[i].id) {
              // 当前选择节点
              brotherId = brotherNodes[i - 1].id
              if (brotherNodes[i + 1]) {
                brotherId = brotherNodes[i + 1].id
              } else if (brotherNodes[i - 1]) {
                brotherId = brotherNodes[i - 1].id
              }
              break
            }
          }
          for (let j = 0; j < operatorArr.length; j++) {
            if (operatorArr[j].id === brotherId) {
              brotherIndex = j
              break
            }
          }
          operatorArr[curIndex1].parentId = brotherId
          operatorArr[curIndex1] = operatorArr.splice(brotherIndex + 1, 1, operatorArr[curIndex1])[0]

          // if (parentIndex === curIndex1 - childrenLength) { // 最后一个节点
          //   changeParentId = operatorArr[curIndex1 - 1].id
          //   operatorArr[curIndex1].parentId = changeParentId
          //   operatorArr[curIndex1] = operatorArr.splice(parentIndex + 1, 1, operatorArr[curIndex1])[0]
          // } else {
          //   changeParentId = operatorArr[curIndex1 + 1].id
          //   operatorArr[curIndex1].parentId = changeParentId
          //   operatorArr[curIndex1] = operatorArr.splice(curIndex1 + 1, 1, operatorArr[curIndex1])[0]
          // }
          this.treeArr = operatorArr
          for (let i = 0; i < this.treeArr.length; i++) {
            this.$set(this.treeArr[i], 'sortCode', i + 1)
          }
          this.templateTable = this.toTree(this.treeArr)
        }
      }
    },
    verifyTempName(index, row) {
      let treeIndex = 0
      for (let i = 0; i < this.treeArr.length; i++) {
        if (this.treeArr[i].id !== row.id && this.treeArr[i].tempName === row.tempName) {
          this.$message({ showClose: true, message: '模板名称重复', type: 'info' })
          row.tempName = ''
        } else if (this.treeArr[i].id === row.id) {
          treeIndex = i
        }
      }
      this.treeArr[treeIndex].tempName = row.tempName
      // this.templateTable = this.toTree(this.treeArr)
    },
    verifyTempCode(index, row) {
      let treeIndex = 0
      for (let i = 0; i < this.treeArr.length; i++) {
        if (this.treeArr[i].id !== row.id && this.treeArr[i].tempCode === row.tempCode) {
          this.$message({ showClose: true, message: '计划编码重复', type: 'info' })
          row.tempCode = ''
        } else if (this.treeArr[i].id === row.id) {
          treeIndex = i
        }
      }
      this.treeArr[treeIndex].tempCode = row.tempCode
      // this.templateTable = this.toTree(this.treeArr)
    },
    verifyLevelRule(index, row) {
      var parentLevel = ''
      let treeIndex = 0
      var parentNode = {}
      var flag = true
      var limit = ''
      var childrenlimit = ''
      var empty = true
      if (!row.parentId || row.parentId === '-1') {
        // 根节点
        if (row.level !== '1') {
          this.$message({ showClose: true, message: '根节点只能添加一级计划', type: 'info' })
          row.level = '1'
        }
      } else {
        for (let i = 0; i < this.treeArr.length; i++) {
          if (this.treeArr[i].id === row.parentId) {
            parentLevel = this.treeArr[i].level
            parentNode = this.treeArr[i]
            // break
            // parentIndex = i
          } else if (this.treeArr[i].id === row.id) {
            treeIndex = i
          }
        }
        if (parentLevel && Number(parentLevel) > Number(row.level)) {
          this.$message({ showClose: true, message: '计划级别不能小于父计划级别', type: 'info' })
          row.level = ''
        } else if (parentLevel && Number(row.level) - Number(parentLevel) > 1) {
          this.$message({ showClose: true, message: '不能跨级添加子计划', type: 'info' })
          row.level = ''
        }
        // 判断父节点下所有子节点都为同一级别
        console.log(parentNode)
        if (parentNode.children.length > 1) {
          for (var j = 0; j < parentNode.children.length; j++) {
            if (parentNode.children[j].id === row.id) {
              j++ // 跳过当前修改的节点
            }
            if (parentNode.children[j].level !== '') {
              limit = Number(parentNode.children[j].level)
              empty = false
              break
            }
          }
          if (!empty) {
            parentNode.children.forEach(el => {
              if (limit !== '' && el.level !== '' && Number(el.level) !== limit) {
                flag = false
              }
            })
            if (!flag) {
              this.$message({ showClose: true, message: '该节点下已存在其他级别的计划', type: 'info' })
              row.level = ''
            }
          }
        }
        // 还要判断不能越级 比如当前节点的父级节点为1级，当前节点设为2级，当前节点的子节点设为三级，再次修改当前节点为1级就有问题
        console.log('row', row)
        if (row.children && row.children.length >= 1) {
          console.log('/*/*/4564', row)
          // 遍历孩子，孩子可能有还未选择级别的
          for (var k = 0; k < row.children.length; k++) {
            if (row.children[k].level !== '') {
              childrenlimit = Number(row.children[k].level)
              break
            }
          }
          if (childrenlimit !== '' && Math.abs(Number(childrenlimit - Number(row.level)) > 1)) {
            this.$message({ showClose: true, message: '不能跨级添加计划', type: 'info' })
            row.level = ''
          }
        }
      }
      // this.treeArr[treeIndex].level = row.level

      // this.templateTable = this.toTree(this.treeArr)
    },
    changeWeightsVal(index, row) {
      let treeIndex = 0
      for (let i = 0; i < this.treeArr.length; i++) {
        if (this.treeArr[i].id === row.id) {
          treeIndex = i
        }
      }
      this.treeArr[treeIndex].weightValue = row.weightValue
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
    // 获取任务列表数据
    getTreeList() {
      var requestData = {
        tempWbsId: this.templateId
      }
      this.loading = true
      getScheWbsTempDet(requestData).then(res => {
        console.log('*/*/', res)
        this.loading = false
        this.treeArr = []
        if (res && res.code === '200' && res.data) {
          this.findTree(res.data, (item) => {
            if (item.weights === 'null' || item.weights === null || item.weights === '') {
              item.weights = 0
            }
            if (item.parentId === '-1') {
              item.parentId = ''
            }
            item.level = item.level + ''
            if (item.id === this.clickTaskInfo.id) {
              this.clickTaskInfo = item
            }
            this.treeArr.push(item)
          })
          this.templateTable = JSON.parse(JSON.stringify(res.data))
        }
      }
      ).finally(() => {
        this.loading = false
        this.maxHeight = this.$refs.pageDiv.clientHeight - this.$refs.formInlinediv.clientHeight - this.$refs.topDiv.clientHeight - this.$refs.bottomDiv.clientHeight - 82
      })
    },
    clickRow({ id, row }) {
      this.treeArr.forEach(element => {
        if (element.id === id) {
          this.currentRow = element
        }
      })
    },
    searchPlan: function() {
      // this.getTreeList()
      var resultlist = []
      this.treeArr.forEach(element => {
        var accordNum = 0
        if (this.planform.wbsCode) {
          if (element.tempCode.indexOf(this.planform.wbsCode) > -1) {
            accordNum++
          }
        } else {
          accordNum++
        }
        if (this.planform.wbsName) {
          if (element.tempName.indexOf(this.planform.wbsName) > -1) {
            accordNum++
          }
        } else {
          accordNum++
        }
        if (this.planform.wbsLevel) {
          if (element.level === this.planform.wbsLevel) {
            accordNum++
          }
        } else {
          accordNum++
        }
        if (accordNum === 3) {
          resultlist.push(element)
        }
      })
      this.templateTable = this.toTree(resultlist)
    },
    exportTemplate: function() {
      alert('导出')
    },
    importTemplate: function() {
      if (this.treeArr && this.treeArr.length > 0) {
        this.$confirm(`导入会覆盖之前的数据您确定导入吗?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.importListVisible = true
        })
      } else {
        this.importListVisible = true
      }
    },

    setCodeRule: function() {
      this.selProfessional = this.formInline.profeType
      this.selProjectType = this.formInline.engType
      this.codeRuleVisible = true
    },
    getBackData(sel) {
      this.codeRuleVisible = false
      if (sel) {
        this.$set(this.formInline, 'wbsCodeRule', sel.id)
        this.$set(this.formInline, 'wbsCodeRuleName', sel.tempName)
        this.$message({ showClose: true, message: '设置成功', type: 'success' })
      }
    },
    closeCodeRule() {
      this.codeRuleVisible = false
    },
    toWeight: function() {
      // var _self = this
      // if (!_self.currentRow) {
      //   return _self.$message({
      //     message: '请先选择节点',
      //     type: 'error'
      //   })
      // } else {
      //   _self.$confirm(`将按子节点权值分配权重，是否确定?`, '提示', {
      //     confirmButtonText: '确定',
      //     cancelButtonText: '取消',
      //     type: 'warning',
      //     dangerouslyUseHTMLString: true
      //   }).then(() => {
      //     var childrenNodes = _self.currentRow.children
      //     var childrenLength = childrenNodes.length
      //     var lastObjIndex = 0
      //     var hejiWeight = 0
      //     if (childrenLength > 0) {
      //       // 获取子节点所有权值
      //       var allChildrenWeightValue = 0
      //       for (let cl = 0; cl < childrenLength; cl++) {
      //         if (childrenNodes[cl].weightValue) {
      //           allChildrenWeightValue = allChildrenWeightValue + Number(childrenNodes[cl].weightValue)
      //         } else {
      //           allChildrenWeightValue = allChildrenWeightValue + 1
      //         }
      //       }
      //       // var parentWeights = _self.currentRow.weights
      //       // if (!parentWeights) {
      //       //   parentWeights = 100
      //       // }
      //       var num = Math.floor(10000 / allChildrenWeightValue) / 100
      //       for (let i = 0; i < _self.treeArr.length; i++) {
      //         // if (_self.treeArr[i].id === _self.currentRow.id) {
      //         //   _self.$set(_self.treeArr[i], 'weights', parentWeights)
      //         // }
      //         if (_self.treeArr[i].parentId === _self.currentRow.id) {
      //           if (_self.treeArr[i].weightValue) {
      //             hejiWeight = hejiWeight + num * Number(_self.treeArr[i].weightValue)
      //             _self.$set(_self.treeArr[i], 'weights', num * Number(_self.treeArr[i].weightValue))
      //           } else {
      //             hejiWeight = hejiWeight + num
      //             _self.$set(_self.treeArr[i], 'weightValue', 1)
      //             _self.$set(_self.treeArr[i], 'weights', num)
      //           }

      //           lastObjIndex = i
      //         }
      //       }
      //       var lastObjWeightValue = _self.treeArr[lastObjIndex].weightValue

      //       var lastNum = 100 - num * (allChildrenWeightValue - Number(lastObjWeightValue))
      //       _self.$set(_self.treeArr[lastObjIndex], 'weights', lastNum)

      //       _self.templateTable = _self.toTree(_self.treeArr)
      //     }
      //   })
      // }
      var vm = this
      vm.$confirm(`将按权值生成权重，是否生成?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        var rootWeightValue = 0
        vm.findTree(vm.templateTable, (item) => {
          if (!item.weightValue) {
            item.weightValue = 1
          }
          if (item.parentId === '' || item.parentId === '-1') {
            rootWeightValue += item.weightValue
          }
          if (item.children && item.children.length > 0) {
            var childrenNodes = item.children
            if (childrenNodes && childrenNodes.length > 0) {
              // 获取子节点所有权值
              var weightSum = childrenNodes.reduce(function(prev, cur, index, arr) {
                if (!cur.weightValue) {
                  cur.weightValue = 1
                }
                return prev + cur.weightValue
              }, 0)
              var proportion = Math.round(10000 / weightSum) / 100
              // var s = proportion.toString()
              // var rs = s.indexOf('.')
              // if (rs < 0) {
              //   rs = s.length
              //   s += '.'
              // }
              // while (s.length <= rs + 2) {
              //   s += '0'
              // }
              // proportion = s
              var lastWeights = 0
              for (var i = 0, len = childrenNodes.length; i < len; i++) {
                if (i === (childrenNodes.length - 1) && childrenNodes.length > 1) {
                  childrenNodes[i].weights = parseFloat(100 - lastWeights).toFixed(2)
                } else {
                  if (!childrenNodes[i].weightValue) {
                    childrenNodes[i].weightValue = 1
                  }
                  childrenNodes[i].weights = parseFloat(proportion * Number(childrenNodes[i].weightValue)).toFixed(2)
                  lastWeights = parseFloat(lastWeights) + parseFloat(childrenNodes[i].weights)
                }
              }
            }
          }
        })
        if (rootWeightValue > 0) {
          var rootProportion = Math.round(10000 / rootWeightValue) / 100
          vm.treeArr = []
          vm.findTree(vm.templateTable, (item) => {
            if (!item.weightValue) {
              item.weightValue = 1
            }
            if (item.parentId === '' || item.parentId === '-1') {
              item.weights = parseFloat(rootProportion * Number(item.weightValue)).toFixed(2)
            }
            vm.treeArr.push(item)// 更新treeArr
          })
        }
        vm.$message.success('成功生成权重')
      })
    },
    toSave: function() {
      this.$refs['formInline'].validate((valid) => {
        if (valid) {
          var savedata = this.formInline
          var arrList = []
          for (let m = 0; m < this.treeArr.length; m++) {
            if (this.templateCopy === '1') {
              const newCreateId = this.GenNonDuplicateID(20)
              for (let n = 0; n < this.treeArr.length; n++) {
                if (this.treeArr[n].parentId === this.treeArr[m].id) {
                  this.treeArr[n].parentId = newCreateId
                }
              }
              this.treeArr[m].id = newCreateId
            }
          }
          for (let i = 0; i < this.treeArr.length; i++) {
            var itemNode = this.treeArr[i]
            if (!itemNode.parentId) {
              itemNode.parentId = '-1'
            }
            if (itemNode.parentId === '-1') {
              itemNode.path = itemNode.id
            }
            if (!itemNode.tempName) {
              this.$message({ showClose: true, message: '名称不能为空', type: 'info' })
              return
            }
            if (!itemNode.tempCode) {
              this.$message({ showClose: true, message: '编码不能为空', type: 'info' })
              return
            }
            if (!itemNode.level) {
              this.$message({ showClose: true, message: '级别不能为空', type: 'info' })
              return
            }

            var tmpObj = { id: itemNode.id,
              tempCode: itemNode.tempCode,
              level: itemNode.level,
              tempName: itemNode.tempName,
              tempWbsId: itemNode.tempWbsId,
              weights: itemNode.weights,
              weightValue: itemNode.weightValue,
              sortCode: itemNode.sortCode,
              parentId: itemNode.parentId,
              path: itemNode.path
            }
            arrList.push(tmpObj)
          }
          savedata.scheWbsTempDets = arrList
          savedata.tentantId = this.tentantId
          if (arrList && arrList.length > 0) {
            this.saveLoading = true
            saveWbsTempData(savedata).then(res => {
              if (res && res.code === '200') {
                if (res.data && res.data.isrepeat) {
                  this.$message({ showClose: true, message: '模板名称重复，保存失败!', type: 'error' })
                } else {
                  this.$message({ showClose: true, message: '保存成功!', type: 'success' })
                  this.toTemplateList()
                }
              }
            }).catch(() => {
            }).finally(() => {
              this.saveLoading = false
            })
          } else {
            this.$message({ showClose: true, message: '请填写wbs模板级别信息!', type: 'info' })
          }
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    deletePlan(index, row) {
      var _self = this
      if (!_self.currentRow) {
        return _self.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        _self.$confirm(`确定要删除该模板么?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          var arr = [_self.currentRow]
          _self.findTree(arr, (item) => {
            for (let i = 0; i < _self.treeArr.length; i++) {
              if (_self.treeArr[i].id === item.id) {
                _self.treeArr.splice(i, 1)
              }
            }
          })
          this.templateTable = this.toTree(_self.treeArr)
          // 重置（如果删除的节点存在子节点，需更新children）
          this.treeArr = []
          this.findTree(this.templateTable, (item) => {
            if (item.parentId === '-1') {
              item.parentId = ''
            }
            item.level = item.level + ''
            this.treeArr.push(item)
          })
          this.currentRow = null
        })
      }
    },
    goback: function() {
      // this.$router.push({ path: '/systemSet/index', query: { tabIndex: 3 }})
      this.toTemplateList()
    }
  }
}
</script>

<style lang="scss" scoped>
.wbsTemDiv{
  width: 100%;
  height: 100%;
  position: absolute;
  padding-left: 10px;
  padding-right: 10px;
}
/deep/ .el-card__body{
  padding: 0px 0px;
}
.el-form-item{
  margin-bottom: 5px;
}
.el-table .hidden-row {
    display:none;
  }

</style>

