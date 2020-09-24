<template>
  <div
    v-loading="connectLoading"
    class="clearfix"
    element-loading-background="rgba(255, 255, 255, 0.8)"
  >

    <div v-if="curBussinessObj.pathName" class="progressHeader">
      <span>{{ rightTreeTitle }}</span>
      <span>{{ curBussinessObj.pathName }}</span>
    </div>
    <div ref="WholeLeft" class="clearfix WholeLeft">
      <div style="float:left">
        <div class="h-30">{{ leftTitle }}</div>
        <div class="mouduleDiv">
          <div class="mt-10">
            <span class="ml-10"> 名称</span>
            <el-input
              v-model="leftQuery[leftName]"
              placeholder=""
              size="small"
              style="width: 170px;margin-left:5px"
              clearable
              @keyup.enter.native="search('left')"
            />
            <el-button
              type="primary"
              class="ml-10"
              size="mini"
              @click="search('left')"
            >查询</el-button>
          </div>
          <slot name="leftTreeUp" />
          <div class="treeDiv">
            <el-tree
              ref="leftTree"
              :data="leftTreeData"
              :props="leftProps"
              :empty-text="leftEmptyText"
              node-key="id"
              default-expand-all
              show-checkbox
              :highlight-current="showHigh"
              @check-change="handleCheckChange"
              @node-click="handleLeftNodeClick"
            />
          </div>
        </div>
      </div>
    </div>
    <div style="float:left;margin-left:10px;margin-top:200px;margin-right:10px;width:80px">
      <el-button type="primary" size="mini" style="margin-left:6px" @click="connect">关联</el-button>
      <el-button type="primary" size="mini" style="margin-left:-5px;margin-top:10px" @click="cancelConnect">取消关联</el-button>
    </div>
    <div ref="wholeRight" class="clearfix wholeRight">
      <div class="h-30">{{ rightTitle }}</div>
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
            show-checkbox
            :filter-node-method="filterRightNode"
            :data="rightTreeData"
            :props="rightProps"
            :empty-text="rightEmptyText"
            default-expand-all
            @check-change="handleRightCheckChange"
            @node-click="handleRightNodeClick"
          >
            <span slot-scope="{ node,data}" class="custom-tree-node">
              <span :style="{'color':data.color}">{{ node.label }}</span>
            </span>
          </el-tree>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getTreeData } from '@/api/progressManage'
