<template>
  <div class="clearfix">
    <div ref="WholeLeft" class="clearfix WholeLeft">
      <div class="progressHeader">
        <span>{{ leftTitle }}</span>
      </div>
      <div style="float:left">
        <div class="h-30">{{ leftTreeTitle }}</div>
        <div class="mouduleDiv">
          <slot name="leftTreeUp" />
          <div class="treeDiv">
            <el-tree
              ref="leftTree"
              :data="leftTreeData"
              :props="leftProps"
              :empty-text="leftEmptyText"
              node-key="id"
              default-expand-all
              :highlight-current="showHigh"
              @node-click="handleLeftNodeClick"
            />
          </div>
        </div>
      </div>
      <div style="float:left;margin-left:10px">
        <div class="h-30">{{ rightTreeTitle }}</div>
        <div class="midMouduleDiv">
          <div slot="midTreeUp" class="mt-10">
            <span class="ml-10"> 名称</span>
            <el-input v-model="midQuery[midName]" placeholder="" size="small" style="width: 170px;margin-left:5px" clearable @keyup.enter.native="search('mid')" />
            <el-button type="primary" class="ml-10" size="mini" @click="search('mid')">查询</el-button>
          </div>

          <div class="treeDiv">
            <el-tree
              ref="midTree"
              :data="midTreeData"
              :props="midProps"
              :empty-text="midEmptyText"
              default-expand-all
              node-key="id"
              :filter-node-method="filterMidNode"
            >
              <span slot-scope="{ node, data }" class="custom-tree-node">
                <span>{{ node.label }}</span>
                <span v-if="data[rightNodeType]=='1'">
                  <el-button
                    type="text"
                    size="mini"
                    @click="() => remove(node, data)"
                  >
                    删除
                  </el-button>
                </span>
              </span>
            </el-tree>
          </div>
        </div>
      </div>
    </div>
    <el-button type="primary" size="mini" style="float:left;margin-left:10px;margin-top:200px;margin-right:10px" :disabled="connectDisabled" @click="connect">关联</el-button>
    <div ref="wholeRight" class="clearfix wholeRight">
      <div class="progressHeaderRight">
        <span>{{ rightTitle }}</span>
      </div>
      <div class="h-30" />
      <div class="midMouduleDiv">
        <div slot="rightTreeUp" class="mt-10">
          <span class="ml-10"> 名称</span>
          <el-input
            v-model="rightQuery[rightName]"
            placeholder=""
            size="small"
            style="width: 170px;margin-left:5px"
            clearable
            @keyup.enter.native="search('right')"
          />
          <el-button
            type="primary"
            class="ml-10"
            size="mini"
            @click="search('right')"
          >查询</el-button>
        </div>
        <div slot="rightTreeUp" />
        <div class="treeDiv">
          <el-tree
            ref="rightTree"
            node-key="id"
            :filter-node-method="filterRightNode"
            :data="rightTreeData"
            :props="rightProps"
            :empty-text="rightEmptyText"
            show-checkbox
            default-expand-all
            @check-change="handleCheckChange"
          />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getTreeData } from '@/api/progressManage'
