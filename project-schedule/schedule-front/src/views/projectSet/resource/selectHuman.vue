<template>
  <div ref="pageDiv" class="clearfix pageDiv">
    <el-form ref="queryForm" :inline="true" :model="queryForm" size="mini" label-width="auto" class="search-form">
      <el-form-item label="姓名" prop="userName">
        <el-input v-model.trim="queryForm.userName" placeholder="姓名" clearable />
      </el-form-item>
      <el-form-item label="账号" prop="userCode">
        <el-input v-model.trim="queryForm.userCode" placeholder="账号" clearable />
      </el-form-item>
      <el-button type="primary" size="mini" icon="el-icon-search" @click="listQuery()">查询</el-button>
      <el-button plain size="mini" icon="el-icon-refresh" @click="resetForm('queryForm')">重置</el-button>

    </el-form>
    <div class="clearfix" style="margin-top:15px">
      <el-table
        ref="humanTable"
        :data="tableData"
        border
        stripe
        highlight-current-row
        :header-cell-class-name="'tableHeader'"
        :cell-class-name="addClass"
        style="margin-top:10px"
        :max-height="maxHeight"
        row-key="id"
        empty-text="暂无数据"
        default-expand-all
        :indent="20"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        @row-click="rowClick"
        @selection-change="handleSelectionChange"
      >

        <el-table-column
          v-if="selectType"
          :type="selectType?'selection':'undefined'"
          width="55"
        />
        <el-table-column
          type="index"
          label="序号"
          width="60"
        />
        <el-table-column
          v-for="(col,index) in tablecolumn"
          :key="index"
          :prop="col.value"
          :label="col.title"
          :min-width="col.width?col.width:'100'"
        >
          <template slot-scope="scope">
            {{ scope.row[tablecolumn[index].key] }}
          </template>
        </el-table-column>
      </el-table>
      <el-pagination
        style="margin-top:10px"
        class="table-pages"
        background
        :page-sizes="[10, 20, 50, 100]"
        :page-size="pagination.pageSize"
        :current-page="pagination.pageIndex"
        layout="total, sizes, prev, pager, next, jumper"
        :total="pagination.total"
        @current-change="handleCurrentChange"
        @size-change="handleSizeChange"
      />
    </div>
    <span slot="footer">
      <el-button type="primary" @click="checkhuman">确 定</el-button>
      <el-button @click="cancelhuman">取 消</el-button>
    </span>
  </div>
