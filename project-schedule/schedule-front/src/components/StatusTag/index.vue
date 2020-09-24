<template>
  <div>
    <el-tag :type="type">{{ value }}</el-tag>
  </div>
</template>

<script>
export default {
  name: 'VueSpan',
  props: {
    value: {
      type: String,
      default: '',
      require: true
    },
    // 本行的所有数据，此字段不需要额外配置
    scope: {
      type: Object,
      default: function() { return null }
    },
    // 通过 component 中 props 字段传过来的数据，此字段需要先在 component 中配置
    myProps: {
      type: Object,
      default: function() { return null }
    }
  },
  computed: {
    type() {
      if (this.myProps) {
        return this.myProps[this.value]
      }
      return this.value === '正常' ? 'success' : 'danger'
    }
  },
  mounted() {
  },
  methods: {
  }
}
</script>
