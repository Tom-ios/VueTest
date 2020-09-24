<template>
  <div ref="pageDiv" class="clearfix pageDiv">
    <el-card :body-style="{ padding: '10px' }">
      <el-row v-if="showInfoToolbar" style="border: 1px solid #EBEEF5;padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
        <div style="float:left;margin-left:10px;margin-top:-2px">
          <span>作业状态</span>
          <el-checkbox-group v-model="query.stateCheckTask" size="mini" class="ml-10" style="width:265px;margin-top:-8px;display:inline-block;margin-left:5px">
            <el-checkbox v-for="state in taskArr" :key="state.key" :label="state.title" class="stateCheckBox" style="display:inline-block">{{ state.title }}</el-checkbox>
          </el-checkbox-group>
          <div style="margin-top:2px">
            <span>进度状态</span>
            <el-checkbox-group v-model="query.stateCheckSche" size="mini" class="ml-10" style="width:265px;display:inline-block;margin-left:5px">
              <el-checkbox v-for="state in stateArr" :key="state.key" :label="state.title" class="stateCheckBox" style="display:inline-block">{{ state.title }}</el-checkbox>
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
        <div v-if="!bfweb || statistic" style="float:left;">
          <span class="ml-20"> 作业名称</span>
          <el-input v-model="wbsName" placeholder="" size="mini" style="width: 140px;margin-left:5px" clearable @keyup.enter.native="search" />
          <div>
            <div style="margin-top:5px;float:left">
              <span style="margin-left:35px;"> 负责人</span>
              <el-select v-model="query.principalId" size="mini" placeholder="全部" clearable style="width:140px;margin-left:5px">
                <el-option v-for="item in managermentArr" :key="item.value" size="mini" :label="item.label" :value="item.value" />
              </el-select>
            </div>
          </div>
        </div>
        <div style="float:left;">
          <el-button type="primary" class="ml-10" style="width:73px" size="mini" @click="search">查询</el-button>
          <div>
            <div v-if="bfweb " style="margin-top:5px;float:left;margin-left:10px">
              <el-button plain size="mini" style="width:73px" @click="resetForm()">重置</el-button>
            </div>
          </div>
        </div>
      </el-row>
      <el-row type="flex" justify="center">
        <i
          :class="showInfoToolbar?'el-icon-caret-top':'el-icon-caret-bottom'"
          style="cursor: pointer;"
          @click="showInfoToolbar = !showInfoToolbar;resetGridHeight()"
        />
      </el-row>
      <div style="margin-top:10px">
        <span style="font-size:14px">  当前项目完成百分比: {{ totalPercent }}%</span>
        <span style="margin-left:10px;font-size:14px">  当前项目进展: {{ totalProgress }}</span>
        <el-popover
          v-model="showCustomCol"
          title="自定义列"
          width="120px"
          trigger="click"
        >
          <CustomCol :prop-all-col="allCol" :prop-select-col="selCol" @selectCol="setTableColumn" />
          <el-button slot="reference" size="mini" type="primary" :icon="customIcon" style="float:right;margin-right:20px;margin-top:-3px">自定义列</el-button>
        </el-popover>
        <el-button v-show="!bEdit" type="primary" size="mini" style="float:right;margin-right:10px;margin-top:-3px" @click="editTable">编辑</el-button>
        <el-button v-show="bEdit" style="float:right;margin-right:8px;margin-top:-3px" size="mini" @click="cancel">取消</el-button>
        <el-button v-show="bEdit" type="primary" style="float:right;margin-right:8px;margin-top:-3px" size="mini" @click="saveTable">保存</el-button>
        <el-checkbox v-show="!bEdit" v-model="showDetail" style="float:right;padding-right:8px;margin-top:3px">显示资源</el-checkbox>
      </div>
      <div style="position:relative">
        <el-table
          ref="treeTable"
          :data="tableData"
          border
          stripe
          highlight-current-row
          :header-cell-class-name="'tableHeader'"
          :cell-class-name="addClass"
          :style="{'margin-top':'10px','width':showDetail?'50%':'100%'}"
          :height="maxHeight"
          row-key="id"
          empty-text="暂无数据"
          default-expand-all
          :indent="20"
          :tree-props="{children: 'childList', hasChildren: 'hasChildren'}"
          class="mainTable"
          @row-click="rowClick"
        >
          <el-table-column
            type="index"
            label="序号"
            width="60"
          />
          <el-table-column
            v-for="(col,index) in tablecolumn"
            :key="index"
            :prop="col.key"
            :label="col.title"
            :min-width="col.width?col.width:'100'"
            :fixed="tablecolumn[index].fixed "
          >
            <template slot-scope="scope">
              <span v-if="tablecolumn[index].type ==='opt'">
                <el-button v-if="(scope.row.taskMold === '1' && userId === scope.row.principalId && !statistic) " type="text" @click="edit(scope.row)">编辑</el-button>
              </span>
              <span v-else-if="tablecolumn[index].type==='percent'">
                {{ scope.row[tablecolumn[index].key] }}
                <span v-if="scope.row[tablecolumn[index].key] && scope.row[tablecolumn[index].key] !== 0">%</span>
              </span>
              <span v-else> {{ scope.row[tablecolumn[index].key] }}</span>
            </template>
          </el-table-column>
        </el-table>
        <div v-if="showDetail" :style="{'position':'absolute','width':'calc(50% - 2px)','background':'white','top':'1px','right':'1px','bottom':'1px','padding-left':'5px'}">
          <el-tabs
            v-model="activeName"
          >
            <el-tab-pane v-if="bEdit && formData.principalId === userId" label="进度信息" name="first">
              <el-form v-if="formData.id" ref="form" label-width="110px" :model="formData" style="margin-top:20px;margin-left:20px" :rules="formData.realStartDate && !formData.realEndDate?rules:rules1">
                <el-row>
                  <el-col :span="12">
                    <el-form-item label="实际开始时间：">
                      <el-date-picker v-model="formData.realStartDate" :picker-options="getPickerOption('realStartDate')" value-format="yyyy-MM-dd" type="date" class="form_item_right" />
                    </el-form-item>
                    <el-form-item label="实际结束时间：">
                      <el-date-picker v-model="formData.realEndDate" :picker-options="getPickerOption('realEndDate')" value-format="yyyy-MM-dd" type="date" class="form_item_right" />
                    </el-form-item>
                    <el-form-item label="实际工期：">
                      <span>{{ (formData.realDuration || formData.realDuration===0) ?formData.realDuration:"-" }}</span>天
                    </el-form-item>

                    <el-form-item v-if="!formData.realEndDate && formData.realStartDate" label="剩余工期：" prop="remainDuration">
                      <el-input v-model="formData.remainDuration" maxlength="6" class="form_item_right" :disabled="formData.realEndDate?true:false" />
                    </el-form-item>
                    <el-form-item label="附件：" class="form_item_right">
                      <FileUpload ref="fileUpload" v-model="formData.groupId" :business-id="formData.id" type="file" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="作业状态：">
                      <span>{{ formData.taskState }} </span>
                    </el-form-item>
                    <el-form-item label="进度状态：">
                      <span>{{ formData.scheState }}</span>
                    </el-form-item>
                    <el-form-item v-if="formData.scheCalcType ==='03'" label="累计完成比例：" prop="currSumFinishPercent">
                      <el-input v-model="formData.currSumFinishPercent" maxlength="11" style="width:calc(100% - 20px)" type="number" :disabled="formData.scheCalcType !=='03'" /> %
                    </el-form-item>
                    <el-form-item label="暂停日期：">
                      <el-date-picker v-model="formData.stopDate" value-format="yyyy-MM-dd" type="date" class="form_item_right" />
                    </el-form-item>
                    <el-form-item label="复工日期：">
                      <el-date-picker v-model="formData.returnDate" value-format="yyyy-MM-dd" type="date" class="form_item_right" />
                    </el-form-item>
                    <el-form-item label="延期原因：">
                      <el-input v-model="formData.delayReason" maxlength="200" class="form_item_right" />
                    </el-form-item>
                  </el-col>

                </el-row>
              </el-form>
              <div v-else style="text-align:center;margin-top:200px">
                请选择作业
              </div>
            </el-tab-pane>
            <el-tab-pane label="资源信息" name="second">
              <div v-if="bEdit && formData.id && formData.principalId === userId" class="clearfix">
                <el-button type="primary" style="float:right;margin-right:10px" @click="addResource">增加</el-button>
              </div>
              <div v-if="formData.id">
                <el-table
                  ref="resTreeTable"
                  :data="resourceData"
                  border
                  stripe
                  :header-cell-class-name="'tableHeader'"
                  cell-class-name="justcenter"
                  style="margin-top:10px;width:100%"
                  :height="(bEdit&&formData &&formData.principalId === userId)?maxHeight-100:maxHeight-70"
                  row-key="id"
                  empty-text="暂无数据"
                  default-expand-all
                  :indent="20"
                  :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
                  @row-click="rowResClick"
                >
                  <el-table-column
                    type="index"
                    label="序号"
                    width="60"
                  />
                  <el-table-column
                    v-for="(col,index) in carlendarColumn"
                    :key="index"
                    :prop="col.value"
                    :label="col.title"
                    :min-width="col.width?col.width:'100'"
                  >
                    <template slot-scope="scope">
                      <span v-if="carlendarColumn[index].type==='opt'">
                        <el-button v-if="bEdit && formData.principalId === userId" type="text" @click="edit(scope.row,'edit')">编辑</el-button>
                        <el-button v-if="bEdit && formData.principalId === userId" type="text" @click="delRes(scope.row)">删除</el-button>
                        <el-button v-if="!bEdit || (bEdit && formData.principalId !== userId)" type="text" @click="edit(scope.row,'look')">查看</el-button>
                      </span>
                      <span v-else> {{ scope.row[carlendarColumn[index].key] }}</span>
                    </template>
                  </el-table-column>
                </el-table>
              </div>
              <div v-else style="text-align:center;margin-top:200px">请选择作业</div>
            </el-tab-pane>
          </el-tabs>

        </div>
      </div>
    </el-card>
    <el-dialog
      title="增加资源"
      :visible.sync="showResource"
      width="900px"
      @close="cancelResource"
    >
      <div style="height:550px;position:relative">
        <resource ref="resourceSel" key-word="resId" :limit-enable-select="true" :show-tree-tool-bar="false" :cur-sel-rows="curSelRows" select-type="multiple" @resourceTypeChange="resourceTypeChange" />
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
      <el-button v-if="bEdit && formData.principalId === userId" type="primary" style="float:right;margin-right:10px;margin-top:3px;margin-bottom:10px" @click="addCarlendar">增加</el-button>
      <div>
        <el-table
          ref="curTreeTable"
          :data="curCarlendarData"
          border
          stripe
          :header-cell-class-name="userResHeader"
          cell-class-name="justcenter"
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
              <span v-if="curResourceColumn[index].type==='opt'">
                <el-button v-if="curResourceFlag==='edit'&& formData.principalId === userId&& (!scope.row.planAmount || scope.row.planAmount==='0')" type="text" @click="curCarlendarData.splice(scope.$index,1)">删除</el-button>
              </span>
              <span v-if="curResourceColumn[index].type==='date'">
                <el-date-picker v-if="bEdit && formData.principalId === userId && (!scope.row.planAmount || scope.row.planAmount==='0')" v-model="scope.row[curResourceColumn[index].key]" value-format="yyyy-MM-dd" type="date" style="width:150px" />
                <span v-else> {{ scope.row[curResourceColumn[index].key] }}</span>
              </span>
              <span v-else-if="curResourceColumn[index].type==='input'">
                <el-input v-if="bEdit&& formData.principalId === userId" v-model="scope.row[curResourceColumn[index].key]" />
                <span v-else> {{ scope.row[curResourceColumn[index].key] }}</span>
              </span>
              <span v-else-if="curResourceColumn[index].type==='numInput'">
                <el-input v-if="bEdit&& formData.principalId === userId" v-model="scope.row[curResourceColumn[index].key]" type="number" :min="0" step="1" :max="1000000" onkeyup="value=value.replace(/^(0+)|[^\d]+/g,'')" maxlength="10" />
                <span v-else> {{ scope.row[curResourceColumn[index].key] }}</span>
              </span>
              <span v-else> {{ scope.row[curResourceColumn[index].key] }}</span>
            </template>
          </el-table-column>
        </el-table>
      </div>
      <span v-if="bEdit" slot="footer">
        <el-button v-if="bEdit" type="primary" :loading="resouceLoading" @click="saveFunc()">保存</el-button>
        <el-button v-if="bEdit" @click="showCurResource = false">取消</el-button>
      </span>
      <div style="height:20px" />
    </el-dialog>
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import { getReportList, getProjectPeriod, getProgressBoardInfo, queryReportById, updateScheReport, calcDuration, updateReportList } from '@/api/progressReport'
import { queryProjectUserList } from '@/api/project'
import CustomCol from '@/components/CustomCol/index.vue'
import FileUpload from '@/components/FileUpload/index'
import resource from '@/views/systemSet/resource/Resource'
export default {
  components: {
    CustomCol,
    FileUpload,
    resource
  },
  props: {
    statistic: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      curResourceFlag: '',
      saveFunc: null,
      showInfoToolbar: true,
      bPeriod: false,
      maxHeight: 400,
      tableData: [],
      originNum: 0,
      totalPercent: 0,
      totalProgress: '-',
      managermentArr: [],
      taskArr: [{
        'title': '未开始', key: '0' }, {
        'title': '进行中', key: '1' }, {
        'title': '已完成', key: '2' }],
      stateArr: [{
        'title': '提前', key: '0' }, {
        'title': '正常', key: '1' }, {
        'title': '延迟', key: '2' }],
      workStates: [{
        'title': '未开始', key: '0' }, {
        'title': '进行中', key: '1' }, {
        'title': '已完成', key: '2' }, {
        'title': '提前', key: '0' }, {
        'title': '正常', key: '1' }, {
        'title': '延迟', key: '2' }],
      query: {
        actualTime: null,
        planTime: null,
        principalId: '',
        stateCheckTask: [],
        stateCheckSche: []
      },
      tablecolumn: [],
      wbsName: '',
      bfweb: process.env.VUE_APP_BFWEB === 'true',
      showCustomCol: false,
      allCol: [],
      selCol: [],
      bEdit: false,
      showDetail: false,
      activeName: 'second',
      resouceLoading: false,
      showCurResource: false,
      curTabName: 'human',
      curSelRows: [],
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
      carlendarColumn: [
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
          title: '计划开始时间',
          key: 'startDate',
          width: 100
        },
        {
          title: '计划结束时间',
          key: 'endDate',
          width: 80
        },

        {
          title: '单位',
          key: 'unitEstimateName',
          width: 80
        },
        {
          title: '计划使用数量',
          key: 'planAmountTotal',
          width: 100
        },
        {
          title: '累计使用数量',
          key: 'amount',
          width: 100
        },
        {
          title: '操作',
          type: 'opt',
          width: 110
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
        },
        {
          title: '操作',
          width: 110,
          type: 'opt'
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
      calendarArr: []
    }
  },

  computed: {
    customIcon() {
      return this.showCustomCol ? 'el-icon-caret-top' : 'el-icon-caret-bottom'
    },
    ...mapGetters([
      'userId'
    ]),
    curTitle() {
      return '资源投入日历 ( 当前资源:' + this.curResource.resName + ')'
    }
  },
  watch: {
    bEdit(v) {
      if (v) {
        this.showDetail = true
        if (this.formData.principalId === this.userId) {
          this.activeName = 'first'
        } else {
          this.activeName = 'second'
        }
      } else {
        this.activeName = 'second'
      }
    },
    query: {
      handler(newValue, oldValue) {
        this.getList()
      },
      deep: true,
      immediate: true
    },
    showResource(v) {
      if (v) {
        this.$nextTick(() => {
          this.curSelRows = [...this.resourceData]
        })
      }
    },

    'formData.realStartDate': {
      handler: function() {
        this.realStartChange()
      }
    },
    'formData.realEndDate': {
      handler: function() {
        this.realEndChange()
      }
    }
  },
  mounted() {
    this.getProjectInfo()
    this.getMember()
    this.getProjectPeriod()
    this.getList()
    this.saveFunc = this.debounce(this.saveCurResource, 200)
    this.resetGridHeight()
  },
  methods: {
    DateMinus(startDate, endDate) {
      var sdate = new Date(startDate)
      var now = new Date(endDate)
      var days = now.getTime() - sdate.getTime()
      var day = parseInt(days / (1000 * 60 * 60 * 24))
      return day + 1
    },
    realStartChange() {
      if (this.formData.realStartDate && this.formData.realEndDate) {
        this.formData.realDuration = this.calcDuration()
      } else {
        this.$set(this.formData, 'realDuration', '')
      }
      this.caclState()
      this.resetDuration()
    },
    realEndChange() {
      if (this.formData.realStartDate && this.formData.realEndDate) {
        this.formData.realDuration = this.calcDuration()
      } else {
        this.$set(this.formData, 'realDuration', '')
      }
      if (this.formData.realEndDate) {
        this.$set(this.formData, 'realDuration', '')
        try {
          if (this.$refs.form) {
            this.$refs['form'].resetFields()
          }
        } catch (error) {
          console.log(error)
        }
      }
      this.caclState()
      this.resetDuration()
    },
    resetGridHeight() {
      this.$nextTick(() => {
        if (this.showInfoToolbar) {
          this.maxHeight = this.$refs.pageDiv.offsetHeight - 168
        } else {
          this.maxHeight = this.$refs.pageDiv.offsetHeight - 87
        }
      })
    },
    saveTable() {
      if (this.formData.id && this.bEdit && this.formData.principalId === this.userId) {
        this.$refs.form.validate((valid) => {
          if (!valid) {
            this.findTree(this.tableData, (element) => {
              if (element.id === this.formData.id) {
                this.$refs.treeTable.setCurrentRow(element)
              }
            })
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
          this.findTree(this.tableData, (item, index) => {
            if (item.id === requestData.id) {
              for (var key in requestData) {
                this.$set(item, key, requestData[key])
              }
            }
          })
          // 大表单保存------
          var requestArr = []
          this.findTree(this.tableData, (item) => {
            if (item.taskMold !== '0') {
              requestArr.push(item)
            }
          })

          updateReportList(requestArr).then(res => {
            this.showDetail = false
            this.bEdit = false
            this.getList()
            // 刷新进展
            this.getProjectInfo()
          })
        })
      } else {
        // 大表单保存------
        var requestArr = []
        this.findTree(this.tableData, (item) => {
          if (item.taskMold !== '0') {
            requestArr.push(item)
          }
        })

        updateReportList(requestArr).then(res => {
          this.showDetail = false
          this.bEdit = false
          this.getList()
          // this.formData = {}
          // this.resourceData = []
        })
      }
    },
    setTableColumn(arr) {
      if (this.allCol.length === 0) {
        if (this.bPeriod) {
          this.allCol = [
            {
              title: '序号',
              disabled: true
            },
            {
              title: '名称',
              key: 'wbsName',
              width: 320,
              disabled: true
            },
            {
              title: '编码',
              key: 'wbsCode',
              width: 130
            },
            {
              title: '类型',
              key: 'taskMoldName',
              width: 100
            },
            {
              title: '作业状态',
              key: 'taskStateName',
              width: 80
            },
            {
              title: '进度状态',
              key: 'scheStateName',
              width: 80
            },
            {
              title: '本期完成比例',
              key: 'currFinishPercent',
              width: 80,
              type: 'percent'
            },
            {
              title: '上期累计完成比例',
              key: 'lastSumFinishPercent',
              width: 100,
              type: 'percent'
            },
            {
              title: '累计完成比例',
              key: 'currSumFinishPercent',
              width: 100,
              type: 'percent'
            },

            {
              title: '作业类型',
              key: 'taskTypeName',
              width: 80
            },
            {
              title: '权重比例',
              key: 'weights',
              width: 80
            },
            {
              title: '计划工期',
              key: 'planDuration',
              width: 80
            },
            {
              title: '计划开始时间',
              key: 'planStartDate',
              width: 100
            },
            {
              title: '计划结束时间',
              key: 'planEndDate',
              width: 100
            },

            {
              title: '进度计算方式',
              key: 'scheCalcTypeName',
              width: 100
            },
            {
              title: '实际工期',
              key: 'realDuration',
              width: 80
            },
            {
              title: '剩余工期',
              key: 'remainDuration',
              width: 80
            },

            {
              title: '实际开始时间',
              key: 'realStartDate',
              width: 100
            },
            {
              title: '实际完成时间',
              key: 'realEndDate',
              width: 100
            },

            {
              title: '负责人',
              key: 'principalName',
              width: 80
            }
          ]
        } else {
          this.allCol = [
            {
              title: '序号',
              disabled: true
            },
            {
              title: '名称',
              key: 'wbsName',
              width: 320,
              disabled: true
            },
            {
              title: '编码',
              key: 'wbsCode',
              width: 80
            },
            {
              title: '类型',
              key: 'taskMoldName',
              width: 100
            },
            {
              title: '作业状态',
              key: 'taskStateName',
              width: 80
            },
            {
              title: '进度状态',
              key: 'scheStateName',
              width: 80
            },
            {
              title: '累计完成比例',
              key: 'currSumFinishPercent',
              width: 100,
              type: 'percent'
            },
            {
              title: '作业类型',
              key: 'taskTypeName',
              width: 80
            },
            {
              title: '权重比例',
              key: 'weights',
              width: 80
            },
            {
              title: '计划工期',
              key: 'planDuration',
              width: 80
            },
            {
              title: '计划开始时间',
              key: 'planStartDate',
              width: 100
            },
            {
              title: '计划结束时间',
              key: 'planEndDate',
              width: 100
            },

            {
              title: '进度计算方式',
              key: 'scheCalcTypeName',
              width: 100
            },
            {
              title: '实际工期',
              key: 'realDuration',
              width: 80
            },
            {
              title: '剩余工期',
              key: 'remainDuration',
              width: 80
            },
            {
              title: '实际开始时间',
              key: 'realStartDate',
              width: 100
            },
            {
              title: '实际完成时间',
              key: 'realEndDate',
              width: 100
            },

            {
              title: '负责人',
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
        this.selCol = [
          {
            title: '序号',
            disabled: true
          },
          {
            title: '名称',
            key: 'wbsName',
            width: 320
          },
          {
            title: '作业状态',
            key: 'taskStateName',
            width: 80
          },
          {
            title: '进度状态',
            key: 'scheStateName',
            width: 80
          },
          {
            title: '累计完成比例',
            key: 'currSumFinishPercent',
            width: 100,
            type: 'percent'
          },

          {
            title: '实际工期',
            key: 'realDuration',
            width: 80
          },
          {
            title: '剩余工期',
            key: 'remainDuration',
            width: 80
          },
          {
            title: '实际开始时间',
            key: 'realStartDate',
            width: 100
          },
          {
            title: '实际完成时间',
            key: 'realEndDate',
            width: 100
          },

          {
            title: '负责人',
            key: 'principalName',
            width: 80
          }
        ]
        this.selCol.forEach(element => {
          element.name = element.key
          element.label = element.title
        })
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
          if (itemCol.label === label && label !== '序号') {
            selArr.push(itemCol)
          }
        })
      })
      this.tablecolumn = [...selArr]
    },
    resetForm() {
      this.query = {
        actualTime: '',
        planTime: 'null',
        principalId: '',
        stateCheckTask: [],
        stateCheckSche: []
      }
      this.wbsName = ''
      this.taskName = ''
    },
    getProjectInfo() {
      getProgressBoardInfo([{ subProjectId: this.$route.params.id }]).then(res => {
        if (res[0].warnType === '1') {
          this.totalProgress = '正常'
        } else if (res[0].warnType === '2') {
          this.totalProgress = '提前' + res[0].warnDays + '天'
        } else if (res[0].warnType === '3') {
          this.totalProgress = '存在延期风险'
        } else if (res[0].warnType === '4') {
          this.totalProgress = '未延期'
        } else if (res[0].warnType === '5') {
          this.totalProgress = '已延期' + res[0].warnDays + '天'
        }
      })
    },
    search() {
      this.getList()
    },
    editTable(row) {
      this.bEdit = true
    },
    cancel() {
      this.bEdit = false
      this.showDetail = false
      this.getList()
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
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.childList) {
          this.findTree(obj.childList, callBack)
        }
      })
    },
    getList() {
      this.formData = {}
      var state1 = []
      var state2 = []
      this.query.stateCheckTask.forEach(item => {
        this.workStates.forEach(element => {
          if (item === element.title) {
            if (item === '未开始' || item === '进行中' || item === '已完成') {
              state1.push(element.key)
            }
          }
        })
      })
      this.query.stateCheckSche.forEach(item => {
        this.workStates.forEach(element => {
          if (item === element.title) {
            if (item === '提前' || item === '正常' || item === '延迟') {
              state2.push(element.key)
            }
          }
        })
      })

      var [planStartDate, planEndDate, realStartDate, realEndDate] = ['', '', '', '']
      if (this.query.planTime && this.query.planTime.length === 2) {
        planStartDate = this.query.planTime[0]
        planEndDate = this.query.planTime[1]
      }
      if (this.query.actualTime && this.query.actualTime.length === 2) {
        realStartDate = this.query.actualTime[0]
        realEndDate = this.query.actualTime[1]
      }
      var requestData = {
        projectId: this.$route.params.id,
        taskName: this.wbsName ? this.wbsName.trim() : '',
        principalId: this.query.principalId,
        taskState: state1.join(','),
        scheState: state2.join(','),
        planStartDate: planStartDate,
        planEndDate: planEndDate,
        realStartDate: realStartDate,
        realEndDate: realEndDate
      }
      if (this.fweb && !this.statistic) {
        requestData.principalId = this.userId
      }
      getReportList(requestData).then(res => {
        this.originNum = 0
        this.totalPercent = 0
        this.findTree(res.data, item => {
          item.scheTaskResource = item.resourceVerList
          if (item.scheTaskResource && item.scheTaskResource.length > 0) {
            item.scheTaskResource.forEach(element => {
              element.amount = element.useCount
            })
          }
          if (item.id === this.formData.id) {
            this.$refs.treeTable.setCurrentRow(item)
          }
          if (item.state2 && item.state2.indexOf('延迟') > -1) {
            item.bgcolor = 'red'
          }
          if (item.parentId === '-1') {
            this.originNum++
            this.totalPercent = this.totalPercent + (item.currSumFinishPercent || 0) * (item.weights / 100)
          }
        })
        if (this.originNum) {
          this.totalPercent = Number(this.totalPercent).toFixed(2)
        }

        this.tableData = res.data
      })
    },
    rowClick(row, col, event) {
      // 点击wbs节点时只需选中状态即可。
      if (row.taskMold === '0') {
        this.$nextTick(() => {
          this.findTree(this.tableData, (element) => {
            if (element.id === this.formData.id) {
              this.$refs.treeTable.setCurrentRow(element)
            }
          })
        })
        return
      }
      // 点击任务节点执行以下操作
      if (this.formData.id && this.bEdit && this.formData.principalId === this.userId) {
        this.$refs.form.validate((valid) => {
          if (!valid) {
            this.findTree(this.tableData, (element) => {
              if (element.id === this.formData.id) {
                this.$refs.treeTable.setCurrentRow(element)
              }
            })
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
          this.findTree(this.tableData, (item, index) => {
            if (item.id === requestData.id) {
              for (var key in requestData) {
                this.$set(item, key, requestData[key])
              }
            }
          })
          this.$refs.treeTable.setCurrentRow(row)
          this.formData = { ...row }
          // 重新计算当前的状态
          this.realStartChange()
          this.realEndChange()
          this.formData.currSumFinishPercentTemp = this.formData.currSumFinishPercent
          this.resourceData = this.formData.scheTaskResource
          this.activeName = (this.formData.principalId === this.userId) ? 'first' : 'second'
        })
      } else {
        this.$refs.treeTable.setCurrentRow(row)
        this.formData = { ...row }
        // 重新计算当前的状态
        this.realStartChange()
        this.realEndChange()
        this.formData.currSumFinishPercentTemp = this.formData.currSumFinishPercent
        this.resourceData = this.formData.scheTaskResource
        if (this.bEdit && this.formData.principalId === this.userId) {
          this.activeName = 'first'
        } else {
          this.activeName = 'second'
        }
      }
    },
    // rowdbClick(row, col, event) {
    //   if (row.taskMold === '1' && this.userId === row.principalId && !this.statistic) {
    //     this.$router.push({ path: '/progressReport/edit/' + this.$route.params.id, query: { id: row.id || '2', versionId: row.versionId, currSumFinishPercent: row.currSumFinishPercent }})
    //   }
    // },
    addClass({ row, columnIndex }) {
      if (row.taskMold === '1') {
        if (columnIndex !== 1) {
          if (row.bgcolor && row.bgcolor === 'red' && this.tablecolumn[columnIndex - 1] && this.tablecolumn[columnIndex - 1].value === 'state2') {
            return 'redBgColor'
          }
          return 'justcenter'
        }
      } else {
        if (columnIndex !== 1) {
          return 'grayBgColorCenter'
        } else {
          return 'grayBgColor'
        }
      }
    },
    userResHeader({ row, rowIndex, column, columnIndex }) {
      if ((this.bEdit && this.formData.principalId === this.userId) && (columnIndex === 1)) {
        return 'must'
      } else {
        return 'tableHeader'
      }
    },
    getMember() {
      var dict = {
        pageSize: 9999,
        pageIndex: 0,
        projectId: this.$route.params.id
      }
      queryProjectUserList(dict).then(res => {
        this.managermentArr = []
        if (!res.rows) return
        res.rows.forEach(element => {
          this.managermentArr.push({
            label: element.userName,
            value: element.id
          })
        })
      })
    },
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
        this.$message({
          message: '数据有重复日期，请修改',
          type: 'warning'
        })
        return
      }

      // this.curResource.startDate = this.getMinDate(saveData)
      // this.curResource.endDate = this.getMaxDate(saveData)
      var totalAmount = 0
      var isValid = false
      saveData.forEach(element => {
        if (element.realAmount) {
          totalAmount += parseFloat(element.realAmount)
        }
        if (!element.investmentDate) {
          isValid = true
        }
      })
      if (isValid) {
        this.$message({
          message: '请选择日期',
          type: 'warning'
        })
        return
      }
      this.resouceLoading = true
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
    edit(row, flag) {
      this.curResourceFlag = flag
      var dateNum = this.DateMinus(row.startDate, row.endDate)
      this.curResource = { ...row }
      if (dateNum > 0 && (!this.curResource.investmentList || (this.curResource.investmentList && this.curResource.investmentList.length === 0))) {
        this.curResource.investmentList = []
        for (let i = 0; i < dateNum; i++) {
          var nowDate = new Date(row.startDate).getTime() + 24 * 60 * 60 * 1000 * i
          this.curResource.investmentList.push({ 'resourceId': this.curResource.oldId, 'investmentDate': this.formatDate(nowDate), realAmount: '', planAmount: parseInt(this.curResource.planAmountTotal) / dateNum, unitName: this.curResource.unitEstimateName })
        }
      }
      this.curCarlendarData = this.curResource.investmentList ? JSON.parse(JSON.stringify(this.curResource.investmentList)) : []
      this.showCurResource = true
    },

    formatDate(sDate) {
      var date = new Date(sDate)
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
              this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'investmentList', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'planAmountTotal', 'amount', 'bOldResource'], [
                taskItem.id, taskItem.oldId, taskItem.resCode, taskItem.resName, taskItem.investmentList, taskItem.resType, taskItem.resTypeName, taskItem.resourceCaleId, taskItem.resourceCaleName, taskItem.resModel, taskItem.unitPrice, taskItem.startDate, taskItem.endDate, taskItem.unitEstimate, taskItem.unitEstimateName, taskItem.planAmountTotal, taskItem.amount, true
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
          this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'investmentList', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'planAmountTotal', 'amount'], [
            uid, uid, '', element.name, element.investmentList, '1', '人力', element.resourceCaleId, element.resourceCaleName, '', element.price, '', '', element.unit, element.unitName, element.planAmountTotal, '0'
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
              this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'investmentList', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'planAmountTotal', 'amount', 'bOldResource'], [
                taskItem.id, taskItem.oldId, taskItem.resCode, taskItem.resName, taskItem.investmentList, taskItem.resType, taskItem.resTypeName, taskItem.resourceCaleId, taskItem.resourceCaleName, taskItem.resModel, taskItem.unitPrice, taskItem.startDate, taskItem.endDate, taskItem.unitEstimate, taskItem.unitEstimateName, taskItem.planAmountTotal, taskItem.amount, true
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
          this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'investmentList', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'planAmountTotal', 'amount'], [
            uid, uid, element.resourceCode, element.resourceName, element.investmentList, '2', '材料', element.resourceCaleId, element.resourceCaleName, element.resourceType, element.price, '', '', element.unit, element.unitName, element.planAmountTotal, '0'
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
              this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'investmentList', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'planAmountTotal', 'amount', 'bOldResource'], [
                taskItem.id, taskItem.oldId, taskItem.resCode, taskItem.resName, taskItem.investmentList, taskItem.resType, taskItem.resTypeName, taskItem.resourceCaleId, taskItem.resourceCaleName, taskItem.resModel, taskItem.unitPrice, taskItem.startDate, taskItem.endDate, taskItem.unitEstimate, taskItem.unitEstimateName, taskItem.planAmountTotal, taskItem.amount, true
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
          this.setValue(element, ['id', 'oldId', 'resCode', 'resName', 'investmentList', 'resType', 'resTypeName', 'resourceCaleId', 'resourceCaleName', 'resModel', 'unitPrice', 'startDate', 'endDate', 'unitEstimate', 'unitEstimateName', 'planAmountTotal', 'amount'], [
            uid, uid, element.resourceCode, element.resourceName, element.investmentList, '3', '设备', element.resourceCaleId, element.resourceCaleName, element.resourceType, element.price, '', '', element.unit, element.unitName, element.planAmountTotal, '0'
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
    rowResClick(row, col, event) {
      this.$refs.resTreeTable.setCurrentRow(row)
      this.currentNode = row
    }
  }
}
</script>
<style scoped lang="scss">
.pageDiv{
  padding:10px;
  position:absolute;
  height:100%;
  width:100%;
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
.form_item_right{
  width:100%;
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
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
/deep/ .el-dialog__body {
    padding: 0px 20px;
    color: #606266;
    font-size: 14px;
    word-break: break-all;
}
/deep/ .justcenter{
  text-align: center;
}
/deep/ .readOnlycenter{
  text-align: center;
}
/deep/ .el-checkbox__label{
  line-height: 16px
}
 /deep/ .el-table td.redBgColor{
  background: red;
  text-align: center;
}
 /deep/ .el-table td.grayBgColor{
  background: #dcdfe6 !important;
}
 /deep/ .el-table td.grayBgColorCenter{
  background: #dcdfe6 !important;
    text-align: center;
}
/deep/ .el-card {
    border: 1px solid #EBEEF5;
    background-color: #FFF;
    color: #303133;
    -webkit-transition: .3s;
    transition: .3s;
    height:100%;
}
/deep/ .el-card__body{
  height:100%
}
/deep/ .el-table--striped .el-table__body tr.el-table__row--striped td {
background: transparent;
}
/deep/ .el-date-editor--daterange.el-input__inner {
    width: 260px;
}
/deep/ .el-date-editor .el-range-separator {
    width: 8%;
    color: #303133;
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
/deep/ table th.must div:before  {
			content: '*';
			color: #ff1818;

}
/deep/ table th.must{
	text-align: center;
  font-size:13px;
}

// 解决 elementUi table动态显隐行列时高度塌缩bug，定死表头，计算表体高度即可
 .mainTalbe /deep/ .el-table th, .el-table tr {
    height: 40px;
  }
.mainTalbe /deep/ .el-table__body-wrapper {
    height: calc(100% - 40px) !important;
  }
</style>