</template>
<script>
import { getList } from '@/api/projectSet'
export default {
  props: {
    listMaxHeight: {
      type: Number,
      default: 0
    },
    selectType: {
      type: String,
      default: ''
    },
    closeHumanDialog: {
      type: Function,
      default: null
    },
    curSelRows: {
      type: Array,
      default: function() { return [] }
    }

  },
  data() {
    return {
      selResouce: [],
      showHumanDialog: false,
      saveLoading: false,
      loadDing: false,
      queryForm: {
        userName: '',
        userCode: ''
      },
      maxHeight: 400,
      tableData: [],
      tablecolumn: [
        {
          title: '姓名',
          key: 'userName',
          width: 80
        },
        {
          title: '账号',
          key: 'userCode',
          width: 80
        },
        {
          title: '工作单位',
          key: 'unit',
          width: 150
        },
        {
          title: '部门',
          key: 'orgName',
          width: 120
        },
        {
          title: '职位',
          key: 'jobName',
          width: 120
        },
        {
          title: '单价(元)',
          key: 'price',
          width: 80
        },
        {
          title: '计量单位',
          key: 'typeName'
        },
        {
          title: '资源日历',
          key: 'resourceCaleId',
          width: 100
        },
        {
          title: '联系方式',
          key: 'mobilePhone',
          width: 110
        },
        {
          title: '是否可用',
          key: 'enabledName',
          width: 80
        },
        {
          title: '创建人',
          key: 'createUserNameDisplay',
          width: 80
        },
        {
          title: '创建时间',
          key: 'createTimeDisplay',
          width: 180
        }
      ],
      pagination: {
        pageIndex: 1,
        pageSize: 20,
        total: 0
      },
      // formData: {
      //   userName: '',
      //   userCode: '',
      //   type: '0'
      // },
      preSel: [],
      role: '1',
      tentantId: '',
      roleIds: ''
    }
  },
  watch: {
    listMaxHeight(v) {
      if (v) {
        this.caclHeight()
      }
    },
    curSelRows: {
      handler: function() {
        this.checkSelRow()
      }
    }
  },
  mounted() {
    this.fetchList()
    this.caclHeight()
    if (this.selectType === 'multiple') {
      this.tablecolumn.splice(this.tablecolumn.length - 3, 3)
    }
  },
  methods: {
    checkSelRow() {
      var selArr = []
      this.curSelRows.forEach(item => {
        this.tableData.forEach(selItem => {
          if (item.userId === selItem.id) {
            selArr.push(selItem)
          }
        })
      })
      this.toggleSelection(selArr)
    },
    caclHeight() {
      this.$nextTick(() => {
        if (this.listMaxHeight !== 0) {
          this.maxHeight = this.listMaxHeight
        } else {
          this.maxHeight = this.$refs.pageDiv.clientHeight - 130
        }
      })
    },
    handleCurrentChange(val) {
      console.log(val)
      this.pagination.pageIndex = val
      this.fetchList()
    },
    handleSizeChange(val) {
      this.pagination.pageSize = val
      this.fetchList()
    },

    search() {
      this.fetchList()
    },
    fetchList() {
      const query = {
        userName: this.queryForm.userName.trim(),
        userCode: this.queryForm.userCode.trim()
      }
      query.pageSize = this.pagination.pageSize
      query.pageIndex = this.pagination.pageIndex - 1
      getList(query).then(res => {
        res.rows.forEach(row => {
          row.createTimeDisplay = row.adminCreateFlag ? '-' : row.createTime
          row.createUserNameDisplay = row.adminCreateFlag ? '-' : row.createUserName
          row.roleName = row.roleId === 'qyptyh' ? '' : row.roleName
          row.roleId = row.roleId === 'qyptyh' ? '' : row.roleId
          row.orgName = row.orgName || ''
          row.jobName = row.jobName || ''
          row.mobilePhone = row.mobilePhone || ''
        })

        this.tableData = res.rows
        this.pagination.total = res.total
        if (!this.tentantId && this.tableData.length > 0) {
          this.tentantId = this.tableData[0].tentantId
        }
        this.$nextTick(() => {
          if (this.selectType) {
            this.checkSelRow()
          }
        })
      })
    },
    toggleSelection(rows) {
      if (rows) {
        rows.forEach(row => {
          this.$refs.humanTable.toggleRowSelection(row)
        })
      } else {
        this.$refs.humanTable.clearSelection()
        this.selResouce = []
      }
    },
    handleSelectionChange(selection) {
      if (this.selectType === 'multiple') {
        this.selResouce = [...selection, ...this.preSel]
      }
    },
    rowClick(row, col, event) {
      this.$refs.humanTable.setCurrentRow(row)
      this.currentNode = row
    },
    addClass({ row, columnIndex }) {
      return 'justcenter'
    },
    // reset() {
    //   this.$refs.form.validate((valid) => {
    //     if (!valid) {
    //       this.$refs.form.resetFields()
    //     }
    //   })
    //   this.formData = {
    //     name: '',
    //     explains: ''
    //   }
    // },
    checkhuman() {
      // const selArr = [...this.$refs.resourceSel.$refs[this.$refs.resourceSel['activeName']].selResouce]
      // var tmpArr = JSON.parse(JSON.stringify(selArr))
      // if (this.formData.scheTaskResource) {
      //   this.formData.scheTaskResource.forEach(taskItem => {
      //     tmpArr.forEach(element => {
      //       if (taskItem.id === element.id) {
      //         this.$set(element, 'resCode', taskItem.resCode)
      //         this.$set(element, 'resName', taskItem.resName)
      //         this.$set(element, 'resType', taskItem.resType)
      //         this.$set(element, 'resModel', taskItem.resModel)
      //         this.$set(element, 'unitPrice', taskItem.unitPrice)
      //         this.$set(element, 'startDate', taskItem.startDate)
      //         this.$set(element, 'endDate', taskItem.endDate)
      //         this.$set(element, 'unitEstimate', taskItem.unitEstimate)
      //         this.$set(element, 'bOldResource', true)
      //       }
      //     })
      //   })
      // }
      // tmpArr.forEach(element => {
      //   if (element.bOldResource) {
      //     return
      //   } else {
      //     this.$set(element, 'resCode', element.userCode)
      //     this.$set(element, 'resName', element.userName)
      //     this.$set(element, 'resType', '人力')
      //     this.$set(element, 'resModel', '')
      //     this.$set(element, 'unitPrice', element.price,)
      //     this.$set(element, 'startDate', '')
      //     this.$set(element, 'endDate', '')
      //     this.$set(element, 'unitEstimate', element.type)
      //   }
      // })

      // this.resourceData = tmpArr
      this.closeHumanDialog(this.selResouce)
    },
    cancelhuman() {
      this.$refs.humanTable.setCurrentRow()
      this.toggleSelection()
      this.closeHumanDialog()
    },
    keydownhandle(event) {
      const { key } = event
      // 或者根据键码判断, 下面过滤掉除数字和退格外的所有输入
      if (new RegExp(/((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/).test(key) || key === 'Backspace') return
      event.preventDefault()
    }
  }

}
</script>
<style lang="scss" scoped>

/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
/deep/ .justcenter{
  text-align: center;
}
/deep/ .el-checkbox__label{
  line-height: 16px
}
 /deep/ .el-table td.redBgColor{
  background: red;
  text-align: center;
}
</style>
