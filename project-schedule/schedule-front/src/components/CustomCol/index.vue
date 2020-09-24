<template>
  <div style="width:130px;font-size:15px;padding-left:5px">
    <el-button type="text" style="font-size:14px" @click="reset">恢复默认值</el-button>
    <div>
      <el-checkbox-group v-model="showCol" @change="handelSelect">
        <el-checkbox v-for="(selCol,index) in selectCol" :key="index" :label="selCol.label" :disabled="selCol.disabled" style="height:23px">{{ selCol.label }}</el-checkbox>
      </el-checkbox-group>
    </div>
    <div style="height:1px;margin-bottom:6px;border-bottom:solid 1px #ebeef5" />
    <div>
      <el-checkbox-group v-model="hideCol" @change="handelUnSelect">
        <el-checkbox v-for="(selCol,index) in unSelectCol" :key="index" :label="selCol.label" style="height:23px">{{ selCol.label }}</el-checkbox>
      </el-checkbox-group>
    </div>
  </div>
</template>

<script>
export default {
  name: 'CustomCol',
  props: {
    propAllCol: {
      type: Array,
      default: function() {
        return [{
          label: '名称',
          name: 'text',
          min_width: 200,
          tree: true,
          resize: true,
          align: 'left'
        },
        {
          label: '类型',
          name: 'taskMold',
          min_width: 50,
          align: 'center',
          resize: true
        },
        {
          label: '前置任务',
          name: 'taskPreCodes',
          min_width: 150,
          align: 'left',
          resize: true

        }
        ]
      }
    },
    propSelectCol: {
      type: Array,
      default: function() {
        return [{
          label: '名称',
          name: 'text',
          min_width: 200,
          tree: true,
          resize: true,
          align: 'left'
        },
        {
          label: '类型',
          name: 'taskMold',
          min_width: 50,
          align: 'center',
          resize: true
        }
        ]
      }
    }
  },
  data() {
    return {
      selectCol: [],
      unSelectCol: [],
      showCol: ['序号'],
      hideCol: []
    }
  },
  watch: {
    propAllCol: {
      handler: function(newV) {
        this.reset()
      },
      immediate: true
    }
  },
  methods: {
    handelSelect(arr) {
      this.selectCol = []
      this.unSelectCol = []
      this.propAllCol.forEach(allItem => {
        let isExit = false
        arr.forEach(label => {
          if (allItem.label === label) {
            this.selectCol.push(allItem)
            isExit = true
          }
        })
        if (!isExit) {
          this.unSelectCol.push(allItem)
        }
      })
      this.$emit('selectCol', this.showCol)
    },
    handelUnSelect(arr) {
      this.propAllCol.forEach(allItem => {
        this.hideCol.forEach(label => {
          if (allItem.label === label) {
            this.selectCol.push(allItem)
            this.showCol.push(label)
          }
        })
      })
      this.unSelectCol = []
      var tmpArr = []
      this.propAllCol.forEach(allItem => {
        let isExit = false
        this.selectCol.forEach(selItem => {
          if (allItem.label === selItem.label) {
            tmpArr.push(allItem)
            isExit = true
          }
        })
        if (!isExit) {
          this.unSelectCol.push(allItem)
        }
      })
      this.hideCol = []
      // 按全部的初始顺序调整选中调整顺序
      this.selectCol = [...tmpArr]
      this.$emit('selectCol', this.showCol)
    },
    reset() {
      this.selectCol = []
      this.unSelectCol = []
      this.hideCol = []
      this.showCol = []
      this.propAllCol.forEach(allItem => {
        let isExit = false
        this.propSelectCol.forEach(selectItem => {
          if (allItem.label === selectItem.label) {
            this.selectCol.push(allItem)
            this.showCol.push(allItem.label)
            isExit = true
          }
        })
        if (!isExit) {
          this.unSelectCol.push(allItem)
        }
      })
      this.$emit('selectCol', this.showCol)
    }
  }
}
</script>
<style lang="scss" scoped >
 /deep/ .el-checkbox__input.is-checked+.el-checkbox__label {
    color: #606266;
}
</style>
