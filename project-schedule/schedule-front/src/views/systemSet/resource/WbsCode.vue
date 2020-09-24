<template>
  <div id="wbsCode" ref="pageDiv" class="clearfix wbsPage">
    <el-row style="border: 1px solid #EBEEF5;padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
      <div style="float:left;margin-left:9px">
        <span class="ml-20">模板名称</span>
        <el-input v-model="queryForm.name" placeholder="" size="mini" style="width: 140px;margin-left:5px" clearable />
      </div>
      <div style="float:left;margin-left:20px">
        <span class="ml-20">行业</span>
        <el-select v-model="queryForm.professional" placeholder="行业" size="mini" style="width: 140px;margin-left:5px" clearable @change="selectProjectTypeList">
          <el-option
            v-for="item in professionalList"
            :key="item.dictCode"
            :label="item.name"
            :value="item.dictCode"
          />
        </el-select>
      </div>
      <div style="float:left;margin-left:20px">
        <span class="ml-20">项目类型</span>
        <el-select v-model="queryForm.projectType" placeholder="项目类型" size="mini" style="width: 140px;margin-left:5px" clearable>
          <el-option
            v-for="item in projectTypeList"
            :key="item.dictCode"
            :label="item.name"
            :value="item.dictCode"
          />
        </el-select>
      </div>
      <el-button type="primary" class="ml-10" style="margin-left:20px" size="mini" @click="listQuery">查询</el-button>
      <el-button v-if="!selectType" plain size="mini" class="ml-10" @click="resetForm('queryForm')">重置</el-button>
      <div v-if="!selectType" style="float:right;margin-right:20px">
        <el-button style="float:right;margin-right:5px;" type="primary" size="mini" icon="el-icon-plus" @click="addtemplate">新增</el-button>
      </div>
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
        :max-height="tableHeight"
        :row-style="changeRowBgColorByIsPay"
        highlight-current-row
        @selection-change="handleSelectionChange"
        @row-click="rowClick"
      >
        <el-table-column label="序号" type="index" width="55" align="center" />
        <el-table-column prop="defaultValue" align="center" label="默认模板" width="80">
          <template slot-scope="scope">
            <span v-if="scope.row.defaultValue == '1' ">
              是
            </span>
            <span v-else-if="scope.row.defaultValue == '0'">否</span>
            <span v-else>系统模板</span>
          </template>
        </el-table-column>
        <el-table-column prop="tempName" label="模板名称">
          <!-- <template slot-scope="scope">
            <span v-if="scope.row.defaultValue == '1' ">
              <i class="el-icon-s-flag" />
              {{ scope.row.tempName }}
            </span>
            <span v-else>{{ scope.row.tempName }}</span>
          </template> -->
        </el-table-column>
        <el-table-column prop="professionalName" label="行业" width="70" />
        <el-table-column prop="projectTypeName" label="项目类型" width="80" />
        <el-table-column prop="remark" label="备注" />
        <el-table-column prop="createUserName" label="创建人" width="70" />
        <el-table-column prop="createTime" label="创建时间" width="135" />
        <el-table-column prop="updateUserName" label="最近编辑人" width="85" />
        <el-table-column prop="updateTime" label="最近编辑时间" width="135" />
        <el-table-column v-if="!selectType" label="操作" width="220" align="center">
          <template slot-scope="scope">
            <span v-if="scope.row.defaultValue != '2' ">
              <el-link :underline="false" type="primary" @click="handleRowEdit(scope.$index, scope.row)">编辑</el-link>
              |
            </span>
            <el-link :underline="false" type="primary" @click="handleCopyRow(scope.$index, scope.row)">复制增加</el-link>
            <el-link :underline="false" type="primary" @click="handleRowDefault(scope.$index,scope.row)">
              <span v-if="scope.row.defaultValue == '1' ">
                |
                取消默认
              </span>
              <span v-if="scope.row.defaultValue == '0' ">
                |
                设为默认
              </span>
            </el-link>
            <span v-if="scope.row.defaultValue == '0' ">
              |
              <el-link :underline="false" type="primary" @click="handleRowRemove(scope.$index, scope.row)">删除</el-link>
            </span>

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
import { getDictByItemId, wbsRuleinfoList, setDefaultRuleinfo, deleteWbsRuleinfo } from '@/api/codeRule'
import { mapGetters } from 'vuex'
export default {
  name: 'WbsCodeListVm',
  props: {
    toWbsCodeEdit: {
      type: Function,
      default: null
    },
    selectType: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      queryForm: {
        name: '',
        projectType: '',
        professional: ''
      },
      data: [],
      loading: false,
      tableHeight: window.innerHeight > 400 ? window.innerHeight - 290 : 400,

      listData: {
        pageNum: 1,
        pageSize: 10,
        total: 0,
        data: []
      },
      projectTypeList: [],
      professionalList: [],
      indexRow: {
        title: '序号'
      }
    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  created() {
    // this.selectProjectTypeList()
    this.selectProfessionalList()
    this.fetchData()
  },
  mounted() {
    if (this.selectType) {
      this.tableHeight = this.$refs.pageDiv.clientHeight - 80
    } else {
      this.tableHeight = this.$refs.pageDiv.offsetHeight - 110
    }
  },
  methods: {
    selectProjectTypeList() {
      var this_ = this
      var selectProfessional = this.queryForm.professional
      if (selectProfessional) {
        var selectContent = ''
        for (let i = 0; i < this.professionalList.length; i++) {
          if (this.professionalList[i].dictCode === selectProfessional) {
            selectContent = this.professionalList[i].content1
            break
          }
        }
        var requestData = { type: 'dict', itemId: '82ad9e44e8364057945c88927fde13e6', content1: selectContent }
        getDictByItemId(requestData).then(res => {
          this_.projectTypeList = res
        }).catch(() => {
          this.$message({
            message: '获取项目类型失败',
            type: 'error'
          })
        })
      }
    },
    selectProfessionalList() {
      var this_ = this
      var requestData = { type: 'dict', itemId: '158e8a0a508341beb9dc31423ece82e8' }
      getDictByItemId(requestData).then(res => {
        this_.professionalList = res
      }).catch(() => {
        this.$message({
          message: '获取专业失败',
          type: 'error'
        })
      })
    },
    fetchData() {
      this.loading = true
      const query = this.queryForm
      query.codeType = '1'
      query.pageSize = this.listData.pageSize
      query.pageIndex = this.listData.pageNum
      query.projectId = this.$route.params.id ? this.$route.params.id : '1'
      query.tentantId = this.tentantId
      wbsRuleinfoList(query).then(res => {
        if (res && res.code === '200') {
          this.listData.data = res.rows
          this.listData.total = res.total
          this.loading = false
        }
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
      this.queryForm.name = ''
      this.queryForm.professional = ''
      this.queryForm.projectType = ''
      // this.$refs[formName].resetFields()
      this.fetchData()
    },
    listQuery: function() {
      this.listData.pageNum = 1
      this.fetchData()
    },
    addtemplate() {
      // this.$router.push(`/wbsTemplate/edit`)
      this.toWbsCodeEdit()
    },
    handleRowEdit: function(index, row) {
      this.toWbsCodeEdit(row.id, 'edit')
      // this.$emit('fatherMethod(' + row.id + ')')
      // this.$router.push(`/wbsTemplate/edit/` + row.id)
    },
    handleRowRemove(index, row) {
      this.$confirm(`确定要删除该模板么?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        deleteWbsRuleinfo(row.id).then(res => {
          // if (res && res.code === '200') {
          this.fetchData()
          // } else {
          //   this.$message({
          //     message: '删除失败',
          //     type: 'warning'
          //   })
          // }
        }
        ).catch(() => {
          this.$message({
            message: '删除失败',
            type: 'error'
          })
        })
      })
    },
    handleCopyRow(index, row) {
      this.toWbsCodeEdit(row.id, 'copy')
      // var params = { id: row.id }
      // copyScheWbsTemp(params).then(res => {
      //   if (res && res.code === '200') {
      //     this.$message({
      //       showClose: true,
      //       message: '操作成功',
      //       type: 'success'
      //     })
      //     this.fetchData()
      //   } else {
      //     this.$message({
      //       message: '复制失败',
      //       type: 'warning'
      //     })
      //   }
      // }
      // ).catch(() => {
      //   this.$message({
      //     message: '复制失败',
      //     type: 'error'
      //   })
      // })
    },
    handleRowDefault(index, row) {
      // var dv = row.defaultValue === '1' ? '0' : '1'
      // var params = { 'id': row.id + '', 'defaultValue': dv }
      // console.log(params)
      setDefaultRuleinfo(row.id).then(res => {
        if (res && res.code === '200') {
          this.$message({
            showClose: true,
            message: '操作成功',
            type: 'success'
          })
          this.fetchData()
        } else {
          this.$message({
            showClose: true,
            message: res.message,
            type: 'warning'
          })
        }
      }
      ).catch(() => {
        this.$message({
          message: '设置失败',
          type: 'error'
        })
      })
    },
    changeRowBgColorByIsPay({ row, rowIndex }) {
      if (row.defaultValue === '1' || row.defaultValue === 1) {
        return { 'background-color': '#f5f7fc' }
      }
    },
    rowClick(row) {
      this.$emit('selectSingle', { 'row': row })
    }
  }
}
</script>

<style lang="scss" scoped>
#wbsCode.wbsPage{
  width: 100%;
  height: 100%;
  // position: absolute;
}
#wbsCode .el-form-item__label-wrap{
margin-left: 28px;
}

// .search-form{
// padding: 10px 0px 0px 0px;
// }
</style>
