<template>
  <div class="dashboard-container" />
</template>

<script>
import { mapGetters } from 'vuex'
import { getList } from '@/api/project'
export default {
  name: 'Dashboard',
  data() {
    return {
      path: '',
      projectList: []
    }
  },
  computed: {
    ...mapGetters([
      'permission_routes',
      'name'
    ])
  },
  watch: {
    'permission_routes': {
      handler: function(val) {
        getList().then(res => {
          if (res && res.rows) {
            this.projectList = res.rows
          }
          this.toPath(val, '')
        })
      },
      immediate: true
    }
  },
  methods: {
    toPath(arr, parentPath) {
      for (const item of arr) {
        if (item.children && item.children.length > 0) {
          if (this.toPath(item.children, item.path)) {
            return true
          }
        } else if (item.name && !item.hidden) {
          this.path = parentPath + '/' + item.path
          if (this.path === '/project/list' && this.projectList.length === 1) {
            this.path = '/projectSet/setPeople/' + this.projectList[0].id
          }
          this.$router.push(this.path)
          return true
        }
      }
      return false
    }
  }
}
</script>

<style lang="scss" scoped>
.dashboard {
  &-container {
    margin: 30px;
  }
  &-text {
    font-size: 30px;
    line-height: 46px;
  }
}
</style>
