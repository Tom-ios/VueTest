<template>
  <!-- 右侧穿梭框 目标框 -->
  <div :style="{width,height,position:'relative','font-size':'14px'}">
    <div style="margin-left:20px">
      <span> 名称</span>
      <el-input v-model="query.name" placeholder="" size="small" style="width: 220px;margin-left:5px" clearable @keyup.enter.native="search()" />
      <el-button type="primary" class="ml-10" size="mini" @click="search()">查询</el-button>
    </div>
    <h3 v-if="!isProjectover" class="treeTable-title" style="width: 100%;">
      <slot name="title-tree" />
      <div>
        <el-tooltip effect="dark" content="新增根节点" placement="top">
          <el-button icon="el-icon-folder-add" size="mini" circle @click="addNode" />
        </el-tooltip>
        <el-tooltip effect="dark" content="新增子节点" placement="top">
          <el-button icon="el-icon-plus" size="mini" circle @click="addChildren" />
        </el-tooltip>
        <el-tooltip effect="dark" content="编辑" placement="top">
          <el-button icon="el-icon-edit" size="mini" circle @click="edit" />
        </el-tooltip>
        <el-tooltip effect="dark" content="删除" placement="top">
          <el-button icon="el-icon-minus" size="mini" circle @click="del" />
        </el-tooltip>
        <el-tooltip effect="dark" content="上移" placement="top">
          <el-button icon="el-icon-top" size="mini" circle @click="up" />
        </el-tooltip>
        <el-tooltip effect="dark" content="下移" placement="top">
          <el-button icon="el-icon-bottom" size="mini" circle @click="down" />
        </el-tooltip>
        <el-tooltip effect="dark" content="升级" placement="top">
          <el-button icon="el-icon-caret-top" size="mini" circle @click="upLevel" />
        </el-tooltip>
        <el-tooltip effect="dark" content="降级" placement="top">
          <el-button icon="el-icon-caret-bottom" size="mini" circle @click="downLevel" />
        </el-tooltip>
        <el-button type="primary" style="float:right;margin-right:10px;margin-top:4px" @click="setMemberClass">设置关联构件类 </el-button>
      </div>

    </h3>
    <!-- 内容区 -->
    <div class="treeTable-main" style="width:100%;position:relative">
      <el-table
        ref="treeTable"
        v-loading="loading"
        highlight-current-row
        :data="tableData"
        :max-height="maxHeight"
        row-key="id"
        empty-text="暂无数据"
        default-expand-all
        :indent="20"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        header-cell-class-name="tableHeader"
        @row-click="rowClick"
        @current-change="handleCurrentChange"
      >
        <el-table-column
          type="index"
          label="序号"
        />
        <el-table-column
          property="sectionName"
          label="名称"
        />
      </el-table>
    </div>
    <el-dialog
      title=""
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
      width="30%"
    >
      <el-form ref="nameForm" :model="form">
        <el-form-item
          label="名称"
          label-width="68"
          prop="label"
          :rules="[
            { required: true, message: '请输入名称', trigger: 'blur' }
          ]"
        >
          <el-input ref="addNodeInput" v-model="form.label" />
        </el-form-item>
      </el-form>

      <span slot="footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" :loading="optLoad" @click="nameSubmit">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title="设置关联构件类"
      :visible.sync="bSetConnectFlowSeg"
      width="1150px"
      :close-on-click-modal="false"
      :destroy-on-close="true"
      @close="bSetConnectFlowSeg = false"
    >
      <ConnectTree
        ref="connectTree"
        :mid-empty-text="rightEmptyText"
        :right-empty-text="rightEmptyText"
        :left-props="{children: 'children',label: 'sectionName'}"
        :left-data="leftTreeFlowData"
        :right-data="rightTreeData"
        :right-props="{children: 'children',label: 'label'}"
        :right-query="rightQuery"
        right-name="label"
        left-node-type="leafNode"
        @handleLeftNodeClick="handleLeftNodeClick"
        @handelLeftCheckChange="handelLeftCheckChange"
        @connectTree="connectTree"
        @delMidNode="delMidNode"
      >
        <div slot="leftTreeUp" class="mt-10">
          <span class="ml-10"> 名称 </span>
          <el-input
            v-model="leftQuery.name"
            placeholder=""
            size="small"
            style="width: 100px;margin-left:5px"
            clearable
            @keyup.enter.native="searchTree('left')"
          />
          <span class="ml-10"> 是否关联</span>
          <el-select v-model="isRelate" placeholder="请选择" clearable style="width:90px;margin-left:5px">
            <el-option v-for="item in modelArr" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
          <el-button
            type="primary"
            class="ml-10"
            size="mini"
            @click="searchTree('left')"
          >查询</el-button>
        </div>
      </ConnectTree>
      <span slot="footer">
        <el-button @click="bSetConnectFlowSeg = false">取 消</el-button>
        <el-button type="primary" @click="sureConnectFlow">保 存</el-button>
      </span>
    </el-dialog>
  </div>
