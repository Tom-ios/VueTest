
import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/project-system-set/project/getProjectDocuments',
    method: 'get',
    params
  })
}
/** **构建树的接口 */
// 新增节点 0同级 1子级
export function addNode(data) {
  return request({
    url: '/project-system-set/commonTree/saveNode',
    method: 'post',
    data
  })
}
// 更新名字
export function updateNodeName(data) {
  return request({
    url: '/project-system-set/commonTree/updateNode',
    method: 'put',
    data
  })
}
// 删除节点
export function deleteNode(id) {
  return request({
    url: `/project-system-set/commonTree/deleteNode/${id}`,
    method: 'delete'
  })
}
// 上移
export function shiftUp(params) {
  return request({
    url: '/project-system-set/commonTree/shiftUp',
    method: 'get',
    params
  })
}
// 下移
export function shiftDown(params) {
  return request({
    url: '/project-system-set/commonTree/shiftDown',
    method: 'get',
    params
  })
}
// 升级
export function upgrade(params) {
  return request({
    url: '/project-system-set/commonTree/upgrade',
    method: 'get',
    params
  })
}
// 降级
export function demotion(params) {
  return request({
    url: '/project-system-set/commonTree/demotion',
    method: 'get',
    params
  })
}
