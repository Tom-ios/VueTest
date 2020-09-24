<template>
  <div>
    <div class="clearfix" style="font-size:13px">
      <div style="float:left;margin-top:10px">
        <span style="margin-left:20px;">是否关联附件</span>
        <el-select v-model="query.isFile" size="mini" placeholder="全部" clearable style="width:140px;margin-left:5px">
          <el-option v-for="item in queryArr" :key="item.value" size="mini" :label="item.label" :value="item.value" />
        </el-select>
      </div>
      <div style="float:left;margin-top:10px">
        <span style="margin-left:20px;">是否关联任务</span>
        <el-select v-model="query.isTask" size="mini" placeholder="全部" clearable style="width:140px;margin-left:5px">
          <el-option v-for="item in queryArr" :key="item.value" size="mini" :label="item.label" :value="item.value" />
        </el-select>
      </div>
      <div style="float:left;margin-top:10px">
        <span class="ml-20">名称</span>
        <el-input v-model="name" size="mini" style="width: 200px;margin-left:5px" clearable @keyup.enter.native="search" />
        <el-button type="primary" class="ml-10" size="mini" @click="search">查询</el-button>
      </div>
    </div>
    <div v-if="isProjectMember" style="margin-top:15px;margin-left:20px">
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
    </div>
    <div class="clearfix" style="margin-top:15px">
      <el-table
        ref="treeTable"
        :data="tableData"
        border
        stripe
        highlight-current-row
        :header-cell-class-name="'tableHeader'"
        :cell-class-name="addClass"
        style="margin-top:10px"
        :max-height="maxHeight"
        row-key="id"
        empty-text="暂无数据"
        default-expand-all
        :indent="20"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        @row-click="rowClick"
      >
        <el-table-column
          type="index"
          label="序号"
          fixed
        />
        <el-table-column
          v-for="(col,index) in tablecolumn"
          :key="index"
          :prop="col.value"
          :label="col.title"
          :min-width="col.width?col.width:'100'"
        >
          <template slot-scope="scope">
            <span v-if="tablecolumn[index].type==='opt'">
              <el-button v-if="(isManager || (userId === scope.row.createUser))&&!isProjectover" type="text" @click="standardFile(scope.row,scope.$index)">标准附件</el-button>
              <el-button v-if="(isManager || (userId === scope.row.createUser))&&!isProjectover" type="text" @click="connectTask(scope.row,scope.$index)">关联任务</el-button>
            </span>
            <span v-else-if="tablecolumn[index].type==='file'">
              <span v-if="scope.row.associate">是</span>
              <span v-else>否</span>
            </span>
            <span v-else-if="tablecolumn[index].type==='isTask'">
              <span v-if="scope.row.taskList.length>0">是</span>
              <span v-else>否</span>
            </span>
            <span v-else> {{ scope.row[tablecolumn[index].value] }}</span>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <el-dialog
      v-if="showQuestionDialog"
      :title="showTitle"
      :visible.sync="showQuestionDialog"
      width="500px"
      center
      :close-on-click-modal="false"
      @close="closeDialog"
    >
      <div v-loading="loadDetail">
        <el-form ref="form" label-width="110px" :rules="rules" :model="formData" style="margin-left:-30px">
          <el-row>
            <el-form-item label="名称：" prop="name">
              <el-input v-model="formData.name" maxlength="50" />
            </el-form-item>
            <el-form-item label="说明：">
              <el-input v-model="formData.explains" maxlength="200" type="textarea" />
            </el-form-item>
          </el-row>
        </el-form>
      </div>
      <span slot="footer">
        <el-button type="primary" :disabled="saveDisable" :loading="saveLoading" @click="saveQuestion">保 存</el-button>
        <el-button @click="closeDialog">取 消</el-button>
      </span>
    </el-dialog>
    <el-dialog
      title="标准附件"
      center
      :visible.sync="showFile"
      width="600px"
      @close="showFile=false"
    >
      <div class="clearfix" style="margin-top: -35px;">
        <div style="display:inline-block;margin-top:10px;width:calc(100% - 90px)">
          名称:  {{ curRow.pathName }}
        </div>
        <el-upload
          v-if="isManager"
          ref="upload"
          action=""
          :on-change="onChange"
          :auto-upload="false"
          :show-file-list="false"
          style="display: inline-block;float:right;right-margin:10px"
        >
          <el-button type="primary" size="small">添加附件</el-button>
        </el-upload>
        <div style="height:1px;background:#EBEEF5;margin-top:15px" />
        <el-table
          :data="fileData"
          border
          stripe
          highlight-current-row
          :header-cell-class-name="'tableHeader'"
          cell-class-name="justcenter"
          style="position:relative;top:10px"
        >
          <el-table-column
            v-for="(col,index) in fileColumns"
            :key="index"
            :prop="col.value"
            :label="col.title"
            :min-width="col.width?col.width:'100'"
          >
            <template slot-scope="scope">
              <span v-if="fileColumns[index].type==='opt'">
                <el-button type="text" @click="preview(scope.row,scope.$index)">预览</el-button>
                <el-button type="text" @click="downLoad(scope.row,scope.$index)">下载</el-button>
                <el-button v-if="userId === scope.row.createUser" type="text" @click="deleteFile(scope.row,scope.$index)">删除</el-button>
              </span>
              <span v-else-if="fileColumns[index].type==='index'"> {{ scope.$index +1 }}</span>
              <span v-else> {{ scope.row[fileColumns[index].value] }}</span>
            </template>
          </el-table-column>
        </el-table>

      </div>
    </el-dialog>
    <el-dialog
      title="关联任务"
      :visible.sync="showConnectTree"
      center
      width="800px"
      :close-on-click-modal="false"
      @close="showConnectTree===false"
    >
      <ConnectTask
        ref="connectTask"
        :cur-bussiness-obj="curRow"
        :show-connect-tree="showConnectTree"
        @sureConnectTask="sureConnectTask"
      />
    </el-dialog>
    <el-dialog :visible.sync="loading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>
    <el-dialog
      :visible="showDoc == true || showPdf == true || showVideo == true || showImage"
      title="附件预览"
      :show-close="true"
      width="950px"
      class="dialog-div-pre-style"
      center
      @close="closeClick"
    >
      <div v-if="showDoc == true" style="width:900px;height:500px">
        <iframe :src="'https://view.officeapps.live.com/op/view.aspx?src='+fileUrl" width="100%" height="100%" frameborder="0" />
      </div>
      <div v-else-if="showPdf == true" style="justify-content: center; align-items: center;height:500px">
        <embed :src="fileUrl" style="width: 100%; height: 100%">
      </div>
      <div
        v-else-if="showVideo == true"
        class="dialog-body-content-base-style"
        style="justify-content: center; align-items: center"
      >
        <video-player
          ref="positiveVideoPlayer"
          class="video-player vjs-custom-skin"
          :playsinline="true"
          :options="positivePlayerOptions"
        />
      </div>
      <el-image v-if="showImage" :src="fileUrl" style="width:300px:height:300px">
        <div slot="placeholder" class="image-slot">
          加载中<span class="dot">...</span>
        </div>
      </el-image>
    </el-dialog>
  </div>
