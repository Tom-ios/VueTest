<template>
  <div ref="reourceDiv" class="clearfix pageDiv">
    <el-tabs
      v-model="activeName"
      class="h_percent100"
      @tab-click="handleClick"
    >
      <el-tab-pane label="wbs编码" name="wbscode" class="h_percent100">
        <WbsCode v-if="wbsCodeList" :to-wbs-code-edit="toWbsCodeEdit" />
        <WbsCodeEdit v-if="!wbsCodeList" :to-wbs-code-list="toWbsCodeList" :wbs-code-id="wbsCodeId" :wbs-code-copy="wbsCodeCopy" />
      </el-tab-pane>
      <el-tab-pane label="费用科目编码" name="expensescourse" class="h_percent100">
        <ExpensesCourse v-if="expensesCourseList" :to-expenses-course-edit="toExpensesCourseEdit" />
        <ExpensesCourseEdit v-if="!expensesCourseList" :to-expenses-course-list="toExpensesCourseList" :wbs-code-id="wbsCodeId" :wbs-code-copy="wbsCodeCopy" />
      </el-tab-pane>
    </el-tabs>

  </div>
</template>

<script>
import WbsCode from './WbsCode.vue'
import WbsCodeEdit from './WbsCodeEdit.vue'
import ExpensesCourse from './ExpensesCourse.vue'
import ExpensesCourseEdit from './ExpensesCourseEdit.vue'
export default {
  components: {
    WbsCode,
    WbsCodeEdit,
    ExpensesCourse,
    ExpensesCourseEdit
  },
  props: {
    tabName: {
      type: String,
      default: ''
    }

  },
  data() {
    return {
      activeName: 'wbscode',
      wbsCodeList: true,
      wbsCodeId: '',
      expensesCourseList: true,
      // expensesCourseId: '',
      wbsCodeCopy: ''
    }
  },
  watch: {
    tabName(v) {
      if (v === 'codeRuleTem') {
        //
      }
    }

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
    toWbsCodeEdit(id, type) {
      this.wbsCodeId = id
      if (type === 'copy') {
        this.wbsCodeCopy = '1'
      } else {
        this.wbsCodeCopy = '0'
      }
      this.wbsCodeList = false
    },
    toWbsCodeList() {
      this.activeName = 'wbscode'
      this.wbsCodeList = true
    },
    toExpensesCourseEdit(id, type) {
      this.wbsCodeId = id
      if (type === 'copy') {
        this.wbsCodeCopy = '1'
      } else {
        this.wbsCodeCopy = '0'
      }
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
.pageDiv{
  width: 100%;
  height: 100%;
  position: absolute;
}
.h_percent100{
  height:100%
}
/deep/ .el-tabs__content {
    position: relative;
    height: calc(100% - 22px) ;
}
/deep/ .el-tabs--border-card>.el-tabs__content {
    padding: 0px 10px;
}
</style>
