<template>
  <div ref="pageDiv" class="clearfix codeEditDiv">
    <el-card class="box-card">
      <div ref="wbsTemFormDiv" class="clearfix">
        <el-form ref="formInline" :model="wbsTemForm" size="mini" :inline="true" label-width="auto" :rules="rules" style="margin-left:10px;margin-top:10px">
          <el-row :gutter="24" style="padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8">
              <el-form-item label="模板名称" prop="tempName">
                <el-input v-model="wbsTemForm.tempName" size="mini" style="width: 160px;margin-left:5px" clearable />
              </el-form-item>
            </el-col>
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8">
              <el-form-item label="行业" prop="professional">
                <el-select v-model="wbsTemForm.professional" placeholder="请选择行业" size="mini" style="width: 160px;margin-left:5px" clearable @change="selectProjectTypeList">
                  <el-option
                    v-for="item in professionalList"
                    :key="item.dictCode"
                    :label="item.name"
                    :value="item.dictCode"
                  />
                </el-select>
              </el-form-item>
            </el-col>
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8" class="search-form-middle">
              <el-form-item label="创建人" prop="createUserName">
                {{ wbsTemForm.createUserName }}
              </el-form-item>
            </el-col>
          </el-row>
          <el-row :gutter="24" style="padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8">
              <el-form-item label="备注" prop="remark">
                <el-input
                  v-model="wbsTemForm.remark"
                  type="textarea"
                  :rows="1"
                  placeholder="请输入内容"
                  size="mini"
                  style="width: 160px;margin-left:5px"
                  clearable
                /></el-form-item>
            </el-col>
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8">
              <el-form-item label="项目类型" prop="projectType">
                <el-select v-model="wbsTemForm.projectType" placeholder="请选择项目类型" size="mini" style="width: 160px;margin-left:5px" clearable>
                  <el-option
                    v-for="item in projectTypeList"
                    :key="item.dictCode"
                    :label="item.name"
                    :value="item.dictCode"
                  />
                </el-select></el-form-item>

            </el-col>
            <el-col :xl="8" :lg="8" :md="8" :sm="8" :xs="8" class="search-form-middle">
              <el-form-item label="创建时间" prop="createTime">
                {{ wbsTemForm.createTime }}
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
      </div>
    </el-card>
    <el-card :body-style="{ padding: '0px' }" class="box-card">
      <div ref="topDiv" class="clearfix">
        <el-row class="clearfix">
          <el-form :inline="true" :model="planform" size="mini" label-width="auto" style="margin-left:10px;margin-top:10px">
            <el-form-item label="编码预览">
              {{ planform.codepreview }}
            </el-form-item>
            <el-button style="float:right;margin-right:15px;" type="primary" size="mini" icon="el-icon-plus" @click="addtemplate">增加前缀</el-button>
          </el-form>
        </el-row>
      </div>
      <el-row class="clearfix">
        <el-table
          ref="listData"
          v-loading="loading"
          class="ff-table-wrap"
          :data="listData"
          border
          size="mini"
          highlight-current-row
          :max-height="maxHeight"
          @row-click="handleSelectionChange"
        >
          <el-table-column label="序号" type="index" align="left" width="55" />
          <el-table-column v-if="false" prop="id" label="主键Id" />
          <el-table-column v-if="false" prop="wbsCodeId" label="wbsCodeId" />
          <el-table-column v-if="false" prop="prefixType" label="prefixType" align="center" />
          <el-table-column prop="prefixTypeName" label="前缀类型" align="center" />

          <el-table-column prop="codeValue" label="值" align="left">
            <template slot-scope="scope">
              <span v-if="scope.row.prefixType=='4'">
                {{ scope.row.sortLength }}位，

                <span v-if="scope.row.reset=='1'">
                  每月
                </span>
                <span v-else>每年</span>
              </span>
              <span v-else>{{ scope.row.codeValue }}</span>
            </template>
          </el-table-column>
          <el-table-column label="操作" align="center">
            <template slot-scope="scope">
              <el-link :underline="false" type="primary" @click="handleRowEdit(scope.$index, scope.row)">编辑</el-link>
              |
              <el-link :underline="false" type="primary" @click="handleRowRemove(scope.$index, scope.row)">删除</el-link>
            </template>
          </el-table-column>
        </el-table>
      </el-row>
      <div ref="bottomDiv" class="clearfix">
        <el-row class="clearfix">
          <el-form :inline="true" :model="childRuleForm" size="mini" label-width="auto" style="margin-top:10px">
            <el-form-item label="子节点连接符">
              <el-input v-model="childRuleForm.childLink" maxlength="20" />
            </el-form-item>
            <el-form-item label="子节点流水号位数">
              <el-input-number v-model="childRuleForm.childDigit" controls-position="right" :min="1" :max="100000000" style="width:160px" />
            </el-form-item>
          </el-form>
        </el-row>
        <el-row type="flex" class="box-card" justify="center" style="margin-top:10px;margin-bottom:10px">
          <el-button size="mini" type="primary" :loading="optLoad" @click="toSave">保 存</el-button>
          <el-button size="mini" @click="goback">取 消</el-button>
        </el-row>
      </div>
    </el-card>
    <el-dialog id="editRuleCodeDialog" :visible.sync="editPageVisble" width="40%" :show-close="true" title="编辑前缀" :close-on-click-modal="true" @close="closeEditDialog">

      <el-row>
        <el-col :span="24">
          <el-tabs
            v-model="ruleTab"
            type="border-card"
          >
            <el-tab-pane label="固定字符" name="ruleone" :disabled="typeDisabled1">
              <el-form ref="formDataOne" :model="formDataOne" class="form-wrap" size="small" label-suffix="">
                <el-form-item label="固定字符：" prop="codeValueOne" style="margin:20px;">
                  <el-input v-model="formDataOne.codeValueOne" style="width:150px" clearable @input="updateInput" />
                </el-form-item>
              </el-form>
            </el-tab-pane>
            <el-tab-pane label="日期" name="ruletwo" :disabled="typeDisabled2">
              <el-form ref="formDataTwo" :model="formDataTwo" class="form-wrap" size="small" label-suffix="">
                <el-form-item label="日期格式：" prop="codeValueTwo" style="margin:20px;">
                  <el-select v-model="formDataTwo.codeValueTwo" size="mini" placeholder="请选择日期格式" style="width:150px" clearable>
                    <el-option
                      v-for="item in dateTypeList"
                      :key="item.name"
                      :label="item.name"
                      :value="item.name"
                    />
                  </el-select>
                </el-form-item>
              </el-form>
            </el-tab-pane>
            <el-tab-pane label="类型代码" name="rulethree" :disabled="typeDisabled3">
              <el-form ref="formDataThree" :model="formDataThree" class="form-wrap" size="small" label-suffix="">
                <el-form-item label="类型代码：" prop="codeValueThree" style="margin:20px;">
                  <el-input v-model="formDataThree.codeValueThree" style="width:150px" clearable @focus="toSetName" />
                </el-form-item>
              </el-form>
            </el-tab-pane>
            <el-tab-pane label="流水号" name="rulefour" :disabled="typeDisabled4">
              <el-form ref="formData" :model="formData" class="form-wrap" size="small" label-suffix="">
                <el-form-item label="位数：" prop="sortLength" style="margin-left:77px;margin-top:20px;">
                  <el-input-number v-model="formData.sortLength" controls-position="right" :min="1" :max="6" size="small" style="width:150px" @change="updateInput" />
                </el-form-item>
                <el-form-item label="重置周期：" prop="reset" style="margin-left:48px;margin-bottom:20px;">
                  <el-select v-model="formData.reset" placeholder="重置周期" size="mini" clearable>
                    <el-option
                      v-for="item in resetTypeList"
                      :key="item.value"
                      :label="item.name"
                      :value="item.value"
                    />
                  </el-select>
                </el-form-item>
              </el-form>
            </el-tab-pane>
          </el-tabs>
        </el-col>
      </el-row>
      <el-row type="flex" class="box-card" justify="center" style="margin-top:10px;margin-bottom:10px">
        <el-button size="mini" @click="editPageVisble = false">取 消</el-button>
        <el-button type="primary" :loading="optLoad" size="mini" @click="toConfirm">确 定</el-button>
      </el-row>
      <el-row type="flex" class="box-card" justify="center" style="margin-top:10px;margin-bottom:10px">
        <SelectDict v-if="dictPageVisble" style="width:100%" @setSelectValue="getBackData" @closeDict="closeDict" />
      </el-row>
    </el-dialog>
  </div>

