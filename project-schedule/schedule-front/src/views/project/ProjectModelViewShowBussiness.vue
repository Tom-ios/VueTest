<template>
  <DragResizeWindow
    :visible.sync="winVisible"
    :w="300"
    :h="530"
    :x="x"
    :y="y"
    element-loading-text=""
    element-loading-spinner="a"
    element-loading-background="rgba(255, 255, 255, 0.8)"
  >
    <div slot="header" class="progressHeader">
      <span style="position:relative;top:1px">业务信息</span>
      <i class="el-icon-close closeBtns" @click="close" />
    </div>
    <div>
      <el-tabs
        v-model="activeName"
        class="mt-10"
        type="card"
        @tab-click="handleClick"
      >

        <el-tab-pane label="任务" name="taskView">
          <el-table
            ref="treeTable"
            v-loading="loading"
            highlight-current-row
            :data="taskData"
            :max-height="maxHeight"
            row-key="id"
            :empty-text="emptyText"
            border
            default-expand-all
            :indent="20"
            :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
            header-cell-class-name="tableHeader"
            :cell-class-name="addClass"
          >
            <el-table-column
              type="index"
              label="序号"
              fixed
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
                <span v-if="tablecolumn[index].value==='state'"> {{ scope.row[tablecolumn[index].value] }}</span>
                <span v-else> {{ scope.row[tablecolumn[index].value] }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="质量工艺" name="quality">
          <el-table
            ref="treeTable"
            v-loading="loading"
            highlight-current-row
            :data="qualityData"
            :max-height="maxHeight"
            row-key="id"
            :empty-text="emptyText"
            border
            default-expand-all
            :indent="20"
            :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
            header-cell-class-name="tableHeader"
            :cell-class-name="addClass"
          >
            <el-table-column
              type="index"
              label="序号"
              fixed
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
                <span v-if="tablecolumn[index].value==='state'"> {{ scope.row[tablecolumn[index].value] }}</span>
                <span v-else> {{ scope.row[tablecolumn[index].value] }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
        <el-tab-pane label="安全风险点" name="safe">
          <el-table
            ref="treeTable"
            v-loading="loading"
            highlight-current-row
            :data="safeData"
            :max-height="maxHeight"
            row-key="id"
            :empty-text="emptyText"
            border
            default-expand-all
            :indent="20"
            :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
            header-cell-class-name="tableHeader"
            :cell-class-name="addClass"
          >
            <el-table-column
              type="index"
              label="序号"
              fixed
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
                <span v-if="tablecolumn[index].value==='state'"> {{ scope.row[tablecolumn[index].value] }}</span>
                <span v-else> {{ scope.row[tablecolumn[index].value] }}</span>
              </template>
            </el-table-column>
          </el-table>
        </el-tab-pane>
      </el-tabs>
    </div>
  </DragResizeWindow>
</template>
<script>
import DragResizeWindow from '@/components/DragResizeWindow'
import { getTaskByPrimitive, getQualityOrSafeFomrPrimitive } from '@/api/projectView'
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
    selPrimitive: {
      type: Array,
      default: function() { return [] }
    }
  },
  data() {
    return {
      qualityData: [],
      safeData: [],
      winVisible: false,
      maxHeight: 300,
      loading: false,
      taskData: [],

      emptyText: '请单选图元',
      activeName: 'taskView'
    }
  },
  computed: {
    tablecolumn() {
      return [{
        title: '任务名称',
        value: this.activeName === 'taskView' ? 'taskName' : 'name'
      }
      ]
    }
  },
  watch: {
    selPrimitive: {
      handler(newArr) {
        if (newArr.length === 0) {
          this.emptyText = '请单选图元'
          this.taskData = []
        } else if (newArr.length === 1) {
          this.emptyText = '暂无数据'
          this.getTask()
        } else {
          this.emptyText = '请单选图元'
          this.taskData = []
        }
      }
    },
    winVisible(v) {
      this.$emit('update:visible', v)
    },
    visible(v) {
      this.winVisible = v
    }
  },
  methods: {
    handleClick() {
      this.getTask()
    },
    close() {
      this.winVisible = false
    },
    addClass({ row, columnIndex }) {
      if (columnIndex !== 1) {
        if (row.color && row.color === 'red' && this.tablecolumn[columnIndex - 1] && this.tablecolumn[columnIndex - 1].value === 'state') {
          return 'redBgColor'
        }
        return 'justcenter'
      } else {
        return ''
      }
    },
    getWidth(index) {
      if (index === 0) {
        return 220
      } else if (index === 1) {
        return 80
      } else if (index === 2) {
        return 100
      }
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    getTask() {
      this.loading = true
      var requestData = {}
      if (this.activeName === 'taskView') {
        requestData = {
          projectId: this.$route.params.id,
          taskModelId: this.selPrimitive.length > 0 ? this.selPrimitive[0].id : ''
        }
        getTaskByPrimitive(requestData).then(res => {
          this.loading = false
          const data = res.data || []
          if (data.length > 0) {
            this.findTree(data, (item) => {
              if (item.state && item.state.indexOf('延迟') > -1) {
                item.color = 'red'
              }
            })

            this.taskData = data
          } else {
            this.taskData = []
          }
        }
        ).catch(() => {
          this.loading = false
        })
      } else {
        requestData = {
          projectId: this.$route.params.id,
          figureId: this.selPrimitive.length > 0 ? this.selPrimitive[0].id : ''
        }
        if (this.activeName === 'quality') {
          requestData.type = '1'
        } else {
          requestData.type = '2'
        }
        getQualityOrSafeFomrPrimitive(requestData).then(res => {
          if (this.activeName === 'quality') {
            this.qualityData = res || []
          } else {
            this.safeData = res || []
          }
        }).finally(() => {
          this.loading = false
        })
      }
    }
  }
}
</script>
<style scoped lang="scss">
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
 /deep/ .el-table td.redBgColor{
  background: red;
  text-align: center;
}
.closeBtns{
  float: right;
  line-height: 35px;
  padding: 0 0px;
  cursor: pointer;
}
.progressHeader {
  border: 1px solid #EBEEF5;
  font-size:14px;
  background: #f5f7fa;
  line-height: 30px;
  margin-top:-35px;
  padding:0px 10px;
}

</style>
