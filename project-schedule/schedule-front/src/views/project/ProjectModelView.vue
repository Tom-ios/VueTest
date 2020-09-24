<template>
  <div class="pageDiv clearfix">
    <div class="fillDiv">
      <div class="clearfix" style="margin-left:10px;margin-top:5px">
        <div :style="{'float':'left','color':activeName==='bimVisible'?'#409eff':'#303133'}" class="tabBorder" @click="handleClick('bimVisible')">
          BIM可视化浏览
        </div>
        <div :style="{'float':'left','margin-left':'5px','color': activeName==='modelFile'?'#409eff':'#303133','opacity':modelConnect?'0.4':'1'}" class="tabBorder" @click="handleClick('modelFile')">模型文件管理</div>

      </div>
      <BimVisible ref="bimVisibleModel" :style="{'height':activeName==='modelFile'?'0px':'calc(100% - 40px)','visibility':activeName==='modelFile'?'hidden':'visible'}" @modelConnectChange="modelConnectChange" />
      <projectModel v-show="activeName==='modelFile'" style="height:calc(100% - 40px)" />

    </div>

  </div>
</template>

<script>
import projectModel from './ProjectModel'
import BimVisible from './BimVisible'
export default {
  name: 'ProjectModelView',
  components: {
    projectModel,
    BimVisible
  },
  data() {
    return {
      activeName: 'bimVisible',
      modelConnect: false

    }
  },
  activated() {
    this.$refs.bimVisibleModel.$refs.progressModel.getListSetChart()
    this.$refs.bimVisibleModel.$refs.modelConnect.$refs[this.$refs.bimVisibleModel.$refs.modelConnect.activeName].getTreeList()
  },
  methods: {
    modelConnectChange({ isConnect }) {
      this.modelConnect = isConnect
    },
    handleClick(activeName) {
      if (this.modelConnect) {
        return
      }
      this.activeName = activeName
      if (this.activeName === 'bimVisible') {
        this.$nextTick(() => {
          if (this.$refs.bimVisibleModel.bim && this.$refs.bimVisibleModel.bim.surfer) {
            this.$refs.bimVisibleModel.bim.resize()
            this.$refs.bimVisibleModel.getModelList()
            this.$refs.bimVisibleModel.loadView()
          }
        })
      }
    }

  }
}
</script>
<style lang='scss' scoped>
.pageDiv{
   width: 100%;
  height: 100%;
  position:absolute;
  padding: 0;
}
.fillDiv{
 width: 100%;
  height: 100%;
}
/deep/ .el-tabs__content{
    overflow: hidden;
    height: 100%;
}
/deep/ .el-tabs__header {
    padding: 0;
    margin: 0 0 0px;
}
.tabBorder{
  border: 1px solid #e4e7ed;
  width:110px;
  height:35px;
  text-align: center;
  line-height: 35px;
  font-size: 14px;
  font-weight: 500;
}
</style>
