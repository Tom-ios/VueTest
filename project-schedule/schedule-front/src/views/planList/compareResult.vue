<template>
  <el-card class="ml-10 mr-10 mt-10">
    <el-row class="mt-20 ml-20">
      <el-form>
        <el-col :span="19">
          <el-form-item label="差异个数：">
            <span>{{ totalDiff }}</span>
          </el-form-item>
        </el-col>
        <el-col :span="5">
          <el-button type="primary" size="mini" @click="before">上一条差异</el-button>
          <el-button type="primary" size="mini" @click="after">下一条差异</el-button>
        </el-col>
      </el-form>
    </el-row>
    <el-row class="mt-20 ml-20">
      <div class="box">
        <split-pane :min-percent="20" split="vertical" @resize="resize">
          <template slot="paneL">
            <el-row>
              <el-col :span="22">
                <span>版本号：{{ sourceVersionId }}</span>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="23" class="mt-10">
                <el-table ref="sourceVersionTableDataRef" :data="sourceVersionTableData" :height="tableHeight" default-expand-all row-key="id" :cell-style="cellStyle" :tree-props="{children: 'children', hasChildren: 'hasChildren'}" border style="width: 100%">
                  <el-table-column type="index" label="序号" width="50" />
                  <el-table-column prop="wbsName" label="名称" :show-overflow-tooltip="true" width="150" />
                  <el-table-column prop="wbsCode" label="编码" :show-overflow-tooltip="true" width="80" />
                  <el-table-column label="类型" width="80">
                    <template slot-scope="scope">
                      <span v-if="scope.row.levelName === '作业'">作业</span>
                      <span v-else>WBS</span>
                    </template>
                  </el-table-column>
                  <el-table-column prop="planStartDate" label="计划开始时间" width="160" />
                  <el-table-column prop="planEndDate" label="计划结束时间" width="160" />
                  <el-table-column prop="planDuration" label="计划工期" width="80" />
                  <el-table-column prop="weights" label="权重比例" width="80" />
                  <el-table-column prop="principalName" label="负责人" width="100" />
                </el-table>
              </el-col>
            </el-row>
          </template>
          <template slot="paneR">
            <el-row>
              <el-col :span="22">
                <span>版本号：{{ targetVersionId }}</span>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="23" class="mt-10">
                <el-table ref="targetVersionTableDataRef" :data="targetVersionTableData" :height="tableHeight" default-expand-all row-key="id" :cell-style="cellStyle" :tree-props="{children: 'children', hasChildren: 'hasChildren'}" border style="width: 100%">
                  <el-table-column type="index" label="序号" width="50" />
                  <el-table-column prop="wbsName" label="名称" :show-overflow-tooltip="true" width="150" />
                  <el-table-column prop="wbsCode" label="编码" :show-overflow-tooltip="true" width="80" />
                  <el-table-column label="类型" width="80">
                    <template slot-scope="scope">
                      <span v-if="scope.row.levelName === '作业'">作业</span>
                      <span v-else>WBS</span>
                    </template>
                  </el-table-column>
                  <el-table-column prop="planStartDate" label="计划开始时间" width="160" />
                  <el-table-column prop="planEndDate" label="计划结束时间" width="160" />
                  <el-table-column prop="planDuration" label="计划工期" width="80" />
                  <el-table-column prop="weights" label="权重比例" width="80" />
                  <el-table-column prop="principalName" label="负责人" width="100" />
                </el-table>
              </el-col>
            </el-row>
          </template>
        </split-pane>
      </div>
    </el-row>
  </el-card>
</template>

