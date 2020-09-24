<template>
  <div ref="pageDiv" class="app-container">
    <TaskView ref="taskView" :is-projectover="isProjectover" :is-manager="isManager" :max-height="maxHeight" />
  </div>
</template>

<script>
import TaskView from './TaskView'
import { getRoleNamesFromProject, detail } from '@/api/project'
export default {
  name: 'ProjectProgressManage',
  components: {
    TaskView
  },
  data() {
    return {
      isManager: false,
      isProgressManage: false,
      isProjectover: false,
      maxHeight: 400

    }
  },

  mounted() {
    // 返回角色
    getRoleNamesFromProject(this.$route.params.id).then((res) => {
      const roleArr = res.split(',')
      this.isManager = roleArr.indexOf('项目经理') !== -1
      this.isProgressManage = roleArr.indexOf('项目经理') !== -1 || roleArr.indexOf('项目成员') !== -1
      if (this.isManager) {
        this.maxHeight = this.$refs.pageDiv.clientHeight - 135
      } else {
        this.maxHeight = this.$refs.pageDiv.clientHeight - 135
      }
    })
    detail(this.$route.params.id).then((res) => {
      if (res.projectOver) {
        this.isProjectover = true
      } else {
        this.isProjectover = false
      }
    })
  },
  methods: {
  }
}
</script>
<style  lang="scss" scoped>
.app-container{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 0;
}
</style>
