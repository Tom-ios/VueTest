<template>
  <el-card class="ml-10 mr-10 mt-10">
    <el-tabs v-model="activeName" class="ml-10" @tab-click="toggleTabs">
      <el-tab-pane label="提交版本" name="0">
        <el-row>
          <el-form :inline="true" :model="paramForm">
            <el-form-item label="生成时间">
              <el-date-picker v-model="paramForm.generationTime" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" format="yyyy-MM-dd" style="min-width:400px;" @change="clear" />
            </el-form-item>
            <el-form-item label="说明">
              <el-input v-model="paramForm.explain" style="width: 130px;" />
            </el-form-item>
            <el-button type="primary" @click="getPlanListData">查询</el-button>
            <el-button type="primary" @click="compareDialogVisible = true">对比</el-button>
          </el-form>
        </el-row>
        <el-row>
          <el-table :data="CVtableData" highlight-current-row style="width: 100%" border>
            <el-table-column prop="baseNo" label="版本号" :formatter="Format" align="center" width="80" />
            <el-table-column prop="applyUserName" label="提交人" :formatter="Format" align="center" width="120" />
            <el-table-column prop="levelName" label="级别" :formatter="Format" align="center" width="120" />
            <el-table-column prop="applyTime" label="生成时间" :formatter="Format" align="center" width="200" />
            <el-table-column prop="remark" label="说明" :formatter="Format" align="center" />
            <el-table-column label="操作" width="200" align="center">
              <template slot-scope="scope">
                <el-button type="text" @click="viewDetails(scope.row)">查看</el-button>
                <el-button type="text" @click="initiateComparison(scope.row)">发起对比</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-row>
      </el-tab-pane>
      <el-tab-pane label="基线版本" name="1">
        <el-row>
          <el-form :inline="true" :model="paramForm">
            <el-form-item label="生成时间">
              <el-date-picker v-model="paramForm.generationTime" type="daterange" range-separator="至" start-placeholder="开始日期" end-placeholder="结束日期" value-format="yyyy-MM-dd" format="yyyy-MM-dd" style="min-width:400px;" />
            </el-form-item>
            <el-form-item label="说明">
              <el-input v-model="paramForm.explain" style="width: 130px;" />
            </el-form-item>
            <el-button type="primary" @click="getPlanListData">查询</el-button>
            <el-button type="primary" @click="compareDialogVisible = true">对比</el-button>
          </el-form>
        </el-row>
        <el-row>
          <el-table :data="BVtableData" highlight-current-row style="width: 100%" border>
            <el-table-column prop="baseNo" label="版本号" :formatter="Format" align="center" width="80" />
            <el-table-column prop="applyUserName" label="提交人" :formatter="Format" align="center" width="120" />
            <el-table-column prop="levelName" label="级别" :formatter="Format" align="center" width="120" />
            <el-table-column prop="applyTime" label="生成时间" :formatter="Format" align="center" width="200" />
            <el-table-column prop="remark" label="说明" :formatter="Format" align="center" />
            <el-table-column label="操作" width="200" align="center">
              <template slot-scope="scope">
                <el-button type="text" @click="viewDetails(scope.row)">查看</el-button>
                <el-button type="text" @click="initiateComparison(scope.row)">发起对比</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-row>
      </el-tab-pane>
    </el-tabs>
    <el-dialog title="选择对比版本" :visible.sync="compareDialogVisible" width="350px" @close="closeDialog">
      <el-form ref="compareFormRef" :model="compareForm" :rules="compareFormRules" label-width="120px">
        <el-form-item prop="item1" style="width:320px;float:left;">
          <p style="float:left;line-height:32px;margin:0 10px 0 -100px;">
            参照版本号
            <span style="color:red;font-size:16px;">*</span>
          </p>
          <el-select v-model="compareForm.item1" filterable placeholder="请选择版本">
            <el-option v-for="item in versions" :key="item.id" :label="item.baseNo" :value="item.versionId" />
          </el-select>
        </el-form-item>
        <el-form-item prop="item2" style="width:320px;float:left;">
          <p style="float:left;line-height:32px;margin:0 10px 0 -100px;">
            对比版本号
            <span style="color:red;font-size:16px;">*</span>
          </p>
          <el-select v-model="compareForm.item2" filterable placeholder="请选择版本">
            <el-option v-for="item in versions" :key="item.id" :label="item.baseNo" :value="item.versionId" />
          </el-select>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="compare">确 定</el-button>
        <el-button @click="compareDialogVisible = false">取 消</el-button>
      </span>
    </el-dialog>
    <el-dialog title="对比结果" :visible.sync="compareResultDialogVisible" width="80%">
      <el-card style="text-align:left;margin-top:-10px;margin-bottom:-10px;">
        <el-row>
          <el-form>
            <span style="font-size:15px;line-height:28px;">差异个数：{{ totalDiff }}</span>
            <el-button type="primary" size="mini" style="float:right;margin-left:10px;" @click="after">下一条差异</el-button>
            <el-button type="primary" size="mini" style="float:right;" @click="before">上一条差异</el-button>
          </el-form>
        </el-row>
        <el-row>
          <div class="box">
            <el-row>
              <el-col :span="12">
                <span>参照版本号：{{ sourceVersionId }}</span>
              </el-col>
              <el-col :span="12">
                <span>对比版本号：{{ targetVersionId }}</span>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12" class="mt-10">
                <el-table
                  ref="sourceVersionTableDataRef"
                  :height="tableHeight"
                  :row-style="{height:'30px'}"
                  :show-overflow-tooltip="true"
                  :data="sourceVersionTableData"
                  default-expand-all
                  row-key="id"
                  :cell-style="cellStyle"
                  :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
                  border
                  style="width: 100%"
                >
                  <el-table-column type="index" label="序号" width="50" />
                  <el-table-column prop="wbsName" label="名称" :show-overflow-tooltip="true" width="150" />
                  <el-table-column prop="wbsCode" label="编码" :show-overflow-tooltip="true" width="70" />
                  <el-table-column label="类型" width="80">
                    <template slot-scope="scope">
                      <span v-if="scope.row.levelName === '作业'">作业</span>
                      <span v-else>WBS</span>
                    </template>
                  </el-table-column>
                  <el-table-column prop="planStartDate" label="计划开始时间" width="100" />
                  <el-table-column prop="planEndDate" label="计划结束时间" width="100" />
                  <el-table-column prop="planDuration" label="计划工期" width="70" />
                  <el-table-column prop="weights" label="权重比例" width="70" />
                  <el-table-column prop="principalName" label="负责人" width="100" />
                </el-table>
              </el-col>
              <el-col :span="12" class="mt-10">
                <el-table
                  ref="targetVersionTableDataRef"
                  :height="tableHeight"
                  :row-style="{height:'30px'}"
                  :show-overflow-tooltip="true"
                  :data="targetVersionTableData"
                  default-expand-all
                  row-key="id"
                  :cell-style="cellStyle"
                  :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
                  border
                  style="width: 100%"
                >
                  <el-table-column type="index" label="序号" width="50" />
                  <el-table-column prop="wbsName" label="名称" :show-overflow-tooltip="true" width="150" />
                  <el-table-column prop="wbsCode" label="编码" :show-overflow-tooltip="true" width="70" />
                  <el-table-column label="类型" width="80">
                    <template slot-scope="scope">
                      <span v-if="scope.row.levelName === '作业'">作业</span>
                      <span v-else>WBS</span>
                    </template>
                  </el-table-column>
                  <el-table-column prop="planStartDate" label="计划开始时间" width="100" />
                  <el-table-column prop="planEndDate" label="计划结束时间" width="100" />
                  <el-table-column prop="planDuration" label="计划工期" width="70" />
                  <el-table-column prop="weights" label="权重比例" width="70" />
                  <el-table-column prop="principalName" label="负责人" width="100" />
                </el-table>
              </el-col>
            </el-row>
            <el-row class="mt-10">
              <span class="floatspan">删除：</span>
              <div class="colorRed" />
              <span class="floatspan">修改：</span>
              <div class="colorYellow" />
              <span class="floatspan">新增：</span>
              <div class="colorBlue" />
              <span class="floatspan">差异选中：</span>
              <div class="colorGreen" />
            </el-row>
          </div>
        </el-row>
      </el-card>
      <span slot="footer" class="dialog-footer">
        <el-button @click="compareResultDialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="compareResultDialogVisible = false">确 定</el-button>
      </span>
    </el-dialog>
  </el-card>
