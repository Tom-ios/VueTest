<template>
  <div id="setwarning" ref="setwarning" class="pageDiv font14">
    <el-card :body-style="{ padding: '20px' }">
      <div style="border-bottom:1px solid #EBEEF5;padding-bottom:10px">
        <span>费用预警阙值:</span>
        <el-input v-model="warnValue" style="width:200px;margin-left:5px;margin-right:5px" oninput="this.value = this.value.replace(/[^0-9]/g, '')" maxlength="11" /> 元/周
      </div>
      <div style="margin-top:10px">
        <span style="margin-left:32px">资源编码</span>
        <el-input v-model.trim="query.resCode" style="width:200px;margin-left:5px;" clearable />
        <span style="margin-left:32px">资源名称</span>
        <el-input v-model.trim="query.resName" style="width:200px;margin-left:5px;" clearable />
        <el-button type="primary" style="margin-left:20px" @click="search">查询</el-button>
        <el-table
          :data="tableData"
          border
          stripe
          :header-cell-class-name="'tableHeader'"
          cell-class-name="justcenter"
          style="margin-top:10px"
          :max-height="maxHeight"
          row-key="id"
          empty-text="暂无数据"
        >
          <el-table-column
            type="index"
            label="序号"
            width="60"
          />
          <el-table-column
            v-for="(col,index) in tablecolumn"
            :key="index"
            :prop="col.value"
            :label="col.title"
            :min-width="col.width?col.width:'100'"
          >
            <template slot-scope="scope">
              <span v-if="tablecolumn[index].type==='input'">
                <el-input v-model="scope.row[tablecolumn[index].key]" oninput="this.value = this.value.replace(/[^0-9]/g, '')" maxlength="11" />
              </span>
              <span v-else-if="tablecolumn[index].type==='key'"> {{ scope.row[tablecolumn[index].key] === "1"?"人力": (scope.row[tablecolumn[index].key] === "2"?"材料":'资源') }}</span>
              <span v-else> {{ scope.row[tablecolumn[index].key] }}</span>
            </template>
          </el-table-column>
        </el-table>
        <div style="position:absolute;bottom:20px;margin-left:calc((100% - 100px) / 2)">
          <el-button type="primary" @click="saveWarning">保存</el-button>
          <el-button @click="cancelWarning">取消</el-button>

        </div>
      </div>
    </el-card>

  </div>
</template>

<script>
import { getResource, save } from '@/api/planAdjust/planAdjust'
export default {
  data() {
    return {
      costWarn: '',
      tableData: [],
      warnValue: '',
      query: {
        resCode: '',
        resName: ''
      },
      tablecolumn: [
        {
          title: '资源类型',
          key: 'resType',
          width: 80,
          type: 'key'
        },

        {
          title: '资源编码',
          key: 'resCode',
          width: 120
        },
        {
          title: '资源名称',
          key: 'resName',
          width: 80
        },
        {
          title: '计量单位',
          key: 'unitEstimate',
          width: 80
        },
        {
          title: '使用量预警值(/周)',
          key: 'warnValue',
          type: 'input',
          width: 120
        }

      ]
    }
  },
  computed: {
    maxHeight() {
      return window.innerHeight - 240
    }
  },
  created() {
    this.search()
    this.warnValue = this.$route.query.costThresholdValue || ''
  },
  methods: {
    search() {
      this.getListData()
    },
    getListData() {
      const query = { ...this.query }
      query.projectId = this.$route.params.id
      // query.warnValue = this.warnValue
      getResource(query).then(res => {
        this.tableData = res.data
      })
    },
    saveWarning() {
      let url = '/project-schedule/scheTaskResourceWarn/saveResWarn?projectId=' + this.$route.params.id + '&costThresholdValue=' + this.warnValue
      url = (this.query.resCode || this.query.resName) ? url + '&updateFlag=1' : url
      save(url, this.tableData).then(res => {
        this.$router.push({ path: '/planAdjust/' + this.$route.params.id })
      })
    },
    cancelWarning() {
      this.$router.push({ path: '/planAdjust/' + this.$route.params.id })
    }
  }
}
</script>

<style lang="scss" scoped>
#setwarning.pageDiv{
  padding:10px;
  position:absolute;
  height:100%;
  width:100%;
}
/deep/ .el-card {
    border: 1px solid #EBEEF5;
    background-color: #FFF;
    color: #303133;
    -webkit-transition: .3s;
    transition: .3s;
    height:100%;
}
/deep/ .el-card__body{
  height:100%
}
.font14{
  font-size: 14px;
}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
 /deep/ .justcenter{
  text-align: center;
}
</style>
