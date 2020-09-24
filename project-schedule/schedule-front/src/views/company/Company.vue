<template>
  <div class="app-container">
    <d2-crud
      id="companyGrid"
      ref="d2Crud"
      :columns="columns"
      :data="data"
      :loading="loading"
      :form-options="formOptions"
      :add-rules="addRules"
      :edit-rules="editRules"
      :row-handle="rowHandle"
      :pagination="pagination"
      :options="options"
      :index-row="indexRow"
      @keyup.enter.native="fetchData"
      @dialog-open="handleDialogOpen"
      @row-add="handleRowAdd"
      @dialog-cancel="handleDialogCancel"
      @row-edit="handleRowEdit"
      @edit="handleEdit"
      @del="handleDel"
      @detail="handleDetail"
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
        <el-form-item label="企业名称">
          <el-input
            v-model="form.tentantName"
            placeholder=""
            style="width: 200px;"
          />
        </el-form-item>
        <el-form-item label="企业编号">
          <el-input
            v-model="form.tentantNo"
            placeholder=""
            style="width: 200px;"
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
            type="primary"
            @click="addRow"
          >
            增加企业
          </el-button>
        </el-form-item>
      </el-form>
    </d2-crud>
  </div>
</template>

<script>
import VueSpan from '@/components/VueSpan'
import { getList, getTentantNo, add, del } from '@/api/tentant'
export default {
  name: 'Company',
  components: {
    // eslint-disable-next-line
    VueSpan
  },
  props: {
    columns: {
      type: Array,
      default: function() {
        return [
          {
            title: '企业名称',
            key: 'tentantName'
          },
          {
            title: '企业编号',
            key: 'tentantNo'
          },
          {
            title: '备注',
            key: 'remark'
          },
          {
            title: '创建时间',
            key: 'createTime'
          }
        ]
      }
    },
    rowHandle: {
      type: Object,
      default: function() {
        return {
          width: '220px',
          custom: [
            // {
            //   text: '查看',
            //   type: 'text',
            //   size: 'mini',
            //   emit: 'detail'
            // },
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
              emit: 'del'
            }
          ]
        }
      }
    }
  },
  data() {
    return {
      form: {
        tentantName: '',
        tentantNo: ''
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
        labelWidth: '80px',
        saveLoading: false,
        width: '500px'
      },
      addRules: {
        tentantName: [
          { required: true, message: '请输入名称', trigger: 'blur' },
          { max: 100, message: '限100字', trigger: 'blur' }
        ]
      },
      editRules: {
        tentantName: [
          { required: true, message: '请输入名称', trigger: 'blur' },
          { max: 100, message: '限100字', trigger: 'blur' }
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
      preSel: []
    }
  },
  mounted() {
    if (this.selType === 'single') {
      this.$refs.d2Crud.options.highlightCurrentRow = true
    }
    this.fetchData()
  },
  methods: {
    paginationCurrentChange(currentPage) {
      this.pagination.currentPage = currentPage
      this.fetchData()
    },
    fetchData() {
      this.loading = true
      if (this.sel.length > 0) {
        this.preSel = this.sel
      }
      const query = this.form
      query.pageSize = this.pagination.pageSize
      query.pageIndex = this.pagination.currentPage - 1
      getList(query).then(res => {
        this.data = res.rows
        this.pagination.total = res.total
        this.loading = false
      })
    },
    addRow() {
      getTentantNo().then(res => {
        this.$refs.d2Crud.showDialog({
          mode: 'add',
          template: {
            tentantNo: {
              title: '企业编号',
              value: res,
              component: {
                name: VueSpan
              }
            },
            tentantName: {
              title: '企业名称',
              value: '',
              component: {
                maxlength: '100'
              }
            },
            remark: {
              title: '备注',
              value: '',
              component: {
                type: 'textarea',
                maxlength: '100',
                autosize: { minRows: 2 }
              }
            }
          }
        })
      })
    },
    handleEdit({ index, row }) {
      this.$refs.d2Crud.showDialog({
        mode: 'edit',
        rowIndex: index,
        template: {
          tentantNo: {
            title: '企业编号',
            value: '',
            component: {
              name: VueSpan
            }
          },
          tentantName: {
            title: '企业名称',
            value: '',
            component: {
              maxlength: '100'
            }
          },
          remark: {
            title: '备注',
            value: '',
            component: {
              type: 'textarea',
              maxlength: '100',
              autosize: { minRows: 2 }
            }
          }
        }
      })
    },
    handleRowAdd(row, done) {
      this.formOptions.saveLoading = true
      add(row).then(res => {
        this.$message({
          message: '保存成功',
          type: 'success'
        })

        // done可以传入一个对象来修改提交的某个字段
        done()
        this.formOptions.saveLoading = false
        this.fetchData()
      })
    },
    handleRowEdit({ index, row }, done) {
      this.formOptions.saveLoading = true
      add(row).then(res => {
        this.$message({
          message: '保存成功',
          type: 'success'
        })

        // done可以传入一个对象来修改提交的某个字段
        done()
        this.formOptions.saveLoading = false
        this.fetchData()
      })
    },
    handleDel({ index, row }) {
      this.$confirm(`确定要 <strong><font size=4>删除</font></strong> ${row.tentantName}吗?`, '提示', {
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
    handleDetail(d) {
      this.$router.push(`/company/detail/${d.row.id}`)
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
    }
  }
}
</script>
