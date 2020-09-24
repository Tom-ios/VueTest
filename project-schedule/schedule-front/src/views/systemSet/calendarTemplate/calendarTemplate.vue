<template>
  <div>
    <div v-if="showEdit === false">
      <div class="box clearfix">
        <div style="width:500px;">
          <span style="float:left;font-size:14px;line-height:32px;margin-right:10px;">模板名称</span>
          <el-input v-model="templateName" style="float:left;width:250px;margin-right:10px;" clearable @clear="clearName" />
          <el-button style="float:left;" size="mini" type="primary" @click="searchTemplate">查询</el-button>
          <el-button v-if="bfweb" plain size="mini" class="ml-10" @click="resetForm('templateName')">重置</el-button>
        </div>
        <div style="float:right">
          <el-button v-if="!selectType" type="primary" icon="el-icon-plus" @click="addNew">新增</el-button>
        </div>
      </div>
      <div class="ml-10 mr-10">
        <el-table :data="tableData" highlight-current-row border @row-click="rowClick">
          <el-table-column type="index" label="序号" width="50" />
          <el-table-column prop="isDefault" label="默认日历" align="center" width="70">
            <template slot-scope="scope">
              <div v-if="scope.row.isDefault === 1">
                <span>是</span>
              </div>
              <div v-else-if="scope.row.isDefault === 2">
                <span>系统模板</span>
              </div>
              <div v-else>
                <span />
              </div>
            </template>
          </el-table-column>
          <el-table-column prop="calendarName" label="日历名称" align="center" />
          <el-table-column prop="remark" label="备注" align="center" />
          <el-table-column prop="createUserName" label="创建人" align="center" />
          <el-table-column prop="createTime" label="创建时间" align="center" />
          <el-table-column prop="updateUserName" label="最近编辑人" align="center" />
          <el-table-column prop="updateTime" label="最近编辑时间" align="center" />
          <el-table-column v-if="!selectType" label="操作" align="center" width="250">
            <template slot-scope="scope">
              <div v-if="scope.row.isDefault === 1">
                <el-link :underline="false" type="primary" @click="edit(scope.row)">编辑</el-link>
                |
                <el-link :underline="false" type="primary" @click="copy(scope.row)">复制增加</el-link>
                |
                <el-link :underline="false" type="primary" @click="cancelDefaultFuc(scope.row)">取消默认</el-link>
                <!-- <el-button type="text" @click="setDefault(scope.row)">设为默认</el-button> -->
              </div>
              <div v-else-if="scope.row.isDefault === 2">
                <!-- <el-button type="text" @click="edit(scope.row)">编辑</el-button> -->
                <el-link :underline="false" type="primary" @click="copy(scope.row)">复制增加</el-link>
                <!-- <el-button type="text" @click="setDefaultFuc(scope.row)">设为默认</el-button> -->
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
    </div>
    <div v-else>
      <el-card class="calendarbox">
        <el-card>
          <span>基本信息</span>
          <el-form ref="editFormRef" :model="editForm" :rules="rules" label-width="100px" class="mt-20">
            <el-row>
              <el-col :span="12">
                <el-form-item prop="calendarName">
                  <p style="float:left;line-height:32px;margin:0 10px 0 -80px;">
                    日历名称:
                    <span style="color:red;font-size:16px;">*</span>
                  </p>
                  <el-input v-model="editForm.calendarName" style="float:left;width:400px;" placeholder="请输入内容" maxlength="50" clearable />
                </el-form-item>
              </el-col>
              <el-col :span="10" :offset="2">
                <el-form-item prop="createUserName">
                  <p style="float:left;line-height:32px;margin:0 10px 0 -100px;">
                    创建人:
                  </p>
                  <span>{{ editForm.createUserName }}</span>
                </el-form-item>
              </el-col>
            </el-row>
            <el-row>
              <el-col :span="12">
                <el-form-item prop="remark">
                  <p style="float:left;line-height:32px;margin:0 10px 0 -50px;">
                    备注:
                  </p>
                  <el-input v-model="editForm.remark" style="float:left;width:400px;" type="textarea" placeholder="请输入内容" maxlength="200" />
                </el-form-item>
              </el-col>
              <el-col :span="10" :offset="2">
                <el-form-item prop="createTime">
                  <p style="float:left;line-height:32px;margin:0 10px 0 -100px;">
                    创建时间:
                  </p>
                  <span>{{ editForm.createTime }}</span>
                </el-form-item>
              </el-col>
            </el-row>
          </el-form>
        </el-card>
        <el-card class="mt-10">
          <span>工作日信息</span>
          <el-table :data="editTableDataWorkDay" border class="infotable">
            <el-table-column prop="name" label="属性/星期" />
            <el-table-column width="110" align="center">
              <template slot="header">
                <p>
                  周一
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <div v-if="scope.row.name === '工作时长(小时)'">
                  <el-input v-model="editTableDataWorkDay[0].MonWorkHour" type="number" min="0" max="24" step="0.5" @input="limitlength($event, 1)" @change="limitlength($event, 1)" />
                </div>
                <div v-else>
                  <el-select v-model="editTableDataWorkDay[1].MonWorkDay" placeholder="请选择">
                    <el-option
                      v-for="item1 in workDayOptions"
                      :key="item1.value"
                      :label="item1.label"
                      :value="item1.value"
                    />
                  </el-select>
                </div>
              </template>
            </el-table-column>
            <el-table-column width="110" align="center">
              <template slot="header">
                <p>
                  周二
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <div v-if="scope.row.name === '工作时长(小时)'">
                  <el-input v-model="editTableDataWorkDay[0].TueWorkHour" type="number" min="0" max="24" step="0.5" @input="limitlength($event, 2)" @change="limitlength($event, 2)" />
                </div>
                <div v-else>
                  <el-select v-model="editTableDataWorkDay[1].TueWorkDay" placeholder="请选择">
                    <el-option
                      v-for="item2 in workDayOptions"
                      :key="item2.value"
                      :label="item2.label"
                      :value="item2.value"
                    />
                  </el-select>
                </div>
              </template>
            </el-table-column>
            <el-table-column width="110" align="center">
              <template slot="header">
                <p>
                  周三
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <div v-if="scope.row.name === '工作时长(小时)'">
                  <el-input v-model="editTableDataWorkDay[0].WedWorkHour" type="number" min="0" max="24" step="0.5" @input="limitlength($event, 3)" @change="limitlength($event, 3)" />
                </div>
                <div v-else>
                  <el-select v-model="editTableDataWorkDay[1].WedWorkDay" placeholder="请选择">
                    <el-option
                      v-for="item3 in workDayOptions"
                      :key="item3.value"
                      :label="item3.label"
                      :value="item3.value"
                    />
                  </el-select>
                </div>
              </template>
            </el-table-column>
            <el-table-column width="110" align="center">
              <template slot="header">
                <p>
                  周四
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <div v-if="scope.row.name === '工作时长(小时)'">
                  <el-input v-model="editTableDataWorkDay[0].ThuWorkHour" type="number" min="0" max="24" step="0.5" @input="limitlength($event, 4)" @change="limitlength($event, 4)" />
                </div>
                <div v-else>
                  <el-select v-model="editTableDataWorkDay[1].ThuWorkDay" placeholder="请选择">
                    <el-option
                      v-for="item4 in workDayOptions"
                      :key="item4.value"
                      :label="item4.label"
                      :value="item4.value"
                    />
                  </el-select>
                </div>
              </template>
            </el-table-column>
            <el-table-column width="110" align="center">
              <template slot="header">
                <p>
                  周五
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <div v-if="scope.row.name === '工作时长(小时)'">
                  <el-input v-model="editTableDataWorkDay[0].FriWorkHour" type="number" min="0" max="24" step="0.5" @input="limitlength($event, 5)" @change="limitlength($event, 5)" />
                </div>
                <div v-else>
                  <el-select v-model="editTableDataWorkDay[1].FriWorkDay" placeholder="请选择">
                    <el-option
                      v-for="item5 in workDayOptions"
                      :key="item5.value"
                      :label="item5.label"
                      :value="item5.value"
                    />
                  </el-select>
                </div>
              </template>
            </el-table-column>
            <el-table-column width="110" align="center">
              <template slot="header">
                <p>
                  周六
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <div v-if="scope.row.name === '工作时长(小时)'">
                  <el-input v-model="editTableDataWorkDay[0].SatWorkHour" type="number" min="0" max="24" step="0.5" @input="limitlength($event, 6)" @change="limitlength($event, 6)" />
                </div>
                <div v-else>
                  <el-select v-model="editTableDataWorkDay[1].SatWorkDay" placeholder="请选择">
                    <el-option
                      v-for="item6 in workDayOptions"
                      :key="item6.value"
                      :label="item6.label"
                      :value="item6.value"
                    />
                  </el-select>
                </div>
              </template>
            </el-table-column>
            <el-table-column width="110" align="center">
              <template slot="header">
                <p>
                  周日
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <div v-if="scope.row.name === '工作时长(小时)'">
                  <el-input v-model="editTableDataWorkDay[0].SunWorkHour" type="number" min="0" max="24" step="0.5" @input="limitlength($event, 7)" @change="limitlength($event, 7)" />
                </div>
                <div v-else>
                  <el-select v-model="editTableDataWorkDay[1].SunWorkDay" placeholder="请选择">
                    <el-option
                      v-for="item7 in workDayOptions"
                      :key="item7.value"
                      :label="item7.label"
                      :value="item7.value"
                    />
                  </el-select>
                </div>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
        <el-card class="mt-10">
          <span>例外日期(非工作日)</span>
          <el-col :offset="18" class="mt-10 mb-10">
            <el-button type="primary" size="mini" @click="addlist">增加</el-button>
          </el-col>
          <el-table :data="editTableDataUnWorkDay" border class="infotable" max-height="250px">
            <el-table-column type="index" label="序号" align="center" width="50" />
            <el-table-column prop="exceptionName" align="center">
              <template slot="header">
                <p>
                  名称
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <el-input v-model="scope.row.exceptionName" placeholder="请输入内容" maxlength="50" />
              </template>
            </el-table-column>
            <el-table-column prop="beginDate" align="center" width="200">
              <template slot="header">
                <p>
                  开始时间
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <!-- <el-input v-model="scope.row.beginDate" placeholder="请输入内容"></el-input> -->
                <el-date-picker v-model="scope.row.beginDate" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" style="width:150px;" @change="timepickEndTime(scope.row)" />
              </template>
            </el-table-column>
            <el-table-column prop="endDate" align="center" width="200">
              <template slot="header">
                <p>
                  结束时间
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <!-- <el-input v-model="scope.row.endDate" placeholder="请输入内容"></el-input> -->
                <el-date-picker v-model="scope.row.endDate" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" style="width:150px;" @change="timepickEndTime(scope.row)" />
              </template>
            </el-table-column>
            <el-table-column prop="workDay" align="center" width="150">
              <template slot="header">
                <p>
                  工作日
                  <span style="color:red;font-size:16px;">*</span>
                </p>
              </template>
              <template slot-scope="scope">
                <!-- <el-input v-model="scope.row.endDate" placeholder="请输入内容"></el-input> -->
                <el-select v-model="scope.row.workDay" placeholder="请选择">
                  <el-option
                    v-for="item8 in workDayOptions"
                    :key="item8.value"
                    :label="item8.label"
                    :value="item8.value"
                  />
                </el-select>
              </template>
            </el-table-column>
            <el-table-column label="操作" align="center" width="100">
              <template slot-scope="scope">
                <el-button type="text" @click="deletelist(scope.$index)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
        <el-row class="mt-30">
          <el-col :span="2" :offset="10">
            <el-button type="primary" @click="save">保存</el-button>
          </el-col>
          <el-col :span="2">
            <el-button @click="cancel">取消</el-button>
          </el-col>
        </el-row>
      </el-card>
    </div>
  </div>
