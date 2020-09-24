import request from '@/utils/request'
// 获取项目周期
export function getProjectPeriod(params) {
  return request({
    url: 'project-schedule/scheReport/getCycle',
    method: 'get',
    params
  })
}
export function queryResourceDetail(params) {
  return request({
    url: `/project-schedule/scheReport/queryResourceDetail`,
    method: 'get',
    params
  })
}

// 查询列表
export function getReportList(params) {
  return request({
    url: '/project-schedule/scheReport/queryTaskList',
    method: 'get',
    params
  })
}
// 保存修改
export function updateScheReport(data) {
  return request({
    url: 'project-schedule/scheReport/updateScheReport',
    method: 'post',
    data
  })
}
// 查询单条
export function queryReportById(params) {
  return request({
    url: `/project-schedule/scheReport/queryReportById`,
    method: 'get',
    params
  })
}
// 保存当前日历资源
export function saveOrUpdateResource(data) {
  return request({
    url: 'project-schedule/scheReport/saveOrUpdateResource',
    method: 'post',
    data
  })
}
// 获取工期
export function calcDuration(params) {
  return request({
    url: `/project-schedule/schePlanTask/calcDuration`,
    method: 'get',
    params
  })
}

export function getUserList(params) {
  return request({
    url: '/project-schedule/scheUserInfo/getUserList',
    method: 'get',
    params
  })
}
// 获取项目完成信息
export function getProgressBoardInfo(data) {
  return request({
    url: 'project-schedule/sche/getProgressBoardInfo ',
    method: 'post',
    data
  })
}
// 大保存修改
export function updateReportList(data) {
  return request({
    url: 'project-schedule/scheReport/updateOrSaveReportBatch',
    method: 'post',
    data
  })
}

