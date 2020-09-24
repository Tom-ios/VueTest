<template>
  <div>
    <el-form ref="nameForm" :model="formData" :rules="rules" style="margin-left:100px;margin-top:20px">
      <el-row>
        <el-col :span="12">
          <el-form-item label="申请部门：" prop="applyDep">
            <el-input v-model="formData.applyDep" maxlength="50" style="width:180px" clearable />
          </el-form-item>
          <el-form-item label="开始时间：" prop="beginDate">
            <el-date-picker
              v-model="formData.beginDate"
              style="width:180px"
              value-format="yyyy-MM-dd"
              type="date"
              :picker-options="getPickerOption('beginDate')"
            />
          </el-form-item>
          <el-form-item label="合同价款：" prop="contractPrice">
            <el-input v-model="formData.contractPrice" maxlength="20" style="width:180px;" clearable @blur="inputMoney('contractPrice',formData.contractPrice)" />
            <span class="ml-20">元</span>
          </el-form-item>
          <el-form-item label="扣除质保金：" prop="deductionPremium" style="margin-left:-13px">
            <el-input v-model="formData.deductionPremium" maxlength="20" style="width:180px;" clearable />
            <span class="ml-20">%</span>
          </el-form-item>
          <el-form-item label="累计完成：" prop="cumulativeComplete">
            <el-input v-model="formData.cumulativeComplete" maxlength="20" style="width:180px;" clearable @blur="inputMoney('cumulativeComplete',formData.cumulativeComplete)" />
            <span class="ml-20">元</span>
          </el-form-item>
          <el-form-item label="实际进度款：" prop="actualProgressPrice" style="margin-left:-13px">
            <el-input v-model="formData.actualProgressPrice" maxlength="20" style="width:180px;" clearable @blur="inputMoney('actualProgressPrice',formData.actualProgressPrice)" />
            <span class="ml-20">元</span>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="审批部门：" prop="approvalDep">
            <el-input v-model="formData.approvalDep" maxlength="50" style="width:180px" clearable />
          </el-form-item>
          <el-form-item label="结束时间：" prop="endDate">
            <el-date-picker
              v-model="formData.endDate"
              value-format="yyyy-MM-dd"
              style="width:180px"
              type="date"
              :picker-options="getPickerOption('endDate')"
            />
          </el-form-item>
          <el-form-item label="扣除预付款：" prop="deductionAdvanceCharge" style="margin-left:-13px">
            <el-input v-model="formData.deductionAdvanceCharge" maxlength="20" style="width:180px;" clearable />
            <span class="ml-20">%</span>
          </el-form-item>
          <el-form-item label="本期完成：" prop="currentComplete">
            <el-input v-model="formData.currentComplete" maxlength="20" style="width:180px;" clearable @blur="inputMoney('currentComplete',formData.currentComplete)" />
            <span class="ml-20">元</span>
          </el-form-item>
          <el-form-item label="累计完成占比：" prop="cumulativeCompletePercent" style="margin-left:-26px">
            <el-input v-model="formData.cumulativeCompletePercent" maxlength="20" style="width:180px;" clearable />
            <span class="ml-20">%</span>
          </el-form-item>
        </el-col>
      </el-row>
      <el-row>
        <el-col :span="12">
          <el-form-item label="附件：" prop="groupNum" style="margin-left:28px;width:380px">
            <FileUpload ref="fileUpload" :group-id="formData.groupId" :business-id="formData.id" type="file" :auto-upload="false" @handleAvatarSuccess="fileSuccess" @handleError="fileError" @handleRemoveFile="handleRemoveFile" />
          </el-form-item>
        </el-col>
      </el-row>
      <el-form-item style="margin-left: calc(50% - 160px)">
        <el-button type="primary" :loading="saveLoad" @click="saveForm">保存</el-button>
        <el-button @click="cancel">取消</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>
