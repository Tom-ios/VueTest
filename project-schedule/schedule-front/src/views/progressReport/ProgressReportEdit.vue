<template>
  <div id="progressRportEdit" class="pageDiv">
    <el-card :body-style="{ padding: '15px' }">
      <div slot="header">
        <span>进度信息</span>
      </div>
      <el-form ref="form" label-width="110px" :model="formData" style="margin-top:20px" :rules="formData.realStartDate && !formData.realEndDate?rules:rules1">
        <el-row>
          <el-col :span="8">
            <el-form-item label="实际开始时间：">
              <el-date-picker v-model="formData.realStartDate" :picker-options="getPickerOption('realStartDate')" value-format="yyyy-MM-dd" type="date" class="form_item_right" />
            </el-form-item>
            <el-form-item label="实际结束时间：">
              <el-date-picker v-model="formData.realEndDate" :picker-options="getPickerOption('realEndDate')" value-format="yyyy-MM-dd" type="date" class="form_item_right" />
            </el-form-item>
            <el-form-item label="实际工期：">
              <span>{{ formData.realDuration?formData.realDuration:"-" }}</span>天
            </el-form-item>
            <el-form-item label="延期原因：">
              <el-input v-model="formData.delayReason" maxlength="200" class="form_item_right" />
            </el-form-item>
            <el-form-item label="附件：" class="form_item_right">
              <FileUpload ref="fileUpload" v-model="formData.groupId" :business-id="formData.id" type="file" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="作业状态：">
              <span>{{ formData.taskState }} </span>
            </el-form-item>
            <el-form-item label="进度状态：">
              <span>{{ formData.scheState }}</span>
            </el-form-item>
            <el-form-item v-if="formData.scheCalcType ==='03'" label="累计完成比例：" prop="currSumFinishPercent">
              <el-input v-model="formData.currSumFinishPercent" maxlength="11" class="form_item_right" type="number" :disabled="formData.scheCalcType !=='03'" /> %
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="暂停日期：">
              <el-date-picker v-model="formData.stopDate" value-format="yyyy-MM-dd" type="date" class="form_item_right" />
            </el-form-item>
            <el-form-item label="复工日期：">
              <el-date-picker v-model="formData.returnDate" value-format="yyyy-MM-dd" type="date" class="form_item_right" />
            </el-form-item>
            <el-form-item v-if="!formData.realEndDate && formData.realStartDate" label="剩余工期：" prop="remainDuration">
              <el-input v-model="formData.remainDuration" maxlength="10" class="form_item_right" :disabled="formData.realEndDate?true:false" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
    <!-- <div class="div__header">
      <span>资源信息</span>
      <el-button type="primary" style="float:right;margin-right:10px;margin-top:3px" @click="addResource">增加</el-button>
    </div> -->
    <el-card :body-style="{ padding: '15px' }" style="margin-top:20px">
      <div slot="header">
        <span>资源信息</span>
        <el-button type="primary" style="float:right;margin-right:10px;margin-top:-8px" @click="addResource">增加</el-button>
      </div>
      <div>
        <el-table
          ref="treeTable"
          :data="resourceData"
          border
          stripe
          highlight-current-row
          :header-cell-class-name="'tableHeader'"
          :cell-class-name="addClass"
          style="margin-top:10px"
          :max-height="maxHeight"
          row-key="id"
          empty-text="暂无数据"
          default-expand-all
          :indent="20"
          :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
          @row-click="rowClick"
        >
          <el-table-column
            type="index"
            label="序号"
            fixed
            width="60"
          />
          <el-table-column
            v-for="(col,index) in tablecolumn"
            :key="index"
            :prop="col.value"
            :label="col.title"
            :min-width="col.width?col.width:'100'"
          >
            <template slot-scope="scope">
              <span v-if="tablecolumn[index].type==='opt'">
                <el-button type="text" @click="edit(scope.row)">编辑</el-button>
                <el-button type="text" @click="delRes(scope.row)">删除</el-button>
              </span>
              <span v-else> {{ scope.row[tablecolumn[index].key] }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
    </el-card>
    <div style="width:200px;margin-left:calc(50% - 100px);margin-top:10px;height:40px">
      <el-button type="primary" @click="saveReport">保存</el-button>
      <el-button @click="cancel">取消</el-button>
    </div>
    <el-dialog
      title="增加资源"
      :visible.sync="showResource"
      width="900px"
      @close="cancelResource"
    >
      <div style="height:460px;position:relative">
        <resource ref="resourceSel" key-word="resId" :cur-sel-rows="curSelRows" select-type="multiple" @resourceTypeChange="resourceTypeChange" />
      </div>
      <span slot="footer">
        <el-button @click="cancelResource">取 消</el-button>
        <el-button type="primary" @click="checkResouce">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog
      :visible.sync="showCurResource"
      width="900px"
      :title="curTitle"
      @close="showCurResource = false"
    >
      <el-button type="primary" style="float:right;margin-right:10px;margin-top:3px;margin-bottom:10px" @click="addCarlendar">增加</el-button>
      <div>
        <el-table
          ref="treeTable"
          :data="curCarlendarData"
          border
          stripe
          highlight-current-row
          :header-cell-class-name="'tableHeader'"
          :cell-class-name="addClass"
          style="margin-top:10px"
          :max-height="maxHeight"
          row-key="id"
          empty-text="暂无数据"
          default-expand-all
          :indent="20"
          :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        >
          <el-table-column
            type="index"
            label="序号"
            width="60"
          />
          <el-table-column
            v-for="(col,index) in curResourceColumn"
            :key="index"
            :prop="col.key"
            :label="col.title"
            :min-width="col.width?col.width:'100'"
          >
            <template slot-scope="scope">
              <span v-if="curResourceColumn[index].type==='date'">
                <el-date-picker v-model="scope.row[curResourceColumn[index].key]" value-format="yyyy-MM-dd" type="date" style="width:150px" />
              </span>
              <span v-else-if="curResourceColumn[index].type==='input'">
                <el-input v-model="scope.row[curResourceColumn[index].key]" />
              </span>
              <span v-else-if="curResourceColumn[index].type==='numInput'">
                <el-input v-model="scope.row[curResourceColumn[index].key]" type="number" :min="0" step="1" onkeyup="value=value.replace(/^(0+)|[^\d]+/g,'')" maxlength="10" />
              </span>
              <span v-else> {{ scope.row[curResourceColumn[index].key] }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <span slot="footer">
        <el-button @click="showCurResource = false">取消</el-button>
        <el-button type="primary" :loading="resouceLoading" @click="saveFunc()">保存</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import FileUpload from '@/components/FileUpload/index'
import resource from '@/views/systemSet/resource/Resource'
import { queryReportById, updateScheReport, calcDuration } from '@/api/progressReport'
export default {
  components: {
    resource,
    FileUpload
  },
  data() {
    return {
      saveFunc: null,
      resouceLoading: false,
      showCurResource: false,
      curTabName: 'human',
      curSelRows: [],
      maxHeight: 400,
      showResource: false,
      curResource: {
        resourceName: '-'
      },
      formData: {
        currSumFinishPercent: '',
        realStartDate: '',
        realEndDate: '',
        realDuration: '',
        taskState: '-',
        scheState: '-',
        remainDuration: '',
        delayReason: ''
      },

      tablecolumn: [
        {
          title: '资源代码',
          key: 'resCode',
          width: 80
        },
        {
          title: '资源名称',
          key: 'resName',
          width: 80
        },
        {
          title: '资源日历',
          key: 'resourceCaleName',
          width: 100
        },
        {
          title: '资源类型',
          key: 'resTypeName',
          width: 100
        },
        {
          title: '规格型号',
          key: 'resModel',
          width: 80
        },
        {
          title: '单价(元)',
          key: 'unitPrice',
          width: 80
        },
        {
          title: '开始时间',
          key: 'startDate',
          width: 100
        },
        {
          title: '结束时间',
          key: 'endDate',
          width: 80
        },

        {
          title: '单位',
          key: 'unitEstimateName',
          width: 80
        },
        {
          title: '累计使用数量',
          key: 'amount',
          width: 100
        },
        {
          title: '操作',
          type: 'opt',
          width: 80
        }
      ],
      curResourceColumn: [
        {
          title: '日期',
          key: 'investmentDate',
          width: 150,
          type: 'date'
        },
        {
          title: '单位',
          key: 'unitName',
          width: 80
        },
        {
          title: '计划数量',
          key: 'planAmount',
          width: 80
        },
        {
          title: '实际投入数量',
          key: 'realAmount',
          width: 100,
          type: 'numInput'
        },
        {
          title: '备注',
          key: 'note',
          width: 150,
          type: 'input'
        }
      ],
      rules: {
        remainDuration: [
          { required: true, message: '请输入剩余工期' },
          {
            trigger: 'blur',
            validator: (rule, value, callback) => {
              const MoneyTest = /((^[1-9]\d*)|^0)$/
              if (MoneyTest.test(value)) {
                callback()
              } else {
                callback(new Error('请输入整数数字类型'))
              }
              if (value <= 0) {
                callback('剩余工期必须大于0')
              } else {
                callback()
              }
            }
          }
        ]
      },
      rules1: {
        currSumFinishPercent: [
          {
            trigger: 'blur',
            validator: (rule, value, callback) => {
              if (value < 0 || value > 100) {
                callback('请填写最大值为100的非负数')
              }
              callback()
            }
          }
        ]
      },
      curCarlendarData: [],
      resourceData: [],
      calendarArr: [],
      taskArr: [{
        'title': '未开始', key: '0' }, {
        'title': '进行中', key: '1' }, {
        'title': '已完成', key: '2' }],
      stateArr: [{
        'title': '提前', key: '0' }, {
        'title': '正常', key: '1' }, {
        'title': '延迟', key: '2' }]

    }
  },
  computed: {
    curTitle() {
      return '资源投入日历 ( 当前资源:' + this.curResource.resName + ')'
    }
  },
  watch: {
    showResource(v) {
      if (v) {
        this.$nextTick(() => {
          this.curSelRows = [...this.resourceData]
        })
      }
    },

    'formData.realStartDate': {
      handler: function(newV) {
        if (this.formData.realStartDate && this.formData.realEndDate) {
          this.formData.realDuration = this.calcDuration()
        } else {
          this.$set(this.formData, 'realDuration', '')
        }
        this.caclState()
        this.resetDuration()
      }
    },
    'formData.realEndDate': {
      handler: function(newV) {
        if (this.formData.realStartDate && this.formData.realEndDate) {
          this.formData.realDuration = this.calcDuration()
        } else {
          this.$set(this.formData, 'realDuration', '')
        }
        if (newV) {
          this.$set(this.formData, 'realDuration', '')
          try {
            this.$refs['form'].resetFields()
          } catch (error) {
            console.log(error)
          }
        }
        this.caclState()
        this.resetDuration()
      }
    }
  },
  mounted() {
    this.getDetail()
    this.saveFunc = this.debounce(this.saveCurResource, 200)
  },
  methods: {
    resetDuration() {
      if (!(!this.formData.realEndDate && this.formData.realStartDate)) {
        this.$set(this.formData, 'remainDuration', '')
      }
    },
    caclState() {
      if (!this.formData.planStartDate || !this.formData.planEndDate) {
        this.formData.scheState = '-'
      } else if (this.formData.planStartDate && this.formData.planEndDate) {
        if (this.formData.realStartDate && this.formData.realEndDate) {
          if ((this.formData.realStartDate <= this.formData.planStartDate) && (this.formData.realEndDate < this.formData.planEndDate)) {
            this.formData.scheState = '提前'
          } else if ((this.formData.realStartDate < this.formData.planStartDate) && (this.formData.realEndDate === this.formData.planEndDate)) {
            this.formData.scheState = '提前'
          } else if ((this.formData.realStartDate >= this.formData.planStartDate) && (this.formData.realEndDate <= this.formData.planEndDate)) {
            this.formData.scheState = '正常'
          } else if ((this.formData.realEndDate > this.formData.planEndDate) || (this.formData.realStartDate > this.formData.planStartDate)) {
            this.formData.scheState = '延迟'
          } else {
            this.formData.scheState = '-'
          }
        } else if (!this.formData.realStartDate && !this.formData.realEndDate) {
          if (this.getNowDay() > this.formData.planStartDate) {
            this.formData.scheState = '延迟'
          } else {
            this.formData.scheState = '正常'
          }
        } else if (!this.formData.realStartDate && this.formData.realEndDate) {
          if (this.getNowDay() > this.formData.planStartDate) {
            this.formData.scheState = '延迟'
          } else if (this.formData.realEndDate > this.formData.planEndDate) {
            this.formData.scheState = '延迟'
          } else {
            this.formData.scheState = '正常'
          }
        } else if (!this.formData.realEndDate && this.formData.realStartDate) {
          if (this.getNowDay() > this.formData.planEndDate) {
            this.formData.scheState = '延迟'
          } else if (this.formData.realStartDate > this.formData.planEndDate) {
            this.formData.scheState = '延迟'
          } else if (this.formData.realStartDate < this.formData.planStartDate) {
            this.formData.scheState = '提前'
          } else if (this.formData.realStartDate >= this.formData.planStartDate) {
            this.formData.scheState = '正常'
          } else {
            this.formData.scheState = '-'
          }
        }
      }
      if (!this.formData.realStartDate && !this.formData.realEndDate) {
        this.formData.scheState = '-'
      }
      if (!this.formData.realStartDate) {
        this.formData.taskState = '未开始'
      }
      if (this.formData.realStartDate) {
        this.formData.taskState = '进行中'
      }
      if (this.formData.realEndDate) {
        this.formData.taskState = '已完成'
      }
    },
    getPickerOption(flag) {
      const self = this
      return {
        disabledDate(time) {
          if (flag === 'realStartDate') {
            if (self.formData.realEndDate) {
              return ((new Date(self.formData.realEndDate).getTime() < time.getTime()) || (time.getTime() >= new Date().getTime()))
            } else {
              return time.getTime() >= new Date().getTime()
            }
          } else if (flag === 'realEndDate') {
            if (self.formData.realStartDate) {
              return (new Date(self.formData.realStartDate).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
            }
          }
          // return time
        }
      }
    },
    calcDuration() {
      var requestData = {
        projectId: this.$route.params.id,
        startTime: this.formData.realStartDate,
        endTime: this.formData.realEndDate
      }
      calcDuration(requestData).then(res => {
        this.formData.realDuration = res.data
      })
    },
    saveCurResource() {
      this.resouceLoading = true
      var saveData = this.curCarlendarData
      var dict = {}
      var repeat = false
      for (var i = 0; i < saveData.length; i++) {
        if (dict[saveData[i].investmentDate]) {
          repeat = true
        } else {
          dict[saveData[i].investmentDate] = true
        }
      }
      if (repeat) {
        this.$alert('数据有重复日期，请修改')
        return
      }

      this.curResource.startDate = this.getMinDate(saveData)
      this.curResource.endDate = this.getMaxDate(saveData)
      var totalAmount = 0
      saveData.forEach(element => {
        if (element.realAmount) {
          totalAmount += parseFloat(element.realAmount)
        }
      })

      this.resourceData.forEach(element => {
        if (element.id === this.curResource.id) {
          this.$set(element, 'startDate', this.curResource.startDate)
          this.$set(element, 'endDate', this.curResource.endDate)
          this.$set(element, 'amount', totalAmount)
          this.$set(element, 'investmentList', saveData)
        }
      })
      this.showCurResource = false
      this.resouceLoading = false
    },
    getNowDay() {
      var date = new Date()
      date.setTime(date.getTime())
      var year = date.getFullYear()
      var month = (date.getMonth() + 1)
      if (month < 10) {
        month = '0' + month
      }
      var day = date.getDate()
      if (day < 10) {
        day = '0' + day
      }
      return year + '-' + month + '-' + day
    },
    getMaxDate(arr) {
      var max = ''
      arr.forEach(element => {
        if (element.investmentDate > max) {
          max = element.investmentDate
        }
      })
      return max
    },
    getMinDate(arr) {
      var min = ''
      if (arr.length > 0) {
        min = arr[0].investmentDate
        arr.forEach(element => {
          if (element.investmentDate < min) {
            min = element.investmentDate
          }
        })
      }
      return min
    },
    // 图片上传失败
    handleError() {
    },
    // 附件上传成功
    fileSuccess({ res }) {
      var oldFileInfo = []
      if (this.formData.fileInfo) {
        oldFileInfo = JSON.parse(this.formData.fileInfo)
      }
      var newFileInfo = [...oldFileInfo, ...res]
      newFileInfo.forEach(element => {
        element.name = element.fileName
      })
      this.formData.fileInfo = JSON.stringify(newFileInfo)
    },
    handleRemoveFile({ file, fileList }) {
      fileList.forEach(element => {
        element.name = element.fileName
      })
      this.formData.fileInfo = JSON.stringify(fileList)
    },
    // 附件上传失败
    fileError() {
    },
    edit(row) {
      this.curResource = { ...row }
      this.curCarlendarData = this.curResource.investmentList ? JSON.parse(JSON.stringify(this.curResource.investmentList)) : []
      this.showCurResource = true
    },
    delRes(row) {
      this.resourceData.forEach((element, index) => {
        if (element.id === row.id) {
          this.resourceData.splice(index, 1)
        }
      })
    },
    resourceTypeChange({ activeName }) {
      this.curTabName = activeName
    },

    getDetail() {
      queryReportById({ id: this.$route.query.id, taskVersionId: this.$route.query.versionId }).then(res => {
        this.formData = res ? Object.assign({}, this.formData, res.data) : {}
        if (!this.$route.query.currSumFinishPercent) {
          this.$set(this.formData, 'currSumFinishPercent', '')
        } else {
          this.$set(this.formData, 'currSumFinishPercent', this.$route.query.currSumFinishPercent)
        }
        this.formData.currSumFinishPercentTemp = this.formData.currSumFinishPercent
        this.resourceData = this.formData.scheTaskResource
      })
    },
    saveReport() {
      this.$refs.form.validate((valid) => {
        if (!valid) {
          return
        }
        var requestData = { ...this.formData, ...{ projectId: this.$route.params.id }}
        if (requestData.realEndDate && !requestData.realStartDate) {
          this.$alert('请选择实际开始时间')
          return
        }
        requestData.scheTaskResource = this.resourceData
        if (requestData.scheState) {
          this.stateArr.forEach(element => {
            if (requestData.scheState === element.title) {
              requestData.scheState = element.key
            }
          })
        }
        if (requestData.taskState) {
          this.taskArr.forEach(element => {
            if (requestData.taskState === element.title) {
              requestData.taskState = element.key
            }
          })
        }
        updateScheReport(requestData).then(res => {
          if (res.code === '200') {
            this.$router.back()
          } else {
            this.$message({
              message: res.message,
              type: 'warning'
            })
          }
        })
      })
    },
    cancel() {
      this.$router.back()
    },
    addResource() {
      this.showResource = true
    },
    checkResouce() {
      this.showResource = false
      // human的humanSelArr
      const humanSelArr = [...this.$refs.resourceSel.$refs['human'].selResouce]
      var humanTmpArr = []
      humanTmpArr = JSON.parse(JSON.stringify(humanSelArr))
      if (this.formData.scheTaskResource) {
        this.formData.scheTaskResource.forEach(taskItem => {
          humanTmpArr.forEach(element => {
            if (taskItem.resId === element.resId) {
              this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'amount', 'bOldResource'], [
                taskItem.id, taskItem.oldId, taskItem.resCode, taskItem.resName, taskItem.resType, taskItem.resTypeName, taskItem.resourceCaleId, taskItem.resourceCaleName, taskItem.resModel, taskItem.unitPrice, taskItem.startDate, taskItem.endDate, taskItem.unitEstimate, taskItem.unitEstimateName, taskItem.amount, true
              ])
            }
          })
        })
      }
      humanTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          const uid = this.getUUID()
          this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'amount'], [
            uid, uid, '', element.name, '1', '人力', element.resourceCaleId, element.resourceCaleName, '', element.price, '', '', element.unit, element.unitName, '0'
          ])
        }
      })

      // material 的处理
      //  material的 materialSelArr
      const materialSelArr = [...this.$refs.resourceSel.$refs['material'].selResouce]
      var materialTmpArr = []
      materialTmpArr = JSON.parse(JSON.stringify(materialSelArr))
      if (this.formData.scheTaskResource) {
        this.formData.scheTaskResource.forEach(taskItem => {
          materialTmpArr.forEach(element => {
            if (taskItem.resId === element.resId) {
              this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'amount', 'bOldResource'], [
                taskItem.id, taskItem.oldId, taskItem.resCode, taskItem.resName, taskItem.resType, taskItem.resTypeName, taskItem.resourceCaleId, taskItem.resourceCaleName, taskItem.resModel, taskItem.unitPrice, taskItem.startDate, taskItem.endDate, taskItem.unitEstimate, taskItem.unitEstimateName, taskItem.amount, true
              ])
            }
          })
        })
      }
      materialTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          const uid = this.getUUID()
          this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'amount'], [
            uid, uid, element.resourceCode, element.resourceName, '2', '材料', element.resourceCaleId, element.resourceCaleName, element.resourceType, element.price, '', '', element.unit, element.unitName, '0'
          ])
        }
      })

      // device 的处理
      //  devicedeviceSelArr
      const deviceSelArr = [...this.$refs.resourceSel.$refs['device'].selResouce]
      var deviceTmpArr = []
      deviceTmpArr = JSON.parse(JSON.stringify(deviceSelArr))
      if (this.formData.scheTaskResource) {
        this.formData.scheTaskResource.forEach(taskItem => {
          deviceTmpArr.forEach(element => {
            if (taskItem.resId === element.resId) {
              this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'amount', 'bOldResource'], [
                taskItem.id, taskItem.oldId, taskItem.resCode, taskItem.resName, taskItem.resType, taskItem.resTypeName, taskItem.resourceCaleId, taskItem.resourceCaleName, taskItem.resModel, taskItem.unitPrice, taskItem.startDate, taskItem.endDate, taskItem.unitEstimate, taskItem.unitEstimateName, taskItem.amount, true
              ])
            }
          })
        })
      }
      deviceTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          const uid = this.getUUID()
          this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'amount'], [
            uid, uid, element.resourceCode, element.resourceName, '3', '设备', element.resourceCaleId, element.resourceCaleName, element.resourceType, element.price, '', '', element.unit, element.unitName, '0'
          ])
        }
      })
      this.formData.scheTaskResource = [...humanTmpArr, ...materialTmpArr, ...deviceTmpArr]
      this.resourceData = [...humanTmpArr, ...materialTmpArr, ...deviceTmpArr]
    },
    setValue(obj, keyArr, valueArr) {
      for (let i = 0; i < keyArr.length; i++) {
        this.$set(obj, keyArr[i], valueArr[i])
      }
    },
    cancelResource() {
      this.$refs.resourceSel.cancelSel()
      this.showResource = false
    },
    addCarlendar() {
      var dictCarlendar = { resourceId: this.curResource.oldId, investmentDate: '', unit: this.curResource.unitEstimate, unitName: this.curResource.unitEstimateName, planAmount: '0', realAmount: '', note: '' }
      this.curCarlendarData.push(dictCarlendar)
    },
    getUUID() {
      return 'xxxxxxxxxxxx4xxxyxxxxxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
        var r = Math.random() * 16 | 0; var v = c === 'x' ? r : (r & 0x3 | 0x8)
        return v.toString(16)
      })
    },

    rowClick(row, col, event) {
      this.$refs.treeTable.setCurrentRow(row)
      this.currentNode = row
    },
    addClass({ row, columnIndex }) {
      return 'justcenter'
    }
  }
}
</script>
<style scoped lang = "scss">
#progressRportEdit.pageDiv{
  padding:10px;
  position:absolute;
  height:100%;
  width:100%;
  overflow-y:scroll;
}
.div__header {
    background-color: #f5f7fa;
    border: 1px solid #e4e7ed;
    /* border-bottom: 1px solid #e4e7ed; */
    margin-top: 10px;
    height:40px;
    line-height: 38px;
    font-size: 15px;
    padding-left:20px;
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
/* /deep/ .el-form-item__label {
    text-align: right;
    vertical-align: middle;
    float: left;
    font-size: 14px;
    color: #606266;
    line-height: 40px;
    padding: 0 12px 0 0;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
} */

/deep/ .el-dialog__body {
    padding: 0px 20px;
    color: #606266;
    font-size: 14px;
    word-break: break-all;
}
.form_item_right{
  width:calc(100% - 50px);
}
/deep/ .el-upload {
     display: inline-block;
    text-align: center;
    cursor: pointer;
    outline: 0;
    width: 100%;
}
/deep/.el-upload-dragger {
    background-color: #fff;
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    width: 100%;
    height: 100px;
    text-align: center;
    position: relative;
    overflow: hidden;
}
/deep/.el-upload-dragger .el-icon-upload {
    font-size: 67px;
    color: #c0c4cc;
    margin: 0px 0 16px;
    line-height: 50px;
}
</style>
