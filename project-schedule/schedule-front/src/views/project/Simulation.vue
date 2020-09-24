<template>
  <el-card id="smiulation" ref="main" :body-style="{ padding: '0px' }" shadow="never" style="height: 100%">
    <div slot="header" class="clearfix">
      <span>施工模拟</span>
      <i class="el-icon-close closeBtns" @click="close" />
      <el-popover
        placement="right-start"
        width="600"
        trigger="click"
      >

        <el-form :inline="true" :model="settings" size="mini">
          <el-form-item label="播放维度">
            <el-select v-model="settings.timeType" placeholder="请选择" style="width: 130px">
              <el-option
                v-for="item in typeOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
              />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-date-picker
              v-model="settings.dates"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              :clearable="false"
              value-format="yyyy-MM-dd"
              :picker-options="pickerOptions()"
            />
          </el-form-item>
          <el-form-item label="刻度单位">
            <el-input-number v-model="settings.day" :min="1" :max="dateNums" label="刻度单位" />
            <span>天/刻度</span>
          </el-form-item>
          <el-form-item label="播放速度">
            <el-slider v-model="settings.speed" class="inline-slider" :min="0.5" :step="0.5" :max="4" style="width: 234px" />
          </el-form-item>
        </el-form>
        <el-button slot="reference" style="float: right; padding: 3px 0" type="text" :disabled="progress !== 0 || playStatus !== 0">设置</el-button>

      </el-popover>
    </div>
    <div style="padding:10px">
      <span style="font-size: 14px">按<span v-html="html(settings.timeType)" />&nbsp;&nbsp;&nbsp;<span v-html="html(settings.dates[0])" /> 至 <span v-html="html(settings.dates[1])" />&nbsp;&nbsp;&nbsp;<span v-html="html(settings.day)" />天/刻度</span>
      <div style="height: 70px">
        <div class="progress-slider" style="height: 70px">
          <el-slider
            :value="progress"
            :step="settings.day"
            :min="0"
            show-stops
            :max="dateNums"
            :show-tooltip="false"
            :disabled="playStatus !== 2"
            @input="progressChanged"
          />
          <span style="font-size: 12px;float:left">{{ settings.dates[0] }}</span>
          <span style="font-size: 12px;float:right">{{ settings.dates[1] }}</span>
        </div>

        <div style="display: inline-block;margin-left: 5px;width: 50px;height: 70px;position: relative;top: -20px;">
          <el-button v-if="(playStatus === 0 || playStatus === 2) && bakData.length > 0" style="position: absolute;margin-top:22px" type="primary" @click="play">播放</el-button>
          <el-button v-if="playStatus === 1 && dateNums !== progress" type="primary" style="position: absolute;top:-40px" @click="pause">暂停</el-button>
          <el-button v-if="playStatus === 1" type="primary" :style="dateNums !== progress?'margin-left: 0px;':'position: absolute;margin-top:22px'" @click="stop">停止</el-button>
        </div>

      </div>
    </div>

    <el-table :max-height="maxHeight" :data="tableData" row-key="id" :tree-props="{children: 'children', hasChildren: 'hasChildren'}" default-expand-all border>
      <el-table-column
        type="index"
        label="序号"
        width="50"
      />
      <el-table-column
        v-for="col in columns"
        :key="col.id"
        :prop="col.id"
        :label="col.label"
        :width="col.width"
      />
    </el-table>

  </el-card>
</template>

