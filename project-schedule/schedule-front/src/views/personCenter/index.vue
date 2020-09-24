<template>
  <div class="app-container">
    <el-form ref="form" label-width="100px" :rules="rules" :model="editInfo" :show-message="bEdit">
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span>基本信息</span>
          <div style="float: right; padding: 0px 0">
            <el-button v-if="!bEdit" style="padding: 0px 0" size="medium" type="text" @click="edit">编辑</el-button>
            <el-button v-if="!bEdit" style="padding: 0px 0" size="medium" type="text" @click="changePass">修改密码</el-button>
            <el-button v-if="bEdit" style="padding: 0px 0" size="medium" type="text" @click="save">保存</el-button>
            <el-button v-if="bEdit" style="padding: 0px 0" size="medium" type="text" @click="cancel">取消</el-button>
          </div>
        </div>
        <div>
          <el-row>
            <el-col :span="24">
              <el-form-item label="姓名：" prop="userName">
                <span v-if="!bEdit">{{ info.userName }}</span>
                <el-input v-else v-model="editInfo.userName" placeholder="" />
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="账号：">
                <span>{{ info.userCode }}</span>
              </el-form-item>
            </el-col>
            <el-col :span="24">
              <el-form-item label="联系方式：" prop="mobilePhone">
                <span v-if="!bEdit">{{ info.mobilePhone }}</span>
                <el-input v-else v-model="editInfo.mobilePhone" placeholder="" />
              </el-form-item>
            </el-col>
          </el-row>
        </div>
      </el-card>

      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span>部门信息</span>
        </div>
        <div>
          <el-row>
            <el-col :span="12">
              <el-form-item label="部门：">
                <span>{{ info.orgName }}</span>
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="职位：">
                <span>{{ info.jobName }}</span>
              </el-form-item>
            </el-col>
          </el-row>
        </div>
      </el-card>
    </el-form>
    <ChangePass :visible.sync="passVisible" :user-code="info.userCode" />
  </div>
</template>

<script>
import { getUserInfo } from '@/api/user'
import { add } from '@/api/account'
import { mapGetters } from 'vuex'
import ChangePass from './ChangePass'
export default {
  name: 'PersonCenter',
  components: {
    ChangePass
  },
  data() {
    return {
      info: {},
      editInfo: {},
      bEdit: false,
      formrules: {
        userName: [
          { required: true, message: '请输入姓名', trigger: 'blur' },
          { max: 20, message: '限20字', trigger: 'blur' }
        ],
        mobilePhone: [
          { required: true, message: '请输入联系方式', trigger: 'blur' },
          { max: 50, message: '限50字', trigger: 'blur' }
        ]
      },
      passVisible: false
    }
  },
  computed: {
    ...mapGetters([
      'userId'
    ]),
    rules() {
      return this.bEdit ? this.formrules : {}
    }
  },
  created() {
    getUserInfo(this.userId).then(res => {
      this.info = res
    })
  },
  methods: {
    changePass() {
      this.passVisible = true
    },
    save() {
      this.$refs.form.validate(valid => {
        if (valid) {
          add(this.editInfo).then(res => {
            this.info = this.editInfo
            this.bEdit = false
          })
        }
      })
    },
    cancel() {
      this.bEdit = false
    },
    edit() {
      this.bEdit = true
      this.editInfo = JSON.parse(JSON.stringify(this.info))
    }
  }
}
</script>

<style>

</style>
