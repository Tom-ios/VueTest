<template>
  <div class="pageDiv">
    <el-card :body-style="{ padding: '10px' }">
      <div slot="header">
        <span> 计划参数信息</span>
        <el-button style="float:right;margin-right:20px;margin-top:-7px" type="primary" @click="editParams">编辑</el-button>
      </div>
      <el-form ref="form" label-width="120px">
        <el-row style="margin-top:8px">
          <el-col :span="8">
            <el-form-item label="wbs编制方式:">
              <span v-if="paramsData.wbsEditType === '2'">手动</span>
              <span v-else>导入</span>
            </el-form-item>
            <el-form-item label="级别设置:" />
          </el-col>
          <el-col :span="8">
            <el-form-item label="wbs模板:">
              <span> {{ paramsData.wbsTempName }} </span>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="wbs编码规则:">
              <span> {{ paramsData.wbsCodeRuleName }} </span>
            </el-form-item>
          </el-col>
        </el-row>
        <el-table
          v-if="isFinishWbsImport || wbsEditType === '2'"
          ref="wbsTable"
          :data="paramsData.scheWbsLevelList"
          border
          stripe
          :header-cell-class-name="'tableHeader'"
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
              <span v-if="levelColumn[index].type==='approval'">
                <span v-if=" scope.row[levelColumn[index].key] === 0 "> 否</span>
                <span v-else>是</span>
              </span>
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
      <el-form ref="form" label-width="130px">
        <el-row style="margin-top:8px">
          <el-col :span="8">
            <el-form-item label="数据开始时间:">
              <span> {{ paramsData.beginDate }} </span>
            </el-form-item>
            <el-form-item label="数据结束时间:">
              <span> {{ paramsData.endDate }} </span>
            </el-form-item>
            <el-form-item label="项目合同额(元):">
              <span> {{ paramsData.contractAmount | money }} </span>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="必须完成时间:">
              <span> {{ paramsData.completeDeadline }} </span>
            </el-form-item>
            <el-form-item label="关键路径计算方式:">
              <span> {{ paramsData.criticalPathCalculationName }} </span>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="进度填报周期:">
              <span> {{ paramsData.cycleName }} </span>
            </el-form-item>
            <el-form-item label="初始反馈日期:">
              <span> {{ paramsData.feedbackDate }} </span>
            </el-form-item>

          </el-col>
        </el-row>
      </el-form>
    </el-card>
    <el-card :body-style="{ padding: '10px' }" class="mt20">
      <div slot="header">
        <span> 项目日历</span>
      </div>
      <el-form ref="form" label-width="130px">
        <el-row style="margin-top:8px">
          <el-col :span="8">
            <el-form-item label="日历名称:">
              <span> {{ paramsData.scheProjectCalendar.calendarName }} </span>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="备注:">
              <span> {{ paramsData.scheProjectCalendar.remark }} </span>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <el-table
        ref="calendarTable"
        :data="workDays"
        border
        stripe
        :header-cell-class-name="'tableHeader'"
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
            <span> {{ scope.row[carlendarWorkColumn[index].key] }}</span>
          </template>
        </el-table-column>
      </el-table>
      <el-form label-width="106px">
        <el-row style="margin-top:8px;margin-left:25px">
          <el-col :span="8">
            <el-form-item label="例外日期" />
          </el-col>
        </el-row>
      </el-form>
      <el-table
        ref="weekTable"
        :data="paramsData.scheProjectCalendar.scheProjectCalendarExpList"
        border
        stripe
        :header-cell-class-name="'tableHeader'"
        :cell-class-name="addClass"
        style="width:500px;margin-top:10px"
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
            <span v-if="carlendarWeekColumn[index].type ==='select'"> {{ scope.row[carlendarWeekColumn[index].key] === 1?"工作日":"非工作日" }}</span>
            <span v-else>{{ scope.row[carlendarWeekColumn[index].key] }}</span>
          </template>
        </el-table-column>
      </el-table>

    </el-card>
  </div>
</template>

