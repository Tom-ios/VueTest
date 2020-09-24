<template>
  <div ref="pageDiv" class="clearfix pageDiv">
    <el-row style="border: 1px solid #EBEEF5;padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
      <div style="float:left;margin-left:20px">
        <span class="ml-20"> 分组名称</span>
        <el-input v-model="query.groupName" placeholder="" size="mini" style="width: 140px;margin-left:5px;margin-right:10px;" clearable @keyup.enter.native="search" />
        <span class="ml-20"> 姓名</span>
        <el-input v-model="query.name" placeholder="" size="mini" style="width: 140px;margin-left:5px" clearable @keyup.enter.native="search" />
      </div>
      <el-button type="primary" class="ml-10" style="margin-left:20px" size="mini" @click="search">查询</el-button>
      <el-button v-if="bfweb" plain size="mini" class="ml-10" @click="resetForm('query')">重置</el-button>
      <!-- <div v-if="!selectType" style="float:right;margin-right:20px">
        <el-button
          v-if="roleIds !== '01'"
          type="primary"
          size="mini"
          @click="download"
        >
          下载模板
        </el-button>
        <el-upload
          v-if="roleIds !== '01'"
          action=""
          :on-change="onChange"
          :auto-upload="false"
          :show-file-list="false"
          style="display: inline-block"
          accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet,application/vnd.ms-excel"
        >
          <el-button slot="trigger" type="primary" size="mini" style="margin-left:10px">导入</el-button>
        </el-upload>
        <el-button
          style="margin-left:10px"
          type="primary"
          @click="addAccount"
        >
          增加
        </el-button>
      </div> -->
    </el-row>
    <el-row v-if="showTreeToolBar">
      <el-button type="text" class="ml-10" style="font-size:14px;margin-left:20px;" @click="expandAll">全部展开</el-button>
      <el-button type="text" class="ml-10" style="font-size:14px;" @click="collapseAll">全部收起</el-button>
      <el-button type="text" class="ml-10" style="font-size:14px;" @click="addNode">新增同级节点</el-button>
      <el-button type="text" class="ml-10" style="font-size:14px;" @click="addChildNode">新增子节点</el-button>
      <el-button type="text" class="ml-10" style="font-size:14px;" @click="deleteNode">删除</el-button>
      <el-button type="text" class="ml-10" style="font-size:14px;" @click="shiftUpNode">上移</el-button>
      <el-button type="text" class="ml-10" style="font-size:14px;" @click="shiftDownNode">下移</el-button>
      <el-button type="text" class="ml-10" style="font-size:14px;" @click="editName">编辑名称</el-button>
    </el-row>
    <div class="clearfix">
      <el-table
        ref="humanTable"
        :data="tableData"
        border
        highlight-current-row
        :header-cell-class-name="'tableHeader'"
        :cell-class-name="addClass"
        style="margin-top:10px"
        :max-height="maxHeight"
        row-key="id"
        empty-text="暂无数据"
        default-expand-all
        :indent="20"
        :tree-props="{children: 'children', hasChildren: 'hasChildren'}"
        @row-click="rowClick"
        @selection-change="handleSelectionChange"
        @select="selectClick"
        @select-all="selectAll"
      >
        <el-table-column
          v-if="selectType === 'multiple'"
          :type="selectType?'selection':'undefined'"
          :selectable="checkSelectable"
          width="55"
        />
        <!-- <el-table-column
          type="index"
          label="序号"
          width="60"
        /> -->
        <el-table-column
          v-for="(col,index) in tablecolumn"
          :key="index"
          :prop="col.value"
          :label="col.title"
          :min-width="col.width?col.width:'100'"
        >
          <template slot-scope="scope">
            <span v-if="tablecolumn[index].type==='opt'">
              <div v-if="!scope.row.isLeaf" style="text-align: center;">
                <el-button type="text" @click="edit(scope.row)">编辑</el-button>
                <el-button v-if="!scope.row.adminCreateFlag" type="text" @click="del(scope.row)">删除</el-button>
              </div>
              <div v-else-if="scope.row.isLeaf && scope.row.isLeaf === '1'" style="text-align: center;">
                <el-button type="text" @click="addAccount(scope.row)">增加资源</el-button>
              </div>
              <div v-else />
            </span>
            <span v-else> {{ scope.row[tablecolumn[index].key] }}</span>
          </template>
        </el-table-column>
      </el-table>
    </div>
    <el-dialog
      v-if="showHumanDialog"
      :title="showTitle"
      :visible.sync="showHumanDialog"
      width="600px"
      :close-on-click-modal="false"
      @close="closeDialog"
    >
      <div v-loading="loadDing">
        <el-form ref="form" label-width="120px" :rules="addRules" :model="formData" style="margin-left:-30px">
          <el-row>
            <el-col :span="12">
              <el-form-item label="姓名：" prop="name">
                <el-input v-model="formData.name" maxlength="20" />
              </el-form-item>
              <el-form-item label="工作单位：" prop="companyName">
                <el-input v-model="formData.companyName" maxlength="50" />
              </el-form-item>
              <el-form-item label="部门：" prop="orgName">
                <el-input v-model="formData.orgName" maxlength="50" />
              </el-form-item>
              <el-form-item label="职位：" prop="jobName">
                <el-input v-model="formData.jobName" maxlength="20" />
              </el-form-item>
              <el-form-item label="联系方式：" prop="linkPhone">
                <el-input
                  v-model="formData.linkPhone"
                  maxlength="20"
                />
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <!-- <el-form-item label="人员：" prop="userCode">
                <el-input v-model="formData.userCode" maxlength="20" />
              </el-form-item> -->
              <el-form-item label="单价：" prop="price">
                <el-input v-model="formData.price" maxlength="9" />
              </el-form-item>
              <el-form-item label="计量单位：" prop="unit">
                <el-select v-model="formData.unit" placeholder="请选择">
                  <el-option
                    v-for="item in unitArr"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
              <el-form-item label="资源日历：" prop="resourceCaleId">
                <el-select v-model="formData.resourceCaleId" placeholder="请选择">
                  <el-option
                    v-for="item in carlendarArr"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
              <el-form-item label="资源是否可用：" prop="enabled">
                <el-select v-model="formData.enabled" placeholder="请选择">
                  <el-option
                    v-for="item in resourceArr"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </el-col>

          </el-row>
        </el-form>
      </div>
      <span slot="footer">
        <el-button type="primary" :loading="saveLoading" @click="saveAccount">保 存</el-button>
        <el-button @click="closeDialog">取 消</el-button>
      </span>
    </el-dialog>
    <el-dialog
      :title="showTitle"
      :visible.sync="showEditNameDialog"
      width="600px"
    >
      <span style="line-height:32px;margin-left:100px;">
        分组名称:
        <span style="color:red;font-size:16px;">*</span>
      </span>
      <el-input v-model="editGroupName" style="width:230px;" />
      <span slot="footer" class="dialog-footer">
        <el-button @click="cancelEdit">取 消</el-button>
        <el-button type="primary" @click="editGroupNameSure">确 定</el-button>
      </span>
    </el-dialog>
  </div>
