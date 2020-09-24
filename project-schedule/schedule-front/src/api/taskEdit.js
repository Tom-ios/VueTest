import request from '@/utils/request'

export function getTaskEditHistoryList(params) {
  return request({
    url: '/project-schedule/schePlanTask/queryEditorList',
    method: 'get',
    params
  })
}
export function saveTaskTable(data, config) {
  return request({
    url: '/project-schedule/schePlanTask/saveScheTaskList',
    method: 'post',
    data,
    ...config
  })
}

export function commitTaskTable(params, data, config) {
  return request({
    url: '/project-schedule/schePlanTask/saveScheTaskList',
    method: 'post',
    params,
    data,
    ...config
  })
}

export function setTaskEditStatus(data, config) {
  return request({
    url: '/project-schedule/schePlanTask/setComplateState',
    method: 'post',
    data, ...config
  })
}

export function taskVersionRecover(params, config) {
  return request({
    url: '/project-schedule/schePlanTask/recoverVersion',
    method: 'get',
    params, ...config
  })
}

export function checkSavePerson(data) {
  return request({
    url: '/project-schedule/schePlanTask/checkSaveScheEdit',
    method: 'post',
    data
  })
}

export function setTaskEditComplete(data) {
  return request({
    url: '/project-schedule/schePlanTask/saveScheEdit',
    method: 'post',
    data
  })
}

export function setTaskApprovalStatus(params) {
  return request({
    url: '/project-schedule/schePlanTask/submitTaskApproval',
    method: 'get',
    params
  })
}

export function getCriticalPath(params) {
  return request({
    url: '/project-schedule/criticalPath/getCriticalPath',
    method: 'get',
    params
  })
}

export function getWbsApproveStatus(params) {
  return request({
    url: '/project-schedule/schePlanTask/checkWbsApprovePass',
    method: 'get',
    params
  })
}

export function getWbsCode(data) {
  return request({
    url: '/project-system-set/setWbsRuleinfo/getCode',
    method: 'post',
    data
  })
}

export function getWbsCodes(data) {
  return request({
    url: '/project-system-set/setWbsRuleinfo/getBatchCode',
    method: 'post',
    data
  })
}

export function getTaskDuration(params) {
  return request({
    url: '/project-schedule/schePlanTask/calcDuration',
    method: 'get',
    params
  })
}

export function getProgrameSettings(params) {
  return request({
    url: '/project-schedule/settings/scheParams/query',
    method: 'get',
    params
  })
}

export function getCurrentUserOptPermission(params) {
  return request({
    url: '/project-schedule/schePlanTask/getUserInProjcet',
    method: 'get',
    params
  })
}
