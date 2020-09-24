<template>
  <div ref="pageDiv" class="pageDiv">
    <el-tabs
      v-model="activeName"
      type="border-card"
      style="height:100%"
      @tab-click="handleClick"
    >
      <el-tab-pane label="基本信息" name="baseInfo">
        <el-form ref="form" label-width="100px">
          <div>
            <el-row>
              <el-col :span="12">
                <el-form-item label="项目名称：">
                  <span>{{ projectInfo.projectName }}</span>
                  <el-tag
                    v-if="projectInfo.projectOver"
                    class="overtag"
                    type="danger"
                    effect="light"
                  >
                    已结项
                  </el-tag>
                </el-form-item>
              </el-col>
              <el-col :span="24">
                <el-form-item label="项目编号：">
                  <span>{{ projectInfo.projectNo }}</span>
                </el-form-item>
              </el-col>
              <el-col :span="24">
                <el-form-item label="立项时间：">
                  <span>{{ projectInfo.projectDate }}</span>
                </el-form-item>
              </el-col>
              <el-col :span="24">
                <el-form-item label="项目经理：">
                  <span>{{ projectInfo.projectManagerName }}</span>
                </el-form-item>
              </el-col>
              <el-col :span="projectInfo.projectOver?12:24">
                <el-form-item label="联系方式：">
                  <span>{{ projectInfo.projectManagerTel }}</span>
                </el-form-item>
              </el-col>
              <el-col v-if="projectInfo.projectOver" :span="12">
                <el-form-item label="结项时间：">
                  <span>{{ projectInfo.projectOverTime }}</span>
                </el-form-item>
              </el-col>
              <el-col v-for="(item, index) in projectInfo.list" :key="index" :span="item.ratio == '1'?24:12">
                <el-form-item :label="item.projectKey+'：'">
                  <span>{{ item.projectValue }}</span>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="创建人：">
                  <span>{{ projectInfo.createUserName }}</span>
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="创建时间：">
                  <span>{{ projectInfo.createTime }}</span>
                </el-form-item>
              </el-col>
              <el-form-item label="项目图片：" style="position: absolute;left:50%">
                <el-image
                  :src="projectInfo.projectImg"
                  fit="cover"
                  style="height:171px;width: 171px"
                  :preview-src-list="[projectInfo.projectImg]"
                >
                  <div slot="error" class="el-image__error" />
                </el-image>
              </el-form-item>
            </el-row>
          </div>
        </el-form>
      </el-tab-pane>
      <span>
        <el-tab-pane label="效果图" name="effectImage">
          <SenceOrEffict type="effectImage" style="height:100%" :active-name="activeName" />
        </el-tab-pane>
        <el-tab-pane label="进度实景记录" name="actualSence">
          <SenceOrEffict type="actualSence" style="height:100%" :active-name="activeName" />
        </el-tab-pane>
        <el-tab-pane label="文档管理" name="documentManage">
          <DetailDoucument :max-height="maxHeight" style="height:100%" />
        </el-tab-pane>
      </span>
    </el-tabs>
    <el-dialog
      title="进度预警通知"
      center
      :visible.sync="progressWarn"
      width="300px"
      @close="progressWarn= false"
    >
      <el-button type="primary" style="margin-top:-25px;float:right;margin-bottom:10px" @click="lookTaskProgress">查看</el-button>

      <el-table
        :data="warnData"
        :max-height="500"
        row-key="id"
        empty-text="暂无数据"
        border
        default-expand-all
        :indent="20"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
      >
        <el-table-column
          type="index"
          width="50"
        />
        <el-table-column
          property="taskName"
          label="任务名称"
          width="200"
        />
      </el-table>
    </el-dialog>

  </div>
</template>

<script>
import { getPlanList } from '@/api/progressManage'
import { detail } from '@/api/project'
import DetailDoucument from './ProjectDetailDocument'
import SenceOrEffict from './ProjectDetailSenceOrEffict'
export default {
  name: 'ProjectDetail',
  components: {
    DetailDoucument,
    SenceOrEffict
  },
  data() {
    return {
      activeName: 'baseInfo',
      maxHeight: 400,
      projectInfo: {
        projectImg: ''
      },
      warnData: [],
      progressWarn: false
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      if (!from.name || from.name === 'projectList' || from.name === 'dashboard') {
        // vm.getRrogressWarn()
      }
    })
  },
  created() {
    localStorage.setItem(':id', this.$route.params.id)
    detail(this.$route.params.id).then((res) => {
      console.log('res', res)
      this.projectInfo = res
    })
  },

  methods: {
    getRrogressWarn() {
      setTimeout(() => {
        getPlanList({ projectId: this.$route.params.id, warnState: '' }).then(res => {
          this.warnData = res
          if (this.warnData.length > 0) {
            this.progressWarn = true
          }
        })
      }, 500)
    },
    lookTaskProgress() {
      this.progressWarn = false
      this.$router.push({ path: '/projectProgressManage/' + this.$route.params.id, query: { look: true }})
    },
    handleClick() {
      if (this.activeName === 'documentManage') {
        this.$nextTick(() => {
          this.maxHeight = this.$refs.pageDiv.clientHeight - 131
        })
      }
    }
  }
}
</script>

<style scoped>
.overtag {
  margin-left:20px;
  border-radius:20px;
  background-color: white;
  border-color: #f56c6c;
}
.pageDiv{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 10px 10px;
}
</style>