import { getDetail, connectTask } from '@/api/ProjectQaOrSafe'
export default {
  components: {
  },
  props: {
    showConnectTree: {
      type: Boolean,
      default: false
    },
    curBussinessObj: {
      type: Object,
      default: function() { return {} }
    },
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
      default: 'bimserver/bimProjectTask/getProjectTask'
    },
    rightTreeUrl: {
      type: String,
      default: ''
    },
    // 左侧树节点类型 （父子 0 -父 1-子）
    leftNodeType: {
      type: String,
      default: 'leafNodec'
    },
    // 右侧树节点类型 （父子 0 -父 1-子）
    rightNodeType: {
      type: String,
      default: 'leafNode'
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
      default: '任务列表'
    },
    rightTitle: {
      type: String,
      default: '已关联任务列表'
    },
    leftTreeTitle: {
      type: String,
      default: '流水段列表'
    },
    rightTreeTitle: {
      type: String,
      default: '名称:'
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
      default: 'taskName'
    },
    midName: {
      type: String,
      default: ''
    },
    rightName: {
      type: String,
      default: 'label'
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
      default: '请在【进度管理】中导入进度计划'
    },
    midEmptyText: {
      type: String,
      default: '暂无数据'
    },
    rightEmptyText: {
      type: String,
      default: '请选择关联任务'
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
      rightArrData: [],
      hasParentRightData: [],
      connectDisabled: true,
      showHigh: true,
      leftCurNode: null,
      selectedId: [],
      connectLoading: false,
      taskList: [],
      key: []
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
    },
    showConnectTree(v) {
      if (v) {
        this.setSelect()
      }
    },
    curBussinessObj: {
      handler(newV) {
        console.log('-------', newV)
      },
      deep: true
    }
  },
  mounted() {
    this.getData()
    this.setSelect()
  },

  methods: {
    setSelect() {
      this.connectLoading = true
      var selectKey = []
      this.getleftTreeData(() => {
        getDetail({ id: this.curBussinessObj.id }).then(res => {
          if (res) {
            res.forEach(element => {
              if (element.taskId && element.types === '2') {
                this.$refs.leftTree.setChecked(element.taskId, true)
              }

              if (element.types === '1') {
                selectKey = element.selectedId.split(',')
              }
            })
            this.initMidTreeForKeys()
            this.findTree(this.rightTreeData, (rightItem) => {
              selectKey.forEach(key => {
                if (rightItem.id === key) {
                  this.$refs.leftTree.setChecked(rightItem.id, true)
                  this.$set(rightItem, 'color', 'blue')
                }
              })
            })
          }
          this.connectLoading = false
        })
      })
    },
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
      var bExit = false
      for (let i = 0; i < this.selectedId.length; i++) {
        if (this.selectedId[i] === data.id) {
          bExit = true
          if (!checked) {
            this.selectedId.splice(i, 1)
            i--
          }
        }
      }
      if (!bExit && checked) {
        this.selectedId.push(data.id)
      }
      this.$emit('handelLeftCheckChange', { data, checked, indeterminate })
    },
    handleRightCheckChange(data, checked, indeterminate) {
      var bExit = false
      for (let i = 0; i < this.selectedId.length; i++) {
        if (this.selectedId[i] === data.id) {
          bExit = true
          if (checked) {
            this.selectedId.splice(i, 1)
            i--
          }
        }
      }
      if (!bExit && !checked) {
        this.selectedId.push(data.id)
      }
      this.$emit('handelReftCheckChange', { data, checked, indeterminate })
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
      // this.connectDisabled = true
      this.initMidTreeForKeys()
      const requestData = { ...this.curBussinessObj }
      requestData.taskList = this.taskList
      requestData.selectedId = this.selectedId.join(',')
      this.connectLoading = true
      var selectKey = []
      connectTask(requestData).then(res => {
        this.getleftTreeData(() => {
          getDetail({ id: this.curBussinessObj.id }).then(res => {
            if (res) {
              res.forEach(element => {
                if (element.taskId && element.types === '2') {
                  this.$refs.leftTree.setChecked(element.taskId, true)
                }
                if (element.types === '1') {
                  selectKey = element.selectedId.split(',')
                }
              })
              this.initMidTreeForKeys()
              this.findTree(this.rightTreeData, (rightItem) => {
                selectKey.forEach(key => {
                  if (rightItem.id === key) {
                    this.$refs.leftTree.setChecked(rightItem.id, true)
                    this.$set(rightItem, 'color', 'blue')
                  }
                })
              })
            }
            this.connectLoading = false
            this.$emit('sureConnectTask', { keys: this.keys, taskList: this.taskList, selectedId: this.selectedId })
          })
        })
      })
    },
    // 取消选中
    cancelConnect() {
      const originKeys = this.$refs['rightTree'].getCheckedKeys()
      this.keys = []
      this.taskList = []
      var keysPath = []
      this.findTree(this.rightTreeData, (item) => {
        var bExit = false
        originKeys.forEach(key => {
          if (key === item.id) {
            bExit = true
          }
        })
        // eslint-disable-next-line eqeqeq
        if (!bExit && item[this.rightNodeType] == '1') {
          item.taskId = item.id
          this.taskList.push(item)
          this.keys.push(item.id)
          var pathArr = this.getPath(item.id, []) || []
          pathArr.push(item.id)
          keysPath.push(pathArr)
        }
      })
      const requestData = { ...this.curBussinessObj }
      requestData.taskList = this.taskList
      requestData.selectedId = this.selectedId.join(',')
      var selectKey = []
      this.connectLoading = true
      connectTask(requestData).then(res => {
        this.getleftTreeData(() => {
          getDetail({ id: this.curBussinessObj.id }).then(res => {
            if (res) {
              res.forEach(element => {
                if (element.taskId && element.types === '2') {
                  this.$refs.leftTree.setChecked(element.taskId, true)
                }
                if (element.types === '1') {
                  selectKey = element.selectedId.split(',')
                }
              })
              this.initMidTreeForKeys()
              this.findTree(this.rightTreeData, (rightItem) => {
                selectKey.forEach(key => {
                  if (rightItem.id === key) {
                    this.$refs.leftTree.setChecked(rightItem.id, true)
                    this.$set(rightItem, 'color', 'blue')
                  }
                })
              })
            }
            this.connectLoading = false
            this.$emit('sureConnectTask', { keys: this.keys, taskList: this.taskList, selectedId: this.selectedId })
          })
        })
      })
      this.$emit('sureConnect', { keys: this.keys, selectedId: this.selectedId })
    },
    initMidTreeForKeys() {
      const originKeys = this.$refs['leftTree'].getCheckedKeys()
      this.keys = []
      var keysPath = []
      this.taskList = []
      this.findTree(this.leftTreeData, (item) => {
        originKeys.forEach(key => {
          // eslint-disable-next-line eqeqeq
          if (item.id === key && item[this.rightNodeType] == '1') {
            this.keys.push(item.id)
            var pathArr = this.getPath(key, []) || []
            pathArr.push(key)
            keysPath.push(pathArr)
            item.taskId = item.id
            this.taskList.push(item)
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
      this.rightArrData = []
      allArr.forEach(id => {
        var dict = {}
        this.findTree(this.leftTreeData, (treeElement) => {
          if (treeElement.id === id) {
            dict = { id: treeElement.id, parentId: treeElement.parentId, label: treeElement[this.rightName], [this.rightNodeType]: treeElement[this.rightNodeType] }
          }
        })
        this.rightArrData.push(dict)
      })
      this.rightTreeData = this.convertToTreeData(this.rightArrData)
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
      this.findTree(this.leftTreeData, (element) => {
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
    handleRightNodeClick(data) {
      this.$refs.rightTree.setCurrentNode(data)
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    getleftTreeData(callback) {
      var requestData = {
        projectId: this.$route.params.id
      }
      requestData = { ...requestData, ...this.leftQuery }
      getTreeData(this.leftTreeUrl, requestData, 'post').then(res => {
        if (res) {
          this.findTree(res, (item) => {
            item.label = item.taskName
            if (!item.parentId) {
              item.parentId = undefined
            }
            item.disabled = false
          })
          this.leftTreeData = res
        } else {
          this.leftTreeData = []
        }
        if (callback instanceof Function) {
          callback()
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
  width:320px
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
  width:330px;
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
