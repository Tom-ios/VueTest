<template>
  <div ref="main" :body-style="{ padding: '0px' }" shadow="never" style="height: 100%">
    <div class="progressHeader">
      <span v-if="flag==='quality'">质量管理</span>
      <span v-else>安全管理</span>
    </div>
    <div class="mt-10" style="font-size:13px">
      <span class="ml-20">名称</span>
      <el-input
        v-model="qcTitle"
        size="small"
        style="width:30%;margin-left:5px"
        clearable
        @keyup.enter.native="search"
      />
      <span class="ml-10"> 是否关联</span>
      <el-select v-model="query.flag" placeholder="请选择" clearable style="width:90px;margin-left:5px">
        <el-option v-for="item in flagArr" :key="item.value" :label="item.label" :value="item.value" />
      </el-select>
      <el-button
        type="primary"
        class="ml-10"
        size="mini"
        @click="search"
      >查询</el-button>
    </div>
    <ul class="infinite-list" :style="{overflow:'auto','max-height':maxHeight+'px'}">
      <li
        v-for="(itemcol,index) in questionList"
        :key="index"
        class="list-li"
      >
        <div :style="{'background-color':(itemcol.highLight?'#b9d7fa':'#f2f2f2')}" class="clearfix cell" @click="rowClick(itemcol)">
          <el-image :src="itemcol.pointGroupId" class="recImage" :show-preview-list="true">
            <div slot="error" class="el-image__error" />
          </el-image>
          <!-- <div v-else class="recImage" style="text-align:center;line-height: 70px;border:">暂无图片</div> -->
          <div style="position:relative;top:15px;left:10px;padding-right:15px;white-space:nowrap;text-overflow:ellipsis;overflow: hidden;"> {{ itemcol.qcTitle }}</div>
          <div class="describe"> {{ itemcol.qcDescribe }}</div>
          <div style="position:absolute;right:10px;top:30px">
            <el-button type="text" @click="jumpToDetail(itemcol)">查看</el-button>
            <el-button v-if="(userId=== itemcol.createUser || isManager)&&!isProjectOver" type="text" @click.stop="aboutLocation(itemcol)">{{ itemcol.point?'取消关联':'关联位置' }}</el-button>

          </div>
        </div>
      </li>
      <div v-if="questionList.length===0" style="margin-top:45%;text-align:center;font-size:14px;color:#909399">暂无数据</div>
    </ul>
    <el-dialog
      title="查看问题"
      :visible.sync="showQuestionDialog"
      width="800px"
      center
      :close-on-click-modal="false"
      @close="closeDialog"
    >
      <div>
        <el-form ref="form" label-width="100px" :model="formData">
          <el-row>
            <el-col :span="15">
              <el-form-item label="标题：">
                <span>{{ formData.qcTitle }}</span>
              </el-form-item>
              <el-form-item label="责任人：">
                <span>{{ formData.qcOwnersName }}</span>
              </el-form-item>
              <el-form-item label="位置：" maxlength="50">
                <span>{{ formData.qcPosition }}</span>
              </el-form-item>
              <el-form-item label="问题描述：" maxlength="500">
                <span>{{ formData.qcDescribe }}</span>
              </el-form-item>
              <el-form-item label="附件：">
                <ImageUpload :src="formData.groupId" type="file" :file-list="formData.fileList" :justlook="true" />
              </el-form-item>
            </el-col>
            <el-col :span="9">
              <el-form-item label="现场图片：">
                <ImageUpload :src="formData.picturesId" :disabled="true" :show-preview-list="true" />
              </el-form-item>
            </el-col>
          </el-row>
        </el-form>
        <el-table
          :data="formData.qcSafeRecordInfo"
          :header-cell-class-name="'tableHeader'"
          :cell-class-name="addClass"
          border
          stripe
        >
          <el-table-column
            v-for="(col,index) in stateChangeColumns"
            :key="index"
            :prop="col.value"
            :label="col.title"
            :min-width="col.width?col.width:'100'"
          />
        </el-table>
      </div>
    </el-dialog>
  </div>

</template>

