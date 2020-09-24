<template>
  <div id="projectDetailSenceOrEffict" style="height:100%;">
    <el-row>
      <el-col :span="activeName=='effectImage'?24:20">

        <el-card :body-style="{ padding: '0px' }" shadow="never">
          <div>
            <i v-if="!selectItem.first && selectSrc " class="el-icon-arrow-left" style="position: relative;left: calc(35%);top: -130px;" @click="previous" />
            <el-image v-if="selectSrc" :src="selectSrc" class="selectDiv">
              <div slot="placeholder" class="image-slot">
                加载中<span class="dot">...</span>
              </div>
            </el-image>
            <div v-else class="selectDiv">
              暂无图片
            </div>
            <i v-if="!selectItem.last && selectSrc" class="el-icon-arrow-right" style="position: relative;top: -130px;" @click="next" />
          </div>
        </el-card>
        <el-card :body-style="{ padding: '0px' }" style="margin-top:30px" shadow="never">
          <div class="imageList">
            <div v-for="(item,index) in srcArr" :key="index" :class="[item.select?'selDiv':'unSelDiv']" @click="selectImage(item)">
              <el-image v-if="item.types!=='add'" :src="item.src" fit="fill" class="eachImage">
                <div slot="placeholder" class="image-slot">
                  加载中<span class="dot">...</span>
                </div>
              </el-image>
              <i v-if="item.types!=='add' && item.select" class="el-icon-close closeBtns" style="color:red" @click="delImage(item.id)" />
              <div v-if="item.types!=='add' && item.select" class="selectUpDown" />
              <el-upload
                v-if="item.types!=='img'"
                ref="upload"
                class="avatar-uploader"
                action=""
                :on-change="onChange"
                :auto-upload="false"
                accept=".jpg,.png"
                :show-file-list="false"
              >
                <i class="el-icon-plus avatar-uploader-icon" />
              </el-upload>
            </div>

          </div>
        </el-card>
      </el-col>
      <el-col :span="activeName=='effectImage'?0:4">
        <div>
          <el-button style="margin-left:10px" type="primary" @click="modifyOrSave">{{ mode==='modify'?'修改':'保存' }}</el-button>
          <el-button v-if="mode==='save'" style="margin-left:10px" type="primary" plain @click="cancel">取消</el-button>
        </div>
        <el-input v-model="selectItem.remark" :readonly="mode==='modify'" rows="22" style="margin-top:8px;margin-left:8px;margin-right:10px;" type="textarea" />

      </el-col>
    </el-row>
    <el-dialog :visible.sync="loading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>

  </div>
