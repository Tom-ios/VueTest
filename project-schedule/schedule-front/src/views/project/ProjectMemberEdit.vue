<template>
  <div class="app-container">
    <el-form ref="form" label-width="100px">
      <el-card :body-style="{ padding: '0px' }" class="box-card">
        <div slot="header">
          <span>项目人员</span>
          <el-button style="float: right;margin-top:-6px" type="primary" @click="add">选择人员</el-button>
        </div>
        <d2-crud
          ref="d2Crud"
          :columns="columns"
          :index-row="indexRow"
          :row-handle="rowHandle"
          :data="data"
          @row-remove="handleRowRemove"
          @cell-data-change="handleCellDataChange"
        />
      </el-card>

      <el-row type="flex" class="box-card" justify="center">
        <el-button size="large" type="primary" :loading="submiting" @click="submit">保 存</el-button>
        <el-button size="large" @click="back">取 消</el-button>
      </el-row>
    </el-form>

    <SelectPerople ref="sel" :visible.sync="selVisible" sel-type="multiple" sel-range="excludeMe" :init-datas="data" @sure="handleSel" />
  </div>
</template>

<script>
import SelectPerople from '@/components/SelectPeople'
import { queryProjectUserList, addProjectUser, getRoleList } from '@/api/project'
export default {
  name: 'ProjectMemberEdit',
  components: {
    SelectPerople
  },
  data() {
    return {
      submiting: false,
      selVisible: false,
      indexRow: {
        title: '序号'
      },
      columns: [
        {
          title: '姓名',
          key: 'userName'
        },
        {
          title: '账号',
          key: 'userCode'
        },
        {
          title: '部门',
          key: 'orgName'
        },
        {
          title: '职位',
          key: 'jobName'
        },
        {
          title: '联系方式',
          key: 'mobilePhone'
        },
        {
          title: '角色',
          key: 'roleId',
          labelClassName: 'require',
          component: {
            render: function(h, scope) {
              const me = this
              function setValue(v) {
                scope.roleId = v
                scope.getData()[me.scope.$index]['roleId'] = v
              }
              if (scope.roleName === '项目经理') {
                return (
                  <span>项目经理</span>
                )
              } else {
                return (
                  <el-select multiple value={scope.roleId} onInput={setValue}>
                    {scope.options.map(item => {
                      return (
                        <el-option
                          key={item.id}
                          label={item.roleName}
                          value={item.id}>
                        </el-option>
                      )
                    })}
                  </el-select>
                )
              }
            },
            options: [
            ]
          }
        }
      ],
      data: [

      ],
      rowHandle: {
        width: '100px',
        remove: {
          icon: 'el-icon-delete',
          size: 'mini',
          fixed: 'right',
          confirm: true,
          show(index, row) {
            return row.roleName !== '项目经理'
          }
        }
      },
      options: []
    }
  },
  created() {
    getRoleList().then((res) => {
      this.options = res.data
      this.fetchData()
    })
  },
  methods: {
    handleCellDataChange({ rowIndex, key, value, row }) {
      this.data[rowIndex][key] = value
    },
    handleRowRemove({ index, row }, done) {
      this.data.splice(index, 1)
    },
    add() {
      this.selVisible = true
    },
    submit(selection) {
      this.submiting = true
      const list = JSON.parse(JSON.stringify(this.data))
      list.forEach(item => {
        item.userId = item.id
        item.projectId = this.$route.params.id
        item.roleId = item.roleId.toString()
      })
      const d = {}
      d.projectUserlist = list
      d.id = this.$route.params.id
      addProjectUser(d).then(() => {
        this.submiting = false
        this.back()
      }).catch(() => {
        this.submiting = false
      })
    },
    back() {
      this.$router.push(`/projectMember/list/${this.$route.params.id}`)
    },
    fetchData() {
      this.loading = true
      const query = {}
      query.pageSize = 9999
      query.pageIndex = 0
      query.projectId = this.$route.params.id
      const me = this
      queryProjectUserList(query).then(res => {
        this.data = res.rows
        this.data.forEach(item => {
          item.roleId = item.roleId.split(',')
          item.getData = function() {
            return me.data
          }
          item.options = this.options
        })
        this.loading = false
      })
    },
    handleSel(selection) {
      const me = this
      selection.forEach((row) => {
        row.roleId = [this.options[0].id]
        row.getData = function() {
          return me.data
        }
        row.options = this.options
        this.data.push(row)
      })
    }
  }
}
</script>

<style scoped>
</style>
