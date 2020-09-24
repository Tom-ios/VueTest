<template>
  <div ref="root" style="margin-left:10px;margin-right:10px" class="app-container">
    <el-form
      slot="header"
      ref="form"
      :inline="true"
      :model="form"
      size="mini"
      style=""
      @keyup.enter.native="fetchData"
    >
      <el-form-item label="项目编号">
        <el-input
          v-model="form.projectNo"
          placeholder=""
          style="width: 140px;"
        />
      </el-form-item>
      <el-form-item label="项目名称">
        <el-input
          v-model="form.projectName"
          placeholder=""
          style="width: 180px;"
        />
      </el-form-item>
      <!-- <el-form-item label="项目经理">
        <el-select v-model="form.projectManager" placeholder="请选择">
          <el-option
            v-for="item in options"
            :key="item.value"
            :label="item.label"
            :value="item.value"
          />
        </el-select>
      </el-form-item> -->
      <el-form-item>
        <el-button
          type="primary"
          @click="fetchData"
        >
          查询
        </el-button>
      </el-form-item>
      <el-form-item v-if="isManager" style="float: right">
        <el-button
          type="primary"
          @click="add"
        >
          创建项目
        </el-button>
      </el-form-item>
    </el-form>
    <el-row id="idRow" :gutter="20">
      <el-col v-for="(o, index) in data" :key="o.id" :span="span" :style="index>count-1?'margin-top:20px':''">
        <el-card :body-style="{ padding: '0px' }">
          <img v-if="o.projectImg" :src="o.projectImg" class="image cp" style="object-fit:contain" @click="detail(o.id)">
          <img v-else src="@/assets/images/project.jpg" class="image cp" style="object-fit:contain" @click="detail(o.id)">
          <div style="padding: 14px;">
            <span class="name" :title="o.projectName">{{ o.projectName }}</span>
            <div class="bottom clearfix">
              <div style="white-space:nowrap;text-overflow:ellipsis;overflow: hidden;">项目编号：{{ o.projectNo }}</div>
              <div style="display: inline-block">项目经理：{{ o.projectManagerName }}</div>
              <el-tag v-if="o.projectOver" size="mini" class="overtag" type="danger" effect="light">已结项</el-tag>
              <div>
                <div v-if="isManager" class="btndiv">
                  <el-button v-if="!o.projectOver" class="button" type="text" @click="edit(o.id)">编辑项目</el-button>
                  <el-button class="button" type="text" @click="del(o.id)">删除项目</el-button>
                  <el-button class="button" type="text" @click="overDialog(o)">编辑结项</el-button>
                </div>
              </div>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <div v-if="!loading && data.length === 0" class="textCenter">{{ search?'暂无数据':isManager?'当前企业暂无项目，请【创建项目】':'您尚未加入任何项目，请联系项目经理将您加入项目中' }}</div>

    <div v-if="pagination && data.length > 0" class="pagination">
      <el-pagination
        v-bind="pagination"
        @current-change="handleCurrentChange"
      />
    </div>

    <el-dialog title="编辑结项信息" :visible.sync="dialogFormVisible" width="500px">
      <el-form ref="overForm" :model="dialogFormData" :rules="rules" label-width="100px">
        <el-form-item label="项目名称：">
          <span>{{ dialogFormData.projectName }}</span>
        </el-form-item>
        <el-form-item label="项目编号：">
          <span>{{ dialogFormData.projectNo }}</span>
        </el-form-item>
        <el-form-item label="是否结项：" prop="projectOver">
          <el-radio v-model="dialogFormData.projectOver" :label="1">是</el-radio>
          <el-radio v-model="dialogFormData.projectOver" :label="0">否</el-radio>
        </el-form-item>
        <el-form-item v-if="dialogFormData.projectOver == 1" label="结项时间：" prop="projectOverTime">
          <el-date-picker v-model="dialogFormData.projectOverTime" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" />
        </el-form-item>
      </el-form>
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" :loading="submiting" @click="setProjectOver">保 存</el-button>
        <el-button @click="dialogFormVisible = false">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped>
.time {
  font-size: 13px;
  color: #999;
}

.overtag {
  float: right;
  margin-left:20px;
  border-radius:20px;
  background-color: white;
  border-color: #f56c6c;
}