<script>
import { createForm, addNode, updateNode, getDetail } from '@/api/projectProgressPayment'
import { getInputValue, delcommafy } from '@/utils/index'
import FileUpload from '@/components/FileUpload/index'
export default {
  components: { FileUpload },
  data() {
    return {
      basefileUrl: process.env.VUE_APP_BASE_API + 'bimserver/commonFile/download/',
      pdfBaseUrl: process.env.VUE_APP_BASE_API + 'bimserver/commonFile/IoReadFile/',
      fileUrl: '',
      formData: {
        id: '',
        applyDep: '施工项目部',
        approvalDep: '监理项目部',
        beginDate: '',
        endDate: '',
        contractPrice: '',
        deductionAdvanceCharge: '',
        deductionPremium: '',
        currentComplete: '',
        cumulativeComplete: '',
        cumulativeCompletePercent: '',
        actualProgressPrice: '',
        groupId: '',
        groupNum: 0

      },
      rules: {
        applyDep: [
          { required: true, message: '请输入申请部门', trigger: ' ' }
        ],
        approvalDep: [
          { required: true, message: '请输入审批部门', trigger: ' ' }
        ],
        beginDate: [
          { required: true, message: '请输入开始时间', trigger: ' ' }
        ],
        endDate: [
          { required: true, message: '请输入结束时间', trigger: ' ' }
        ],
        contractPrice: [
          { required: true, message: '合同价款', trigger: ' ' },
          {
            validator(rule, value, callback) {
              var newValue = delcommafy(value)
              const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
              if (Number.isInteger(Number(newValue)) && Number(newValue) > 0 && Number(newValue) < 1000000000 && MoneyTest.test(newValue)) {
                callback()
              } else {
                callback(new Error('整数最大9位，保留两位小数的金额'))
              }
            },
            trigger: 'blur'
          }
        ],
        deductionAdvanceCharge: [
          { required: true, message: '扣除预付款', trigger: ' ' },
          {
            validator(rule, value, callback) {
              const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/

              if (MoneyTest.test(value)) {
                callback()
              } else {
                callback(new Error('请输入数字类型，保留两位小数'))
              }
            },
            trigger: 'blur'
          }

        ],
        deductionPremium: [
          { required: true, message: '扣除质保金', trigger: ' ' },
          {
            validator(rule, value, callback) {
              const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/

              if (MoneyTest.test(value)) {
                callback()
              } else {
                callback(new Error('请输入数字类型，保留两位小数'))
              }
            },
            trigger: 'blur'
          }
        ],
        currentComplete: [
          { required: true, message: '本期完成', trigger: ' ' },
          {
            validator(rule, value, callback) {
              var newValue = delcommafy(value)
              const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
              if (Number.isInteger(Number(newValue)) && Number(newValue) > 0 && Number(newValue) < 1000000000 && MoneyTest.test(newValue)) {
                callback()
              } else {
                callback(new Error('整数最大9位，保留两位小数的金额'))
              }
            },
            trigger: 'blur'
          }
        ],
        cumulativeComplete: [
          { required: true, message: '累计完成', trigger: ' ' },
          {
            validator(rule, value, callback) {
              var newValue = delcommafy(value)
              const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
              if (Number.isInteger(Number(newValue)) && Number(newValue) > 0 && Number(newValue) < 1000000000 && MoneyTest.test(newValue)) {
                callback()
              } else {
                callback(new Error('整数最大9位，保留两位小数的金额'))
              }
            },
            trigger: 'blur'
          }

        ],
        cumulativeCompletePercent: [
          { required: true, message: '累计完成占比', trigger: ' ' },
          {
            validator(rule, value, callback) {
              const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
              if (MoneyTest.test(value)) {
                callback()
              } else {
                callback(new Error('请输入数字类型，保留两位小数'))
              }
            },
            trigger: 'blur'
          }
        ],
        actualProgressPrice: [
          { required: true, message: '实际进度款', trigger: ' ' },
          {
            validator(rule, value, callback) {
              var newValue = delcommafy(value)
              const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
              if (Number.isInteger(Number(newValue)) && Number(newValue) > 0 && Number(newValue) < 1000000000 && MoneyTest.test(newValue)) {
                callback()
              } else {
                callback(new Error('整数最大9位，保留两位小数的金额'))
              }
            },
            trigger: 'blur'
          }
        ],
        groupNum: [
          { required: true, message: '请添加附件', trigger: ' ' }]
      },
      mode: '',
      saveLoad: false

    }
  },
  mounted() {
    if (this.$route.query.mode === 'add') {
      this.createForm()
    } else {
      getDetail(this.$route.query.id).then(res => {
        this.formData = res
        for (const key in this.formData) {
          if (this.formData.hasOwnProperty(key)) {
            if (key === 'actualProgressPrice' || key === 'cumulativeComplete' || key === 'contractPrice' || key === 'currentComplete') {
              this.inputMoney(key, this.formData[key])
            }
          }
        }
      })
    }
  },
  methods: {
    getPickerOption(flag) {
      const self = this
      return {
        disabledDate(time) {
          if (flag === 'beginDate') {
            if (self.formData.endDate) {
              return new Date(self.formData.endDate).getTime() <= time.getTime()
            }
          } else if (flag === 'endDate') {
            if (self.formData.beginDate) {
              return (new Date(self.formData.beginDate).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
            }
          }
        }
      }
    },
    fileSuccess({ file }) {
      console.log('---successFile', file)
    },
    handleRemoveFile({ file }) {
      console.log('---removeFile', file)
    },
    fileError() {},
    inputMoney(name, value) {
      this.formData[name] = getInputValue(value)
    },
    createForm() {
      createForm().then(res => {
        this.formData.id = res
      })
    },
    cancel() {
      this.$router.back()
    },
    saveForm() {
      this.saveLoad = true
      this.formData.groupNum = this.$refs.fileUpload.filelistData.length || ''
      this.$refs['nameForm'].validate((valid) => {
        if (valid) {
          var requestData = { ...{}, ...this.formData }
          for (var key in requestData) {
            if (!requestData[key]) {
              delete requestData[key]
            }
            if (key === 'actualProgressPrice' || key === 'cumulativeComplete' || key === 'contractPrice' || key === 'currentComplete') {
              requestData[key] = delcommafy(requestData[key])
            }
          }
          requestData.num = this.$refs.fileUpload.filelistData.length || 0
          if (!requestData.num) {
            this.$alert('请上传附件')
            this.saveLoad = false
            return
          }
          requestData.projectId = this.$route.params.id
          if (this.$route.query.mode === 'add') {
            addNode(requestData).then(res => {
              this.$router.back()
            }).finally(() => {
              this.saveLoad = false
            })
          } else {
            updateNode(requestData).then(res => {
              this.$router.back()
            }).finally(() => {
              this.saveLoad = false
            })
          }
        } else {
          this.saveLoad = false
          return false
        }
      })
    }
  }
}
</script>
<style lang="scss" scoped >
/deep/ .ml-20 {
  margin-left:10px;
}
/deep/.el-upload-dragger {
    background-color: #fff;
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    width: 300px;
    height: 80px;
    text-align: center;
    position: relative;
    overflow: hidden;
}
/deep/.el-upload-dragger .el-icon-upload {
    font-size: 40px;
    color: #c0c4cc;
    margin: 0 0 0 0;
    line-height: 40px;
}
</style>