<script>
import { getPlanList } from '@/api/progressManage'
import { parseTime } from '@/utils/index.js'
export default {
  props: {
    bim: {
      type: Object,
      default: function() { return {} }
    }
  },
  data() {
    return {
      settings: {
        timeType: '计划时间',
        dates: [],
        day: 7,
        speed: 1
      },
      typeOptions: [{
        value: '计划时间',
        label: '计划时间'
      },
      {
        value: '实际时间',
        label: '实际时间'
      }],
      value1: 0,
      tableData: [],
      bakData: [],
      columns_actual: [
        { label: '任务名称', id: 'taskName' },
        { label: '开始时间', id: 'actualStartTime', width: '85px' },
        { label: '完成时间', id: 'actualEndTime', width: '85px' }
      ],
      columns_plan: [
        { label: '任务名称', id: 'taskName' },
        { label: '开始时间', id: 'planeStartTime', width: '85px' },
        { label: '完成时间', id: 'planeEndTime', width: '85px' }
      ],
      maxHeight: 1000,
      planStart: '9999-99-99',
      planEnd: '',
      actualStart: '9999-99-99',
      actualEnd: '',
      visibleIds: [],
      transIds: [],
      timeoutObj: 0,
      // 0:停止，1：播放，2：暂停
      playStatus: 0,
      offset: 0,
      bLast: false
    }
  },
  computed: {
    columns() {
      return this.settings.timeType === '计划时间' ? this.columns_plan : this.columns_actual
    },
    dateNums() {
      return this.settings.dates.length > 0 ? (new Date(this.settings.dates[1]).getTime() - new Date(this.settings.dates[0]).getTime()) / (24 * 60 * 60 * 1000) : 7
    },
    progress() {
      return this.bLast ? this.dateNums : this.offset * this.settings.day
    }
  },
  created() {
    var requestData = {
      projectId: this.$route.params.id
    }
    getPlanList(requestData).then(res => {
      if (res) {
        this.tableData = res
        this.bakData = JSON.parse(JSON.stringify(this.tableData))
        this.getRange(this.tableData)
        this.settings.dates = [this.planStart, this.planEnd]
      }
    })
  },
  mounted() {
    this.cal()
    window.addEventListener('resize', this.cal)
  },
  destroyed() {
    this.$emit('setObjColors')
    this.$emit('playing', false)
    window.removeEventListener('resize', this.cal)
  },
  methods: {
    close() {
      this.$emit('closeSimulation')
    },
    progressChanged(v) {
      if (this.playStatus === 2) {
        this.offset = v / this.settings.day
        this.filterData()
      }
    },
    pickerOptions() {
      const me = this
      return {
        disabledDate(time) {
          const t = time.getTime()
          if (me.settings.timeType === '计划时间') {
            const s = new Date(me.planStart)
            s.setHours(0)
            const e = new Date(me.planEnd)
            e.setHours(0)
            return t < s.getTime() || t > e.getTime()
          } else {
            const s = new Date(me.actualStart)
            s.setHours(0)
            const e = new Date(me.actualEnd)
            e.setHours(0)
            return t < s.getTime() || t > e.getTime()
          }
        }
      }
    },
    cal() {
      this.maxHeight = this.$refs.main.$el.offsetHeight - 166
    },
    html(value) {
      if (value) {
        return `<span style="color: #409eff">${value}</span>`
      } else {
        return ''
      }
    },
    getRange(data) {
      data.forEach(item => {
        if (item.actualStartTime && item.actualStartTime < this.actualStart) {
          this.actualStart = item.actualStartTime
        }
        if (item.actualEndTime && item.actualEndTime > this.actualEnd) {
          this.actualEnd = item.actualEndTime
        }
        if (item.planeStartTime && item.planeStartTime < this.planStart) {
          this.planStart = item.planeStartTime
        }
        if (item.planeEndTime && item.planeEndTime > this.planEnd) {
          this.planEnd = item.planeEndTime
        }
        if (item.children && item.children.length > 0) {
          this.getRange(item.children)
        }
      })
    },
    play() {
      if (this.offset === 0) {
        this.tableData = []
        const allIds = this.bim.getAllIds()
        this.bim.setVisibility({ ids: allIds, visible: false })
      }
      this.timeoutObj = setTimeout(() => {
        ++this.offset
        this.progressFilter()
      }, 1000 / this.settings.speed)
      this.playStatus = 1
      this.bim.setPickDisabled(true)
      this.bim.defaultToolbar = false
      this.$emit('playing', true)
    },
    pause() {
      clearTimeout(this.timeoutObj)
      this.playStatus = 2
    },
    stop() {
      clearTimeout(this.timeoutObj)
      this.offset = 0
      this.playStatus = 0
      this.tableData = JSON.parse(JSON.stringify(this.bakData))
      this.bim.resetVisibility()
      this.bim.setPickDisabled(false)
      this.bim.defaultToolbar = true
      this.bLast = false
      this.$emit('setObjColors')
      this.$emit('playing', false)
    },
    progressFilter() {
      if (this.bLast) {
        return
      }

      this.filterData()
      this.$nextTick(() => {
        const container = this.$el.querySelector('.el-table__body-wrapper')
        container.scrollTop = container.scrollHeight
      })
      this.timeoutObj = setTimeout(() => {
        ++this.offset
        this.progressFilter()
      }, 1000 / this.settings.speed)
    },
    filterData() {
      this.visibleIds = []
      this.transIds = []
      const time = new Date(this.settings.dates[0]).getTime() + (24 * 60 * 60 * 1000) * this.settings.day * this.offset
      let date = parseTime(time, '{y}-{m}-{d}')
      if (date >= this.settings.dates[1]) {
        this.bLast = true
        date = this.settings.dates[1]
      }
      const tmpData = JSON.parse(JSON.stringify(this.bakData))
      this.filterFun(tmpData, date)
      this.tableData = tmpData
      for (let index = 0; index < this.visibleIds.length; index++) {
        this.visibleIds[index] = parseInt(this.visibleIds[index])
      }
      for (let index = 0; index < this.transIds.length; index++) {
        this.transIds[index] = parseInt(this.transIds[index])
      }
      this.bim.setVisibility({ ids: this.visibleIds, visible: true })
      this.bim.resetColor({ ids: this.visibleIds })
      this.bim.setColor({ ids: this.transIds, color: '#ffffffc8' })
    },
    concatIds(item, type) {
      if (item.taskModel) {
        if (item.taskModel instanceof Array) {
          item.taskModel.forEach(obj => {
            if (obj.figureId) {
              if (type === 0) {
                this.transIds = this.transIds.concat(obj.figureId.split(','))
              }
              this.visibleIds = this.visibleIds.concat(obj.figureId.split(','))
            }
          })
        } else {
          if (item.taskModel.figureId) {
            if (type === 0) {
              this.transIds = this.transIds.concat(item.taskModel.figureId.split(','))
            }
            this.visibleIds = this.visibleIds.concat(item.taskModel.figureId.split(','))
          }
        }
      }
      if (item.taskSection) {
        item.taskSection.forEach(obj => {
          if (obj.figureId) {
            if (type === 0) {
              this.transIds = this.transIds.concat(obj.figureId.split(','))
            } else {
              this.visibleIds = this.visibleIds.concat(obj.figureId.split(','))
            }
          }
        })
      }
    },
    filterFun(arr, date) {
      for (let i = 0; i < arr.length; i++) {
        const item = arr[i]
        if (item) {
          if (this.settings.timeType === '计划时间') {
            if (item.planeStartTime && !item.planeEndTime && item.planeStartTime >= this.settings.dates[0] && item.planeStartTime <= date) {
              this.concatIds(item, 0)
            } else if (item.planeStartTime && item.planeEndTime) {
              if (item.planeStartTime >= this.settings.dates[0] && item.planeStartTime <= date) {
                if (item.planeEndTime > date) {
                  this.concatIds(item, 0)
                } else {
                  this.concatIds(item, 1)
                }
              } else {
                arr.splice(i, 1)
                i--
              }
            }
          } else {
            if (item.actualStartTime && !item.actualEndTime && item.actualStartTime >= this.settings.dates[0] && item.actualStartTime <= date) {
              this.concatIds(item, 0)
            } else if (item.actualStartTime && item.actualEndTime) {
              if (item.actualStartTime >= this.settings.dates[0] && item.actualStartTime <= date) {
                if (item.actualEndTime > date) {
                  this.concatIds(item, 0)
                } else {
                  this.concatIds(item, 1)
                }
              } else {
                arr.splice(i, 1)
                i--
              }
            }
          }
          if (item.children) {
            this.filterFun(item.children, date)
            if (item.children.length === 0) {
              arr.splice(i, 1)
              i--
            }
          }
        }
      }
    }
  }
}
</script>

<style>
#smiulation .inline-slider .el-slider__runway{
  margin: 11px 0
}

#smiulation .progress-slider .el-slider__stop{
  height: 6px;
  margin-top: 6px;
  width: 1px;
  background-color: #000;
}
#smiulation .closeBtns{
  float: right;
  line-height: 20px;
  cursor: pointer;
  margin-right:-15px;
  margin-top:2px;
  margin-left: 10px;
}
</style>

<style scoped>
.progress-slider {
  width: calc( 100% - 65px );
  display: inline-block;
  margin-left: 5px
}
</style>
