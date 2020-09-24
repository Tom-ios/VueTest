import request from '@/utils/request'

export function getTemplateList(params) {
  return request({
    url: '/project-system-set/expenseDictTemp/queryList',
    method: 'get',
    params
  })
}

export function deleteTemplateById(id) {
  return request({
    url: `/project-system-set/expenseDictTemp/delete/${id}`,
    method: 'delete'
  })
}

export function setDefault(id) {
  return request({
    url: `/project-system-set/expenseDictTemp/setDefault/${id}`,
    method: 'post',
    id
  })
}

export function cancelDefault(id) {
  return request({
    url: `/project-system-set/expenseDictTemp/cancelDefault/${id}`,
    method: 'post',
    id
  })
}

export function getDetil(params) {
  return request({
    url: '/project-system-set/expenseDictTemp/getDetil',
    method: 'get',
    params
  })
}

export function saveAndUpdate(data) {
  return request({
    url: `/project-system-set/expenseDictTemp/saveAndUpdate`,
    method: 'post',
    data
  })
}

export function getCodeRule(params) {
  return request({
    url: `/project-system-set/expenseDictTemp/getCodeRule`,
    method: 'get',
    params
  })
}
