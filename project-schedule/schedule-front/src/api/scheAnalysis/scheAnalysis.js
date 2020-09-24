import request from '@/utils/request'

export function getReport(params) {
  return request({
    url: '/project-schedule/progressAnalysis/getReport',
    method: 'get',
    params
  })
}

export function getResourceStatisticsInfo(params) {
  return request({
    url: '/project-schedule/progressAnalysis/statistics',
    method: 'get',
    params
  })
}

export function getResource(params) {
  return request({
    url: '/project-schedule/progressAnalysis/queryResourceList',
    method: 'get',
    params
  })
}

export function getEarnedValue(params) {
  return request({
    url: '/project-schedule/progressAnalysis/getEarnedValue',
    method: 'get',
    params
  })
}

export function getEarnedValueChart(params) {
  return request({
    url: '/project-schedule/progressAnalysis/getEarnedValueChart',
    method: 'get',
    params
  })
}

export function getProgressBoardInfo(data) {
  return request({
    url: 'project-schedule/sche/getProgressBoardInfo',
    method: 'post',
    data,
    timeout: 600000
  })
}

// 是否已经进行填报填报
export function whetherReport(params) {
  return request({
    url: '/project-schedule/progressAnalysis/whetherReport',
    method: 'get',
    params
  })
}
