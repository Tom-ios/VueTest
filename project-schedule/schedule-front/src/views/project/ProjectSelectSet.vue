<template>
  <DragResizeWindow
    title="选择集"
    :visible.sync="winVisible"
    :w="520"
    :h="530"
    :x="x"
    :y="y"
    :center="true"
    :resizable="false"
    element-loading-text=""
    element-loading-spinner="a"
    element-loading-background="rgba(255, 255, 255, 0.8)"
  >
    <div>
      <el-input v-model="groupFigureName" style="width:320px;margin-right:10px;" clearable placeholder="名称" />
      <el-button type="primary" @enter.native="search" @click="search">查询</el-button>
      <el-button v-if="!isProjectover" type="primary" @click="addRecord">增加</el-button>
      <el-table
        ref="table"
        v-loading="loading"
        :data="tableData"
        :max-height="maxHeight"
        row-key="id"
        border
        header-cell-class-name="tableHeader"
        :cell-class-name="addClass"
        style="margin-top:10px"
        highlight-current-row
        @row-click="rowClick"
      >
        <el-table-column
          type="index"
          label="序号"
          :min-width="50"
        />

        <el-table-column
          v-for="(itemcol,index) in tablecolumn"
          :key="index"
          :prop="itemcol.value"
          :label="itemcol.title"
          :min-width="getWidth(index)"
          :show-overflow-tooltip="true"
        >
          <template slot-scope="scope">
            <span v-if="tablecolumn[index].value==='opt'">
              <el-button v-if="scope.row.projectOperate=='true' && scope.row.userOperate=='true'" type="text" @click="edit(scope.row)">编辑</el-button>
              <el-button v-if="scope.row.projectOperate=='true' && scope.row.userOperate=='true'" type="text" @click.stop="del(scope.row)">删除</el-button>

            </span>
            <span v-else> {{ scope.row[tablecolumn[index].value] }}</span>
          </template>
        </el-table-column>
      </el-table>
    </div>
  </DragResizeWindow>
</template>
<script>
import DragResizeWindow from '@/components/DragResizeWindow'
import { getSelectSetList, delSelectSet } from '@/api/ProjectSelectSet'
export default {
  components: {
    DragResizeWindow
  },
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    x: {
      type: Number,
      default: 0
    },
    y: {
      type: Number,
      default: 0
    },
    bim: {
      type: Object,
      default: function() { return {} }
    },
    isProjectover: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      winVisible: false,
      maxHeight: 400,
      loading: false,
      tableData: [],
      tablecolumn: [{
        title: '名称',
        value: 'groupFigureName'
      }, {
        title: '图元数量',
        value: 'groupFigureNum'
      }, {
        title: '描述',
        value: 'groupFigureDescription'
      }, {
        title: '创建人',
        value: 'userName'
      }, {
        title: '操作',
        value: 'opt'
      }],
      modeFlag: '',
      groupFigureName: '',
      curRowData: {}
    }
  },
  watch: {
    winVisible(v) {
      this.$emit('update:visible', v)
    },
    visible(v) {
      this.winVisible = v
      if (v) {
        this.curRowData = {}
        this.$refs.table.setCurrentRow()
        this.getSelectSetList()
      }
    },
    isProjectover(v) {
      if (!v) {
        this.tablecolumn = [{
          title: '名称',
          value: 'groupFigureName'
        }, {
          title: '图元数量',
          value: 'groupFigureNum'
        }, {
          title: '描述',
          value: 'groupFigureDescription'
        }, {
          title: '创建人',
          value: 'userName'
        }, {
          title: '操作',
          value: 'opt'
        }]
      } else {
        this.tablecolumn = [{
          title: '名称',
          value: 'groupFigureName'
        }, {
          title: '图元数量',
          value: 'groupFigureNum'
        }, {
          title: '描述',
          value: 'groupFigureDescription'
        }, {
          title: '创建人',
          value: 'userName'
        }]
      }
    }

  },
  methods: {
    search() {
      this.getSelectSetList()
    },
    rowClick(row, col, event) {
      this.$refs.table.setCurrentRow(row)
      this.curRowData = row
      this.dealModel()
    },
    dealModel() {
      if (this.curRowData && this.curRowData.groupFigureSubList) {
        var privitiveIds = ''
        this.curRowData.groupFigureSubList.forEach(element => {
          if (!privitiveIds) {
            privitiveIds = element.figureId
          } else {
            privitiveIds = privitiveIds + ',' + element.figureId
          }
        })
        if (this.curRowData.taskSection) {
          this.curRowData.taskSection.forEach(element => {
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
        this.bim.setSelectionState({ ids: tmpArr, selected: true, clear: true })
        this.$emit('setSelect', { moudule: 'selectSet', selectArr: tmpArr })
      }
    },
    getSelectSetList() {
      getSelectSetList({ projectId: this.$route.params.id, groupFigureName: this.groupFigureName }).then(res => {
        if (res) {
          res.forEach(element => {
            var privitiveIds = ''
            element.groupFigureSubList.forEach(element => {
              if (!privitiveIds) {
                privitiveIds = element.figureId
              } else {
                privitiveIds = privitiveIds + ',' + element.figureId
              }
            })
            var selectArr = []
            if (privitiveIds) {
              selectArr = privitiveIds.split(',')
            }
            element.groupFigureNum = selectArr.length
          })
        }
        this.tableData = res
      })
    },
    addRecord() {
      this.bim.setSelectionState({ ids: [], selected: true, clear: true })
      this.modeFlag = 'create'
      this.$emit('editSelectSet', { flag: this.modeFlag })
    },
    edit(row) {
      this.curRowData = row
      this.modeFlag = 'edit'
      this.$emit('editSelectSet', { flag: this.modeFlag, formData: this.curRowData })
    },
    del(row) {
      this.$confirm(`确定要删除该选择集么?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        delSelectSet(row.id).then(res => {
          this.getSelectSetList()
        })
      }).catch(() => {
      })
    },
    addClass({ row, columnIndex }) {
      return 'justcenter'
    },
    getWidth(index) {
      if (index === this.tablecolumn.length - 1) {
        return 100
      } else {
        return 80
      }
    }

  }
}
</script>
<style scoped lang="scss" >
/deep/ .justcenter{
  text-align: center
}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;
}
</style>
