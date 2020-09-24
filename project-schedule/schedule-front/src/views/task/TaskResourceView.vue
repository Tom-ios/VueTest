<template>
  <d2-crud
    id="taskResourceGrid"
    ref="d2Crud"
    :options="options"
    :index-row="indexRow"
    :columns="columns"
    :data="data"
    :loading="loading"
    :pagination="pagination"
    @keyup.enter.native="fetchData"
    @pagination-current-change="paginationCurrentChange"
  />
</template>

<script>
export default {
  name: 'TaskResource',
  components: {},
  props: {},
  data() {
    return {
      options: {
        border: true
      },
      loading: false,
      data: [
        {
          code: 'dm-2012',
          name: '技工',
          type: '人力',
          unit: '天'
        }
      ],
      pagination: {
        currentPage: 1,
        pageSize: 20,
        total: 1
      },
      indexRow: {
        title: '序号',
        width: '50'
      },
      columns: [
        {
          title: '资源代码',
          key: 'code'
        },
        {
          title: '资源名称',
          key: 'name'
        },
        {
          title: '资源类型',
          key: 'type'
        },
        {
          title: '单位',
          key: 'unit'
        }
      ]
    }
  },
  computed: {},
  created() {},
  methods: {
    paginationCurrentChange(currentPage) {
      this.pagination.currentPage = currentPage
    }
  }
}
</script>
