import request from '@/utils/request'
import store from '../store'
export function getList(params) {
  return request({
    url: '/bimserver/project/queryProjectList',
    method: 'get',
    params
  })
}

export function detail(id) {
  return request({
    url: `/bimserver/project/project/${id}`,
    method: 'get'
  }).then(rep => {
    store.dispatch('project/setprojectName', rep.projectName)
    return Promise.resolve(rep)
  })
}

export function add(data) {
  return request({
    url: '/bimserver/project/add',
    method: 'post',
    data
  })
}

export function setProjectOver(data) {
  return request({
    url: '/bimserver/project/setProjectOver',
    method: 'post',
    data
  })
}

export function edit(data) {
  return request({
    url: '/bimserver/project/update',
    method: 'put',
    data
  })
}

export function del(id) {
  return request({
    url: `/bimserver/project/delete/${id}`,
    method: 'delete'
  })
}

export function queryProjectUserList(params) {
  return request({
    url: '/bimserver/projectUser/queryProjectUserList',
    method: 'get',
    params
  })
}

export function queryTententUserList(params) {
  return request({
    url: '/bimserver/projectUser/queryTententUserList',
    method: 'get',
    params
  })
}

export function addProjectUser(data) {
  return request({
    url: '/bimserver/projectUser/add',
    method: 'post',
    data
  })
}

export function checkIsManager(id) {
  return request({
    url: `/bimserver/userInfo/checkIsManager/${id}`,
    method: 'get'
  })
}

export function getRoleList() {
  return request({
    url: `/bimserver/roleInfo/getRoleList?roleType=2`,
    method: 'get'
  })
}

export function getRoleNamesByProject(id) {
  let over
  return detail(id).then(rep => {
    over = rep.projectOver
    return request({
      url: `/bimserver/userInfo/getRoleNamesByProject/${id}`,
      method: 'get'
    })
  }).then(rep => {
    if (over) {
      return Promise.resolve('')
    } else {
      return Promise.resolve(rep)
    }
  })
}
export function getRoleNamesFromProject(id) {
  return request({
    url: `/bimserver/userInfo/getRoleNamesByProject/${id}`,
    method: 'get'
  })
}

