<template>
  <el-dialog
    class="select-dialog"
    title="选择人员"
    :visible.sync="winVisible"
    width="800px"
    @open="handelOpen"
  >
    <Account
      ref="account"
      :columns="columns"
      :row-handle="null"
      :sel-type="selType"
      :url="url"
      :is-fweb="isFweb"
      :sel-range="selRange"
      :init-datas="initDatas"
      :b-add-account="addAccount"
      :b-project-select="bProjectSelect"
      :url-param="urlParam"
    />

    <span slot="footer">
      <el-button @click="winVisible = false">取 消</el-button>
      <el-button type="primary" @click="sure">确 定</el-button>
    </span>
  </el-dialog>

</template>

<script>
import Account from '@/views/account'
export default {
  name: 'SelectPeople',
  components: {
    Account
  },
  props: {
    isFweb: {
      type: Boolean,
      default: false
    },
    visible: {
      type: Boolean,
      default: false
    },
    selType: {
      type: String,
      default: 'single'
    },
    selRange: {
      type: String,
      default: ''
    },
    initDatas: {
      type: Array,
      default: function() { return [] }
    },
    addAccount: {
      type: Boolean,
      default: true
    },
    bProjectSelect: {
      type: Boolean,
      default: false
    },
    url: {
      type: String,
      default: ''
    },
    urlParam: {
      type: Object,
      default: function() { return null }
    }
  },
  data() {
    return {
      winVisible: false,
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
        }
      ]
    }
  },
  watch: {
    winVisible(v) {
      this.$emit('update:visible', v)

      if (!v && this.selType === 'multiple') {
        this.cancelSel()
      }
    },
    visible(v) {
      this.winVisible = v
    }
  },
  methods: {
    cancelSel() {
      this.$refs.account.cancelSel()
    },
    sure() {
      if (this.$refs.account.sel.length > 0) {
        const arr = this.$refs.account.sel
        if (this.selType !== 'multiple' && this.selType !== 'single') {
          for (var i = 0; i < arr.length; i++) {
            for (const item of this.initDatas) {
              if (arr[i].userId === item.id) {
                arr.splice(i, 1)
                i--
                break
              }
            }
          }
        }
        this.$emit('sure', arr)
      } else {
        this.$emit('sure', [])
      }

      this.winVisible = false
    },
    handelOpen() {
      /* if (this.$refs.account) {
        this.$refs.account.fetchData()
      } */
      // edit by cjcui 解决第一次打开无法加载列表数据
      this.$nextTick(() => {
        this.$refs.account.fetchData()
      })
    }
  }
}
</script>

<style>
.select-dialog .el-dialog__body{
  padding: 10px 20px
}
</style>