<script>
import { getProjectParams, getProjectCalendarDefault, getDefaultCodeRule } from '@/api/projectSet'
import { mapGetters } from 'vuex'
export default {
  filters: {
    money: function(val) {
      if (val === null || val === '' || val === undefined) {
        return ''
      }
      val = val + ''
      val = val.replace(/\$|\,/g, '')
      if (isNaN(val)) {
        val = '0'
      }
      val = Math.floor(val * 100 + 0.50000000001)
      let cents = val % 100
      val = Math.floor(val / 100).toString()
      if (cents < 10) {
        cents = '0' + cents
      }
      for (var i = 0; i < Math.floor((val.length - (1 + i)) / 3); i++) {
        val = val.substring(0, val.length - (4 * i + 3)) + ',' + val.substring(val.length - (4 * i + 3))
      }

      return (val + '.' + cents)
    }
  },
  data() {
    return {
      wbsEditType: '1', // wbs导入方式
      isFinishWbsImport: false, // 检查项目是否点击过导入完成，导入完成则展示级别设置子表
      paramsData: {
        wbsTempName: '-',
        wbsCodeRule: '',
        wbsCodeRuleName: '-',
        scheWbsLevelList: [],
        beginDate: '-',
        endDate: '-',
        completeDeadline: '-',
        cycle: 1,
        cycleName: '实时',
        feedbackDate: '-',
        approval: '0',
        approvalName: '否',
        criticalPathCalculation: '1',
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
      workDays: [],
      weekDays: [],
      levelColumn: [
        {
          title: '级别',
          key: 'levelName',
          width: 80
        },
        {
          title: '编制角色',
          key: 'roleName',
          width: 150
        },
        {
          title: '是否需要审批',
          key: 'approval',
          type: 'approval',
          width: 80
        },
        {
          title: '审批上级',
          key: 'approveUserName',
          width: 150
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
          width: 100
        },
        {
          title: '开始时间',
          key: 'beginDate',
          width: 100
        },
        {
          title: '结束时间',
          key: 'endDate',
          width: 100
        },
        {
          title: '类型',
          key: 'workDay',
          width: 100,
          type: 'select'
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
    getDataByProject() {
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
        if (!res.data.wbsCodeRule) {
          getDefaultCodeRule({ codeType: 1, tentantId: this.tentantId }).then(ruleRes => {
            this.paramsData.wbsCodeRule = ruleRes.id
            this.paramsData.wbsCodeRuleName = ruleRes.tempName
          })
        }
        if (!res.data.scheProjectCalendar) {
          var param = {
            tentantId: this.tentantId,
            projectId: this.$route.params.id
          }
          getProjectCalendarDefault(param).then(carlenRes => {
            const data = carlenRes.data[0]
            this.paramsData.scheProjectCalendar.calendarName = data.calendarName
            this.paramsData.scheProjectCalendar.remark = data.remark
            this.paramsData.scheProjectCalendar.scheProjectCalendarDetList = data.setCalendarDetList
            this.paramsData.scheProjectCalendar.scheProjectCalendarExpList = data.setCalendarExpList
            var dict1 = { name: '工作时长(小时)' }
            var dict2 = { name: '工作时日' }
            this.paramsData.scheProjectCalendar.scheProjectCalendarDetList.forEach(element => {
              dict1['week' + element.weekDay] = element.workHour
              dict2['week' + element.weekDay] = element.workDay === 1 ? '是' : '否'
            })
            this.workDays.push(dict1)
            this.workDays.push(dict2)
            this.weekDays = this.paramsData.scheProjectCalendar.scheProjectCalendarExpList
            if ((!this.paramsData.scheWbsLevelList || this.paramsData.scheWbsLevelList.length === 0) && this.paramsData.wbsEditType === '2') {
              this.paramsData.scheWbsLevelList = [{ 'levelName': '一级计划', 'level': '1', 'projectId': this.$route.params.id, 'type': 0, 'approval': 1
              }, { 'levelName': '作业', 'level': '', 'projectId': this.$route.params.id, 'type': 1, 'approval': 1
              }]
            }
          })
        } else {
          this.paramsData = res.data
          if ((!this.paramsData.scheWbsLevelList || this.paramsData.scheWbsLevelList.length === 0) && this.paramsData.wbsEditType === '2') {
            this.paramsData.scheWbsLevelList = [{ 'levelName': '一级计划', 'level': '1', 'projectId': this.$route.params.id, 'type': 0, 'approval': 1
            }, { 'levelName': '作业', 'level': '', 'projectId': this.$route.params.id, 'type': 1, 'approval': 1
            }]
          }
          var dict1 = { name: '工作时长(小时)', type: 'input' }
          var dict2 = { name: '工作日', type: 'select' }
          this.paramsData.scheProjectCalendar.scheProjectCalendarDetList.forEach(element => {
            dict1['week' + element.weekDay] = element.workHour
            dict2['week' + element.weekDay] = element.workDay === 1 ? '是' : '否'
          })
          this.workDays.push(dict1)
          this.workDays.push(dict2)
          this.weekDays = this.paramsData.scheProjectCalendar.scheProjectCalendarExpList
        }
      })
    },
    editParams() {
      this.$router.push({ path: '/projectSet/setParams/edit/' + this.$route.params.id })
    },
    addClass({ row, columnIndex }) {
      return 'justcenter'
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
  overflow-y: scroll;
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
.mt20 {
  margin-top:20px
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
</style>
