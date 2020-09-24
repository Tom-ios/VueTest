import request from '@/utils/request'

export function getRecentTaskEditList(params) {
  return request({
    url: '/project-schedule/schePlanTask/queryTaskProgressList',
    method: 'get',
    params
  })
}

export function getTaskList(params, isVersionInfo) {
  return request({
    url: isVersionInfo ? '/project-schedule/schePlanTask/queryTaskVersionInfo' : '/project-schedule/schePlanTask/queryTaskList',
    method: 'get',
    params
  })
}

export function getApprovalHistoryList(params) {
  return request({
    url: '/project-schedule/schePlanTask/getWbsApprovePage',
    method: 'get',
    params
  })
}

export function getTaskVersionHistoryList(params) {
  return request({
    url: '/project-schedule/schePlanTask/getWbsVersionPage',
    method: 'get',
    params
  })
}
export function checkScheTaskList(data, projectId) {
  return request({
    url: '/project-schedule/schePlanTask/checkScheTaskList?projectId=' + projectId,
    method: 'post',
    data
  })
}

