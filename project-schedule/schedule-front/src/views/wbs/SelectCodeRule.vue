<template>
  <div ref="pageDiv" class="clearfix">

    <!-- 表格 -->
    <div ref="tablewrap" style="margin-top:15px">
      <el-table
        ref="listData"
        v-loading="loading"
        :data="listData.data"
        border
        size="mini"
        :max-height="tableHeight"
        highlight-current-row
        @current-change="handleSelectionChange"
      >
        <el-table-column label="序号" type="index" width="55" align="center" />
        <el-table-column prop="tempName" label="模板名称" />
        <el-table-column prop="professionalName" label="行业" />
        <el-table-column prop="projectTypeName" label="项目类型" />
        <el-table-column prop="remark" label="备注" />
        <el-table-column prop="createUserName" label="创建人" />
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column prop="updateUserName" label="最近编辑人" />
        <el-table-column prop="updateTime" label="最近编辑时间" />
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
    <div ref="bottomDiv" class="clearfix">
      <el-row type="flex" class="box-card" justify="center" style="margin-top:10px;margin-bottom:10px">
        <el-button size="mini" type="primary" @click="toSave">确定</el-button>
        <el-button size="mini" @click="goback">取 消</el-button>
      </el-row>
    </div>

  </div>

</template>
<script>
import { wbsRuleinfoList } from '@/api/codeRule'
import { mapGetters } from 'vuex'
export default {
  props: {
    selProfessional: {
      type: String,
      default: ''
    },
    selProjectType: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      loading: false,
      listData: {
        pageNum: 1,
        pageSize: 10,
        total: 0,
        data: []
      },
      tableHeight: window.innerHeight > 400 ? window.innerHeight - 235 : 400,
      currentRow: null
    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  created() {
    this.fetchData()
  },
  methods: {
    fetchData() {
      this.loading = true
      const query = { professional: this.selProfessional, projectType: this.selProjectType, tentantId: this.tentantId }
      query.codeType = '1'
      query.pageSize = this.listData.pageSize
      query.pageIndex = this.listData.pageNum
      query.projectId = this.$route.params.id ? this.$route.params.id : '1'
      query.tentantId = this.tentantId
      wbsRuleinfoList(query).then(res => {
        this.listData.data = res.rows
        this.listData.total = res.total
        this.loading = false
      })
    },
    toSave() {
      console.log(this.currentRow)
      this.$emit('setSelectValue', this.currentRow)
    },
    goback() {
      this.$emit('closeCodeRule')
    },
    handleSelectionChange(val) {
      this.currentRow = val
    },
    handleCurrentChange(val) {
      this.listData.pageNum = val
      this.fetchData(val)
    },
    handleSizeChange(val) {
      this.listData.pageSize = val
      this.fetchData()
    }
  }
}
</script>
