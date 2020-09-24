<template>
  <div class="pageDiv">
    <el-card :body-style="{ padding: '10px' }">
      <div slot="header">
        <span> 计划参数信息</span>
      </div>
      <el-form ref="wbsform" label-width="120px">
        <el-row style="margin-top:8px">
          <el-col :span="6">
            <el-form-item label="wbs编制方式:" style="margin-left:28px;">
              <el-radio-group v-model="wbsEditType" @change="changeStyle">
                <el-radio v-model="wbsEditType" label="1">导入</el-radio>
                <el-radio v-model="wbsEditType" label="2">手动</el-radio>
              </el-radio-group>
            </el-form-item>
            <el-form-item v-if="wbsEditType === '2'" label="级别设置:" />
          </el-col>
          <el-col v-if="wbsEditType === '2'" :span="10">
            <el-form-item label="wbs模板:">
              <el-input ref="wbsTemp" v-model="paramsData.wbsTempName" :readonly="true" class="inputW-200" />
              <el-button type="primary" @click="checkWBSTemplate">选择</el-button>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="wbs编码规则:">
              <el-input v-model="paramsData.wbsCodeRuleName" :readonly="true" class="inputW-200" />
              <el-button type="primary" @click="checkCodeRuleTemplate">选择</el-button>
            </el-form-item>
            <el-button v-if="wbsEditType === '2'" type="primary" style="float:right;margin-right:40px;" @click="addLevelPlan">增加</el-button>
          </el-col>
        </el-row>
        <el-table
          v-if="isFinishWbsImport || wbsEditType === '2'"
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
                <el-button v-if="scope.row.type === 0 && scope.row.level !== '1' " type="text" @click="delLevel(scope.$index, scope.row)">删除</el-button>
              </span>
              <div
                v-else-if="levelColumn[index].type==='click'"
                style="height: 30px;border: #DCDFE6 1px solid; border-radius: 4px;background: white; line-height: 30px;"
                @click="showRoleList(scope.$index, scope.row,levelColumn[index].key)"
              >
                {{ scope.row[levelColumn[index].key] }}
              </div>
              <span v-else> {{ scope.row[levelColumn[index].key] }}</span>
            </template>
          </el-table-column>
        </el-table>
      </el-form>
    </el-card>
    <el-card :body-style="{ padding: '10px' }" class="mt20">
      <div slot="header">
        <span> 进度参数信息</span>
      </div>
      <el-form ref="moneyForm" label-width="130px" :rules="rules" :model="paramsData">
        <el-row style="margin-top:8px">
          <el-col :span="8">
            <el-form-item label="数据开始时间:">
              <el-date-picker
                v-model="paramsData.beginDate"
                align="right"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd"
              />
            </el-form-item>
            <el-form-item label="数据结束时间:">
              <el-date-picker
                v-model="paramsData.endDate"
                align="right"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd"
              />
            </el-form-item>
            <el-form-item label="项目合同额(元):" prop="contractAmount">
              <el-input v-model="paramsData.contractAmount" class="inputW-200" maxlength="11" />
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="必须完成时间:">
              <el-date-picker
                v-model="paramsData.completeDeadline"
                align="right"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd"
              />
            </el-form-item>
            <el-form-item label="关键路径计算方式:">
              <el-radio v-model="paramsData.criticalPathCalculation" :label="1">最长路径</el-radio>
              <el-radio v-model="paramsData.criticalPathCalculation" :label="2">总浮时小于等于0</el-radio>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="进度填报周期:">
              <!-- <span> {{ paramsData.cycleName }} </span> -->
              <el-radio v-model="paramsData.cycle" :label="1">实时</el-radio>
              <el-radio v-model="paramsData.cycle" :label="2">周</el-radio>
              <el-radio v-model="paramsData.cycle" :label="3">双周</el-radio>
              <el-radio v-model="paramsData.cycle" :label="4">月</el-radio>
            </el-form-item>
            <el-form-item label="初始反馈日期:">
              <el-date-picker
                v-model="paramsData.feedbackDate"
                align="right"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd"
              />
            </el-form-item>

          </el-col>
        </el-row>
      </el-form>
    </el-card>
    <el-card :body-style="{ padding: '10px' }" class="mt20">
      <div slot="header">
        <span> 项目日历</span>
        <el-button style="float:right;margin-right:30px;margin-top:-7px" type="primary" @click="showCarlendar = true">选择日历</el-button>
      </div>
      <el-form ref="form" label-width="130px">
        <el-row style="margin-top:8px">
          <el-col :span="8">
            <el-form-item label="日历名称:">
              <span>{{ paramsData.scheProjectCalendar.calendarName }} </span>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="备注:">
              <span>{{ paramsData.scheProjectCalendar.remark }} </span>
            </el-form-item>
          </el-col>

        </el-row>
      </el-form>
      <el-table
        ref="calendarTable"
        :data="workDays"
        border
        stripe
        :header-cell-class-name="getWeekHeaderClass"
        :cell-class-name="addClass"
        style="width:90%;margin-top:10px"
        row-key="id"
        empty-text="暂无数据"
      >
        <el-table-column
          type="index"
          label="序号"
          width="60"
        />
        <el-table-column
          v-for="(col,index) in carlendarWorkColumn"
          :key="index"
          :prop="col.value"
          :label="col.title"
          :min-width="col.width?col.width:'100'"
        >
          <template slot-scope="scope">
            <el-input v-if="scope.row.type==='input' && carlendarWorkColumn[index].key !=='name'" v-model="scope.row[carlendarWorkColumn[index].key]" type="number" step="1" />
            <span v-else-if="scope.row.type==='select' && carlendarWorkColumn[index].key !=='name'">
              <el-select v-model="scope.row[carlendarWorkColumn[index].key]" size="mini">
                <el-option
                  v-for="item in approvalArr"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </span>
            <span v-else>
              {{ scope.row[carlendarWorkColumn[index].key] }}
            </span>
          </template>
        </el-table-column>
      </el-table>
      <el-form label-width="106px">
        <el-row style="margin-top:8px;margin-left:25px">
          <el-col :span="12">
            <el-form-item label="例外日期" />
          </el-col>
          <el-col :span="12">
            <el-button type="primary" style="float:right;margin-right:30px;margin-top:10px" @click="addWeekDays"> 增加</el-button>
          </el-col>
        </el-row>
      </el-form>

      <el-table
        ref="weekTable"
        :data="paramsData.scheProjectCalendar.scheProjectCalendarExpList"
        border
        stripe
        :header-cell-class-name="getLevelHeaderClass"
        :cell-class-name="addClass"
        style="width:950px;margin-top:10px"
        row-key="id"
        empty-text="暂无数据"
      >
        <el-table-column
          type="index"
          label="序号"
          width="60"
        />
        <el-table-column
          v-for="(col,index) in carlendarWeekColumn"
          :key="index"
          :prop="col.value"
          :label="col.title"
          :min-width="col.width?col.width:'100'"
        >
          <template slot-scope="scope">
            <span v-if="carlendarWeekColumn[index].type==='opt'">
              <el-button type="text" @click="delExtWeek(scope.$index, scope.row)">删除</el-button>
            </span>
            <span v-else-if="carlendarWeekColumn[index].type==='input'">
              <el-input v-model="scope.row[carlendarWeekColumn[index].key]" />
            </span>

            <span v-else-if="carlendarWeekColumn[index].type==='date'">
              <el-date-picker
                v-model="scope.row[carlendarWeekColumn[index].key]"
                type="date"
                placeholder="选择日期"
                value-format="yyyy-MM-dd"
                style="width:160px"
                :picker-options="getPickerOption(carlendarWeekColumn[index].key,scope.row)"
              />
            </span>
            <span v-else-if="carlendarWeekColumn[index].type ==='select'">
              <el-select v-model="scope.row[carlendarWeekColumn[index].key]" size="mini">
                <el-option
                  v-for="item in isWorkArr"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </span>
            <span v-else> {{ scope.row[carlendarWeekColumn[index].key] }}</span>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    <div style="margin-top:20px;display:inline-block;margin-left:calc(50% - 63px)">
      <el-button type="primary" @click="save">保存</el-button>
      <el-button plain @click="cancel">取消</el-button>
    </div>
    <el-dialog
      title="WBS模板"
      :visible.sync="showWbsTemp"
      width="800px"
      :close-on-click-modal="false"
      @close="showWbsTemp = false"
    >
      <div style="height:500px">
        <wbsTemp style="height:500px" select-type="single" :list-height="420" @selectSingle="selectWbsTemp" />
      </div>
    </el-dialog>
    <el-dialog
      title="WBS编码规则模板"
      :visible.sync="showWbsCodeTemp"
      width="800px"
      :close-on-click-modal="false"
      @close="showWbsCodeTemp = false"
    >
      <div style="height:500px">
        <WbsCodeTemp style="height:500px" select-type="single" @selectSingle="selectWbsCodeTemp" />
      </div>
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
    <el-dialog
      title="日历选择"
      :visible.sync="showCarlendar"
      width="840px"
      :close-on-click-modal="false"
      @close="showCarlendar = false"
    >
      <div style="height:500px">
        <CalendarTemplate style="height:500px" select-type="single" @selectSingle="selectCarlendar" />
      </div>
    </el-dialog>
    <SelectPerople ref="human" :visible.sync="humanDialogVisible" sel-type="single" :is-fweb="true" :b-project-select="true" :add-account="false" url="/bimserver/projectUser/queryProjectUserList" @sure="closeHumanDialog" />
  </div>
