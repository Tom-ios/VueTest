<template>
  <div ref="reourceDiv" class="clearfix reourceDiv">
    <el-tabs
      v-model="activeName"
      type="border-card"
      class="h_percent100"
      @tab-click="handleClick"
    >
      <el-tab-pane label="人员权限设置" name="personpermission" class="h_percent100">
        <PersonPermission />
      </el-tab-pane>
      <el-tab-pane label="项目参数设置" name="projectparam" class="h_percent100">
        <ProjectParam />
      </el-tab-pane>
    </el-tabs>

  </div>
</template>

<script>
import PersonPermission from './resource/PersonPermission.vue'
import ProjectParam from './resource/ProjectParam.vue'
export default {
  components: {
    PersonPermission,
    ProjectParam
  },
  props: {

  },
  data() {
    return {
      activeName: 'personpermission'
    }
  },
  watch: {

  },
  methods: {
    mounted() {
    },
    handleClick() {
      this.$emit('resourceTypeChange', { 'activeName': this.activeName })
    },
    cancelSel() {
      this.$refs[this.activeName].cancelSel()
    },
    toWbsCodeEdit(id) {
      this.wbsCodeId = id
      this.wbsCodeList = false
    },
    toWbsCodeList() {
      this.activeName = 'wbscode'
      this.wbsCodeList = true
    },
    toExpensesCourseEdit(id) {
      this.expensesCourseId = id
      this.expensesCourseList = false
    },
    toExpensesCourseList() {
      this.activeName = 'expensescourse'
      this.expensesCourseList = true
    }
  }

}
</script>
<style lang="scss" scoped>
.reourceDiv{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 10px;
}
.h_percent100{
  height:100%
}

/deep/ .el-tabs--border-card>.el-tabs__content {
    padding: 0px 10px;
}
</style>
