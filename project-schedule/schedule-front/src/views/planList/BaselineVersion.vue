<template>
  <div class="ml-10 mr-10 mt-10">
    <!-- <el-button type="primary" class="mb-10 ml-20" @click="back">返回列表</el-button> -->
    <el-card class="infocard">
      <!-- <el-alert title="当前版本信息" type="info" :closable="false" /> -->
      <span>当前版本信息</span>
      <el-row class="mt-20">
        <el-form :inline="true" label-width="100px" label-position="left">
          <el-col :span="6">
            <el-form-item label="当前版本号：">
              <span>{{ info.baseNo }}</span>
            </el-form-item>
          </el-col>
          <el-col :span="6">
            <el-form-item label="提交人：">
              <span>{{ info.applyUserName }}</span>
            </el-form-item>
          </el-col>
          <el-col :span="8">
            <el-form-item label="提交时间：">
              <span>{{ info.applyTime }}</span>
            </el-form-item>
          </el-col>
          <el-col>
            <el-form-item label="提交说明:">
              <span>{{ info.remark }}</span>
            </el-form-item>
          </el-col>
        </el-form>
      </el-row>
    </el-card>
    <el-card class="mt-10">
      <el-row>
        <el-form :inline="true">
          <el-form-item label="编码">
            <el-input v-model="wbsCode" style="width: 130px;" />
          </el-form-item>
          <el-form-item label="名称">
            <el-input v-model="wbsname" style="width: 130px;" />
          </el-form-item>
          <el-form-item label="级别">
            <el-select v-model="wbslevel" clearable placeholder="全部" style="width: 130px;" @clear="clear">
              <el-option v-for="item in leveloptions" :key="item.id" :label="item.levelName" :value="item.id" />
            </el-select>
          </el-form-item>
          <el-button type="primary" @click="select">查询</el-button>
        </el-form>
      </el-row>
      <el-row>
        <el-button type="text" @click="expandAll">展开全部节点</el-button>
        <el-button type="text" @click="collapseAll">收起全部节点</el-button>
        <el-button type="text" @click="expandSelect">展开当前节点</el-button>
        <el-button type="text" @click="collapseSelect">收起当前节点</el-button>
      </el-row>
      <el-row class="mt-10">
        <el-table ref="theTable" :data="tableDataCopy" highlight-current-row default-expand-all row-key="id" :tree-props="{children: 'children', hasChildren: 'hasChildren'}" :row-class-name="getindex" border style="width: 100%" @row-click="onRowClick">
          <el-table-column type="index" width="50" />
          <el-table-column prop="wbsName" label="名称" :formatter="Format" />
          <el-table-column prop="wbsCode" label="编码" :formatter="Format" width="200" />
          <el-table-column prop="levelName" label="级别" :formatter="Format" width="100" />
          <el-table-column prop="planStartDate" label="计划开始时间" :formatter="Format" width="150" />
          <el-table-column prop="planEndDate" label="计划结束时间" :formatter="Format" width="150" />
          <el-table-column prop="planDuration" label="计划工期" :formatter="Format" width="100" />
          <el-table-column prop="weights" label="权重比例(%)" :formatter="Format" width="100" />
          <el-table-column prop="principalName" label="负责人" :formatter="Format" width="100" />
        </el-table>
      </el-row>
    </el-card>
  </div>
</template>

