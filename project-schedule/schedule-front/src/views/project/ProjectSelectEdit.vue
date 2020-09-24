<template>
  <DragResizeWindow
    :title="tilte"
    :visible.sync="winVisible"
    :w="350"
    :h="260"
    :x="x"
    :y="y"
    :center="true"
    element-loading-text=""
    element-loading-spinner="a"
    element-loading-background="rgba(255, 255, 255, 0.8)"
  >
    <el-form ref="form" :model="formData" label-width="80px" :rules="rules">
      <el-form-item label="名称" prop="groupFigureName">
        <el-input v-model="formData.groupFigureName" />
      </el-form-item>
      <el-form-item label="描述" prop="groupFigureDescription">
        <el-input v-model="formData.groupFigureDescription" />
      </el-form-item>
      <el-form-item v-if="flag==='create'">
        <span style="margin-left:-40px;font-size:12px;color:rgba(130, 124, 125, 1)">说明：保存后，选择集中将包含当前选中的图元 </span>
      </el-form-item>
      <el-form-item v-if="flag==='edit'" label="更新图元" prop="isUpdate">
        <el-radio v-model="formData.isUpdate" label="1">是</el-radio>
        <el-radio v-model="formData.isUpdate" label="0">否</el-radio>
      </el-form-item>
      <el-form-item style="margin-left:50px">
        <el-button type="primary" @click="save">保存</el-button>
        <el-button @click="cancel">取消</el-button>
      </el-form-item>
    </el-form>

  </DragResizeWindow>
</template>
<script>
import DragResizeWindow from '@/components/DragResizeWindow'
import { saveSelectSet } from '@/api/ProjectSelectSet'
export default {
  components: {
    DragResizeWindow
  },
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    flag: {
      type: String,
      default: ''
    },
    x: {
      type: Number,
      default: 10
    },
    y: {
      type: Number,
      default: 50
    },
    curSetData: {
      type: Object,
      default: function() { return {} }
    },
    selectPrimitives: {
      type: Array,
      default: function() { return [] }
    },
    bim: {
      type: Object,
      default: function() { return {} }
    }
  },
  data() {
    return {
      winVisible: false,
      formData: {
        groupFigureName: '',
        groupFigureDescription: '',
        isUpdate: '0'
      },
      tilte: '创建选择集',
      editPrimitives: [],
      rules: {
        groupFigureName: [
          { required: true, message: '请输入名称', trigger: ' ' }
        ],
        groupFigureDescription: [
          { required: true, message: '请输入描述', trigger: ' ' }
        ],
        isUpdate: [
          { required: true, message: '请选择', trigger: ' ' }
        ]
      }
    }
  },
  watch: {
    winVisible(v) {
      this.$emit('update:visible', v)
      if (!v) {
        this.bim.setSelectionState({ ids: [], selected: true, clear: true })
      }
    },
    visible(v) {
      this.winVisible = v
      if (v) {
        this.$refs.form.resetFields()
        this.dealModel()
      }
    },
    flag(newv) {
      if (newv === 'create') {
        this.tilte = '创建选择集'
      } else {
        this.tilte = '编辑选择集'
      }
    },
    curSetData: {
      handler(newV) {
        newV.groupFigureName = newV.groupFigureName || ''
        newV.groupFigureDescription = newV.groupFigureDescription || ''
        this.formData = { ...newV }

        if (this.formData.groupFigureSubList) {
          this.editPrimitives = []
          this.formData.groupFigureSubList.forEach(element => {
            var dict = {}
            dict.projectModelId = element.modelId
            if (element.figureId) {
              dict.figureId = element.figureId.split(',')
            } else {
              dict.figureId = []
            }
            this.editPrimitives.push(dict)
          })
        }
        this.$set(this.formData, 'isUpdate', '0')
      }
    },
    selectPrimitives: {
      handler(newV) {
        this.editPrimitives = newV
      }
    }
  },
  methods: {
    getAllIds() {
      return this.bim.getAllIds()
    },
    save() {
      if (this.flag === 'create') {
        if (this.editPrimitives.length === 0) {
          this.$alert('请选择选择集中包含的图元')
          return
        }
      } else {
        if (this.editPrimitives.length === 0 && this.formData.isUpdate === '1') {
          this.$alert('请选择选择集中包含的图元')
          return
        }
      }
      this.$refs.form.validate((valid) => {
        if (valid) {
          var requestData = {
            projectId: this.$route.params.id,
            groupFigureName: this.formData.groupFigureName,
            groupFigureDescription: this.formData.groupFigureDescription,
            updateFigure: this.formData.isUpdate
          }
          var groupFigureSubList = []
          this.editPrimitives.forEach(element => {
            const dict = { modelId: element.projectModelId, figureId: element.figureId.join(',') }
            if (this.flag === 'edit') {
              dict.id = this.formData.id
            }
            groupFigureSubList.push(dict)
          })
          requestData.groupFigureSubList = groupFigureSubList
          if (this.flag === 'create') {
            requestData.createUser = this.$store.state.user.userId
          } else {
            requestData.id = this.formData.id
            requestData.updateUser = this.$store.state.user.userId
          }
          saveSelectSet(requestData).then(res => {
            this.winVisible = false
            this.$emit('selectEditHide', { flag: 'save' })
          })
        } else {
          return false
        }
      })
    },
    cancel() {
      this.$emit('selectEditHide', { flag: 'cancel' })
      this.winVisible = false
    },
    dealModel() {
      if (this.formData && this.formData.groupFigureSubList) {
        var privitiveIds = ''
        this.formData.groupFigureSubList.forEach(element => {
          if (!privitiveIds) {
            privitiveIds = element.figureId
          } else {
            privitiveIds = privitiveIds + ',' + element.figureId
          }
        })
        if (this.formData.taskSection) {
          this.formData.taskSection.forEach(element => {
            if (!privitiveIds) {
              privitiveIds = element.figureId
            } else {
              privitiveIds = privitiveIds + ',' + element.figureId
            }
          })
        }
        var selectArr = []
        if (privitiveIds) {
          selectArr = privitiveIds.split(',')
        }
        var tmpArr = []
        selectArr.forEach(element => {
          tmpArr.push(parseInt(element))
        })
        this.bim.setSelectionState({ ids: tmpArr, selected: true })
      }
    }
  }
}
</script>
<style>
</style>
