import request from '@/utils/request'

export function getTaskTemplateList(params) {
  return request({
    url: '/project-system-set/scheTask/getTaskTempList',
    method: 'get',
    params
  })
}

export function saveTaskTemplate(params, data, config) {
  return request({
    url: '/project-system-set/scheTask/saveTaskTempList',
    method: 'post',
    params,
    data,
    ...config
  })
}

export function importTaskTemplate(params, data, config) {
  return request({
    url: '/project-system-set/',
    method: 'post',
    params,
    data,
    ...config
  })
}

export function deleteTaskTemplate(id) {
  return request({
    url: '/project-system-set/scheTask/deleteTaskTemp/' + id,
    method: 'delete'
  })
}

