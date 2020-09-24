<template>
  <span>
    <span v-if="autoUpload">
      <span v-if="type==='image'">
        <el-upload
          v-if="disabled===false"
          class="avatar-uploader"
          :action="actionUrl"
          :show-file-list="false"
          :on-success="handleAvatarSuccess"
          :on-error="handleError"
          name="file[]"
          :disabled="disabled"
          list-type="picture"
          :preview-src-list="showPreviewList?[srcUrl]:[]"
        >
          <el-image v-if="srcUrl" :src="srcUrl" class="avatar" fit="cover" :preview-src-list="showPreviewList?[srcUrl]:[]" />
          <i v-else class="el-icon-plus avatar-uploader-icon" />
        </el-upload>
        <span v-else>
          <el-image v-if="srcUrl" :src="srcUrl" class="avatar" fit="cover" :preview-src-list="showPreviewList?[srcUrl]:[]" />
        </span>
      </span>
      <span v-else-if="type ==='file' && !justlook">
        <el-upload
          drag
          :action="actionUrl"
          :on-success="handleAvatarSuccess"
          :on-error="handleError"
          name="file[]"
          :file-list="filelistData"
          :disabled="disabled"
          :on-preview="handlePreview"
          :on-remove="handleRemove"
          multiple
        >
          <i class="el-icon-upload" />
          <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
        </el-upload>
      </span>
      <span v-else-if="type ==='file' && justlook">
        <el-upload
          class="justlook"
          :action="actionUrl"
          :file-list="fileList"
          :disabled="true"
          :on-preview="handlePreview"
          :on-remove="handleRemove"
          name="file[]"
        />
      </span>
    </span>
    <span v-else>
      <el-upload
        drag
        action=""
        :on-success="handleAvatarSuccess"
        :on-error="handleError"
        name="file[]"
        :auto-upload="autoUpload"
        :file-list="filelistData"
        :disabled="disabled"
        :on-preview="handlePreview"
        :on-remove="handleRemove"
        :on-change="onChange"
        multiple
      >
        <i class="el-icon-upload" />
        <div class="el-upload__text">将文件拖到此处，或<em>点击上传</em></div>
      </el-upload>
    </span>
    <el-dialog :visible.sync="loading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>
  </span>
