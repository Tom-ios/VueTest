<template>
  <div ref="BimVisible" style="height:100%">
    <el-row class="toolbar" style="height:50px;">
      <el-col :span="12">
        <div v-show="modelVisible" style="position:relative;left:10px;top:10px;">
          <el-popover
            placement="bottom-start"
            trigger="click"
            :disabled="buttonDisable"
          >
            <div style="max-height: 400px; overflow:auto">
              <el-checkbox v-model="checkAll" :indeterminate="isIndeterminate" @change="handleCheckAllChange">全选</el-checkbox>
              <el-checkbox-group v-model="modelCheckList">
                <div v-for="(item, index) in models" :key="index" style="height:22px">
                  <el-checkbox
                    :disabled="item.state === 2 || item.state === 0"
                    style="display:inline"
                    :label="item.bimserverModuleId"
                    @change="v => checkChange(item.bimserverModuleId, v)"
                  >{{ item.moduleName }}</el-checkbox>
                  <el-tag v-if="item.state === 2 || item.state === 0" :type="item.state === 2 ? 'danger' : 'success'" size="mini" style="margin-left:10px">{{ item.stateName }}</el-tag>
                </div>

              </el-checkbox-group>
            </div>

            <el-button slot="reference" type="primary" :disabled="buttonDisable || isConnect || playDisabled">
              模型列表<i class="el-icon-arrow-down el-icon--right" />
            </el-button>
          </el-popover>
          <el-button v-if="isManager" type="primary" :disabled="buttonDisable || playDisabled || isConnect" @click="clickModelConnect">
            关联模型
          </el-button>
          <el-button v-if="isManager" type="primary" :disabled="buttonDisable || isConnect" @click="simulate">施工模拟</el-button>
          <!-- <el-button v-if="isManager" type="primary" :disabled="buttonDisable || playDisabled" @click="lookBussinessInfo = !lookBussinessInfo;bim.setPickDisabled(false)">
            查看关联任务
          </el-button> -->
          <el-button v-if="isManager" type="primary" :disabled="buttonDisable || playDisabled || isConnect" @click="clickPaymentSumation ">
            进度款趋势模拟
          </el-button>
        </div>
      </el-col>
      <el-col v-show="isConnect" :span="12">
        <div style="margin-top:10px;margin-right:10px;float:right">
          <el-button type="primary" @click.native="saveTaskModel">
            保存
          </el-button>
          <el-button type="primary" class="ml-10" @click.native="cancelTaskModel">
            取消
          </el-button>
        </div>
      </el-col>
    </el-row>
    <span v-if="isConnect" style="margin-left:10px;position:relative;top:-5px;font-size:14px">任务名称: {{ curConnectName }}</span>
    <split-pane split="horizontal" :min-percent="0" :default-percent="defaultHrPerc" @resize="hrReSize">
      <template slot="paneL">
        <split-pane ref="splitPanel" :class="[isConnect?'bim72':'bim',simulationMode ?'':'noSplit']" split="vertical" :min-percent="minPercent" :default-percent="defaultPerc" @resize="reSize">
          <template slot="paneL">
            <Simulation v-if="simulationMode" :bim="bim" @setObjColors="setObjColors" @closeSimulation="simulate" @playing="setPlayingState" />
          </template>
          <template slot="paneR">
            <bim-widget v-if="sucModels.length > 0 && bimVisible" ref="bim" :default-toolbar-options.prop="defaultToolbarOptions" :toolbar-ext.prop="toolbarExt" default-property="false" @selected="selectedHandler" />
            <el-button v-if="buttonDisable" style="position: absolute;top:5px; right:13px" icon="el-icon-circle-close" type="text" size="medium" @click="cancleLoad" />
            <div v-if="models.length === 0 && listLoaded" class="textCenter">暂无模型</div>
            <ProjectModelViewConnect
              ref="modelConnect"
              :bim="bim"
              :is-manager="isManager"
              :is-projectover="isProjectover"
              :visible.sync="modelConnectVisible"
              :y="10"
              :x="10"
              :just-show-flow-connect-model="justShowFlowConnectModel"
              @changeModule="changeModule"
              @connectModelChange="connectModelChange"
              @setObjColors="setObjColors"
            />
            <ProjectModelViewShowBussiness :visible.sync="lookBussinessInfo" :y="10" :x="10" :sel-primitive="selArr" />
            <ProjectSelectSet :visible.sync="showSelectSet" :y="10" :x="10" :is-projectover="isProjectover" :bim="bim" @editSelectSet="editSelectSet" />
            <projectSelectEdit :visible.sync="showSelectSetEdit" :y="10" :x="10" :flag="selectSetFlag" :select-primitives="initArr" :cur-set-data="curSetData" :bim="bim" @selectEditHide="showSelectSet= true" />
          </template>
        </split-pane>
      </template>
      <template slot="paneR">
        <div style="height:100%">
          <ProgressPaymentModelView ref="progressModel" :bim="bim" style="height:100%" @close="clickPaymentSumation" />
        </div>
      </template>
    </split-pane>
  </div>
