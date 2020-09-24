
import request from '@/utils/request'
export function createForm(params) {
  return request({
    url: '/project-system-set/commonFile/getId',
    method: 'get',
    params
  })
}
export function getList(params) {
  return request({
    url: '/project-system-set/progressPayment',
    method: 'get',
    params
  })
}
export function getDetail(id) {
  return request({
    url: `/project-system-set/progressPayment/${id}`,
    method: 'get'
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
// 取消关联任务
export function removeConnectTask(data) {
  return request({
    url: '/project-system-set/commonQualitySafety/removeCommonAndTask',
    method: 'post',
    data
  })
}
// 保存附件
export function saveCommFile(data) {
  return request({
    url: '/project-system-set/commonFile/uploadFile',
    method: 'post',
    data
  })
}
/** **构建流水段树的接口 */
// 新增节点 0同级 1子级
export function addNode(data) {
  return request({
    url: '/project-system-set/progressPayment',
    method: 'post',
    data
  })
}
// 更新名字
export function updateNode(data) {
  return request({
    url: '/project-system-set/progressPayment',
    method: 'put',
    data
  })
}
// 删除节点
export function deleteNode(id) {
  return request({
    url: `project-system-set/progressPayment/${id}`,
    method: 'delete'
  })
}
// 上移 下移
export function shiftUpDown(params) {
  return request({
    url: '/project-system-set/progressPayment/updateProgressSort',
    method: 'put',
    params
  })
}

