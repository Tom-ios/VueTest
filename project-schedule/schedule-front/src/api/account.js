import request from '@/utils/request'

export function getList(queryUrl, params, isFweb) {
  return request({
    url: queryUrl || (isFweb ? 'project-schedule/scheUserInfo/getUserList' : '/bimserver/userInfo/getUserList'),
    method: 'get',
    params
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
    url: '/bimserver/userInfo/upload',
    method: 'post',
    data,
    headers: { 'Content-Type': 'multipart/form-data' }
  })
}
