<template>
  <div id="system_resource" class="clearfix pageDiv">
    <Account v-if="roleIds ==='01'" style="height:100%" />
    <Human v-else style="height:100%;padding:10px 10px;" />
  </div>
</template>
<script>
import Human from './Human'
import Account from '@/views/account/index'
import { getRoleIds } from '@/api/user'
export default {
  components: {
    Human,
    Account
  },
  data() {
    return {
      roleIds: ''
    }
  },
  created() {
    getRoleIds().then(res => {
      this.roleIds = res
    })
  }
}
</script>
<style lang="scss" scoped>
 #system_resource.pageDiv{
  width: 100%;
  height: 100%;
  position: absolute;
}
#system_resource  /deep/ .el-tabs__content {
    // flex-grow: 1;
    // overflow-y: scroll;
    position: relative;
    height: calc(100% - 22px) ;
}
 #system_resource /deep/ .el-tabs--border-card>.el-tabs__content {
    padding: 0px 10px;
}
</style>