</template>
<script>
import { saveAndUpdate, delNode, upload, newGetTreeList, shiftUp, shiftDown, saveHuman, delHuman, queryResourceList } from '@/api/resource'
import { getCalendarList } from '@/api/calendarTemplate/calendarTemplate'
import { getProjectCalendarDefault } from '@/api/projectSet'
import { mapGetters } from 'vuex'
export default {
  props: {
    showTreeToolBar: {
      type: Boolean,
      default: false
    },
    limitEnableSelect: {
      type: Boolean,
      default: true
    },
    listMaxHeight: {
      type: Number,
      default: 0
    },
    selectType: {
      type: String,
      default: ''
    },
    curSelRows: {
      type: Array,
      default: function() { return [] }
    },
    keyWord: {
      type: String,
      default: 'id'
    },
    listurl: {
      type: String,
      default: ''
    },
    typeUrl: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      selectAllFlag: false,
      changedFlag: false,
      addChildFlag: false,
      editGroupName: '',
      parentNode: '',
      currentNode: '',
      showEditNameDialog: false,
      defaultCarlendar: {},
      selResouce: [],
      showTitle: '',
      showHumanDialog: false,
      saveLoading: false,
      loadDing: false,
      query: {
        name: '',
        groupName: ''
      },
      maxHeight: 400,
      tableData: [],
      tablecolumn: [
        {
          title: '分组名/姓名',
          key: 'name',
          width: 200
        },
        {
          title: '工作单位',
          key: 'companyName',
          width: 100
        },
        {
          title: '部门',
          key: 'orgName',
          width: 100
        },
        {
          title: '职位',
          key: 'jobName',
          width: 100
        },
        {
          title: '单价(元)',
          key: 'price',
          width: 70
        },
        {
          title: '计量单位',
          key: 'unitName',
          width: 70
        },
        {
          title: '资源日历',
          key: 'resourceCaleName',
          width: 100
        },
        {
          title: '联系方式',
          key: 'linkPhone',
          width: 110
        },
        {
          title: '是否可用',
          key: 'enabledName',
          width: 70
        },
        {
          title: '创建人',
          key: 'createUserName',
          width: 80
        },
        {
          title: '创建时间',
          key: 'createTime',
          width: 130
        },
        {
          title: '操作',
          type: 'opt',
          width: 100
        }
      ],
      formData: {
        name: '',
        userCode: '',
        resourceCaleId: '',
        type: '0',
        unit: '0',
        enabled: '1'
      },
      resourceArr: [{ value: '1', label: '是' }, { value: '0', label: '否' }],
      carlendarArr: [],
      unitArr: [{ value: '0', label: '天' }, { value: '1', label: '小时' }],
      addRules: {
        name: [
          { required: true, message: '请输入姓名', trigger: 'blur' },
          { max: 20, message: '限20字', trigger: 'blur' }
        ],

        companyName: [
          { required: true, message: '请输入工作单位', trigger: 'blur' }
        ],
        price: [
          { required: true, message: '请输入单价', trigger: 'blur' },
          { validator: (rule, value, callback) => {
            const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
            if (MoneyTest.test(value)) {
              callback()
            } else {
              callback(new Error('请输入非负数，最多两位小数'))
            }
          }, trigger: 'blur' }
        ],
        unit: [
          { required: true, message: '请选择计量单位', trigger: 'blur' }

        ],
        resourceCaleId: [
          { required: true, message: '请选择资源日历', trigger: 'blur' }
        ],
        enabled: [
          { required: true, message: '请选择是否可用', trigger: 'blur' }
        ],
        orgName: [
          { required: true, message: '请输入部门', trigger: 'blur' },
          { max: 50, message: '限50字', trigger: 'blur' }
        ],
        jobName: [
          { required: true, message: '请输入职位', trigger: 'blur' }
        ],
        linkPhone: [
          { required: true, message: '请输入联系方式', trigger: 'blur' }
        ]
      },
      role: '1',
      roleIds: '',
      bfweb: process.env.VUE_APP_BFWEB === 'true'
    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  watch: {
    listMaxHeight(v) {
      if (v) {
        this.caclHeight()
      }
    },
    curSelRows: {
      handler: function(v) {
        this.checkSelRow()
      },
      deep: true
    }
  },
  mounted() {
    getCalendarList({ tentantId: this.tentantId }).then(res => {
      this.carlendarArr = []
      res.data.forEach(element => {
        this.carlendarArr.push({ label: element.calendarName, value: element.id })
      })
      getProjectCalendarDefault({ tentantId: this.tentantId }).then(defaultres => {
        if (defaultres.data && defaultres.data.length > 0) {
          this.defaultCarlendar = defaultres.data[0]
          this.formData.resourceCaleId = this.defaultCarlendar.id
        }
      })
    })
    this.fetchList()
    this.caclHeight()
    if (this.selectType === 'multiple' || this.selectType === 'singleSelect') {
      this.tablecolumn.splice(this.tablecolumn.length - 3, 3)
    }
  },
  methods: {
    cancelEdit() {
      this.showEditNameDialog = false
      this.editGroupName = ''
    },
    selectAll(selection) {
      // console.log('this.selResouce', this.selResouce, 'selection', selection)
      console.log('***selectALl', this.selectAllFlag, 'changeedFlag', this.changedFlag)
      if (this.selectAllFlag && !this.changedFlag) {
        this.findTree(this.tableData, el => {
          if (!el.isLeaf && (el.enabled === 0 || el.enabled === '0')) {
            this.$refs.humanTable.toggleRowSelection(el, false)
          } else {
            this.$refs.humanTable.toggleRowSelection(el, true)
          }
        })
        this.changedFlag = true
      } else {
        this.findTree(this.tableData, el => {
          this.$refs.humanTable.toggleRowSelection(el, false)
        })
        this.changedFlag = false
      }
      // if (this.selResouce.length !== 0) {
      //   this.$refs.humanTable.clearSelection()
      //   this.findTree(this.tableData, el => {
      //     this.$refs.humanTable.toggleRowSelection(el, true)
      //   })
      // } else {
      //   this.findTree(this.tableData, el => {
      //     this.$refs.humanTable.toggleRowSelection(el, false)
      //   })
      //   // this.$refs.humanTable.clearSelection()
      // }
    },
    selectClick(selection, row) {
      // console.log('点击选中', selection, '选中', row)
      var result = selection.some(item => {
        if (item.id === row.id) {
          return true
        }
      })
      if (result) { // 勾选当前节点
        if (row.children) {
          this.downRecursion(row.children, true)
          this.upRecursion(row, selection)
        } else {
          this.upRecursion(row, selection)
        }
      } else { // 取消勾选当前节点
        this.downRecursion(row.children, selection, false)
        this.upRecursion(row, selection)
      }
    },

    downRecursion(row, type) { // 向下递归
      if (!row) {
        return
      } else {
        row.forEach(el => {
          if (type) { // 勾选
            // if (el.enabled === '1' || el.enabled === 1) { // 检查是否可用
            //   this.$refs.humanTable.toggleRowSelection(el, type)
            // }
            this.$refs.humanTable.toggleRowSelection(el, type)
          } else { // 取消勾选
            // for (let k = 0; k < selection.length; k++) {
            //   if (selection[k].id === el.id) {
            //     selection.splice(k, 1)
            //   }
            // }
          }
          if (el.children && el.children.length !== 0) {
            this.downRecursion(el.children, type)
          }
        })
      }
    },

    upRecursion(row, selection) { // 向上递归
      console.log('-----0000当前节点', row.name)
      if ((row && row.parentId && row.parentId === '-1')) {
        return
      } else {
        let parent = ''
        this.findTree(this.tableData, el => {
          if ((row.isLeaf && el.id === row.parentId) || (!row.isLeaf && el.id === row.groupId)) {
            parent = el
            console.log('tag----父节点', el.name)
            // console.log('parent', el)
            var isExitLenth = 0
            var len = 0 // 还要排除不可用的资源节点
            el.children.forEach(elem => {
              if ((elem.enabled === 1 || elem.enabled === '1') || el.isLeaf) {
                len++
              }
            })
            console.log('len', len)
            var str = ''
            var childStr = ''
            selection.forEach(element => {
              str += ('**' + element.name)
            })
            el.children.forEach(element => {
              childStr += ('**' + element.name)
            })
            console.log('选中selection', str, 'children节点', childStr)
            el.children.forEach(ele => {
              selection.forEach(item => {
                if (item.id === ele.id) {
                  isExitLenth++
                }
              })
            })
            console.log('isExitLenth', isExitLenth)
            if (isExitLenth === len) {
              // 全选
              console.log('全选---', el.name)
              this.$refs.humanTable.toggleRowSelection(el, true)
              // 勾选父节点后需要把父节点推进selection，不然递归的selection不变化
              // selection.push(el)
              var isExit = false
              for (let k = 0; k < selection.length; k++) {
                if (selection[k].id === el.id) {
                  isExit = true
                }
              }
              if (!isExit) {
                console.log('0000++++',)
                selection.push(el)
              }
            } else {
              // 取消全选
              console.log('取消全选---', el.name)
              this.$refs.humanTable.toggleRowSelection(el, false)
              // 取消勾选需要把父节点从selection中剔除
              for (let k = 0; k < selection.length; k++) {
                if (selection[k].id === el.id) {
                  selection.splice(k, 1)
                }
              }
            }
          }
        })
        this.upRecursion(parent, selection)
      }
    },

    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    forArr(arr, isExpand) {
      arr.forEach(i => {
        this.$refs.humanTable.toggleRowExpansion(i, isExpand)
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
    forArrById(arr, id) {
      arr.forEach(i => {
        if (i.id === id) {
          this.parentNode = i
        }
        if (i.children) {
          this.forArrById(i.children, id)
        }
      })
    },
    addNode() {
      if (this.tableData && this.tableData.length === 0) {
        this.showTitle = '新增'
        this.showEditNameDialog = true
      } else {
        if (!this.currentNode) {
          this.$message({
            type: 'info',
            message: '请选择节点!'
          })
        } else {
          if (!this.currentNode.isLeaf) {
            return this.$message({
              type: 'error',
              message: '请选择分组!'
            })
          } else {
            this.showTitle = '新增'
            this.showEditNameDialog = true
          }
        }
      }
    },
    addChildNode() {
      if (!this.currentNode) {
        this.$message({
          type: 'info',
          message: '请选择节点!'
        })
      } else {
        if (!this.currentNode.isLeaf) {
          return this.$message({
            type: 'error',
            message: '请选择分组!'
          })
        } else {
          if (this.currentNode.isLeaf === '1' && this.currentNode.children && this.currentNode.children.length !== 0) {
            return this.$message({
              type: 'error',
              message: '此分组已关联资源，如需调整层级关系请删除分组中所有资源!'
            })
          } else {
            this.showTitle = '新增'
            this.addChildFlag = true
            this.showEditNameDialog = true
          }
        }
      }
    },
    deleteNode() {
      if (!this.currentNode) {
        this.$message({
          type: 'info',
          message: '请选择节点!'
        })
      } else {
        if (!this.currentNode.isLeaf) {
          return this.$message({
            type: 'error',
            message: '请选择分组!'
          })
        } else {
          this.$confirm(`是否删除选中分组？`, '提示', {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning',
            dangerouslyUseHTMLString: true
          }).then(() => {
            delNode(this.currentNode.id).then(res => {
              this.$message({
                type: 'success',
                message: '删除成功!'
              })
              this.fetchList()
              this.currentNode = ''
            })
          })
        }
      }
    },
    shiftUpNode() {
      if (!this.currentNode) {
        this.$message({
          type: 'info',
          message: '请选择节点!'
        })
      } else {
        if (!this.currentNode.isLeaf) {
          return this.$message({
            type: 'error',
            message: '请选择分组!'
          })
        } else {
          shiftUp(this.currentNode.id).then(res => {
            this.$message({
              type: 'success',
              // message: '节点上移!'
              message: res.msg
            })
            this.fetchList()
            this.currentNode = ''
            this.$refs.humanTable.setCurrentRow()
          })
        }
      }
    },
    shiftDownNode() {
      if (!this.currentNode) {
        this.$message({
          type: 'info',
          message: '请选择节点!'
        })
      } else {
        if (!this.currentNode.isLeaf) {
          return this.$message({
            type: 'error',
            message: '请选择分组!'
          })
        } else {
          shiftDown(this.currentNode.id).then(res => {
            this.$message({
              type: 'success',
              // message: '节点下移!'
              message: res.msg
            })
            this.fetchList()
            this.currentNode = ''
            this.$refs.humanTable.setCurrentRow()
          })
        }
      }
    },
    editName() {
      if (!this.currentNode) {
        this.$message({
          type: 'info',
          message: '请选择分组!'
        })
      } else {
        if (!this.currentNode.isLeaf) {
          return this.$message({
            type: 'error',
            message: '请选择分组!'
          })
        } else {
          this.showTitle = '编辑'
          this.showEditNameDialog = true
          this.editGroupName = this.currentNode.name
          // console.log(this.currentNode)
        }
      }
    },
    async editGroupNameSure() {
      if (this.editGroupName === '') {
        return this.$message({
          message: '请填写分组名称',
          type: 'error'
        })
      } else {
        var node = { ...this.currentNode, ...{ tentantId: this.tentantId }}
        node.name = this.editGroupName
        if (this.showTitle === '新增') {
          node.id = null
          node.children = null
          node.isLeaf = '1'
          node.createTime = null
          node.updateTime = null
          node.createUser = null
          node.updateUser = null
          if (!this.addChildFlag) {
            // 新增同级
            if (this.currentNode.parentId === '-1' || (this.tableData && this.tableData.length === 0)) {
              // 新增根节点
              node.sort = this.tableData.length + 1
              node.path = null
              node.parentId = '-1'
            } else {
              // 新增的不是根节点，先找到当前选中节点的父节点
              await this.forArrById(this.tableData, this.currentNode.parentId)
              node.sort = this.parentNode.children ? this.parentNode.children.length + 1 : 1
              node.path = this.parentNode.path
              node.parentId = this.parentNode.id
            }
          } else {
            // 新增子级
            node.parentId = this.currentNode.id
            node.path = this.currentNode.path
            node.sort = this.currentNode.children ? this.currentNode.children.length + 1 : 1
          }
        }
        node.classification = '1'
        saveAndUpdate(node).then(res => {
          this.$message({
            type: 'success',
            message: '成功!'
          })
          this.fetchList()
          this.currentNode = ''
          this.parentNode = ''
          this.showEditNameDialog = false
          this.editGroupName = ''
          this.addChildFlag = false
        })
      }
    },
    checkSelectable(row) {
      if (this.limitEnableSelect) {
        if (row.isLeaf) {
          return true
        } else {
          return row.enabled === '1'
        }
      } else {
        return true
      }
    },
    checkSelRow() {
      // console.log('回显***', this.curSelRows)
      this.selResouce = []
      var selArr = []
      this.$refs.humanTable.clearSelection()
      this.curSelRows.forEach(item => {
        this.findTree(this.tableData, element => {
          if (item[this.keyWord] === element.id) {
            selArr.push(element)
            this.$refs.humanTable.toggleRowSelection(element, true)
          }
        })
      })
      // this.toggleSelection(selArr)
      selArr.forEach(el => {
        this.upRecursion(el, selArr) // 回显只往上走
      })
    },
    toggleSelection(rows) {
      if (rows && rows.length > 0) {
        rows.forEach(row => {
          this.$refs.humanTable.toggleRowSelection(row, true)
        })
      } else {
        this.$refs.humanTable.clearSelection()
        this.selResouce = []
      }
    },
    caclHeight() {
      this.$nextTick(() => {
        if (this.listMaxHeight !== 0) {
          this.maxHeight = this.listMaxHeight
        } else {
          this.maxHeight = this.$refs.pageDiv.clientHeight - 100
        }
      })
    },
    edit(curRow) {
      this.formData = { ...curRow }
      this.showTitle = '编辑'
      this.showHumanDialog = true
    },
    del(curRow) {
      this.$confirm(`是否删除资源`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        delHuman(curRow.id).then(res => {
          this.$message({
            type: 'success',
            message: '删除成功!'
          })
          this.fetchList()
        })
      })
    },
    addAccount(row) {
      this.showTitle = '增加人力'
      this.showHumanDialog = true
      this.parentNode = row
    },
    saveAccount() { // 添加人力资源
      this.$refs.form.validate((valid) => {
        if (valid) {
          this.saveLoading = true
          var questData = { ...this.formData, ...{ tentantId: this.tentantId }}
          questData.groupId = this.parentNode.id
          saveHuman(questData).then(res => {

          }).finally(() => {
            this.saveLoading = false
            this.fetchList()
            this.showHumanDialog = false
            this.formData = {
              name: '',
              userCode: '',
              type: '0',
              unit: '0',
              enabled: '1',
              resourceCaleId: this.defaultCarlendar.id
            }
            this.parentNode = ''
          })
        } else {
          return false
        }
      })
    },
    search() {
      this.fetchList()
    },
    fetchList(callback) {
      if (this.typeUrl && this.typeUrl === 'planlistView') { // 走计划表查看资源接口
        var param = {
          projectId: this.$route.params.id,
          resType: '1',
          resName: this.query.name.trim(),
          groupName: this.query.groupName.trim()
        }
        queryResourceList(param).then(res => {
          this.tableData = res.data
          this.selResouce = [...this.selResouce]
          var arr = []
          this.curSelRows.forEach(item => {
            var isExit = false
            this.selResouce.forEach(element => {
              if (item[this.keyWord] === element.id) {
                isExit = true
              }
            })
            if (!isExit) {
              this.selResouce.push(item)
            }
          })
          this.selResouce.forEach(item => {
            this.findTree(res.data, selItem => {
              if (item[this.keyWord] === selItem.id) {
                arr.push(selItem)
              }
            })
          })
          this.$nextTick(() => {
            this.toggleSelection(arr)
            arr.forEach(el => {
              this.upRecursion(el, arr) // 回显只往上走
            })
          })
        })
      } else {
        /* 重构树形 */
        var params = {
          classification: 1,
          tentantId: this.tentantId,
          resourceName: this.query.name.trim(),
          groupName: this.query.groupName.trim()
        }
        if (this.listurl) {
          params = { projectId: this.$route.params.id, resType: 1, resourceName: this.query.name.trim(),
            groupName: this.query.groupName ? this.query.groupName.trim() : '' }
        }

        newGetTreeList(params, this.listurl).then(res => {
          this.tableData = res.data

          this.$nextTick(() => {
            this.selResouce = [...this.selResouce]
            var arr = []
            // 下面相当于 this.selResouce = [...this.selResouce] + this.curSelRows 去重
            this.curSelRows.forEach(item => {
              var isExit = false
              this.selResouce.forEach(element => {
                if (item[this.keyWord] === element.id) {
                  isExit = true
                }
              })

              if (!isExit) {
                this.selResouce.push(item)
              }
            })
            this.selResouce.forEach(item => {
              this.findTree(this.tableData, selItem => {
                if (item[this.keyWord] === selItem.id) {
                  arr.push(selItem)
                }
              })
            })

            this.toggleSelection(arr)
            arr.forEach(el => {
              this.upRecursion(el, arr) // 回显只往上走
            })
          })
        })
      }
    },
    cancelSel() {
      this.$refs.humanTable.setCurrentRow()
      this.toggleSelection()
    },
    handleSelectionChange(selection) {
      // console.log('最终数组', selection)
      if (this.selectType === 'multiple') {
        // this.selResouce = [...selection, ...this.otherPageSel]
        this.selResouce = []
        if (selection.length !== 0) {
          selection.forEach(el => {
            if (!el.isLeaf && (el.enabled === '1' || el.enabled === 1)) { // 剔除不可用资源
              var exitflag = false
              this.selResouce.forEach(item => {
                if (item.id === el.id) {
                  exitflag = true
                }
              })
              if (!exitflag) {
                this.selResouce.push(el)
              }
            } else { // 如果不是叶子节点就遍历
              // console.log('eccccl', this.selResouce)
              if (!el.children) {
                return
              }
              this.findTree(el.children, ele => {
                if (!ele.isLeaf && (ele.enabled === '1' || ele.enabled === 1)) { // 剔除不可用资源
                  var exit = false
                  this.selResouce.forEach(item => {
                    if (item.id === ele.id) {
                      exit = true
                    }
                  })
                  if (!exit) {
                    this.selResouce.push(ele)
                  }
                }
              })
            }
          })
        }
        // var ZYCount = 0
        // this.findTree(this.tableData, el => {
        //   if (!el.isLeaf && (el.enabled === '1' || el.enabled === 1)) { // 只有可用的资源节点才算
        //     ZYCount++
        //   }
        // })
        // if (ZYCount === this.selResouce.length) { // 如果所有可用的资源节点都选中了说明全选？还是所有节点都选中才算全选？这样禁用的需要剔除
        //   this.selectAllFlag = true
        // } else {
        //   this.selectAllFlag = false
        // }

        // 或者遍历一遍树所有根节点，所有根节点下所有不可用资源之外的资源都选中了说明全选,如果这个根节点没有资源节点也得选上
        var trueflag = 0 // 存储树下是否所有节点都为true
        // this.tableData.forEach(element => { // 拿出单个根节点递归
        //   // console.log('*/*/*/*/*', element)
        //   var haveChild = 0 // 存储当前根节点下所有可用资源节点的个数
        //   if (element.children !== null && element.children.length !== 0) {
        //     this.findTree(element.children, el => { // 遍历当前根节点下所有资源
        //       if (!el.isLeaf && (el.enabled === 1 || el.enabled === '1')) {
        //         haveChild++
        //       }
        //     })
        //   }
        //   if (haveChild !== 0) { // 当前根节点有可用的资源节点
        //     var len = 0
        //     this.findTree(element.children, el => { // 遍历当前根节点下所有可用资源节点
        //       if (!el.isLeaf && (el.enabled === 1 || el.enabled === '1')) { // 可用节点都在选中数组中的话
        //         this.selResouce.forEach(item => {
        //           if (item.id === el.id) {
        //             len++
        //           }
        //         })
        //       }
        //     })
        //     // console.log('len', len)
        //     if (len === haveChild) {
        //       trueflag++
        //     }
        //   } else { // 当前根节点没有资源节点，那这个根节点可以跳过
        //     trueflag++
        //   }
        //   // console.log('haveChild', haveChild)
        //   // console.log('trueflag', trueflag)
        // })
        this.tableData.forEach(el => {
          selection.forEach(item => {
            if (item.id === el.id) {
              trueflag++
            }
          })
        })
        // console.log('trueflag', trueflag)
        if (trueflag === this.tableData.length) {
          this.selectAllFlag = true
        } else {
          this.selectAllFlag = false
        }
        // console.log('全选标志', this.selectAllFlag)
      } else if (this.selectType === 'singleSelect') {
        // 单选
        // this.selResouce = selection
        // console.log('this.selResouce', this.selResouce)
      }
      // console.log('选中的资源', this.selResouce)
    },
    onChange(file) {
      const d = new FormData()
      d.append('file', file.raw)
      d.append('tentantId', this.tentantId)
      d.append('importtype', 'human')
      upload(d).then(res => {
        if (res && res.data && (res.data.info || res.data.istemplent || res.data.isexcel || res.data.isdata)) {
          let message = ''
          if (res.data.info) {
            res.data.info.forEach(item => {
              message += item + '<br/>'
            })
          }
          if (res.data.istemplent) {
            message = res.data.istemplent
          }
          if (res.data.isexcel) {
            message = res.data.isexcel
          }
          if (res.data.isdata) {
            message = res.data.isdata
          }
          this.$alert(message, '导入错误', {
            confirmButtonText: '确定',
            dangerouslyUseHTMLString: true
          })
        } else {
          this.$message({
            type: 'success',
            message: '导入成功!'
          })
          this.fetchList()
        }
      })
    },
    rowClick(row, col, event) {
      this.$refs.humanTable.setCurrentRow(row)
      this.currentNode = row // 点击就是单选
      if (this.selectType === 'singleSelect') {
        this.selResouce = [row]
      }
    },
    addClass({ row, columnIndex }) {
      // return 'justcenter'
      // if (columnIndex === 1) {
      //   return ''
      // } else {
      //   return 'justcenter'
      // }
      if (this.selectType === 'multiple') {
        if (columnIndex === 1 && row.isLeaf) {
          return 'grayBgColorAndNoCellBorder'
        } else if (columnIndex !== 1 && row.isLeaf) {
          return 'grayBgColorCenterAndNoCellBorder'
        } else if (columnIndex !== 1) {
          return 'textCenter'
        }
        return ''
      } else {
        if (columnIndex === 0 && row.isLeaf) {
          return 'grayBgColorAndNoCellBorder'
        } else if (columnIndex !== 0 && row.isLeaf) {
          return 'grayBgColorCenterAndNoCellBorder'
        } else if (columnIndex !== 0 && !row.isLeaf) {
          var flag1 = false
          this.selResouce.forEach(el => {
            // console.log('有')
            if (row.id === el.id) {
              flag1 = true
            }
          })
          if (flag1) {
            return 'rowHeightLightStyle'
          }
          return 'textCenter'
        } else if (columnIndex === 0 && !row.isLeaf) {
          var flag = false
          this.selResouce.forEach(el => {
            // console.log('有')
            if (row.id === el.id) {
              flag = true
            }
          })
          if (flag) {
            return 'rowHeightLightStyle'
          }
        }
        return ''
      }
    },
    download() {
      window.location.href = process.env.VUE_APP_BASE_API + 'project-system-set/setResource/download?importtype=human'
    },
    closeDialog() {
      this.reset()
      this.showHumanDialog = false
    },
    reset() {
      this.$refs.form.validate((valid) => {
        if (!valid) {
          this.$refs.form.resetFields()
        }
      })

      this.saveDisable = false
      this.formData = {
        name: '',
        userCode: '',
        type: '0',
        unit: '0',
        enabled: '1',
        resourceCaleId: this.defaultCarlendar.id
      }
    },
    keydownhandle(event) {
      const { key } = event
      // 或者根据键码判断, 下面过滤掉除数字和退格外的所有输入
      if (new RegExp(/((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/).test(key) || key === 'Backspace') return
      event.preventDefault()
    },
    resetForm(formName) {
      this.query.name = ''
      this.query.groupName = ''
      this.search()
    }
  }

}
</script>
<style lang="scss" scoped>
 /deep/ .el-table td.grayBgColorAndNoCellBorder{
  background: #dcdfe6;
  border-left: 0px;
  border-right: 0px;
}
 /deep/ .el-table td.grayBgColorCenterAndNoCellBorder{
  background: #dcdfe6;
  border-left: 0px;
  border-right: 0px;
  text-align: center;
}
 /deep/ .el-table td.textCenter{
  text-align: center;
}
.pageDiv{
  width: 100%;
  height: 100%;
  position: absolute;
}
.mt-20{
  margin-top:20px;
}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
/deep/ .justcenter{
  text-align: center;
}
/deep/ .el-checkbox__label{
  line-height: 16px
}
/deep/ .el-table td.redBgColor{
  background: red;
  text-align: center;
}

/deep/ .el-table td.rowHeightLightStyle{
  background: #b9d7fa;
}
</style>
