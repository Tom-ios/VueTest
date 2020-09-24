<template>
  <div ref="pageDiv" class="clearfix wbsTemplate">
    <el-row style="border: 1px solid #EBEEF5;padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
      <div style="float:left;margin-left:9px">
        <span class="ml-20">模板名称</span>
        <el-input v-model="queryForm.name" placeholder="" size="mini" style="width: 140px;margin-left:5px" clearable />
      </div>
      <div style="float:left;margin-left:20px">
        <span class="ml-20">行业</span>
        <el-select v-model="queryForm.profeType" placeholder="行业" size="mini" style="width: 140px;margin-left:5px" clearable @change="selectProjectTypeList">
          <el-option
            v-for="item in profeTypeList"
            :key="item.dictCode"
            :label="item.name"
            :value="item.dictCode"
          />
        </el-select>
      </div>
      <div style="float:left;margin-left:20px">
        <span class="ml-20">项目类型</span>
        <el-select v-model="queryForm.engType" placeholder="项目类型" size="mini" style="width: 140px;margin-left:5px" clearable>
          <el-option
            v-for="item in projectTypeList"
            :key="item.dictCode"
            :label="item.name"
            :value="item.dictCode"
          />
        </el-select>
      </div>
      <el-button type="primary" class="ml-10" style="margin-left:20px" size="mini" @click="listQuery">查询</el-button>
      <el-button v-if="bfweb" plain size="mini" class="ml-10" @click="resetForm('queryForm')">重置</el-button>
      <div style="float:right;margin-right:20px">
        <el-button v-if="!selectType" style="float:right;margin-right:5px;" type="primary" size="mini" icon="el-icon-plus" @click="addtemplate">新增</el-button>
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
        :row-style="changeRowBgColorByIsPay"
        highlight-current-row
        :max-height="listHeight?listHeight:undefined"
        @selection-change="handleSelectionChange"
        @row-click="rowClick"
      >
        <el-table-column label="序号" type="index" width="55" align="center" />
        <el-table-column prop="isDefault" align="center" label="默认模板" width="70">
          <template slot-scope="scope">
            <span v-if="scope.row.isDefault == '1' ">
              是
            </span>
            <span v-else>否</span>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="模板名称">
          <!-- <template slot-scope="scope">
            <span v-if="scope.row.isDefault == '1' ">
              <i class="el-icon-s-flag" />
              {{ scope.row.name }}
            </span>
            <span v-else>{{ scope.row.name }}</span>
          </template> -->
        </el-table-column>
        <el-table-column prop="profeTypeName" width="60" label="行业" />
        <el-table-column prop="engTypeName" width="80" label="项目类型" />
        <el-table-column prop="remark" label="备注" />
        <el-table-column prop="createUserName" width="70" label="创建人" />
        <el-table-column prop="createTime" width="135" label="创建时间" />
        <el-table-column prop="updateUserName" width="85" label="最近编辑人" />
        <el-table-column prop="updateTime" width="135" label="最近编辑时间" />
        <el-table-column v-if="!selectType" label="操作" width="220" align="center">
          <template slot-scope="scope">
            <el-link :underline="false" type="primary" @click="handleRowEdit(scope.$index, scope.row)">编辑</el-link>
            |
            <el-link :underline="false" type="primary" @click="handleCopyRow(scope.$index, scope.row)">复制增加</el-link>
            |
            <el-link :underline="false" type="primary" @click="handleRowDefault(scope.$index,scope.row)">
              <span v-if="scope.row.isDefault == '1' ">
                取消默认
              </span>
              <span v-else>
                设为默认
              </span>
            </el-link>
            <span v-if="scope.row.isDefault != '1' ">
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
import { getDictByItemId, queryWbsTemplateList, setDefault, deleteScheWbsTempById } from '@/api/wbsPlan'
import { mapGetters } from 'vuex'
export default {
  name: 'WbsTemplateListVm',
  props: {
    selectType: {
      type: String,
      default: ''
    },
    toTemplateEdit: {
      type: Function,
      default: null
    },
    listHeight: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      queryForm: {
        name: '',
        engType: '',
        profeType: ''
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
      projectTypeList: [],
      profeTypeList: [],
      indexRow: {
        title: '序号'
      },
      bfweb: process.env.VUE_APP_BFWEB === 'true'
    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  created() {
    // this.selectProjectTypeList()
    this.selectProfeTypeList()
    this.fetchData()
  },
  mounted() {
    if (this.selectType) {
      this.tableHeight = this.$refs.pageDiv.clientHeight - 65
    } else {
      this.tableHeight = this.$refs.pageDiv.offsetHeight - 65
    }
  },
  methods: {
    selectProjectTypeList() {
      var this_ = this
      var selectProfeType = this.queryForm.profeType
      if (selectProfeType) {
        var selectContent = ''
        for (let i = 0; i < this.profeTypeList.length; i++) {
          if (this.profeTypeList[i].dictCode === selectProfeType) {
            selectContent = this.profeTypeList[i].content1
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
    selectProfeTypeList() {
      var this_ = this
      var requestData = { type: 'dict', itemId: '158e8a0a508341beb9dc31423ece82e8' }
      getDictByItemId(requestData).then(res => {
        this_.profeTypeList = res
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
      query.pageSize = this.listData.pageSize
      query.pageIndex = this.listData.pageNum
      query.projectId = this.$route.params.id ? this.$route.params.id : '1'
      query.tentantId = this.tentantId
      queryWbsTemplateList(query).then(res => {
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
      this.queryForm.name = ''
      this.queryForm.profeType = ''
      this.queryForm.engType = ''
      // this.$refs[formName].resetFields()
      this.fetchData()
    },
    listQuery: function() {
      this.listData.pageNum = 1
      this.fetchData()
    },
    addtemplate() {
      // this.$router.push(`/wbsTemplate/edit`)
      this.toTemplateEdit()
    },
    handleRowEdit: function(index, row) {
      this.toTemplateEdit(row.id, 'edit')
      // this.$emit('fatherMethod(' + row.id + ')')
      // this.$router.push(`/wbsTemplate/edit/` + row.id)
    },
    handleRowRemove(index, row) {
      this.$confirm(`确定要删除该模板么?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        deleteScheWbsTempById(row.id).then(res => {
          if (res && res.code === '200') {
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
    handleCopyRow(index, row) {
      this.toTemplateEdit(row.id, 'copy')
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
      var params = { id: row.id }
      setDefault(params).then(res => {
        console.log(res)
        if (res && res.code === '200') {
          if (!res.data.key) {
            this.$message({
              showClose: true,
              message: res.data.value,
              type: 'error'
            })
          } else {
            this.$message({
              showClose: true,
              message: '操作成功',
              type: 'success'
            })
            this.fetchData()
          }
        } else {
          this.$message({
            message: '设置失败',
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
      if (row.isDefault === '1' || row.isDefault === 1) {
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
.wbsTemplate{
  width: 100%;
  height: 100%;
}
.el-form-item__label-wrap{
margin-left: 28px;
}

// .search-form{
// padding: 10px 0px 0px 0px;
// }
</style>
