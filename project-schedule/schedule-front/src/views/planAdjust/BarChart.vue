<template>
  <div style="height:100%">
    <div slot="header" />
    <div ref="echartDiv" style="height:100%" />
  </div>
</template>

<script>
import { month, week, monthOn, weekOn } from './imagePath'
import { getCostStatisByDate, getCostStatisByRes, getResMoneyStatis } from '@/api/planAdjust/planAdjust'
export default {

  props: {
    clickType: {
      type: String,
      default: 'date'
    },
    jSWData: {
      type: Boolean,
      default: false
    },
    selectRes: {
      type: Object,
      default: function() {
        return {
          selectId: '',
          selectName: ''
        }
      }
    },
    tabType: {
      type: String,
      default: 'res'
    },
    chartType: {
      type: String,
      default: 'date'
    },
    warnShow: {
      type: Boolean,
      default: false
    },
    propsOption: {
      type: Object,
      default: function() {
        return {
          title: {
            text: '',
            left: 'center'
          },
          toolBox: {
            show: true
          },
          click: false
        }
      }
    },

    pXAxisData: {
      type: Array,
      default: function() { return [] }
    },
    pYAxisData: {
      type: Array,
      default: function() { return [] }
    },
    pWarnValue: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      myChart: null,
      params: {
      },
      title: {
        text: '',
        left: ''
      },
      toolBox: {
        show: true
      },
      click: false,
      option: {},
      tmpOption: {},
      bFirstInit: false,
      xAxisData: [],
      xAxisDataTmp: [],
      yAxisData: [],
      yAxisDataTmp: [],
      yCostResArr: [],
      warnValue: 0,
      dateType: 'week',
      selectType: '',
      maxVal: 0
    }
  },
  computed: {
    warnData: function() {
      if (!this.warnValue || this.selectResId.length > 1 || this.yAxisDataTmp.length === 0) {
        this.$emit('hideJSWD', true)
        return []
      }
      var arr = []
      var max = 0
      if (Array.isArray(this.yAxisDataTmp[0])) {
        max = Math.max(...this.yAxisDataTmp[0])
      } else {
        max = Math.max(...this.yAxisDataTmp)
      }
      var tmpWarnValue = this.dateType === 'month' ? parseFloat(this.warnValue) * 4 : parseFloat(this.warnValue)
      if (max < tmpWarnValue) {
        this.$emit('hideJSWD', true)
        return arr
      } else {
        this.$emit('hideJSWD', false)
      }
      if (Array.isArray(this.yAxisData[0])) {
        this.yAxisDataTmp[0].forEach(element => {
          if (this.dateType === 'week') {
            arr.push(this.warnValue)
          } else {
            arr.push(this.warnValue * 4)
          }
        })
      } else {
        this.yAxisDataTmp.forEach(element => {
          if (this.dateType === 'week') {
            arr.push(this.warnValue)
          } else {
            arr.push(this.warnValue * 4)
          }
        })
      }
      return arr
    },
    selectResName() {
      return this.selectRes.selectName ? this.selectRes.selectName.split(',') : []
    },
    selectResId() {
      return this.selectRes.selectId ? this.selectRes.selectId.split(',') : []
    }
  },

  watch: {
    clickType(v) {
      // 当一个chart点击刷新是 另外一个重新render去掉选中
      if (v !== this.chartType && this.params.seriesId) {
        this.params = {}
        this.setMyChart()
      }
    },
    jSWData(v) {
      if (this.chartType === 'date') {
        this.filterWarnData()
      }
    },
    tabType(v) {
      this.warnValue = this.pWarnValue
      this.getStatic()
    },
    pWarnValue: {
      handler(v) {
        this.warnValue = v
      },
      immediate: true
    },
    warnShow(v) {
      if (v) {
        this.setMyChart()
      }
    },
    selectRes: {
      handler(obj) {
        this.getStatic()
      },
      deep: true
    }
  },
  created() {
    this.warnValue = this.pWarnValue
    this.getStatic()
  },
  mounted() {
    this.dealOptionData()
    this.setMyChart()
  },
  methods: {
    caluMax() {
      this.maxVal = 0
      if (Array.isArray(this.yAxisDataTmp[0])) {
        let totalMax = 0
        this.yAxisDataTmp.forEach(eleArr => {
          totalMax += Math.max(...eleArr)
        })
        this.maxVal = totalMax
      } else {
        this.maxVal = Math.max(...this.yAxisDataTmp)
      }
    },
    getStatic(noClickFirst) {
      // 每次下载数据相当于切换tab 清空param 自动选取第一个tab
      if (!noClickFirst) {
        this.params = {}
        this.tmpOption = {}
      }
      if (this.tabType === 'res') {
        if (!this.selectRes.selectId) {
          this.xAxisData = []
          this.yAxisData = []
          this.setMyChart()
          return
        }
        if (this.chartType === 'date') {
          getResMoneyStatis(null, { headers: null, params: {
            projectId: this.$route.params.id,
            resIds: this.selectRes.selectId,
            period: this.dateType === 'month' ? 1 : 2,
            isCaculate: 0,
            jhtz: 'jhtz'
          }}).then(res => {
            if (res && res.data) {
              res.data.forEach(item => {
                this.yAxisData = []
                this.yAxisDataTmp = []
                res.data.forEach(item => {
                  this.xAxisData = []
                  var tmpArrY = []
                  item.planStatisticsList.forEach((axisItem) => {
                    this.xAxisData.push(axisItem.xName)
                    tmpArrY.push(axisItem.yTotal)
                  })
                  this.yAxisData.push(tmpArrY)
                  this.yAxisDataTmp.push(tmpArrY)
                })
                this.xAxisDataTmp = [...this.xAxisData]
              })
              if (this.jSWData) {
                this.filterWarnData()
              } else {
                this.setMyChart()
              }
            }
          })
        } else if (this.chartType === 'cost') {
          getResMoneyStatis(null, { headers: null, params: {
            projectId: this.$route.params.id,
            resIds: this.selectRes.selectId,
            period: this.dateType === 'month' ? 1 : 2,
            isCaculate: 1,
            jhtz: 'jhtz'
          }}).then(res => {
            this.xAxisData = []
            this.yAxisData = []
            this.yAxisDataTmp = []
            res.data.forEach(item => {
              this.xAxisData = []
              var tmpArrY = []
              item.planStatisticsList.forEach((axisItem) => {
                this.xAxisData.push(axisItem.xName)
                const yTotal = parseFloat(axisItem.yTotal)
                tmpArrY.push(yTotal)
              })
              this.yAxisData.push(tmpArrY)
              this.yAxisDataTmp.push(tmpArrY)
            })
            this.xAxisDataTmp = [...this.xAxisData]
            this.setMyChart()
          })
        }
      } else if (this.tabType === 'cost') {
        if (this.chartType === 'date') {
          getCostStatisByDate(null, { headers: null, params: {
            projectId: this.$route.params.id,
            period: this.dateType === 'month' ? 1 : 2
          }}).then(res => {
            this.xAxisData = []
            this.yAxisData = []
            this.yAxisDataTmp = []
            if (res && res.data) {
              res.data.forEach(axisItem => {
                this.xAxisData.push(axisItem.xAxis)
                this.yAxisData.push(axisItem.yAxis)
                this.yAxisDataTmp.push(axisItem.yAxis)
              })
            }
            this.xAxisDataTmp = [...this.xAxisData]
            if (this.jSWData) {
              this.filterWarnData()
            } else {
              this.setMyChart()
            }
          })
        }
        if (this.chartType === 'cost') {
          getCostStatisByRes(null, { headers: null, params: {
            projectId: this.$route.params.id
          }}).then(res => {
            this.xAxisData = []
            this.yAxisData = []
            this.yCostResArr = []
            if (res && res.data) {
              res.data.forEach(axisItem => {
                this.xAxisData.push(axisItem.xAxis)
                this.yAxisData.push(axisItem.yAxis)
                this.yCostResArr.push(axisItem)
              })
            }
            this.setMyChart()
          })
        }
      }
    },
    dealOptionData() {
      for (var key in this.propsOption) {
        this[key] = this.propsOption[key]
      }
    },
    convert(money) {
      if (!money) { return 0 }
      var m = money.toString().split('.')
      var m1 = m[0]
      if (!m[1]) { m[1] = '00' } // 加不加0看需求
      var m2 = m.length > 1 ? '.' + m[1] : ''
      var reg = /(\d+)(\d{3})/
      while (reg.test(m1)) {
        m1 = m1.replace(reg, '$1' + ',' + '$2')
      }
      return m1 + m2
    },
    filterWarnData() {
      if (Array.isArray(this.yAxisDataTmp[0])) {
        this.yAxisData = [[]]
        this.xAxisData = []
        if (this.jSWData) {
          const tmpWarnValue = this.dateType === 'month' ? parseFloat(this.warnValue) * 4 : parseFloat(this.warnValue)
          this.yAxisDataTmp[0].forEach((value, index) => {
            if (parseFloat(value) > tmpWarnValue) {
              this.yAxisData[0].push(value)
              this.xAxisData.push(this.xAxisDataTmp[index])
            }
          })
        } else {
          this.yAxisData = JSON.parse(JSON.stringify(this.yAxisDataTmp))
          this.xAxisData = JSON.parse(JSON.stringify(this.xAxisDataTmp))
        }
      } else {
        this.yAxisData = []
        this.xAxisData = []
        if (this.jSWData) {
          const tmpWarnValue = this.dateType === 'month' ? parseFloat(this.warnValue) * 4 : parseFloat(this.warnValue)
          this.yAxisDataTmp.forEach((value, index) => {
            if (parseFloat(value) > tmpWarnValue) {
              this.yAxisData.push(value)
              this.xAxisData.push(this.xAxisDataTmp[index])
            }
          })
        } else {
          this.yAxisData = Object.assign([], this.yAxisData, this.yAxisDataTmp)
          this.xAxisData = JSON.parse(JSON.stringify(this.xAxisDataTmp))
        }
      }
      this.params = {}
      this.tmpOption = {}
      this.setMyChart()
    },
    setMyChart() {
      const me = this
      if (this.tabType === 'res' || this.chartType === 'date') {
        this.caluMax()
      }
      var xAxis = [
        {
          type: 'category',
          axisTick: {
            alignWithLabel: true
          },
          axisLabel: {}
        }
      ]
      var yAxis = [
        {
          axisTick: {
            show: true
          },
          type: 'value',
          axisLabel: {}
        }

      ]
      var dataZoomSet = []
      var endValue = this.tmpOption.dataZoom ? this.tmpOption.dataZoom[0].end : 100
      var startValue = this.tmpOption.dataZoom ? this.tmpOption.dataZoom[0].start : 0

      if (me.tabType === 'cost') {
        me.click = true
        if (me.chartType === 'date') {
          yAxis[0].max = me.maxVal
          yAxis[0].interval = Math.round(me.maxVal / 5, 1)
          me.title.text = '费用统计'
          yAxis[0].axisLabel.formatter = function(value) {
            return '¥' + me.convert(value)
          }
          if (me.xAxisData.length > 0) {
            if (me.xAxisData.length > 5) {
              endValue = this.tmpOption.dataZoom ? endValue : Math.round(5 / me.xAxisData.length * 100)
            }
          }
          dataZoomSet = [
            {
              start: startValue, // 默认为0
              end: endValue, // 默认为100
              type: 'slider',
              show: true,
              xAxisIndex: [0]

            },
            {
              type: 'inside',
              show: true,
              yAxisIndex: [0],
              filterMode: 'empty'
            }
          ]
        } else if (me.chartType === 'cost') {
          me.title.text = '各类资源总费用统计'
          xAxis[0].axisLabel.formatter = function(value) {
            return '¥' + me.convert(value)
          }
          if (me.yAxisData.length > 0) {
            if (me.yAxisData.length > 5) {
              endValue = this.tmpOption.dataZoom ? endValue : Math.round(5 / me.xAxisData.length * 100)
            }
          }
          dataZoomSet = [
            {
              type: 'inside',
              show: true,
              xAxisIndex: [0]
            },
            {
              type: 'slider',
              show: true,
              filterMode: 'empty',
              yAxisIndex: [0]
            }
          ]
        }
      } else if (me.tabType === 'res') {
        if (me.xAxisData.length > 0) {
          if (me.xAxisData.length > 5) {
            endValue = this.tmpOption.dataZoom ? endValue : Math.round(5 / me.xAxisData.length * 100)
          }
        }
        dataZoomSet = [
          {
            start: startValue, // 默认为0
            end: endValue, // 默认为100
            type: 'slider',
            show: true,
            xAxisIndex: [0]
          },
          {
            type: 'inside',
            show: true,
            filterMode: 'empty',
            yAxisIndex: [0]
          }
        ]
        if (me.chartType === 'date') {
          me.click = true
          me.title.text = '资源使用情况统计'
          yAxis[0].max = me.maxVal
          yAxis[0].interval = Math.round(me.maxVal / 5)
        } else if (me.chartType === 'cost') {
          me.title.text = '费用统计'
          if (me.maxVal) {
            yAxis[0].max = me.maxVal
            yAxis[0].interval = Math.round(me.maxVal / 5)
          }

          me.click = false
          yAxis[0].axisLabel.formatter = function(value) {
            return '¥' + me.convert(value)
          }
        }
      }
      if (this.tabType === 'cost' && this.chartType === 'cost') {
        xAxis[0].type = 'value'
        yAxis[0].type = 'category'
        yAxis[0].data = me.yAxisData // Y轴确定 x轴为值 可变 在series中设置
        me.toolBox.show = false
      } else {
        xAxis[0].type = 'category'
        yAxis[0].type = 'value'
        xAxis[0].data = me.xAxisData // X轴确定 x轴为值 可变 在series中设置
        me.toolBox.show = true
      }
      var seriesArr = []
      if (this.tabType === 'cost') {
        seriesArr = [
          {
            name: this.chartType === 'cost' ? '当前资源总费用' : '当前时段总费用',
            type: 'bar',
            barWidth: '40%',
            data: this.chartType === 'cost' ? me.xAxisData : me.yAxisData,
            itemStyle: {
              normal: {
                label: {
                  show: true,
                  position: 'insideLeft',
                  distance: this.chartType === 'cost' ? 8 : 0,
                  formatter: (params) => {
                    if (params.value) {
                      return '¥' + me.convert(params.value)
                    } else {
                      return params.value
                    }
                  }
                },
                color: function(params) {
                  let data0 = null
                  if (me.chartType === 'date' && me.xAxisData.length > 0) {
                    data0 = me.xAxisData[0]
                  }
                  let guard = false
                  if (me.dateType === 'month') {
                    if (data0) {
                      guard = data0.split('.').length === 2
                    }
                  } else {
                    if (data0) {
                      guard = data0.split('~').length === 2
                    }
                  }
                  if (me.click && params.dataIndex === 0 && me.chartType === 'date' && me.clickType === me.chartType && !me.params.seriesId && data0 === params.name && guard) {
                    params.chartType = me.chartType
                    me.params = params
                    me.$emit('clickBar', params)
                  }
                  // 判断选中的名字改变柱子的颜色样式
                  if (me.click && me.params.name === params.name && me.params.componentIndex === params.componentIndex && me.params.dataIndex === params.dataIndex) {
                    return '#4472c4'
                  } else {
                    return '#ffc001'
                  }
                }
              }
            }
          }, {
            name: '预警值',
            type: 'line',
            // symbol: 'none',
            data: me.warnData,
            itemStyle: {
              color: 'red'
            }
          }
        ]
      } else {
        seriesArr = [{
          name: '预警值',
          type: 'line',
          // symbol: 'none',
          data: me.warnData,
          itemStyle: {
            color: 'red'
          }
        }]
        var stacKColor = ['#ffc001', '#5b9bd5', '#70ad47']
        var lengendArr = []
        this.selectResName.forEach((selectName, selIndex) => {
          lengendArr.push(selectName)
          const dict = {
            id: me.selectResId[selIndex],
            name: selectName,
            type: 'bar',
            stack: '资源',
            barWidth: '40%',
            data: me.tabType === 'res' ? me.yAxisData[selIndex] : me.yAxisData,
            itemStyle: {
              normal: {
                label: { show: true,
                  formatter: (params) => {
                    if (me.chartType === 'cost' && params.value) {
                      return '¥' + me.convert(params.value)
                    } else {
                      return params.value
                    }
                  }
                },
                color: function(params) {
                  let data0 = null
                  if (me.tabType === 'res' && me.yAxisData[selIndex].length > 0) {
                    data0 = me.xAxisData[0]
                  } else {
                    data0 = me.xAxisData[0]
                  }
                  let guard = false
                  if (me.dateType === 'month') {
                    if (data0) {
                      if (me.tabType === 'res') {
                        guard = data0.split('.').length === 2
                      }
                    }
                  } else {
                    if (data0) { guard = data0.split('~').length === 2 }
                  }
                  console.log('tag', me.click, params)
                  if (me.click && params.dataIndex === 0 && me.chartType === 'date' && !me.params.seriesId && data0 === params.name && guard) {
                    params.chartType = me.chartType
                    me.params = params
                    me.$emit('clickBar', params)
                  }
                  // 判断选中的名字改变柱子的颜色样式
                  if (me.click && me.params.name === params.name && me.params.componentIndex === params.componentIndex && me.params.dataIndex === params.dataIndex) {
                    return '#4472c4'
                  } else {
                    return stacKColor[selIndex]
                  }
                }
              }
            }
          }
          seriesArr.unshift(dict)
        })
      }
      if (!me.warnShow) { seriesArr.splice(seriesArr.length - 1, 1) }
      if (!this.myChart) {
        var echarts = require('echarts')
        this.myChart = echarts.init(this.$refs.echartDiv)
      }
      // 绘制图表
      me.option = {
        title: {
          text: me.title.text,
          left: me.title.left
        },
        color: stacKColor,
        legend: {
          data: me.tabType === 'res' && me.selectResName.length > 1 ? lengendArr : [],
          left: 60,
          top: 28,
          selectedMode: false
        },
        tooltip: {
          trigger: 'axis',
          axisPointer: {
            type: 'cross',
            label: {
              backgroundColor: '#283b56'
            }
          }
        },
        toolbox: {
          show: me.toolBox.show,
          showTitle: false,
          itemSize: 25,
          feature: {
            myToolweek: {
              show: me.toolBox.show,
              title: '周',
              icon: this.dateType === 'week' ? weekOn : week,
              onclick: function() {
                if (me.dateType === 'week') {
                  return
                }
                me.dateType = 'week'
                me.getStatic()
                me.$emit('changeUnit', 'week')
              }
            },
            myToolMonth: {
              show: me.toolBox.show,
              title: '月',
              icon: this.dateType === 'month' ? monthOn : month,
              onclick: function() {
                if (me.dateType === 'month') {
                  return
                }
                me.dateType = 'month'
                me.getStatic()
                me.$emit('changeUnit', 'month')
              }
            }
          }
        },
        grid: {
          left: '3%',
          right: '4%',
          bottom: '3%',
          containLabel: true
        },
        xAxis: xAxis,
        yAxis: yAxis,
        dataZoom: dataZoomSet,
        series: seriesArr.reverse()
      }
      this.myChart.setOption(this.option, true)
      this.setClickBar()
    },
    resizeChart() {
      if (this.myChart) {
        this.myChart.resize()
      }
    },
    setClickBar() {
      this.myChart.on('click', (params) => {
        if (!this.click || (this.params.name === params.name && this.params.componentIndex === params.componentIndex)) {
          return
        }
        if (this.tabType === 'cost' && this.chartType === 'cost') {
          this.yCostResArr.forEach(element => {
            if (element.yAxis === params.name) {
              params.seriesId = element.resId
              return
            }
          })
        }
        params.chartType = this.chartType
        this.params = params
        this.tmpOption = this.myChart.getOption()
        this.option.dataZoom = this.tmpOption.dataZoom
        this.myChart.setOption(this.option)
        this.$emit('clickBar', params)
      })
    }

  }
}
</script>
<style lang="scss" scoped>
</style>
