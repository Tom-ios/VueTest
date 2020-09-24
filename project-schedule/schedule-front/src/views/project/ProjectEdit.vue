<template>
  <div class="editPage app-container">
    <el-form ref="form" label-width="100px" :rules="rules" :model="formData">
      <el-card class="box-card">
        <div slot="header" class="clearfix">
          <span>项目基本信息</span>
        </div>
        <div>
          <el-row>
            <el-col :span="12">
              <el-form-item label="项目名称：" prop="projectName">
                <el-input v-model="formData.projectName" maxlength="50" />
              </el-form-item>
              <el-form-item label="项目编号：" prop="projectNo">
                <el-input v-model="formData.projectNo" />
              </el-form-item>
              <el-form-item label="立项时间：" prop="projectDate">
                <el-date-picker v-model="formData.projectDate" type="date" placeholder="选择日期" value-format="yyyy-MM-dd" style="width: 100%;" />
              </el-form-item>
              <el-form-item label="项目经理：" prop="projectManager">
                <div @click="selPeople">
                  <el-input v-model="formData.projectManagerName" :readonly="true" />
                </div>
              </el-form-item>
              <el-form-item label="联系方式：">
                {{ formData.projectManagerTel }}
              </el-form-item>
            </el-col>
            <el-col :span="12">
              <el-form-item label="项目图片 ：">
                <!-- <el-image src="https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png" ></el-image> -->
                <el-upload
                  class="avatar-uploader"
                  :action="baseURL"
                  :show-file-list="false"
                  :on-success="handleAvatarSuccess"
                  :on-error="handleError"
                  name="file[]"
                >
                  <el-image v-if="formData.projectImg" :src="formData.projectImg" class="avatar" fit="cover" />
                  <i v-else class="el-icon-plus avatar-uploader-icon" />
                </el-upload>
              </el-form-item>
            </el-col>
          </el-row>
        </div>
      </el-card>

      <el-card :body-style="{ padding: '0px' }" class="box-card">
        <div slot="header">
          <span>自定义项目属性</span>
          <el-button style="float: right;margin-top:-6px" type="primary" @click="add">增加属性</el-button>
        </div>
        <el-table :data="formData.list">
          <el-table-column
            label="序号"
            type="index"
            width="50"
          />
          <el-table-column label="属性名称" label-class-name="require">
            <template slot-scope="scope">
              <el-form-item
                label-width="0px"
                :prop="'list.'+scope.$index+'.projectKey'"
                :rules="[
                  {required: true, message: '不能为空', trigger: 'blur'},
                  {max: 20, message: '限20字', trigger: 'blur'}
                ]"
              >
                <el-input v-model="scope.row.projectKey" />
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="属性值" label-class-name="require">
            <template slot-scope="scope">
              <el-form-item
                label-width="0px"
                :prop="'list.'+scope.$index+'.projectValue'"
                :rules="[
                  {required: true, message: '不能为空', trigger: 'blur'},
                  {max: 500, message: '限500字', trigger: 'blur'}
                ]"
              >
                <el-input v-model="scope.row.projectValue" />
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="占比" width="100px">
            <template slot-scope="scope">
              <el-form-item label-width="0px" :prop="'list.'+scope.$index+'.ratio'">
                <el-select v-model="scope.row.ratio">
                  <el-option
                    v-for="item in options"
                    :key="item.value"
                    :label="item.label"
                    :value="item.value"
                  />
                </el-select>
              </el-form-item>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="280px">
            <template slot-scope="scope">
              <el-button v-if="scope.$index !== 0" icon="el-icon-top" @click="up(scope.$index)">上移</el-button>
              <el-button v-if="scope.$index !== formData.list.length - 1" icon="el-icon-bottom" @click="down(scope.$index)">下移</el-button>
              <el-button icon="el-icon-delete" type="danger" @click="del(scope.$index)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-card>

      <el-row type="flex" class="box-card" justify="center">
        <el-button size="large" type="primary" :loading="submiting" @click="submitForm('form')">保 存</el-button>
        <el-button size="large" @click="back">取 消</el-button>
      </el-row>
    </el-form>

    <SelectPerople ref="sel" :visible.sync="selVisible" sel-type="single" :init-datas="formData.projectManager?[formData.projectManager]:[]" @sure="handleSel" />
  </div>
