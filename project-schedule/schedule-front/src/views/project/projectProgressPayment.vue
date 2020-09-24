<template>

  <div class="clearfix">
    <div class="clearfix">
      <!-- <div style="float:left;margin-top:15px">
        <span style="margin-left:20px;font-size:14px">是否关联附件</span>
        <el-select v-model="query.linkFile" size="mini" placeholder="全部" clearable style="width:140px;margin-left:5px">
          <el-option v-for="item in queryArr" :key="item.value" size="mini" :label="item.label" :value="item.value" />
        </el-select>
      </div> -->
      <div style="float:left;margin-top:15px">
        <span style="margin-left:20px;font-size:14px">是否关联任务</span>
        <el-select v-model="query.isTask" size="mini" placeholder="全部" clearable style="width:140px;margin-left:5px">
          <el-option v-for="item in queryArr" :key="item.value" size="mini" :label="item.label" :value="item.value" />
        </el-select>
      </div>
      <el-button type="primary" size="small" style="float:right;margin-right:10px;margin-top:10px" @click="addPayment">增加</el-button>
    </div>
    <el-table
      :data="tableData"
      border
      stripe
      :header-cell-class-name="'tableHeader'"
      :cell-class-name="addClass"
      style="margin-top:10px"
    >
      <el-table-column
        v-for="(col,index) in tablecolumn"
        :key="index"
        :prop="col.value"
        :label="col.title"
        :min-width="col.width?col.width:'100'"
      >
        <template slot-scope="scope">
          <span v-if="tablecolumn[index].type==='opt'">
            <el-button v-if="isManager || (userId === scope.row.createUser) && false" type="text" @click="standardFile(scope.row,scope.$index)">标准附件</el-button>
            <el-button v-if="isManager || (userId === scope.row.createUser)" type="text" @click="connectTask(scope.row,scope.$index)">关联任务</el-button>
            <el-button v-if="isManager || (userId === scope.row.createUser)" type="text" @click="editRow(scope.row,scope.$index)">编辑</el-button>
            <el-button v-if="isManager || (userId === scope.row.createUser)" type="text" @click="deleteRow(scope.row,scope.$index)">删除</el-button>
            <el-button v-if="(isManager || (userId === scope.row.createUser)) && (scope.$index!== 0)" type="text" @click="shift(scope.row,scope.$index)">上移</el-button>
            <el-button v-if="(isManager || (userId === scope.row.createUser)&& !scope.row.isLast)" type="text" @click="down(scope.row,scope.$index)">下移</el-button>
          </span>
          <span v-else-if="tablecolumn[index].type==='index'"> {{ scope.$index +1 }}</span>
          <span v-else-if="tablecolumn[index].type==='file'">
            <!-- <span v-if="scope.row[tablecolumn[index].value]>0">是</span>
            <span v-else>否</span> -->
            <a style="color:#409EFF" @click.prevent="standardFile(scope.row)"> {{ scope.row[tablecolumn[index].value] }}</a>
          </span>

          <span v-else> {{ scope.row[tablecolumn[index].value] }}</span>
        </template>
        <el-table-column
          v-for="(singleCol,singleIndex) in tablecolumn[index].arrCol"
          :key="singleIndex"
          :prop="singleCol.value"
          :label="singleCol.title"
          :min-width="singleCol.width?singleCol.width:'100'"
        />
      </el-table-column>
    </el-table>
    <el-dialog
      title="标准附件"
      center
      :visible.sync="showFile"
      width="600px"
      @close="showFile=false"
    >
      <div class="clearfix" style="margin-top: -35px;">
        <div class="clearfix">
          <el-upload
            ref="upload"
            action=""
            :on-change="onChange"
            :auto-upload="false"
            :show-file-list="false"
            style="display: inline-block;float:right;right-margin:10px"
          >
            <el-button type="primary" size="small">添加附件</el-button>
          </el-upload>
        </div>
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
    <el-dialog :visible.sync="loading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>
  </div>