<script>
import ImageUpload from '@/components/FileUpload/index'
import { getQualityList, getQualityDetail, getSafeList, getSafeDetail, qualityAssociatedPoint, safeAssociatedPoint } from '@/api/ProjectQaOrSafe'
export default {
  components: {
    ImageUpload
  },
  props: {
    flag: {
      type: String,
      default: 'quality'
    },
    bim: {
      type: Object,
      default: function() { return {} }
    },
    isManager: {
      type: Boolean,
      default: false
    },
    isProjectOver: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      flagArr: [{
        label: '是',
        value: '1'
      }, {
        label: '否',
        value: '0'
      }],
      questionList: [],
      stateChangeColumns: [{
        title: '操作', value: 'handleName', width: 100 }, {
        title: '操作人', value: 'handleUserName', width: 100 }, {
        title: '操作时间', value: 'handleTime', width: 100 }, {
        title: '问题状态', value: 'qcStatusName', width: 100 }, {
        title: '说明', value: 'state', width: 100 }],
      formData: {},
      showQuestionDialog: false,
      query: {
        flag: ''
      },
      qcTitle: '',
      curRow: {},
      userId: '',
      maxHeight: 400,
      previewSrcList: ['https://fuss10.elemecdn.com/8/27/f01c15bb73e1ef3793e64e6b7bbccjpeg.jpeg', 'https://fuss10.elemecdn.com/8/27/f01c15bb73e1ef3793e64e6b7bbccjpeg.jpeg']
    }
  },
  watch: {
    flag(v) {
      this.qcTitle = ''
      this.query.flag = ''
      this.getList()
    },
    query: {
      handler() {
        this.getList()
      },
      deep: true
    }
  },
  activated() {
    this.getList()
  },
  mounted() {
    this.cal()
    this.userId = this.$store.state.user.userId
    this.getList()
  },
  methods: {
    cal() {
      this.maxHeight = this.$refs.main.clientHeight - 120
    },
    rowClick(rowData) {
      if (this.curRow.highLight) {
        this.$set(this.curRow, 'highLight', false)
      }
      this.curRow = rowData
      this.$set(this.curRow, 'highLight', true)
      if (this.curRow.point) {
        var point = JSON.parse(this.curRow.point)
        point.duration = 500
        this.bim.setCamera(point)
      }
    },
    search() {
      this.getList()
    },
    addClass() {
      return 'justcenter'
    },
    closeDialog() {
      this.showQuestionDialog = false
    },
    getList() {
      var questData = {
      }

      if (this.flag === 'quality') {
        questData = {
          projectId: this.$route.params.id,
          qcTitle: this.qcTitle ? this.qcTitle.trim() : '',
          flag: this.query.flag
        }
        getQualityList(questData).then(res => {
          this.questionList = res
        })
      } else {
        questData = {
          projectId: this.$route.params.id,
          safeTitle: this.qcTitle ? this.qcTitle.trim() : '',
          flag: this.query.flag
        }
        getSafeList(questData).then(res => {
          res.forEach(element => {
            this.swiftsafeToqc(element)
          })
          this.questionList = res
        })
      }
    },
    swiftsafeToqc(element) {
      for (var key in element) {
        if (key.indexOf('safe') === 0) {
          var newKey = 'qc' + key.substring(4)
          element[newKey] = element[key]
        }
      }
    },
    jumpToDetail(rowData) {
      if (this.flag === 'quality') {
        getQualityDetail(rowData.id).then(res => {
          if (res && res.fileInfo) {
            res.fileList = JSON.parse(res.fileInfo)
          } else {
            res.fileList = []
          }
          this.formData = res
        }).finally(() => {
          this.showQuestionDialog = true
        })
      } else {
        getSafeDetail(rowData.id).then(res => {
          this.swiftsafeToqc(res)
          if (res && res.fileInfo) {
            res.fileList = JSON.parse(res.fileInfo)
          } else {
            res.fileList = []
          }
          this.formData = res
        }).finally(() => {
          this.showQuestionDialog = true
        })
      }
    },
    aboutLocation(rowData) {
      var point = ''
      if (!rowData.point) {
        const base64DataImage = this.bim.toDataURL()
        this.formData.pointGroupId = base64DataImage
        point = JSON.stringify(this.bim.getCamera())
        const requestDict = {
          id: rowData.id,
          point: point,
          pointGroupId: base64DataImage
        }
        if (this.flag === 'quality') {
          qualityAssociatedPoint(requestDict).then(res => {
            this.getList()
          })
        } else {
          safeAssociatedPoint(requestDict).then(res => {
            this.getList()
          })
        }
      } else {
        this.$confirm(`是否确认取消定位?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          dangerouslyUseHTMLString: true
        }).then(() => {
          const requestDict = {
            id: rowData.id,
            point: point,
            pointGroupId: ''
          }
          if (this.flag === 'quality') {
            qualityAssociatedPoint(requestDict).then(res => {
              this.getList()
            })
          } else {
            safeAssociatedPoint(requestDict).then(res => {
              this.getList()
            })
          }
        }).catch(() => {
        })
      }
    }
  }
}
</script >
<style scoped lang="scss">
.progressHeader {
  border: 1px solid #EBEEF5;
  font-size:14px;
  background: rgb(236, 238, 241);
  height:30px;
  line-height: 30px;
  margin-top:-2px;
  padding-left: 10px;
  margin-left: 10px;
}
li.list-li {
  list-style-type:none;
  margin-left:-30px
}
.recImage {
height:70px;
width: 120px;
margin-top:15px;
margin-left:10px;
float:left
}
.describe {
  position:relative;
  top:30px;
  left:10px;
  padding-right:110px;
  text-overflow: -o-ellipsis-lastline;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 4;
  -webkit-box-orient: vertical;
  font-size:12px;
  color:#919191
}
.mt-10{
  margin-top:10px
}
.ml-10{
  margin-left:10px
}
.ml-20{
  margin-left:20px
}
.cell {
  height:100px;
  margin-bottom:20px;
  margin-right:10px;
  font-size:14px;
  position:relative;
}
/deep/ .el-upload-list__item {
      transition: none !important;
    }
</style>