</template>
<script>
import SelectDict from '../common/SelectDict.vue'
import { getDictByItemId, getWbsRuleinfo, saveWbsRuleinfo } from '@/api/codeRule'
import { parseTime } from '@/utils/index.js'
import { mapGetters } from 'vuex'
export default {
  name: 'ExpensesCourseEditVm',
  components: {
    SelectDict
  },
  props: {
    wbsCodeId: {
      type: String,
      default: ''
    },
    wbsCodeCopy: {
      type: String,
      default: ''
    },
    toExpensesCourseList: {
      type: Function,
      default: null
    }
  },
  data() {
    return {
      ruleTab: 'rulecodetype1',
      optLoad: false,
      loading: false,
      saveLoading: false,
      planform: {
        codepreview: ''
      },
      childRuleForm: {
        childLink: '',
        childDigit: ''
      },
      formData: {
        prefixType: '',
        prefixTypeName: '',
        wbsCodeId: '',
        codeValue: '',
        sortLength: '',
        reset: '1',
        sortCode: ''
      },
      formDataOne: {
        codeValueOne: ''
      },
      formDataTwo: {
        codeValueTwo: ''
      },
      formDataThree: {
        codeValueThree: ''
      },
      typeDisabled1: false,
      typeDisabled2: false,
      typeDisabled3: false,
      typeDisabled4: false,
      wbsTemForm: {
        id: '',
        tempName: '',
        projectType: '',
        professional: '',
        createUser: '',
        createTime: '',
        remark: '',
        childLink: '',
        childDigit: '',
        tentantId: '',
        codeRuleList: []
      },
      resetTypeList: [{ value: '1', name: '每月' }, { value: '2', name: '每年' }],
      dateTypeList: [{ name: 'yyyy' }, { name: 'yyyy-MM' }, { name: 'yyyy-MM-dd' }, { name: 'yyyy-MM-ddHH' }, { name: 'yyyy-MM-ddHH:mm' }, { name: 'yyyy-MM-ddHH:mm:ss' }],
      maxHeight: 400,
      listData: [],
      editPageVisble: false,
      dictPageVisble: false,
      projectTypeList: [],
      professionalList: [],
      currentRow: null,
      rules: {
        tempName: [
          { required: true, message: '请输入模板名称', tigger: 'blur' }
        ],
        professional: [
          { required: true, message: '请输入行业', tigger: 'change' }
        ],
        projectType: [
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
  watch: {
    wbsCodeId(v) {
      if (!v) {
        this.wbsCodeId = v
      }
    },
    wbsCodeCopy(v) {
      if (!v) {
        this.wbsCodeCopy = v
      }
    }
  },
  created() {
    this.selectProfessionalList()
    this.getWbsRuleinfoById()
  },
  mounted() {
    this.$nextTick(() => {
      this.maxHeight = this.$refs.pageDiv.clientHeight - this.$refs.wbsTemFormDiv.clientHeight - this.$refs.topDiv.clientHeight - this.$refs.bottomDiv.clientHeight - 81
    })
  },
  methods: {
    selectProjectTypeList() {
      var this_ = this
      var selectProfessional = this.wbsTemForm.professional
      if (selectProfessional) {
        var selectContent = ''
        for (let i = 0; i < this.professionalList.length; i++) {
          if (this.professionalList[i].dictCode === selectProfessional) {
            selectContent = this.professionalList[i].content1
            break
          }
        }
        var requestData = { type: 'dict', itemId: '82ad9e44e8364057945c88927fde13e6', content1: selectContent }
        getDictByItemId(requestData).then(res => {
          this_.projectTypeList = res
        }).catch(() => {
          this.$message({
            message: '获取项目类型失败',
            type: 'error'
          })
        })
      }
    },
    selectProfessionalList() {
      var this_ = this
      var requestData = { type: 'dict', itemId: '158e8a0a508341beb9dc31423ece82e8' }
      getDictByItemId(requestData).then(res => {
        this_.professionalList = res
      }).catch(() => {
        this.$message({
          message: '获取行业失败',
          type: 'error'
        })
      })
    },
    getWbsRuleinfoById() {
      if (this.wbsCodeId) { // this.$route.params.id
        getWbsRuleinfo(this.wbsCodeId).then(res => {
          if (res) {
            this.wbsTemForm = res
            if (this.wbsCodeCopy === '1') {
              this.$set(this.wbsTemForm, 'id', '')
              this.$set(this.wbsTemForm, 'defaultValue', '0')
              if (res.codeRuleList) {
                res.codeRuleList.forEach(rule => {
                  rule.id = ''
                })
              }
            }
            if (res.professional) {
              this.selectProjectTypeList()
            }
            this.childRuleForm.childLink = this.wbsTemForm.childLink
            this.childRuleForm.childDigit = this.wbsTemForm.childDigit
            this.listData = res.codeRuleList
            this.generatePreviewCode()
          } else {
            this.$message({
              message: '获取编码规则信息失败',
              type: 'warning'
            })
          }
        })
      } else {
        this.wbsTemForm.createUserName = this.$store.state.user.name
        this.wbsTemForm.createUser = this.$store.state.user.userId
        this.wbsTemForm.createTime = parseTime(new Date().getTime())
      }
    },
    addtemplate() {
      this.formDataOne.codeValueOne = ''
      this.formDataTwo.codeValueTwo = ''
      this.formDataThree.codeValueThree = ''
      this.formData.sortLength = ''
      this.formData.reset = ''
      this.typeDisabled1 = false
      this.typeDisabled2 = false
      this.typeDisabled3 = false
      this.typeDisabled4 = false
      this.editPageVisble = true
      this.ruleTab = 'ruleone'
    },
    toSave() {
      this.$refs['formInline'].validate((valid) => {
        if (valid) {
          this.wbsTemForm.codeType = '2'
          this.wbsTemForm.tentantId = this.tentantId
          this.wbsTemForm.childLink = this.childRuleForm.childLink
          this.wbsTemForm.childDigit = this.childRuleForm.childDigit
          if (this.listData && this.listData.length > 0) {
            this.wbsTemForm.codeRuleList = this.listData
            this.saveLoading = true
            saveWbsRuleinfo(this.wbsTemForm).then(res => {
              if (res.code === '501') {
                this.$message({ showClose: true, message: '编码规则模板名称重复，保存失败!', type: 'error' })
              } else {
                this.$message({ showClose: true, message: '保存成功!', type: 'success' })
                this.toExpensesCourseList()
              }
            }).catch(() => {
            }).finally(() => {
              this.saveLoading = false
            })
          } else {
            this.$message({ showClose: true, message: '请填写编码前缀类型列表!', type: 'info' })
          }
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    toConfirm() {
      var _self = this
      if (_self.typeDisabled1 || _self.typeDisabled2 || _self.typeDisabled3 || _self.typeDisabled4) {
        var changeCodeValue = ''
        switch (_self.formData.prefixType) {
          case '1':
            changeCodeValue = _self.formDataOne.codeValueOne
            break
          case '2':
            changeCodeValue = _self.formDataTwo.codeValueTwo
            break
          case '3':
            changeCodeValue = _self.formDataThree.codeValueThree
        }
        if (_self.currentRow) {
          _self.currentRow.codeValue = changeCodeValue
          _self.currentRow.sortLength = _self.formData.sortLength
          _self.currentRow.reset = _self.formData.reset
        }
      } else {
        if (_self.formDataOne.codeValueOne) {
          _self.listData.push({ prefixType: '1', prefixTypeName: '固定字符', codeValue: _self.formDataOne.codeValueOne, sortCode: '1', wbsCodeId: _self.wbsCodeId })
        }
        if (_self.formDataTwo.codeValueTwo) {
          _self.listData.push({ prefixType: '2', prefixTypeName: '时间', codeValue: _self.formDataTwo.codeValueTwo, sortCode: '2', wbsCodeId: _self.wbsCodeId })
        }
        if (_self.formDataThree.codeValueThree) {
          _self.listData.push({ prefixType: '3', prefixTypeName: '类型代码', codeValue: _self.formDataThree.codeValueThree, sortCode: '3', wbsCodeId: _self.wbsCodeId })
        }
        if (_self.formData.sortLength) {
          _self.listData.push({ prefixType: '4', prefixTypeName: '流水号', sortLength: _self.formData.sortLength, reset: _self.formData.reset, sortCode: '4', wbsCodeId: _self.wbsCodeId })
        }
      }
      this.generatePreviewCode()
      _self.editPageVisble = false
    },
    generatePreviewCode() {
      var _self = this
      var previewCode = ''
      for (let i = 0; i < _self.listData.length; i++) {
        if (_self.listData[i].prefixType === '4') {
          previewCode = previewCode + (Array(_self.listData[i].sortLength).join('0') + 1).slice(-_self.listData[i].sortLength)
        } else if (_self.listData[i].prefixType === '2') {
          const date = new Date()
          const Y = date.getFullYear()
          const M = (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1)
          const D = date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()
          const h = date.getHours() < 10 ? '0' + (date.getHours()) : date.getHours()
          const m = date.getMinutes() < 10 ? '0' + (date.getMinutes()) : date.getMinutes()
          const s = date.getSeconds() < 10 ? '0' + (date.getSeconds()) : date.getSeconds()
          if (_self.listData[i].codeValue.length === 4) {
            previewCode = previewCode + Y
          } else if (_self.listData[i].codeValue.length === 7) {
            previewCode = previewCode + Y + '-' + M
          } else if (_self.listData[i].codeValue.length === 10) {
            previewCode = previewCode + Y + '-' + M + '-' + D
          } else if (_self.listData[i].codeValue.length === 12) {
            previewCode = previewCode + Y + '-' + M + '-' + D + ' ' + h
          } else if (_self.listData[i].codeValue.length === 15) {
            previewCode = previewCode + Y + '-' + M + '-' + D + ' ' + h + ':' + m
          } else if (_self.listData[i].codeValue.length === 18) {
            previewCode = previewCode + Y + '-' + M + '-' + D + ' ' + h + ':' + m + ':' + s
          }
        } else {
          previewCode = previewCode + _self.listData[i].codeValue
        }
      }
      this.planform.codepreview = previewCode
    },
    handleRowEdit: function(index, row) {
      this.formData = row
      this.currentRow = row
      this.editPageVisble = true
      switch (row.prefixType) {
        case '1':
          // this.formData.codeValueOne = row.codeValue
          this.$set(this.formDataOne, 'codeValueOne', row.codeValue)
          this.typeDisabled1 = false
          this.typeDisabled2 = true
          this.typeDisabled3 = true
          this.typeDisabled4 = true
          this.ruleTab = 'ruleone'
          break
        case '2':
          this.$set(this.formDataTwo, 'codeValueTwo', row.codeValue)
          this.typeDisabled1 = true
          this.typeDisabled2 = false
          this.typeDisabled3 = true
          this.typeDisabled4 = true
          this.ruleTab = 'ruletwo'
          break
        case '3':
          this.$set(this.formDataThree, 'codeValueThree', row.codeValue)
          this.typeDisabled1 = true
          this.typeDisabled2 = true
          this.typeDisabled3 = false
          this.typeDisabled4 = true
          this.ruleTab = 'rulethree'
          break
        case '4':
          this.typeDisabled1 = true
          this.typeDisabled2 = true
          this.typeDisabled3 = true
          this.typeDisabled4 = false
          this.ruleTab = 'rulefour'
      }
    },
    toSetName() {
      if (this.ruleTab === 'rulethree') {
        this.dictPageVisble = true
      }
    },
    getBackData(sel) {
      this.dictPageVisble = false
      if (sel[0]) {
        this.$set(this.formDataThree, 'codeValueThree', sel[0].itemName)
      }
    },
    handleRowRemove(index, row) {
      this.$confirm(`确定要删除该类型么?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.listData.splice(index, 1)
        this.generatePreviewCode()
        // deleteRuleinfo(row.id).then(res => {
        //   this.getWbsRuleinfoById()
        // }
        // ).catch(() => {
        //   this.$message({
        //     message: '删除失败',
        //     type: 'error'
        //   })
        // })
      })
    },
    handleSelectionChange(val) {
      this.currentRow = val
    },
    goback: function() {
      this.toExpensesCourseList()
    },
    closeEditDialog() {
      this.dictPageVisble = false
    },

    closeDict() {
      this.dictPageVisble = false
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
    updateInput(val) {
      this.$emit('input', val)
    },
    handleClick(tab, event) {
      if (this.ruleTab !== 'rulethree') {
        this.dictPageVisble = false
      }
    }

  }
}
</script>
<style lang="scss" scoped>
.codeEditDiv{
  width: 100%;
  height: 100%;
  position: absolute;
  padding-right: 20px;
}
/deep/ .el-card__body{
  padding: 0px 0px;
}
/deep/ #editRuleCodeDialog .el-dialog .el-dialog__body{
  padding: 10px 10px
}

.el-form-item{
  margin-bottom: 5px;
}
.el-table .hidden-row {
    display:none;
  }

</style>
