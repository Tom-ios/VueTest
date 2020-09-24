<template>
  <div ref="pageDiv" class="pageDiv">
    <ProjectSafeQAview module-flag="safe" :max-height="maxHeight" />
  </div>
</template>

<script>
import ProjectSafeQAview from './ProjectSafeQAview'
export default {
  components: {
    ProjectSafeQAview
  },
  data() {
    return {
      maxHeight: 400
    }
  },

  mounted() {
    this.$nextTick(() => {
      this.maxHeight = this.$refs.pageDiv.clientHeight - 100
    })
  }
}
</script>
<style scoped>
.pageDiv{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 0;
}
</style>
