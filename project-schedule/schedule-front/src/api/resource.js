import request from '@/utils/request'
export function getHumanList(params, listURL) {
  return request({
    url: listURL || '/project-system-set/setHuman/page',
    method: 'get',
    params
  })
}
export function getHumanById(id) {
  return request({
    url: `/project-system-set/getHumanById/${id}`,
    method: 'get'

  })
}
export function delHuman(id) {
  return request({
    url: `/project-system-set/setHuman/delete/${id}`,
    method: 'delete'
  })
}
export function saveHuman(data) {
  return request({
    url: '/project-system-set/setHuman/save',
    method: 'post',
    data
  })
}

export function getResourceList(params, listURL) {
  return request({
    url: listURL || '/project-system-set/setResource/page',
    method: 'get',
    params
  })
}
export function getResourceById(id) {
  return request({
    url: `/project-system-set/getResourceById/${id}`,
    method: 'get'

  })
}
export function delResource(id) {
  return request({
    url: `/project-system-set/setResource/delete/${id}`,
    method: 'delete'
  })
}
export function saveResource(data) {
  return request({
    url: '/project-system-set/setResource/save',
    method: 'post',
    data
  })
}

export function add(data) {
  return request({
    url: '/bimserver/userInfo/add',
    method: 'post',
    data
  })
}

export function del(id) {
  return request({
    url: `/bimserver/userInfo/delete/${id}`,
    method: 'delete'
  })
}

export function getRoleList() {
  return request({
    url: `/bimserver/roleInfo/getRoleList?roleType=1`,
    method: 'get'
  })
}

export function upload(data) {
  return request({
    url: '/project-system-set/setResource/upload',
    method: 'post',
    data,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}

/* 树形new */
export function newGetTreeList(params, listURL) {
  return request({
    url: listURL || `/project-system-set/setResourceGroup/getResourceTree`,
    method: 'get',
    params
  })
}

export function saveAndUpdate(data) {
  return request({
    url: '/project-system-set/setResourceGroup/saveAndUpdate',
    method: 'post',
    data
  })
}

export function delNode(id) {
  return request({
    url: `/project-system-set/setResourceGroup/delete/${id}`,
    method: 'delete'
  })
}

export function shiftUp(id) {
  return request({
    url: `/project-system-set/setResourceGroup/shiftUp/${id}`,
    method: 'post',
    id
  })
}

export function shiftDown(id) {
  return request({
    url: `/project-system-set/setResourceGroup/shiftDown/${id}`,
    method: 'post',
    id
  })
}

// 计划表查看单独资源接口
export function queryResourceList(params) {
  return request({
    url: `/project-schedule/progressAnalysis/queryResourceList`,
    method: 'get',
    params
  })
}
