<template>
  <div ref="main">
    <el-row style="border: 1px solid #EBEEF5;padding:10px 0px;font-size:14px;color:#606266" class="clearfix">
      <div style="float:left;">
        <span class="ml-10"> 名称: </span>
        <el-input v-model="taskName" placeholder="" size="small" style="width: 100px;" clearable @keyup.enter.native="search" />
        <span style="margin-left:10px;"> 关联模型:</span>
        <el-select v-model="query.linkModel" placeholder="全部" clearable style="width:90px">
          <el-option v-for="item in modelArr" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
        <el-button type="primary" class="ml-10" style="bottom:10px;position:absolute" @click="search">查询</el-button>
      </div>
    </el-row>
    <div class="mt-10">
      <el-table
        ref="treeTable"
        v-loading="loading"
        highlight-current-row
        :data="tableData"
        :max-height="maxHeight"
        row-key="id"
        empty-text="暂无数据"
        border
        default-expand-all
        :indent="20"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        :cell-class-name="addClass"
        header-cell-class-name="tableHeader"
        @row-click="rowClick"
      >
        <el-table-column
          type="index"
          label="序号"
          width="48px"
          fixed
        />

        <el-table-column
          v-for="(itemcol,index) in tablecolumn"
          :key="index"
          :prop="itemcol.value"
          :label="itemcol.title"
          :fixed="getFixed(index)"
          :min-width="getWidth(index)"
          :show-overflow-tooltip="true"
        >
          <template slot-scope="scope">
            <div v-if="tablecolumn[index].value==='op'">
              <el-button size="mini" type="text" @click.stop="connectModel(scope.row,index)">关联模型</el-button>
              <el-button v-if="scope.row.linkModel==='是'" type="text" size="mini" @click="cancelConnectModel(scope.row,index)">取消关联</el-button>
            </div>
            <span v-else>
              <li v-if="scope.row.linkModel==='是'" style="color:#409EFF" class="el-icon-paperclip" />
              {{ scope.row[tablecolumn[index].value] }}</span>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </div>
