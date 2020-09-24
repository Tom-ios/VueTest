<template>
  <div class="table-wrap">
    <el-table
      ref="taskTreeGrid"
      :data="tableData"
      row-key="id"
      size="mini"
      border
      default-expand-all
      :tree-props="{children: 'childList', hasChildren: 'hasChildren'}"
      :row-class-name="tableRowClassName"
      @selection-change="handleSelectionChange"
    >
      <el-table-column
        type="selection"
        :selectable="selectable"
      />
      <el-table-column
        prop="wbsCode"
        label="代码"
      />
      <el-table-column
        prop="wbsName"
        label="名称"
      />
      <!--   <el-table-column
        prop="status"
        label="状态"
      /> -->
    </el-table>
  </div>
</template>

<script>
export default {
  props: {
    taskTreeData: {
      type: Array,
      default: () => []
    },
    logicGridData: {
      type: Array,
      default: () => []
    },
    currentTask: {
      type: Object,
      default: () => ({})
    }
  },
  data() {
    return {
      tableData: [],
      bData: false,
      bCurTask: false
    }
  },
  watch: {
    taskTreeData: {
      handler(newValue, oldValue) {
        this.bData = true
        this.initData()
      },
      deep: true,
      immediate: true
    },
    currentTask: {
      handler(newValue, oldValue) {
        this.bCurTask = true
        this.initData()
      },
      deep: true,
      immediate: true
    },
    logicGridData: {
      handler(newValue, oldValue) {
        if (this.$refs.taskTreeGrid) {
          this.$refs.taskTreeGrid.clearSelection()
        }
      }
      // deep: true,
      // immediate: true
    }
  },
  methods: {
    initData() {
      if (this.bData && this.bCurTask) {
        this.tableData = this.taskTreeData
      }
    },
    handleSelectionChange(selection) {
      this.$emit('multiple-selection', selection)
      for (let i = 0, len = selection.length; i < len; i++) {
        /* if (selection[i].children) {
        } */
      }
    },
    selectable(row, index) {
      if (row.taskMold === '0' || row.taskType === '0') {
        return false
      }
      if (this.currentTask && this.currentTask.id === row.id) {
        return false
      }
      return !this.logicGridData.some(function(item) {
        return item.taskNextId === row.id || item.taskPreId === row.id
      })
    },
    tableRowClassName({ row, rowIndex }) {
      if (row.taskMold === '0') {
        return 'wbs-row'
      }
    }
  }
}
</script>
<style lang="scss" scoped>
 /deep/ .el-table .wbs-row {
    background:#DCDFE6;
  }
.table-wrap{
  width: 100%;
  height: 100%;
  position: absolute;
}
/deep/ .el-table{
  height: 100%;
  overflow-y: auto;
}

/deep/ .el-table::before {
  z-index: auto;
 }
 /deep/ .el-table__header-wrapper  .el-checkbox{//找到表头那一行，然后把里面的复选框隐藏掉
	display:none
}
</style>