export default {
  components: {
  },
  props: {
    leftProps: {
      type: Object,
      default: function() {
        return {
          children: 'children',
          label: 'label'
        }
      }
    },
    leftTreeUrl: {
      type: String,
      default: ''
    },
    rightTreeUrl: {
      type: String,
      default: ''
    },
    // 左侧树节点类型 （父子 0 -父 1-子）
    leftNodeType: {
      type: String,
      default: 'nodeType'
    },
    // 右侧树节点类型 （父子 0 -父 1-子）
    rightNodeType: {
      type: String,
      default: 'nodeType'
    },
    // 右方的树的属性
    rightProps: {
      type: Object,
      default: function() {
        return {
          children: 'children',
          label: 'label'
        }
      }
    },
    leftTitle: {
      type: String,
      default: '流水段关联构件类'
    },
    rightTitle: {
      type: String,
      default: '目录树'
    },
    leftTreeTitle: {
      type: String,
      default: '流水段列表'
    },
    rightTreeTitle: {
      type: String,
      default: '关联构件类'
    },
    // 中间的树的属性
    midProps: {
      type: Object,
      default: function() {
        return {
          children: 'children',
          label: 'label'
        }
      }
    },
    leftData: {
      type: Array,
      default: function() { return [] }
    },
    rightData: {
      type: Array,
      default: function() { return [] }
    },
    // 搜索输入框字段
    leftName: {
      type: String,
      default: ''
    },
    midName: {
      type: String,
      default: ''
    },
    rightName: {
      type: String,
      default: ''
    },
    leftQuery: {
      type: Object,
      default: function() { return {} }
    },
    midQuery: {
      type: Object,
      default: function() { return {} }
    },
    rightQuery: {
      type: Object,
      default: function() { return {} }
    },
    leftEmptyText: {
      type: String,
      default: '暂无数据'
    },
    midEmptyText: {
      type: String,
      default: '暂无数据'
    },
    rightEmptyText: {
      type: String,
      default: '请选择流水段'
    },
    bShowHigh: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      leftTreeData: [],
      rightTreeData: [],
      midTreeData: [],
      midArrData: [],
      hasParentRightData: [],
      connectDisabled: true,
      showHigh: true,
      leftCurNode: null
    }
  },
  watch: {
    leftData: {
      handler(newV) {
        this.leftTreeData = newV
      },
      deep: true
    },
    rightData: {
      handler(newV) {
        this.rightTreeData = newV
      }
    },
    bShowHigh(v) {
      this.showHigh = v
    }
  },
  mounted() {
    this.getData()
  },

  methods: {
    filterMidNode(value, data) {
      if (!value) return true
      return data.label.indexOf(value) !== -1
    },
    filterRightNode(value, data) {
      if (!value) return true
      return data[this.rightName].indexOf(value) !== -1
    },
    remove(node, data) {
      this.$emit('delMidNode', { leftCurNode: this.leftCurNode, data })
      this.$refs.rightTree.setChecked(data, false)
      this.$refs.midTree.remove(node)
      this.findTree(this.midTreeData, (treeElement) => {
        // eslint-disable-next-line eqeqeq
        if (treeElement.children && treeElement.children.length === 0 && treeElement[this.rightNodeType] == '0') {
          this.remove(this.$refs.midTree.getNode(treeElement.id), treeElement)
        }
      })

      var halfKeys = this.$refs['rightTree'].getHalfCheckedKeys()
      // 过滤数据 去重只要子节点的key
      this.findTree(this.rightTreeData, element => {
        if (element.id === data.id) {
          element.disabled = false
        }
        halfKeys.forEach(key => {
          if (element.id === key) {
            element.disabled = false
          }
        })
      })
    },

    handleCheckChange(data, checked, indeterminate) {
      this.$emit('handelLeftCheckChange', { data, checked, indeterminate })
    },
    isEqual() {
      const originKeys = this.$refs['rightTree'].getCheckedKeys()
      // 过滤数据 去重只要子节点的key
      var keys = []
      var keysPath = []
      this.findTree(this.rightTreeData, (item) => {
        originKeys.forEach(key => {
          // eslint-disable-next-line eqeqeq
          if (item.id === key && item[this.rightNodeType] == '1') {
            keys.push(item.id)
            var pathArr = this.getPath(key, []) || []
            pathArr.push(key)
            keysPath.push(pathArr)
          }
        })
      })
      // 合并 去重
      var allArr = []
      keysPath.forEach(arr => {
        allArr = [...allArr, ...arr]
      })
      allArr = [...new Set(allArr)]
      var arrData = []
      allArr.forEach(id => {
        var dict = {}
        this.findTree(this.rightTreeData, (treeElement) => {
          if (treeElement.id === id) {
            dict = { id: treeElement.id, parentId: treeElement.parentId, label: treeElement[this.rightName], [this.rightNodeType]: treeElement[this.rightNodeType] }
          }
        })
        arrData.push(dict)
      })
      var tmpData = this.convertToTreeData(arrData)
      return JSON.stringify(tmpData) === JSON.stringify(this.midTreeData)
    },
    changeLeftNode(keys) {
      const curSelKeys = this.$refs.rightTree.getCheckedKeys(true)
      this.$refs.rightTree.setCheckedKeys(curSelKeys, false)
      this.findTree(this.rightTreeData, element => {
        if (element.disabled) {
          element.disabled = false
        }
      })
      this.$refs.rightTree.setCheckedKeys(keys, true)
      this.initMidTreeForKeys()
    },
    connect() {
      this.connectDisabled = true
      this.initMidTreeForKeys()
    },
    initMidTreeForKeys() {
      const originKeys = this.$refs['rightTree'].getCheckedKeys()
      var keys = []
      var keysPath = []
      this.findTree(this.rightTreeData, (item) => {
        originKeys.forEach(key => {
          // eslint-disable-next-line eqeqeq
          if (item.id === key && item[this.rightNodeType] == '1') {
            keys.push(item.id)
            var pathArr = this.getPath(key, []) || []
            pathArr.push(key)
            keysPath.push(pathArr)
          }
          if (item.id === key) {
            this.$set(item, 'disabled', true)
          }
        })
      })
      // 合并 去重
      var allArr = []
      keysPath.forEach(arr => {
        allArr = [...allArr, ...arr]
      })
      allArr = [...new Set(allArr)]
      this.midArrData = []
      allArr.forEach(id => {
        var dict = {}
        this.findTree(this.rightTreeData, (treeElement) => {
          if (treeElement.id === id) {
            dict = { id: treeElement.id, parentId: treeElement.parentId, label: treeElement[this.rightName], [this.rightNodeType]: treeElement[this.rightNodeType] }
          }
        })
        this.midArrData.push(dict)
      })
      this.midTreeData = this.convertToTreeData(this.midArrData)
      this.$emit('connectTree', keys)
    },
    convertToTreeData(data, pid) {
      const result = []
      let temp = []
      for (let i = 0; i < data.length; i++) {
        if (data[i].parentId === pid) {
          const obj = { ...data[i] }
          temp = this.convertToTreeData(data, data[i].id)
          if (temp.length > 0) {
            obj.children = temp
          }
          result.push(obj)
        }
      }
      return result
    },

    getPath(id, pathArr) {
      pathArr = JSON.parse(JSON.stringify(pathArr))
      var parentId = ''
      this.findTree(this.rightTreeData, (element) => {
        if (element.id === id) {
          parentId = element.parentId
        }
      })
      if (parentId) {
        pathArr.push(parentId)
        pathArr = this.getPath(parentId, pathArr)
      }

      return pathArr
    },

    getData() {
      if (this.leftTreeUrl) {
        this.getleftTreeData()
      } else {
        this.leftTreeData = this.leftData
      }
      if (this.rightTreeUrl) {
        this.getRightTreeData()
      } else {
        this.rightTreeData = this.rightData
      }
    },
    getParentIdFromTreeData(array) {
      this.findTree(array, (element) => {
        if (element.children && element.children.length > 0) {
          element[this.rightNodeType] = '0'
          const childrenArr = element.children
          childrenArr.forEach(childItem => {
            childItem.parentId = element.id
            childItem[this.rightNodeType] = '1'
          })
        } else {
          element[this.rightNodeType] = '1'
        }
      })
      return array
    },
    search(flag) {
      if (flag === 'left') {
        if (this.leftTreeUrl) {
          this.getleftTreeData()
        } else {
          this.$refs.leftTree.filter(this.leftQuery[this.leftName])
          this.$emit(flag)
        }
      } else if (flag === 'mid') {
        this.$refs.midTree.filter(this.midQuery[this.midName])
      } else if (flag === 'right') {
        if (this.rightTreeUrl) {
          this.getRightTreeData()
        } else {
          this.$refs.rightTree.filter(this.rightQuery[this.rightName])
          this.$emit(flag)
        }
      }
    },
    handleLeftNodeClick(data) {
      if ((data.children && data.children.length > 0) || data[this.leftNodeType] === 0) {
        if (this.leftCurNode) {
          this.$refs.leftTree.setCurrentKey(this.leftCurNode.id)
          this.$refs.leftTree.setCurrentNode(this.leftCurNode)
        }
      } else {
        this.leftCurNode = data
        this.$emit('handleLeftNodeClick', this.leftCurNode)
      }
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    getleftTreeData() {
      var requestData = {
        projectId: this.$route.params.id
      }
      requestData = { ...requestData, ...this.leftQuery }
      getTreeData(this.leftTreeUrl, requestData, 'post').then(res => {
        if (res) {
          this.findTree(res, (item) => {
            this.leftTreeData = res
          })
        } else {
          this.leftTreeData = []
        }
      }).catch(() => {
        this.loading = false
      })
    },
    getRightTreeData() {
      getTreeData(this.rightTreeUrl, this.rightQuery).then(res => {
        if (res) {
          if (res) {
            this.rightTreeData = this.getParentIdFromTreeData(JSON.parse(res.content))
          } else {
            this.rightTreeData = []
          }
        } else {
          this.rightTreeData = []
        }
      }).catch(() => {
        this.loading = false
      })
    }
  }
}
</script>
<style scoped>
.progressHeader {
  border: 1px solid #EBEEF5;
  font-size:14px;
  background: #f5f7fa;
  height:35px;
  line-height: 35px;
  width:730px
}
.progressHeaderRight{
  border: 1px solid #EBEEF5;
  font-size:14px;
  background: #f5f7fa;
  height:35px;
  line-height: 35px;
  width:300px
}
.mouduleDiv {
  border: 1px solid #EBEEF5;
  width:420px
}
.midMouduleDiv {
  border: 1px solid #EBEEF5;
  width:300px
}
.treeDiv {
  margin-top:10px;
  height:300px;
  overflow: auto;

}
.ml-10 {
  margin-left:10px;
}
.mr-10 {
  margin-right:20px;
}
.mr-20 {
  margin-right:20px;
}
.ml-20 {
  margin-left:20px;
}
.mt-10{
  margin-top:10px;
}
.mt-20{
  margin-top:20px;
}
.h-30{
  height:40px;
  line-height: 40px;
}
.WholeLeft{
  width:730px;
  float:left;
}
.wholeRight{
  width:300px;
  float:left;
}
  .custom-tree-node {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 14px;
    padding-right: 8px;
  }
</style>
