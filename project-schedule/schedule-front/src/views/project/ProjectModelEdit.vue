<template>
  <div class="app-container">
    <el-tabs v-model="activeName" type="border-card" @tab-click="handleClick">
      <el-tab-pane v-loading="loading" label="目录树设置" name="tree">
        <div :style="treeBodyStyle">
          <div style="position: absolute;right: 30px;z-index:9;top:20px">
            <el-button type="primary" :loading="saveing" @click="saveTree">保存</el-button>
          </div>
          <bim-ifctree ref="ifctree" />
          <div style="height: 100%">
            <TreeTransfer
              ref="transTree"
              :left-tree-loading="modelLoading"
              :title="['', '自定义目录树']"
              :filter="true"
              :from_data="fromData"
              :to_data="toData"
              :init-right-data="initRightData"
              :default-transfer="true"
              :default-props="{label:'label'}"
              :default-checked-keys="defaultCheckedKeys"
              placeholder="节点名称"
              :button_text="[]"
              height="100%"
              :model-id="modelId"
            >
              <template v-slot:title-left>
                <span>
                  模型文件
                </span>
                <el-select v-model="currentModel" style="width:calc( 100% - 70px)" @change="modelClicked">
                  <div
                    v-for="item in models"
                    :key="item.bimserverModuleId"
                  >
                    <el-option
                      style="display:inline"
                      :label="item.moduleName"
                      :value="item.bimserverModuleId"
                      :disabled="item.state === 0 || item.state === 2"
                    />
                    <el-tag v-if="item.state === 2 || item.state === 0" :type="item.state === 2 ? 'danger' : 'success'" size="mini" style="margin-left:10px">{{ item.stateName }}</el-tag>
                  </div>
                </el-select>
              </template>
            </TreeTransfer>
          </div>
        </div>
      </el-tab-pane>
      <el-tab-pane label="自定义属性设置" name="property" :lazy="true">
        <el-container :style="propertyBodyStyle">
          <el-aside
            v-loading="propertyTreeLoading || propertyEdit"
            element-loading-text=""
            element-loading-spinner="a"
            element-loading-background="rgba(255, 255, 255, 0.8)"
            width="400px"
            style="border-right: 1px solid #e6e6e6;"
          >
            <el-tree
              ref="propertyTree"
              :data="propertyTree"
              :highlight-current="true"
              :default-expand-all="true"
              @node-click="nodeClick"
            />
          </el-aside>
          <el-container v-if="propertyListVisible">
            <el-header height="32px">
              <div style="position: relative">
                <el-button v-if="!propertyEdit" type="primary" style="right: 0px; position: absolute" @click="startEdit">编辑</el-button>
                <el-button v-else type="primary" style="right: 0px; position: absolute" @click="handleAdd">增加属性</el-button>
              </div>
            </el-header>
            <el-main>
              <d2-crud
                ref="d2"
                :columns="columns"
                :data="propertyData"
                :index-row="indexRow"
                :row-handle="propertyEdit?rowHandle:null"
                @edit="handleEdit"
                @del="handleDel"
                @save="handleSave"
                @cancel="handleCancel"
              />
              <div v-if="propertyEdit" style="float: right">
                <el-button type="primary" :loading="propertySaveLoading" @click="handleSave">保存</el-button>
                <el-button type="primary" @click="handleCancel">取消</el-button>
              </div>
            </el-main>
          </el-container>
          <div v-else-if="propertyTree.length>0" class="textCenter"> 请选择叶子节点</div>
          <div v-else class="textCenter"> 请设置自定义目录树</div>
        </el-container>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