</template>
<script>
import { getRoleNamesFromProject, detail } from '@/api/project'
import { getUserList } from '@/api/progressManage'
import { getList, addNode, updateNodeName, deleteNode, shiftUp, shiftDown, upgrade, demotion } from '@/api/ProjectQaOrSafe'
import { saveCommFile, getFileList, deleteFile } from '@/api/commonFile'
import ConnectTask from '@/components/TreeTransfer/connectTask.vue'
export default {
  components: {
    ConnectTask
  },
  props: {
    moduleFlag: {
      type: String,
      default: 'quality'
    },
    maxHeight: {
      type: Number,
      default: 400
    }

  },
  data() {
    return {
      showDoc: false,
      showPdf: false,
      showVideo: false,
      loadDetail: false,
      showImage: false,
      basefileUrl: process.env.VUE_APP_BASE_API + 'bimserver/commonFile/download/',
      pdfBaseUrl: process.env.VUE_APP_BASE_API + 'bimserver/commonFile/IoReadFile/',
      fileUrl: '',
      name: '',
      showTitle: '编辑',
      showQuestionDialog: false,
      titleName: '',
      tableData: [],
      query: {
        isFile: '',
        isTask: ''
      },
      formData: {
        explains: '',
        name: ''
      },
      showFile: false,
      filetoken: '',
      queryArr: [
        { label: '是',
          value: '1' },
        { label: '否',
          value: '0' }
      ],
      stateArr: [{
        label: '待整改',
        value: '1'
      }, {
        label: '已整改',
        value: '2'
      }, {
        label: '关闭',
        value: '3'
      }],
      tmpStateArr: [{
        label: '待整改',
        value: '1'
      }, {
        label: '已整改',
        value: '2'
      }, {
        label: '关闭',
        value: '3'
      }],
      dialogMode: '',
      tablecolumn: [{
        title: '名称', value: 'name', width: 100 }, {
        title: '说明', value: 'explains', width: 100 }, {
        title: '是否关联附件', value: 'associate', width: 60, type: 'file' }, {
        title: '是否关联任务', value: 'isTask', width: 60, type: 'isTask' }, {
        title: '操作', width: 120, type: 'opt' }],
      fileColumns: [{
        title: '序号', type: 'index', width: 100 }, {
        title: '文件名称', value: 'fileName', width: 100 }, {
        title: '上传时间', value: 'uploadTime', width: 100 }, {
        title: '操作', type: 'opt', width: 100 }
      ],
      modeFlag: '',
      rules: {
        name: [
          { required: true, message: '请输入名称', trigger: ' ' }
        ]
      },
      curRow: {},
      isProjectMember: false,
      saveDisable: false,
      isManager: false,
      userId: '',
      saveLoading: false,
      fileData: [],
      progressPercent: 0,
      loading: false,
      showConnectTree: false,
      isProjectover: false
    }
  },
  watch: {
    query: {
      handler() {
        this.getList()
      },
      deep: true

    }
  },
  mounted() {
    this.userId = this.$store.state.user.userId
    this.getProjectMember()
    this.getList()
    this.getRole()
    detail(this.$route.params.id).then((res) => {
      if (res.projectOver) {
        this.isProjectover = true
      } else {
        this.isProjectover = false
      }
    })
  },
  activated() {
    this.getRole()
  },
  methods: {
    closeClick() {
      if (this.showDoc === true) {
        this.showDoc = false
      } else if (this.showPdf === true) {
        this.showPdf = false
      } else if (this.showVideo === true) {
        this.showVideo = false
      } else if (this.showImage === true) {
        this.showImage = false
      }
    },
    preview(row, index) {
      this.fileUrl = this.basefileUrl + row.id
      const path = row.filePath
      if (row && row.fileName) {
        const arr = row.fileName.split('.')
        const type = arr[arr.length - 1]
        if (type === 'png' || type === 'jpg') {
          this.showImage = true
        } else if (type === 'doc' || type === 'docx' || type === 'xsl' || type === 'xlsx') {
          this.fileUrl = process.env.VUE_APP_FILE_API + path.substring(path.indexOf('commonFile/'), path.length) + '/' + row.fileName
          this.showDoc = true
        } else if (type === 'pdf' || type === 'txt') {
          const path = row.filePath
          this.fileUrl = process.env.VUE_APP_FILE_API + path.substring(path.indexOf('commonFile/'), path.length) + '/' + row.fileName
          this.showPdf = true
        } else {
          this.$alert('暂不支持此格式预览,请下载后再查看')
        }
      }
    },
    downLoad(row, index) {
      this.curRow = row
      window.location.href = this.basefileUrl + this.curRow.id
    },
    saveQuestion() {
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.optData(this.dialogMode)
        } else {
          return false
        }
      })
    },
    deleteFile(row, index) {
      deleteFile(row.id).then(res => {
        this.getFileList()
        this.getList()
      })
    },
    sureConnectTask({ keys, taskList }) {
      this.getList()
    },
    onChange(file) {
      this.progressPercent = 0
      this.loading = true
      const d = new FormData()
      d.append('file', file.raw)
      d.append('commonId', this.curRow.id)
      d.append('type', this.moduleFlag === 'quality' ? '1' : '2')
      var onUploadProgress = progressEvent => {
        var complete = (progressEvent.loaded / progressEvent.total * 100 | 0)
        this.progressPercent = complete
      }
      saveCommFile(d, onUploadProgress).then(res => {
        if (res && (res.info || res.istemplent || res.isexcel || res.isdata)) {
          let message = ''
          if (res.info) {
            res.info.forEach(item => {
              message += item + '<br/>'
            })
          }
          if (res.istemplent) {
            message = res.istemplent
          }
          if (res.isexcel) {
            message = res.isexcel
          }
          if (res.isdata) {
            message = res.isdata
          }
          this.$alert(message, '导入错误', {
            confirmButtonText: '确定',
            dangerouslyUseHTMLString: true
          })
        } else {
          this.loading = false
          this.$message({
            type: 'success',
            message: '导入成功!'
          })
          this.getFileList()
          this.getList()
        }
      }).catch(() => {
        this.loading = false
      })
    },
    getFileList() {
      getFileList({ commonId: this.curRow.id }).then(res => {
        this.fileData = res
      })
    },
    getProjectMember() {
      this.projectMember = []
      getUserList({
        'projectId': this.$route.params.id
      }).then(res => {
        this.projectMember = []
        if (!res) return
        res.forEach(element => {
          if (element.id === this.$store.state.user.userId) {
            this.isProjectMember = true
          }
          this.projectMember.push({
            label: element.userName,
            value: element.id
          })
        })
      })
    },
    getRole() {
      // 返回角色
      getRoleNamesFromProject(this.$route.params.id).then((res) => {
        const roleArr = res.split(',')
        this.isManager = roleArr.indexOf('项目经理') !== -1
        // this.isProgressManage = roleArr.indexOf('项目经理') !== -1 || roleArr.indexOf('项目成员') !== -1
      })
    },
    getList(callBack) {
      var queryDict = {
        projectId: this.$route.params.id,
        name: this.name ? this.name.trim() : '',
        isFile: this.query.isFile,
        isTask: this.query.isTask
      }
      if (this.moduleFlag === 'quality') {
        queryDict.type = '1'
      } else {
        queryDict.type = '2'
      }
      getList(queryDict).then(res => {
        this.tableData = res || []
        if (callBack instanceof Function) {
          callBack()
        }
      })
    },
    closeDialog() {
      this.reset()
      this.showQuestionDialog = false
    },
    reset() {
      this.$refs.form.validate((valid) => {
        if (!valid) {
          this.$refs.form.resetFields()
        }
      })

      this.saveDisable = false
      this.formData = {
        name: '',
        explains: ''
      }
    },
    search() {
      this.getList()
    },
    rowClick(row, col, event) {
      this.$refs.treeTable.setCurrentRow(row)
      this.currentNode = row
    },
    addClass({ row, columnIndex }) {
      if (columnIndex !== 1) {
        return 'justcenter'
      } else {
        return ''
      }
    },
    createRecord() {
      this.curRow = {}
      this.showTitle = '编辑'
      this.showQuestionDialog = true
      this.modeFlag = 'create'
    },
    getPath(id, pathArr) {
      pathArr = JSON.parse(JSON.stringify(pathArr))
      var parentId = ''
      this.findTree(this.tableData, (element) => {
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
    getPathName(pathArr) {
      var pathName = ''
      this.findTree(this.tableData, (element) => {
        pathArr.forEach(id => {
          if (element.id === id) {
            if (pathName === '') {
              pathName = element.name
            } else {
              pathName = pathName + ' > ' + element.name
            }
          }
        })
      })
      return pathName
    },
    standardFile(row, index) {
      this.curRow = row
      var pathArr = this.getPath(this.curRow.id, [])
      pathArr.push(this.curRow.id)
      this.curRow.pathName = this.getPathName(pathArr)
      this.getFileList()
      this.showFile = true
    },
    connectTask(row, index) {
      row.pathName = this.getPathName(row.path.split('/'))
      this.curRow = row
      this.showConnectTree = true
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
      this.setNodeInput('addChild') // 添加子节点
    },
    edit() {
      if (!this.currentNode) {
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      this.formData = { ...this.currentNode }
      this.setNodeInput('edit') // 编辑
    },
    setNodeInput(dialogMode) {
      this.showQuestionDialog = true
      this.dialogMode = dialogMode
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
          this.formData.name = this.currentNode.name
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
          requestData = { projectId: this.$route.params.id, name: this.formData.name, explains: this.formData.explains, parentId: '-1', sort: this.tableData.length + 1, leafNode: 1, addNode: 0, type: this.moduleFlag === 'quality' ? '1' : '2' }
        } else if (type === 'addChild') {
          requestData = { projectId: this.$route.params.id, name: this.formData.name, explains: this.formData.explains, parentId: this.currentNode.id, sort: this.currentNode.children ? this.currentNode.children.length + 1 : 1, leafNode: 1, addNode: 1, path: this.currentNode.path, type: this.moduleFlag === 'quality' ? '1' : '2' }
        }
        addNode(requestData).then(res => {
          this.showQuestionDialog = false
          this.formData = { name: '', explains: '' }
          this.optNodeOver()
        })
      } else if (type === 'edit') {
        requestData = { id: this.currentNode.id, name: this.formData.name, explains: this.formData.explains }
        updateNodeName(requestData).then(res => {
          this.formData = { name: '', explains: '' }
          this.optNodeOver()
        })
      } else if (type === 'del') {
        requestData = { name: this.formData.name, explains: this.formData.explains, id: this.currentNode.id, parentId: this.currentNode.parentId, projectId: this.$route.params.id }
        deleteNode(requestData).then(res => {
          this.showQuestionDialog = false
          this.getList()
          this.formData = { name: '', explains: '' }
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
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    optNodeOver() {
      this.optLoad = false
      this.showQuestionDialog = false
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
    }
  }
}
</script>
<style lang="scss" scoped>
.ml-10{
  margin-left: 10px
}
.ml-20{
  margin-left: 20px
}
.mt-10{
  margin-top: 10px
}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;
}
/deep/ .justcenter{
  text-align: center;
}
/deep/.el-upload-dragger {
    background-color: #fff;
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
    width: 365px;
    height: 100px;
    text-align: center;
    position: relative;
    overflow: hidden;
}
/deep/.el-upload-dragger .el-icon-upload {
    font-size: 67px;
    color: #c0c4cc;
    margin: 0px 0 16px;
    line-height: 50px;
}
</style>
