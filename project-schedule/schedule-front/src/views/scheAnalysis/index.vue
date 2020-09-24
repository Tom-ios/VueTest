<template>
  <el-card ref="cardRef" class="mt-10 ml-10 mr-10 min-w">
    <div v-if="showDiv">
      <div class="clearfix">
        <span style="line-height:32px;">项目完成比例:&nbsp;{{ completionRatio }}</span>
        <span style="margin-left:50px;line-height:32px;">项目进展:&nbsp;{{ projectProgress }}</span>
        <div class="fr">
          <el-button type="primary" @click="dialogVisible = true">偏差分析</el-button>
          <el-button type="primary" @click="getNewData">汇总计算</el-button>
        </div>
      </div>
      <div class="box clearfix">
        <ul class="ulBox" style="margin-top: 5px;">
          <li title="PV = ∑ (作业计划进度*项目合同额*作业权重比例)">&nbsp;计划价值(PV)</li>
          <li>&nbsp;{{ PV }}元</li>
          <li title="AC = ∑ 作业实际使用资源的费用">&nbsp;实际成本(AC)</li>
          <li>&nbsp;{{ AC }}元</li>
          <li title="BAC = ∑ 作业计划使用资源的费用">&nbsp;完工预算(BAC)</li>
          <li>&nbsp;{{ BAC }}元</li>
          <li title="CPI = EV / AC">&nbsp;CPI指数</li>
          <li>&nbsp;{{ CPI }}</li>
        </ul>
        <ul class="ulBox">
          <li title="EV = ∑ (作业实际进度*项目合同额*作业权重比例)">&nbsp;挣值(EV)</li>
          <li>&nbsp;{{ EV }}元</li>
          <li title="CV = EV - AC">&nbsp;成本偏差(CV)</li>
          <li>&nbsp;{{ CV }}元</li>
          <li title="EAC = AC + BAC - EV(剩余工作按计划效率进行)">&nbsp;实际完工估算(非典型EAC)</li>
          <li>&nbsp;{{ EAC_TYPICAL_NO }}元</li>
          <li title="SPI = EV / PV">&nbsp;SPI指数</li>
          <li>&nbsp;{{ SPI }}</li>
        </ul>
        <ul class="ulBox">
          <li />
          <li />
          <li title="SV = EV - PV">&nbsp;进度偏差(SV)</li>
          <li>&nbsp;{{ SV }}元</li>
          <li title="EAC = BAC / CPI(剩余工作按当前效率进行)">&nbsp;实际完工估算(典型EAC)</li>
          <li>&nbsp;{{ EAC_TYPICAL_YES }}元</li>
          <li />
          <li />
        </ul>
      </div>
      <div class="mt-10 clearfix" :style="{ height: divHeight + 'px' }">
        <div class="clearfix">
          <div style="float:right;margin-right:0px;">
            <!-- <el-button v-if="timeValue === '1'" class="week" circle @click="toggleTime(2)" />
            <el-button v-if="timeValue === '1'" class="monthOn" circle @click="toggleTime(1)" />
            <el-button v-if="timeValue === '2'" class="weekOn" circle @click="toggleTime(2)" />
            <el-button v-if="timeValue === '2'" class="month" circle @click="toggleTime(1)" /> -->
            <img v-if="timeValue === '1'" :src="week" alt="周" style="cursor: pointer;" @click="toggleTime(2)">
            <img v-if="timeValue === '1'" :src="monthOn" alt="月选" style="cursor: pointer;" @click="toggleTime(1)">
            <img v-if="timeValue === '2'" :src="weekOn" alt="周选" style="cursor: pointer;" @click="toggleTime(2)">
            <img v-if="timeValue === '2'" :src="month" alt="月" style="cursor: pointer;" @click="toggleTime(1)">
          </div>
        </div>
        <div>
          <div id="dataTable1" style="width: 49%;float:left;" :style="{ height: divHeight / 2 + 'px' }" />
          <div id="dataTable2" style="width: 49%;float:left;margin-left:2%;" :style="{ height: divHeight / 2 + 'px' }" />
        </div>
        <div class="mt-10">
          <div id="dataTable3" style="width: 49%;float:left;" :style="{ height: divHeight / 2 + 'px' }" />
          <div id="dataTable4" style="width: 49%;float:left;margin-left:2%;" :style="{ height: divHeight / 2 + 'px' }" />
        </div>
      </div>
    </div>
    <div v-else class="noneBox">
      <span class="noneData">尚未填报进度</span>
    </div>

    <el-dialog
      title="分析报告"
      :visible.sync="dialogVisible"
      width="35%"
    >
      <el-alert
        title="分析结论"
        type="success"
        show-icon
        :closable="false"
        style="margin-bottom:10px;"
      />
      <p v-for="(item,i) in conclusions" :key="i" :style="{ margin:'5px' }">{{ item }}<br></p>
      <el-alert
        title="建议措施"
        type="warning"
        show-icon
        :closable="false"
        style="margin-top:20px;margin-bottom:10px;"
      />
      <span style="margin:5px">{{ measure }}</span>
    </el-dialog>
  </el-card>
</template>

