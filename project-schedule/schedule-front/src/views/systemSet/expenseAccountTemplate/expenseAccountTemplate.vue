<template>
  <div>
    <div v-if="showEdit === false">
      <div class="box clearfix">
        <div style="width:100%;">
          <span style="float:left;font-size:14px;line-height:32px;margin-right:10px;">模板名称</span>
          <el-input v-model="searchQuery.templateName" style="float:left;width:250px;margin-right:10px;" clearable />
          <span style="float:left;font-size:14px;line-height:32px;margin-right:10px;">行业</span>
          <el-select v-model="searchQuery.industry" style="float:left;width:150px;margin-right:10px;" placeholder="全部" clearable @change="selectProjectTypeList('')">
            <el-option
              v-for="item1 in industrys"
              :key="item1.dictCode"
              :label="item1.name"
              :value="item1.dictCode"
            />
          </el-select>
          <span style="float:left;font-size:14px;line-height:32px;margin-right:10px;">项目类型</span>
          <el-select v-model="searchQuery.projectType" style="float:left;width:150px;margin-right:10px;" placeholder="全部" clearable>
            <el-option
              v-for="item1 in projectTypes"
              :key="item1.dictCode"
              :label="item1.name"
              :value="item1.dictCode"
            />
          </el-select>
          <el-button type="primary" @click="searchTemplate">查询</el-button>
          <div style="float:right">
            <el-button type="primary" icon="el-icon-plus" @click="addNew">新增</el-button>
          </div>
        </div>
      </div>
      <el-table :data="templateList" highlight-current-row border class="ml-10 mr-10" style="min-width:900px">
        <el-table-column type="index" label="序号" align="center" width="50" />
        <el-table-column prop="isDefault" label="是否默认" align="center">
          <template slot-scope="scope">
            <div v-if="scope.row.isDefault === 1">
              <span>是</span>
            </div>
            <div v-else>
              <span />
            </div>
          </template>
        </el-table-column>
        <el-table-column prop="name" label="名称" align="center" />
        <el-table-column prop="indusrtyName" label="行业" align="center" />
        <el-table-column prop="projectTypeName" label="项目类型" align="center" />
        <el-table-column prop="remark" label="备注" align="center" />
        <el-table-column prop="createUserName" label="创建人" align="center" />
        <el-table-column prop="createTime" label="创建时间" align="center" />
        <el-table-column prop="updateUserName" label="最近编辑人" align="center" />
        <el-table-column prop="updateTime" label="最近编辑时间" align="center" />
        <el-table-column label="操作" align="center" width="250">
          <template slot-scope="scope">
            <div v-if="scope.row.isDefault === 1">
              <el-link :underline="false" type="primary" @click="edit(scope.row)">编辑</el-link>
              |
              <el-link :underline="false" type="primary" @click="copy(scope.row)">复制增加</el-link>
              |
              <el-link :underline="false" type="primary" @click="cancelDefaultFuc(scope.row)">取消默认</el-link>
              <!-- <el-button type="text" @click="setDefault(scope.row)">设为默认</el-button> -->
            </div>
            <div v-else>
              <el-link :underline="false" type="primary" @click="edit(scope.row)">编辑</el-link>
              |
              <el-link :underline="false" type="primary" @click="copy(scope.row)">复制增加</el-link>
              |
              <el-link :underline="false" type="primary" @click="setDefaultFuc(scope.row)">设为默认</el-link>
              |
              <el-link :underline="false" type="primary" @click="deleteTempalate(scope.row)">删除</el-link>
            </div>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <div v-else>
      <el-card class="infoBox">
        <el-form ref="infoFormRef" :rules="rules" :model="infoForm" label-width="80px">
          <el-row>
            <el-form-item prop="name" style="width:320px;float:left;">
              <p style="float:left;line-height:32px;margin:0 10px 0 -50px;">
                名称:
                <span style="color:red;font-size:16px;">*</span>
              </p>
              <el-input v-model="infoForm.name" style="float:left;width:230px;" />
            </el-form-item>
            <el-form-item prop="hangye" style="width:220px;float:left;">
              <p style="float:left;line-height:32px;margin:0 10px 0 -50px;">
                行业:
              </p>
              <el-select v-model="infoForm.industry" style="width:150px;" placeholder="请选择" clearable @change="selectProjectTypeListinfo('')">
                <el-option
                  v-for="item1 in industrys"
                  :key="item1.dictCode"
                  :label="item1.name"
                  :value="item1.dictCode"
                />
              </el-select>
            </el-form-item>
            <el-form-item prop="projectType" style="width:250px;float:left;">
              <p style="float:left;line-height:32px;margin:0 10px 0 -50px;">
                项目类型:
              </p>
              <el-select v-model="infoForm.projectType" style="width:150px;" placeholder="请选择" clearable>
                <el-option
                  v-for="item1 in projectTypes"
                  :key="item1.dictCode"
                  :label="item1.name"
                  :value="item1.dictCode"
                />
              </el-select>
            </el-form-item>
            <el-form-item prop="codeRuleName" style="width:300px;height:30px;float:left;overflow:hidden;text-overflow:ellipsis;white-space:nowrap;">
              <p style="float:left;line-height:32px;margin:0 10px 0 -50px;">
                编码规则:
              </p>
              <el-tooltip effect="light" :content="showCode" placement="top">
                <span style="width:300px;">{{ infoForm.codeRuleName }}</span>
              </el-tooltip>
            </el-form-item>
          </el-row>
          <el-form-item prop="remark">
            <p style="float:left;line-height:32px;margin:0 10px 0 -40px;">
              备注:
            </p>
            <el-input v-model="infoForm.remark" style="width:1000px;" />
          </el-form-item>
        </el-form>
      </el-card>
      <el-card class="mt-10">
        <div>
          <el-button type="text" @click="addNewNode">新增同级节点</el-button>
          <el-button type="text" @click="addNewChildNode">新增子节点</el-button>
          <el-button type="text" @click="deleteNode">删除</el-button>
          <el-button type="text" @click="shiftUp">上移</el-button>
          <el-button type="text" @click="shiftDown">下移</el-button>
          <el-button type="text" @click="expandAll">全部展开</el-button>
          <el-button type="text" @click="collapseAll">全部收起</el-button>
          <el-button type="primary" class="ml-500" @click="codeRuleVisible = true">选择编码规则</el-button>
        </div>
        <el-table
          ref="theTable"
          :data="tableData"
          style="margin-top: 20px;width:100%"
          row-key="id"
          border
          :row-class-name="getindex"
          default-expand-all
          highlight-current-row
          :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
          @row-click="onRowClick"
        >
          <el-table-column type="index" label="序号" width="50" />
          <el-table-column prop="dictCode" label="编码" width="500" />
          <el-table-column label="名称">
            <template slot-scope="scope">
              <el-input v-model="scope.row.dictName" />
            </template>
          </el-table-column>
        </el-table>
        <el-row class="mt-20">
          <el-col :span="3" :offset="10">
            <el-button type="primary" @click="save">保存</el-button>
          </el-col>
          <el-col :span="1">
            <el-button @click="cancel">取消</el-button>
          </el-col>
        </el-row>
      </el-card>
      <el-dialog :visible.sync="codeRuleVisible" width="90%" :show-close="true" title="选择编码规则" :close-on-click-modal="true">
        <SelectCodeRule v-if="codeRuleVisible" :sel-professional="infoForm.industry" :sel-project-type="infoForm.projectType" @setSelectValue="getBackData" @closeCodeRule="closeCodeRule" />
      </el-dialog>
    </div>
  </div>
