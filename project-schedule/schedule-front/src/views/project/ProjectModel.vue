<template>
  <div id="projectModel">
    <div class="clearfix">
      <div style="float:right;margin-right:10px">
        <el-button v-if="isManager" type="primary" @click="editInfo">编辑模型信息</el-button>
        <el-upload
          v-if="isManager"
          ref="upload"
          action=""
          :on-change="onChange"
          :auto-upload="false"
          :show-file-list="false"
          style="display: inline-block"
        >
          <el-button type="primary">导入模型</el-button>
        </el-upload>
      </div>
    </div>
    <el-form ref="form" label-width="100px">
      <d2-crud
        ref="d2Crud"
        v-loading="delloading"
        element-loading-text="正在删除中"
        :columns="columns"
        :index-row="indexRow"
        :row-handle="rowHandle"
        :data="data"
        @del="handleRowRemove"
        @export="handleExport"
        @moveUp="moveUp"
        @moveDown="moveDown"
      />
    </el-form>
    <el-dialog :visible.sync="loading" width="400px" :show-close="false" title="正在导入..." :close-on-click-modal="false">
      <el-progress type="circle" :percentage="progressPercent" style="left:100px" />
    </el-dialog>
  </div>
</template>

<script>
import { getList, del, add, move } from '@/api/model'
import { getRoleNamesByProject } from '@/api/project'
export default {
  name: 'ProjectModel',
  data() {
    return {
      indexRow: {
        title: '序号'
      },
      timer: null,
      columns: [
        {
          title: '模型文件',
          key: 'moduleName',
          component: {
            render: function(h, scope) {
              if (scope.state === 0 || scope.state === 2) {
                const type = scope.state === 2 ? 'danger' : 'success'
                return (
                  <div>
                    <span style='margin-right:20px'>{scope.moduleName}</span>
                    <el-tag type={type} size='small'>{scope.stateName}</el-tag>
                  </div>
                )
              } else {
                return (
                  <span>{scope.moduleName}</span>
                )
              }
            }
          }
        },
        {
          title: '导入人',
          key: 'impUserName',
          width: 150
        },
        {
          title: '导入时间',
          key: 'impDate',
          width: 200
        },
        {
          title: '文件大小',
          key: 'size',
          width: 150
        }
      ],
      data: [
      ],
      rowHandle: {
        width: '170px',
        custom: [
          {
            text: '导出',
            type: 'text',
            size: 'mini',
            emit: 'export'
          },
          {
            text: '删除',
            type: 'text',
            size: 'mini',
            emit: 'del',
            show(index, row) {
              return row.isManager
            }
          },
          {
            text: '上移',
            type: 'text',
            size: 'mini',
            emit: 'moveUp',
            show(index, row) {
              return row.isManager && index !== 0
            }
          },
          {
            text: '下移',
            type: 'text',
            size: 'mini',
            emit: 'moveDown',
            show(index, row) {
              return row.isManager && !row.isLast
            }
          }
        ]
      },
      uploadVisible: false,
      isManager: false,
      loading: false,
      delloading: false,
      progressPercent: 0
    }
  },
  created() {
    this.timer = setInterval(() => {
      var isExit = false
      this.data.forEach(element => {
        if (element.state === 0) {
          isExit = true
        }
      })
      if (isExit) {
        this.fetchData()
      }
    }, 10000)
    getRoleNamesByProject(this.$route.params.id).then(res => {
      const roleArr = res.split(',')
      this.isManager = roleArr.indexOf('属性维护人员') !== -1 || roleArr.indexOf('项目经理') !== -1
      this.fetchData()
    })
  },
  beforeDestroy() {
    clearInterval(this.timer)
    this.timer = null
  },
  methods: {
    onChange(file) {
      this.progressPercent = 0
      this.loading = true
      const d = new FormData()
      d.append('file', file.raw)
      d.append('projectId', this.$route.params.id)
      var onUploadProgress = progressEvent => {
        var complete = (progressEvent.loaded / progressEvent.total * 100 | 0)
        this.progressPercent = complete
      }

      add(d, onUploadProgress).then(res => {
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
          this.fetchData()
        }
      }).catch(() => {
        this.loading = false
      })
    },
    handleExport({ row }) {
      const url = process.env.VUE_APP_BASE_API + 'bimserver/projectModule/download/' + row.id
      var eleLink = document.createElement('a')
      // eleLink.download = url
      eleLink.style.display = 'none'
      eleLink.href = url
      // // 触发点击
      document.body.appendChild(eleLink)
      eleLink.click()
      // // 然后移除
      document.body.removeChild(eleLink)
    },
    handleRowRemove({ row }) {
      this.$confirm(`确定要 <strong><font size=4>删除</font></strong> ${row.moduleName}吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        this.delloading = true
        del(row.id).then(() => {
          this.delloading = false
          this.$message({
            type: 'success',
            message: '删除成功!'
          })
          this.fetchData()
        }).catch(() => {
          this.delloading = false
        })
      }).catch(() => {
      })
    },
    editInfo() {
      if (this.data.length === 0) {
        return this.$message({
          message: '请导入模型',
          type: 'error'
        })
      }
      this.$router.push(`/projectModelView/edit/${this.$route.params.id}`)
    },
    fetchData() {
      getList({ projectId: this.$route.params.id }).then((data) => {
        this.data = data.rows
        for (let i = 0; i < data.rows.length; i++) {
          data.rows[i].isManager = this.isManager
          data.rows[i].isLast = i === data.total - 1
        }
      })
    },
    moveUp({ index }) {
      move(this.data[index].id, this.data[index - 1].id).then(() => {
        this.fetchData()
      })
    },
    moveDown({ index }) {
      move(this.data[index].id, this.data[index + 1].id).then(() => {
        this.fetchData()
      })
    },
    formatBytes(bytes, decimals) {
      if (bytes === 0) {
        return '0 Bytes'
      }
      var k = 1000
      var dm = decimals + 1 || 3
      var sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB']
      var i = Math.floor(Math.log(bytes) / Math.log(k))
      return parseFloat((bytes / Math.pow(k, i)).toFixed(dm)) + ' ' + sizes[i]
    }
  }
}
</script>

<style>
#projectModel .el-button--text+.el-button--text {
    margin-left: 0px;
}
#projectModel .el-button--text:after {
  content: "|";
  color: #606266;
}
#projectModel .el-button--text:last-child:after {
  display: none;
}
</style>
