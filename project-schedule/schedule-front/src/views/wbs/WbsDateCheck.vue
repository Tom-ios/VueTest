<template>
  <div id="wbsDateCheckDiv" ref="wbsDateCheckDiv" class="pageDiv clearfix">
    <el-card :body-style="{ padding: '0px 0px 0px' }">
      <div ref="cardthreeheader" slot="header" class="clearfix">
        <div class="clearfix" style="float:right;padding:0px 10px 5px 0px;">
          <el-button v-if="!bEdit && tableData.length>0" type="primary" size="mini" @click="toEdit">编辑</el-button>
          <el-button v-if="bEdit" type="primary" size="mini" @click="toSure">确定</el-button>
          <el-button v-if="bEdit" type="primary" size="mini" @click="toCancel">取消</el-button>
        </div>
        <div class="clearfix" style="float:left;padding:10px 0px 5px 10px;">
          <span style="font-size:14px;margin-left:-10px">说明：有 <svg-icon icon-class="warn" />  标识的WBS计划设置了强制时间，如果上下级WBS计划的强制时间有冲突，请在【WBS编制】中进行变更</span>
          <div style="background:#ffffb9;margin-left:10px;display:inline-block;padding:5px 5px">冲突的wbs</div> <div style="background:#ffb6b5;margin-left:10px;display:inline-block;padding:5px 5px">问题作业</div>
        </div>
      </div>
      <div>
        <el-table
          ref="curTreeTable"
          :data="tableData"
          border
          stripe
          :header-cell-class-name="'tableHeader'"
          :cell-class-name="addClass"
          style="padding: 10px 10px"
          :max-height="maxGridHeight"
          row-key="id"
          empty-text="暂无数据"
          default-expand-all
          :indent="20"
          :tree-props="{children: 'childList', hasChildren: 'hasChildren'}"
        >
          <el-table-column
            type="index"
            label="序号"
            width="60"
          />
          <el-table-column
            v-for="(col,index) in tablecolumn"
            :key="index"
            :prop="col.name"
            :label="col.label"
            :min-width="col.width?col.width:'100'"
          >
            <template slot-scope="scope">
              <span v-if="tablecolumn[index].type==='date'">
                <el-date-picker
                  v-if="bEdit && scope.row.operate && (scope.row.setType===1 || scope.row.taskType==='0' )"
                  v-model="scope.row[tablecolumn[index].name]"
                  value-format="yyyy-MM-dd"
                  type="date"
                  style="width:150px"
                  :picker-options="getPickerOption(scope.row,tablecolumn[index].name)"
                  @change="dateChange(tablecolumn[index].name,scope.row,scope.$index)"
                />
                <span v-else> {{ scope.row[tablecolumn[index].name] }}</span>
              </span>

              <span v-else-if="tablecolumn[index].type==='mark'">
                <span>{{ scope.row[tablecolumn[index].name] }}</span>
                <svg-icon v-if="scope.row.forceTime===1" icon-class="warn" />
              </span>
              <span v-else-if="tablecolumn[index].type==='input'">
                <el-input v-if="bEdit && scope.row.operate " v-model="scope.row[tablecolumn[index].name]" />
                <span v-else> {{ scope.row[tablecolumn[index].name] }}</span>
              </span>
              <span v-else-if="tablecolumn[index].type==='number'">
                <el-input v-if="bEdit && scope.row.operate && (!scope.row.setType) && scope.row.taskType!=='0' " v-model="scope.row[tablecolumn[index].name]" type="number" :min="1" step="1" onkeyup="value=value.replace(/^(0+)|[^\d]+/g,'')" maxlength="10" @change="scope.row.planStartDate ='';scope.row.planEndDate ='';" />
                <span v-else> {{ scope.row[tablecolumn[index].name] }}</span>
              </span>
              <span v-else-if="tablecolumn[index].type==='type'">
                <span v-if="scope.row.taskMold==='0'"> {{ handlePlanTypeCovert(scope.row.taskMold) }}</span>
                <span v-else> {{ handleTaskTypeCovert(scope.row.taskType) }}</span>
              </span>
              <span v-else> {{ scope.row[tablecolumn[index].name] }}</span>
            </template>
          </el-table-column>
        </el-table>

      </div>

    </el-card>
  </div>

