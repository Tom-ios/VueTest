<template>
  <div class="app-container">
    <d2-crud
      id="memberGrid"
      ref="d2Crud"
      :columns="columns"
      :data="data"
      :loading="loading"
      :pagination="pagination"
      :index-row="indexRow"
      @keyup.enter.native="fetchData"
      @pagination-current-change="paginationCurrentChange"
    >
      <el-form
        slot="header"
        ref="form"
        :inline="true"
        :model="form"
        size="mini"
        style=""
      >
        <el-form-item label="姓名">
          <el-input
            v-model="form.userName"
            placeholder=""
            style="width: 120px;"
          />
        </el-form-item>
        <el-form-item label="账号">
          <el-input
            v-model="form.userCode"
            placeholder=""
            style="width: 120px;"
          />
        </el-form-item>
        <el-form-item>
          <el-button
            type="primary"
            @click="fetchData"
          >
            查询
          </el-button>
        </el-form-item>
        <el-form-item style="float: right">
          <el-button
            v-if="isManager"
            type="primary"
            @click="edit"
          >
            编辑人员
          </el-button>
        </el-form-item>
      </el-form>
    </d2-crud>
  </div>
</template>

<script>
import { queryProjectUserList, getRoleNamesByProject } from '@/api/project'
export default {
  name: 'ProjectMemberList',
  data() {
    return {
      form: {
        userName: '',
        userCode: ''
      },
      data: [],
      loading: false,
      pagination: {
        currentPage: 1,
        pageSize: 20,
        total: 0
      },
      indexRow: {
        title: '序号'
      },
      columns: [
        {
          title: '姓名',
          key: 'userName'
        },
        {
          title: '账号',
          key: 'userCode'
        },
        {
          title: '部门',
          key: 'orgName'
        },
        {
          title: '职位',
          key: 'jobName'
        },
        {
          title: '联系方式',
          key: 'mobilePhone'
        },
        {
          title: '角色',
          key: 'roleName'
        }
      ],
      isManager: false
    }
  },
  created() {
    this.fetchData()
    getRoleNamesByProject(this.$route.params.id).then(res => {
      const roleArr = res.split(',')
      this.isManager = roleArr.indexOf('项目经理') !== -1
    })
  },
  methods: {
    fetchData() {
      this.loading = true
      const query = this.form
      query.pageSize = this.pagination.pageSize
      query.pageIndex = this.pagination.currentPage - 1
      query.projectId = this.$route.params.id
      queryProjectUserList(query).then(res => {
        this.data = res.rows
        this.pagination.total = res.total
        this.loading = false
      })
    },
    paginationCurrentChange() {
      this.fetchData()
    },
    edit() {
      this.$router.push(`/projectMember/edit/${this.$route.params.id}`)
    }
  }
}
</script>

<style lang="scss" scoped>

</style>
