<template>
  <div ref="gantt" />
</template>
<script>
import 'dhtmlx-gantt'
// import './tooltip'
import './screenFull'
import './zoom_to_fit'
import { mapGetters } from 'vuex'

export default {
  name: 'Gantt',
  props: {
    tasks: {
      type: Object,
      default() {
        return { data: [], links: [] }
      }
    },
    gantColumns: {
      type: Array,
      default: function() { return [] }
    },
    dragBranchFree: {
      type: Boolean,
      default: true
    },
    // task图是否可以拖拽移动日期
    dragMoveDate: {
      type: Boolean,
      default: false
    },
    // task图是否可以拖拽改变工期
    dragResizeDate: {
      type: Boolean,
      default: false
    },
    filter: {
      type: Function,
      default: null
    },
    beforeTaskSelected: {
      type: Function,
      default: null
    },
    moverow: {
      type: Function,
      default: null
    },
    withOutGrid: {
      type: Boolean,
      default: false
    },
    withOutGant: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      ganttObj: null,
      init: false,
      isActive: false,
      gridWidth: 1,
      gantWidth: 1,
      zoomConfig: {
        levels: [
          {
            name: 'hours',
            scales: [
              { unit: 'day', step: 1, format: '%M%d日' },
              { unit: 'hour', step: 1, format: '%h' }
            ],
            round_dnd_dates: true,
            min_column_width: 100,
            scale_height: 60
          },
          {
            name: 'days',
            scales: [
              { unit: 'month', step: 1, format: '%M' },
              { unit: 'week', step: 1, format: '第%W周' },
              { unit: 'day', step: 1, format: '%D' }
            ],
            round_dnd_dates: true,
            min_column_width: 100,
            scale_height: 60
          },
          {
            name: 'weeks',
            scales: [
              { unit: 'year', step: 1, format: '%Y' },
              { unit: 'month', step: 1, format: '%M' },
              { unit: 'week', step: 1, format: '%W' }
            ],
            round_dnd_dates: false,
            min_column_width: 100,
            scale_height: 60
          },
          {
            name: 'months',
            scales: [
              { unit: 'year', step: 1, format: '%Y' },
              { unit: 'month', step: 1, format: '%M' }
            ],
            round_dnd_dates: false,
            min_column_width: 100,
            scale_height: 60
          },
          {
            name: 'quarters',
            scales: [
              { unit: 'year', step: 1, format: '%Y' },
              { unit: 'quarter', step: 1, format: function quarterLabel(date) {
                var month = date.getMonth()
                var q_num

                if (month >= 9) {
                  q_num = 4
                } else if (month >= 6) {
                  q_num = 3
                } else if (month >= 3) {
                  q_num = 2
                } else {
                  q_num = 1
                }

                return '第' + q_num + '季度'
              } },
              { unit: 'month', step: 1, format: '%M' }
            ],
            round_dnd_dates: false,
            min_column_width: 50,
            scale_height: 60
          },
          {
            name: 'years',
            scales: [
              { unit: 'year', step: 1, format: '%Y' }
            ],
            round_dnd_dates: false,
            min_column_width: 50,
            scale_height: 60
          },
          {
            name: 'years-quarters',
            scales: [
              { unit: 'year', step: 1, format: '%Y' },
              { unit: 'quarter', step: 1, format: function quarterLabel(date) {
                var month = date.getMonth()
                var q_num

                if (month >= 9) {
                  q_num = 4
                } else if (month >= 6) {
                  q_num = 3
                } else if (month >= 3) {
                  q_num = 2
                } else {
                  q_num = 1
                }

                return '第' + q_num + '季度'
              } }
            ],
            round_dnd_dates: false,
            min_column_width: 50,
            scale_height: 60
          },
          {
            name: 'quarters-months',
            scales: [
              { unit: 'quarter', step: 1, format: function quarterLabel(date) {
                var month = date.getMonth()
                var q_num

                if (month >= 9) {
                  q_num = 4
                } else if (month >= 6) {
                  q_num = 3
                } else if (month >= 3) {
                  q_num = 2
                } else {
                  q_num = 1
                }

                return '第' + q_num + '季度'
              } },
              { unit: 'month', step: 1, format: '%M' }
            ],
            round_dnd_dates: false,
            min_column_width: 50,
            scale_height: 60
          }
        ]

      }
    }
  },
 
  watch: {

    withOutGrid(v) {
      this.resetLayout()
    },
    withOutGant(v) {
      this.resetLayout()
    },
    dragBranchFree(v) {
      this.setDragBranchFree()
      gantt.init(this.$refs.gantt)
    },
    dragMoveDate(v) {
      this.setDargMoveDate()
      gantt.render()
    },
    dragResizeDate() {
      this.setDragResizeDate()
      gantt.render()
    },
    gantColumns: {
      handler(newV, oldV) {
        this.initGant()
      }
    },
    tasks: {
      handler(newValue, oldValue) {
        if (this.init) {
          gantt.clearAll()
          gantt.parse(this.$props.tasks)
          gantt.init(this.$refs.gantt)
          this.$emit('initOver')
        }
      },
      deep: true,
      immediate: true
    }

  },
  mounted() {
    this.ganttObj = gantt
    this.$nextTick(() => {
      window.onresize = () => {
        return (() => {
          this.initGant()
        })()
      }
    })
  },
  beforeDestroy() {
    // gantt.ext.tooltips.delayHide()
    // gantt.ext.tooltips.detach('[task_id]:not(.gantt_task_row)')
    gantt.clearAll()
  },
  methods: {
    resetLayout(init){
   this.gridWidth = 1
      this.gantWidth = 0
      let layout = {}
      if (this.withOutGrid) {
        this.gridWidth = 1
        this.gantWidth = this.$refs.gantt.clientWidth
        layout = {
          css: 'gantt_container',
          cols: [
            {
              width: this.gridWidth,
              min_width: this.gridWidth,
              rows: [
                { view: 'grid', scrollX: 'gridScroll', scrollable: true, scrollY: 'scrollVer' },
                { view: 'scrollbar', id: 'gridScroll', group: 'horizontal' }
              ]
            },
            { resizer: true, width: 0 },
            {
              width: this.gantWidth,
              min_width: this.gantWidth,
              rows: [
                { view: 'timeline', scrollX: 'scrollHor', scrollY: 'scrollVer' },
                { view: 'scrollbar', id: 'scrollHor', group: 'horizontal' }
              ]
            },
            { view: 'scrollbar', id: 'scrollVer' }
          ]
        }
      } else if (this.withOutGant) {
        this.gridWidth = this.$refs.gantt.clientWidth
        this.gantWidth = 0
            layout = {
          css: 'gantt_container',
          cols: [
            {
              width: this.gridWidth,
              min_width: this.gridWidth,
              rows: [
                { view: 'grid', scrollX: 'gridScroll', scrollable: true, scrollY: 'scrollVer' },
                { view: 'scrollbar', id: 'gridScroll', group: 'horizontal' }
              ]
            },
            { resizer: true, width: 0 },
            {
              width: this.gantWidth,
              min_width: this.gantWidth,
              rows: [
                { view: 'timeline', scrollX: 'scrollHor', scrollY: 'scrollVer' },
                { view: 'scrollbar', id: 'scrollHor', group: 'horizontal' }
              ]
            },
            { view: 'scrollbar', id: 'scrollVer' }
          ]
        }
      } else {
        this.gridWidth = (this.$refs.gantt.clientWidth) / 2,
        this.gantWidth = (this.$refs.gantt.clientWidth) / 2
        layout = {
          css: 'gantt_container',
          cols: [
            {
              width: this.gridWidth,
              min_width: this.gridWidth,
              rows: [
                { view: 'grid', scrollX: 'gridScroll', scrollable: true, scrollY: 'scrollVer' },
                { view: 'scrollbar', id: 'gridScroll', group: 'horizontal' }
              ]
            },
            { resizer: true, width: 0 },
            {
              rows: [
                { view: 'timeline', scrollX: 'scrollHor', scrollY: 'scrollVer' },
                { view: 'scrollbar', id: 'scrollHor', group: 'horizontal' }
              ]
            },
            { view: 'scrollbar', id: 'scrollVer' }
          ]
        }
      }
      gantt.config.grid_width = this.gridWidth
      gantt.config.layout = layout
      const colLength = this.gantColumns.length
      this.gantColumns.forEach(colItem => {
        if(colItem.hasOwnProperty('min_width')){
          delete colItem.min_width
        }
         if(colLength === 2) {
            if(colItem.label === '序号'){
           colItem.width = 100
          }else if(colItem.label ==='名称'){
            colItem.width = this.gridWidth - 100
          }
        }else if(colLength>2 && colLength<=5){
         if(colItem.label === '序号'){
            colItem.width = 70
          }else if(colItem.label ==='名称') {
            colItem.width = 300
          }else {
            colItem.width = (this.gridWidth-370)/(colLength-2)
          }
        }else if(colLength>5){
          if(colItem.label === '序号'){
            colItem.width = 70
          }else if(colItem.label ==='名称') {
            colItem.width = 300
          }else {
               if(!this.withOutGant){
                  colItem.width = (this.gridWidth-370)/3
                }else {
                    colItem.width = (this.gridWidth-370)/(colLength-2)
                }
          }
        }
        // else {
        //   if(){
        //    colItem.width = this.gridWidth/3
        //   }else {
        //     if(this.gantColumns.length>2){
        //      colItem.width = this.gridWidth/this.gantColumns.length-2
        //     }else{

        //     }
        //   }
        // }
      });
      try {
        gantt.resetLayout();
      } catch (error) {
      }
    },
    initGant() {
      this.localCN()
      this.setColumn()
      this.setDateScale()
      this.setDragBranchFree()
      this.setDargMoveDate()
      this.setDragResizeDate()
      gantt.config.tooltip_timeout = 50
      gantt.init(this.$refs.gantt)
      gantt.parse(this.$props.tasks)
      this.$emit("initOver")
      this.init = true
    },
    setDragBranchFree() {
      gantt.config.order_branch = this.dragBranchFree
      gantt.config.order_branch_free = this.dragBranchFree
    },
    setDargMoveDate() {
      gantt.config.drag_move = this.dragMoveDate
    },
    setDragResizeDate() {
      gantt.config.drag_resize = this.dragResizeDate
    },
    deactivate() {
      this.isActive = false
    },
    setZoom(level) {
      this.isActive = true
      gantt.ext.zoom.setLevel(level)
    },
    zoomOut(filt) {
      this.isActive = true
      if (this.canZoomOut() || filt) {
        gantt.ext.zoom.zoomOut()
        gantt.render()
      }
    },
    zoomIn(filt) {
      this.isActive = true
      if (this.canZoomIn() || filt) {
        gantt.ext.zoom.zoomIn()
        gantt.render()
      }
    },
    canZoomOut() {
      var level = gantt.ext.zoom.getCurrentLevel()
      return !this.isActive || !(level > 4)
    },
    canZoomIn() {
      var level = gantt.ext.zoom.getCurrentLevel()
      return !this.isActive || !(level === 0)
    },

    setColumn() {
      const me = this
      gantt.config.task_height = 25
      gantt.config.fit_tasks = true
      // tree全部展开
      gantt.config.open_tree_initially = true
      // 详情界面弹出
      gantt.config.details_on_dblclick = false
      // 禁止连线
      gantt.config.drag_links = false
      // 进度百分比禁止
      gantt.config.drag_progress = false
      // 暂不支持
      // gantt.config.grid_resize = true
      gantt.templates.task_end_date = function(date) {
        return gantt.templates.task_date(new Date(date.valueOf() - 1))
      }

      var gridDateToStr = gantt.date.date_to_str('%Y-%m-%d')
      gantt.templates.grid_date_format = function(date, column) {
        if (column === 'end_date') {
          return gridDateToStr(new Date(date.valueOf() - 1))
        } else {
          return gridDateToStr(date)
        }
      }
      gantt.templates.task_text = function(start, end, task) {
        return ''
      }
      gantt.templates.rightside_text = function(start, end, task) {
        return task.text
      }
      gantt.attachEvent('onTaskDblClick', function(id, e) {
        me.$emit('doubleClick', { id, id, event })
      })
      gantt.attachEvent('onTaskCreated', function(obj, e) {
        me.$emit('addTask', { obj, event })
      })
      gantt.attachEvent('onTaskRowClick', function(id, row) {
        me.$emit('clickRow', { id, row })
      })
       gantt.attachEvent('onAfterTaskUpdate', function(id, row) {
        me.$emit('updateRow', { id, row })
      })
      gantt.attachEvent('onBeforeTaskMove', function(id, parent, tindex) {
        if (me.moverow) {
          var resultmsg = this.moverow(id, parent, tindex)
          return resultmsg
        } else {
          return true
        }
      })
      gantt.attachEvent('onBeforeTaskDisplay', function(id, task) {
        if (me.filter) {
          var resultmsg = me.filter(id, task)
          return resultmsg
        } else {
          return true
        }
      })
      //注释掉为什么还是有提示。。？？？
     	// gantt.attachEvent('onGanttReady', function() {
      //   if (!me.withOutGant) {
      //     var tooltips = gantt.ext.tooltips
      //     tooltips.tooltip.setViewport(gantt.$task_data)
      //   } else {
      //     var tooltips = gantt.ext.tooltips
      //     tooltips.tooltip.setViewport(gantt.$task_data)
      //   }
      // })
      gantt.ext.fullscreen.getFullscreenElement = function() {
        return me.$refs.gantt
      }
       this.resetLayout(true)
      gantt.config.columns = this.gantColumns
     
    },
    setDateScale() {
      gantt.ext.zoom.init(this.zoomConfig)
      gantt.ext.zoom.setLevel('months')
    },
    localCN() {
      gantt.locale = {
        date: {
          month_full: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
          month_short: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
          day_full: ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六'],
          day_short: ['日', '一', '二', '三', '四', '五', '六']
        },
        labels: {
          dhx_cal_today_button: '今天',
          day_tab: '日',
          week_tab: '周',
          month_tab: '月',
          new_event: '新建日程',
          icon_save: '保存',
          icon_cancel: '关闭',
          icon_details: '详细',
          icon_edit: '编辑',
          icon_delete: '删除',
          confirm_closing: '请确认是否撤销修改!', // Your changes will be lost, are your sure?
          confirm_deleting: '是否删除日程?',
          section_description: '描述',
          section_time: '时间范围',
          section_type: '类型',
          /* grid columns */
          column_text: '任务名',
          column_start_date: '开始时间',
          column_duration: '持续时间',
          column_add: '',
          /* link confirmation */
          link: '关联',
          confirm_link_deleting: '将被删除',
          link_start: ' (开始)',
          link_end: ' (结束)',
          type_task: '任务',
          type_project: '项目',
          type_milestone: '里程碑',
          minutes: '分钟',
          hours: '小时',
          days: '天',
          weeks: '周',
          months: '月',
          years: '年'
        }
      }
    }
  }
}
</script>

<style>
    @import "~dhtmlx-gantt/codebase/dhtmlxgantt.css";
    .gantt_tree_content{
      width:100%;
      text-overflow: ellipsis; 
      white-space: nowrap;
      overflow: hidden;
      height: 100%;
      display: inline-block;
    }
</style>