import TreeTransfer from '@/components/TreeTransfer'
import { getFrame, addFrame, getTemplateList, addTemplate } from '@/api/projectFrame'
import { getList } from '@/api/model'
export default {
  name: 'ProjectModelEdit',
  components: {
    TreeTransfer
  },
  data() {
    return {
      timer: '',
      activeName: 'tree',
      fromData: [],
      toData: [],
      saveing: false,
      loading: false,
      initRightData: [],
      defaultCheckedKeys: [],
      frameId: '',
      propertyTree: [],
      propertyTreeLoading: false,
      propertyData: [],
      treeBodyStyle: { },
      propertyBodyStyle: {},
      columns: [
        {
          title: '属性名',
          key: 'elementKey',
          labelClassName: 'require',
          component: {
            render: function(h, scope) {
              const setValue = (v) => {
                scope.elementKey = v
                scope.getthis().propertyData[this.scope.$index].elementKey = v
              }
              if (!scope.getthis().propertyEdit || scope.elementKey === '颜色' || scope.elementKey === '不透明度') {
                return (
                  <span style={{ 'line-height': '28px' }}>{scope.elementKey}</span>
                )
              } else {
                return (
                  <el-input value={scope.elementKey} onInput={setValue}></el-input>
                )
              }
            }
          }
        }
      ],
      indexRow: {
        title: '序号'
      },
      rowHandle: {
        width: '50px',
        custom: [
          {
            text: '删除',
            type: 'text',
            size: 'mini',
            emit: 'del',
            show(index, row) {
              return (row.elementKey !== '颜色' && row.elementKey !== '不透明度') && row.getthis().propertyEdit
            }
          }
        ]
      },
      propertyListVisible: false,
      currentTemplateId: '',
      models: [],
      modelLoading: false,
      currentModel: '',
      propertyEdit: false,
      tmpData: [],
      propertySaveLoading: false,
      modelId: '',
      modelTrees: {}
    }
  },
  mounted() {
    this.treeBodyStyle.height = document.body.clientHeight - 162 + 'px'
    this.propertyBodyStyle.height = document.body.clientHeight - 162 + 'px'
    this.loading = true
    getList({ projectId: this.$route.params.id }).then((data) => {
      this.models = data.rows
      this.loading = false
      return getFrame({ projectId: this.$route.params.id })
    }).then(res => {
      if (res) {
        const showData = JSON.parse(res.content)
        this.frameId = res.id
        this.initRightData = showData
      }
    })
    this.timer = setInterval(() => {
      var isExit = true
      this.models.forEach(element => {
        if (element.state === 0) {
          isExit = true
        }
      })
      if (isExit) {
        this.fetchData()
      }
    }, 10000)
  },
  beforeDestroy() {
    clearInterval(this.timer)
    this.timer = null
  },
  methods: {
    fetchData() {
      getList({ projectId: this.$route.params.id }).then((data) => {
        this.models = data.rows
        this.loading = false
      }).then(res => {
        if (res) {
          const showData = JSON.parse(res.content)
          this.frameId = res.id
          this.initRightData = showData
        }
      })
    },
    modelClicked(bimserverModuleId) {
      const model = this.models.find(model => {
        return model.bimserverModuleId === bimserverModuleId
      })
      this.modelId = ''
      if (model) {
        this.modelId = model.id
      }
      this.modelLoading = true
      if (this.modelTrees[bimserverModuleId]) {
        this.initTransTree(this.modelTrees[bimserverModuleId])
      } else {
        this.$refs.ifctree.getVueInstance().init({ bimserverUrl: process.env.VUE_APP_BIMSERVER_API, poid: bimserverModuleId.split('-')[0] }, treeData => {
          console.log('tree', treeData)
          this.modelTrees[bimserverModuleId] = treeData
          this.initTransTree(treeData)
        })
      }
    },
    initTransTree(treeData) {
      this.fromData = treeData
      this.$nextTick(() => {
        const showData = this.$refs.transTree.rightData
        const cArr = []
        const eArr = []
        this.eachArr(showData, cArr, true)
        this.eachArr(treeData, eArr)
        this.$refs.transTree.setDisabled(cArr)
        this.$refs.transTree.setExpendedKeys(eArr)
        this.modelLoading = false
      })
    },
    getTemplateList(id) {
      this.propertyData = []
      getTemplateList(id).then(res => {
        res.childList.forEach(n => {
          n.getthis = () => {
            return this
          }
        })
        this.propertyData = res.childList
        this.currentTemplateId = id
      })
    },
    eachArr(arr, v, bLeaf) {
      arr.forEach((item) => {
        if (item.data && bLeaf) {
          v.push(item.id)
        } else if (item.children.length > 0 && item.children[0].children.length > 0) {
          v.push(item.id)
        }
        if (item.children.length > 0) {
          this.eachArr(item.children, v, bLeaf)
        }
        if (item.leafChildren && item.leafChildren.length > 0) {
          this.eachArr(item.leafChildren, v, bLeaf)
        }
      })
    },
    delLeaf(arr) {
      for (let i = 0; i < arr.length; i++) {
        const item = arr[i]
        if (item.data) {
          arr.splice(i, 1)
          i--
        } else if (item.children.length > 0) {
          this.delLeaf(item.children)
        }
      }
    },
    handleClick(tab, event) {
      if (tab.name === 'property') {
        this.propertyTreeLoading = true
        getFrame({ projectId: this.$route.params.id }).then(res => {
          if (res) {
            const treedata = JSON.parse(res.content)
            this.delLeaf(treedata)
            this.propertyTree = treedata
          }
          this.propertyTreeLoading = false
        })
      }
    },
    saveTree() {
      this.saveing = true
      // console.log('sss', {
      //   content: JSON.stringify(this.$refs.transTree.rightData),
      //   projectId: this.$route.params.id,
      //   id: this.frameId,
      //   templateIds: this.$refs.transTree.getDelNodes().toString(),
      //   modelIdsList: this.$refs.transTree.getDelLeafs()
      // })
      addFrame({
        content: JSON.stringify(this.$refs.transTree.rightData),
        projectId: this.$route.params.id,
        id: this.frameId,
        templateIds: this.$refs.transTree.getDelNodes().toString(),
        modelIdsList: this.$refs.transTree.getDelLeafs()
      }).then(res => {
        this.saveing = false
        this.$message({
          message: '保存成功',
          type: 'success'
        })
      })
    },
    nodeClick(v) {
      this.propertyListVisible = v.children.length === 0
      if (this.propertyListVisible) {
        this.getTemplateList(v.id)
      }
    },
    handleEdit({ index, row }) {
      this.editValue = row.elementKey
      this.editState = true
    },
    handleDel({ index, row }) {
      this.editValue = ''
      this.propertyData.splice(index, 1)
    },
    handleSave() {
      for (let i = 0; i < this.propertyData.length; i++) {
        if (!this.propertyData[i].elementKey) {
          const num = i + 1
          return this.$message({
            message: '第' + num + '行，请填写属性名',
            type: 'error'
          })
        }
      }
      const d = {
        frameId: this.frameId,
        id: this.currentTemplateId,
        childList: this.propertyData
      }
      this.propertySaveLoading = true
      addTemplate(d).then(res => {
        this.propertyEdit = false
      }).finally(() => {
        this.propertySaveLoading = false
      })
    },
    handleCancel() {
      this.propertyEdit = false
      this.propertyData = this.tmpData
    },
    handleAdd() {
      this.editState = true
      const d = { elementKey: '' }
      d.getthis = () => {
        return this
      }
      this.propertyData.splice(-2, 0, d)
    },
    startEdit() {
      this.propertyEdit = true
      this.tmpData = JSON.parse(JSON.stringify(this.propertyData))
      this.tmpData.forEach(item => {
        item.getthis = () => {
          return this
        }
      })
    }
  }
}
</script>

<style scoped>
.textCenter{
  position: absolute;
  top: 50%;
  left: calc(50% + 200px);
  transform: translate(-50%, -50%);
  color: #808080
}

.el-divider--horizontal{
  margin: 10px 0
}

.modelitem{
  cursor: pointer;
}

.modelitem:hover{
  color: #409EFF
}
</style>