.name {
  height: 36px;
  overflow : hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.bottom {
  margin-top: 13px;
  line-height: 20px;
  font-size: 14px;
  color: gray
}

.button {
  padding-bottom: 0px
}

.btndiv {
  padding: 0;
  float: right;
}

.image {
  width: 100%;
  display: block;
  height: 250px
}

.pagination{
  padding: 15px 0
}

.textCenter{
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #808080
}
</style>

<script>
import { getList, del, setProjectOver } from '@/api/project'
import { getRoleIds } from '@/api/user'

export default {
  name: 'Project',
  data() {
    return {
      data: [],
      form: {
        projectName: '',
        projectNo: ''
      },
      options: [{
        value: '选项1',
        label: '黄金糕'
      }, {
        value: '选项2',
        label: '双皮奶'
      }, {
        value: '选项3',
        label: '蚵仔煎'
      }, {
        value: '选项4',
        label: '龙须面'
      }, {
        value: '选项5',
        label: '北京烤鸭'
      }],
      span: 6,
      count: 0,
      pagination: {
        currentPage: 1,
        pageSize: 20,
        total: 1
      },
      currentPage: 1,
      dialogFormVisible: false,
      dialogFormData: {
      },
      rules: {
        projectOver: [
          { required: true }
        ],
        projectOverTime: [
          { required: true, message: '请填写结项日期' }
        ]
      },
      submiting: false,
      roleIds: '',
      loading: false,
      search: false,
      erd: null
    }
  },
  computed: {
    isManager() {
      return this.roleIds.indexOf('6c946a394b7b4e14ae97') > -1
    }
  },
  watch: {
    'dialogFormData.projectOver': function(v) {
      if (v && !this.dialogFormData.projectOverTime) {
        const date = new Date()
        this.$set(this.dialogFormData, 'projectOverTime', date.getFullYear() + '-' + (date.getMonth() + 1 < 10 ? '0' + (date.getMonth() + 1) : date.getMonth() + 1) + '-' + date.getDate())
      }
    }
  },
  mounted() {
    var elementResizeDetectorMaker = require('element-resize-detector')
    this.erd = elementResizeDetectorMaker()
    this.erd.listenTo(document.getElementById('idRow'), (element) => {
      this.cal()
    })
    getRoleIds().then((res) => {
      this.roleIds = res
    })
    this.fetchData()
  },
  methods: {
    cal() {
      if (this.$refs.root) {
        const tmp = parseInt((this.$refs.root.offsetWidth - 20) / 270)
        this.span = parseInt(24 / tmp)
        this.count = 24 / this.span
      } else {
        setTimeout(() => {
          this.cal()
        }, 1000)
      }
    },
    overDialog(o) {
      if (!o.projectOver) {
        o.projectOver = 0
      }
      this.dialogFormData = JSON.parse(JSON.stringify(o))
      this.dialogFormVisible = true
    },
    handleCurrentChange(v) {
      this.pagination.currentPage = v
      this.fetchData()
    },
    setProjectOver() {
      this.$refs['overForm'].validate((valid) => {
        if (valid) {
          this.submiting = true
          setProjectOver(this.dialogFormData).then((rep) => {
            this.dialogFormVisible = false
            this.fetchData()
          }).catch((err) => {
            console.error(err)
          }).finally(() => {
            this.submiting = false
          })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    edit(id) {
      this.$router.push(`/project/edit/${id}`)
    },
    add() {
      this.$router.push('/project/add')
    },
    del(id) {
      this.$confirm(`确定要 <strong><font size=4>删除</font></strong> 此项目吗?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        return del(id)
      }).then(() => {
        this.fetchData()
      }).catch(() => {
      })
    },
    fetchData() {
      this.loading = true
      const query = this.form
      query.pageSize = this.pagination.pageSize
      query.pageIndex = this.pagination.currentPage - 1
      this.search = query.projectName || query.projectNo
      getList(query).then((data) => {
        this.data = data.rows
        this.pagination.total = data.total
      }).finally(() => {
        this.loading = false
      })
    },
    detail(id) {
      this.$router.push(`/projectSet/setPeople/${id}`)
    }
  }
}
</script>