</template>
<style>
</style>
<script>
import { saveCommFile, getFileList, deleteFile, updateDes } from '@/api/commonFile'
export default {
  props: {
    type: {
      type: String,
      default: 'effectImage'
    },
    activeName: {
      type: String,
      default: 'effectImage'
    }
  },
  data() {
    return {
      fileData: [],
      srcArr: [{ types: 'add', src: '' }],
      progressPercent: 0,
      loading: false,
      selectSrc: '',
      selectItem: {
        remark: ''
      },
      mode: 'modify',
      OldSrcArr: []

    }
  },
  watch: {
    activeName(v) {
      this.getData()
    },
    selectSrc(v) {
      this.getSelectSrc()
    }
  },
  mounted() {
    this.getData()
  },
  methods: {
    previous() {
      if (this.selectItem) {
        for (let i = 0; i < this.srcArr.length; i++) {
          if (this.srcArr[i].types !== 'img') {
            continue
          }
          if (this.srcArr[i].id === this.selectItem.id) {
            this.selectItem = { ...{}, ...this.srcArr[i - 1] }
            this.selectSrc = this.selectItem.src
            return
          }
        }
      }
    },
    next() {
      if (this.selectItem) {
        for (let i = 0; i < this.srcArr.length; i++) {
          if (this.srcArr[i].types !== 'img') {
            continue
          }
          if (this.srcArr[i].id === this.selectItem.id) {
            this.selectItem = { ...{}, ...this.srcArr[i + 1] }
            this.selectSrc = this.selectItem.src
            return
          }
        }
      }
    },
    cancel() {
      this.mode = 'modify'
      this.OldSrcArr.forEach(eachItem => {
        if (this.selectItem.id === eachItem.id) {
          this.selectItem.remark = eachItem.remark
        }
      })
    },
    modifyOrSave() {
      if (this.mode === 'modify') {
        if (!this.selectItem.id) {
          this.$alert('请选择进度实景记录图片')
          return
        }
        this.mode = 'save'
      } else {
        var data = {
          ...this.selectItem,
          remark: this.selectItem ? this.selectItem.remark : ''
        }
        if (data.hasOwnProperty('img')) {
          delete data.img
        }
        if (data.hasOwnProperty('select')) {
          delete data.select
        }
        if (data.hasOwnProperty('src')) {
          delete data.src
        }
        updateDes(data).then(res => {
          this.getData()
          this.mode = 'modify'
        })
      }
    },
    selectImage(selItem) {
      if (selItem.types !== 'img') {
        return
      }
      this.selectItem = selItem
      this.selectSrc = selItem.src
      this.srcArr.forEach(eachItem => {
        if (eachItem.src === selItem.src) {
          this.$set(eachItem, 'select', true)
        } else {
          this.$set(eachItem, 'select', false)
        }
      })
    },
    getSelectSrc() {
      if (this.srcArr.length > 1) {
        if (this.selectSrc === '') {
          this.selectSrc = this.srcArr[0].src
          this.selectItem = this.srcArr[0]
          this.$set(this.srcArr[0], 'select', true)
        } else {
          for (let i = 0; i < this.srcArr.length; i++) {
            var eachItem = this.srcArr[i]
            if (i === 0) {
              eachItem.first = true
            } else if (i === this.srcArr.length - 2) {
              eachItem.last = true
            }
            if (this.selectSrc === eachItem.src) {
              this.selectItem = eachItem
              this.$set(eachItem, 'select', true)
            } else {
              this.$set(eachItem, 'select', false)
            }
          }
        }
      }
    },
    getData() {
      if (this.type !== this.activeName) {
        return
      }
      getFileList({ commonId: this.$route.params.id, type: this.type === 'effectImage' ? '1' : '2' }).then(res => {
        if (res) {
          this.srcArr = []
          res.forEach(element => {
            var item = { ...element, ...{ types: 'img', src: '', select: false }}
            item.src = process.env.VUE_APP_BASE_API + 'bimserver/commonFile/IoReadFile/' + element.id
            if (this.selectSrc !== '' && item.src === this.selectSrc) {
              item.select = true
            }
            this.srcArr.push(item)
          })
          this.srcArr.push({ types: 'add', src: '' })
          this.OldSrcArr = JSON.parse(JSON.stringify(this.srcArr))
          this.getSelectSrc()
        }
      })
    },
    onChange(file) {
      this.progressPercent = 0
      this.loading = true
      const d = new FormData()
      d.append('file', file.raw)
      d.append('commonId', this.$route.params.id)
      d.append('type', this.type === 'effectImage' ? '1' : '2')
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
          this.getData()
        }
      }).catch(() => {
        this.loading = false
      })
    },
    delImage(curImage) {
      if (!curImage) {
        return
      }
      deleteFile(curImage).then(() => {
        for (var i = 0; i < this.srcArr.length; i++) {
          if (curImage === this.srcArr[i].id) {
            this.srcArr.splice(i, 1)
            i--
            this.selectSrc = ''
            this.selectItem = { remark: '' }
          }
        }
      })
    }
  }
}
</script>
<style lang="scss" >
#projectDetailSenceOrEffict .selectDiv {
width:30%;
height:300px;
margin-left:35%;
text-align:center;
line-height:300px;
}
 #projectDetailSenceOrEffict .avatar-uploader .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
  }
 #projectDetailSenceOrEffict .avatar {
    width: 100px;
    height: 100px;
    display: block;
  }
  #projectDetailSenceOrEffict .avatar-uploader  .el-upload:hover {
    border-color: #409EFF;
  }
  #projectDetailSenceOrEffict .avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 100px;
    height: 100px;
    line-height: 100px;
    text-align: center;
  }
  #projectDetailSenceOrEffict .imageList {
    overflow-x: auto;
    overflow-y: hidden;
    height:130px;
    white-space: nowrap;
    padding: 0 10px;
  }
  #projectDetailSenceOrEffict .unSelDiv{
    position:relative;
    top:20px;
    width:100px;
    height:100px;
    margin-right:10px;
    display:inline-block;
    border-radius: 2px;
  }
  #projectDetailSenceOrEffict .selDiv{
    position:relative;
    top:20px;
    width:104px;
    height:104px;
    margin-right:10px;
    display:inline-block;
    border:2px solid red;
   border-radius: 2px;
  }
  #projectDetailSenceOrEffict .eachImage{
    height:100px;
    width:100px;
  }
  #projectDetailSenceOrEffict .closeBtns{
  position:absolute;
  right:3px;
  top:2px;
  line-height: 18px;
  cursor: pointer;
}
#projectDetailSenceOrEffict .selectUpDown{
 position: absolute;
   right:58px;
  top:-22px;
}
#projectDetailSenceOrEffict .selectUpDown:before,.selectUpDown:after{
 position: absolute;
 content: '';
 border-top: 10px transparent dashed;
 border-left: 10px transparent dashed;
 border-right: 10px transparent dashed;
 border-bottom: 10px #fff solid;
}
#projectDetailSenceOrEffict .selectUpDown:before{
 border-bottom: 10px red solid;
}
#projectDetailSenceOrEffict .selectUpDown:after{
 top: 2px; /*覆盖并错开1px*/
 border-bottom: 10px #fff solid;
}
</style>
