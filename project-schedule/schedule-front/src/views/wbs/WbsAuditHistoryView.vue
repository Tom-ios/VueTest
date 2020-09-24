<template>
  <div ref="tablewrap" class="">
    <div class="table-header" style="margin-bottom:10px;">
      <span class="table-title"><strong>当前级别：</strong>{{ levelName }}</span>
    </div>
    <el-table
      ref="progressData"
      :data="progressData.data"
      border
      size="mini"
      max-height="460"
      height="460"
    >
      <el-table-column label="提交人" prop="applyUserName" />
      <el-table-column label="提交审批时间" prop="applyTime" />
      <el-table-column label="提交说明" prop="remark" />
      <el-table-column label="当前状态" prop="stateName" />
      <el-table-column label="审批通过时间" prop="completeTime" />
      <el-table-column label="审批人" prop="approvalUserName" />
      <!-- <el-table-column label="操作">
        <template slot-scope="scope">
          <el-link :underline="false" type="primary" @click="handleBpmImg(scope.$index, scope.row)">查看</el-link>
        </template>
      </el-table-column> -->
    </el-table>
    <el-pagination
      class="table-pages"
      background
      :page-sizes="[10, 20, 50, 100]"
      :page-size="progressData.pageSize"
      :current-page="progressData.pageNum"
      layout="total, sizes, prev, pager, next, jumper"
      :total="progressData.total"
      @current-change="handleCurrentChange"
      @size-change="handleSizeChange"
    />
  </div>
</template>

<script>
import { getWbsApprovePage, getWbsVerData } from '@/api/wbsPlan'
export default {
  name: 'WbsAuditHistory',
  components: {},
  props: {
    wbsLevelId: {
      type: String,
      default: '1'
    },
    levelName: {
      type: String,
      default: '一级计划'
    }
  },
  data() {
    return {

      loading: false,
      progressData: {
        pageNum: 1,
        pageSize: 10,
        total: 20,
        data: []
      }
    }
  },
  computed: {},
  created() {
    this.getPageList()
  },
  methods: {
    getPageList(pageNum) {
      this.loading = true
      var requestData = {
        pageSize: this.progressData.pageSize,
        pageIndex: this.progressData.pageNum,
        wbsLevelId: this.wbsLevelId,
        type: '0'
      }// type=1
      getWbsApprovePage(requestData).then(res => {
        this.loading = false
        if (res && res.code === '200') {
          this.progressData.total = res.total
          this.$set(this.progressData, 'data', res.rows)
        }
      })
    },

    handleCurrentChange(val) {
      this.progressData.pageNum = val
      this.getPageList(val)
    },
    handleSizeChange(val) {
      this.progressData.pageSize = val
      this.getPageList()
    },
    handleBpmImg(index, row) {
      var requestData = {
        versionId: row.id,
        type: 1
      }
      getWbsVerData(requestData).then(res => {
        this.loading = false
        if (res && res.code === '200') {

          // this.$set(this.progressData, 'data', res.data)
        }
      })
    }
  }
}
</script>
