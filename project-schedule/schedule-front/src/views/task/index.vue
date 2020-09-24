<template>
  <div ref="pageDiv" class="app-container">
    <el-row class="clearfix">
      <div ref="topDiv" class="table-wrap">
        <div slot="header">
          <span>作业进展</span>
        </div>
        <d2-crud
          id="taskProgressGrid"
          ref="d2Crud"
          edit-title="审批记录"
          :columns="columns"
          :data="data"
          :loading="loading"
          :row-handle="rowHandle"
          :options="options"
          @dialog-cancel="handleDialogCancel"
          @approvalHistory="handleApprovalHistory"
        />
      </div>
    </el-row>
    <GanttView ref="ganttView" :max-height="maxHeight" :is-edit="false" />
    <!-- <el-row class="clearfix">
      <el-col :span="12">
        <div class="table-wrap">
          <div slot="header" class="clearfix">
            <span>所有有效资源</span>
          </div>
          <TaskResource />
        </div>
      </el-col>
      <el-col :span="12"> -->
    <!-- <ResourceHistogram ref="progressModel" style="height:100%" @close="clickPaymentSumation" /> -->
    <!-- </el-col>
    </el-row> -->
    <el-dialog
      title="审批记录"
      center
      :visible.sync="showApprovalHistory"
      width="50%"
      @close="showApprovalHistory=false"
    >
      <!-- <div class="table-wrap"> -->
      <el-table
        :data="approvalHistoryData"
        border
        size="mini"
      >
        <el-table-column
          v-for="(col,index) in approvalHistoryColumns"
          :key="index"
          :prop="col.value"
          :label="col.title"
          :min-width="col.width?col.width:'100'"
        >
          <template slot-scope="scope">
            <span v-if="approvalHistoryColumns[index].type==='opt'">
              <el-button type="text" @click="toView(scope.row,scope.$index)">查看</el-button>
            </span>
            <span v-else-if="approvalHistoryColumns[index].type==='index'"> {{ scope.$index +1 }}</span>
            <span v-else> {{ scope.row[approvalHistoryColumns[index].value] }}</span>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        v-bind="pagination"
        class="table-pages"
        background
        @size-change="handleSizeChange"
        @current-change="paginationCurrentChange"
      />
      <!-- </div> -->
    </el-dialog>
  </div>
</template>

<script>
import GanttView from './GanttView'
// import TaskResource from './TaskResourceView'
// import ResourceHistogram from './ResourceHistogramView'
import { getRecentTaskEditList, getApprovalHistoryList } from '@/api/taskView'
export default {
  name: 'TaskDetail',
  components: {
    GanttView
    // TaskResource
    // ResourceHistogram
  },
  props: {
    rowHandle: {
      type: Object,
      default: function() {
        return {
          width: '150px',
          custom: [
            {
              text: '编辑',
              type: 'text',
              size: 'mini',
              emit: 'edit'
            },
            {
              text: '审批记录',
              type: 'text',
              size: 'mini',
              emit: 'approvalHistory'
            }
          ]
        }
      }
    }
  },
  data() {
    return {
      globalParam: { projectId: 2 },
      options: {
        border: true
      },
      showApprovalHistory: false,
      approvalHistoryColumns: [{
        title: '提交人', value: 'applyUser', width: 100 }, {
        title: '提交审批时间', value: 'submitTime', width: 100 }, {
        title: '提交说明', value: 'remark', width: 100 }, {
        title: '当前状态', value: 'state', width: 100 }, {
        title: '审批通过时间', value: 'applyTime', width: 100 }, {
        title: '操作', type: 'opt', width: 100 }
      ],
      approvalHistoryData: [{
        applyUser: 'jrodan',
        submitTime: '2020-01-01',
        remark: '...',
        state: '通过',
        completeTime: '2020-01-01 11:30:30'
      }],
      data: [{
        applyUser: 'kobe',
        applyTime: '2020-01-01',
        submitTime: '2020-01-01',
        state: '未提交'
      }],
      loading: false,
      indexRow: {
        title: '序号'
      },
      columns: [
        {
          title: '最近编制人员',
          key: 'applyUser'
        },
        {
          title: '最近编制时间',
          key: 'applyTime'
        },
        {
          title: '最近提交审批时间',
          key: 'submitTime'
        },
        {
          title: '当前状态',
          key: 'state'
        }
      ],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0,
        pageSizes: [10, 20, 50, 100],
        layout: 'total, sizes, prev, pager, next, jumper'
      },
      maxHeight: 400
    }
  },
  computed: {},
  mounted() {
    this.$nextTick(() => {
      this.maxHeight = this.$refs.pageDiv.clientHeight - this.$refs.topDiv.offsetHeight - 102
    })
  },
  created() {
    this.fetchData()
  },
  methods: {
    handleApprovalHistory(v) {
      this.$refs.d2Crud.showDialog({

      })
      this.fetchApprovalHistoryData()
      this.showApprovalHistory = true
    },
    fetchApprovalHistoryData() {
      getApprovalHistoryList({ ...this.globalParam,
        ...{ pageSize: this.pagination.pageSize,
          pageIndex: this.pagination.currentPage }}).then(res => {
        if (res.state === 'success') {
          this.approvalHistoryData = res.rows
          this.pagination.total = res.total
        } else {
          this.$message.error('查询审批历史失败')
        }
      })
    },
    handleDialogCancel(done) {
      done()
    },
    fetchData() {
      getRecentTaskEditList(this.globalParam).then(res => {
        if (res.state === 'success') {
          this.data = res.data
        } else {
          this.$message.error('查询作业进展失败')
        }
      })
    },
    paginationCurrentChange(currentPage) {
      this.pagination.currentPage = currentPage
      this.fetchApprovalHistoryData()
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val
      this.fetchApprovalHistoryData()
    }
  }
}
</script>

<style>
.app-container{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 0;
}
</style>