</template>

<script>
import { getProjectParams, saveParams, getProjectCalendarDefault, getCodeFromWbs, getDefaultCodeRule, checkTaskIsEditFinish, checkIsExistWbs } from '@/api/projectSet'
import wbsTemp from '@/views/wbs/WbsTemplateList/'
import WbsCodeTemp from '@/views/systemSet/resource/WbsCode'
import PersonPermission from '@/views/projectSet/resource/PersonPermission'
import CalendarTemplate from '@/views/systemSet/calendarTemplate/calendarTemplate'
import SelectPerople from '@/components/SelectPeople'
import { mapGetters } from 'vuex'
export default {
  components: {
    wbsTemp,
    WbsCodeTemp,
    PersonPermission,
    CalendarTemplate,
    SelectPerople

  },
  data() {
    return {
      rules: {
        contractAmount: [
          { required: true, message: '请输入项目合同额', trigger: 'blur' },
          {
            trigger: 'blur',
            validator: (rule, value, callback) => {
              const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
              if (MoneyTest.test(value)) {
                callback()
              } else {
                callback(new Error('请输入最多两位小数的金额的非负数'))
              }
            }
          }]
      },
      isFinishWbsImport: false, // 检查项目是否点击过导入完成，导入完成则展示级别设置子表
      taskIsEditFinish: false,
      defalutCodeRule: {},
      curRoleRow: {},
      humanDialogVisible: false,
      showCarlendar: false,
      showRoles: false,
      showWbsTemp: false,
      showWbsCodeTemp: false,
      wbsEditType: '1', // wbs导入方式
      paramsData: {
        contractAmount: '',
        wbsTempName: '',
        wbsCodeRule: '',
        wbsCodeRuleName: '',
        scheWbsLevelList: [],
        beginDate: '',
        endDate: '',
        completeDeadline: '',
        cycle: 1,
        cycleName: '实时',
        feedbackDate: '',
        approval: 0,
        approvalName: '否',
        criticalPathCalculation: 1,
        criticalPathCalculationName: '最长路径',
        scheProjectCalendar: {
          calendarName: '',
          remark: '',
          // 日历信息（工作日）
          scheProjectCalendarDetList: [],
          // 日历信息（非工作日）
          scheProjectCalendarExpList: []
        }

      },
      approvalArr: [{ label: '是', value: 1 }, { label: '否', value: 0 }],
      isWorkArr: [{ label: '非工作日', value: 0 }, { label: '工作日', value: 1 }],
      workDays: [],
      weekDays: [],
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
          width: 50
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
          width: 100
        }

      ],
      carlendarWorkColumn: [
        {
          title: '属性/星期',
          key: 'name',
          width: 100
        },
        {
          title: '周一',
          key: 'week1',
          width: 100
        },
        {
          title: '周二',
          key: 'week2',
          width: 100
        },
        {
          title: '周三',
          key: 'week3',
          width: 100
        },
        {
          title: '周四',
          key: 'week4',
          width: 100
        },
        {
          title: '周五',
          key: 'week5',
          width: 100
        },
        {
          title: '周六',
          key: 'week6',
          width: 100
        },
        {
          title: '周日',
          key: 'week7',
          width: 100
        }
      ],
      carlendarWeekColumn: [
        {
          title: '名称',
          key: 'exceptionName',
          width: 200,
          type: 'input'
        },
        {
          title: '开始时间',
          key: 'beginDate',
          width: 200,
          type: 'date'
        },
        {
          title: '结束时间',
          key: 'endDate',
          width: 200,
          type: 'date'
        },
        {
          title: '类型',
          key: 'workDay',
          width: 150,
          type: 'select'
        },
        {
          title: '操作',
          type: 'opt',
          width: 120
        }

      ]

    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  mounted() {
    this.getDataByProject()
  },
  methods: {
    changeStyle(type) {
      console.log(type)
      checkIsExistWbs(this.$route.params.id).then(res => {
        if (!res) {
          if (type === '2' || type === 2) {
            console.log(2)
            if ((!this.paramsData.scheWbsLevelList || this.paramsData.scheWbsLevelList.length === 0) && this.wbsEditType === '2') {
              this.paramsData.scheWbsLevelList = [{ 'levelName': '一级计划', 'level': '1', 'projectId': this.$route.params.id, 'type': 0, 'approval': 1, 'scheRoleLevelList': []
              }, { 'levelName': '作业', 'level': null, 'projectId': this.$route.params.id, 'type': 1, 'approval': 1, 'scheRoleLevelList': []
              }]
            }
          }
        } else {
          this.$message({
            message: 'wbs编制中有数据，不允许修改wbs编制方式',
            type: 'error'
          })
          if (type === 1 || type === '1') {
            type = '2'
            this.wbsEditType = '2'
            // this.$set(this.wbsEditType, 'wbsEditType', '2')
          } else {
            type = 1
            this.wbsEditType = '1'
            // this.$set(this.wbsEditType, 'wbsEditType', '1')
          }
        }
      })
    },
    changeApprove(item, index) {
      if (item.approval === 0) {
        item.approveUser = ''
        this.$set(this.paramsData.scheWbsLevelList[index], 'approveUserName', '')
      }
    },
    getPickerOption(flag, row) {
      return {
        disabledDate(time) {
          if (flag === 'beginDate') {
            if (row.endDate) {
              return new Date(row.endDate).getTime() < time.getTime()
            } else {
              // return time.getTime() <= new Date().getTime() - (1000 * 60 * 60 * 24)
            }
          } else if (flag === 'endDate') {
            if (row.beginDate) {
              return (new Date(row.beginDate).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
            }
          }
        }
      }
    },
    closeHumanDialog(data) {
      // console.log('datadata', data)
      this.paramsData.scheWbsLevelList.forEach(element => {
        if (element.level === this.curRoleRow.level) {
          if (data && data[0] && data.length > 0) {
            element.approveUser = data[0].id
            this.$set(element, 'approveUserName', data[0].userName)
          } else {
            element.approveUser = ''
            this.$set(element, 'approveUserName', '')
          }
        }
      })

      this.humanDialogVisible = false
    },
    delExtWeek(index, row) {
      this.paramsData.scheProjectCalendar.scheProjectCalendarExpList.splice(index, 1)
    },
    showRoleList(index, row, key) {
      if (key === 'roleName') {
        this.curRoleRow = row
        this.showRoles = true
      } else if (key === 'approveUserName') {
        this.curRoleRow = row
        this.humanDialogVisible = true
      }
    },
    delLevel(index, row) {
      this.paramsData.scheWbsLevelList.splice(index, this.paramsData.scheWbsLevelList.length - (index + 1))
    },
    addWeekDays() {
      this.paramsData.scheProjectCalendar.scheProjectCalendarExpList.push({ projectId: this.$route.params.id, beginDate: '', endDate: '', exceptionName: '', workDay: 0 })
    },
    save() {
      console.log('5959595', this.paramsData)
      this.$refs.moneyForm.validate((valid) => {
        if (valid) {
          if (this.wbsEditType === '1') {
            // 当选择为导入方式的时候，保存是设置wbs模板初始值为空,级别设置也为空
            this.paramsData.wbsTempName = ''
            if (!this.paramsData.id || (this.wbsEditType === '1' && !this.isFinishWbsImport)) {
              this.paramsData.scheWbsLevelList = []
            }
          }
          var bWork = false
          var str = ''
          for (let i = 0; i < this.workDays.length; i++) {
            const workDict = this.workDays[i]
            this.paramsData.scheProjectCalendar.scheProjectCalendarDetList.forEach(element => {
              if (i === 0) {
                for (const key in workDict) {
                  if (key.indexOf('week') > -1 && key.split('week')[1] === element.weekDay) {
                    if (workDict[key] || workDict[key] === 0) {
                      element.workHour = parseFloat(workDict[key])
                    } else {
                      const weekArr = ['一', '二', '三', '四', '五', '六', '日']
                      str ? (str += ',请输入周' + weekArr[element.weekDay - 1] + '的工作时长') : (str += '请输入周' + weekArr[element.weekDay - 1] + '的工作时长')
                    }
                  }
                }
              } else if (i === 1) {
                for (const key in workDict) {
                  if (key.indexOf('week') > -1 && key.split('week')[1] === element.weekDay) {
                    element.workDay = workDict[key]
                  }
                  // eslint-disable-next-line eqeqeq
                  if (workDict[key] === 1) {
                    bWork = true
                  }
                }
              }
            })
          }
          if (str) {
            this.$alert(str, '提示', {
              center: true,
              showConfirmButton: false
            })
            return
          }
          if (!bWork) {
            this.$alert('至少有一天为工作日', '提示', {
              center: true,
              showConfirmButton: false
            })
            return
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
          }
          // c处理非工作日sort
          var requiredStr = ''
          for (let i = 0; i < this.paramsData.scheProjectCalendar.scheProjectCalendarExpList.length; i++) {
            this.paramsData.scheProjectCalendar.scheProjectCalendarExpList[i].sort = i + 1

            var field = ''
            if (!this.paramsData.scheProjectCalendar.scheProjectCalendarExpList[i].exceptionName) {
              field = '名称'
            }
            if (!this.paramsData.scheProjectCalendar.scheProjectCalendarExpList[i].beginDate) {
              field = field ? field + '、开始时间' : '开始时间'
            }
            if (!this.paramsData.scheProjectCalendar.scheProjectCalendarExpList[i].endDate) {
              field = field ? field + '、结束时间' : '结束时间'
            }
            if (field) {
              requiredStr = requiredStr + (requiredStr ? ',第' : '第') + (i + 1) + '行的' + field
            }
          }
          if (requiredStr) {
            this.$alert('请填写' + requiredStr, '提示', {
              center: true,
              showConfirmButton: false
            })
            return
          }

          this.paramsData.projectId = this.$route.params.id
          this.paramsData.wbsEditType = this.wbsEditType // 传递wbsEditType
          // console.log('****', this.paramsData)
          saveParams(this.paramsData).then(res => {
            this.$router.push({ path: '/projectSet/setParams/' + this.$route.params.id })
          })
        }
      })
    },
    cancel() {
      this.$router.push({ path: '/projectSet/setParams/' + this.$route.params.id })
    },
    selectWbsTemp({ row }) {
      this.showWbsTemp = false
      if (!row.wbsCodeRule) {
        row.wbsCodeRule = this.defalutCodeRule.id
        row.wbsCodeRuleName = this.defalutCodeRule.tempName
      }
      if (row.wbsCodeRule !== this.paramsData.wbsCodeRule) {
        this.$confirm(`当前所选模板的编码规则与当前所选编码规则不一致，是否选用模板编码规则?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          closeOnClickModal: false,
          dangerouslyUseHTMLString: true
        }).then(() => {
          this.paramsData.wbsCodeRule = row.wbsCodeRule
          this.paramsData.wbsCodeRuleName = row.wbsCodeRuleName
        })
      }
      if (row.id !== this.paramsData.wbsTempId) {
        getCodeFromWbs({ 'tempWbsId': row.id }).then(res => {
          this.paramsData.scheWbsTempDetList = res.wbsTempDets
          res.levels.forEach(element => {
            element.projectId = this.$route.params.id
            element.type = 0
            element.approval = 1
          })
          this.paramsData.scheWbsLevelList = res.levels
          console.log('this.paramsData', this.paramsData)
          if (!this.paramsData.scheWbsLevelList || this.paramsData.scheWbsLevelList.length === 0) {
            this.paramsData.scheWbsLevelList = [{ 'levelName': '一级计划', 'level': '1', 'projectId': this.$route.params.id, 'type': 0, 'approval': 1, 'scheRoleLevelList': []
            }, { 'levelName': '作业', 'level': null, 'projectId': this.$route.params.id, 'type': 1, 'approval': 1
            }]
          } else {
            this.paramsData.scheWbsLevelList.push({ 'levelName': '作业', 'level': null, 'projectId': this.$route.params.id, 'type': 1, 'approval': 1, 'scheRoleLevelList': []
            })
          }
        })
      }
      this.paramsData.wbsTempId = row.id
      this.paramsData.wbsTempName = row.name
    },
    selectWbsCodeTemp({ row }) {
      this.showWbsCodeTemp = false
      this.paramsData.wbsCodeRule = row.id
      this.paramsData.wbsCodeRuleName = row.tempName
    },
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
    selectCarlendar({ row }) {
      this.showCarlendar = false
      this.paramsData.scheProjectCalendar.id = row.id
      this.paramsData.scheProjectCalendar.calendarName = row.calendarName
      this.paramsData.scheProjectCalendar.remark = row.remark
      this.paramsData.scheProjectCalendar.scheProjectCalendarDetList = row.setCalendarDetList
      this.paramsData.scheProjectCalendar.scheProjectCalendarExpList = row.setCalendarExpList
      var dict1 = { name: '工作时长(小时)', type: 'input' }
      var dict2 = { name: '工作时日', type: 'select' }
      this.paramsData.scheProjectCalendar.scheProjectCalendarDetList.forEach(element => {
        dict1['week' + element.weekDay] = element.workHour
        dict2['week' + element.weekDay] = element.workDay
      })
      this.workDays = []
      this.workDays.push(dict1)
      this.workDays.push(dict2)
      this.weekDays = this.paramsData.scheProjectCalendar.scheProjectCalendarExpList
      if (!this.paramsData.scheWbsLevelList || this.paramsData.scheWbsLevelList.length === 0) {
        this.paramsData.scheWbsLevelList = [{ 'levelName': '一级计划', 'level': '1', 'projectId': this.$route.params.id, 'type': 0, 'approval': 1
        }, { 'levelName': '作业', 'level': null, 'projectId': this.$route.params.id, 'type': 1, 'approval': 1
        }]
      }
    },
    getDataByProject() {
      // 校验作业完成状态
      checkTaskIsEditFinish(this.$route.params.id).then(res => {
        console.log('作业完成状态', res)
        if (res) {
          this.taskIsEditFinish = res
        }
      })

      this.workDays = []
      this.weekDays = []
      getProjectParams({ projectId: this.$route.params.id }).then(res => {
        if (!res.data.wbsEditType || res.data.wbsEditType === '' || res.data.wbsEditType === null) {
          this.wbsEditType = '1'
        } else {
          this.wbsEditType = res.data.wbsEditType
        }
        if (res.data.wbsEditState && res.data.wbsEditState === '1') {
          this.isFinishWbsImport = true
        }
        getDefaultCodeRule({ codeType: 1, tentantId: this.tentantId }).then(ruleRes => {
          this.defalutCodeRule = ruleRes
          if (!res.data || !res.data.wbsCodeRule) {
            this.paramsData.wbsCodeRule = ruleRes.id
            this.paramsData.wbsCodeRuleName = ruleRes.tempName
          }
        })

        if (!res.data.scheProjectCalendar) {
          var param = {
            tentantId: this.tentantId
          }
          getProjectCalendarDefault(param).then(carlenRes => {
            const data = carlenRes.data[0]
            this.paramsData.scheProjectCalendar.id = data.id
            this.paramsData.scheProjectCalendar.calendarName = data.calendarName
            this.paramsData.scheProjectCalendar.remark = data.remark
            this.paramsData.scheProjectCalendar.scheProjectCalendarDetList = data.setCalendarDetList
            this.paramsData.scheProjectCalendar.scheProjectCalendarExpList = data.setCalendarExpList
            var dict1 = { name: '工作时长(小时)', type: 'input' }
            var dict2 = { name: '工作时日', type: 'select' }
            this.paramsData.scheProjectCalendar.scheProjectCalendarDetList.forEach(element => {
              dict1['week' + element.weekDay] = element.workHour
              dict2['week' + element.weekDay] = element.workDay
            })
            this.workDays.push(dict1)
            this.workDays.push(dict2)
            this.weekDays = this.paramsData.scheProjectCalendar.scheProjectCalendarExpList
            if ((!this.paramsData.scheWbsLevelList || this.paramsData.scheWbsLevelList.length === 0) && this.paramsData.wbsEditType === '2') {
              this.paramsData.scheWbsLevelList = [{ 'levelName': '一级计划', 'level': '1', 'projectId': this.$route.params.id, 'type': 0, 'approval': 1, 'scheRoleLevelList': []
              }, { 'levelName': '作业', 'level': null, 'projectId': this.$route.params.id, 'type': 1, 'approval': 1, 'scheRoleLevelList': []
              }]
            }
          })
        } else {
          this.paramsData = res.data
          var dict1 = { name: '工作时长(小时)', type: 'input' }
          var dict2 = { name: '工作时日', type: 'select' }
          this.paramsData.scheProjectCalendar.scheProjectCalendarDetList.forEach(element => {
            dict1['week' + element.weekDay] = element.workHour
            dict2['week' + element.weekDay] = element.workDay
          })
          this.workDays.push(dict1)
          this.workDays.push(dict2)
          this.weekDays = this.paramsData.scheProjectCalendar.scheProjectCalendarExpList
          if ((!this.paramsData.scheWbsLevelList || this.paramsData.scheWbsLevelList.length === 0) && this.paramsData.wbsEditType === '2') {
            this.paramsData.scheWbsLevelList = [{ 'levelName': '一级计划', 'level': '1', 'projectId': this.$route.params.id, 'type': 0, 'approval': 1, 'scheRoleLevelList': []
            }, { 'levelName': '作业', 'level': null, 'projectId': this.$route.params.id, 'type': 1, 'approval': 1, 'scheRoleLevelList': []
            }]
          }
        }
      })
    },
    checkWBSTemplate() {
      if (this.taskIsEditFinish) {
        this.$message({ message: '当前作业编制已完成！不能切换模板', type: 'error' })
      } else {
        this.showWbsTemp = true
      }
    },
    checkCodeRuleTemplate() {
      this.showWbsCodeTemp = true
    },
    addLevelPlan() {
      console.log(this.paramsData.scheWbsLevelList)
      const curlevel = parseInt(this.paramsData.scheWbsLevelList[this.paramsData.scheWbsLevelList.length - 2].level)
      var nextcaplevel = ''
      var nextlevel = ''
      switch (curlevel) {
        case 1:
          nextlevel = curlevel + 1
          nextcaplevel = '二'
          break
        case 2:
          nextlevel = curlevel + 1
          nextcaplevel = '三'
          break
        case 3:
          nextlevel = curlevel + 1
          nextcaplevel = '四'
          break
        case 4:
          nextlevel = curlevel + 1
          nextcaplevel = '五'
          break
        case 5:
          this.$alert('最多允许增加到第5级计划', '提示', {
            center: true,
            showConfirmButton: false
          })
          return
        default: this.$alert('wbs计划有误,不在计划之内', '提示', {
          center: true,
          showConfirmButton: false
        })
          return
      }
      var dict = {
        'levelName': nextcaplevel + '级计划', 'level': nextlevel, 'projectId': this.$route.params.id, 'type': 0, 'approval': 1, 'scheRoleLevelList': []
      }
      this.paramsData.scheWbsLevelList.splice(this.paramsData.scheWbsLevelList.length - 1, 0, dict)
    },

    addClass({ row, columnIndex }) {
      return 'justcenter'
    },
    getWeekHeaderClass({ row, rowIndex, column, columnIndex }) {
      if (columnIndex === 1 || columnIndex === 0) {
        return 'tableHeader'
      } else {
        return 'must'
      }
    },
    getHeaderClass({ row, rowIndex, column, columnIndex }) {
      if (columnIndex === 5 || columnIndex === 0) {
        return 'tableHeader'
      } else {
        return 'must'
      }
    },
    getLevelHeaderClass({ row, rowIndex, column, columnIndex }) {
      if (columnIndex === 1 || columnIndex === 2 || columnIndex === 3 || columnIndex === 4) {
        return 'must'
      } else {
        return 'tableHeader'
      }
    }
  }
}

</script>
<style scoped lang = "scss">
.pageDiv{
  width: 100%;
  height: 100%;
  padding: 10px;
  position:absolute;
  overflow: scroll;
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
/deep/ .el-form-item--small.el-form-item {
    margin-bottom: 5px;
}
/deep/ .el-dialog__body {
    padding: 30px 20px;
    color: #606266;
    font-size: 14px;
    word-break: break-all;
    /* width:calc(100% - 40px) */
}
/deep/ .el-radio {
    color: #606266;
    cursor: pointer;
    margin-right: 10px;
}
 .inputW-140{
  width:140px
}
 .inputW-200{
  width:200px
}
/deep/ table th.must div:before  {
			content: '*';
			color: #ff1818;

}
/deep/ table th.must{
	text-align: center;
  font-size:13px;

}
/deep/ .el-date-editor.el-input, .el-date-editor.el-input__inner {
    width: 200px;
}
.mt20 {
  margin-top:20px
}
</style>
