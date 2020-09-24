<template>
  <div class="login-container">
    <!-- <a href="./static/docs/index.html" target="_blank" class="devUrl">
      开发者中心
    </a> -->
    <div class="loginHead">
      <img src="/img/global.png" class="login-logo">
      <span class="loginTitle"> 基建项目施工管理系统 </span>
    </div>
    <div class="clearfix" style="height:100%">
      <img src="/img/leftPic.jpg" class="login-leftpic">
      <div class="login-form">
        <div class="title-container">
          <div class="title">用户登录</div>
        </div>

        <el-form ref="loginForm" :model="loginForm" :rules="loginRules" auto-complete="on" label-position="left">
          <el-form-item prop="username" class="form-item">
            <span class="svg-container">
              <svg-icon icon-class="user" />
            </span>
            <el-input
              ref="username"
              v-model="loginForm.username"
              placeholder="用户名"
              name="username"
              type="text"
              tabindex="1"
              auto-complete="on"
              @keyup.enter.native="handleLogin"
            />
          </el-form-item>

          <el-form-item prop="password" class="form-item">
            <span class="svg-container">
              <svg-icon icon-class="password" />
            </span>
            <el-input
              :key="passwordType"
              ref="password"
              v-model="loginForm.password"
              :type="passwordType"
              placeholder="密码"
              name="password"
              tabindex="2"
              auto-complete="on"
              @keyup.enter.native="handleLogin"
            />
            <span class="show-pwd" @click="showPwd">
              <svg-icon :icon-class="passwordType === 'password' ? 'eye' : 'eye-open'" />
            </span>
          </el-form-item>
          <el-checkbox v-model="rememberUser" label="记住密码" style="margin-left:20px;margin-bottom:20px" />
          <el-button :loading="loading" type="primary" size="medium" style="margin-left:20px;width:280px;margin-bottom:30px;" @click.native.prevent="handleLogin">登录</el-button>
        </el-form>
        <div class="image-border image-border1" />
        <div class="image-border image-border2" />
        <div class="image-border image-border3" />
        <div class="image-border image-border4" />

      </div>
    </div>
  </div>
</template>