<script>
import { getPlanList, getDetails, getWbsLevel, queryTree } from '@/api/planCompare/planCompare'
export default {
  name: 'BaselineVersion',
  data() {
    return {
      info: {},
      selectIndex: '',
      defaultExpandAll: false,
      leveloptions: [],
      wbsCode: '',
      wbsname: '',
      wbslevel: '',
      tableDataCopy: [],
      tableData: []
    }
  },
  created() {
    this.getPlanListData()
    this.getDetailsFuc()
  },
  methods: {
    getPlanListData() {
      console.log(this.$route.params.id)
      var versionId = this.$route.query.versionId
      var params = {
        type: this.$route.query.type,
        projectId: this.$route.query.projectId,
        beginCreateTime: '',
        endCreateTime: '',
        remark: ''
      }
      // console.log('query', this.$route.query)
      getPlanList(params).then(res => {
        if (res && res.code === '200') {
          for (var i = 0; i < res.data.length; i++) {
            if (res.data[i].versionId === versionId) {
              this.info = res.data[i]
            }
          }
        } else {
          // alert('获取计划列表失败')
          this.$message({
            type: 'error',
            message: '获取计划列表失败'
          })
        }
      })
    },
    async getDetailsFuc() {
      // console.log(this.$route.query)
      var versionId = this.$route.query.versionId
      var params = {
        projectId: this.$route.query.projectId,
        wbsCode: '',
        wbsName: '',
        level: '',
        versionId: versionId
      }
      var params2 = {
        projectId: this.$route.query.projectId
        // projectId: '70411cac7ec5431daef8'
      }
      await getDetails(params).then(res => {
        console.log(res.data)
        if (res && res.code === '200') {
          // this.tableData = res.data
          this.tableDataCopy = res.data
        } else {
          // alert('获取详情失败')
          this.$message({
            type: 'error',
            message: '获取详情失败'
          })
        }
      })
      // await getDetails(params).then(res => {
      //   if (res && res.code === '200') {
      //     this.tableData = res.data
      //   } else {
      //     // alert('获取详情失败')
      //     this.$message({
      //       type: 'error',
      //       message: '获取详情失败'
      //     })
      //   }
      // })
      await getWbsLevel(params2).then(res => {
        console.log('level', res.data)
        if (res && res.code === '200') {
          this.leveloptions = res.data
        } else {
          // alert('获取Wbs级别失败')
          this.$message({
            type: 'error',
            message: '获取Wbs级别失败'
          })
        }
      })
    },
    forArr(arr, isExpand) {
      arr.forEach(i => {
        this.$refs.theTable.toggleRowExpansion(i, isExpand)
        if (i.children) {
          this.forArr(i.children, isExpand)
        }
      })
    },
    expandAll() {
      this.forArr(this.tableDataCopy, true)
    },
    collapseAll() {
      this.forArr(this.tableDataCopy, false)
    },
    getindex({ row, rowIndex }) {
      row.row_index = rowIndex
    },
    onRowClick(row, event, column) {
      this.selectIndex = row
    },
    expandSelect() {
      if (this.selectIndex !== '') {
        this.$refs.theTable.toggleRowExpansion(this.selectIndex, true)
      } else {
        // alert('请选择一个节点！')
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    collapseSelect() {
      if (this.selectIndex !== '') {
        this.$refs.theTable.toggleRowExpansion(this.selectIndex, false)
      } else {
        // alert('请选择一个节点！')
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    // deepSearch(nodes) {
    //   // 如果已经没有节点了，结束递归
    //   if (!(nodes && nodes.length)) {
    //     return
    //   }
    //   const newChildren = []
    //   console.log('this.wbsname:', this.wbsname, 'this.wbsCode:', this.wbsCode, 'this.wbslevel:', this.wbslevel)
    //   for (const node of nodes) {
    //     if (this.wbsname !== '' && this.wbsCode === '' && this.wbslevel === '') {
    //       console.log(1)
    //       if (node.wbsName.indexOf(this.wbsname) >= 0) {
    //         // 如果自己（节点）符合条件，直接加入到新的节点集
    //         newChildren.push(node)
    //         // 并接着处理其 children
    //         node.children = this.deepSearch(node.children)
    //       } else {
    //         // 如果自己不符合条件，需要根据子集来判断它是否将其加入新节点集
    //         // 根据递归调用 deal() 的返回值来判断
    //         const subs = this.deepSearch(node.children)
    //         if (subs && subs.length) {
    //           // 1. 如果子孙集中有符合要求的节点（返回 [...])，加入
    //           node.children = subs
    //           newChildren.push(node)
    //         }
    //         // 2. 否则，不加入（因为整个子集都没有符合条件的）
    //       }
    //     } else if (this.wbsname === '' && this.wbsCode !== '' && this.wbslevel === '') {
    //       console.log(2)
    //       if (node.wbsCode.indexOf(this.wbsCode) >= 0) {
    //         newChildren.push(node)
    //         node.children = this.deepSearch(node.children)
    //       } else {
    //         const subs = this.deepSearch(node.children)
    //         if (subs && subs.length) {
    //           node.children = subs
    //           newChildren.push(node)
    //         }
    //       }
    //     } else if (this.wbsname === '' && this.wbsCode === '' && this.wbslevel !== '') {
    //       console.log(3)
    //       if ((node.levelCode && node.levelCode.indexOf(this.wbslevel) >= 0)) {
    //         newChildren.push(node)
    //         node.children = this.deepSearch(node.children)
    //       } else {
    //         const subs = this.deepSearch(node.children)
    //         if (subs && subs.length) {
    //           node.children = subs
    //           newChildren.push(node)
    //         }
    //       }
    //     } else if (this.wbsname !== '' && this.wbsCode !== '' && this.wbslevel === '') {
    //       console.log(4)
    //       if (node.wbsName.indexOf(this.wbsname) >= 0 && node.wbsCode.indexOf(this.wbsCode) >= 0) {
    //         newChildren.push(node)
    //         node.children = this.deepSearch(node.children)
    //       } else {
    //         const subs = this.deepSearch(node.children)
    //         if (subs && subs.length) {
    //           node.children = subs
    //           newChildren.push(node)
    //         }
    //       }
    //     } else if (this.wbsname !== '' && this.wbsCode === '' && this.wbslevel !== '') {
    //       console.log(5)
    //       if (node.wbsName.indexOf(this.wbsname) >= 0 && (node.levelCode && node.levelCode.indexOf(this.wbslevel) >= 0)) {
    //         newChildren.push(node)
    //         node.children = this.deepSearch(node.children)
    //       } else {
    //         const subs = this.deepSearch(node.children)
    //         if (subs && subs.length) {
    //           node.children = subs
    //           newChildren.push(node)
    //         }
    //       }
    //     } else if (this.wbsname === '' && this.wbslevel !== '' && this.wbsCode !== '') {
    //       console.log(6)
    //       if (node.wbsCode.indexOf(this.wbsCode) >= 0 && (node.levelCode && node.levelCode.indexOf(this.wbslevel) >= 0)) {
    //         newChildren.push(node)
    //         node.children = this.deepSearch(node.children)
    //       } else {
    //         const subs = this.deepSearch(node.children)
    //         if (subs && subs.length) {
    //           node.children = subs
    //           newChildren.push(node)
    //         }
    //       }
    //     } else {
    //       console.log(7)
    //       if (node.wbsCode.indexOf(this.wbsCode) >= 0 && (node.levelCode && node.levelCode.indexOf(this.wbslevel) >= 0) && node.wbsName.indexOf(this.wbsname) >= 0) {
    //         newChildren.push(node)
    //         node.children = this.deepSearch(node.children)
    //       } else {
    //         const subs = this.deepSearch(node.children)
    //         if (subs && subs.length) {
    //           node.children = subs
    //           newChildren.push(node)
    //         }
    //       }
    //     }
    //   }
    //   return newChildren.length ? newChildren : void 0
    // },
    select() {
      // 查询操作
      // this.tableDataCopy = this.tableData
      // if (this.wbsname !== '' || this.wbsCode !== '' || this.wbslevel !== '') {
      //   this.tableDataCopy = this.deepSearch(this.tableDataCopy)
      //   console.log('show', this.tableDataCopy)
      // } else {
      //   this.getDetailsFuc()
      // }
      var params = {
        wbsCode: this.wbsCode,
        wbsName: this.wbsname,
        levelId: this.wbslevel,
        versionId: this.$route.query.versionId
      }
      queryTree(params).then(res => {
        if (res && res.state === 'success') {
          console.log('成功', res)
          this.tableDataCopy = res.data
        } else {
          this.$message({
            type: 'error',
            message: '查询失败'
          })
        }
      })
    },
    clear() {
      this.wbsname = ''
      this.wbsCode = ''
      this.wbslevel = ''
      this.select()
    },
    Format(row, column) {
      const str = row[column.property]
      if (str === null || str === '') {
        return ' '
      }
      return str
    },
    back() {
      this.$router.push(`/planlist/list/${this.$route.query.projectId}`)
    }
  }
}
</script>

<style lang="scss" scoped>
  .ml-10 {
    margin-left: 10px;
  }
  .mt-10 {
    margin-top: 10px;
  }
  .mr-10 {
    margin-right: 10px;
  }
  .mb-10 {
    margin-bottom: 10px;
  }
  .ml-20 {
    margin-left: 20px;
  }
  .mt-20 {
    margin-top: 20px;
  }
  .el-table__body tr.current-row>td{
    background-color: #f19944 !important;
  }
  .infocard {
    height: 150px;
  }
</style>
