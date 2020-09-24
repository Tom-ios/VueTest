<template>
  <div id="reourceDiv" ref="reourceDiv" class="clearfix pageDiv">
    <el-tabs
      v-model="activeName"
      class="h_percent100"
      @tab-click="handleClick"
    >
      <el-tab-pane label="人力" name="human" class="h_percent100">
        <Human ref="human" :limit-enable-select="limitEnableSelect" :show-tree-tool-bar="showTreeToolBar" :key-word="keyWord" :select-type="selectType" :cur-sel-rows="humanSelArr" :list-max-height="maxHeight" :listurl="listurl" :type-url="typeUrl" />
      </el-tab-pane>
      <el-tab-pane label="材料" name="material" class="h_percent100">
        <DeviceMaterial
          ref="material"
          :limit-enable-select="limitEnableSelect"
          :show-tree-tool-bar="showTreeToolBar"
          :key-word="keyWord"
          :select-type="selectType"
          :cur-sel-rows="materialSelArr"
          type="material"
          :active-name="activeName"
          :list-max-height="maxHeight"
          :listurl="listurl"
          :type-url="typeUrl"
        />
      </el-tab-pane>
      <el-tab-pane label="设备" name="device" class="h_percent100">
        <DeviceMaterial
          ref="device"
          :limit-enable-select="limitEnableSelect"
          :show-tree-tool-bar="showTreeToolBar"
          :key-word="keyWord"
          :select-type="selectType"
          :cur-sel-rows="deviceSelArr"
          type="device"
          :active-name="activeName"
          :list-max-height="maxHeight"
          :listurl="listurl"
          :type-url="typeUrl"
        />
      </el-tab-pane>
    </el-tabs>

  </div>
</template>

<script>
import Human from './Human'
import DeviceMaterial from './DeviceMaterial'
export default {
  components: {
    Human,
    DeviceMaterial
  },
  props: {
    showTreeToolBar: {
      type: Boolean,
      default: false
    },
    limitEnableSelect: {
      type: Boolean,
      default: true
    },
    selectType: {
      type: String,
      default: ''
    },
    curSelRows: {
      type: Array,
      default: function() { return [] }
    },
    tabName: {
      type: String,
      default: ''
    },
    keyWord: {
      type: String,
      default: 'id'
    },
    listurl: {
      type: String,
      default: ''
    },
    typeUrl: {
      type: String,
      default: ''
    }

  },
  data() {
    return {
      activeName: 'human',
      maxHeight: 0,
      humanSelArr: [],
      materialSelArr: [],
      deviceSelArr: []
    }
  },
  watch: {
    limitEnableSelect(v) {
      console.log('tag----000', this.limitEnableSelect)
    },
    tabName(v) {
      if (v === 'resourceTem') {
        this.maxHeight = this.$refs.reourceDiv.clientHeight - 205
      }
    },
    curSelRows: {
      handler(v, ddd) {
        if (v) {
          this.orgData()
        }
      },
      immediate: true,
      deep: true
    }
  },
  mounted() {
    console.log('tag----', this.limitEnableSelect)
  },
  methods: {
    orgData() {
      this.humanSelArr = []
      this.materialSelArr = []
      this.deviceSelArr = []
      this.curSelRows.forEach(element => {
        if (element.resType === '1') {
          this.humanSelArr.push(element)
        } else if (element.resType === '2') {
          this.materialSelArr.push(element)
        } else if (element.resType === '3') {
          this.deviceSelArr.push(element)
        }
      })
    },
    handleClick() {
      this.$emit('resourceTypeChange', { 'activeName': this.activeName })
    },
    cancelSel() {
      this.$refs.human.cancelSel()
      this.$refs.material.cancelSel()
      this.$refs.device.cancelSel()
    }
  }
}
</script>
<style lang="scss" scoped>
 #reourceDiv.pageDiv{
  width: 100%;
  height: 100%;
  position: absolute;
  padding:0px 10px;
}
#reourceDiv .h_percent100{
  height:100%
}
#reourceDiv /deep/ .el-tabs--border-card>.el-tabs__content {
    padding: 0px 0px;
}
 #reourceDiv /deep/ .el-tabs__content {
    // flex-grow: 1;
    position: relative;
    height: calc(100% - 50px) ;
}
</style>