<script>
// import { validUsername } from '@/utils/validate'
export default {
  name: 'Login',
  data() {
    // const validateUsername = (rule, value, callback) => {
    //   if (!validUsername(value)) {
    //     callback(new Error('请输入正确的用户名'))
    //   } else {
    //     callback()
    //   }
    // }
    const validatePassword = (rule, value, callback) => {
      if (value.length < 6) {
        callback(new Error('密码至少6位'))
      } else {
        callback()
      }
    }
    return {
      loginForm: {
        username: '',
        password: ''
      },
      loginRules: {
        username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
        password: [{ required: true, message: '请输入密码', trigger: 'blur', validator: validatePassword }]
      },
      loading: false,
      passwordType: 'password',
      redirect: undefined,
      rememberUser: true
    }
  },
  watch: {
    $route: {
      handler: function(route) {
        this.redirect = route.query && route.query.redirect
      },
      immediate: true
    }
  },
  mounted() {
    this.loginForm.username = localStorage.getItem('username')
    this.loginForm.password = localStorage.getItem('password')
    this.$refs.username.focus()
  },
  methods: {
    showPwd() {
      if (this.passwordType === 'password') {
        this.passwordType = ''
      } else {
        this.passwordType = 'password'
      }
      this.$nextTick(() => {
        this.$refs.password.focus()
      })
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          this.$store.dispatch('user/login', this.loginForm).then(() => {
            if (this.rememberUser) {
              localStorage.setItem('username', this.loginForm.username)
              localStorage.setItem('password', this.loginForm.password)
            } else {
              localStorage.removeItem('username')
              localStorage.removeItem('password')
            }
            this.$router.push({ path: this.redirect || '/' })
            this.loading = false
          }).catch(() => {
            this.loading = false
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

<style lang="scss" scoped>
/* 修复input 背景不协调 和光标变色 */
/* Detail see https://github.com/PanJiaChen/vue-element-admin/pull/927 */

$bg:#283443;
$light_gray:#fff;
$cursor: #fff;

@supports (-webkit-mask: none) and (not (cater-color: $cursor)) {
  .login-container .el-input input {
    color: $cursor;
  }
}
/deep/.el-form-item--small .el-form-item__content, .el-form-item--small .el-form-item__label {
    line-height: 32px;
    background: #0054a2
}
.login-container {
 /deep/ .el-input {
    display: inline-block;
    height: 26px;
    width: 85%;

   /deep/ input {
      background: #0054a2;
      border: 0px;
      -webkit-appearance: none;
      border-radius: 0px;
      padding: 12px 5px 12px 15px;
      color: $light_gray;
      height: 26px;
      caret-color: $cursor;

      &:-webkit-autofill {
        box-shadow: 0 0 0px 1000px #0054a2 inset !important;
        -webkit-text-fill-color: $cursor !important;
      }
    }
  }
/deep/ .el-checkbox {
    color: white;
    font-weight: 500;
    font-size: 12px;
    cursor: pointer;
    -webkit-user-select: none;
    -moz-user-select: none;
    -ms-user-select: none;
    user-select: none;
    margin-right: 30px;
}
/deep/ .el-checkbox__label {
    display: inline-block;
    padding-left: 10px;
    line-height: 19px;
    font-size: 13px;
    }
 /deep/.el-form-item {
    border: 1px solid #007cc3;
    background-color:#0054a2;
    border-radius: 2px;
    color: #454545;
  }
}
</style>

<style lang="scss" scoped>
$bg:#2d3a4b;
$dark_gray:#889aa4;
$light_gray:#eee;

.devUrl {
  right: 20px;
  position: absolute;
  top: 20px;
  color: $bg;
  font-weight: bold;
}

.login-container {
  min-height: 100%;
  width: 100%;
  background-color: $bg;
  overflow: hidden;
  background-image: url('/img/background.jpg');
  background-size:cover;
}
  .tips {
    font-size: 14px;
    color: #fff;
    margin-bottom: 10px;

    span {
      &:first-of-type {
        margin-right: 16px;
      }
    }
  }

  .svg-container {
    padding: 0px 5px 0px 15px;
    color: $dark_gray;
    vertical-align: middle;
    width: 30px;
    display: inline-block;
  }

  .title-container {
    position: relative;

    .title {
      font-size: 14px;
      color: white;
      margin-top:30px;
      text-align: center;
      font-weight: bold;
    }
  }

  .show-pwd {
    position: absolute;
    right: 10px;
    top: 1px;
    font-size: 16px;
    color: $dark_gray;
    cursor: pointer;
    user-select: none;
  }
  .loginHead{
    border-bottom: 2px solid #003c80;
    background:#00468d;
    height:50px;
  }
  .login-logo{
      margin-left:15px;
      margin-top:9px;
      width: 32px;
      height: 32px;
  }
  .login-form {
    position: absolute;
    width: 320px;
    right:calc(50% - 400px);
    bottom:calc(50% - 150px);
    overflow: hidden;
    background-color: #004f8d;
    .form-item{
      background-color: #283443;
      width:280px;
      margin-left:20px;
      margin-top:20px;
    }
  }

  .login-leftpic{
    position: absolute;
    left: calc(50% - 460px);
    bottom:calc(50% - 190px);
    width: 380px;
    height: 380px;
  }
  .loginTitle {
    color: white;
    position: relative;
    top: -10px;
    font-size: 14px;
  }
  .image-border {
	position: absolute;
	width: 10px;
	height: 10px;
}

.image-border1 {
	top: 0;
	left: 0;
	border-left: 1px solid #007cc3;
	border-top: 1px solid #007cc3;
}

.image-border2 {
	top: 0;
	right: 0px;
	border-right: 1px solid #007cc3;
	border-top: 1px solid #007cc3;
}

.image-border3 {
	bottom: 0;
	left: 0;
	border-bottom: 1px solid #007cc3;
	border-left: 1px solid #007cc3;
}

.image-border4 {
	bottom: 0;
	right: 0px;
	border-right: 1px solid #007cc3;
	border-bottom: 1px solid #007cc3;
}
</style>
