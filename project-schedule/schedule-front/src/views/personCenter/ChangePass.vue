<template>
  <el-dialog
    title="修改密码"
    :visible.sync="dialogVisible"
    width="350px"
    :close-on-click-modal="false"
    @closed="ruleForm = {
      pass: '',
      checkPass: '',
      newpass: ''
    }"
  >
    <el-form ref="ruleForm" :model="ruleForm" :rules="rules" label-width="100px">
      <el-form-item label="当前密码" prop="pass">
        <el-input v-model="ruleForm.pass" type="password" />
      </el-form-item>
      <el-form-item label="新密码" prop="newpass">
        <el-input v-model="ruleForm.newpass" type="password" />
      </el-form-item>
      <el-form-item label="确认密码" prop="checkPass">
        <el-input v-model="ruleForm.checkPass" type="password" />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" :loading="submiting" @click="submitForm('ruleForm')">确定</el-button>
        <el-button @click="dialogVisible = false">取消</el-button>
      </el-form-item>
    </el-form>
  </el-dialog>
</template>

<script>
import { updatepasswd } from '@/api/user'
export default {
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    userCode: {
      type: String,
      default: ''
    }
  },
  data() {
    var pass = (rule, value, callback) => {
      if (value === '') {
        return callback(new Error('密码不能为空'))
      }
      callback()
    }
    var validatePass = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请输入新密码'))
      } else if (value.length < 6) {
        callback(new Error('不能小于6位'))
      } else if (value.length > 16) {
        callback(new Error('不能大于16位'))
      } else {
        if (this.ruleForm.checkPass !== '') {
          this.$refs.ruleForm.validateField('checkPass')
        }
        callback()
      }
    }
    var validatePass2 = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'))
      } else if (value !== this.ruleForm.newpass) {
        callback(new Error('两次输入密码不一致!'))
      } else {
        callback()
      }
    }
    return {
      ruleForm: {
        pass: '',
        checkPass: '',
        newpass: ''
      },
      rules: {
        newpass: [
          { required: true, validator: validatePass, trigger: 'blur' }
        ],
        checkPass: [
          { required: true, validator: validatePass2, trigger: 'blur' }
        ],
        pass: [
          { required: true, validator: pass, trigger: 'blur' }
        ]
      },
      dialogVisible: false,
      submiting: false
    }
  },
  watch: {
    dialogVisible(v) {
      this.$emit('update:visible', v)
    },
    visible(v) {
      this.dialogVisible = v
    }
  },
  methods: {
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.submiting = true
          updatepasswd({ 'userCode': this.userCode, 'oldUserPasswd': this.ruleForm.pass, 'newUserPasswd': this.ruleForm.newpass, 'isReset': false }).then(() => {
            this.$message({
              type: 'success',
              message: '修改成功!'
            })
            this.dialogVisible = false
          }).finally(() => {
            this.submiting = false
          })
        } else {
          console.log('error submit!!')
          return false
        }
      })
    }
  }
}
</script>

<style>

</style>
