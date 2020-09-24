<template>
  <div id="app">
    <router-view />
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
#app{
  overflow-x: hidden
}
/* 解决屏幕放大表头的线不齐的问题 */
.el-table--border th.gutter:last-of-type {
    display: block!important;
    width: 17px!important;
}
</style>
