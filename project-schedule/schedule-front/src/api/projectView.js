import request from '@/utils/request'

export function getViewList(params) {
  return request({
    url: '/project-system-set/projectView/queryView',
    method: 'get',
    params
  })
}

export function add(data) {
  return request({
    url: '/project-system-set/projectView/add',
    method: 'post',
    data
  })
}

export function checkIsViewRole(params) {
  return request({
    url: `/project-system-set/projectView/checkIsViewRole`,
    method: 'get',
    params
  })
}
export function getTaskByPrimitive(params) {
  return request({
    url: '/project-system-set/bimProjectTask/getTaskByTaskModelId',
    method: 'get',
    params
  })
}
export function getQualityOrSafeFomrPrimitive(params) {
  return request({
    url: '/project-system-set/qualitySafetyModel/queryQualitySafetyModelTree',
    method: 'get',
    params
  })
}
