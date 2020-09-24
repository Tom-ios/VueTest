<template>
  <div ref="pageDiv" class="pageDiv">
    <el-tabs
      v-model="activeName"
      type="border-card"
      class="h-100"
      @tab-click="handleClick"
    >
      <el-tab-pane label="编码规则模板" name="codeRuleTem" class="h-100">
        <CodeRule :tab-name="activeName" class="h-100" />
      </el-tab-pane>
      <el-tab-pane label="日历模板" name="calendarTem" class="h-100" style="overflow:auto">
        <CalendarTemplate />
      </el-tab-pane>
      <el-tab-pane label="wbs模板" name="wbsTem" class="h-100">
        <WbsTemplateList v-if="templateList" ref="templateListPage" :to-template-edit="toTemplateEdit" />
        <WbsTemplateEdit v-if="!templateList" :to-template-list="toTemplateList" :template-id="templateId" :template-copy="templateCopy" />
      </el-tab-pane>
      <el-tab-pane label="作业模板" name="taskTem" class="h-100">
        <TaskTemplate />
      </el-tab-pane>
      <el-tab-pane label="费用科目模板" name="ExpenseAccountTem" class="h-100" style="overflow:auto">
        <ExpenseAccountTemplate />
      </el-tab-pane>
    </el-tabs>
  </div>
</template>

<script>
import WbsTemplateList from '../wbs/WbsTemplateList.vue'
import WbsTemplateEdit from '../wbs/WbsTemplateEdit.vue'
import CodeRule from './resource/CodeRule.vue'
import CalendarTemplate from './calendarTemplate/calendarTemplate.vue'
import TaskTemplate from '@/views/task/Template.vue'
import ExpenseAccountTemplate from './expenseAccountTemplate/expenseAccountTemplate.vue'
export default {
  name: 'SystemSet',
  components: {
    WbsTemplateList,
    WbsTemplateEdit,
    CodeRule,
    CalendarTemplate,
    ExpenseAccountTemplate,
    TaskTemplate
  },
  data() {
    return {
      activeName: 'codeRuleTem',
      templateList: true,
      templateId: '',
      templateCopy: ''
    }
  },
  methods: {
    mounted() {

    },
    create() {

    },
    handleClick(tab, event) {
      if (this.activeName === 'wbsTem') {
        // this.$nextTick(() => {
        //   this.maxHeight = this.$refs.pageDiv.clientHeight - 13
        // })
      }
    },
    toTemplateEdit(id, type) {
      this.templateId = id
      if (type === 'copy') {
        this.templateCopy = '1'
      }
      this.templateList = false
    },
    toTemplateList() {
      this.activeName = 'wbsTem'
      this.templateList = true
      // this.$nextTick(() => {
      //   this.maxHeight = this.$refs.pageDiv.clientHeight - 13
      // })
    }
  }
}
</script>
<style scoped lang="scss">
.pageDiv{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 10px 10px;
}
/deep/ .el-tabs__content {
    // flex-grow: 1;
    // overflow-y: scroll;
    position: relative;
    height: calc(100% - 22px) ;
}
/deep/ .el-tabs--border-card>.el-tabs__content {
    padding: 0px 0px;
}
.h-100 {
  height:100%
}
</style>
