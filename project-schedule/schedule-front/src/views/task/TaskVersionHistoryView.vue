<template>
  <div>
    <el-form :model="searchData" size="mini" class="search-form" label-width="auto">
      <el-row :gutter="20">
        <el-col :span="5">
          <el-form-item label="提交人：">
            <el-input v-model="searchData.applyUser" clearable placeholder="" />
          </el-form-item>
        </el-col>
        <el-col :span="8">
          <el-form-item label="提交时间：">
            <el-date-picker v-model="applyTime" value-format="yyyy-MM-dd HH:mm:ss" type="daterange" range-separator="至" start-placeholder="" end-placeholder="" />
          </el-form-item>
        </el-col>
        <el-col :span="5">
          <el-form-item label="说明：">
            <el-input v-model="searchData.remark" placeholder="" clearable />
          </el-form-item>
        </el-col>
        <el-col :span="5">
          <el-button type="primary" size="mini" icon="el-icon-search" @click="fetchData">查询</el-button>
        </el-col>
      </el-row>
    </el-form>

    <d2-crud
      id="taskVersionHistoryGrid"
      ref="d2Crud"
      class="d2-p-0"
      :options="options"
      :columns="columns"
      :data="data"
      :loading="loading"
      :row-handle="rowHandle"
      :pagination="pagination"
      @version-detail-view="handleToVersionDetailView"
      @version-recover="handleVersionRecover"
      @pagination-current-change="paginationCurrentChange"
      @pagination-size-change="handleSizeChange"
    />
  </div>
</template>

<script>
import { getTaskVersionHistoryList as getTaskVersionList } from '@/api/taskView'
import { taskVersionRecover } from '@/api/taskEdit'
export default {
  name: 'TaskVersionHistory',
  components: {},
  props: {
    rowHandle: {
      type: Object,
      default: function() {
        return {
          width: '150px',
          custom: [
            {
              text: '查看',
              type: 'text',
              size: 'mini',
              emit: 'version-detail-view'
            }
          ],
          fixed: 'right'
        }
      }
    },
    isEdit: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      // globalParam: { projectId: 2 },
      options: {
        border: true,
        maxHeight: 460,
        height: 460
      },
      applyTime: [],
      searchData: {
        applyUser: '',
        remark: '',
        startApplyTime: '',
        endApplyTime: ''
      },
      loading: false,
      data: [
        {
          // versionNo: '1',
          // applyUser: 'paul',
          // applyTime: '2020-01-01',
          // remark: 'xxx'
        }
      ],
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0,
        pageSizes: [10, 20, 50, 100],
        layout: 'total, sizes, prev, pager, next, jumper',
        background: true
      },
      columns: [
        {
          title: '作业版本号',
          key: 'taskVersionNo'
        },
        {
          title: '提交人',
          key: 'applyUserName'
        },
        {
          title: '提交时间',
          key: 'applyTime'
        },
        {
          title: '备注',
          key: 'remark'
        },
        {
          title: '基线版本号',
          key: 'baseNo'
        },
        {
          title: 'WBS版本号',
          key: 'versionNo'
        }
      ]
    }
  },
  computed: {},
  created() { this.fetchData() },
  methods: {
    paginationCurrentChange(currentPage) {
      this.pagination.currentPage = currentPage
      this.fetchData()
    },
    fetchData() {
      getTaskVersionList({ ...{ projectId: this.$route.params.id, pageSize: this.pagination.pageSize, pageIndex: this.pagination.currentPage, type: 1 }, ...this.searchData, ...{ startApplyTime: this.applyTime ? this.applyTime[0] : null, endApplyTime: this.applyTime ? this.applyTime[1] : null }}).then(res => {
        if (res.state === 'success') {
          this.data = res.rows
          this.pagination.total = res.total
        } else {
          this.$message.error('查询作业历史版本失败')
        }
      })
    },
    handleVersionRecover({ index, row }) {
      taskVersionRecover({ projectId: row.projectId, versionId: row.id }).then(res => {
        if (res.state === 'success') {
          this.$emit('after-version-recover')
          this.$message.success('版本复原成功')
        } else {
          this.$message.error('版本复原失败')
        }
      })
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val
      this.fetchData()
    },
    handleToVersionDetailView({ index, row }) {
      // this.$router.push(`/task/versionDetail/${this.$route.params.id}`)
      this.$emit('to-task-version-detail', { index, row })
    }
  }
}
</script>
<style lang="scss" scoped>
/deep/ .d2-crud-body .d2-crud{
  padding: 0px;
}
/deep/ .el-date-editor--daterange.el-input__inner {
    width: 260px;
}
/deep/ .el-date-editor .el-range-separator {
    width: 8%;
    color: #303133;
}
</style>
