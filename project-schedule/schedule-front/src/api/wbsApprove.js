import request from '@/utils/request'

export function getDictByItemId(params) {
  return request({
    url: '/fweb-commons-sort/commons/sort/dict/list',
    method: 'get',
    params
  })
}

export function getApproveData(params) {
  return request({
    // url: '/project-schedule/setApprove/getApproveData',
    url: '/project-system-set/setApprove/page',
    method: 'get',
    params
  })
}
export function getApproveById(id) {
  return request({
    url: `/project-system-set/setApprove/${id}`,
    method: 'get'
  })
}
export function updateApproval(data) {
  return request({
    url: '/project-system-set/setApprove/updateApproval',
    method: 'put',
    data
  })
}
export function getApprovalTree(params) {
  return request({
    url: `/project-schedule/schePlanTask/getApprovalTree`,
    method: 'get',
    params
  })
}
export function callApproval(params) {
  return request({
    url: `/project-system-set/setApprove/callApproval`,
    method: 'get',
    params
  })
}
export function backApproval(params) {
  return request({
    url: `/project-system-set/setApprove/backApproval`,
    method: 'get',
    params
  })
}
export function endApproval(params) {
  return request({
    url: `/project-system-set/setApprove/endApproval`,
    method: 'get',
    params
  })
}