</template>

<script>
import { getCalendarList, getCalendarDetail, saveCalendar, deleteCalendar, setDefault, checkCalendar, cancelDefault } from '@/api/calendarTemplate/calendarTemplate'
import { parseTime } from '@/utils/index.js'
import { mapGetters } from 'vuex'
export default {
  name: 'CalendarTemplate',
  props: {
    selectType: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      templateName: '',
      tableData: [],
      showEdit: false,
      editForm: {
        calendarName: '',
        createUserName: '',
        remark: '',
        createTime: ''
      },
      workDayOptions: [
        {
          value: 1,
          label: '是'
        },
        {
          value: 0,
          label: '否'
        }
      ],
      editTableDataWorkDay: [
        {
          name: '工作时长(小时)',
          MonWorkHour: 8,
          TueWorkHour: 8,
          WedWorkHour: 8,
          ThuWorkHour: 8,
          FriWorkHour: 8,
          SatWorkHour: 0,
          SunWorkHour: 0
        },
        {
          name: '工作日',
          MonWorkDay: 1,
          TueWorkDay: 1,
          WedWorkDay: 1,
          ThuWorkDay: 1,
          FriWorkDay: 1,
          SatWorkDay: 0,
          SunWorkDay: 0
        }
      ],
      editTableDataUnWorkDay: [],
      item: {},
      setCalendarDetList: [],
      setCalendarExpList: [],
      addNewFlag: false,
      rules: {
        calendarName: [
          { required: true, message: '日历名称不能为空', trigger: 'blur' }
        ]
      },
      isCopy: false,
      bfweb: process.env.VUE_APP_BFWEB === 'true'
    }
  },
  computed: {
    ...mapGetters([
      'tentantId'
    ])
  },
  created() {
    this.searchTemplate()
  },
  methods: {
    rowClick(row, col, event) {
      this.$emit('selectSingle', { row: row })
    },
    async searchTemplate() {
      var params = {
        calendarName: this.templateName ? this.templateName : '',
        tentantId: this.tentantId
      }
      await getCalendarList(params).then(res => {
        // console.log(res)
        if (res && res.code === '200') {
          this.tableData = res.data
        } else {
          // alert('获取模板列表失败')
          this.$message({
            type: 'error',
            message: '获取日历模板列表失败'
          })
        }
      })
    },
    addNew() {
      this.editTableDataWorkDay = [
        {
          name: '工作时长(小时)',
          MonWorkHour: 8,
          TueWorkHour: 8,
          WedWorkHour: 8,
          ThuWorkHour: 8,
          FriWorkHour: 8,
          SatWorkHour: 0,
          SunWorkHour: 0
        },
        {
          name: '工作日',
          MonWorkDay: 1,
          TueWorkDay: 1,
          WedWorkDay: 1,
          ThuWorkDay: 1,
          FriWorkDay: 1,
          SatWorkDay: 0,
          SunWorkDay: 0
        }
      ]
      this.item.id = ''
      this.item.calendarName = ''
      this.item.isDefault = 0
      this.remark = ''
      this.createUser = ''
      this.createTime = ''
      this.item.updateUser = ''
      this.item.updateTime = ''
      this.item.setCalendarDetList = []
      this.item.setCalendarExpList = []
      // console.log('newitem', this.item)
      this.editForm.createUserName = this.$store.state.user.name
      this.editForm.createUser = this.$store.state.user.userId
      this.editForm.createTime = parseTime(new Date().getTime())
      this.showEdit = true
      this.addNewFlag = true
    },
    async edit(row) {
      console.log(row)
      this.item = JSON.parse(JSON.stringify(row))
      var params = {
        calendarId: row.id
      }
      await getCalendarDetail(params).then(res => {
        if (res && res.code === '200') {
          console.log('res', res)
          this.editForm.calendarName = res.data.calendarName
          this.editForm.createUserName = res.data.createUserName
          this.editForm.remark = res.data.remark
          this.editForm.createTime = res.data.createTime
          this.setCalendarDetList = res.data.setCalendarDetList
          this.setCalendarExpList = res.data.setCalendarExpList
          res.data.setCalendarDetList.forEach(element => {
            console.log(element)
            if (element.weekDay === '1') {
              this.editTableDataWorkDay[0].MonWorkHour = element.workHour
              this.editTableDataWorkDay[1].MonWorkDay = element.workDay
            } else if (element.weekDay === '2') {
              this.editTableDataWorkDay[0].TueWorkHour = element.workHour
              this.editTableDataWorkDay[1].TueWorkDay = element.workDay
            } else if (element.weekDay === '3') {
              this.editTableDataWorkDay[0].WedWorkHour = element.workHour
              this.editTableDataWorkDay[1].WedWorkDay = element.workDay
            } else if (element.weekDay === '4') {
              this.editTableDataWorkDay[0].ThuWorkHour = element.workHour
              this.editTableDataWorkDay[1].ThuWorkDay = element.workDay
            } else if (element.weekDay === '5') {
              this.editTableDataWorkDay[0].FriWorkHour = element.workHour
              this.editTableDataWorkDay[1].FriWorkDay = element.workDay
            } else if (element.weekDay === '6') {
              this.editTableDataWorkDay[0].SatWorkHour = element.workHour
              this.editTableDataWorkDay[1].SatWorkDay = element.workDay
            } else if (element.weekDay === '7') {
              this.editTableDataWorkDay[0].SunWorkHour = element.workHour
              this.editTableDataWorkDay[1].SunWorkDay = element.workDay
            }
          })
          this.editTableDataUnWorkDay = res.data.setCalendarExpList
          this.showEdit = true
          // console.log('this.editTableDataWorkDay', this.editTableDataWorkDay)
        } else {
          // alert('获取模板列表失败')
          this.$message({
            type: 'error',
            message: '获取日历模板列表失败'
          })
        }
      })
    },
    limitlength(event, type) {
      if (event > 24 || event < 0) {
        this.$message({
          type: 'error',
          message: '工作时长在0-24之间，请重新输入'
        })
        if (type === 1) {
          this.editTableDataWorkDay[0].MonWorkHour = ''
        }
        if (type === 2) {
          this.editTableDataWorkDay[0].TueWorkHour = ''
        }
        if (type === 3) {
          this.editTableDataWorkDay[0].WedWorkHour = ''
        }
        if (type === 4) {
          this.editTableDataWorkDay[0].ThuWorkHour = ''
        }
        if (type === 5) {
          this.editTableDataWorkDay[0].FriWorkHour = ''
        }
        if (type === 6) {
          this.editTableDataWorkDay[0].SatWorkHour = ''
        }
        if (type === 7) {
          this.editTableDataWorkDay[0].SunWorkHour = ''
        }
      }
    },
    copy(row) {
      this.isCopy = true
      this.edit(row)
    },
    async save() {
      // if (this.editForm.calendarName === '') {
      //   // alert('日历名称不允许为空')
      //   this.$message({
      //     type: 'error',
      //     message: '日历名称不允许为空'
      //   })
      //   return
      // }
      var data = this.item
      data.tentantId = this.tentantId
      // console.log('data', data)
      // console.log('this.setCalendarDetList', this.setCalendarDetList)
      if (this.isCopy) {
        data.id = ''
      }
      data.calendarName = this.editForm.calendarName
      data.remark = this.editForm.remark
      // data.isDefault = 0
      if (this.addNewFlag === true) {
        data.setCalendarDetList = [
          {
            'id': '',
            'calendarId': '',
            'weekDay': '1',
            'workHour': '',
            'workDay': 1,
            'weekDayName': '周一'
          }, {
            'id': '747521709917463aad7fc3080713d89b',
            'calendarId': 'f551325eddc14a8ba62c280525444524',
            'weekDay': '2',
            'workHour': '',
            'workDay': 1,
            'weekDayName': '周二'
          }, {
            'id': '77ea05c660484cb8857824de28d987a0',
            'calendarId': 'f551325eddc14a8ba62c280525444524',
            'weekDay': '3',
            'workHour': '',
            'workDay': 1,
            'weekDayName': '周三'
          }, {
            'id': '7ddef99d464b4c8e9bd96b67a00bb7a0',
            'calendarId': 'f551325eddc14a8ba62c280525444524',
            'weekDay': '4',
            'workHour': '',
            'workDay': 1,
            'weekDayName': '周四'
          }, {
            'id': '7b1f980a580f416dbe17b8ceff574654',
            'calendarId': 'f551325eddc14a8ba62c280525444524',
            'weekDay': '5',
            'workHour': '',
            'workDay': 1,
            'weekDayName': '周五'
          }, {
            'id': '57b83cd39bc14b81b12dd56b04979d1b',
            'calendarId': 'f551325eddc14a8ba62c280525444524',
            'weekDay': '6',
            'workHour': '',
            'workDay': 0,
            'weekDayName': '周六'
          }, {
            'id': 'a8a34da2b35c401c98d4ddd73f6ba391',
            'calendarId': 'f551325eddc14a8ba62c280525444524',
            'weekDay': '7',
            'workHour': '',
            'workDay': 0,
            'weekDayName': '周日'
          }
        ]
      } else {
        data.setCalendarDetList = this.setCalendarDetList
      }
      data.setCalendarDetList.forEach(element => {
        // console.log(element)
        if (this.isCopy) {
          element.id = ''
          element.calendarId = ''
        }
        if (element.weekDay === '1') {
          element.workHour = this.editTableDataWorkDay[0].MonWorkHour
          element.workDay = this.editTableDataWorkDay[1].MonWorkDay
        } else if (element.weekDay === '2') {
          element.workHour = this.editTableDataWorkDay[0].TueWorkHour
          element.workDay = this.editTableDataWorkDay[1].TueWorkDay
        } else if (element.weekDay === '3') {
          element.workHour = this.editTableDataWorkDay[0].WedWorkHour
          element.workDay = this.editTableDataWorkDay[1].WedWorkDay
        } else if (element.weekDay === '4') {
          element.workHour = this.editTableDataWorkDay[0].ThuWorkHour
          element.workDay = this.editTableDataWorkDay[1].ThuWorkDay
        } else if (element.weekDay === '5') {
          element.workHour = this.editTableDataWorkDay[0].FriWorkHour
          element.workDay = this.editTableDataWorkDay[1].FriWorkDay
        } else if (element.weekDay === '6') {
          element.workHour = this.editTableDataWorkDay[0].SatWorkHour
          element.workDay = this.editTableDataWorkDay[1].SatWorkDay
        } else if (element.weekDay === '7') {
          element.workHour = this.editTableDataWorkDay[0].SunWorkHour
          element.workDay = this.editTableDataWorkDay[1].SunWorkDay
        }
      })
      data.setCalendarExpList = this.editTableDataUnWorkDay
      if (this.isCopy) {
        data.setCalendarExpList.forEach(element => {
          element.id = ''
          element.calendarId = ''
        })
      }
      // console.log('数据', data)
      var check = true
      for (var i = 0; i < data.setCalendarDetList.length; i++) {
        if (data.setCalendarDetList[i].workHour === null || data.setCalendarDetList[i].workHour === '') {
          check = false
        }
      }
      if (data.setCalendarExpList.length !== 0) {
        for (var j = 0; j < data.setCalendarExpList.length; j++) {
          // console.log('**', data.setCalendarExpList[j].workDay)
          if (data.setCalendarExpList[j].exceptionName === '' || data.setCalendarExpList[j].exceptionName === null || data.setCalendarExpList[j].beginDate === '' || data.setCalendarExpList[j].beginDate === null || data.setCalendarExpList[j].endDate === '' || data.setCalendarExpList[j].endDate === null || data.setCalendarExpList[j].workDay === '' || data.setCalendarExpList[j].workDay === null || data.setCalendarExpList[j].workDay === undefined) {
            check = false
          }
        }
      }
      if (check) {
        this.$refs.editFormRef.validate((valid) => {
          if (valid) {
            var params = {
              id: data.id,
              calendarName: data.calendarName,
              tentantId: this.tentantId
            }
            console.log('检查', params)
            checkCalendar(params).then(async res => {
              console.log(res)
              if (res === false) {
                this.$message({
                  type: 'error',
                  message: '日历名不允许重复'
                })
              } else {
                await saveCalendar(data).then(res => {
                  if (res && res.state === 'success') {
                    this.$message({
                      type: 'success',
                      message: '保存成功'
                    })
                    this.addNewFlag = false
                    this.isCopy = false
                    this.searchTemplate()
                    this.showEdit = false
                    this.clear()
                  } else {
                    this.$message({
                      type: 'error',
                      message: res.msg
                    })
                  }
                })
              }
            })
          } else {
            return false
          }
        })
      } else {
        this.$message({
          type: 'info',
          message: '请填写完整模板信息'
        })
      }
    },
    clearName() {
      this.searchTemplate()
    },
    clear() {
      this.editTableDataWorkDay = [
        {
          name: '工作时长(小时)',
          MonWorkHour: '',
          TueWorkHour: '',
          WedWorkHour: '',
          ThuWorkHour: '',
          FriWorkHour: '',
          SatWorkHour: '',
          SunWorkHour: ''
        },
        {
          name: '工作日',
          MonWorkDay: '',
          TueWorkDay: '',
          WedWorkDay: '',
          ThuWorkDay: '',
          FriWorkDay: '',
          SatWorkDay: '',
          SunWorkDay: ''
        }
      ]
      this.editTableDataUnWorkDay = []
      this.editForm = {
        calendarName: '',
        createUserName: '',
        remark: '',
        createTime: ''
      }
      this.item = ''
      this.setCalendarDetList = []
      this.setCalendarExpList = []
    },
    back() {
      this.searchTemplate()
      this.clear()
      this.showEdit = false
    },
    setDefaultFuc(row) {
      this.$confirm('设为默认后，该模板会自动成为新增项目的默认日历模板，确定吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        row.isDefault = 0
        // console.log(row)
        setDefault(row).then(res => {
          console.log(res)
          if (res && res.code === '200') {
            this.searchTemplate()
            this.$message({
              type: 'success',
              message: '设置成功!'
            })
          } else {
            this.$message({
              type: 'error',
              message: '设置失败'
            })
          }
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消'
        })
      })
    },
    cancelDefaultFuc(row) {
      this.$confirm('取消默认，确定吗？', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        row.isDefault = 1
        // console.log(row)
        cancelDefault(row).then(res => {
          console.log(res)
          if (res && res.code === '200') {
            this.searchTemplate()
            this.$message({
              type: 'success',
              message: '取消默认成功!'
            })
          } else {
            this.$message({
              type: 'error',
              message: '取消默认失败'
            })
          }
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消'
        })
      })
    },
    deleteTempalate(row) {
      this.$confirm(`是否删除 "${row.calendarName}" ？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        deleteCalendar(row.id).then(res => {
          if (res && res.code === '200') {
            this.searchTemplate()
            this.$message({
              type: 'success',
              message: '删除成功!'
            })
          } else {
            this.$message({
              type: 'error',
              message: '删除失败'
            })
          }
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '已取消删除'
        })
      })
    },
    cancel() {
      this.clear()
      // this.searchTemplate()
      this.showEdit = false
    },
    addlist() {
      var len = this.editTableDataUnWorkDay.length
      this.editTableDataUnWorkDay.push({
        id: '',
        calendarId: '',
        exceptionName: '',
        beginDate: '',
        endDate: '',
        workDay: 0,
        sort: len + 1
      })
      // console.log(this.editTableDataUnWorkDay)
    },
    deletelist(index) {
      this.editTableDataUnWorkDay.splice(index, 1)
      for (var i = 0; i < this.editTableDataUnWorkDay.length; i++) {
        this.editTableDataUnWorkDay[i].sort = i + 1
      }
      // console.log(this.editTableDataUnWorkDay)
    },
    timepickEndTime(row) {
      console.log(row)
      var onetime = row.beginDate.split('-')
      var starttime = new Date(onetime[0], onetime[1], onetime[2])
      var starttimes = starttime.getTime()
      var twotime = row.endDate.split('-')
      var endTime = new Date(twotime[0], twotime[1], twotime[2])
      var endTimes = endTime.getTime()
      // 进行日期比较
      if (endTimes < starttimes) {
        this.$message({
          type: 'error',
          message: '结束日期不能小于开始日期'
        })
        row.endDate = ''
      }
    },
    resetForm(formName) {
      this.templateName = ''
      this.searchTemplate()
    }
  }
}
</script>

<style lang="scss" scoped>
.box {
  margin: 20px 15px 0 15px;
  height: 50px;
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
.infotable {
  width: 80%;
  margin-top:20px;
  margin-left:20px;
  text-align: center;
}
.el-input--small .el-input__inner{
  text-align: center;
}
.calendarbox {
  overflow: auto;
  min-width: 1200px;
}
</style>
