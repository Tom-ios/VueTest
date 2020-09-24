<template>
  <div ref="tablewrap" class="clearfix">
    <el-form :inline="true" :model="planform" size="mini" class="demo-form-inline">

      <el-form-item label="提交人">
        <el-input v-model="planform.applyUser" placeholder="提交人" style="width:85px;" clearable />
      </el-form-item>

      <el-form-item label="提交时间">
        <el-date-picker v-model="planform.applyTime" type="daterange" style="width:340px;" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" />
      </el-form-item>

      <el-form-item label="说明">
        <el-input v-model="planform.remark" placeholder="说明" style="width:120px;" clearable />
      </el-form-item>

      <el-button type="primary" size="mini" icon="el-icon-search" @click="listQuery()">查询</el-button>

    </el-form>
    <!-- 表格 -->
    <div ref="tablewrap" class="clearfix">
      <el-table
        ref="progressData"
        :data="progressData.data"
        border
        size="mini"
        max-height="460"
        height="460"
      >
        <el-table-column label="wbs版本号" prop="versionNo" />
        <!-- <el-table-column label="级别" prop="level" width="100" /> -->
        <el-table-column label="提交人" prop="applyUserName" />
        <el-table-column label="提交时间" prop="applyTime" />
        <el-table-column label="提交说明" prop="remark" />
        <el-table-column label="基线版本号" prop="baseNo" />
        <el-table-column label="作业版本号" prop="taskVersionNo" />
        <el-table-column label="操作" width="150" fixed="right">
          <template slot-scope="scope">
            <el-link :underline="false" type="primary" @click="handleBpmImg(scope.$index, scope.row)">查看</el-link>
            <el-link v-if="editManagement" :underline="false" type="primary" @click="backToVersion(scope.$index, scope.row)">复原到此版本</el-link>
          </template>
        </el-table-column>
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

  </div>
</template>

<script>
import { getDictByItemId, getWbsVersionPage, recoverWbsVersion } from '@/api/wbsPlan'

export default {
  name: 'WbsVersionHistory',
  components: {
    // WbsVersionHistoryInfo
  },
  props: {
    wbsLevelId: {
      type: String,
      default: ''
    },
    wbsLevelCode: {
      type: String,
      default: ''
    },
    levelName: {
      type: String,
      default: ''
    },
    versionViewClose: {
      type: Function,
      default: null
    },
    editManagement: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {

      loading: false,
      planform: {
        applyUser: '',
        applyTime: '',
        wbsLevel: '',
        remark: ''
      },
      progressData: {
        pageNum: 1,
        pageSize: 10,
        total: 2,
        data: []
      },
      rowObj: '',
      planLevelList: '',
      versionHistoryInfoVisble: false,
      forbidden: false
    }
  },
  computed: {},
  watch: {
    editManagement(v) {
      if (!v) {
        this.editManagement = v
      }
    }
  },
  created() {
    this.selectPlanLevelList()
    this.getPageList()
  },
  methods: {
    selectPlanLevelList() {
      var this_ = this
      var requestData = { type: 'dict', itemId: '317b8ac10f804307a471cdfddaf7366d' }
      getDictByItemId(requestData).then(res => {
        this_.planLevelList = res
        this_.planform.wbsLevel = this_.wbsLevelCode
      }).catch(() => {
        this.$message({
          message: '获取计划等级失败',
          type: 'error'
        })
      })
    },
    getPageList(pageNum) {
      this.loading = true
      var requestData = {
        projectId: this.$route.params.id,
        applyUser: this.planform.applyUser,
        remark: this.planform.remark,
        pageSize: this.progressData.pageSize,
        pageIndex: this.progressData.pageNum,
        type: 0
      }
      if (this.planform.applyTime) {
        requestData.startApplyTime = this.planform.applyTime[0]
        requestData.endApplyTime = this.planform.applyTime[1]
      }
      getWbsVersionPage(requestData).then(res => {
        this.loading = false
        if (res && res.code === '200') {
          this.progressData.total = res.total
          this.$set(this.progressData, 'data', res.rows)
        }
      })
    },
    listQuery() {
      this.getPageList()
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
      // if (this.versionViewClose) {
      //   this.versionViewClose()
      // }
      // row['level'] = this.planform.wbsLevel
      // this.$router.push({ path: '/wbs/versioninfo', query: { data: JSON.stringify(row) }})
      // this.rowObj = row
      // this.versionHistoryInfoVisble = true
      this.$emit('toViewHistoryInfo', row)
    },
    backToVersion(index, row) {
      if (this.wbsLevelId) {
        var requestData = {
          projectId: this.$route.params.id,
          wbsLevelId: this.wbsLevelId,
          versionId: row.id,
          taskVerId: row.taskVerId
        }
        recoverWbsVersion(requestData).then(res => {
          this.$message({
            showClose: true,
            type: 'success',
            message: '操作成功'
          })
        })
      } else {
        this.$message({
          showClose: true,
          type: 'info',
          message: '没有获取到当前正在执行的计划信息'
        })
      }
    }
  }
}
</script>
<style lang="scss" scoped>
/deep/ .el-dialog__body{
    padding: 0px 20px;
    color: #606266;
    font-size: 14px;
    word-break: break-all;
}
.el-card__header {
    padding: 10px 20px;
    border-bottom: none;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}
.el-card__body{
  padding: 0px 0px;
}
/deep/.el-date-editor .el-range-separator{
padding:0px 1px 0px 0px
}
.el-form-item{
  margin-bottom: 5px;
}
</style>
