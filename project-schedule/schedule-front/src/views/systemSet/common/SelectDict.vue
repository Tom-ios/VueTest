<template>
  <div ref="pageDiv" class="clearfix">
    <el-card ref="cardone" class="box-card">
      <div ref="cardoneheader" slot="header" class="clearfix">
        <span>选择字段</span>
      </div>
      <!-- 表格 -->
      <div id="sortTreeDiv" style="height:285px;overflow-x:hidden;overflow-y:auto;">
        <el-tree
          ref="tree"
          :data="data"
          show-checkbox
          node-key="itemId"
          highlight-current
          check-strictly
          :max-height="100"
          :props="defaultProps"
          @check-change="checkChange"
          @node-click="nodeClick"
        />

      </div>
      <div ref="bottomDiv" class="clearfix">
        <el-row type="flex" class="box-card" justify="center" style="margin-top:10px;margin-bottom:10px">
          <el-button size="mini" @click="goback">取 消</el-button>
          <el-button size="mini" type="primary" @click="toSave">确定</el-button>
        </el-row>
      </div>
    </el-card>
  </div>

</template>
<script>
import { getAllSort } from '@/api/codeRule'
export default {

  data() {
    return {
      data: [],
      defaultProps: {
        children: 'chihldList',
        label: 'itemName'
      }
    }
  },
  created() {
    this.fetchData()
  },
  methods: {
    fetchData() {
      this.loading = true
      getAllSort().then(res => {
        console.log(res)
        if (res) {
          this.data = res
          this.loading = false
        }
      })
    },
    checkChange(item, node, self) {
      if (node === true) {
        this.editCheckId = item.itemId
        this.$refs.tree.setCheckedKeys([item.itemId])
      } else {
        if (this.editCheckId === item.itemId) {
          this.$refs.tree.setCheckedKeys([item.itemId])
        }
      }
    },
    nodeClick(item, node, self) {
      this.editCheckId = item.itemId
      this.$refs.tree.setCheckedKeys([item.itemId])
    },
    toSave() {
      this.$emit('setSelectValue', this.$refs.tree.getCheckedNodes())
    },
    goback() {
      this.$emit('closeDict')
    }
  }
}
</script>
<style scoped lang="scss">

</style>
