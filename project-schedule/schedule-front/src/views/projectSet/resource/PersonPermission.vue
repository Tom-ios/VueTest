<template>
  <div ref="pageDiv" class="clearfix PersonPermissionDiv">
    <!-- 查询 -->
    <el-form ref="queryForm" :inline="true" :model="queryForm" size="mini" label-width="auto" class="search-form">
      <el-form-item prop="roleName" label="角色名称">
        <el-input v-model.trim="queryForm.roleName" placeholder="角色名称" clearable />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" size="mini" @click="listQuery()">查询</el-button>
        <el-button v-if="peopleShow" plain size="mini" @click="resetForm('queryForm')">重置</el-button>
      </el-form-item>
      <div v-if="!selectTypeMode" class="clearfix" style="float:right;margin-right:5px;">
        <el-button type="primary" size="mini" @click="uprow">上移</el-button>
        <el-button type="primary" size="mini" @click="downrow">下移</el-button>
        <el-button type="primary" size="mini" @click="addRole">增加角色</el-button>
      </div>

    </el-form>
    <!-- 表格 -->
    <div ref="tablewrap" class="table-wrap">
      <el-table
        ref="listData"
        v-loading="loading"
        :data="listData.data"
        :highlight-current-row="selectTypeMode?false:true"
        border
        size="mini"
        :max-height="tableHeight"
        @row-click="rowClick"
      >
        <el-table-column label="序号" type="index" width="55" />
        <el-table-column prop="roleName" label="角色名称" />
        <el-table-column prop="remark" label="备注" />
        <el-table-column label="人员">
          <template slot-scope="scope">
            <div v-html="formatterColumn(scope.row.scheRoleUserList)" />
          </template>
        </el-table-column>
        <el-table-column prop="createUserName" label="创建人" />
        <el-table-column prop="createTime" label="创建时间" />
        <el-table-column v-if="!selectTypeMode" label="操作" width="230">
          <template slot-scope="scope">
            <el-button type="text" @click="handleRowEdit(scope.$index, scope.row)">编辑</el-button>
            <el-button type="text" @click="handleSelectUser(scope.$index, scope.row)">选择人员</el-button>
            <el-button type="text" @click="handleRowRemove(scope.$index, scope.row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div v-if="!selectTypeMode && !peopleShow" style="margin-top:10px">
      <span style="font-size:14px;">项目人员列表</span>
      <el-table
        style="margin-top:10px"
        :data="peopleData"
        border
        size="mini"
        :max-height="peopleHeight"
      >
        <el-table-column label="序号" type="index" width="55" />
        <el-table-column prop="userName" label="姓名" />
        <el-table-column prop="userCode" label="账号" />
        <el-table-column prop="roleName" label="角色" />
        <el-table-column prop="orgName" label="部门" />
        <el-table-column prop="jobName" label="职位" />

      </el-table>
    </div>

    <el-dialog
      title="添加/修改角色"
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
      width="30%"
      @close="personPermissionDialogClose"
    >
      <el-form ref="formData" :model="formData" class="form-wrap" label-width="auto" size="small" label-suffix="" :rules="rules">
        <el-row style="padding-left:30px">
          <el-col :span="20">
            <el-form-item label="角色名称：" prop="roleName" style="margin-left:18px;">
              <el-input v-model="formData.roleName" />
            </el-form-item>
          </el-col>
        </el-row>

        <el-row style="padding-left:30px">
          <el-col :span="20">
            <el-form-item label="备注：" prop="remark" style="margin-left:18px;">
              <el-input v-model="formData.remark" type="textarea" :rows="5" placeholder="请输入内容" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <span slot="footer">
        <el-button size="mini" @click="personPermissionDialogClose">取 消</el-button>
        <el-button type="primary" :loading="optLoad" size="mini" @click="nameSubmit">确 定</el-button>
      </span>
    </el-dialog>
    <!-- <el-dialog
      title=""
      :visible.sync="humanDialogVisible"
      :close-on-click-modal="false"
      width="90%"
    > -->
    <SelectPerople ref="human" :visible.sync="humanDialogVisible" :sel-type="selectType" is-multiple-filter :is-fweb="true" :init-datas="curSelRows" :add-account="false" @sure="closeHumanDialog" />
    <!-- </el-dialog> -->
  </div>
</template>

<script>
import SelectPerople from '@/components/SelectPeople'

