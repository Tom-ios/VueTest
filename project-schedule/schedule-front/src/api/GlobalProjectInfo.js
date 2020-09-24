import request from '@/utils/request'

export function getGlobalProjectInfo(params) {
  return request({
    url: '/fweb-exchange/contextVariable/getVariable?variableName=projectId',
    method: 'get',
    params
  })
}
export function getGlobalDepartmentId(params) {
  return request({
    url: '/fweb-exchange/contextVariable/getVariable?variableName=departmentId',
    method: 'get',
    params
  })
}
export function getGlobalDepartmentMap(params) {
  return request({
    url: '/mainframe/index/getDepartmentId?flag=departmentId',
    method: 'get',
    params
  })
}
export function getGlobalSubDepartmentMap(params) {
  return request({
    url: '/mainframe/index/getDepartmentId?flag=subDepartmentId',
    method: 'get',
    params
  })
}
