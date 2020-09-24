<template>
  <div class="app-container">
    <el-form label-width="180px">
      <el-row>
        <el-col :span="12">
          <el-form-item label="企业编号：">
            <span>{{ info.tentantNo }}</span>
          </el-form-item>
        </el-col>
        <el-col :span="12">
          <el-form-item label="企业名称：">
            <span>{{ info.tentantName }}</span>
          </el-form-item>
        </el-col>
      </el-row>
    </el-form>

    <el-tabs v-model="activeName" type="card" @tab-click="handleClick">
      <el-tab-pane label="人员信息" name="member">
        <d2-crud
          :columns="columnsMember"
          :index-row="indexRow"
          :row-handle="rowHandle"
          :loading="loading"
          :pagination="pagination"
          :data="dataMember"
          @setDev="setDev"
          @cancelDev="cancelDev"
        >
          <el-form
            slot="header"
            :inline="true"
            :model="queryMember"
            size="mini"
          >
            <el-form-item label="姓名">
              <el-input
                v-model="queryMember.name"
                placeholder=""
                style="width: 120px;"
              />
            </el-form-item>
            <el-form-item label="账号">
              <el-input
                v-model="queryMember.account"
                placeholder=""
                style="width: 120px;"
              />
            </el-form-item>
            <el-form-item>
              <el-button
                type="primary"
                @click="fetchData"
              >
                查询
              </el-button>
            </el-form-item>
          </el-form>
        </d2-crud>
      </el-tab-pane>
      <el-tab-pane label="项目信息" name="project">
        <d2-crud
          :columns="columnsProject"
          :index-row="indexRow"
          :pagination="pagination"
          :data="dataProject"
        >
          <el-form
            slot="header"
            :inline="true"
            :model="queryProject"
            size="mini"
          >
            <el-form-item label="项目编号">
              <el-input
                v-model="queryMember.name"
                placeholder=""
                style="width: 120px;"
              />
            </el-form-item>
            <el-form-item label="项目名称">
              <el-input
                v-model="queryMember.account"
                placeholder=""
                style="width: 120px;"
              />
            </el-form-item>
            <el-form-item>
              <el-button
                type="primary"
                @click="fetchData"
              >
                查询
              </el-button>
            </el-form-item>
            <el-row>
              <el-col :span="6" :offset="6">
                <el-form-item label="项目总数：">
                  2
                </el-form-item>
              </el-col>
              <el-col :span="12">
                <el-form-item label="模型总数：">
                  35
                </el-form-item>
              </el-col>
            </el-row>
          </el-form>
        </d2-crud>
      </el-tab-pane>
    </el-tabs>
  </div>
</template>
<script>
import StatusTag from '@/components/StatusTag'
import { getInfo } from '@/api/tentant'
export default {
  name: 'CompanyDetail',
  components: {
    // eslint-disable-next-line
    StatusTag
  },
  data() {
    return {
      activeName: 'member',
      loading: false,
      indexRow: {
        title: '序号'
      },
      queryMember: {},
      queryProject: {},
      columnsMember: [
        {
          title: '姓名',
          key: 'name'
        },
        {
          title: '账号',
          key: 'account'
        },
        {
          title: '角色',
          key: 'role'
        },
        {
          title: '部门',
          key: 'org'
        },
        {
          title: '职位',
          key: 'duty'
        },
        {
          title: '联系方式',
          key: 'mobile'
        },
        {
          title: '创建人',
          key: 'createUser'
        },
        {
          title: '创建时间',
          key: 'createTime'
        },
        {
          title: '账号状态',
          key: 'status',
          component: {
            name: StatusTag
          }
        }
      ],
      dataMember: [

      ],
      dataProject: [
        {
          name: '红寺堡一泵站整合模型.IFC',
          code: '201906-BD-1S-0002 ',
          modelCount: '22',
          isOver: '是'
        },
        {
          name: '红寺堡一泵站整合模型.IFC',
          code: '201906-BD-1S-0001 ',
          modelCount: '32',
          isOver: '否'
        }
      ],
      rowHandle: {
        width: '180px',
        custom: [
          {
            text: '设置为开发者',
            emit: 'setDev'
          },
          {
            text: '取消开发者身份',
            emit: 'cancelDev'
          }
        ]
      },
      columnsProject: [
        {
          title: '项目编号',
          key: 'code'
        },
        {
          title: '项目名称',
          key: 'name'
        },
        {
          title: '模型数量',
          key: 'modelCount'
        },
        {
          title: '是否结项',
          key: 'isOver',
          component: {
            name: StatusTag,
            props: {
              myProps: {
                '是': 'danger',
                '否': 'success'
              }
            }
          }
        }
      ],
      pagination: {
        currentPage: 1,
        pageSize: 20,
        total: 0
      },
      info: {}
    }
  },
  created() {
    this.fetchData()
  },
  methods: {
    handleClick(tab, event) {
      // console.log(tab, event)
    },
    setDev() {

    },
    cancelDev() {

    },
    fetchData() {
      getInfo(this.$route.params.id).then(res => {
        this.info = res
        this.loading = false
      })
    }
  }
}
</script>
