<template>
  <el-card id="progressPaymentModelView" ref="main" :body-style="{ padding: '0px' }" shadow="never" style="height: 100%">
    <div slot="header" class="clearfix">
      <span style="font-size:14px">进度款模拟</span>
      <i class="el-icon-close closeBtns" @click="close" />
    </div>
    <div style="padding:10px">
      <span style="font-size: 14px">按<span v-html="html(settings.timeType)" />&nbsp;&nbsp;&nbsp;<span v-html="html(settings.dates[0])" /> 至 <span v-html="html(settings.dates[1])" />&nbsp;&nbsp;&nbsp;<span v-html="html(settings.day)" />天/刻度</span>
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
        <el-button slot="reference" style="padding: 3px 10px" type="text" size="max" :disabled="progress !== 0 || playStatus !== 0">设置</el-button>
      </el-popover>
      <div style="height: 60px">
        <div class="progress-slider" style="height: 60px">
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
    <div re="echartDiv" :style="{'height':maxHeight + 'px'}" />

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
      planMoneyArr: [],
      planMoneyMap: {},
      actualMoneyArr: [],
      actualMoneyMap: {},
      chaMoneyArr: [],
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
      bLast: false,
      myChart: null
    }
  },
  computed: {
    dateNums() {
      return this.settings.dates.length > 0 ? (new Date(this.settings.dates[1]).getTime() - new Date(this.settings.dates[0]).getTime()) / (24 * 60 * 60 * 1000) : 7
    },
    xAxisData() {
      return this.getMonthBetween(this.settings.dates[0], this.settings.dates[1])
    },
    progress() {
      return this.bLast ? this.dateNums : this.offset * this.settings.day
    }
  },
  watch: {
    'settings.dates': {
      handler: function() {
        this.resetXAsixData()
        this.findTree(this.tableData, item => {
          this.caclMoney(item)
        })
        this.setChart()
      }
    }
  },

  created() {
    this.getListSetChart()
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
    getListSetChart() {
      var requestData = {
        projectId: this.$route.params.id
      }
      getPlanList(requestData).then(res => {
        if (res) {
          this.tableData = res
          this.bakData = JSON.parse(JSON.stringify(this.tableData))
          this.getRange(this.tableData)
          this.settings.dates = [this.planStart, this.planEnd]
          this.resetXAsixData()
          this.findTree(this.tableData, item => {
            this.caclMoney(item)
          })

          this.setChart()
        }
      })
    },
    close() {
      this.$emit('close')
    },
    getMonthBetween(start, end) {
      var result = []
      var starts = start.split('-')
      var ends = end.split('-')
      var staYear = parseInt(starts[0])
      var staMon = parseInt(starts[1])
      var endYear = parseInt(ends[0])
      var endMon = parseInt(ends[1])
      if (staMon < 10) {
        result.push(staYear + '-0' + staMon)
      } else {
        result.push(staYear + '-' + staMon)
      }
      while (staYear <= endYear) {
        if (staYear === endYear) {
          while (staMon <= endMon) {
            staMon++
            if (staMon < 10) {
              result.push(staYear + '-0' + staMon)
            } else {
              result.push(staYear + '-' + staMon)
            }
          }
          staYear++
        } else {
          staMon++
          if (staMon > 12) {
            staMon = 1
            staYear++
          }
          if (staMon < 10) {
            result.push(staYear + '-0' + staMon)
          } else {
            result.push(staYear + '-' + staMon)
          }
        }
      }
      return result
    },
    findTree(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.children) {
          this.findTree(obj.children, callBack)
        }
      })
    },
    setChart(noInit) {
      this.planMoneyArr = []
      this.actualMoneyArr = []
      this.chaMoneyArr = []
      var planTotal = 0
      var actualTotal = 0
      const time = new Date(this.settings.dates[0]).getTime() + (24 * 60 * 60 * 1000) * this.settings.day * this.offset
      const date = parseTime(time, '{y}-{m}-{d}')
      for (const key in this.planMoneyMap) {
        const money = this.planMoneyMap[key]
        if (this.planMoneyMap.hasOwnProperty(key)) {
          planTotal = planTotal + money
          if (date >= key || this.playStatus === 0) {
            var pd = planTotal
            this.planMoneyArr.push(pd)
          }
        }
        if (this.actualMoneyMap.hasOwnProperty(key)) {
          const money = this.actualMoneyMap[key]
          actualTotal = actualTotal + money
          if (date >= key || this.playStatus === 0) {
            var tmp = actualTotal
            this.actualMoneyArr.push(tmp)
            this.chaMoneyArr.push(actualTotal - planTotal)
          }
        }
      }
      if (!noInit) {
        const me = this
        // 引入柱状图
        if (!this.myChart) {
          var echarts = require('echarts')
          this.myChart = echarts.init(this.$refs.echartDiv)
        }
        // 绘制图表
        this.option = {
          tooltip: {
            trigger: 'axis'
          },
          legend: {
            data: ['计划金额', '实际金额', '差额']
          },
          xAxis: {
            type: 'category',
            boundaryGap: true,
            data: me.xAxisData
          },
          yAxis: {
            type: 'value'
          },
          grid: {
            left: '3%',
            right: '4%',
            top: '30',
            bottom: '60',
            containLabel: true
          },
          // dataset: {
          //   source: me.sourceData
          // },
          series: [
            {
              name: '计划金额',
              type: 'line',
              data: me.planMoneyArr
            },
            {
              name: '实际金额',
              type: 'line',
              data: this.actualMoneyArr
            },
            {
              name: '差额',
              type: 'line',
              data: this.chaMoneyArr
            }
          ]
        }
        this.myChart.setOption(this.option, true)
      } else {
        for (let i = 0; i < this.planMoneyArr.length; i++) {
          var change = false
          if (i < this.option.series[0].data.length) {
            if (this.option.series[0].data[i] !== this.planMoneyArr[i]) {
              this.option.series[0].data[i] = this.planMoneyArr[i]
              change = true
            }
          } else {
            this.option.series[0].data.push(this.planMoneyArr[i])
            change = true
          }
        }
        for (let j = 0; j < this.actualMoneyArr.length; j++) {
          if (j < this.option.series[1].data.length) {
            if (this.option.series[1].data[j] !== this.actualMoneyArr[j]) {
              this.option.series[1].data[j] = this.actualMoneyArr[j]
              change = true
            }
          } else {
            this.option.series[1].data.push(this.actualMoneyArr[j])
            change = true
          }
        }
        for (let k = 0; k < this.chaMoneyArr[k].length; k++) {
          if (k < this.option.series[2].data.length) {
            if (this.option.series[2].data[k] !== this.chaMoneyArr[k]) {
              this.option.series[2].data[k] = this.chaMoneyArr[k]
              change = true
            }
          } else {
            this.option.series[2].data.push(this.chaMoneyArr[k])
            change = true
          }
        }
        if (change === true) {
          this.myChart.setOption(this.option)
        }
      }
    },
    progressChanged(v) {
      if (this.playStatus === 2) {
        this.offset = v / this.settings.day
        this.filterData()
      }
    },
    pickerOptions() {
      // const me = this
      return {
        disabledDate(time) {
          // const t = time.getTime()
          // if (me.settings.timeType === '计划时间') {
          //   const s = new Date(me.planStart)
          //   s.setHours(0)
          //   const e = new Date(me.planEnd)
          //   e.setHours(0)
          //   return t < s.getTime() || t > e.getTime()
          // } else {
          //   const s = new Date(me.actualStart)
          //   s.setHours(0)
          //   const e = new Date(me.actualEnd)
          //   e.setHours(0)
          //   return t < s.getTime() || t > e.getTime()
          // }
        }
      }
    },
    cal() {
      this.maxHeight = this.$refs.main.$el.offsetHeight - 130
      if (this.myChart) { this.myChart.resize() }
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
    resetXAsixData() {
      this.xAxisData.forEach(datex => {
        this.planMoneyMap[datex] = 0
        this.actualMoneyMap[datex] = 0
      })
    },
    play() {
      if (this.offset === 0) {
        this.resetXAsixData()
        this.option.series[0].data = []
        this.option.series[1].data = []
        this.option.series[2].data = []
        this.myChart.setOption(this.option)
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
      this.resetXAsixData()
      this.findTree(this.tableData, item => {
        this.caclMoney(item)
      })
      this.setChart()
      this.$emit('setObjColors')
      this.$emit('playing', false)
    },
    progressFilter() {
      if (this.bLast) {
        return
      }

      this.filterData()
      this.timeoutObj = setTimeout(() => {
        ++this.offset
        this.progressFilter()
      }, 1000 / this.settings.speed)
    },
    filterData() {
      this.visibleIds = []
      this.transIds = []
      this.resetXAsixData()
      const time = new Date(this.settings.dates[0]).getTime() + (24 * 60 * 60 * 1000) * this.settings.day * this.offset
      let date = parseTime(time, '{y}-{m}-{d}')
      if (date >= this.settings.dates[1]) {
        this.bLast = true
        date = this.settings.dates[1]
      }
      const tmpData = JSON.parse(JSON.stringify(this.bakData))
      this.filterFun(tmpData, date)
      this.setChart()
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
      this.caclMoney(item, type)
    },

    caclMoney(item, type) {
      var totalMoney = 0
      if (item.progressPaymentList) {
        item.progressPaymentList.forEach(element => {
          totalMoney = parseFloat(totalMoney) + parseFloat(element.actualProgressPrice)
        })
      }
      if (item.planeEndTime) {
        var YM = item.planeEndTime.split('-')[0] + '-' + item.planeEndTime.split('-')[1]
        if (!this.planMoneyMap[YM]) {
          this.planMoneyMap[YM] = 0
        }
        this.planMoneyMap[YM] = parseFloat(this.planMoneyMap[YM]) + totalMoney
      }
      if (item.actualEndTime) {
        var YMActual = item.actualEndTime.split('-')[0] + '-' + item.actualEndTime.split('-')[1]
        if (!this.actualMoneyMap[YMActual]) {
          this.actualMoneyMap[YMActual] = 0
        }
        this.actualMoneyMap[YMActual] = parseFloat(this.actualMoneyMap[YMActual]) + totalMoney
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

<style lang='scss' scoped >
/deep/ .el-card__header {
    padding: 4px 20px;
    border-bottom: 1px solid #EBEEF5;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}
/deep/ .inline-slider .el-slider__runway{
  margin: 11px 0
}

/deep/ .progress-slider .el-slider__stop{
  height: 6px;
  margin-top: 6px;
  width: 1px;
  background-color: #000;
}
/deep/ .progress-slider {
  width:500px;
  display: inline-block;
  margin-left: 5px
}
.closeBtns{
  float: right;
  line-height: 18px;
  padding: 0 0px;
  cursor: pointer;
}
</style>
<style>
#progressPaymentModelView.el-card{
   border: 0px solid #EBEEF5;
    -webkit-transition: .3s;
    transition: .3s;
}
</style>