</template>

<script>
import { getPlanList, getDiff } from '@/api/planCompare/planCompare'
export default {
  name: 'PlanList',
  data() {
    return {
      activeName: '0',
      paramForm: {
        generationTime: '',
        explain: ''
      },
      startTime: '',
      endTime: '',
      CVtableData: [],
      BVtableData: [],
      compareDialogVisible: false,
      compareForm: {
        item1: '',
        item2: ''
      },
      versions: {},
      compareFormRules: {
        item1: [{ required: true, message: '请选择版本号', trigger: 'blur' }],
        item2: [{ required: true, message: '请选择版本号', trigger: 'blur' }]
      },
      compareResultDialogVisible: false,
      totalDiff: '',
      sourceVersionId: '',
      targetVersionId: '',
      sourceVersionTableData: [],
      targetVersionTableData: [],
      SourceTreeRowList: [],
      TargetTreeRowList: [],
      selectRowIndex: '',
      tableHeight: 250
    }
  },
  async created() {
    await this.getPlanListData()
    this.getVersions()
  },
  mounted() {
    this.$nextTick(function() {
      this.tableHeight < 250 ? window.innerHeight * 0.3 : 250
      // 监听窗口大小变化
      const self = this
      window.onresize = function() {
        self.tableHeight < 250 ? window.innerHeight * 0.3 : 250
      }
    })
    console.log(this.tableHeight)
  },
  methods: {
    async getPlanListData() {
      // console.log(this.$route.params.id)
      this.startTime = this.paramForm.generationTime ? this.paramForm.generationTime[0] : ''
      this.endTime = this.paramForm.generationTime ? this.paramForm.generationTime[1] : ''
      var params = {
        type: this.activeName || '0',
        projectId: this.$route.params.id || '',
        beginCreateTime: this.startTime ? this.startTime : '',
        endCreateTime: this.endTime ? this.endTime : '',
        remark: this.paramForm.explain || ''
      }
      // console.log('params', params)
      // this.versions = []
      await getPlanList(params).then(res => {
        console.log(res)
        if (res && res.code === '200') {
          if (this.activeName === '0') {
            this.CVtableData = res.data
            // this.versions = res.data
          } else {
            this.BVtableData = res.data
            // this.versions = res.data
          }
        } else {
          // alert('获取计划列表失败')
          this.$message({
            type: 'error',
            message: '获取计划列表失败'
          })
        }
      })
    },
    getVersions() {
      if (this.activeName === '0') {
        console.log(1)
        this.versions = this.CVtableData.concat()
      } else {
        console.log(2)
        this.versions = this.BVtableData.concat()
      }
      console.log(this.versions)
    },
    async toggleTabs() {
      await this.getPlanListData()
      this.getVersions()
    },
    viewDetails(row) {
      // var itemobj = row
      var projectId = this.$route.params.id
      // this.$router.push({ path: '/planlist/baselineVersion', query: { item: itemobj }})
      var versionId = row.versionId
      this.$router.push({ path: `/planlist/baselineVersion/${projectId}`, query: { type: this.activeName, projectId: projectId, versionId: versionId }})
    },
    initiateComparison(row) {
      this.compareForm.item1 = row.versionId
      this.compareDialogVisible = true
    },
    deepSearch1(tree) {
      for (var i = 0; i < tree.length; i++) {
        var item = {
          editType: tree[i].editType,
          oldId: tree[i].oldId,
          path: tree[i].path
        }
        this.SourceTreeRowList.push(item)
        if (tree[i].children && tree[i].children.length > 0) {
          this.deepSearch1(tree[i].children)
        }
      }
    },
    deepSearch2(tree) {
      for (var i = 0; i < tree.length; i++) {
        var item = {
          editType: tree[i].editType,
          oldId: tree[i].oldId,
          path: tree[i].path
        }
        this.TargetTreeRowList.push(item)
        if (tree[i].children && tree[i].children.length > 0) {
          this.deepSearch2(tree[i].children)
        }
      }
    },
    async getDiffFuc(one, two) {
      console.log(one, two)
      var params = {
        sourceVersionId: one.versionId,
        targetVersionId: two.versionId
        // sourceVersionId: '572024e6df2d47b5aee32986b45b7930',
        // targetVersionId: '60f94c0bcbb1471dac71e9f9ac0625ab'
      }
      await getDiff(params).then(res => {
        console.log(res)
        if (res && res.code === '200') {
          this.totalDiff = res.data.totalDiff
          this.sourceVersionTableData = res.data.contrastNewSourceTree
          this.targetVersionTableData = res.data.contrastNewTargetTree
          this.deepSearch1(this.sourceVersionTableData)
          this.deepSearch2(this.targetVersionTableData)
        } else {
          // alert('获取对比结果失败')
          this.$message({
            type: 'error',
            message: '获取对比结果失败'
          })
        }
      })
    },
    cellStyle({ row, column, rowIndex, columnIndex }) {
      // console.log(row)
      if (row.editType === 'update' && row.oldId === this.selectRowIndex.oldId && rowIndex === this.selectRowIndex.rowindex) {
        return 'background: #66FF99;'
      } else if (row.editType === 'update' && rowIndex !== this.selectRowIndex.rowindex) {
        return 'background: yellow;'
      } else if (row.editType === 'delete' && rowIndex === this.selectRowIndex.rowindex) {
        return 'text-decoration: line-through; background: #66FF99;'
      } else if (row.editType === 'delete' && rowIndex !== this.selectRowIndex.rowIndex) {
        return 'background: red;text-decoration: line-through;'
      } else if (row.editType === 'add' && rowIndex === this.selectRowIndex.rowindex) {
        return 'background: #66FF99;'
      } else if (row.editType === 'add' && rowIndex !== this.selectRowIndex.rowIndex) {
        return 'background: #77DDFF'
      }
    },
    nextone(list1, list2) {
      // console.log(this.selectRowIndex)
      // console.log(list)
      var len = list1.length >= list2.length ? list1.length : list2.length
      // console.log(len)
      for (var i = 0; i < len; i++) {
        // console.log(list1[i], list2[i])
        if (this.selectRowIndex === '' && ((list1[i] && list1[i].editType === 'update') || (list2[i] && list2[i].editType === 'update'))) {
          if (list1[i] && list1[i].editType === 'update') {
            console.log(1, list1[i])
            this.selectRowIndex = {
              oldId: list1[i].oldId,
              rowindex: i,
              path: list1[i].path
            }
          } else if (list2[i] && list2[i].editType === 'update') {
            // console.log(1.1, list2[i])
            this.selectRowIndex = {
              oldId: list2[i].oldId,
              rowindex: i,
              path: list2[i].path
            }
          }
          return
        } else if (this.selectRowIndex.rowindex < i && ((list1[i] && list1[i].editType === 'update') || (list2[i] && list2[i].editType === 'update'))) {
          if (list1[i] && list1[i].editType === 'update') {
            // console.log(2, list1[i])
            this.selectRowIndex = {
              oldId: list1[i].oldId,
              rowindex: i,
              path: list1[i].path
            }
          } else if (list2[i] && list2[i].editType === 'update') {
            // console.log(2.1, list2[i])
            this.selectRowIndex = {
              oldId: list2[i].oldId,
              rowindex: i,
              path: list2[i].path
            }
          }
          return
        } else if (this.selectRowIndex === '' && ((list1[i] && list1[i].editType === 'add') || (list1[i] && list1[i].editType === 'delete') || (list2[i] && list2[i].editType === 'add') || (list2[i] && list2[i].editType === 'delete'))) {
          if (list1[i] && (list1[i].editType === 'add' || list1[i].editType === 'delete')) {
            // console.log(3, list1[i])
            this.selectRowIndex = {
              oldId: list1[i].oldId,
              rowindex: i,
              path: list1[i].path
            }
          } else if (list2[i] && (list2[i].editType === 'add' || list2[i].editType === 'delete')) {
            // console.log(3.1, list2[i])
            this.selectRowIndex = {
              oldId: list2[i].oldId,
              rowindex: i,
              path: list2[i].path
            }
          }
          return
        } else if (this.selectRowIndex.rowindex < i && ((list1[i] && list1[i].editType === 'add') || (list1[i] && list1[i].editType === 'delete') || (list2[i] && list2[i].editType === 'add') || (list2[i] && list2[i].editType === 'delete'))) {
          if (list1[i] && (list1[i].editType === 'add' || list1[i].editType === 'delete')) {
            // console.log(4, list1[i])
            this.selectRowIndex = {
              oldId: list1[i].oldId,
              rowindex: i,
              path: list1[i].path
            }
          } else if (list2[i] && (list2[i].editType === 'add' || list2[i].editType === 'delete')) {
            // console.log(4.1, list2[i])
            this.selectRowIndex = {
              oldId: list2[i].oldId,
              rowindex: i,
              path: list2[i].path
            }
          }
          return
        }
      }
    },
    lastone(list1, list2) {
      // console.log(this.selectRowIndex)
      var len = list1.length >= list2.length ? list1.length : list2.length
      // console.log(len)
      for (var i = len; i >= 0; i--) {
        if (this.selectRowIndex === '' && ((list1[i] && list1[i].editType === 'update') || (list2[i] && list2[i].editType === 'update'))) {
          if (list1[i] && list1[i].editType === 'update') {
            this.selectRowIndex = {
              oldId: list1[i].oldId,
              rowindex: i,
              path: list1[i].path
            }
          } else if (list2[i] && list2[i].editType === 'update') {
            this.selectRowIndex = {
              oldId: list2[i].oldId,
              rowindex: i,
              path: list2[i].path
            }
          }
          return
        } else if (this.selectRowIndex.rowindex > i && ((list1[i] && list1[i].editType === 'update') || (list2[i] && list2[i].editType === 'update'))) {
          if (list1[i] && list1[i].editType === 'update') {
            this.selectRowIndex = {
              oldId: list1[i].oldId,
              rowindex: i,
              path: list1[i].path
            }
          } else if (list2[i] && list2[i].editType === 'update') {
            this.selectRowIndex = {
              oldId: list2[i].oldId,
              rowindex: i,
              path: list2[i].path
            }
          }
          return
        } else if (this.selectRowIndex === '' && ((list1[i] && list1[i].editType === 'add') || (list1[i] && list1[i].editType === 'delete') || (list2[i] && list2[i].editType === 'add') || (list2[i] && list2[i].editType === 'delete'))) {
          if (list1[i] && (list1[i].editType === 'add' || list1[i].editType === 'delete')) {
            this.selectRowIndex = {
              oldId: list1[i].oldId,
              rowindex: i,
              path: list1[i].path
            }
          } else if (list2[i] && (list2[i].editType === 'add' || list2[i].editType === 'delete')) {
            this.selectRowIndex = {
              oldId: list2[i].oldId,
              rowindex: i,
              path: list2[i].path
            }
          }
          return
        } else if (this.selectRowIndex.rowindex > i && ((list1[i] && list1[i].editType === 'add') || (list1[i] && list1[i].editType === 'delete') || (list2[i] && list2[i].editType === 'add') || (list2[i] && list2[i].editType === 'delete'))) {
          if (list1[i] && (list1[i].editType === 'add' || list1[i].editType === 'delete')) {
            this.selectRowIndex = {
              oldId: list1[i].oldId,
              rowindex: i,
              path: list1[i].path
            }
          } else if (list2[i] && (list2[i] && list2[i].editType === 'add' || list2[i].editType === 'delete')) {
            this.selectRowIndex = {
              oldId: list2[i].oldId,
              rowindex: i,
              path: list2[i].path
            }
          }
          return
        }
      }
    },
    tableLocation() {
      this.$refs.sourceVersionTableDataRef.bodyWrapper.scrollTop = this.selectRowIndex.rowindex * 30
      this.$refs.targetVersionTableDataRef.bodyWrapper.scrollTop = this.selectRowIndex.rowindex * 30
    },
    before() {
      // console.log(this.SourceTreeRowList, this.TargetTreeRowList)
      this.lastone(this.SourceTreeRowList, this.TargetTreeRowList)
      // console.log(this.selectRowIndex)
      this.tableLocation()
    },
    after() {
      // console.log(this.SourceTreeRowList, this.TargetTreeRowList)
      this.nextone(this.SourceTreeRowList, this.TargetTreeRowList)
      // console.log(this.selectRowIndex)
      this.tableLocation()
    },
    compare() {
      this.selectRowIndex = ''
      this.SourceTreeRowList = []
      this.TargetTreeRowList = []
      this.$refs.compareFormRef.validate((valid) => {
        if (valid) {
          if (this.compareForm.item1 === this.compareForm.item2) {
            this.$message({
              type: 'error',
              message: '请选择不同版本'
            })
            return
          }
          var one = {}
          var two = {}
          for (var i = 0; i < this.versions.length; i++) {
            if (this.versions[i].versionId === this.compareForm.item1) {
              one = this.versions[i]
            }
            if (this.versions[i].versionId === this.compareForm.item2) {
              two = this.versions[i]
            }
          }
          this.sourceVersionId = one.baseNo
          this.targetVersionId = two.baseNo
          this.getDiffFuc(one, two)
          this.compareDialogVisible = false
          this.compareResultDialogVisible = true
          this.compareForm.item1 = ''
          this.compareForm.item2 = ''
          this.$refs.compareFormRef.resetFields()
        } else {
          // this.$message({
          //   type: 'error',
          //   message: '请选择好两个版本'
          // })
          return false
        }
        // console.log(this.compareForm)

        // // console.log(one, two)
        // var onetime = one.applyTime.split('-')
        // var twotime = two.applyTime.split('-')
        // if (parseInt(twotime[0]) > parseInt(onetime[0]) || parseInt(twotime[0]) === parseInt(onetime[0])) {
        //   if (parseInt(twotime[1]) > parseInt(onetime[1]) || parseInt(twotime[1]) === parseInt(onetime[1])) {
        //     if (parseInt(twotime[2]) > parseInt(onetime[2]) || parseInt(twotime[2]) === parseInt(onetime[2])) {
        //       this.sourceVersionId = one.baseNo
        //       this.targetVersionId = two.baseNo
        //       this.getDiffFuc(one, two)
        //     } else {
        //       this.sourceVersionId = two.baseNo
        //       this.targetVersionId = one.baseNo
        //       this.getDiffFuc(two, one)
        //     }
        //   } else {
        //     this.sourceVersionId = two.baseNo
        //     this.targetVersionId = one.baseNo
        //     this.getDiffFuc(two, one)
        //   }
        // } else {
        //   this.sourceVersionId = two.baseNo
        //   this.targetVersionId = one.baseNo
        //   this.getDiffFuc(two, one)
        // }
      })
    },
    Format(row, column) {
      const str = row[column.property]
      if (str === null) {
        return ' '
      }
      return str
    },
    clear() {
      console.log(1)
      if (this.paramForm.generationTime === '' || this.paramForm.generationTime === null) {
        this.paramForm = {
          generationTime: '',
          explain: ''
        }
        this.getPlanListData()
      }
    },
    closeDialog() {
      this.compareForm = {
        item1: '',
        item2: ''
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.ml-10 {
  margin-left: 10px;
}
.mt-10 {
  margin-top: 10px;
}
.mr-10 {
  margin-right: 10px;
}
.box {
  width: 100%;
  height: 100%;
}
.floatspan {
  float: left;
}
.colorRed {
  // 蓝色新增#77DDFF 红色删除red 黄色修改yellow 绿色选中#66FF99
  width: 16px;
  height: 16px;
  float: left;
  background: red;
  margin-right: 10px;
}
.colorYellow {
  width: 16px;
  height: 16px;
  float: left;
  background: yellow;
  margin-right: 10px;
}
.colorBlue {
  width: 16px;
  height: 16px;
  float: left;
  background: #77DDFF;
  margin-right: 10px;
}
.colorGreen {
  width: 16px;
  height: 16px;
  float: left;
  background: #66FF99;
  margin-right: 10px;
}
.el-table .cell {
  white-space: nowrap;   //强制不换行
  overflow: hidden; //溢出隐藏
  text-overflow: ellipsis  //替换为省略号
}
</style>