</template>

<script>
import { getFlowSegList, addNode, updateNodeName, deleteNode, shiftUp, shiftDown, upgrade, demotion, flowConnectTree } from '@/api/progressManage'
import { getFrame } from '@/api/projectFrame'
import ConnectTree from '@/components/TreeTransfer/connectTree'
export default {
  components: {
    ConnectTree
  },
  props: {
    // 宽度
    width: {
      type: String,
      default: '100%'
    },
    // 高度
    height: {
      type: String,
      default: '320px'
    },
    isManager: {
      type: Boolean,
      default: true
    },
    isProjectover: {
      type: Boolean,
      default: false
    },
    maxHeight: {
      type: Number,
      default: 400
    }
  },
  data() {
    return {
      bSetConnectFlowSeg: false,
      loading: false,
      currentNode: null,
      tableData: [],
      dialogVisible: false,
      modelArr: [{
        'label': '是', value: '1' }, {
        'label': '否', value: '0' }],
      form: {
        label: ''
      },
      query: {
        name: ''
      },
      leafDatas: [],
      checkList: [],
      dialogMode: 0,
      tree_key: 0,
      defaultExpand: [],
      isIndeterminate: false,
      checkAll: false,
      searchText: '',
      treeCurrentNode: {}, // 右侧树的当前节点
      rightEmptyText: '',
      leftTreeFlowData: [],
      // 用来存储关联关系
      connectArr: [],
      leftQuery: {
        name: ''
      },
      isRelate: '',
      rightTreeData: [],
      rightQuery: {
        name: ''
      },
      bShowLoad: false,
      optLoad: false,
      bLast: false
    }
  },
  watch: {
    isRelate(v) {
      this.getLeftData()
    },
    bSetConnectFlowSeg(v) {
      if (v) {
        this.rightEmptyText = '请选择流水段'
      }
    }
  },
  mounted() {
    this.getList()
  },
  methods: {
    delMidNode({ leftCurNode, data }) {
      var templateList = leftCurNode.templateList
      if (!templateList) {
        return
      }
      for (let i = 0; i < this.connectArr.length; i++) {
        if (this.connectArr[i].id === leftCurNode.id) {
          for (let j = 0; j < this.connectArr[i].templateList.length; j++) {
            if (this.connectArr[i].templateList[j].templateId === data.id) {
              this.connectArr[i].templateList.splice(j, 1)
              j--
            }
          }
        }
      }
    },
    connectTree(keys) {
      var leftCurNode = this.$refs.connectTree.$refs.leftTree.getCurrentNode()
      var isExit = false
      var templateList = []
      this.connectArr.forEach(element => {
        if (element.id === leftCurNode.id) {
          templateList = []
          isExit = true
          keys.forEach(key => {
            var dict = { sectionId: leftCurNode.id, templateId: key }
            templateList.push(dict)
          })
          element.templateList = templateList
        }
      })
      if (!isExit) {
        this.connectArr.push({ id: leftCurNode.id, templateList: templateList })
      }
    },
    handelLeftCheckChange(data) {
      const curNode = this.$refs.connectTree.$refs.leftTree.getCurrentNode()
      if (!curNode || curNode.leafNode === 0 || (curNode.children && curNode.children.length > 0)) {
        this.$alert('请选择流水段')
        this.$refs.connectTree.$refs.rightTree.setCheckedKeys([data.id])
      }
      this.$refs.connectTree.connectDisabled = this.$refs.connectTree.isEqual()
    },
    searchTree(flag) {
      if (flag === 'left') {
        this.getLeftData()
      }
    },
    handleLeftNodeClick(data) {
      var keys = []
      this.connectArr.forEach(element => {
        if (element.id === data.id) {
          element.templateList.forEach(element => {
            keys.push(element.templateId)
          })
        }
      })
      this.$refs.connectTree.changeLeftNode(keys)
      if (this.rightTreeData.length > 0) {
        this.rightEmptyText = '暂无数据'
      } else {
        this.rightEmptyText = '尚未设置自定义目录树'
      }
    },
    sureConnectFlow() {
      this.bSetConnectFlowSeg = false
      var arr = []
      this.findTree(this.leftTreeFlowData, element => {
        if (!element.templateList) {
          return
        }
        var dict = { id: element.id, projectId: this.$route.params.id, templateList: [] }
        this.connectArr.forEach(connectEle => {
          if (element.id === connectEle.id) {
            dict.templateList = connectEle.templateList
            arr.push(dict)
          }
        })
      })
      flowConnectTree(arr)
    },
    setConnectFlowseg() {
      this.bSetConnectFlowSeg = !this.bSetConnectFlowSeg
    },
    search() {
      this.getList()
    },
    getList(callBack) {
      var requestData = {
        projectId: this.$route.params.id,
        ...this.query
      }
      this.bShowLoad = true
      getFlowSegList(requestData).then(res => {
        this.bShowLoad = false
        if (!res) {
          res = []
        }
        this.tableData = res
        if (callBack && callBack instanceof Function) {
          callBack()
        }
      })
    },
    setMemberClass() {
      if (this.tableData.length === 0) {
        this.$alert('请维护流水段')
        return
      }
      this.leftQuery = { name: '' }
      this.bLast = false
      this.isRelate = ''
      // 用来存储关联关系
      this.connectArr = []
      this.rightEmptyText = '请选择流水段'
      this.getLeftData()
      this.getRightFlowSegTreeList()
      this.bSetConnectFlowSeg = true
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    // 获取左侧树的data
    getLeftData() {
      var requestData = { projectId: this.$route.params.id, ...this.leftQuery, isRelate: this.isRelate }
      getFlowSegList(requestData).then(res => {
        if (!res) {
          this.leftTreeFlowData = []
        } else {
          if (!this.bLast) {
            this.findTree(res, element => {
              var dict = { id: element.id, templateList: element.templateList ? element.templateList : [] }
              this.connectArr.push(dict)
            })
            this.bLast = true
          }
          this.findTree(res, (element) => {
            if (element && element.parentId === '-1') {
              element.parentId = undefined
            }
          })
          this.leftTreeFlowData = res
        }
      })
    },
    // 获取右侧流水段数据
    getRightFlowSegTreeList() {
      getFrame({ projectId: this.$route.params.id }).then(res => {
        if (res.content) {
          this.rightTreeData = this.getParentIdFromTreeData(JSON.parse(res.content))
          if (this.rightTreeData.length === 0) {
            this.rightEmptyText = '尚未设置自定义目录树'
          }
        }
      })
    },
    getParentIdFromTreeData(array) {
      this.findTree(array, (element) => {
        if (element.children && element.children.length > 0) {
          element['nodeType'] = '0'
          const childrenArr = element.children
          childrenArr.forEach(childItem => {
            childItem.parentId = element.id
            childItem['nodeType'] = '1'
          })
        } else {
          element['nodeType'] = '1'
        }
      })
      return array
    },
    handleCurrentChange() {

    },
    rowClick(row, col, event) {
      this.currentNode = row
      this.$refs.treeTable.setCurrentRow(row)
    },

    // 目标数据筛选
    filterNodeTo(value, data) {
      if (!value) return true
      return data[this.defaultProps.label].toLowerCase().indexOf(value.toLowerCase()) !== -1
    },
    addNode() {
      this.setNodeInput('addNode') // 添加节点 0
    },
    addChildren() {
      if (!this.currentNode) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      if (this.currentNode && this.currentNode.modelRelationList.length > 0) {
        this.$message({
          message: '此流水段已关联模型，如需调整层级关系，请在模型浏览页面中【取消关联】模型',
          type: 'error'
        })
        return
      } else {
        this.setNodeInput('addChild') // 添加子节点
      }
    },
    edit() {
      if (!this.currentNode) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      this.form.label = this.currentNode.sectionName
      this.setNodeInput('edit') // 编辑
    },
    setNodeInput(dialogMode) {
      this.dialogVisible = true
      this.dialogMode = dialogMode
      this.$nextTick(() => {
        this.$refs.addNodeInput.focus()
      })
    },
    eachArr(arr, v) {
      arr.forEach((item) => {
        if (item.data) {
          v.push(item.id)
        }
        if (item.children.length > 0) {
          this.eachArr(item.children, v)
        }
        if (item.leafChildren && item.leafChildren.length > 0) {
          this.eachArr(item.leafChildren, v)
        }
      })
    },
    filter(data, id) {
      var newData = data.filter(x => x.id !== id)
      newData.forEach(x => x.children && (x.children = this.filter(x.children, id)))
      return newData
    },
    del() {
      const current = this.currentNode
      if (current) {
        this.$confirm(`确定要删除该节点么?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          dangerouslyUseHTMLString: true
        }).then(() => {
          this.form.label = this.currentNode.sectionName
          this.optData('del')
        }).catch(() => {
        })
      } else {
        this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
    },
    getParentNode() {

    },
    up() {
      if (this.bShowLoad) {
        return
      }
      if (!this.currentNode) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('shiftUp')
      }
    },
    down() {
      if (this.bShowLoad) {
        return
      }
      if (!this.currentNode) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('shiftDown')
      }
    },
    upLevel() {
      if (!this.currentNode) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        this.optData('upgrade')
      }
    },
    downLevel() {
      if (!this.currentNode) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      } else {
        var upNode = null
        var isExit = false
        this.findTree(this.tableData, element => {
          if (element.id === this.currentNode.parentId) {
            isExit = true
            const children = element.children
            for (var i = 0; i < children.length; i++) {
              if (children[i].id === this.currentNode.id) {
                if (i > 0) {
                  upNode = children[i - 1]
                }
              }
            }
          }
        })
        if (!isExit) {
          for (var j = 0; j < this.tableData.length; j++) {
            if (this.tableData[j].id === this.currentNode.id) {
              if (j > 0) {
                upNode = this.tableData[j - 1]
              }
            }
          }
        }
        if (upNode && upNode.modelRelationList && upNode.modelRelationList.length > 0) {
          this.$alert('此流水段的上级节点已关联模型，如需调整层级关系，请在模型浏览页面中【取消关联】模型')
          return
        }
        this.optData('demotion')
      }
    },
    // type 操作类型 isOriginParent是否为祖先节点
    optData(type) {
      this.optLoad = true
      var requestData = {}
      if (type === 'addNode' || type === 'addChild') {
        if (type === 'addNode') {
          requestData = { projectId: this.$route.params.id, sectionName: this.form.label, parentId: '-1', sort: this.tableData.length + 1, leafNode: 1, addNode: 0 }
        } else if (type === 'addChild') {
          requestData = { projectId: this.$route.params.id, sectionName: this.form.label, parentId: this.currentNode.id, sort: this.currentNode.children ? this.currentNode.children.length + 1 : 1, leafNode: 1, addNode: 1, path: this.currentNode.path }
        }
        addNode(requestData).then(res => {
          this.dialogVisible = false
          this.form = { label: '' }
          this.optNodeOver()
        })
      } else if (type === 'edit') {
        requestData = { id: this.currentNode.id, sectionName: this.form.label }
        updateNodeName(requestData).then(res => {
          this.form = { label: '' }
          this.optNodeOver()
        })
      } else if (type === 'del') {
        requestData = { sectionName: this.form.label, id: this.currentNode.id, parentId: this.currentNode.parentId, projectId: this.$route.params.id }
        deleteNode(requestData).then(res => {
          this.dialogVisible = false
          this.getList()
          this.form = { label: '' }
          this.currentNode = null
          this.optLoad = false
        })
      } else if (type === 'shiftUp') {
        requestData = { id: this.currentNode.id }
        shiftUp(requestData).then(res => {
          this.optNodeOver()
        })
      } else if (type === 'shiftDown') {
        requestData = { id: this.currentNode.id }
        shiftDown(requestData).then(res => {
          this.optNodeOver()
        })
      } else if (type === 'upgrade') {
        requestData = { id: this.currentNode.id }
        upgrade(requestData).then(res => {
          this.optNodeOver()
        })
      } else if (type === 'demotion') {
        requestData = { id: this.currentNode.id }
        demotion(requestData).then(res => {
          this.optNodeOver()
        })
      }
    },
    optNodeOver() {
      this.optLoad = false
      this.dialogVisible = false
      this.getList(() => {
        this.$nextTick(() => {
          if (!this.currentNode) {
            return
          }
          // 直接设置this.currentNode无法设置上
          this.findTree(this.tableData, element => {
            if (element.id === this.currentNode.id) {
              this.currentNode = element
              this.$refs.treeTable.setCurrentRow(element)
            }
          })
        })
      })
    },
    nameSubmit() {
      this.$refs.nameForm.validate((valid) => {
        if (valid) {
          if (this.dialogMode === 'addNode' || this.dialogMode === 'addChild' || this.dialogMode === 'edit') {
            this.optData(this.dialogMode)
          }
        } else {
          return false
        }
      })
    }
  }
}
</script>
<style scoped lang="scss">
.treeTable-main {
  padding: 10px;
  height: calc(100% - 41px);
  box-sizing: border-box;
  overflow: auto;
}
.treeTable-title {
  border-bottom: 1px solid #ebeef5;
  padding: 0 15px;
  height: 40px;
  line-height: 40px;
  color: #333;
  font-size: 16px;
  background-color: #f5f7fa;
  margin: auto;
  margin-top:15px
}
.float-r {
 float:right
}
/deep/ .tableHeader {
  font-size:13px
}
.ml-10{
  margin-left:10px
}

</style>