</template>
<script>
import { getList, deleteNode, shiftUpDown } from '@/api/projectProgressPayment.js'
import ConnectTask from '@/components/TreeTransfer/connectTask.vue'
import { saveCommFile, getFileList } from '@/api/commonFile'
export default {
  components: {
    ConnectTask
  },
  data() {
    return {
      loading: false,
      progressPercent: 0,
      showDoc: false,
      showPdf: false,
      showVideo: false,
      loadDetail: false,
      showImage: false,
      basefileUrl: process.env.VUE_APP_BASE_API + 'bimserver/commonFile/download/',
      pdfBaseUrl: process.env.VUE_APP_BASE_API + 'bimserver/commonFile/IoReadFile/',
      fileUrl: '',
      fileColumns: [{
        title: '序号', type: 'index', width: 100 }, {
        title: '文件名称', value: 'fileName', width: 100 }, {
        title: '上传时间', value: 'uploadTime', width: 100 }, {
        title: '操作', type: 'opt', width: 100 }
      ],
      showFile: false,
      fileData: [],
      curRow: {},
      showConnectTree: false,
      isManager: false,
      userId: '',
      tableData: [],
      query: {
        isTask: '',
        linkFile: ''
      },
      queryArr: [
        { label: '是',
          value: '1' },
        { label: '否',
          value: '0' }
      ],
      tablecolumn: [{
        title: '序号', value: 'index', width: 50, type: 'index' }, {
        title: '申请部门', value: 'applyDep', width: 100 }, {
        title: '审批部门', value: 'approvalDep', width: 100 }, {
        title: '开始日期', value: 'beginDate', width: 100 }, {
        title: '结束日期', value: 'endDate', width: 100 }, {
        title: '合同价款(元)', value: 'contractPrice', width: 100 }, {
        title: '扣除预付款(%)', value: 'deductionAdvanceCharge', width: 100 }, {
        title: '扣除质保金(元)', value: 'deductionPremium', width: 100 }, {
        title: '安全文明施工费', value: 'isTask', width: 100, type: 'total',
        arrCol: [
          { title: '本期完成(元)', value: 'currentComplete', width: 100 }, {
            title: '累计完成(元)', value: 'cumulativeComplete', width: 100 }, {
            title: '累计完成占比(%)', value: 'cumulativeCompletePercent', width: 100 }
        ]
      }, {
        title: '实际进度款(元)', value: 'actualProgressPrice', width: 100 }, {
        title: '附件', value: 'groupNum', width: 60, type: 'file' }, {
        title: '是否关联任务', value: 'linkTask', width: 60 }, {
        title: '操作', width: 260, type: 'opt' }]
    }
  },
  watch: {
    query: {
      handler(newValue, oldValue) {
        this.getList()
      },
      deep: true,
      immediate: true
    }

  },
  mounted() {
    this.userId = this.$store.state.user.userId
    this.getList()
  },

  methods: {
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
    sureConnectTask({ keys, taskList }) {
      this.getList()
    },
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
      window.location.href = process.env.VUE_APP_BASE_API + 'bimserver/commonFile/download/' + row.id
    },
    connectTask(row) {
      this.curRow = row
      this.showConnectTree = true
    },
    standardFile(row) {
      this.curRow = row
      this.getFileList()
      this.showFile = true
    },
    getFileList() {
      getFileList({ commonId: this.curRow.id }).then(res => {
        this.fileData = res
      })
    },
    getList() {
      getList({ projectId: this.$route.params.id, linkTask: this.query.isTask, linkFile: this.query.linkFile }).then(res => {
        for (let i = 0; i < res.length; i++) {
          res[i].isLast = i === res.length - 1
        }
        this.tableData = res
      })
    },
    editRow(row) {
      this.$router.push({ path: '/projectProgressPayment/edit/' + this.$route.params.id, query: { mode: 'edit', id: row.id }})
    },
    deleteRow(row) {
      deleteNode(row.id).then(() => {
        this.getList()
      }
      )
    },
    shift(row) {
      var tanstoId = ''
      for (let i = 0; i < this.tableData.length; i++) {
        if (this.tableData[i].id === row.id) {
          tanstoId = this.tableData[i - 1].id
          break
        }
      }
      var data = { transFrom: row.id, transTo: tanstoId }
      shiftUpDown(data).then(() => {
        this.getList()
      })
    },
    down(row) {
      var tanstoId = ''
      for (let i = 0; i < this.tableData.length; i++) {
        if (this.tableData[i].id === row.id) {
          tanstoId = this.tableData[i + 1].id
          break
        }
      }
      var data = { transFrom: row.id, transTo: tanstoId }
      shiftUpDown(data).then(() => {
        this.getList()
      })
    },
    addPayment() {
      this.$router.push({ path: '/projectProgressPayment/edit/' + this.$route.params.id, query: { mode: 'add' }})
    },
    addClass() {
      return 'justcenter'
    }
  }
}
</script>
<style  lang="scss" scoped>
/deep/ .el-button--text+.el-button--text {
    margin-left: 0px;
}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;
}
/deep/ .justcenter{
  text-align: center;
}
</style>

