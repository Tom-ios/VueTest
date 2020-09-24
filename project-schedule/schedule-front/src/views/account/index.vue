<template>
  <div :class="selType?'':'app-container'">
    <d2-crud
      id="accountGrid"
      ref="d2Crud"
      :columns="datacolumns"
      :data="data"
      :loading="loading"
      :form-options="formOptions"
      :add-rules="addRules"
      :edit-rules="editRules"
      :row-handle="rowHandle"
      :pagination="pagination"
      :options="options"
      :index-row="indexRow"
      :selection-row="selType === 'multiple'? selectionRow:undefined"
      @cell-click="handleCellClick"
      @keyup.enter.native="fetchData"
      @dialog-open="handleDialogOpen"
      @row-add="handleRowAdd"
      @dialog-cancel="handleDialogCancel"
      @row-edit="handleRowEdit"
      @del="handleDel"
      @edit="handelEdit"
      @resetPassword="handleReset"
      @enableAccount="handleEnable"
      @disableAccount="handleDisable"
      @selection-change="handleSelectionChange"
      @current-change="handleCurrentChange"
      @pagination-current-change="paginationCurrentChange"
      @select="handleSelect"
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
            clearable
            style="width: 120px;"
          />
        </el-form-item>
        <el-form-item label="账号">
          <el-input
            v-model="form.userCode"
            clearable
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
            v-if="roleIds !== '01' && !selType"
            type="primary"
            @click="download"
          >
            下载模板
          </el-button>
          <el-upload
            v-if="roleIds !== '01' && !selType"
            action=""
            :on-change="onChange"
            :auto-upload="false"
            :show-file-list="false"
            style="display: inline-block"
            accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel"
          >
            <el-button slot="trigger" type="primary">导入账号</el-button>
          </el-upload>
          <el-button
            v-if="(roleIds === '01' || roleIds === '6c946a394b7b4e14ae97') && bAddAccount"
            type="primary"
            @click="addRow"
          >
            增加账号
          </el-button>
        </el-form-item>
      </el-form>
    </d2-crud>
  </div>
</template>

