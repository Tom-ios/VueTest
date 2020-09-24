import request from '@/utils/request'

export function getPlanList(params) {
  return request({
    url: '/project-schedule/contrast/query',
    method: 'get',
    params
  })
}

export function getDetails(params) {
  return request({
    url: '/project-schedule/contrast/getTree',
    method: 'get',
    params
  })
}

export function getWbsLevel(params) {
  return request({
    url: '/project-schedule/contrast/getWbsLevel',
    method: 'get',
    params
  })
}

export function getDiff(params) {
  return request({
    url: '/project-schedule/contrast/getDiff',
    method: 'get',
    params
  })
}

export function queryTree(params) {
  return request({
    url: '/project-schedule/contrast/queryTree',
    method: 'get',
    params
  })
}