import { queryPersonPermissionList, shiftUp, shiftDown, savePersonPermission, deletePersonPermissionById, checkSameName, queryProjectUserList } from '@/api/projectSet'
export default {
  name: 'PersonPermissionListVm',
  components: {
    SelectPerople
  },
  props: {
    selectTypeMode: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      peopleShow: process.env.VUE_APP_BFWEB === 'true',
      peopleHeight: 0,
      peopleData: [],
      queryForm: {
        roleName: ''
      },
      formData: {
        projectId: '',
        roleName: '',
        sort: '',
        remark: ''
      },
      data: [],
      dialogVisible: false,
      humanDialogVisible: false,
      optLoad: false,
      loading: false,
      tableHeight: window.innerHeight - 259,
      listData: {
        data: []
      },
      currentRow: null,
      indexRow: {
        title: '序号'
      },
      selectType: 'multiple',
      curSelRows: [],
      rules: {
        roleName: [
          { required: true, message: '请输入角色名称', tigger: ' ' }
        ]
      }
    }
  },
  watch: {

  },
  created() {
    this.fetchData()
    if (!this.selectTypeMode) {
      this.tableHeight = 400
    }
    this.getPeople()
  },

  methods: {
    getPeople() {
      if (!this.peopleShow) {
        queryProjectUserList({ projectId: this.$route.params.id }).then(res => {
          this.peopleData = res.rows
        })
      }
    },
    rowClick(row, col, event) {
      this.currentRow = row
      this.$emit('selectRow', { row: row })
    },
    fetchData() {
      this.loading = true
      const query = this.queryForm
      query.projectId = this.$route.params.id
      queryPersonPermissionList(query).then(res => {
        this.listData.data = res.data
        this.loading = false
        this.$nextTick(() => {
          if (!this.selectTypeMode) {
            this.peopleHeight = window.innerHeight - this.$refs.listData.$el.offsetHeight - 155
          }
          if (this.currentRow && this.currentRow.id) {
            this.listData.data.forEach(element => {
              if (element.id === this.currentRow.id) {
                this.$refs.listData.setCurrentRow(element)
              }
            })
          }
        })
      })
    },
    formatterColumn(cellValue) {
      let usernames = ''
      if (cellValue && cellValue.length > 0) {
        cellValue.forEach(item => {
          usernames = usernames + item.userName + ','
        })
      }
      if (usernames)usernames = usernames.substring(0, usernames.length - 1)
      return usernames
    },
    setCurrent(row) {
      this.$refs.listData.setCurrentRow(row)
    },
    listQuery: function() {
      this.fetchData()
    },
    addRole() {
      this.$set(this.formData, 'roleName', '')
      this.$set(this.formData, 'remark', '')
      this.$set(this.formData, 'sort', '')
      this.dialogVisible = true
    },
    personPermissionDialogClose() {
      this.reset()
      this.dialogVisible = false
    },
    reset() {
      this.$refs.formData.validate((valid) => {
        if (!valid) {
          this.$refs.formData.resetFields()
        }
      })
      this.formData = {
        roleName: '',
        remark: '',
        sort: ''
      }
    },
    uprow() {
      if (this.currentRow) {
        var requestData = {
          id: this.currentRow.id
        }
        shiftUp(requestData).then(res => {
          this.fetchData()
        })
      } else {
        this.$message({
          showClose: true,
          message: '请选择行',
          type: 'info'
        })
      }
    },
    downrow() {
      if (this.currentRow) {
        var requestData = {
          id: this.currentRow.id
        }
        shiftDown(requestData).then(res => {
          this.fetchData()
        })
      } else {
        this.$message({
          showClose: true,
          message: '请选择行',
          type: 'info'
        })
      }
    },
    handleRowEdit: function(index, row) {
      this.formData = { ...row }
      this.dialogVisible = true
    },
    nameSubmit() {
      this.$refs['formData'].validate((valid) => {
        if (valid) {
          this.optLoad = true
          var requestData = { id: this.formData.id, roleName: this.formData.roleName, projectId: this.$route.params.id }
          checkSameName(requestData).then(res => {
            if (res) {
              this.formData.projectId = this.$route.params.id
              if (!this.formData.sort) this.formData.sort = this.listData.data.length + 1
              savePersonPermission(this.formData).then(res => {
                this.$message({
                  showClose: true,
                  message: '保存成功',
                  type: 'success'
                })
                this.optLoad = false

                this.dialogVisible = false
                this.fetchData()
              })
            } else {
              this.$message({
                showClose: true,
                message: '角色名称重复，请修改角色名称',
                type: 'error'
              })
              this.optLoad = false
            }
          })
        }
      })
    },
    handleRowRemove(index, row) {
      this.$confirm(`确定要删除该角色么?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        var requestData = {
          id: row.id,
          projectId: this.$route.params.id ? this.$route.params.id : '1'
        }
        if (process.env.VUE_APP_BFWEB === 'false') {
          requestData.projectUserFlag = '1'
        }
        deletePersonPermissionById(requestData).then(res => {
          if (res && res.code === '200') {
            this.getPeople()
            this.$message({
              showClose: true,
              message: '删除成功',
              type: 'success'
            })
            this.currentRow = {}
            this.fetchData()
          } else {
            this.$message({
              message: '删除失败',
              type: 'warning'
            })
          }
        }
        ).catch(() => {
          this.$message({
            message: '删除失败',
            type: 'error'
          })
        })
      })
    },
    handleSelectUser(index, row) {
      this.setCurrent(row)
      this.curSelRows = []
      if (row.scheRoleUserList) {
        row.scheRoleUserList.forEach((obj) => {
          this.curSelRows.push({ ...obj, id: obj.userId })
        })
      }
      this.humanDialogVisible = true
    },
    closeHumanDialog(data) {
      if (!data) {
        data = []
      }
      if (data) {
        var userdata = []
        for (let i = 0; i < data.length; i++) {
          userdata.push({ userId: data[i].userId, roleId: data[i].roleId, projectId: this.$route.params.id, userName: data[i].userName })
        }
        this.currentRow.scheRoleUserList = userdata
        if (!this.peopleShow) {
          this.currentRow.projetUserFlag = 1
        }
        // 保存信息
        savePersonPermission(this.currentRow).then(res => {
          this.$message({
            showClose: true,
            message: '保存成功',
            type: 'success'
          })
          this.curSelRows = []
          this.fetchData()
          this.getPeople()
        })
      }

      this.humanDialogVisible = false
    },
    resetForm(formName) {
      this.queryForm.roleName = ''
      this.fetchData()
    }
  }
}
</script>

<style lang="scss" scoped>
.PersonPermissionDiv{
  width: 100%;
  height: 100%;
  padding:10px 10px
}
</style>