<script>
import { month, week, monthOn, weekOn } from './imagePath'
import { getEarnedValue, getEarnedValueChart, getReport, getProgressBoardInfo, whetherReport } from '@/api/scheAnalysis/scheAnalysis'
export default {
  name: 'EarnAnalysis',
  data() {
    return {
      showDiv: false,
      divHeight: '500',
      month: month,
      week: week,
      monthOn: monthOn,
      weekOn: weekOn,
      dialogVisible: false,
      completionRatio: '',
      projectProgress: '',
      timeValue: '1',
      PV: '',
      AC: '',
      BAC: '',
      CPI: '',
      EV: '',
      CV: '',
      EAC_TYPICAL_NO: '',
      SPI: '',
      SV: '',
      EAC_TYPICAL_YES: '',
      measure: '',
      conclusions: [],
      option1: {},
      option2: {},
      option3: {},
      option4: {},
      myChart1: {},
      myChart2: {},
      myChart3: {},
      myChart4: {},
      taskVersionInfo: null
    }
  },
  watch: {
    option1: {
      handler(newVal, oldVal) {
        if (this.myChart1) {
          if (newVal) {
            this.myChart1.setOption(newVal)
          } else {
            this.myChart1.setOption(oldVal)
          }
        } else {
          this.init('dataTable1', 1)
        }
      },
      deep: true // 对象内部属性的监听，关键。
    },
    option2: {
      handler(newVal, oldVal) {
        if (this.myChart1) {
          if (newVal) {
            this.myChart2.setOption(newVal)
          } else {
            this.myChart2.setOption(oldVal)
          }
        } else {
          this.init('dataTable2', 2)
        }
      },
      deep: true // 对象内部属性的监听，关键。
    },
    option3: {
      handler(newVal, oldVal) {
        if (this.myChart1) {
          if (newVal) {
            this.myChart3.setOption(newVal)
          } else {
            this.myChart3.setOption(oldVal)
          }
        } else {
          this.init('dataTable3', 3)
        }
      },
      deep: true // 对象内部属性的监听，关键。
    },
    option4: {
      handler(newVal, oldVal) {
        if (this.myChart1) {
          if (newVal) {
            this.myChart4.setOption(newVal)
          } else {
            this.myChart4.setOption(oldVal)
          }
        } else {
          this.init('dataTable4', 4)
        }
      },
      deep: true // 对象内部属性的监听，关键。
    }
  },
  created() {
    // this.checkReport() // 检测是否已经开始了进度填报
    // this.getData()
    // this.getChart()
  },
  mounted() {
    this.checkReport()
    console.log('/*/*', this.showDiv)
  },
  methods: {
    async checkReport() { // 检测是否已经开始了进度填报
      var params = {
        projectId: this.$route.params.id
      }
      await whetherReport(params).then(res => {
        this.showDiv = res
      })
      if (this.showDiv) { // 进度填报已经开始
        console.log('879*')
        this.getData()
        this.getChart()
        this.$nextTick(() => {
          this.divHeight = window.innerHeight - 260
        })
      }
    },
    init(echartsName, type) {
      var echarts = require('echarts')
      if (type === 1) {
        this.myChart1 = echarts.init(document.getElementById(echartsName))
        this.myChart1.setOption(this.option1, true)
      } else if (type === 2) {
        this.myChart2 = echarts.init(document.getElementById(echartsName))
        this.myChart2.setOption(this.option2, true)
      } else if (type === 3) {
        this.myChart3 = echarts.init(document.getElementById(echartsName))
        this.myChart3.setOption(this.option3, true)
      } else {
        this.myChart4 = echarts.init(document.getElementById(echartsName))
        this.myChart4.setOption(this.option4, true)
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
    toggleTime(type) {
      if (type === 1) {
        this.timeValue = '1'
      } else {
        this.timeValue = '2'
      }
      this.getChart()
    },
    getNewData() {
      this.checkReport()
      if (this.showDiv) {
        this.getData()
        // this.getChart()
      }
      // this.getData()
    },
    getData() {
      var params = {
        projectId: this.$route.params.id
      }
      getEarnedValue(params).then(res => {
        console.log(res)
        if (res && res.state === 'success') {
          this.PV = res.data.PV.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
          this.AC = res.data.AC.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
          this.BAC = res.data.BAC.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
          this.CPI = res.data.CPI.toFixed(2)
          this.EV = res.data.EV.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
          this.CV = res.data.CV.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
          this.EAC_TYPICAL_NO = res.data.EAC_TYPICAL_NO.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
          this.SPI = res.data.SPI.toFixed(2)
          this.SV = res.data.SV.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
          this.EAC_TYPICAL_YES = res.data.EAC_TYPICAL_YES.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,')
          this.measure = res.data.deviationAnalysis.measure
          this.conclusions = res.data.deviationAnalysis.conclusions
        }
      })
      getReport(params, Boolean(this.taskVersionInfo)).then(res => {
        if (res.state === 'success') {
          this.completionRatio = res.data.actualProgress + '%'
        } else {
          this.$message.error('获取项目进展失败')
        }
      })
      var data = [{
        subProjectId: this.$route.params.id
      }]
      getProgressBoardInfo(data).then(res => {
        console.log('项目进展', res)
        if (res[0].warnType === '1') {
          this.projectProgress = '正常'
        } else if (res[0].warnType === '2') {
          this.projectProgress = '提前' + res[0].warnDays + '天'
        } else if (res[0].warnType === '3') {
          this.projectProgress = '存在延期风险'
        } else if (res[0].warnType === '4') {
          this.projectProgress = '未延期'
        } else if (res[0].warnType === '5') {
          this.projectProgress = '已延期' + res[0].warnDays + '天'
        }
      })
    },
    async getChart() {
      var param = {
        projectId: this.$route.params.id,
        period: this.timeValue
      }
      var WGPC_NO_BAC = []
      var WGPC_NO_EAC = []
      var WGPC_NO_VAC = []
      var WGPC_NO_X = []
      var WGPC_YES_BAC = []
      var WGPC_YES_EAC = []
      var WGPC_YES_VAC = []
      var WGPC_YES_X = []
      var progress_EV = []
      var progress_SV = []
      var progress_PV = []
      var progress_X = []
      var cost_EV = []
      var cost_AC = []
      var cost_CV = []
      var cost_X = []
      await getEarnedValueChart(param).then(res => {
        console.log('getEarnedValueChart', res)
        /*
        if (res && res.state === 'success') {
          res.data.deviationUntypicalChart.BAC.forEach(el => {
            WGPC_NO_BAC.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
            WGPC_NO_X.push(el.xName)
          })
          res.data.deviationUntypicalChart.EAC.forEach(el => {
            WGPC_NO_EAC.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
          })
          res.data.deviationUntypicalChart.VAC.forEach(el => {
            WGPC_NO_VAC.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
          })
          res.data.deviationTypicalChart.BAC.forEach(el => {
            WGPC_YES_BAC.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
            WGPC_YES_X.push(el.xName)
          })
          res.data.deviationTypicalChart.EAC.forEach(el => {
            WGPC_YES_EAC.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
          })
          res.data.deviationTypicalChart.VAC.forEach(el => {
            WGPC_YES_VAC.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
          })
          res.data.progressChart.EV.forEach(el => {
            progress_EV.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
            progress_X.push(el.xName)
          })
          res.data.progressChart.SV.forEach(el => {
            progress_SV.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
          })
          res.data.progressChart.PV.forEach(el => {
            progress_PV.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
          })
          res.data.costChart.EV.forEach(el => {
            cost_EV.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
            cost_X.push(el.xName)
          })
          res.data.costChart.AC.forEach(el => {
            cost_AC.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
          })
          res.data.costChart.CV.forEach(el => {
            cost_CV.push(el.yTotal.toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,'))
          })
        }
        */
        if (res && res.state === 'success') {
          res.data.deviationUntypicalChart.BAC.forEach(el => {
            WGPC_NO_BAC.push(el.yTotal)
            WGPC_NO_X.push(el.xName)
          })
          res.data.deviationUntypicalChart.EAC.forEach(el => {
            WGPC_NO_EAC.push(el.yTotal)
          })
          res.data.deviationUntypicalChart.VAC.forEach(el => {
            WGPC_NO_VAC.push(el.yTotal)
          })
          /**/
          res.data.deviationTypicalChart.BAC.forEach(el => {
            WGPC_YES_BAC.push(el.yTotal)
            WGPC_YES_X.push(el.xName)
          })
          res.data.deviationTypicalChart.EAC.forEach(el => {
            WGPC_YES_EAC.push(el.yTotal)
          })
          res.data.deviationTypicalChart.VAC.forEach(el => {
            WGPC_YES_VAC.push(el.yTotal)
          })
          /**/
          res.data.progressChart.EV.forEach(el => {
            progress_EV.push(el.yTotal)
            progress_X.push(el.xName)
          })
          res.data.progressChart.SV.forEach(el => {
            progress_SV.push(el.yTotal)
          })
          res.data.progressChart.PV.forEach(el => {
            progress_PV.push(el.yTotal)
          })
          /**/
          res.data.costChart.EV.forEach(el => {
            cost_EV.push(el.yTotal)
            cost_X.push(el.xName)
          })
          res.data.costChart.AC.forEach(el => {
            cost_AC.push(el.yTotal)
          })
          res.data.costChart.CV.forEach(el => {
            cost_CV.push(el.yTotal)
          })
        }
      })
      var endValue1 = 100
      var endValue2 = 100
      var endValue3 = 100
      var endValue4 = 100
      if (WGPC_NO_X.length > 0) {
        if (WGPC_NO_X.length > 5) {
          endValue1 = Math.round(5 / WGPC_NO_X.length * 100)
        } else {
          endValue1 = 100
        }
      }
      if (WGPC_YES_X.length > 0) {
        if (WGPC_YES_X.length > 5) {
          endValue2 = Math.round(5 / WGPC_YES_X.length * 100)
        } else {
          endValue2 = 100
        }
      }
      if (progress_X.length > 0) {
        if (progress_X.length > 5) {
          endValue3 = Math.round(5 / progress_X.length * 100)
        } else {
          endValue3 = 100
        }
      }
      if (cost_X.length > 0) {
        if (cost_X.length > 5) {
          endValue4 = Math.round(5 / cost_X.length * 100)
        } else {
          endValue4 = 100
        }
      }
      this.showDiv = true
      const me = this
      this.$nextTick(() => {
        // const myChart1 = echarts.init(document.getElementById('dataTable1'))
        this.option1 = {
          title: {
            text: '成本曲线',
            top: '20px',
            textStyle: {
              fontSize: 16
            }
          },
          tooltip: {
            trigger: 'axis',
            formatter(params) {
              // console.log('params', params)
              if (params.length === 3) {
                var relVal1 = params[0].name + '<br/>'
                relVal1 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[2]['marker'] + params[2]['seriesName'] + ' : ' + params[2]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal1
              } else if (params.length === 2) {
                var relVal2 = params[0].name + '<br/>'
                relVal2 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal2
              } else if (params.length === 1) {
                var relVal3 = params[0].name + '<br/>'
                relVal3 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal3
              } else {
                return ''
              }
            }
          },
          legend: {
            // x: '200px',
            y: '20px',
            data: ['CV', 'AC', 'EV']
          },
          grid: {
            left: '3%',
            right: '4%',
            bottom: '8%',
            containLabel: true
          },
          xAxis: {
            type: 'category',
            boundaryGap: true,
            axisLabel: {
              interval: 0,
              formatter: function(value) {
                let valueText = ''
                if (value.length > 10) {
                  valueText = value.substring(0, 10) + '\n' + value.substring(10)
                } else {
                  valueText = value
                }
                return valueText
              }
            },
            data: cost_X
          },
          yAxis: {
            type: 'value'
          },
          dataZoom: [
            {
              start: 0, // 默认为0
              end: endValue1, // 默认为100
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
          ],
          series: [
            {
              name: 'CV',
              type: 'line',
              // itemStyle: {
              //   normal: {
              //     label: { show: true,
              //       formatter: (params) => {
              //         return '¥' + me.convert(params.value)
              //       }
              //     }
              //   }
              // },
              data: cost_CV
            },
            {
              name: 'AC',
              type: 'line',
              itemStyle: {
                normal: {
                  // label: { show: true,
                  //   formatter: (params) => {
                  //     return '¥' + me.convert(params.value)
                  //   }
                  // },
                  color: '#0000FF',
                  lineStyle: {
                    color: '#0000FF'
                  }
                }
              },
              data: cost_AC
            },
            {
              name: 'EV',
              type: 'line',
              itemStyle: {
                normal: {
                  // label: { show: true,
                  //   formatter: (params) => {
                  //     return '¥' + me.convert(params.value)
                  //   }
                  // },
                  color: '#FF9900',
                  lineStyle: {
                    color: '#FF9900'
                  }
                }
              },
              data: cost_EV
            }
          ]
        }
        console.log('option1', this.option1)
        this.option2 = {
          title: {
            text: '进度曲线',
            top: '20px',
            textStyle: {
              fontSize: 16
            }
          },
          tooltip: {
            trigger: 'axis',
            formatter(params) {
              // console.log('params', params)
              if (params.length === 3) {
                var relVal1 = params[0].name + '<br/>'
                relVal1 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[2]['marker'] + params[2]['seriesName'] + ' : ' + params[2]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal1
              } else if (params.length === 2) {
                var relVal2 = params[0].name + '<br/>'
                relVal2 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>'
                return relVal2
              } else if (params.length === 1) {
                var relVal3 = params[0].name + '<br/>'
                relVal3 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal3
              } else {
                return ''
              }
            }
          },
          legend: {
            // x: '200px',
            y: '20px',
            data: ['SV', 'PV', 'EV']
          },
          grid: {
            left: '3%',
            right: '4%',
            bottom: '8%',
            containLabel: true
          },
          xAxis: {
            type: 'category',
            boundaryGap: true,
            axisLabel: {
              interval: 0,
              formatter: function(value) {
                let valueText = ''
                if (value.length > 10) {
                  valueText = value.substring(0, 10) + '\n' + value.substring(10)
                } else {
                  valueText = value
                }
                return valueText
              }
            },
            data: progress_X
          },
          yAxis: {
            type: 'value'
          },
          dataZoom: [
            {
              start: 0, // 默认为0
              end: endValue2, // 默认为100
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
          ],
          series: [
            {
              name: 'SV',
              type: 'line',
              // itemStyle: {
              //   normal: {
              //     label: { show: true,
              //       formatter: (params) => {
              //         return '¥' + me.convert(params.value)
              //       }
              //     }
              //   }
              // },
              data: progress_SV
            },
            {
              name: 'PV',
              type: 'line',
              itemStyle: {
                normal: {
                  // label: { show: true,
                  //   formatter: (params) => {
                  //     return '¥' + me.convert(params.value)
                  //   }
                  // },
                  color: '#0000FF',
                  lineStyle: {
                    color: '#0000FF'
                  }
                }
              },
              data: progress_PV
            },
            {
              name: 'EV',
              type: 'line',
              itemStyle: {
                normal: {
                  // label: { show: true,
                  //   formatter: (params) => {
                  //     return '¥' + me.convert(params.value)
                  //   }
                  // },
                  color: '#FF9900',
                  lineStyle: {
                    color: '#FF9900'
                  }
                }
              },
              data: progress_EV
            }
          ]
        }
        console.log('option2', this.option2)
        this.option3 = {
          title: {
            text: '完工偏差(典型)',
            top: '20px',
            textStyle: {
              fontSize: 16
            }
          },
          tooltip: {
            trigger: 'axis',
            formatter(params) {
              // console.log('params', params)
              if (params.length === 3) {
                var relVal1 = params[0].name + '<br/>'
                relVal1 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[2]['marker'] + params[2]['seriesName'] + ' : ' + params[2]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal1
              } else if (params.length === 2) {
                var relVal2 = params[0].name + '<br/>'
                relVal2 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>'
                return relVal2
              } else if (params.length === 1) {
                var relVal3 = params[0].name + '<br/>'
                relVal3 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal3
              } else {
                return ''
              }
            }
          },
          legend: {
            // x: '200px',
            y: '20px',
            data: ['典型VAC', '典型EAC', 'BAC']
          },
          grid: {
            left: '3%',
            right: '4%',
            bottom: '8%',
            containLabel: true
          },
          xAxis: {
            type: 'category',
            boundaryGap: true,
            axisLabel: {
              interval: 0,
              formatter: function(value) {
                let valueText = ''
                if (value.length > 10) {
                  valueText = value.substring(0, 10) + '\n' + value.substring(10)
                } else {
                  valueText = value
                }
                return valueText
              }
            },
            data: WGPC_YES_X
          },
          yAxis: {
            type: 'value'
          },
          dataZoom: [
            {
              start: 0, // 默认为0
              end: endValue3, // 默认为100
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
          ],
          series: [
            {
              name: '典型VAC',
              type: 'line',
              // itemStyle: {
              //   normal: {
              //     label: { show: true,
              //       formatter: (params) => {
              //         return '¥' + me.convert(params.value)
              //       }
              //     }
              //   }
              // },
              data: WGPC_YES_VAC
            },
            {
              name: '典型EAC',
              type: 'line',
              itemStyle: {
                normal: {
                  // label: { show: true,
                  //   formatter: (params) => {
                  //     return '¥' + me.convert(params.value)
                  //   }
                  // },
                  color: '#0000FF',
                  lineStyle: {
                    color: '#0000FF'
                  }
                }
              },
              data: WGPC_YES_EAC
            },
            {
              name: 'BAC',
              type: 'line',
              itemStyle: {
                normal: {
                  // label: { show: true,
                  //   formatter: (params) => {
                  //     return '¥' + me.convert(params.value)
                  //   }
                  // },
                  color: '#FF9900',
                  lineStyle: {
                    color: '#FF9900'
                  }
                }
              },
              data: WGPC_YES_BAC
            }
          ]
        }
        console.log('option2', this.option2)
        this.option4 = {
          title: {
            text: '完工偏差(非典型)',
            top: '20px',
            textStyle: {
              fontSize: 16
            }
          },
          tooltip: {
            trigger: 'axis',
            formatter(params) {
              // console.log('params', params)
              if (params.length === 3) {
                var relVal1 = params[0].name + '<br/>'
                relVal1 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[2]['marker'] + params[2]['seriesName'] + ' : ' + params[2]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal1
              } else if (params.length === 2) {
                var relVal2 = params[0].name + '<br/>'
                relVal2 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>' + params[1]['marker'] + params[1]['seriesName'] + ' : ' + params[1]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元' + '<br/>'
                return relVal2
              } else if (params.length === 1) {
                var relVal3 = params[0].name + '<br/>'
                relVal3 += params[0]['marker'] + params[0]['seriesName'] + ' : ' + params[0]['value'].toFixed(2).replace(/(\d{1,3})(?=(\d{3})+(?:$|\.))/g, '$1,') + '元'
                return relVal3
              } else {
                return ''
              }
            }
          },
          legend: {
            // x: '200px',
            y: '20px',
            data: ['非典型VAC', '非典型EAC', 'BAC']
          },
          grid: {
            left: '3%',
            right: '4%',
            bottom: '8%',
            containLabel: true
          },
          xAxis: {
            type: 'category',
            boundaryGap: true,
            axisLabel: {
              interval: 0,
              formatter: function(value) {
                let valueText = ''
                if (value.length > 10) {
                  valueText = value.substring(0, 10) + '\n' + value.substring(10)
                } else {
                  valueText = value
                }
                return valueText
              }
            },
            data: WGPC_NO_X
          },
          yAxis: {
            type: 'value'
          },
          dataZoom: [
            {
              start: 0, // 默认为0
              end: endValue4, // 默认为100
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
          ],
          series: [
            {
              name: '非典型VAC',
              type: 'line',
              // itemStyle: {
              //   normal: {
              //     label: { show: true,
              //       formatter: (params) => {
              //         return '¥' + me.convert(params.value)
              //       }
              //     }
              //   }
              // },
              data: WGPC_NO_VAC
            },
            {
              name: '非典型EAC',
              type: 'line',
              itemStyle: {
                normal: {
                  // label: { show: true,
                  //   formatter: (params) => {
                  //     return '¥' + me.convert(params.value)
                  //   }
                  // },
                  color: '#0000FF',
                  lineStyle: {
                    color: '#0000FF'
                  }
                }
              },
              data: WGPC_NO_EAC
            },
            {
              name: 'BAC',
              type: 'line',
              itemStyle: {
                normal: {
                  // label: { show: true,
                  //   formatter: (params) => {
                  //     return '¥' + me.convert(params.value)
                  //   }
                  // },
                  color: '#FF9900',
                  lineStyle: {
                    color: '#FF9900'
                  }
                }
              },
              data: WGPC_NO_BAC
            }
          ]
        }
        console.log('option2', this.option2)
        this.init('dataTable1', 1)
        this.init('dataTable2', 2)
        this.init('dataTable3', 3)
        this.init('dataTable4', 4)
      })
    }
  }
}
</script>

<style>
.min-w {
  min-width: 1200px;
}
.mt-5 {
  margin-top: 5px;
}
.mt-10 {
  margin-top: 10px;
}
.mt-20 {
  margin-top: 20px;
}
.ml-10 {
  margin-left: 10px;
}
.mr-10 {
  margin-right: 10px;
}
.fr {
  float: right;
}
.fl {
  float: left;
}
.box {
  width: 100%;
  margin-top: 10px;
}
.ulBox {
  font-size: 14px;
  display: table;
  border-collapse: collapse;
  margin: 0 auto;
  width: 100%;
  min-width: 1200px;
  list-style: none;
  margin-top: -1px;
  margin-bottom: -1px;
}
.ulBox>li {
  display: table-cell;
  /* float: left; */
  text-align: center;
  vertical-align: middle;
  /* line-height: 20px; */
  box-sizing: border-box;
  min-width: 100px;
  max-width: 100px;
  height: 30px;
  border: 1px solid #ccc;
  margin: 0 0 -1px -1px;
  list-style: none;
}
.ulBox>li:nth-of-type(5) {
  min-width: 180px;
  max-width: 180px;
}
.ulBox>li:nth-child(odd) {
  background: #F5F7FA;
}
.el-dialog__body {
  padding-top: 5px;
}
.month {
  width: 26px;
  height: 26px;
  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAGaADAAQAAAABAAAAGQAAAABY85deAAADX0lEQVRIDcWVT0iTYRzH5+bMIVrmdEqZSBOdTrF/1IiISDA6RARBF7vULQ9BUFiHslOXwsxDBB7qUFQeiiD6B3mJAhsiuvmng0kIsqm5hitzzj6/lz3yvG3NvNQLz/v79/39eX6/531ei+UfPFl/k6O+vr4wkUjss1qtW8ALH4UfX1hYeDc2Nja9WoyMSQi+f3l5+SJBDrDsaYIlsrKyXqG/Pjg4+CaN3VClTdLY2LghHo93gzjGihDoCdW/oPoJaBhaDK2AHqKIo2DWg+nJyck57ff7I0Zk7ZWSpKGhoZIAz8FUs26R7OrIyMiM5mNia2pqirKzsy+jbGWN2Wy2gwMDA5M6yJTE7XYX5ObmvgdQSYUnA4FAjw7OxNPa4/jcBTO+uLi4Z3R0NKrwVsUIdTgctyGetSYQX2byWPzE3263d4gu5amtrd3t9XoTrJspxjUo8O+UOMTbptyyFcMQz8N/kxkonaK0ooYqPyKPKB2DzkW3bmhoqErphOLfzlzcsDlKbyTx+XyOaDTaLCckw5AHCehTjpIY/pmSFU36H66rqzMnmZ+f3wkoj1P1UoHT0Cra8EjT52u8iQXnQvGZQk4xq/vGTpaWljaxCwvbHDehzcInMHeUioK8yNKWlMfpdM5MT0/foHV9YjSSAC4UATorNN1D/xexf1U2+JUjqnSK9vb2xuEvKdlIQoAwThboRmXQKVU7sVdjv6bp8zQ+I6uSfJEktK0S9Ic0HlvRdTN4uceMJ3niUgYvRm6N7cTqoLiW4eHhCeNjLCkp8WOb4Rg3GxF+e6E/wS5eK3VysCVKTkcpOoHfgsmGYzdrTu4i3SDHm6pXBi425Atg+1htOnZVnnPtxuknq3NVcAYABTQRa5cOsSkhHA7P0rYC5LPFxcUB5KCyrYW6XC65VOtDodBD5We6IDnfbfTyLeseFR1XoLVQht3ELFp0H9NVL4bkD0u+7CZWl9xFGa4acbHQniMU1sXtu6O/vz9sKLXXSruUbmpq6gc36INYLCa2Vqo6Qxs9tNBRWlqaD43Ryu9yTNl5OfxkWVmZ/JqLIpHI07m5OfkQTU/KTnQrh6Ac+RxLfrEVSVs738sVbL3Idvi9Sf0fScYkupfH46liV5v5XkLBYDBAi0rFzt9zSsf9N/4XywFRUuTjYzsAAAAASUVORK5CYII=');
  background-repeat: no-repeat;
  background-position: center;
  background-size:100% 100%;
  -moz-background-size:100% 100%;
}
.monthOn {
  width: 26px;
  height: 26px;
  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAGaADAAQAAAABAAAAGQAAAABY85deAAADp0lEQVRIDc1VTWhUVxQ+5743MUU0mZkkLoyV1Jkkohu1pYpIEQNKF1KKBTcWREGchCAIFnVhdFUKtf5MXrSShS5cxCwqglhb0I201HZVijovmoSQTZKZUcfGODPvHs99zo13Ms9JsykeeHP+z/fmnnPPA/gfCP8LRp0zGg5Bfgshfkggw0CYQwnD+ZC8lzvQNjVfjaog9Y77mQA4xkW28hMKKCbZdhuBvk8nWn8N8PumQJD6H4brxSKvH4C+5KhnzH8iFLcQadTycNKzqJEIVyLJHQD4BcfUAcIgCbE/e2AVx5dTBUjd+YctlrBuclIbH8v5AhVO5bpWp8vT3mpLkg+itrBOIGAXA6YQvW3pg23jbyPYaiqRc+5SsOE3trUAwdeZzvig6a8mRxz3K/Zf5meYT2Hj1L72nI7nIzcohBdYW71QAFUhk4hfU3kqX85YZ5StgqLJ1Kf8NjLSO3S2wrkAQ9hJnVN16vvcdTrN1gI37Qg3+LnqgbZpHr34qJ088SfrD7WNeS0BLMom4nHDBkXpnQwJO2Z5VKPtPkjz6bEPpmFmO4MMVmny33wkm3RiCfiG1jUv5X8OA/+Ug/xbO/0xglhMBD/r4AAe52MY0HbyYImW5/KmS0+WFae8EXJS+7KJ1qtvjgut5cAIiDg8N8HQXb50P2qdo9eyHNO6ySfGR9PhpubTPNr3lb3UEworRUiRUTyYsMB3Iat9RJQrvwDaw7xna5EDj2uLD8J7aFIlSCEj2mFyWbQbEGWbBPzWsC825KriGxCiMV5+fGLUwtG/z80QSKt4SfVnEzG1x3x6V+OVsyHprpcCz0gp9jzt+mjUv4zpqfG/2JdmHJ6wSiKg3RbhL9qjGusVsEnrQZxfWYYQX5X5Ir1uP0/PU7WLTIca70ifO9tw5Qs77jccfz/quEfN2Hnlxt6hGIPk1Y2dN7hKQNRJdUR7H39ihszursnO2BBfxrNqm/Jb7jKDFibjdwRe2T+cBVGFMhPjynmHJ+0K/yu1VRdMhZp8R2j65R4zsWzVK4f/waopDjBQBzc8qXZRlVXj12pw3J08fcl8ETa86I5PmgBKrgDxA3ru2OFly3uQ8DDrr3gRXuf5voUWjhTt/KPn+9dk1JiSJW3+QP0R7htay9PUvbTW7h7Z2zLj1zB+gkFKAbz2V4CAwwygPrErfTPBSf6Y9fBk3WXwEC/NzUa9QLG0VgJ9kOmMjbHnkHoaLzyOk0fNkmhCRQuydyv+3tBr1uVgHK1611AAAAAASUVORK5CYII=');
  background-repeat: no-repeat;
  background-position: center;
  background-size:100% 100%;
  -moz-background-size:100% 100%;
}
.week {
  width: 26px;
  height: 26px;
  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAGaADAAQAAAABAAAAGQAAAABY85deAAADp0lEQVRIDcWVW0iUURDHXd01F1EzXVdTM2sjV12RLEqiQrK0oIiil6Be8i2hIgoqouwxKCqFLhBRL1EJXR6iootE0UOZeFlRg0RKMHcVt0XNXNd+87Fn+VzXVV/qwPlmzsx/Zs6ZmXO+qKh/MAxzieFwOJL9fv+G6OjoJeCF98J3j42Nfejq6nLP5iNiEJxvmpycPIWTMqYpjDO/wWB4ifxia2vrqzB6TRQ2SHFx8UKfz3cLxG6mB0eP2f1zdt8DdUEt0BxoJZvYBSYJTH1sbGxVY2OjR/Os+0wLUlRUlIuDZ2BWMmsJdr6jo2NAZzOFzcvLSzEajWcRVjO7YmJiNjc3N/fqQVOC2Gy2xLi4uI8ActnhAafTWa8HR+JJ7V5s7oDpHh8fX9fZ2elV+GjFCDWbzdch9vkGEFtq8lDsxN5kMl0WmRrBk+Tn568lx3KK2ra2tsMKQPriMbaqdSilFj9bWlqGlbywsPAqfDUpL2lvb28SuVEpCXAC/pfUQMmETkxMbMPRBdjPenmAd+DsDHwwrdjXUBcbsliF14KUlpaavV5vhXTIDEV+jcEN9FKra/BHoT+gW5UjRQP22wsKCoJBtJoMDw+vBhTPrl4ocCglgAXZMqYRfiknXxyKUWtSZgXjoRn2iUw7CSnJRBjFMbsVMJSy84PIkphx8GXQjdh8hQ+FRqWmpg643e5LpO6TKLUggJNlAR0Uqh/sOAFHo8huo8+E3hQ9siHIFuFDR0NDgw/ZaSXXgmDgwoEYLlIKRZFloHOTyh3ISlh3s5ZU+eA7FC4S1WoC+LuASFtuGHAeAdoD8m+crBG+MwwuKKLtV1H4d3a7PUeEWpC0tDQxHMBBRRAJE+iQStg3zEec4EtA3wN9zzoLOr0oCNH58TcmeIN8ZNAR8iDuoVjLVRvLReQUVVzOKxoo8OH5WcDz85TlII6OcxmlnWcf7NpGoD+BGzu7wQwI2rYcX2v06hi1cLlcg6QtkfURi8XiZK3qoCBzolarVW6/o7+//74y0GqiFvT3SXL5lnlXXlUlnw8lveWkcL/eJlgTJQz8sB6wLmfWyVukaqQwoZT07GRjdby+JU1NTa5QfTBdStHX1/ebF/neyMiI6KrZ1SHSaCeF5vT09AToCKkclTbl5NnwvRkZGfJrTvF4PE+GhobkIk4Z006i19IE2ayPMeUXq/U8tIZuO4euAd4Evx4acUQMorfkYq3gVFlc3H7+E05SlC56/p59etx/4/8CUMB0rkI7geQAAAAASUVORK5CYII=');
  background-repeat: no-repeat;
  background-position: center;
  background-size:100% 100%;
  -moz-background-size:100% 100%;
}
.weekOn {
  width: 26px;
  height: 26px;
  background-image: url('data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABkAAAAZCAYAAADE6YVjAAAAAXNSR0IArs4c6QAAAERlWElmTU0AKgAAAAgAAYdpAAQAAAABAAAAGgAAAAAAA6ABAAMAAAABAAEAAKACAAQAAAABAAAAGaADAAQAAAABAAAAGQAAAABY85deAAAEEElEQVRIDc1Va2hcRRQ+Z+7dPGmT3W0MNtEam21aVASjKIhIMGoVFPEBIihKA6VNiUqpoCKm/qxYbbrZVqWI/qwBHz+kiloRpaBW8YfaZrfZhjY/muzePmIe3b13jt/c7t3eTTc1/SMO3J3z+M58O+ecmSH6DwYvhaMpNR6NUOEuYb5WSEdJeJo1ZQsR/eP0xq7cv61xWZLmVPpuRfQKFunBF6mymIbtKyZ5K795zddV/L6pKknz29lmVevtI5JHgTqL+VNhdYBZxi2PpzxLWkR4FYteT8SPANNETCOiVN/pjauBrxyXkDTtPtJhKesLBHUhLbuLUnxjesu6fGXYRW1Z8q+4razXmXgLCEeZvXvym7omLiJgDSuxofRysukQbB0k9IzTnxgJ+y8nx1LpJ+D/EF8WWbgjt2HtdIBHykMjwnuhrbtSArOCsznxsYkz8XreesfYglHeSTw5ersoPmRS5PR3Ph8AWt/8vXG+sb410BfOdTNzp05tu3kmsEdTo0MmdZqp+8ymxG/GbgdOFO0lFPicqUFgM3OxoeEBi2gHxF/Cdl8Wugn+1yCX0+pqb3tE2Z2WJzUB3idp33mifpbm7wfJyCJF/kYp9a7WugOBe5jpRdZ8Ukjuk2Cl0lyKf5D2/1Em8WsyUzd7KzCNIvTlgpiy6mm0LdH1MNhY/DpPycqyc4Fw1ftjrbFczVmk7injulB4ttqMwsxZM1cbOHAbkOteFLEOZ6SHhZ9FbzZVw05OjOfxh3aitX82/lJNJGoUpZVj5orBsgwBcyzqA2Jpg/ye3y1KnxGt7kWKK+C+MtjjniZ6NXD4JLiHpsyJ0UrHAkcw499fDTmHnTyEdHaDKAvbSq3ZVSJHqlAEoeXZTxeLnDAWETGFrRi4nNbiz/55wchj2O9hkB2tAC1QViTTt8RSme+bk2OrjMsnyecmDkPOo2vQYaGBDgFgvVtb+Ba5/AS7/dV4UbtxfD9AbydsJxRRFrFzHWE+7+MDa2w4vQ9BjxW1uzpoY3MQiw31fU7/ml0Bzp+H0rUxmz7H3h1yeZszkDhZ4V9MaRnOdOL+KZgTuxhmKfZ4arQ3PnzstjDWT5cxTPV3ZvDPdpkrAbt6PAy6Mpl3CHkvh2PKJMboTE4Y50Gk7aPSrRrGLkku1hR6I7NzT4fBfsuHDf6DVePuB1EvTnbS3EVBjcK4sLwilX4YXZgsuNT990BiKuwz8iUkPmDwoB1tbRvEqd4K/Tza5zP09wG2+LhrF46e67vBMW0qlrbxQP0U3ZO5Ed00sLzOHjj+XMe8v0bopzpJCRAbzlyDJt8KAvPE+j2PM7Mdj9lgPJX+DuQRvCN3htarKpaulao+wrtiDukL5mvZeywhnrRrkUmDVmI/aeb/zfgHQQB7Ov9gOaYAAAAASUVORK5CYII=');
  background-repeat: no-repeat;
  background-position: center;
  background-size:100% 100%;
  -moz-background-size:100% 100%;
}
.noneBox{
  position: relative;
  height: calc(100vh - 110px);
  width: 100%;
}
.noneData{
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%,-50%);
    color: #909399;
    font-size: 14px;
  }
</style>
