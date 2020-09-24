
import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/project-system-set/commonQualitySafety/queryCommonQualitySafetyListTree',
    method: 'get',
    params
  })
}
export function getDetail(params) {
  return request({
    url: `project-system-set/commonQualitySafety/queryCommonQualitySafetyTreeById`,
    method: 'get',
    params
  })
}
// 关联任务
export function connectTask(data) {
  return request({
    url: '/project-system-set/commonQualitySafety/saveCommonAndTask',
    method: 'post',
    data
  })
}
export function getSelected(params) {
  return request({
    url: '/project-system-set/commonQualitySafety/getTaskById',
    method: 'get',
    params
  })
}

// 取消关联任务
export function removeConnectTask(data) {
  return request({
    url: '/project-system-set/commonQualitySafety/removeCommonAndTask',
    method: 'post',
    data
  })
}
/** **构建流水段树的接口 */
// 新增节点 0同级 1子级
export function addNode(data) {
  return request({
    url: '/project-system-set/commonQualitySafety/saveNode',
    method: 'post',
    data
  })
}
// 更新名字
export function updateNodeName(data) {
  return request({
    url: '/project-system-set/commonQualitySafety/updateNodeName',
    method: 'put',
    data
  })
}
// 删除节点
export function deleteNode(data) {
  return request({
    url: '/project-system-set/commonQualitySafety/deleteNode',
    method: 'post',
    data
  })
}
// 上移
export function shiftUp(params) {
  return request({
    url: '/project-system-set/commonQualitySafety/shiftUp',
    method: 'get',
    params
  })
}
// 下移
export function shiftDown(params) {
  return request({
    url: '/project-system-set/commonQualitySafety/shiftDown',
    method: 'get',
    params
  })
}
// 升级
export function upgrade(params) {
  return request({
    url: '/project-system-set/commonQualitySafety/upgrade',
    method: 'get',
    params
  })
}
// 降级
export function demotion(params) {
  return request({
    url: '/project-system-set/commonQualitySafety/demotion',
    method: 'get',
    params
  })
}
