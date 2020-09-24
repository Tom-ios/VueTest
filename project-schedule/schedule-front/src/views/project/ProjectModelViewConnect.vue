<template>
  <DragResizeWindow
    v-loading="isConnect"
    :visible.sync="winVisible"
    :w="430"
    :h="530"
    :x="x"
    :y="y"
    element-loading-text=""
    element-loading-spinner="a"
    element-loading-background="rgba(255, 255, 255, 0.8)"
  >
    <div slot="header" class="progressHeader">
      <span style="position:relative;top:1px">关联模型</span>
      <i class="el-icon-close closeBtns" @click="close" />
      <div v-if="activeName==='taskView'" style="float:right;height:30px;margin-right:10px">
        <el-tooltip placement="bottom" effect="light">
          <div slot="content">
            <div v-for="(item,index) in workStateColor" :key="index">
              <div class="mt-10 clearfix">
                <div :style="{width:'15px',height:'15px',float:'left',background:item.color}" />
                <span class="ml-10">{{ item.title }}</span>
              </div>
            </div>
          </div>
          <div style="width:20px;height:30px;display:inline-block;position:relative;right:5px;">
            <svg-icon icon-class="i-question" />
          </div>
        </el-tooltip>
        <el-button :type="showProgressState?'':'primary'" size="mini" style="position:relative;top:-1px;" @click="clickShowState">{{ progressText }}</el-button>
      </div>
    </div>
    <el-tabs
      v-model="activeName"
      class="mt-10"
      type="card"
      @tab-click="handleClick"
    >

      <el-tab-pane label="任务" name="taskView">
        <ProjectModelViewConnectTab
          ref="taskView"
          :bim="bim"
          :is-manager="isManager"
          :is-projectover="isProjectover"
          :active-name="activeName"
          :show-progress-state="showProgressState"
          @connectModelChange="connectModelChange"
          @setObjColors="setObjColors"
          @resetInitArr="resetInitArr"
        />
      </el-tab-pane>
      <el-tab-pane label="质量工艺" name="quality">
        <ProjectModelViewConnectTab
          ref="quality"
          :bim="bim"
          :is-manager="isManager"
          :is-projectover="isProjectover"
          :active-name="activeName"
          :just-show-flow-connect-model="justShowFlowConnectModel"
          @connectModelChange="connectModelChange"
          @setObjColors="setObjColors"
          @resetInitArr="resetInitArr"
        />
      </el-tab-pane>
      <el-tab-pane label="安全风险点" name="safe">
        <ProjectModelViewConnectTab
          ref="safe"
          :bim="bim"
          :is-manager="isManager"
          :is-projectover="isProjectover"
          :active-name="activeName"
          :just-show-flow-connect-model="justShowFlowConnectModel"
          @connectModelChange="connectModelChange"
          @setObjColors="setObjColors"
          @resetInitArr="resetInitArr"
        />
      </el-tab-pane>
    </el-tabs>
  </DragResizeWindow>
</template>

<script>
import DragResizeWindow from '@/components/DragResizeWindow'
import ProjectModelViewConnectTab from './ProjectModelViewConnectTab'
export default {
  components: {
    DragResizeWindow,
    ProjectModelViewConnectTab
  },
  props: {
    bim: {
      type: Object,
      default: function() { return {} }
    },
    isManager: {
      type: Boolean,
      default: true
    },
    isProjectover: {
      type: Boolean,
      default: false
    },
    visible: {
      type: Boolean,
      default: false
    },
    x: {
      type: Number,
      default: 0
    },
    y: {
      type: Number,
      default: 0
    },
    treeData: {
      type: Array,
      default: function() { return [] }
    },
    justShowFlowConnectModel: {
      type: Boolean,
      default: false
    }

  },
  data() {
    return {
      winVisible: false,
      activeName: 'taskView',
      isConnect: false,
      showProgressState: false,
      progressText: '展示模型进度',
      workStateColor: [{
        title: '未开始(正常)',
        color: '#D7D7D7' }, {
        title: '进行中(提前)、进行中(正常)',
        color: '#C7EDCC' }, {
        title: '已完成(提前)、已完成(正常)',
        color: '#02830F' }, {
        title: '未开始(延迟)、进行中(延迟)、已完成(延迟)',
        color: '#FF0000' }
      ]
    }
  },
  watch: {
    showProgressState(v) {
      if (!v) {
        this.progressText = '展示模型进度'
      } else {
        this.progressText = '取消展示进度'
      }
    },
    isManager(v) {
    },
    isProjectover(v) {
    },
    winVisible(v) {
      this.$emit('update:visible', v)
    },
    visible(v) {
      this.winVisible = v
    }
  },
  mounted() {
  },
  methods: {
    close() {
      this.winVisible = false
    },
    resetInitArr() {
      this.$emit('resetInitArr')
    },
    setObjColors() {
      this.$emit('setObjColors')
    },
    connectModelChange(isConnect) {
      this.isConnect = isConnect
      this.$emit('connectModelChange', isConnect)
    },
    handleClick() {
      this.$emit('setObjColors')
      this.$emit('changeModule', { activeName: this.activeName })
    },
    clickShowState() {
      this.showProgressState = !this.showProgressState
    }
  }
}
</script>

<style lang="scss" scoped>

.progressHeader {
  border: 1px solid #EBEEF5;
  font-size:14px;
  background: #f5f7fa;
  line-height: 30px;
  margin-top:-35px;
  padding:0px 10px;
}
.ml-10 {
  margin-left:10px;
}
.mt-10 {
  margin-top:10px;
}
.closeBtns{
  float: right;
  line-height: 35px;
  padding: 0 10px;
  cursor: pointer;
}
</style>