</template>
<script>
import { getPlanList, cancelTaskModel, connectTaskModel, getqualityOrSafe, connectQualityOrSafeModel, cancelFlowSegModelModel } from '@/api/progressManage'
import { getFrame } from '@/api/projectFrame'
export default {
  props: {
    bim: {
      type: Object,
      default: function() { return {} }
    },
    isManager: {
      type: Boolean,
      default: true
    },
    isProjectover: {
      type: Boolean,
      default: false
    },
    activeName: {
      type: String,
      default: 'taskView'
    },
    showProgressState: {
      type: Boolean,
      default: false
    },
    justShowFlowConnectModel: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      maxHeight: 316,
      treeArr: [],
      loading: false,
      saveLoading: false,
      taskName: '',
      query: {
        linkModel: ''
      },
      importLoading: false,
      fileInfo: {
        name: '',
        importType: '1'
      },
      modelArr: [{
        'label': '是', value: '1' }, {
        'label': '否', value: '0' }],
      workStates: [{
        'title': '未开始', key: '2' }, {
        'title': '进行中', key: '3' }, {
        'title': '已完成', key: '4' }, {
        'title': '提前', key: '2' }, {
        'title': '正常', key: '3' }, {
        'title': '延迟', key: '4' }],
      taskArr: [{
        'title': '未开始', key: '2' }, {
        'title': '进行中', key: '3' }, {
        'title': '已完成', key: '4' }],
      stateArr: [{
        'title': '提前', key: '2' }, {
        'title': '正常', key: '3' }, {
        'title': '延迟', key: '4' }],
      tableData: [],
      originTableData: [],
      tablecolumn: [],
      // 选择人员data
      data: [

      ],
      connectTaskInfo: null,
      clickTaskInfo: {},
      mapId: {},
      treeData: []

    }
  },
  watch: {
    query: {
      handler(newValue, oldValue) {
        this.getTreeList()
      },
      deep: true,
      immediate: true
    },
    isManager(v) {
      this.setTableColumn()
    },
    isProjectover(v) {
      this.setTableColumn()
    },
    winVisible(v) {
      this.$emit('update:visible', v)
    },
    visible(v) {
      this.winVisible = v
    },
    showProgressState(v) {
      this.setModel()
    },
    activeName(newValue, oldValue) {
      // 去掉当前高亮
      if (this.clickTaskInfo) {
        // 为了不用 setSelectionState：false 改了api  所以全部清除
        this.bim.setSelectionState({ ids: [], selected: true, clear: true })
      }
      // 清空选中
      this.getTreeList()
      this.clickTaskInfo = null
    },
    justShowFlowConnectModel(v) {
      this.flowMetaOpt()
    }
  },
  mounted() {
    this.setTableColumn()
  },
  activated() {
    this.getTreeList()
  },
  methods: {
    addClass({ row, columnIndex }) {
      if (columnIndex !== 1) {
        return 'justcenter'
      } else {
        return ''
      }
    },
    setModel() {
      if (this.showProgressState) {
        for (var key in this.mapId) {
          if (this.showProgressState) {
            if (this.mapId[key].indexOf('延迟') > -1) {
              this.bim.setColor({ ids: [parseInt(key)], color: '#FF0000' })
              continue
            } else if (this.mapId[key].indexOf('进行中') > -1) {
              this.bim.setColor({ ids: [parseInt(key)], color: '#C7EDCC' })
              continue
            } else if (this.mapId[key].indexOf('未开始') > -1) {
              this.bim.setColor({ ids: [parseInt(key)], color: '#D7D7D7' })
              continue
            } else if (this.mapId[key].indexOf('已完成') > -1) {
              this.bim.setColor({ ids: [parseInt(key)], color: '#02830F' })
              continue
            }
          }
        }
        var otherArrId = this.getOtherIds()
        otherArrId = otherArrId.map(function(e) { return parseInt(e) })
        this.bim.setColor({ ids: otherArrId, color: '#555555' })
      } else {
        this.$emit('setObjColors')
      }
    },
    getOtherIds() {
      const allIds = []
      for (const oid of this.bim.getAllIds()) {
        var bExit = false
        for (var id in this.mapId) {
          if (id.indexOf(oid) > -1) {
            bExit = true
          }
        }
        if (!bExit) {
          allIds.push(oid)
        }
      }
      return allIds
    },
    getSectionSelectArr() {
      if (this.clickTaskInfo && this.clickTaskInfo.taskModel && this.clickTaskInfo.taskModel) {
        var privitiveIds = ''
        this.clickTaskInfo.taskModel.forEach(element => {
          if (!privitiveIds) {
            privitiveIds = element.figureId
          } else {
            privitiveIds = privitiveIds + ',' + element.figureId
          }
        })
        if (this.clickTaskInfo.taskSection) {
          this.clickTaskInfo.taskSection.forEach(element => {
            if (!element.figureId) {
              return
            }
            if (!privitiveIds) {
              privitiveIds = element.figureId
            } else {
              privitiveIds = privitiveIds + ',' + element.figureId
            }
          })
        }
        var selectArr = []
        if (privitiveIds) {
          selectArr = privitiveIds.split(',')
        }
        var tmpArr = []
        selectArr.forEach(element => {
          tmpArr.push(parseInt(element))
        })
        return tmpArr
      }
      return []
    },
    setSelctMata(select) {
      if (this.clickTaskInfo && this.clickTaskInfo.taskModel && this.clickTaskInfo.taskModel) {
        var tmpArr = this.getSectionSelectArr()
        this.bim.setSelectionState({ ids: tmpArr, selected: select, clear: true })
      } else {
        this.bim.setSelectionState({ ids: [], selected: true, clear: true })
      }
    },
    getAllIds() {
      return this.bim.getAllIds()
    },

    setTableColumn() {
      if (this.isManager && !this.isProjectover) {
        this.query.managerment = ''
        this.tablecolumn = [{
          title: '任务名称',
          value: 'taskName'
        }, {
          title: '操作',
          value: 'op'
        }
        ]
      } else {
        if (!this.isManager) {
          this.query.managerment = this.$store.state.user.userId
        }
        this.tablecolumn = [{
          title: '任务名称',
          value: 'taskName'
        }]
      }
    },
    filterModel(arr, allArr) {
      var result = []
      allArr.forEach(aId => {
        var bExit = false
        arr.forEach(sId => {
          if (aId === sId) {
            bExit = true
          }
        })
        if (!bExit) {
          result.push(aId)
        }
      })
      return result
    },
    connectModel(rowData, index) {
      this.$refs.treeTable.setCurrentRow(rowData)
      this.clickTaskInfo = rowData
      if (this.activeName === 'quality' || this.activeName === 'safe') {
        this.flowMetaOpt(rowData)
      } else {
        this.setSelctMata(true)
        // 不可选择
        var privitiveIds = ''
        if (this.clickTaskInfo && this.clickTaskInfo.taskSection) {
          this.clickTaskInfo.taskSection.forEach(element => {
            if (!privitiveIds) {
              privitiveIds = element.figureId
            } else {
              privitiveIds = privitiveIds + ',' + element.figureId
            }
          })
        }
        var selectArr = []
        if (privitiveIds) {
          selectArr = privitiveIds.split(',')
        }
        var tmpArr = []
        selectArr.forEach(element => {
          tmpArr.push(parseInt(element))
        })
        this.bim.setPickDisabledIds(tmpArr)
        // 任务关联了流水段 流水段中的不需要选中 但是如果先选中这个图元 后关联流水段（流水段中有这个图元）
        var curSelIds = this.getSectionSelectArr()
        var trueSel = this.filterModel(tmpArr, curSelIds)
        this.bim.setSelectionState({ ids: trueSel, selected: true, clear: true })
        this.bim.setColor({ ids: tmpArr, color: '#f6922d' })
      }
      this.connectTaskInfo = { ...rowData }
      this.$emit('connectModelChange', true)
    },
    flowMetaOpt(rowData) {
      this.reSetModel()
      if (!rowData) {
        rowData = this.clickTaskInfo
      }
      if (rowData) {
        var arr = []
        if (rowData.allSecTionModel) {
          rowData.allSecTionModel.forEach(element => {
            arr.push(element.id)
          })
        }
        this.setSelctMata(true)
        // var hideModel = this.filterModel(arr, this.getAllIds())
        // // 流水段只能关联流水段下的图元 //只显示关联流水段下的图元 //设置隐藏的时候会取消图元的高亮
        // if (this.justShowFlowConnectModel) {
        //   this.bim.surfer.setVisibility({ ids: hideModel, visible: false })
        //   this.setSelctMata(true)
        // } else {
        // //  '其他的图元不能选择并且半透明'
        //   this.bim.surfer.setPickDisabledIds(hideModel)
        //   this.bim.surfer.setColor({ ids: hideModel, color: '#ffffff4c' })
        //   this.setSelctMata(true)
        // }
      }
    },
    reSetModel() {
      this.$emit('setObjColors')
      this.bim.setVisibility({ ids: this.getAllIds(), visible: true })
      this.bim.setPickDisabledIds([])
    },
    saveTaskConnectModel(ModelArr) {
      if (ModelArr.length === 0) {
        this.$alert('请选择关联的图元')
        return
      }
      var requestData = null
      if (this.activeName === 'taskView') {
        requestData = { taskId: this.connectTaskInfo.id, bimTaskModels: [] }
        var bimTaskModels = []
        ModelArr.forEach(element => {
          var dict = {
            projectId: this.$route.params.id,
            taskId: this.connectTaskInfo.id,
            figureId: element.figureId.join(','),
            projectModelId: element.projectModelId
          }
          bimTaskModels.push(dict)
        })
        requestData.bimTaskModels = bimTaskModels
        connectTaskModel(requestData).then((res) => {
          this.getTreeList()
        }).catch(() => {
        }).finally(() => {
          this.reSetModel()
          this.$emit('connectModelChange', false)
        })
      } else if (this.activeName === 'quality' || this.activeName === 'safe') {
        requestData = []
        ModelArr.forEach(element => {
          var dict = {
            id: '',
            taskId: this.connectTaskInfo.id,
            figureId: element.figureId.join(','),
            projectModelId: element.projectModelId,
            projectId: this.$route.params.id
          }
          requestData.push(dict)
        })
        connectQualityOrSafeModel(requestData).then((res) => {
          this.getTreeList()
        }).catch(() => {
        }).finally(() => {
          this.reSetModel()
          this.$emit('connectModelChange', false)
        })
      }
    },
    cancelConnectModel(rowData, index) {
      var text = ''
      if (this.activeName === 'taskView') {
        text = '取消 "任务" 与 所有图元 的关联，确定要取消吗？确定后，取消任务与所有图元的关联'
      } else if (this.activeName === 'quality') {
        text = '取消关联 "图元" 的同时，会取消 "标准工艺" 与 "任务" 的关联，确定要取消吗？确定后，取消标准工艺与所有图元和与所有任务的关联'
      } else if (this.activeName === 'safe') {
        text = '取消关联 "图元" 的同时，会取消 "风险点" 与 "任务" 的关联，确定要取消吗？确定后，取消风险点与所有图元和与所有任务的关联'
      }
      this.$confirm(text).then(_ => {
        if (this.activeName === 'taskView') {
          cancelTaskModel(rowData.id).then((res) => {
            this.getTreeList()
            this.reSetModel()
          })
        } else {
          cancelFlowSegModelModel(rowData.id).then(res => {
            this.getTreeList()
            this.reSetModel()
          })
        }
      })
        .catch(_ => {

        })
    },

    getPickerOption(rowData, colIndex, rowIndex) {
      const self = this
      return {
        disabledDate(time) {
          if (self.tablecolumn[colIndex].value === 'actualStartTime') {
            if (rowData.actualEndTime) {
              return new Date(rowData.actualEndTime).getTime() < time.getTime()
            }
          } else if (self.tablecolumn[colIndex].value === 'actualEndTime') {
            if (rowData.actualStartTime) {
              return (new Date(rowData.actualStartTime).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
            }
          }
          // return time
        }
      }
    },
    // date1:小日期 date2:大日期
    DateMinus(date1, date2) {
      var sdate = new Date(date1)
      var now = new Date(date2)
      var days = now.getTime() - sdate.getTime()
      var day = parseInt(days / (1000 * 60 * 60 * 24))
      return day + 1
    },
    datePickChange(rowData, index) {
      var duration = ''
      this.getPickerOption(rowData, index)
      if (rowData.actualStartTime && rowData.actualEndTime) {
        duration = this.DateMinus(rowData.actualStartTime, rowData.actualEndTime)
      } else {
        duration = ''
      }
      this.$set(rowData, 'actualDuration', duration)
      this.$set(rowData, 'update', true)
    },
    rowClick(row, col, event) {
      // if (row.leafNode === 0) {
      //   this.$refs.treeTable.setCurrentRow()
      //   return
      // }
      this.$refs.treeTable.setCurrentRow(row)
      this.clickTaskInfo = row
      this.setSelctMata(true)
    },
    clearManage(rowData, index) {
      this.findTree(this.tableData, (item) => {
        if (rowData.id === item.id) {
          this.$set(item, 'managerment', '')
          this.$set(item, 'managermentName', '')
          this.$set(item, 'clear', true)
        }
      })
    },
    handleSel(selection) {
      this.findTree(this.tableData, (item) => {
        if (selection.id === item.id) {
          this.$set(item, 'update', true)
        }
      })
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    getTreeList() {
      var requestData = {}
      if (this.activeName === 'taskView') {
        getFrame({ projectId: this.$route.params.id }).then(data => {
          if (data && data.content) {
            this.treeData = JSON.parse(data.content)
          } else {
            this.treeData = []
          }
          requestData = {
            projectId: this.$route.params.id,
            taskName: this.taskName ? this.taskName.trim() : '',
            linkModel: this.query.linkModel
          }
          this.loading = true
          getPlanList(requestData).then(res => {
            this.loading = false
            this.mapId = {}
            this.treeArr = []
            if (res) {
              this.findTree(res, (item) => {
                if (item.linkModel === 1) {
                  item.linkModel = '是'
                } else {
                  item.linkModel = '否'
                }
                this.treeArr.push(item)
                if (item.state1 && item.state2) {
                  item.state = item.state1 + '(' + item.state2 + ')'
                }

                if (item.taskModel) {
                  item.taskModel.forEach(element => {
                    var arr = []
                    if (element.figureId) {
                      arr = element.figureId.split(',')
                    }
                    arr.forEach(id => {
                      var bHas = false
                      for (var key in this.mapId) {
                        if (key === id) {
                          bHas = true
                          this.mapId[id] = this.mapId[id] + ',' + item.state
                        }
                      }
                      if (!bHas) {
                        this.mapId[id] = item.state
                      }
                    })
                  })
                }
                if (item.taskSection) {
                  item.taskSection.forEach(element => {
                    var arr = []
                    if (element.figureId) {
                      arr = element.figureId.split(',')
                    }
                    arr.forEach(id => {
                      var bHas = false
                      for (var key in this.mapId) {
                        if (key === id) {
                          bHas = true
                          this.mapId[id] = this.mapId[id] + ',' + item.state
                        }
                      }
                      if (!bHas) {
                        this.mapId[id] = item.state
                      }
                    })
                  })
                }
              })
              this.tableData = res
              this.originTableData = JSON.parse(JSON.stringify(this.tableData))
              if (this.showProgressState) {
                this.setModel()
              }
            } else {
              this.tableData = []
              this.originTableData = JSON.parse(JSON.stringify(this.tableData))
            }
          }
          ).catch(() => {
            this.loading = false
          })
        })
      } else {
        requestData = {
          projectId: this.$route.params.id,
          businessName: this.taskName ? this.taskName.trim() : '',
          associate: this.query.linkModel }
        if (this.activeName === 'quality') {
          requestData.type = '1'
        } else {
          requestData.type = '2'
        }
        getFrame({ projectId: this.$route.params.id }).then(data => {
          if (data && data.content) {
            this.treeData = JSON.parse(data.content)
          }
          getqualityOrSafe(requestData).then(res => {
            this.treeArr = []
            if (res) {
              this.tableData = res
              this.findTree(res, element => {
                this.treeArr.push(element)
                element.taskName = element.name
                element.linkModel = element.associate ? '是' : '否'
                if (element.templateIds) {
                  element.linkClass = !!element.templateIds
                }
                element.taskModel = element.QualitySafetyModelList
                var sectionModel = []
                if (element.QualitySafetyTaskList) {
                  element.QualitySafetyTaskList.forEach(oneItem => {
                    if (oneItem.modelFigures) {
                      var dict = {}
                      dict['projectModelId'] = oneItem.modelFigures.split('*')[0]
                      dict['figureId'] = oneItem.modelFigures.split('*')[1]
                      sectionModel.push(dict)
                    }
                  })
                  element.taskSection = sectionModel
                  console
                }
              })
            } else {
              this.tableData = []
            }
          })
        })
      }
    },
    getFixed(index) {
      if (index < 1) {
        return 'left'
      } else if (index > this.tablecolumn.length - 2) {
        return 'right'
      } else {
        return false
      }
    },
    getWidth(index) {
      if (index === 0) {
        return 200
      } else if (index === this.tablecolumn.length - 1 && this.isManager) {
        return 140
      } else {
        return 100
      }
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
    search() {
      this.getTreeList()
    }

  }

}
</script>

<style lang="scss" scoped>

.progressHeader {
  border: 1px solid #EBEEF5;
  font-size:14px;
  background: #f5f7fa;
  height:30px;
  line-height: 30px;
  margin-top:-2px;
  padding:0px 10px
}
.ml-10 {
  margin-left:10px;
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
.el-button {
  height: 32px
}

.el-checkbox{
  display: block;
  font-weight:normal;
}
/deep/ .readonly{
  background: #e5e6e7 !important;
}
/deep/ .justcenter{
text-align: center
}
/deep/ .el-checkbox__label{
  font-weight:normal;
}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
/deep/ .el-button+.el-button {
    margin-left: 0px;
}
</style>