<script>
import { getGlobalDepartmentMap } from '@/api/GlobalProjectInfo'
import StatusTag from '@/components/StatusTag'
import VueSpan from '@/components/VueSpan'
import { getList, add, del, getRoleList, upload } from '@/api/account'
import { getList as getTentantList } from '@/api/tentant'
import { queryTententUserList } from '@/api/project'
import { getRoleIds, updatepasswd } from '@/api/user'
import store from '@/store'
import { mapGetters } from 'vuex'
export default {
  name: 'Account',
  components: {
    // eslint-disable-next-line
    StatusTag,
    // eslint-disable-next-line
    VueSpan
  },
  props: {
    isFweb: Boolean,
    selType: {
      type: String,
      default: ''
    },
    selRange: {
      type: String,
      default: ''
    },
    initDatas: {
      type: Array,
      default: function() { return [] }
    },
    columns: {
      type: Array,
      default: function() {
        return []
      }

    },
    bAddAccount: {
      type: Boolean,
      default: true
    },
    bProjectSelect: {
      type: Boolean,
      default: false
    },
    url: {
      type: String,
      default: ''
    },
    urlParam: {
      type: Object,
      default: function() { return null }
    },
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
              text: '删除',
              type: 'text',
              size: 'mini',
              emit: 'del',
              show(index, row) {
                return !row.adminCreateFlag
              }
            },
            {
              text: '重置密码',
              type: 'text',
              size: 'mini',
              emit: 'resetPassword'
            }
            // {
            //   text: '启用',
            //   type: 'text',
            //   size: 'mini',
            //   emit: 'enableAccount',
            //   show(index, row) {
            //     return row.status === '禁用'
            //   }
            // },
            // {
            //   text: '禁用',
            //   type: 'text',
            //   size: 'mini',
            //   emit: 'disableAccount',
            //   show(index, row) {
            //     return row.status === '正常'
            //   }
            // }
          ]
        }
      }
    }
  },
  data() {
    return {
      departmentId: '',
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
      formOptions: {
        appendToBody: true,
        labelWidth: '85px',
        saveLoading: false,
        width: '500px'
      },
      addRules: {
        userName: [
          { required: true, message: '请输入姓名', trigger: 'blur' },
          { max: 20, message: '限20字', trigger: 'blur' }
        ],
        userCode: [
          { required: true, message: '请输入账号', trigger: 'blur' },
          { max: 20, message: '限20字', trigger: 'blur' }
        ],
        unit: [
          { required: true, message: '请输入单位', trigger: 'blur' }
        ],
        tentantId: [
          { required: true, message: '请选择企业', trigger: 'blur' }
        ],
        roleId: [
          // { required: true, message: '请选择角色', trigger: 'blur' }
        ],
        orgName: [
          { required: true, message: '请输入部门', trigger: 'blur' },
          { max: 50, message: '限50字', trigger: 'blur' }
        ],
        jobName: [
          { required: true, message: '请输入职位', trigger: 'blur' },
          { max: 20, message: '限20字', trigger: 'blur' }
        ],
        mobilePhone: [
          { required: true, message: '请输入联系方式', trigger: 'blur' },
          { max: 50, message: '限50字', trigger: 'blur' }
        ]
      },
      editRules: {
        userName: [
          { required: true, message: '请输入姓名', trigger: 'blur' },
          { max: 20, message: '限20字', trigger: 'blur' }
        ],
        userCode: [
          { required: true, message: '请输入账号', trigger: 'blur' },
          { max: 20, message: '限20字', trigger: 'blur' }
        ],
        unit: [
          { required: true, message: '请输入单位', trigger: 'blur' }
        ],
        tentantId: [
          { required: true, message: '请选择企业', trigger: 'blur' }
        ],
        roleId: [
          // { required: true, message: '请选择角色', trigger: 'blur' }
        ],
        orgName: [
          { required: true, message: '请输入部门', trigger: 'blur' },
          { max: 50, message: '限50字', trigger: 'blur' }
        ],
        jobName: [
          { required: true, message: '请输入职位', trigger: 'blur' },
          { max: 20, message: '限20字', trigger: 'blur' }
        ],
        mobilePhone: [
          { required: true, message: '请输入联系方式', trigger: 'blur' },
          { max: 50, message: '限50字', trigger: 'blur' }
        ]
      },
      options: {
        // stripe: true
      },
      indexRow: {
        title: '序号'
      },
      sel: [],
      selectionRow: {},
      preSel: [],
      role: '1',
      tentantList: [],
      roleList: [],
      datacolumns: [],
      tentantId: '',
      roleIds: '',
      bFirst: true
    }
  },
  computed: {
    ...mapGetters([
      'userId'
    ])
  },
  watch: {
    initDatas: {
      handler: function() {
        this.sel = []
      },
      deep: true
    }
  },
  mounted() {
    if (this.selType === 'single') {
      this.$refs.d2Crud.options.highlightCurrentRow = true
    }
    if (process.env.VUE_APP_BFWEB === 'true') {
      getGlobalDepartmentMap().then(res => {
        if (res) {
          if (res.departmentId) {
            this.departmentId = res.departmentId
          }
          if (res.subDepartmentId) {
            this.departmentId = this.departmentId ? this.departmentId + ',' + res.subDepartmentId : res.subDepartmentId
          }
        }

        this.fetchData()
        // getRoleList().then(res => {
        //   this.roleList = res.data
        //   this.roleList.forEach(item => {
        //     item.label = item.roleName
        //     item.value = item.id
        //   })
        // })
      })
    } else {
      this.fetchData()
      getRoleList().then(res => {
        this.roleList = res.data
        this.roleList.forEach(item => {
          item.label = item.roleName
          item.value = item.id
        })
      })
    }
  },
  methods: {
    toggleSelection(rows) {
      if (rows) {
        rows.forEach((row) => {
          this.data.forEach((element, index) => {
            if (element.id === row.id) {
              this.$refs.d2Crud.$refs.elTable.toggleRowSelection(element, true)
              this.$refs.d2Crud.updateRow(index, row)
            }
          })
        })
      } else {
        this.$refs.d2Crud.$refs.elTable.clearSelection()
        this.sel = []
        this.preSel = []
      }
    },
    columnsInit() {
      if (this.columns.length === 0) {
        const arr = [
          {
            title: '姓名',
            key: 'userName'
          },
          {
            title: '账号',
            key: 'userCode'
          },
          {
            title: '企业',
            key: 'tentantName'
          },
          {
            title: '角色',
            key: 'roleName'
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
            title: '创建人',
            key: 'createUserNameDisplay'
          },
          {
            title: '创建时间',
            key: 'createTimeDisplay'
          }
        // {
        //   title: '账号状态',
        //   key: 'isLocked',
        //   component: {
        //     name: StatusTag
        //   }
        // }
        ]
        if (this.roleIds === '01') {
          arr.splice(4, 2)
          arr.splice(5, 1)
        } else {
          arr.splice(2, 2)
          arr.splice(2, 0, {
            title: '单位',
            key: 'unit'
          })
        }

        this.datacolumns = arr
      } else {
        this.datacolumns = this.columns
      }
    },
    onChange(file) {
      const d = new FormData()
      d.append('file', file.raw)
      d.append('tentantId', this.tentantId)
      upload(d).then(res => {
        if (res && (res.info || res.istemplent || res.isexcel || res.isdata)) {
          let message = ''
          if (res.info) {
            res.info.forEach(item => {
              message += item + '<br/>'
            })
          }
          if (res.istemplent) {
            message = res.istemplent
          }
          if (res.isexcel) {
            message = res.isexcel
          }
          if (res.isdata) {
            message = res.isdata
          }
          this.$alert(message, '导入错误', {
            confirmButtonText: '确定',
            dangerouslyUseHTMLString: true
          })
        } else {
          this.$message({
            type: 'success',
            message: '导入成功!'
          })
          this.fetchData()
        }
      })
    },
    paginationCurrentChange(currentPage) {
      this.pagination.currentPage = currentPage
      this.fetchData()
    },
    fetchData(callback) {
      this.loading = true
      if (this.bFirst && !this.isFweb) {
        getRoleIds().then(res => {
          this.roleIds = res
          this.columnsInit()
          // admin账号 表头标题和数据不一致的问题
          this.$nextTick(async() => {
            const query = this.form
            if (this.selType) {
              query.pageSize = this.pagination.pageSize = 10
            } else {
              query.pageSize = this.pagination.pageSize = 20
            }
            if (this.isFweb) {
              query.pageIndex = this.pagination.currentPage
              query.tentantId = store.getters.tentantId
            } else {
              query.pageIndex = this.pagination.currentPage - 1
            }
            if (process.env.VUE_APP_BFWEB === 'true' && this.isFweb) {
              query.tentantId = this.departmentId
            } else {
              if (this.bProjectSelect && this.isFweb) {
                query.projectId = this.$route.params.id
              }
            }

            let listFun = getList
            if (this.selRange === 'excludeMe') {
              listFun = queryTententUserList
            }
            listFun(this.url, query, this.isFweb).then(res => {
              if (this.selType === 'multiple') {
                var arr = []
                this.preSel = []
                this.sel = [...this.sel]
                this.initDatas.forEach(item => {
                  var isExit = false
                  this.sel.forEach(element => {
                    if (item.userId === element.userId) {
                      isExit = true
                    }
                  })
                  if (!isExit) {
                    this.sel.push(item)
                  }
                })

                this.sel.forEach(item => {
                  var isExit = false
                  res.rows.forEach(selItem => {
                    if (item.userId === selItem.userId) {
                      isExit = true
                      arr.push(selItem)
                    }
                  })
                  if (!isExit) {
                    this.preSel.push(item)
                  }
                })
              }
              res.rows.forEach(row => {
                row.createTimeDisplay = row.adminCreateFlag ? '-' : row.createTime
                row.createUserNameDisplay = row.adminCreateFlag ? '-' : row.createUserName
                row.roleName = row.roleId === 'qyptyh' ? '' : row.roleName
                row.roleId = row.roleId === 'qyptyh' ? '' : row.roleId
                row.orgName = row.orgName || ''
                row.jobName = row.jobName || ''
                row.unit = row.unit || ''
                row.mobilePhone = row.mobilePhone || ''
              })

              this.data = res.rows
              if (!this.tentantId && this.data.length > 0) {
                this.tentantId = this.data[0].tentantId
              }
              this.pagination.total = res.total
              this.loading = false
              this.$nextTick(() => {
                this.data.forEach((item, index) => {
                  if (!this.selType) {
                    this.$refs.d2Crud.updateRow(index, item)
                  }
                  this.initDatas.forEach((initItem) => {
                    if (this.selType === 'single') {
                      if (initItem === item.id) {
                        this.$refs.d2Crud.$refs.elTable.setCurrentRow(item)
                        this.$refs.d2Crud.updateRow(index, item)
                      }
                    }
                  })
                })
                if (this.selType === 'multiple') {
                  this.toggleSelection(arr)
                }
                if (callback instanceof Function) {
                  callback()
                }
              })
            })

            if (!this.selType && this.bFirst) {
              const q = {}
              q.pageSize = 9999
              q.pageIndex = 0
              getTentantList(q).then(res => {
                this.tentantList = res.rows
                this.tentantList.forEach(item => {
                  item.label = item.tentantName
                  item.value = item.id
                })
                this.bFirst = false
              })
            }
          })
        })
      } else {
        this.columnsInit()
        this.$nextTick(async() => {
          let query = this.form
          if (this.selType) {
            query.pageSize = this.pagination.pageSize = 10
          } else {
            query.pageSize = this.pagination.pageSize = 20
          }
          if (this.isFweb) {
            query.pageIndex = this.pagination.currentPage
            query.tentantId = store.getters.tentantId
          } else {
            query.pageIndex = this.pagination.currentPage - 1
          }
          if (process.env.VUE_APP_BFWEB === 'true' && this.isFweb) {
            query.tentantId = this.departmentId
          } else {
            if (this.bProjectSelect && this.isFweb) {
              query.projectId = this.$route.params.id
            }
          }

          let listFun = getList
          if (this.selRange === 'excludeMe') {
            listFun = queryTententUserList
          }
          if (this.urlParam) {
            query = { ...query, ...this.urlParam }
          }
          listFun(this.url, query, this.isFweb).then(res => {
            if (this.selType === 'multiple') {
              var arr = []
              this.preSel = []
              this.sel = [...this.sel]
              this.initDatas.forEach(item => {
                var isExit = false
                this.sel.forEach(element => {
                  if (item.userId === element.userId) {
                    isExit = true
                  }
                })
                if (!isExit) {
                  this.sel.push(item)
                }
              })

              this.sel.forEach(item => {
                var isExit = false
                res.rows.forEach(selItem => {
                  if (item.userId === selItem.userId) {
                    isExit = true
                    arr.push(selItem)
                  }
                })
                if (!isExit) {
                  this.preSel.push(item)
                }
              })
            }
            res.rows.forEach(row => {
              row.createTimeDisplay = row.adminCreateFlag ? '-' : row.createTime
              row.createUserNameDisplay = row.adminCreateFlag ? '-' : row.createUserName
              row.roleName = row.roleId === 'qyptyh' ? '' : row.roleName
              row.roleId = row.roleId === 'qyptyh' ? '' : row.roleId
              row.orgName = row.orgName || ''
              row.jobName = row.jobName || ''
              row.unit = row.unit || ''
              row.mobilePhone = row.mobilePhone || ''
            })

            this.data = res.rows
            if (!this.tentantId && this.data.length > 0) {
              this.tentantId = this.data[0].tentantId
            }
            this.pagination.total = res.total
            this.loading = false
            this.$nextTick(() => {
              this.data.forEach((item, index) => {
                if (!this.selType) {
                  this.$refs.d2Crud.updateRow(index, item)
                }
                this.initDatas.forEach((initItem) => {
                  if (this.selType === 'single') {
                    if (initItem === item.id) {
                      this.$refs.d2Crud.$refs.elTable.setCurrentRow(item)
                      this.$refs.d2Crud.updateRow(index, item)
                    }
                  }
                })
              })
              if (this.selType === 'multiple') {
                this.toggleSelection(arr)
              }
              if (callback instanceof Function) {
                callback()
              }
            })
          })

          if (!this.selType && this.bFirst) {
            const q = {}
            q.pageSize = 9999
            q.pageIndex = 0
            getTentantList(q).then(res => {
              this.tentantList = res.rows
              this.tentantList.forEach(item => {
                item.label = item.tentantName
                item.value = item.id
              })
              this.bFirst = false
            })
          }
        })
      }
    },
    addRow() {
      const template = {
        userName: {
          title: '姓名',
          value: ''
        },
        userCode: {
          title: '账号',
          value: ''
        },
        unit: {
          title: '单位',
          value: ''
        },
        tentantId: {
          title: '企业',
          value: '',
          component: {
            name: 'el-select',
            options: this.tentantList
          }
        },
        roleId: {
          title: '角色',
          value: '',
          component: {
            span: 24,
            name: 'el-select',
            options: this.roleList,
            clearable: true
          }
        },
        orgName: {
          title: '部门',
          value: ''
        },
        jobName: {
          title: '职位',
          value: ''
        },
        mobilePhone: {
          title: '联系方式',
          value: ''
        }
      }
      if (this.roleIds === '01') {
        delete template.orgName
        delete template.jobName
        delete template.unit
      } else {
        delete template.tentantId
        delete template.roleId
      }

      this.$refs.d2Crud.showDialog({
        mode: 'add',
        template: template
      })
    },
    handelEdit(val) {
      const template = {
        userName: {
          title: '姓名',
          value: ''
        },
        userCode: {
          title: '账号',
          value: '',
          component: {
            name: VueSpan
          }
        },
        unit: {
          title: '单位',
          value: ''
        },
        tentantId: {
          title: '企业',
          value: '',
          component: {
            span: 24,
            name: 'el-select',
            options: this.tentantList
          }
        },
        roleId: {
          title: '角色',
          value: '',
          component: {
            span: 24,
            name: 'el-select',
            options: this.roleList,
            clearable: true
          }
        },
        orgName: {
          title: '部门',
          value: ''
        },
        jobName: {
          title: '职位',
          value: ''
        },
        mobilePhone: {
          title: '联系方式',
          value: ''
        }
      }
      if (this.roleIds === '01') {
        delete template.orgName
        delete template.jobName
        delete template.unit
      } else {
        delete template.tentantId
        delete template.roleId
      }
      this.$refs.d2Crud.showDialog({
        mode: 'edit',
        template: template,
        rowIndex: val.index
      })
    },
    importData() {

    },
    download() {
      window.location.href = process.env.VUE_APP_BASE_API + 'bimserver/userInfo/download'
    },
    handleRowAdd(row, done) {
      if (!row.roleId) {
        row.roleId = 'qyptyh'
      }

      this.save(row, done)
    },
    handleRowEdit({ index, row }, done) {
      if (!row.roleId) {
        row.roleId = 'qyptyh'
      }

      this.save(row, done)
    },
    save(row, done) {
      this.formOptions.saveLoading = true

      for (const item of this.tentantList) {
        if (item.id === row.tentantId) {
          row.tentantName = item.tentantName
          break
        }
      }
      if (!row.tentantId) {
        row.tentantId = this.tentantId
      }
      if (!row.isTentantuser) { // 新增复制 保存用查询的
        row.isTentantuser = row.roleId === '6c946a394b7b4e14ae97' ? '1' : '0'
      }
      add(row).then(res => {
        this.$message({
          message: '保存成功',
          type: 'success'
        })

        // done可以传入一个对象来修改提交的某个字段
        done()
        this.formOptions.saveLoading = false
        this.fetchData(() => {
          let newIndex = -1
          for (let i = 0; i < this.data.length; i++) {
            if (this.data[i].id === res.userId) {
              newIndex = i
              break
            }
          }
          if (newIndex >= 0) {
            if (this.selType === 'single') {
              this.$refs.d2Crud.$refs.elTable.setCurrentRow(this.data[newIndex])
            } else {
              this.$refs.d2Crud.$refs.elTable.toggleRowSelection(this.data[newIndex], true)
            }
            this.$refs.d2Crud.updateRow(newIndex, this.data[newIndex])
          }
        })
      }).catch(() => {
        this.formOptions.saveLoading = false
      })
    },
    handleDel({ index, row }) {
      this.$confirm(`确定要 <strong><font size=4>删除</font></strong> ${row.userName}(${row.userCode})的账号吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        return del(row.id)
      }).then(() => {
        this.$message({
          type: 'success',
          message: '删除成功!'
        })
        this.fetchData()
      }).catch(() => {
      })
    },
    handleReset({ index, row }) {
      this.$confirm(`确定要 <strong><font size=4>重置</font></strong> ${row.userName}(${row.userCode})的密码吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        return updatepasswd({ 'userCode': row.userCode, 'isReset': true })
      }).then(() => {
        this.$message({
          type: 'success',
          message: '重置成功!'
        })
      }).catch(() => {
      })
    },
    handleEnable({ index, row }) {
      this.$confirm(`确定要 <strong><font size=4>启用</font></strong> ${row.userName}(${row.userCode})的账号吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        this.$message({
          type: 'success',
          message: '启用成功!'
        })
      }).catch(() => {
      })
    },
    handleDisable({ index, row }) {
      this.$confirm(`确定要 <strong><font size=4>禁用</font></strong> ${row.userName}(${row.userCode})的账号吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        this.$message({
          type: 'success',
          message: '禁用成功!'
        })
      }).catch(() => {
      })
    },
    handleDialogCancel(done) {
      // this.$message({
      //   message: '取消保存',
      //   type: 'warning'
      // })
      done()
    },
    handleDialogOpen({ mode }) {
      // this.$message({
      //   message: '打开模态框，模式为：' + mode,
      //   type: 'success'
      // })
    },
    cancelSel() {
      this.$refs.d2Crud.$refs.elTable.setCurrentRow()
      this.toggleSelection()
    },
    handleSelectionChange(selection) {
      if (this.selType === 'multiple') {
        this.sel = [...selection, ...this.preSel]
      }
    },
    handleSelect(selection, row) {
    },
    handleCurrentChange(selection) {
      if (this.selType === 'single') {
        this.sel = [selection]
      }
    },
    handleCellClick(row, column, cell, event) {
      this.$refs.d2Crud.$refs.elTable.toggleRowSelection(row, this.sel.indexOf(row) === -1)
    }
  }
}
</script>
<style>

#accountGrid .el-select{
  width: 100%
}
</style>
