<template>
  <div ref="pageDiv" class="pageDiv">
    <WbsTemplateList v-if="templateList" ref="templateListPage" :to-template-edit="toTemplateEdit" />
    <WbsTemplateEdit v-if="!templateList" :to-template-list="toTemplateList" :template-id="templateId" :template-copy="templateCopy" />
  </div>
</template>

<script>
import WbsTemplateList from '../wbs/WbsTemplateList.vue'
import WbsTemplateEdit from '../wbs/WbsTemplateEdit.vue'
export default {
  name: 'SystemSet',
  components: {
    WbsTemplateList,
    WbsTemplateEdit
  },
  data() {
    return {
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
    }
  }
}
</script>
<style scoped lang="scss">

</style>
