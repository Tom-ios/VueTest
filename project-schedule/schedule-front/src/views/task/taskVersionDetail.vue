<template>
  <div class="app-container" style="position:absolute;top: 0;right: 0;bottom: 0;left: 0;height:100%">
    <el-card ref="topCard" :body-style="{ padding: '0px 0px 0px' }">
      <!-- <div slot="header">
        <span>当前版本信息</span>
      </div> -->
      <el-form ref="form" style="margin-top:10px" class="search-form" label-width="auto" size="small">
        <el-row :gutter="8">
          <el-col :xl="5" :lg="5" :md="5" :sm="12" :xs="24">
            <el-form-item label="当前版本号：">
              <span>{{ versionInfoCopy.taskVersionNo }}</span>
            </el-form-item>
          </el-col>
          <!-- <el-col :xl="6" :lg="6" :md="6" :sm="12" :xs="24">
            <el-form-item label="计划级别：">
              <span>{{ versionInfo.submitTime }}</span>
            </el-form-item>
          </el-col> -->
          <el-col :xl="5" :lg="5" :md="5" :sm="12" :xs="24">
            <el-form-item label="提交人：">
              <span>{{ versionInfoCopy.applyUserName }}</span>
            </el-form-item>
          </el-col>
          <el-col :xl="5" :lg="5" :md="5" :sm="12" :xs="24">
            <el-form-item label="提交时间：">
              <span>{{ versionInfoCopy.applyTime }}</span>
            </el-form-item>
          </el-col>
          <el-col :xl="9" :lg="9" :md="9" :sm="12" :xs="24">
            <el-form-item label="提交说明：">
              <span>{{ versionInfoCopy.remark }}</span>
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
    <!-- <el-card ref="ganttCard" style="height:calc(100% - 167px);" :body-style="{ padding: '0px 0px 0px' }"> -->
    <!-- <el-card ref="ganttCard" :style="'height:calc(100% - ' + topCardHeight + 'px;'" :body-style="{ padding: '0px 0px 0px' }"> -->
    <el-card ref="ganttCard" :body-style="{ padding: '0px 0px 0px' }">
      <!--  <div slot="header">
        <span>作业计划信息</span>
      </div> -->
      <GanttView ref="ganttView" :max-height="maxHeight" :is-edit="false" :task-version-info="versionInfo" @after-load-detail="afterLoadDetail" />
    </el-card>
  </div>
</template>

<script>
import Qs from 'qs'
// import GanttView from './GanttView'
// import TaskResource from './TaskResourceView'
// import ResourceHistogram from './ResourceHistogramView'
// import { getTaskVersionDetail } from '@/api/taskView'
export default {
  name: 'TaskVersionDetail',
  components: {
    GanttView: () =>
      import('./GanttView').then(component => {
        component.default._Ctor = {}
        if (!component.default.attached) {
          component.default.backupMounted = component.default.mounted
        }
        component.default.mounted = function() {
          this.$nextTick(() => {
            // this.maxGridHeight = this.$parent.$el.clientHeight - 10 - 55 - 50 - 42
            // this.topCardHeight = this.$parent.$parent.$refs.topCard.$el.offsetHeight
            this.maxGridHeight = this.$parent.$el.clientHeight - 50 - 42
          })
          if (component.default.backupMounted) {
            component.default.backupMounted.call(this)
          }
        }
        component.default.attached = true
        return component
      }).catch(d => console.log(d))

    // TaskResource
    // ResourceHistogram
  },
  props: {
  },
  data() {
    return {
      globalParam: { projectId: this.$route.params.id },
      versionInfo: {},
      versionInfoCopy: {},
      maxHeight: 400,
      topCardHeight: 62
    }
  },
  computed: {},
  watch: {

  },
  mounted() {
    // this.$nextTick(() => {
    //   console.log(this.$refs.ganttCard.$el.offsetHeight)
    //   console.log(this.$refs.ganttCard.$el.clientHeight)
    //   this.maxHeight = this.$refs.ganttCard.$el.clientHeight - 10 - 55 - 50 - 42
    //   console.log(this.maxHeight)
    // })
  },
  created() {
    this.initVersionInfo()
    this.fetchData()
  },
  methods: {
    initVersionInfo() {
      this.versionInfo = Qs.parse(this.$route.query)
      this.versionInfoCopy = Object.assign(this.versionInfo)
    },
    fetchData() {
      // getTaskVersionDetail({ baseId: this.$route.query.baseId, projectId: this.$route.query.projectId }).then(res => {
      //   if (res.state === 'success') {
      //     console.log(res.data)
      //   } else {
      //     this.$message.error('查询作业版本详情失败')
      //   }
      // })
    },
    afterLoadDetail() {
      this.versionInfo = null
    }
  }
}
</script>

<style>
/* .app-container{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 0;
} */
</style>