<script>
import { getDiff } from '@/api/planCompare'
export default {
  name: 'CompareResult',
  data() {
    return {
      totalDiff: '',
      sourceVersionId: '',
      targetVersionId: '',
      sourceVersionTableData: [],
      targetVersionTableData: [],
      SourceTreeRowList: [],
      TargetTreeRowList: [],
      selectRowIndex: '',
      tableHeight: window.innerHeight - 200
    }
  },
  created() {
    this.getDiffFuc()
    this.nextone(this.SourceTreeRowList)
  },
  methods: {
    async getDiffFuc() {
      this.sourceVersionId = this.$route.query.item1.baseNo
      this.targetVersionId = this.$route.query.item2.baseNo
      var params = {
        // sourceVersionId: this.$route.query.item1.id,
        // targetVersionId: this.$route.query.item2.id
        sourceVersionId: '572024e6df2d47b5aee32986b45b7930',
        targetVersionId: '60f94c0bcbb1471dac71e9f9ac0625ab'
      }
      await getDiff(params).then(res => {
        console.log(res)
        if (res && res.code === '200') {
          this.totalDiff = res.data.totalDiff
          this.sourceVersionTableData = res.data.contrastNewSourceTree
          this.targetVersionTableData = res.data.contrastNewTargetTree
        } else {
          alert('获取对比结果失败')
        }
      })
      this.deepSearch1(this.sourceVersionTableData)
      this.deepSearch2(this.targetVersionTableData)
    },
    resize() {
      console.log('resize')
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
    cellStyle({ row, column, rowIndex, columnIndex }) {
      // console.log(row)
      if (row.editType === 'update' && row.oldId === this.selectRowIndex.oldId) {
        return 'background: #77DDFF;'
      } else if (row.editType === 'delete' && rowIndex === this.selectRowIndex.rowindex) {
        return 'text-decoration: line-through; background: #77DDFF;'
      } else if (row.editType === 'add' && rowIndex === this.selectRowIndex.rowindex) {
        return 'color: red; background: #77DDFF;'
      } else if (row.editType === 'update' && row.oldId !== this.selectRowIndex.oldId) {
        return 'background: yellow;'
      } else if (row.editType === 'delete' && row.oldId !== this.selectRowIndex.oldId) {
        return 'text-decoration: line-through;'
      } else if (row.editType === 'add' && row.oldId !== this.selectRowIndex.oldId) {
        return 'color: red;'
      }
    },
    nextone(list) {
      // console.log(this.selectRowIndex)
      // console.log(list)
      // console.dir(this.selectRowIndex = '')
      for (var i = 0; i < list.length; i++) {
        if (this.selectRowIndex === '' && list[i].editType === 'update') {
          this.selectRowIndex = {
            oldId: list[i].oldId,
            rowindex: i,
            path: list[i].path
          }
          return
        } else if (this.selectRowIndex.rowindex < i && list[i].editType === 'update') {
          this.selectRowIndex = {
            oldId: list[i].oldId,
            rowindex: i,
            path: list[i].path
          }
          return
        } else if (this.selectRowIndex.rowindex === '' && (list[i].editType === 'add' || list[i].editType === 'delete')) {
          this.selectRowIndex = {
            oldId: list[i].oldId,
            rowindex: i,
            path: list[i].path
          }
          return
        } else if (this.selectRowIndex.rowindex < i && (list[i].editType === 'add' || list[i].editType === 'delete')) {
          this.selectRowIndex = {
            oldId: list[i].oldId,
            rowindex: i,
            path: list[i].path
          }
          return
        }
      }
    },
    lastone(list) {
      for (var i = list.length - 1; i >= 0; i--) {
        if (this.selectRowIndex === '' && list[i].editType === 'update') {
          this.selectRowIndex = {
            oldId: list[i].oldId,
            rowindex: i,
            path: list[i].path
          }
          return
        } else if (this.selectRowIndex.rowindex > i && list[i].editType === 'update') {
          this.selectRowIndex = {
            oldId: list[i].oldId,
            rowindex: i,
            path: list[i].path
          }
          return
        } else if (this.selectRowIndex.rowindex === '' && (list[i].editType === 'add' || list[i].editType === 'delete')) {
          this.selectRowIndex = {
            oldId: list[i].oldId,
            rowindex: i,
            path: list[i].path
          }
          return
        } else if (this.selectRowIndex.rowindex > i && (list[i].editType === 'add' || list[i].editType === 'delete')) {
          this.selectRowIndex = {
            oldId: list[i].oldId,
            rowindex: i,
            path: list[i].path
          }
          return
        }
      }
    },
    before() {
      this.lastone(this.SourceTreeRowList)
    },
    after() {
      this.nextone(this.SourceTreeRowList)
    }
  }
}
</script>

<style lang="scss" scoped>
.box{
  width: 100%;
  height: 580px;
}
.ml-20 {
  margin-left: 20px;
}
.ml-10 {
  margin-left: 10px;
}
.mt-10 {
  margin-top: 10px;
}
.mr-10 {
  margin-right: 10px;
}
.mt-20 {
  margin-top: 20px;
}
.mr-20 {
  margin-right: 20px;
}
</style>
