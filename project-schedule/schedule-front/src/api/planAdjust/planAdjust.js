import request from '@/utils/request'
// 查询作业所有资源预警列表（或查询某个资源预警阈值）
export function getResource(params) {
  return request({
    url: '/project-schedule/scheTaskResourceWarn/queryResWarnList',
    method: 'get',
    params
  })
}

export function save(url, data) {
  return request({
    url,
    method: 'post',
    data
  })
}
// 获取task列表
export function getResTaskList(params) {
  return request({
    url: '/project-schedule/planAdjust/queryTaskList',
    method: 'get',
    params
  })
}
// 保存单条task
export function saveTask(data, config) {
  return request({
    url: '/project-schedule/planAdjust/saveScheTaskBatch',
    method: 'post',
    data,
    ...config
  })
}
// 费用统计 - 按日期（period  按周：2  按月：1）

export function getCostStatisByDate(params, config) {
  return request({
    url: '/project-schedule/planAdjust/expByDateStatistics',
    method: 'get',
    params,
    ...config
  })
}
// 费用统计-按资源

export function getCostStatisByRes(params, config) {
  return request({
    url: '/project-schedule/planAdjust/expByResStatistics',
    method: 'get',
    params,
    ...config
  })
}
// 资源统计 - 资源使用量 和金额 （period  按周：2  按月：1 ， isCaculate=0 使用量 1 金额）

export function getResMoneyStatis(params, config) {
  return request({
    url: '/project-schedule/progressAnalysis/statistics',
    method: 'get',
    params,
    ...config
  })
}
