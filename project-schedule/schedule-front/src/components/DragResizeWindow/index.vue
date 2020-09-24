<template>
  <vue-draggable-resizable
    v-show="visible"
    :parent="true"
    :active.sync="resizeactive"
    :handles="['br']"
    :w="w"
    :h="h"
    :x="x"
    :y="y"
    :z="10"
    :min-width="200"
    :min-height="200"
    :drag-handle="'.drag-handle'"
    :resizable="resizable"
    class="pmdialog dragDialog"
  >
    <div class="drag-handle">
      <span style="margin-left:10px">{{ title }}</span>
      <slot name="header" />
      <i class="el-icon-close closeBtn" @click="close" />
    </div>
    <div ref="scroll" class="dialog-content scroll-bar">
      <slot />
    </div>
  </vue-draggable-resizable>
</template>

<script>
import VueDraggableResizable from 'vue-draggable-resizable'

export default {
  components: {
    VueDraggableResizable
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    w: {
      type: Number,
      default: 300
    },
    h: {
      type: Number,
      default: 500
    },
    x: {
      type: Number,
      default: 0
    },
    y: {
      type: Number,
      default: 0
    },
    resizable: {
      type: Boolean,
      default: true
    },
    visible: {
      type: Boolean,
      default: false
    }

  },
  data() {
    return {
      resizeactive: true
    }
  },
  watch: {
    resizeactive(v) {
      if (v === false) {
        this.$nextTick(() => {
          this.resizeactive = true
        })
      }
    }
  },
  methods: {
    close() {
      this.$emit('update:visible', false)
    },
    setScrollTop(v) {
      this.$refs.scroll.scrollTop = v
    }
  }
}
</script>

<style>
.pmdialog.dragDialog{
  box-shadow: 0 1px 3px rgba(0,0,0,.3);
  z-index: 1
}
.pmdialog .drag-handle, .drag-cancel {
    height: 35px;
    width: 100%;
    position: absolute;
    cursor: move;
    font-size: 14px;
    line-height: 35px;
    background: white
}

.pmdialog .closeBtn{
  float: right;
  line-height: 35px;
  padding: 0 10px;
  cursor: pointer;
}

.pmdialog .handle-br {
  z-index: 999;
  position: absolute;
  width: 20px;
  height: 20px;
  bottom: 0;
  right: 0;
  background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAYAAAAGCAYAAADgzO9IAAAABGdBTUEAALGPC/xhBQAAAF5JREFUCB1jYEADq1at4r927dpOJmRxkKC+vv5ORkbGG3BxkODNmzdPXL9+fSJWwf///zNfvnx5CTNM+79//05qaGgUAXUtBeoQYARZBDJTU1MzH6SSiYlJaMaMGYEA7E42FFiHq5AAAAAASUVORK5CYII=);
  background-position: 100% 100%;
  padding: 0 3px 3px 0;
  background-repeat: no-repeat;
  background-origin: content-box;
  -webkit-box-sizing: border-box;
  box-sizing: border-box;
  cursor: se-resize;
}
@media only screen and (max-width: 768px) {
  [class*="handle-"]:before {
    content: '';
    left: -10px;
    right: -10px;
    bottom: -10px;
    top: -10px;
    position: absolute;
  }
}

.pmdialog .dialog-content{
  overflow: auto;
  position: absolute;
  padding: 10px;
  top: 35px;
  width: 100%;
  height: calc(100% - 35px);
  background: white
}

.pmdialog .scroll-bar::-webkit-scrollbar{
  width: 8px;
  height: 8px;
  border-radius: 5px;
  color: gray
}

.pmdialog .scroll-bar::-webkit-scrollbar-corner {
  background-color: transparent;
}

.pmdialog .scroll-bar::-webkit-scrollbar-thumb {
  border-radius: 5px;
  background-color: rgba(153,153,153,0.8);
}

.pmdialog .scroll-bar::-webkit-scrollbar-track {
  border-radius: 5px;
  /* background-color: rgba(102,102,102,0.2); */
}
</style>
