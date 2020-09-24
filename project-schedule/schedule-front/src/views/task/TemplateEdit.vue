<template>
  <div>
    <el-card>
      <div slot="header">
        <span>基本信息</span>
      </div>
      <el-form ref="form" :model="data.templateForm" label-width="auto" size="small" label-suffix="">
        <el-row>
          <el-col :xl="8" :lg="8" :md="8" :sm="12" :xs="24">
            <el-form-item label="模板名称：">
              <template v-if="$route.query.isEdit">
                <span>{{ data.templateForm.tempName }}</span>
              </template>
              <el-input v-else v-model.trim="data.templateForm.tempName" maxlength="20" />
            </el-form-item>
          </el-col>
          <el-col :xl="8" :lg="8" :md="8" :sm="12" :xs="24">
            <el-form-item label="创建人：">
              <span>{{ data.templateForm.createUser }}</span>
            </el-form-item>
          </el-col>
          <el-col :xl="8" :lg="8" :md="8" :sm="12" :xs="24">
            <el-form-item label="创建时间：">
              <span>{{ data.templateForm.createTime }}</span>
            </el-form-item>
          </el-col>
        </el-row>
        <el-row>
          <el-col :xl="24" :lg="24" :md="24" :sm="24" :xs="24">
            <el-form-item label="备注：">
              <template v-if="$route.query.isEdit">
                <span>{{ data.templateForm.remark }}</span>
              </template>
              <el-input v-else v-model.trim="data.templateForm.createUser" maxlength="20" type="textarea" resize="none" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
    </el-card>
    <el-card>
      <div slot="header">
        <span>作业步骤信息</span>
      </div>
      <el-form
        ref="form"
        :inline="true"
        size="mini"
        @keyup.enter.native="fetchData"
      >
        <el-form-item label="项目编号">
          <el-input
            placeholder=""
          />
        </el-form-item>
        <el-form-item label="项目名称">
          <el-input
            placeholder=""
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
        <el-form-item style="float: right">
          <el-button
            type="primary"
          >
            创建项目
          </el-button>
        </el-form-item>
      </el-form>
      <div ref="tablewrap" class="table-wrap">
        <div class="table-header">
          <el-tooltip effect="dark" content="向前添加" placement="top">
            <el-button icon="el-icon-plus" size="mini" circle />
          </el-tooltip>
          <el-tooltip effect="dark" content="向后添加" placement="top">
            <el-button icon="el-icon-edit" size="mini" circle />
          </el-tooltip>
          <el-tooltip effect="dark" content="上移" placement="top">
            <el-button icon="el-icon-top" size="mini" circle />
          </el-tooltip>
          <el-tooltip effect="dark" content="下移" placement="top">
            <el-button icon="el-icon-bottom" size="mini" circle />
          </el-tooltip>
          <div class="buttons-right">
            <el-button type="text" size="mini" icon="el-icon-plus">保存
            </el-button>
          </div>
        </div>
        <el-table ref="table" border size="mini" style="margin-top:10px;">
          <el-table-column label="序号" type="index" />
          <el-table-column label="名称" prop="tempName" />
          <el-table-column label="编码" prop="remark" />
          <el-table-column label="作业类型" prop="createUser" />
          <el-table-column label="进度计算方式" prop="createTime" />
          <el-table-column label="权重比例" prop="updateUser" />
          <el-table-column label="费用科目编码" prop="updateTime" />
          <el-table-column label="费用科目" prop="updateTime" />
          <el-table-column label="操作">
            <template>
              <el-link type="primary">编辑</el-link>
              <el-link type="primary">复制增加</el-link>
              <el-link type="primary">删除</el-link>
            </template>
          </el-table-column>
        </el-table>
        <el-pagination
          v-bind="pagination"
          class="table-pages"
          background
          @size-change="handleSizeChange"
          @current-change="paginationCurrentChange"
        />
      </div>
    </el-card>
  </div>
</template>

<script>
export default {
  name: 'TaskTemplateEdit',
  components: {
  },
  props: {
  },
  data() {
    return {
      data: {
        templateForm: {

        }
      },
      pagination: {
        currentPage: 1,
        pageSize: 10,
        total: 0,
        pageSizes: [10, 20, 50, 100],
        layout: 'total, sizes, prev, pager, next, jumper'
      }

    }
  },
  computed: {},
  mounted() {
  },
  created() {
  },
  methods: {
    fetchData() {

    },
    handleSizeChange(val) {
      this.pagination.pageSize = val
      this.fetchData()
    },
    paginationCurrentChange(currentPage) {
      this.pagination.currentPage = currentPage
      this.fetchData()
    }
  }
}
</script>

<style>
</style>