</template>

<script>
import { getTemplateList, deleteTemplateById, setDefault, getDetil, saveAndUpdate, getCodeRule, cancelDefault } from '@/api/expenseAccountTemplate/expenseAccountTemplate'
import { getDictByItemId } from '@/api/codeRule'
import { getWbsRuleCode } from '@/api/wbsPlan'
import SelectCodeRule from '@/views/wbs/SelectCodeRule.vue'
import { mapGetters } from 'vuex'
export default {
  name: 'ExpenseAccountTemplate',
  components: {
    SelectCodeRule
  },
  data() {
    return {
      showEdit: false,
      searchQuery: {
        templateName: '',
        projectType: '',
        industry: ''
      },
      templateList: [],
      industrys: [],
      projectTypes: [],
      infoForm: {
        name: '',
        industry: '',
        projectType: '',
        codeRule: '',
        remark: '',
        codeRuleName: ''
      },
      rules: {
        name: [
          { required: true, message: '请输入名称', trigger: 'blur' }
        ]
      },
      saveData: {},
      tableData: [],
      tempId: '',
      selectIndex: '',
      setExpenseDictTempDetList: [],
      isCopy: false,
      codeRuleVisible: false,
      showCode: ''
    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  created() {
    this.searchTemplate()
    this.selectProfessionalList()
  },
  methods: {
    searchTemplate() {
      // 接口
      var params = {
        name: this.searchQuery.templateName,
        projectType: this.searchQuery.projectType,
        industry: this.searchQuery.industry,
        tentantId: this.tentantId
      }
      getTemplateList(params).then(res => {
        console.log(res.data)
        if (res && res.code === '200') {
          this.templateList = res.data
        } else {
          this.$message({
            type: 'error',
            message: '获取费用科目模板列表失败'
          })
        }
      })
    },
    async selectProjectTypeList(selectEngType) {
      var this_ = this
      var industry = this.searchQuery.industry
      if (industry) {
        var selectContent = ''
        for (let i = 0; i < this.industrys.length; i++) {
          if (this.industrys[i].dictCode === industry) {
            selectContent = this.industrys[i].content1
            break
          }
        }
        var requestData = { itemId: '82ad9e44e8364057945c88927fde13e6', content1: selectContent }
        await getDictByItemId(requestData).then(res => {
          this_.projectTypes = res
          if (selectEngType) {
            this.$set(this.searchQuery, 'projectType', selectEngType)
          }
        }).catch(() => {
          this.$message({
            message: '获取项目类型失败',
            type: 'error'
          })
        })
      }
    },
    async selectProjectTypeListinfo(selectEngType) {
      var this_ = this
      var industry = this.infoForm.industry
      if (industry) {
        var selectContent = ''
        for (let i = 0; i < this.industrys.length; i++) {
          if (this.industrys[i].dictCode === industry) {
            selectContent = this.industrys[i].content1
            break
          }
        }
        var requestData = { itemId: '82ad9e44e8364057945c88927fde13e6', content1: selectContent }
        await getDictByItemId(requestData).then(res => {
          this_.projectTypes = res
          if (selectEngType) {
            this.$set(this.infoForm, 'projectType', selectEngType)
          }
        }).catch(() => {
          this.$message({
            message: '获取项目类型失败',
            type: 'error'
          })
        })
      }
    },
    async selectProfessionalList() {
      var requestData = { type: 'dict', itemId: '158e8a0a508341beb9dc31423ece82e8' }
      await getDictByItemId(requestData).then(res => {
        this.industrys = res
      }).catch(() => {
        this.$message({
          message: '获取行业失败',
          type: 'error'
        })
      })
    },
    newId(arr) {
      arr.forEach(i => {
        var ID = this.GenNonDuplicateID(20)
        i.id = ID
        var parentID = ID
        if (i.children) {
          for (var j = 0; j < i.children.length; j++) {
            var ID2 = this.GenNonDuplicateID(20)
            i.children[j].id = ID2
            i.children[j].parentId = parentID
          }
          this.newId(i.children)
        }
      })
    },
    getCodeRuleName(tempId, industry, projectType, codeType) {
      var params = {
        tempId: tempId,
        industry: industry,
        projectType: projectType,
        codeType: codeType,
        tentantId: this.tentantId
      }
      console.log(params)
      getCodeRule(params).then(res => {
        console.log(res)
        this.infoForm.codeRuleName = res.tempName
      }).catch(() => {
        this.$message({
          message: '获取模板名失败',
          type: 'error'
        })
      })
    },
    async addNew() {
      this.infoForm = {
        name: '',
        industry: '',
        projectType: '',
        codeRule: '',
        remark: '',
        codeRuleName: ''
      }
      this.tableData = []
      await this.getCodeRuleName(this.infoForm.codeRule, this.infoForm.industry, this.infoForm.projectType, '2')
      this.showCode = await this.getCodetoNode('1', [], '1', this.infoForm.codeRule, this.infoForm.projectType, this.infoForm.industry, '2', this.tentantId)
      this.showEdit = true
    },
    async edit(row) {
      this.infoForm = {
        name: '',
        industry: '',
        projectType: '',
        codeRule: '',
        remark: '',
        codeRuleName: ''
      }
      // 接口
      this.tempId = row.id
      var params = {
        tempId: row.id
      }
      await getDetil(params).then(async res => {
        if (res && res.code === '200') {
          console.log(res)
          this.saveData = res.data
          this.tableData = res.data.expenseDictTempTree
          if (this.isCopy) {
            this.newId(this.tableData)
            console.log('new', this.tableData)
          }
          this.infoForm.name = res.data.name
          this.infoForm.industry = res.data.industry
          await this.selectProjectTypeListinfo('')
          this.infoForm.projectType = res.data.projectType
          this.infoForm.codeRule = res.data.codeRule
          this.infoForm.remark = res.data.remark
          // this.infoForm.codeRuleName = res.data.codeRuleName
        } else {
          this.$message({
            type: 'error',
            message: '获取详情失败'
          })
        }
      })
      console.log('infoFrom', this.infoForm)
      await this.getCodeRuleName(this.infoForm.codeRule, this.infoForm.industry, this.infoForm.projectType, '2')
      this.showCode = await this.getCodetoNode('1', [], '1', this.infoForm.codeRule, this.infoForm.projectType, this.infoForm.industry, '2', this.tentantId)
      this.showEdit = true
    },
    copy(row) {
      this.isCopy = true
      this.edit(row)
    },
    forArr(arr, isExpand) {
      arr.forEach(i => {
        this.$refs.theTable.toggleRowExpansion(i, isExpand)
        if (i.children) {
          this.forArr(i.children, isExpand)
        }
      })
    },
    expandAll() {
      this.forArr(this.tableData, true)
    },
    collapseAll() {
      this.forArr(this.tableData, false)
    },
    getindex({ row, rowIndex }) {
      row.row_index = rowIndex
    },
    onRowClick(row, event, column) {
      this.selectIndex = row
    },
    GenNonDuplicateID(randomLength) {
      return Number(Math.random().toString().substr(3, randomLength) + Date.now()).toString(36)
    },
    async getCodetoNode(childFlag, nodeList, isChild, tempId, projectType, Professional, codeType, tentantId) {
      var dictCode = ''
      var params = {
        childFlag: childFlag,
        nodeList: nodeList,
        isChild: isChild,
        tempId: tempId,
        Professional: Professional,
        projectType: projectType,
        codeType: codeType,
        tentantId: tentantId
      }
      await getWbsRuleCode(params).then(res => {
        console.log(res)
        if (res && res.messageCode === '200') {
          dictCode = res.code
        } else {
          this.$message({
            message: '获取wbs编码失败',
            type: 'error'
          })
        }
      })
      return dictCode
    },
    async addNodeById(arr, row) {
      if (row.parentId === '-1') {
        var ID = this.GenNonDuplicateID(20)
        var nodelist = []
        for (let i = 0; i < arr.length; i++) {
          nodelist.push(arr[i].dictCode)
        }
        var newNode = {
          id: ID,
          dictName: '',
          dictCode: await this.getCodetoNode('1', nodelist, '1', this.infoForm.codeRule, this.infoForm.projectType, this.infoForm.industry, '2', this.tentantId),
          parentId: '-1',
          // sort: arr.length + 1,
          tempId: this.tempId,
          children: []
        }
        arr.push(newNode)
      } else {
        arr.forEach(async(i, index) => {
          if (i.id === row.id) {
            var ID = this.GenNonDuplicateID(20)
            var nodelist = []
            for (let i = 0; i < arr.length; i++) {
              nodelist.push(arr[i].dictCode)
            }
            var newNode = {
              id: ID,
              dictName: '',
              dictCode: await this.getCodetoNode('1', nodelist, '2', this.infoForm.codeRule, this.infoForm.projectType, this.infoForm.industry, '2', this.tentantId),
              parentId: row.parentId,
              // sort: arr.length,
              tempId: this.tempId,
              children: []
            }
            // arr.splice(index + 1, 0, newNode)
            arr.push(newNode)
          }
          if (i.children) {
            this.addNodeById(i.children, row)
          }
        })
      }
    },
    async addNewNode() {
      console.log(this.tableData)
      if (this.tableData && this.tableData.length !== 0) {
        if (this.selectIndex !== '') {
          console.log('新增同级节点', this.selectIndex) // 新增操作
          this.addNodeById(this.tableData, this.selectIndex)
          console.log(this.tableData)
        } else {
          // alert('请选择一个节点！')
          this.$message({
            type: 'info',
            message: '请选择一个节点！'
          })
        }
      } else {
        var ID = this.GenNonDuplicateID(20)
        var nowNode = {
          id: ID,
          dictName: '',
          dictCode: await this.getCodetoNode('1', [], '1', this.infoForm.codeRule, this.infoForm.projectType, this.infoForm.industry, '2', this.tentantId),
          parentId: '-1',
          // sort: 1,
          tempId: this.tempId,
          children: []
        }
        this.tableData.push(nowNode)
      }
    },
    async addChildNodeById(arr, row) {
      arr.forEach(async i => {
        if (i.id === row.id) {
          if (i.children === null || i.children === undefined || i.children === 'undefined' || i.children === '') {
            var a = []
            this.$set(i, 'children', a)
          }
          var childFlag = ''
          var nodelist = []
          var len = i.children.length
          if (len === 0) {
            nodelist.push(i.dictCode)
            childFlag = '2'
          } else {
            for (let j = 0; j < len; j++) {
              if (i.children && i.children[j]) {
                nodelist.push(i.children[j].dictCode)
              }
            }
            childFlag = '1'
          }
          // console.log(isChild)
          var ID = this.GenNonDuplicateID(20)
          var newNode = {
            id: ID,
            dictName: '',
            dictCode: await this.getCodetoNode(childFlag, nodelist, '2', this.infoForm.codeRule, this.infoForm.projectType, this.infoForm.industry, 2, this.tentantId),
            parentId: row.id,
            // sort: i.children.length + 1,
            tempId: this.tempId,
            children: []
          }
          this.$set(i, 'children', i.children)
          i.children.push(newNode)
        }
        if (i.children) {
          this.addChildNodeById(i.children, row)
        }
      })
    },
    addNewChildNode() {
      if (this.selectIndex !== '') {
        console.log('新增子节点', this.selectIndex) // 新增操作
        this.addChildNodeById(this.tableData, this.selectIndex)
        // console.log(this.tableData)
      } else {
        // alert('请选择一个节点！')
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    deleteSearchById(arr, id) {
      arr.forEach((i, index) => {
        if (i.id === id) {
          arr.splice(index, 1)
        }
        if (i.children) {
          this.deleteSearchById(i.children, id)
        }
      })
    },
    deleteNode() {
      if (this.selectIndex !== '') {
        console.log('删除节点', this.selectIndex) // 删除操作
        this.deleteSearchById(this.tableData, this.selectIndex.id)
        this.selectIndex = ''
      } else {
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    // Newsort(arr) {
    //   arr.forEach((i, index) => {
    //     i.sort = index + 1
    //     if (i.children) {
    //       this.Newsort(i.children)
    //     }
    //   })
    // },
    moveUpNodeNById(arr, id) {
      arr.forEach((i, index) => {
        if (i.id === id) {
          if (index === 0) {
            this.$message({
              type: 'info',
              message: '该节点已为第一个节点'
            })
            return
          } else {
            arr.splice(index, 1)
            arr.splice(index - 1, 0, i)
          }
        }
        if (i.children) {
          this.moveUpNodeNById(i.children, id)
        }
      })
    },
    shiftUp() {
      if (this.selectIndex !== '') {
        console.log('上移节点', this.selectIndex) // 上移操作
        this.moveUpNodeNById(this.tableData, this.selectIndex.id)
        // this.Newsort(this.tableData)
        console.log('刷新', this.tableData)
      } else {
        // alert('请选择一个节点！')
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    moveDownNodeNById(arr, id) {
      try {
        arr.forEach((i, index) => {
          if (i.id === id) {
            if (index === arr.length - 1) {
              this.$message({
                type: 'info',
                message: '该节点已为最后一个节点'
              })
              return
            } else {
              arr.splice(index, 1)
              arr.splice(index + 1, 0, i)
              throw new Error('ending')
            }
          }
          if (i.children) {
            this.moveDownNodeNById(i.children, id)
          }
        })
      } catch (e) {
        if (e.message !== 'ending') {
          throw e
        }
      }
    },
    shiftDown() {
      if (this.selectIndex !== '') {
        console.log('下移节点', this.selectIndex) // 下移操作
        this.moveDownNodeNById(this.tableData, this.selectIndex.id)
        // this.Newsort(this.tableData)
        console.log('刷新', this.tableData)
      } else {
        // alert('请选择一个节点！')
        this.$message({
          type: 'info',
          message: '请选择一个节点！'
        })
      }
    },
    async getBackData(sel) {
      this.codeRuleVisible = false
      console.log('sel', sel)
      if (sel) {
        this.$set(this.infoForm, 'codeRule', sel.id)
        this.getCodeRuleName(this.infoForm.codeRule, this.infoForm.industry, this.infoForm.projectType, '2')
        this.showCode = await this.getCodetoNode('1', [], '1', this.infoForm.codeRule, this.infoForm.projectType, this.infoForm.industry, '2', this.tentantId)
        this.$message({ showClose: true, message: '设置成功', type: 'success' })
      }
    },
    closeCodeRule() {
      this.codeRuleVisible = false
    },
    saveTableDataArray(arr) {
      arr.forEach((i, index) => {
        i.sort = i.row_index
        this.setExpenseDictTempDetList.push(i)
        if (i.children) {
          this.saveTableDataArray(i.children)
        }
      })
    },
    save() {
      this.$refs.infoFormRef.validate(async(valid) => {
        if (valid) {
          this.setExpenseDictTempDetList = []
          this.saveTableDataArray(this.tableData)
          console.log(this.tableData)
          // 接口
          var data = this.saveData
          data.tentantId = this.tentantId
          data.name = this.infoForm.name
          data.projectType = this.infoForm.projectType || ''
          data.industry = this.infoForm.industry || ''
          data.remark = this.infoForm.remark
          data.codeRule = this.infoForm.codeRule
          data.codeRuleName = this.infoForm.codeRuleName
          if (this.isCopy) {
            data.isDefault = 0
          }
          data.setExpenseDictTempDetList = this.setExpenseDictTempDetList
          data.expenseDictTempTree = this.tableData
          if (this.isCopy) {
            data.id = ''
          }
          console.log('data', data)
          await saveAndUpdate(data).then(async res => {
            console.log(res)
            if (res && res.state === 'success') {
              this.$message({
                type: 'success',
                message: '保存成功'
              })
              this.$refs.infoFormRef.resetFields()
              this.tableData = []
              // 刷新列表
              await this.searchTemplate()
              this.showEdit = false
              this.isCopy = false
            } else {
              this.isCopy = false
              this.$message({
                type: 'error',
                message: res.msg
              })
            }
          })
        } else {
          // this.$message({
          //   type: 'error',
          //   message: '请填写完整'
          // })
          return false
        }
      })
    },
    cancel() {
      this.infoForm = {
        name: '',
        industry: '',
        projectType: '',
        codeRule: '',
        remark: '',
        codeRuleName: ''
      }
      this.tableData = []
      this.showEdit = false
      this.isCopy = false
    },
    setDefaultFuc(row) {
      // 接口setDefault
      setDefault(row.id).then(res => {
        console.log(res)
        if (res === 'success') {
          this.$message({
            type: 'success',
            message: '设置默认成功'
          })
          this.searchTemplate()
        } else {
          this.$message({
            type: 'error',
            message: '设置默认失败'
          })
        }
      })
      this.searchTemplate()
    },
    cancelDefaultFuc(row) {
      // 接口setDefault
      cancelDefault(row.id).then(res => {
        console.log(res)
        if (res === 'success') {
          this.$message({
            type: 'success',
            message: '取消默认成功'
          })
          this.searchTemplate()
        } else {
          this.$message({
            type: 'error',
            message: '取消默认失败'
          })
        }
      })
      this.searchTemplate()
    },
    deleteTempalate(row) {
      // console.log('删除', row)
      deleteTemplateById(row.id).then(res => {
        console.log(res)
        if (res && res.data === 'success') {
          this.$message({
            type: 'success',
            message: '删除模板成功'
          })
          this.searchTemplate()
        } else {
          this.$message({
            type: 'error',
            message: '删除模板失败'
          })
        }
      })
    }
  }
}
</script>

<style lang="scss" scoped>
.box {
    margin: 20px 15px 5px 15px;
    height: 50px;
    min-width: 900px;
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
.mb-10 {
  margin-bottom: 10px;
}
.mt-20 {
  margin-top: 20px;
}
.mt-30 {
  margin-top: 30px;
}
.ml-500 {
  margin-left: 500px;
}
.infoBox {
  height: 120px;
  min-width: 1200px;
}
</style>
