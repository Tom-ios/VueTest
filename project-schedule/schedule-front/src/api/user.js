import request from '@/utils/request'

export function login(data) {
  return request({
    url: '/fweb-security/login/dologin',
    method: 'post',
    data
  })
}

export function getPublicKey() {
  return request({
    url: '/fweb-security/login/getPublicKey',
    method: 'get'
  })
}

export function getInfo(token) {
  return request({
    url: '/fweb-security/login/getLoginUserInfo',
    method: 'get'
  })
}

export function logout() {
  return request({
    url: '/fweb-security/login/logout',
    method: 'post'
  })
}

export function fwebRoleMenu(params) {
  return request({
    url: '/fweb-security/auth/fwebRoleMenu',
    method: 'get',
    params
  })
}

export function getRoleIds() {
  return request({
    url: '/bimserver/userInfo/getRoleIds',
    method: 'get'
  })
}

export function getRoleIdsByProject(params) {
  return request({
    url: `/bimserver/userInfo/getRoleIdsByProject/${params.id}`,
    method: 'get'
  })
}

export function getFileToken(params) {
  return request({
    url: `/bimserver/fileservice/getToken`,
    method: 'get'
  })
}

export function getUserInfo(id) {
  return request({
    url: `/bimserver/userInfo/getUserInfo/${id}`,
    method: 'get'
  })
}

export function getTentantFlag() {
  return request({
    url: 'project-system-set/commonSet/checkTentantFlag',
    method: 'get'
  })
}

export function updatepasswd(data) {
  return request({
    url: '/fweb-security/user/updatepasswd',
    method: 'post',
    data
  })
}