</template>

<script>
import { getList } from '@/api/model'
import { getRoleNamesByProject, getRoleNamesFromProject, detail } from '@/api/project'
import { getFrame, initRender } from '@/api/projectFrame'
import { valInDeep } from '@/components/TreeTransfer/array'
import Simulation from './Simulation'
import ProjectModelViewConnect from './ProjectModelViewConnect'
import ProjectModelViewShowBussiness from './ProjectModelViewShowBussiness'
import ProjectSelectSet from './ProjectSelectSet'
import ProjectSelectEdit from './ProjectSelectEdit'
import ProgressPaymentModelView from './ProgressPaymentModelVIew'
export default {
  name: 'BimVisible',
  components: {
    Simulation,
    ProjectModelViewConnect,
    ProjectModelViewShowBussiness,
    ProjectSelectSet,
    ProjectSelectEdit,
    ProgressPaymentModelView
  },
  data() {
    return {

      models: [],
      // 转化成功的模型
      sucModels: [],
      Model2primitive: [],
      bim: null,
      modelVisible: false,
      listLoaded: false,
      isViewRole: false,
      isPropertyRole: false,
      modelCheckList: [],
      selArr: [],
      isIndeterminate: true,
      checkAll: false,
      buttonDisable: false,
      frameData: [],
      propertys: [],
      colorObj: {},
      initColors: {},
      bimVisible: true,
      isConnect: false,
      selectModelArr: [],
      isManager: true,
      isProgressManage: false,
      maxHeight: 260,
      defaultHrPerc: 100,
      minPercent: 0,
      defaultPerc: 0,
      showProgress: false,
      toolbarExt: [],
      simulationMode: false,
      isProjectover: false,
      modelConnectVisible: false,
      initArr: [],
      lookBussinessInfo: false,
      justShowFlowConnectModel: false,
      activeName: 'taskView',
      showSelectSet: false,
      showSelectSetEdit: false,
      selectSetFlag: 'create',
      curSetData: {},
      showQualityOrSafe: false,
      searchVisible: false,
      timer: null,
      playDisabled: false,
      loadingRevision: '',
      curConnectName: '',
      paymentSumation: false,
      defaultToolbarOptions: [
        { type: 'main', visible: true, icon: 'el-icon-house' },
        { type: 'section', visible: true, icon: 'el-icon-edit' },
        { type: 'explode', visible: true, icon: 'el-icon-s-grid' },
        { type: 'tree', visible: true, icon: 'HHBIM icontree-table' },
        { type: 'property', visible: true, icon: 'el-icon-tickets', canEdit: true },
        { type: 'roamMode', visible: true, icon: 'el-icon-user' },
        { type: 'pathRoam', visible: true, icon: 'el-icon-position', canEdit: true },
        { type: 'search', visible: true, icon: 'el-icon-search' },
        { type: 'setting', visible: true, icon: 'el-icon-setting' }
      ]
    }
  },

  watch: {
    propertys(v) {
      console.log('propertys', v)
    },
    buttonDisable(v) {
      if (!v) {
        this.setObjColors()
      }
    },
    modelConnectVisible(v) {
      this.ProjectModelViewConnect = v
    },
    modelCheckList(v) {
      this.handleCheckedChange(v)
    },
    isConnect(v) {
      this.$emit('modelConnectChange', { 'isConnect': v })
    }
  },
  mounted() {
    this.toolbarExt.push(
      {
        name: '选择集', icon: 'el-icon-files', click: () => {
          this.showSelectSet = !this.showSelectSet
        }
      }
    )
    this.$nextTick(() => {
      this.loadView()
    })
  },

  methods: {
    clickModelConnect() {
      if (!this.modelConnectVisible && this.simulationMode) {
        this.simulate()
      }
      if (!this.modelConnectVisible && this.paymentSumation) {
        this.clickPaymentSumation()
      }
      this.modelConnectVisible = !this.modelConnectVisible
    },
    close() {
      this.clickModelConnect()
    },
    getModelList() {
      getList({ projectId: this.$route.params.id }).then(data => {
        this.models = data.rows
        this.sucModels = this.models.filter(item => {
          if (item.state === 1 || !item.state) {
            return item
          }
        })
      })
    },
    loadView() {
      // 返回角色
      getRoleNamesFromProject(this.$route.params.id).then((res) => {
        const roleArr = res.split(',')
        this.isManager = roleArr.indexOf('项目经理') !== -1
        this.isProgressManage = roleArr.indexOf('项目经理') !== -1 || roleArr.indexOf('项目成员') !== -1
      })
      detail(this.$route.params.id).then((res) => {
        if (res.projectOver) {
          this.isProjectover = true
        } else {
          this.isProjectover = false
        }
      })

      // 项目结项不返回角色
      getRoleNamesByProject(this.$route.params.id).then((res) => {
        const roleArr = res.split(',')
        this.isViewRole = roleArr.indexOf('漫游路径维护人员') !== -1 || roleArr.indexOf('项目经理') !== -1
        this.isPropertyRole = roleArr.indexOf('属性维护人员') !== -1 || roleArr.indexOf('项目经理') !== -1
        this.defaultToolbarOptions.forEach(element => {
          if (element.type === 'property') {
            if (!this.isPropertyRole) {
              this.$set(element, 'canEdit', this.isPropertyRole)
            }
          } else if (element.type === 'pathRoam') {
            if (!this.isViewRole) {
              this.$set(element, 'canEdit', this.isViewRole)
            }
          }
        })
        return getList({ projectId: this.$route.params.id })
      }).then((data) => {
        this.models = data.rows
        this.sucModels = this.models.filter(item => {
          if (item.state === 1 || !item.state) {
            return item
          }
        })
        this.listLoaded = true
        return getFrame({ projectId: this.$route.params.id })
      }).then(res => {
        if (res) {
          this.frameData = JSON.parse(res.content)
          return initRender(res.id)
        } else {
          return initRender(this.$route.params.id)
        }
      }).then(res => {
        if (this.models.length > 0) {
          if (this.bim) {
            this.handleCheckAllChange()
          }
          this.modelVisible = true
          if (this.sucModels.length > 0) {
            this.bimVisible = true
            this.$nextTick(() => {
              this.bim = this.$refs.bim.getVueInstance()
              this.bim.init({ bimserverUrl: process.env.VUE_APP_BIMSERVER_API, bimbackUrl: process.env.VUE_APP_BASE_API, bimbackApp: 'bimserver', projectId: this.$route.params.id }, () => {
                this.handleCheckAllChange([])
                var contextmenuExt = []
                contextmenuExt.push({ name: '查看业务信息', click: () => {
                  this.lookBussinessInfo = true
                } })
                document.querySelector('bim-widget').contextmenuExt = contextmenuExt
              })
            })
          }
        }
        res.forEach(item => {
          if (!this.initColors[item.pixelId]) {
            this.initColors[item.pixelId] = {}
          }
          if (item.elementKey === '颜色' && item.elementValue) {
            this.initColors[item.pixelId].color = item.elementValue
          } else if (item.elementKey === '不透明度') {
            this.initColors[item.pixelId].opacity = item.elementValue
          }
        })
      })
    },
    clickPaymentSumation() {
      this.paymentSumation = !this.paymentSumation
      if (this.paymentSumation) {
        if (this.simulationMode) { this.simulate() }
        if (this.modelConnectVisible) { this.modelConnectVisible = !this.modelConnectVisible }
        this.defaultHrPerc = 40
      } else {
        this.defaultHrPerc = 100
      }
      this.hrReSize()
    },
    cancleLoad() {
      this.buttonDisable = false
      if (this.bim) {
        this.bim.delRevision(this.loadingRevision)
      }
    },
    editSelectSet({ flag, formData }) {
      this.curSetData = formData
      this.showSelectSet = false
      this.selectSetFlag = flag
      this.showSelectSetEdit = true
    },
    changeModule({ activeName }) {
      this.activeName = activeName
    },
    connectModelChange(isConnect) {
      this.isConnect = isConnect
      this.modelConnectVisible = !this.isConnect
      if (this.$refs.modelConnect.activeName === 'quality') {
        this.curConnectName = this.$refs.modelConnect.$refs.quality.connectTaskInfo.taskName
      } else if (this.$refs.modelConnect.activeName === 'safe') {
        this.curConnectName = this.$refs.modelConnect.$refs.safe.connectTaskInfo.taskName
      } else {
        this.curConnectName = this.$refs.modelConnect.$refs.taskView.connectTaskInfo.taskName
      }
    },
    reSize() {
      this.$nextTick(() => {
        if (this.bim && this.bim.surfer) {
          this.bim.resize()
        }
      })
    },
    hrReSize() {
      this.$nextTick(() => {
        if (this.bim && this.bim.surfer) {
          this.bim.resize()
        }
        if (this.$refs.progressModel.$refs.echartDiv) {
          this.$nextTick(() => {
            this.$refs.progressModel.cal()
          })
        }
      })
    },
    saveTaskModel() {
      if (this.$refs.modelConnect.activeName === 'quality') {
        this.$refs.modelConnect.$refs.quality.saveTaskConnectModel(this.initArr)
      } else if (this.$refs.modelConnect.activeName === 'safe') {
        this.$refs.modelConnect.$refs.safe.saveTaskConnectModel(this.initArr)
      } else {
        this.$refs.modelConnect.$refs.taskView.saveTaskConnectModel(this.initArr)
      }
      this.cancelAllModelSelect()
    },
    cancelTaskModel() {
      this.$refs.modelConnect.isConnect = false
      this.isConnect = false
      this.modelConnectVisible = true
      this.cancelAllModelSelect()
      if (this.$refs.modelConnect.activeName === 'quality') {
        this.$refs.modelConnect.$refs.quality.reSetModel()
      } else if (this.$refs.modelConnect.activeName === 'safe') {
        this.$refs.modelConnect.$refs.safe.reSetModel()
      } else {
        this.$refs.modelConnect.$refs.taskView.reSetModel()
      }
    },
    cancelAllModelSelect() {
      this.bim.setSelectionState({ ids: [], selected: true, clear: true })
      this.selectModelArr = []
    },
    setObjColors() {
      if (this.bim) {
        this.bim.resetColors()
        this.bim.resetVisibility()
        for (const key in this.initColors) {
          if (this.initColors.hasOwnProperty(key)) {
            const element = this.initColors[key]
            if (element.color && element.color !== '?') {
              let color = element.color
              if (color.indexOf('#') === 0 && color.length <= 7) {
                if (element.opacity && element.opacity !== '?') {
                  let o = Math.floor(element.opacity / 100 * 255).toString(16)
                  if (o.length < 2) {
                    o = '0' + o
                  }
                  color += o
                }

                this.bim.setColor({ ids: [parseInt(key)], color: color })
              }
            }
          }
        }
      }
    },
    addModel(arr) {
      if (arr.length > 0) {
        this.buttonDisable = true
        this.loadingRevision = arr[0].split('-')[1]
        this.bim.addRevision(arr[0], () => {
          this.modelCheckList.push(arr[0])
          arr.shift()
          this.buttonDisable = false
          this.loadingRevision = ''
          this.addModel(arr)
        }, percentage => {
          return percentage + '%    ' + arr.length + '个模型待加载'
        })
      }
    },
    handleCheckAllChange(val) {
      if (val) {
        const arr = []
        const toAddArr = []
        this.models.forEach((model) => {
          arr.push(model.bimserverModuleId)
          if (this.modelCheckList.indexOf(model.bimserverModuleId) === -1 && model.state === 1) {
            toAddArr.push(model.bimserverModuleId)
          }
        })
        this.addModel(toAddArr)
      } else {
        this.modelCheckList = []
        this.models.forEach((model) => {
          if (model.state === 1) { this.bim.unloadRevision(model.bimserverModuleId) }
        })
      }

      this.isIndeterminate = false
    },
    handleCheckedChange(value) {
      const checkedCount = value.length
      this.checkAll = checkedCount === this.models.length
      this.isIndeterminate = checkedCount > 0 && checkedCount < this.models.length
    },
    rightPanelVisibleChange(v) {
      // this.propertyVisible = v.detail[0]
    },
    selectedHandler(event) {
      const arr = event.detail[0]
      this.initArr = []
      if (arr.length === 0) {
        this.onSelect(arr)
      } else {
        arr.forEach(item => {
          this.bim.getObject(item, obj => {
            var dict = { figureId: [obj.oid] }
            var isExit = false
            this.models.forEach((itemModel) => {
              if (itemModel.state !== 1) {
                return
              }
              if (itemModel.bimserverModuleId.split('-')[0] === obj.model.poid && itemModel.bimserverModuleId.split('-')[1] === obj.model.roid) {
                dict.projectModelId = itemModel.id
              }
            })
            this.initArr.forEach(singleElement => {
              if (singleElement.projectModelId === dict.projectModelId) {
                singleElement.figureId.push(obj.oid)
                isExit = true
              }
            })
            if (!isExit) {
              this.initArr.push({ projectModelId: dict.projectModelId, figureId: [obj.oid] })
            }
          })
        })
        this.onSelect(arr)
      }
    },
    onSelect(ids) {
      const tmpArr = []
      ids.forEach(id => {
        const o = valInDeep(this.frameData, id, 'id', 'leafChildren')
        if (o.length > 0) {
          tmpArr.push(o[0])
        } else {
          tmpArr.push({ id: id, frameId: this.$route.params.id })
        }
      })
      this.selArr = tmpArr
    },
    checkChange(id, v) {
      if (v) {
        this.buttonDisable = true
        this.bim.addRevision(id, () => {
          this.buttonDisable = false
        })
      } else {
        this.bim.unloadRevision(id)
      }
    },
    simulate() {
      this.simulationMode = !this.simulationMode
      if (this.defaultPerc === 0) {
        this.defaultPerc = 25
        if (this.modelConnectVisible) {
          this.clickModelConnect()
        }
        if (this.paymentSumation) {
          this.clickPaymentSumation()
        }
      } else {
        this.defaultPerc = 0
      }
      this.reSize()
    },
    setPlayingState(val) {
      if (val) {
        this.modelConnectVisible = false
        this.lookBussinessInfo = false
        this.playDisabled = true
      } else {
        this.playDisabled = false
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.app-container{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 0
}
.bim {
  height:calc(100% - 52px);
}
.bim72 {
  height:calc(100% - 72px);
}
.el-icon-arrow-down {
  font-size: 10px;
}
.toolbar .el-button {
  height: 32px;
  margin-left:0px
}
.textCenter{
  position: absolute;
  top: 25%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #808080;
}
.el-checkbox{
  display: block
}
.font-14{
  font-size: 14px;
}
 .noSplit /deep/.splitter-pane-resizer.vertical {
  height:0px;
  display: none
}
</style>
