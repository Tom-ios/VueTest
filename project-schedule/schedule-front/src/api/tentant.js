import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/bimserver/tentant/queryTentantList',
    method: 'get',
    params
  })
}

export function add(data) {
  return request({
    url: '/bimserver/tentant/add',
    method: 'post',
    data
  })
}

export function getInfo(id) {
  return request({
    url: `/bimserver/tentant/tetant/${id}`,
    method: 'get'
  })
}

export function del(id) {
  return request({
    url: `/bimserver/tentant/delete/${id}`,
    method: 'delete'
  })
}

export function getTentantNo() {
  return request({
    url: `/bimserver/tentant/getTentantNo`,
    method: 'get'
  })
}