</template>

<script>
import { mapGetters } from 'vuex'
import SelectPerople from '@/components/SelectPeople'
import { add, detail, edit } from '@/api/project'
export default {
  name: 'ProjectEdit',
  components: {
    SelectPerople
  },
  data() {
    return {
      submiting: false,
      selVisible: false,
      formData: { projectImg: '', list: [], projectManager: '', projectManagerName: '' },
      rules: {
        projectName: [
          { required: true, message: '请输入项目名称', trigger: 'blur' },
          { max: 100, message: '限100字', trigger: 'blur' }
        ],
        projectNo: [
          { required: true, message: '请输入项目编号', trigger: 'blur' },
          { max: 30, message: '限30字', trigger: 'blur' }
        ],
        projectDate: [
          { required: true, message: '请选择日期', trigger: 'change' }
        ],
        projectManager: [
          { required: true, message: '请选择项目经理', trigger: 'change' }
        ]
      },
      baseURL: process.env.VUE_APP_BASE_FILE_URL + '/fileservice/fileext?token=' + this.filetoken,
      options: [
        {
          value: '1/2',
          label: '1/2'
        },
        {
          value: '1',
          label: '1'
        }
      ]
    }
  },
  computed: {
    ...mapGetters([
      'filetoken'
    ])
  },
  created() {
    if (this.$route.params.id) {
      detail(this.$route.params.id).then(res => {
        this.formData = res
      })
    }
  },
  methods: {
    handleError() {
      this.formData.imageUrl = 'https://shadow.elemecdn.com/app/element/hamburger.9cf7b091-55e9-11e9-a976-7f4d0b07eef6.png'
    },
    handleAvatarSuccess(res) {
      this.formData.projectImg = process.env.VUE_APP_BASE_FILE_URL + '/fileservice/fileext/' + res[0].id
    },
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          let i = 0
          this.formData.list.forEach((item) => {
            item.sort = i
            i++
          })
          this.submiting = true
          if (this.formData.id) {
            edit(this.formData).then((rep) => {
              this.back()
            }).catch((err) => {
              console.error(err)
            }).finally(() => {
              this.submiting = false
            })
          } else {
            add(this.formData).then((rep) => {
              this.back()
            }).catch((err) => {
              console.error(err)
            }).finally(() => {
              this.submiting = false
            })
          }
        } else {
          console.log('error submit!!')
          return false
        }
      })
    },
    resetForm(formName) {
      this.$refs[formName].resetFields()
    },
    handleCellDataChange({ rowIndex, key, value, row }) {
      console.log(rowIndex)
      console.log(key)
      console.log(value)
      console.log(row)
    },
    add() {
      this.formData.list.push({
        projectKey: '',
        projectValue: '',
        ratio: '1/2'
      })
    },
    up(index) {
      const temp = this.formData.list[index]
      this.$set(this.formData.list, index, this.formData.list[index - 1])
      this.$set(this.formData.list, index - 1, temp)
    },
    down(index) {
      const temp = this.formData.list[index]
      this.$set(this.formData.list, index, this.formData.list[index + 1])
      this.$set(this.formData.list, index + 1, temp)
    },
    del(index) {
      this.formData.list.splice(index, 1)
    },
    back() {
      this.$router.push('/project/list')
    },
    selPeople() {
      this.selVisible = true
    },
    handleSel(sel) {
      this.formData.projectManager = sel[0].id
      this.formData.projectManagerName = sel[0].userName
      this.formData.projectManagerTel = sel[0].mobilePhone
    }
  }
}
</script>
<style>
.avatar-uploader .el-upload {
  border: 1px dashed #d9d9d9;
  border-radius: 6px;
  cursor: pointer;
  position: relative;
  overflow: hidden;
}
.avatar-uploader .el-upload:hover {
  border-color: #409EFF;
}
.avatar-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 178px;
  height: 178px;
  line-height: 178px;
  text-align: center;
}
.avatar {
  width: 178px;
  height: 178px;
  display: block;
}

.editPage .el-form-item--mini.el-form-item, .editPage .el-form-item--small.el-form-item {
  margin-top: 18px
}
</style>