</template>
<script>
// import request from '@/utils/request'
import { saveCommFile, getFileList, deleteFile, getGroupId, getFileFromFileService, deleteFileFromFileService, saveCommFileToFileSerVice } from '@/api/commonFile'
export default {
  name: 'PmUpload',
  model: {
    prop: 'groupId',
    event: 'groupIdChange'
  },
  props: {
    autoUpload: {
      type: Boolean,
      default: true
    },
    bFileSerive: {
      type: Boolean,
      default: true
    },

    src: {
      type: String,
      default: ''
    },
    disabled: {
      type: Boolean,
      default: false
    },
    businessId: {
      type: String,
      default: ''
    },
    reqType: {
      type: String,
      default: '3'
    },
    type: {
      type: String,
      default: 'image'
    },
    groupId: {
      type: String,
      default: ''
    },
    fileList: {
      type: Array,
      default: function() { return [] }
    },
    showPreviewList: {
      type: Boolean,
      default: false
    },
    justlook: {
      type: Boolean,
      default: false
    }

  },
  data() {
    return {
      srcUrl: '',
      actionUrl: '',
      filetoken: '',
      progressPercent: 0,
      loading: false,
      baseUrl: process.env.VUE_APP_FILE_API + 'fileext',
      filelistData: [],
      tmpFileList: []
    }
  },
  watch: {
    src(v) {
      if (v) {
        this.srcUrl = this.baseUrl + '/' + v
        if (this.type === 'file') { this.getFileList() }
      } else {
        this.srcUrl = ''
        this.filelistData = []
      }
    },
    businessId(v) {
      this.initFileList()
    }
  },
  mounted() {
    if (this.bFileSerive) {
      if (this.type === 'file') {
        this.initFileServeiceUrl()
      }
    }
  },

  methods: {
    initFileList() {
      if (this.bFileSerive) {
        this.initFileServeiceUrl()
      } else {
        this.getFileFromLocalService()
      }
    },
    initFileServeiceUrl() {
      this.filetoken = this.$store.state.user.filetoken
      if (this.type === 'image') {
        this.actionUrl = this.baseUrl
      } else if (this.type === 'file') {
        if (this.groupId) {
          this.actionUrl = this.baseUrl + '?groupId=' + this.groupId
          this.getFileListFromFileService()
        } else {
          getGroupId().then(res => {
            this.$emit('groupIdChange', res)
            this.$nextTick(() => {
              this.filelistData = []
              this.actionUrl = this.baseUrl + '?groupId=' + this.groupId
            })
          })
        }
      }
    },
    onChange(file) {
      this.progressPercent = 0
      this.loading = true

      var onUploadProgress = progressEvent => {
        var complete = (progressEvent.loaded / progressEvent.total * 100 | 0)
        this.progressPercent = complete
      }
      const d = new FormData()
      d.append('file', file.raw)
      if (!this.bFileSerive) {
        d.append('commonId', this.businessId)
        d.append('type', this.reqType)
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
            this.getFileFromLocalService(() => {
              this.$emit('handlePreviewFile', { file: res })
            })
          }
        }).catch(() => {
          this.loading = false
        })
      } else {
        d.append('groupId', this.groupId)
        saveCommFileToFileSerVice(d, this.actionUrl, onUploadProgress).then(res => {
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
            this.getFileListFromFileService()
          }
        }).catch(() => {
          this.loading = false
        })
      }
    },
    getFileFromLocalService(callBack) {
      getFileList({ commonId: this.businessId }).then(res => {
        res.forEach(element => {
          element.name = element.fileName
        })
        this.filelistData = res
        if (callBack instanceof Function) {
          callBack()
        }
      })
    },
    getFileListFromFileService() {
      getFileFromFileService(this.groupId).then(res => {
        var tmpArr = []
        res.forEach(element => {
          element.name = element.fileName + element.extension
          tmpArr.push(element)
        })
        this.filelistData = tmpArr
      })
    },
    handleError(Error) {
      this.srcUrl = 'https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png'
    },
    handleAvatarSuccess(res) {
      res.forEach(element => {
        if (this.type === 'image') {
          this.srcUrl = this.baseUrl + '/' + element.id
        } else {
          this.$emit('groupIdChange', element.groupId)
          this.actionUrl = this.baseUrl + '?groupId=' + this.groupId
        }
        element.name = element.fileName
        // this.filelistData.push(element)
      })
      this.getFileListFromFileService()
    },
    handleRemove(file, fileList) {
      if (this.bFileSerive) {
        for (let i = 0; i < this.filelistData.length; i++) {
          if (this.filelistData[i].id === file.id) {
            this.filelistData.splice(i, 1)
            i--
          }
        }
        deleteFileFromFileService({ fileId: file.id }).then(() => {
        })
      } else {
        if (file.id) {
          deleteFile(file.id).then(res => {
            this.getFileFromLocalService(() => {
              this.$emit('handleRemoveFile', { file: file, fileList: res })
            })
          })
        }
      }
    },
    handlePreview(file) {
      if (this.autoUpload) {
        window.location.href = this.baseUrl + '/' + file.id
        this.$emit('handlePreviewFile', { file: file })
      } else {
        window.location.href = process.env.VUE_APP_BASE_API + 'bimserver/commonFile/download/' + file.id
      }
    }
  }

}
</script>
<style scoped lang='scss'>
.avatar-uploader /deep/ .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader /deep/ .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}
.avatar {
  width: 178px;
  height: 178px;
  display: block;
}
 .justlook /deep/ .el-upload-list.el-upload-list--text {
   margin-top:-38px
 }
  /deep/ .el-upload-list__item {
      transition: none !important;
    }
 /deep/ .el-icon-close-tip {
      display: none !important;
    }
</style>
