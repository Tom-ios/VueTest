<template>
  <div ref="pageDiv" class="clearfix approveList">
    <el-row style="border: 1px solid #EBEEF5;padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
      <div style="float:left;margin-left:9px">
        <span class="ml-20">提交人</span>
        <el-input v-model="queryForm.applyUser" placeholder="" size="mini" style="width: 120px;margin-left:5px" clearable />
      </div>
      <div style="float:left;margin-left:20px">
        <span class="ml-20">审批结果</span>
        <el-select v-model="queryForm.state" placeholder="审批结果" size="mini" style="width: 140px;margin-left:5px" clearable>
          <el-option
            v-for="item in stateList"
            :key="item.dictCode"
            :label="item.name"
            :value="item.dictCode"
          />
        </el-select>
      </div>
      <div style="float:left;margin-left:20px">
        <span class="ml-20">分类</span>
        <el-select v-model="queryForm.type" placeholder="分类" size="mini" style="width: 80px;margin-left:5px" clearable>
          <el-option
            v-for="item in approveTypeList"
            :key="item.dictCode"
            :label="item.name"
            :value="item.dictCode"
          />
        </el-select>
      </div>
      <div style="float:left;margin-left:20px">
        <span class="ml-20">当前节点</span>
        <el-select v-model="queryForm.currentNode" placeholder="当前节点" size="mini" style="width: 120px;margin-left:5px" clearable>
          <el-option
            v-for="item in userApproveList"
            :key="item.value"
            :label="item.name"
            :value="item.value"
          />
        </el-select>
      </div>
      <el-button type="primary" class="ml-10" style="margin-left:20px" size="mini" @click="listQuery">查询</el-button>
      <el-button plain size="mini" icon="el-icon-refresh" @click="resetForm('queryForm')">重置</el-button>
    </el-row>
    <!-- 查询 -->

    <!-- 表格 -->
    <div ref="tablewrap" style="margin-top:15px">
      <el-table
        ref="listData"
        v-loading="loading"
        :data="listData.data"
        border
        size="mini"
        highlight-current-row
        @selection-change="handleSelectionChange"
      >
        <el-table-column label="序号" type="index" width="55" align="center" />
        <el-table-column prop="typeName" label="分类" width="80" />
        <el-table-column prop="levelName" label="级别" width="120" />
        <el-table-column prop="applyUserName" label="提交人" width="120" />
        <el-table-column prop="applyTime" label="提交时间" width="180" />
        <el-table-column prop="opinion" label="审批意见" />
        <el-table-column prop="approvalUserName" label="处理人" width="120" />
        <el-table-column prop="stateName" label="审批结果" width="160" />
        <el-table-column label="操作" width="80" align="center">
          <template slot-scope="scope">
            <el-link :underline="false" type="primary" @click="handleRowEdit(scope.$index, scope.row)">查看</el-link>
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        style="margin-top:10px"
        class="table-pages"
        background
        :page-sizes="[10, 20, 50, 100]"
        :page-size="listData.pageSize"
        :current-page="listData.pageNum"
        layout="total, sizes, prev, pager, next, jumper"
        :total="listData.total"
        @current-change="handleCurrentChange"
        @size-change="handleSizeChange"
      />
    </div>
  </div>
</template>

<script>
import { getDictByItemId, getApproveData } from '@/api/wbsApprove'
export default {
  name: 'ApproveListVm',
  props: {
  },
  data() {
    return {
      queryForm: {
        applyUser: '',
        state: '',
        type: '',
        currentNode: ''
      },
      data: [],
      loading: false,
      tableHeight: window.innerHeight > 400 ? window.innerHeight - 235 : 400,

      listData: {
        pageNum: 1,
        pageSize: 10,
        total: 0,
        data: []
      },
      approveTypeList: [],
      stateList: [],
      userApproveList: [{ name: '我的提交', value: '1' }, { name: '我的审批', value: '2' }],
      indexRow: {
        title: '序号'
      }
    }
  },
  created() {
    this.selectStateList()
    this.selectApproveTypeList()
    this.fetchData()
  },
  mounted() {
    this.tableHeight = this.$refs.pageDiv.clientHeight - 65
  },
  methods: {
    selectStateList() {
      var this_ = this
      var requestData = { type: 'dict', itemId: '8891df1ee31b4684a44aed9cb6c46bfc' }
      getDictByItemId(requestData).then(res => {
        this_.stateList = res
      }).catch(() => {
        this.$message({
          message: '获取审批结果失败',
          type: 'error'
        })
      })
    },
    selectApproveTypeList() {
      var this_ = this
      var requestData = { type: 'dict', itemId: 'c9690e2b4caf4d8ba92080e85cd5ec71' }
      getDictByItemId(requestData).then(res => {
        this_.approveTypeList = res
      }).catch(() => {
        this.$message({
          message: '获取审批结果失败',
          type: 'error'
        })
      })
    },

    fetchData() {
      this.loading = true
      const query = this.queryForm
      query.pageSize = this.listData.pageSize
      query.pageIndex = this.listData.pageNum
      query.projectId = this.$route.params.id ? this.$route.params.id : '1'
      getApproveData(query).then(res => {
        this.listData.data = res.rows
        this.listData.total = res.total
        this.loading = false
      })
    },
    handleSelectionChange(val) {
      this.multipleSelection = val
    },
    handleCurrentChange(val) {
      this.listData.pageNum = val
      this.fetchData(val)
    },
    handleSizeChange(val) {
      this.listData.pageSize = val
      this.fetchData()
    },
    resetForm(formName) {
      this.queryForm.applyUser = ''
      this.queryForm.state = ''
      this.queryForm.type = ''
      this.queryForm.currentNode = ''
      // this.$refs[formName].resetFields()
      this.fetchData()
    },
    listQuery: function() {
      this.listData.pageNum = 1
      this.fetchData()
    },
    handleRowEdit: function(index, row) {
      if (row.frozen === '1' || row.frozen === 1) {
        this.$message({
          message: '当前审批记录已冻结，无法查看',
          type: 'info'
        })
      } else {
        this.$router.push({ path: `/approve/view`, query: { id: row.id }})
      }
    }
    // handleRowRemove(index, row) {
    //   this.$confirm(`确定要删除该模板么?`, '提示', {
    //     confirmButtonText: '确定',
    //     cancelButtonText: '取消',
    //     type: 'warning'
    //   }).then(() => {
    //     deleteScheWbsTempById(row.id).then(res => {
    //       if (res && res.code === '200') {
    //         this.fetchData()
    //       } else {
    //         this.$message({
    //           message: '删除失败',
    //           type: 'warning'
    //         })
    //       }
    //     }
    //     ).catch(() => {
    //       this.$message({
    //         message: '删除失败',
    //         type: 'error'
    //       })
    //     })
    //   })
    // },
    // changeRowBgColorByIsPay({ row, rowIndex }) {
    //   if (row.isDefault === '1' || row.isDefault === 1) {
    //     return { 'background-color': '#f5f7fc' }
    //   }
    // }
  }
}
</script>

<style lang="scss" scoped>
.approveList{
  width: 100%;
  height: 100%;
}
.el-form-item__label-wrap{
margin-left: 28px;
}
</style>