</template>

<script>
import { mapGetters } from 'vuex'
import { iterm, getTaskComboBox } from '@/api/taskComboBox'
import { checkScheTaskList } from '@/api/taskView'
import { getTaskDuration } from '@/api/taskEdit'
export default {
  name: 'WbsDateCheck',
  props: {
    show: {
      type: Boolean,
      default: false
    },
    taskData: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      originData: [],
      oldTableData: [],
      indexRow: {
        title: '序号'
      },
      rowObj: {},
      tablecolumn: [],
      maxGridHeight: 400,
      tableData: [],
      planTypeComboxOptions: [{
        name: 'WBS',
        dictCode: '0'
      }, {
        name: '作业',
        dictCode: '1'
      }],
      taskTypeComboxOptions: [{
        name: '里程碑',
        dictCode: '0'
      }, {
        name: '作业',
        dictCode: '1'
      }
      ],
      bEdit: false,
      curObj: null

    }
  },
  computed: {
    ...mapGetters([
      'userId'
    ])
  },
  watch: {
    show: {
      handler(v) {
        if (v) {
          this.getTreeList()
        }
      },
      immediate: true
    }
  },
  created() {
    this.getTaskComboBox()
  },
  mounted() {
    this.setTableColumn()
  },
  methods: {
    getPickerOption(row, flag) {
      return {
        disabledDate(time) {
          if (row.taskType === '1') {
            if (flag === 'planStartDate') {
              if (row.planEndDate) {
                return ((new Date(row.planEndDate).getTime() < time.getTime()))
              }
            } else if (flag === 'planEndDate') {
              if (row.planStartDate) {
                return (new Date(row.planStartDate).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
              }
            }
          // return time
          }
        }
      }
    },
    dateChange(code, row, index) {
      if (row.taskMold === '1' && row.taskType === '0') {
        if (code === 'planStartDate') {
          row.planEndDate = row[code]
        }
        if (code === 'planEndDate') {
          row.planStartDate = row[code]
        }
      }
      if (row.planStartDate && row.planEndDate) {
        getTaskDuration({ projectId: this.$route.params.id, ...{ startTime: row.planStartDate, endTime: row.planEndDate }}).then(res => {
          if (res.state === 'success') {
            this.$set(row, 'planDuration', res.data)
          } else {
            this.$message.error('计算工期时出错')
          }
        })
      } else {
        row.planDuration = ''
      }
    },
    DateMinus(startDate, endDate) {
      var sdate = new Date(startDate)
      var now = new Date(endDate)
      var days = now.getTime() - sdate.getTime()
      var day = parseInt(days / (1000 * 60 * 60 * 24))
      return day + 1
    },

    handlePlanTypeCovert(value) {
      return this.planTypeComboxOptions.find((element) => (element.dictCode === value)).name
    },
    handleTaskTypeCovert(value) {
      return this.taskTypeComboxOptions.find((element) => (element.dictCode === value)).name
    },
    addClass({ row, columnIndex }) {
      if (!row.colorCt) {
        return ''
      }
      if (row.taskMold === '0') {
        if (columnIndex === 5 || columnIndex === 6 || columnIndex === 7) {
          return 'yellow'
        } else {
          return ''
        }
      } else {
        if (columnIndex === 5 || columnIndex === 6 || columnIndex === 7) {
          return 'red'
        } else {
          return ''
        }
      }
    },
    doubleClick({ id, event }) {
      var task = this.$refs.gantDiv.ganttObj.getTaskBy('id', id)
      if (this.bEdit && task[0].taskMold === '1') {
        if (task[0].operate === false) {
          this.$message.warning('只有创建人和负责人才可编辑哦')
        } else {
          this.$refs.gantDiv.ganttObj.getTask(id).editable = true
        }
      }
    },
    async getTaskComboBox() {
      await getTaskComboBox({ itemId: iterm.workTypeId }).then(res => {
        this.taskTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化作业类型下拉框失败')
      }).finally(() => {
      })
      await getTaskComboBox({ itemId: iterm.taskTypeId }).then(res => {
        this.planTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化任务类型下拉框失败')
      }).finally(() => {
      })
      this.getTreeList()
    },
    setTableColumn() {
      this.tablecolumn = [{
        label: '名称',
        name: 'wbsName',
        width: 200,
        type: 'mark'
      },
      {
        label: '编码',
        name: 'wbsCode',
        width: 100,
        resize: true,
        align: 'left'

      },
      {
        label: '类型',
        name: 'taskMold',
        width: 60,
        align: 'center',
        type: 'type'
      },
      {
        label: '前置任务',
        name: 'taskPreCodes',
        width: 60,
        align: 'left'

      },
      {
        label: '计划工期',
        name: 'planDuration',
        width: 60,
        type: 'number'

      },
      {
        label: '计划开始时间',
        name: 'planStartDate',
        align: 'center',
        width: 100,
        type: 'date'

      }, {
        label: '计划结束时间',
        name: 'planEndDate',
        align: 'center',
        width: 100,
        type: 'date'

      }, {
        label: '负责人',
        name: 'principalName',
        width: 60

      }]
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.childList) {
          this.findTree(obj.childList, callBack)
        }
      })
    },
    getPath(item, treeData) {
      let arr = []
      if (item.taskMold === '0') {
        arr = item.path.split('.')
      } else {
        this.findTree(treeData, (obj) => {
          if (obj.oldId === item.wbsId) {
            arr = obj.path.split('.')
            arr.push(item.id)
          }
        })
      }
      return arr
    },

    // 获取任务列表数据
    getTreeList() {
      this.originData = JSON.parse(this.taskData)
      var oData = JSON.parse(this.taskData)
      oData.data.forEach(element => {
        if (element.taskMold !== '0') {
          element.parentId = element.wbsId
        }
        if (element.hasOwnProperty('childList')) {
          delete element.childList
        }
      })
      const tData = this.convertToTreeData(oData.data, '-1')
      var isForceTime = false
      var qsData = []
      this.findTree(tData, (item) => {
        if (item.forceTime === 1 && item.childList) {
          var isExit = false
          this.findTree(item.childList, (childItem) => {
            if (childItem.planStartDate && childItem.planEndDate && (childItem.planStartDate < item.planStartDate || childItem.planEndDate > item.planEndDate)) {
              qsData.push(childItem)
              isForceTime = true
              isExit = true
            }
          })
          if (isExit) {
            qsData.push(item)
          }
        }
      })
      var pathArr = []
      qsData.forEach(item => {
        const arr = this.getPath(item, tData)
        pathArr.push(...arr)
      })
      // 去重
      var allArr = new Set(pathArr)

      var tmpData = []
      allArr.forEach(id => {
        var dict = {}
        this.findTree(tData, (treeElement) => {
          var itemId = ''
          if (treeElement.taskMold === '0') {
            itemId = treeElement.oldId
          } else {
            itemId = treeElement.id
          }
          if (itemId === id) {
            dict = { ...treeElement }
          }
        })
        tmpData.push(dict)
        tmpData.forEach(element => {
          qsData.forEach(qsItem => {
            if (element.id === qsItem.id) {
              element.colorCt = true
            }
          })
        })
      })
      var treeData = this.convertToTreeData(tmpData, '-1')

      if (!isForceTime) {
        this.tableData = []
      } else {
        this.tableData = treeData
      }
      this.oldTableData = JSON.parse(JSON.stringify(this.tableData))
      this.maxGridHeight = window.innerHeight > 200 ? window.innerHeight - 130 : 400
    },
    convertToTreeData(data, pid) {
      const result = []
      let temp = []
      for (let i = 0; i < data.length; i++) {
        if (data[i].hasOwnProperty('childList')) {
          delete data[i].childList
        }
        const parentId = data[i].taskMold === '0' ? data[i].parentId : data[i].wbsId
        if (parentId === pid) {
          const obj = { ...data[i] }
          const id = data[i].taskMold === '0' ? data[i].oldId : data[i].id
          temp = this.convertToTreeData(data, id)
          if (temp.length > 0) {
            obj.childList = temp
          }
          result.push(obj)
        }
      }
      return result
    },
    // 获取{id}任务的后置任务
    getNextPlan(id) {
      var nextArr = []
      this.originData.data.forEach(taskItem => {
        const relateList = taskItem.relateList
        if (relateList) {
          relateList.forEach(relateItem => {
            if (relateItem.taskPreId && relateItem.taskPreId.indexOf(id) > -1) {
              // taskNextId 为当前的id
              const dict = { taskNextId: relateItem.taskNextId, relationshipId: relateItem.relationshipId, intervalDays: relateItem.intervalDays, projectId: relateItem.projectId }
              nextArr.push(dict)
            }
          })
        }
      })
      return nextArr
    },
    toEdit: function() {
      this.bEdit = true
    },
    toSure: function() {
      var taskData = JSON.parse(JSON.stringify(this.originData.data))
      var isRequred = false
      var durationRequired = false
      taskData.forEach(taskItem => {
        this.findTree(this.tableData, (tableItem) => {
          if (tableItem.operate && (tableItem.setType === 1 || tableItem.taskType === '0') && (!tableItem.planStartDate || !tableItem.planEndDate)) {
            isRequred = true
          }
          if (tableItem.operate && !Number(tableItem.planDuration)) {
            durationRequired = true
          }
          if (taskItem.id === tableItem.id) {
            taskItem.planStartDate = tableItem.planStartDate
            taskItem.planEndDate = tableItem.planEndDate
            taskItem.planDuration = tableItem.planDuration
            taskItem.nextList = null
            taskItem.nextList = this.getNextPlan(taskItem.id)
          }
        })
      })
      if (isRequred) {
        return this.$message.warning('请填写手动设置时间')
      }
      if (durationRequired) {
        return this.$message.warning('请填写工期')
      }
      var treeData = this.convertToTreeData(taskData, '-1')
      checkScheTaskList(treeData, this.$route.params.id).then(res => {
        const task = []
        // 将新增的节点未填开始结束时间的数据推算一下 赋值给tableData
        this.findTree(res.data, element => {
          task.push(element)
          this.findTree(this.tableData, tableItem => {
            if (element.id === tableItem.id) {
              tableItem.planStartDate = element.planStartDate
              tableItem.planEndDate = element.planEndDate
              tableItem.planDuration = element.planDuration
            }
          })
        })
        this.bEdit = false
        var qsData = []
        this.findTree(this.tableData, (item) => {
          item.colorCt = false
          task.push(item)
          if (item.forceTime === 1 && item.childList) {
            var isExit = false
            this.findTree(item.childList, (childItem) => {
              if (childItem.planStartDate && childItem.planEndDate && (childItem.planStartDate < item.planStartDate || childItem.planEndDate > item.planEndDate)) {
                qsData.push(childItem)
                isExit = true
              }
            })
            if (isExit) {
              qsData.push(item)
            }
          }
        })
        qsData.forEach(item => {
          this.findTree(this.tableData, (element) => {
            if (item.id === element.id) {
              element.colorCt = true
            }
          })
        })
        this.oldTableData = JSON.parse(JSON.stringify(this.tableData))
        this.$emit('handleNewTasks', task)
      })
    },
    toCancel: function() {
      this.bEdit = false
      this.tableData = JSON.parse(JSON.stringify(this.oldTableData))
    }
  }

}
</script>

<style lang="scss" scoped>
#wbsDateCheckDiv{
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
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
/deep/.yellow{
  background:#ffffb9 !important;
}
/deep/.red{
  background:#ffb6b5 !important;
}
/deep/ .justcenter{
  text-align:
  center;
}
/deep/ .el-table tbody tr:hover>td {
}
</style>
