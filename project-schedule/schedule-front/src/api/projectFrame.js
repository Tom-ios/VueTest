import request from '@/utils/request'

export function getFrame(params) {
  return request({
    url: '/project-system-set/projectFrame/queryFrameByProjectId',
    method: 'get',
    params
  })
}

export function addFrame(data) {
  return request({
    url: '/project-system-set/projectFrame/add',
    method: 'post',
    data
  })
}

export function getTemplateList(id) {
  return request({
    url: '/project-system-set/projectFrame/queryTemplateList',
    method: 'get',
    params: { templateId: id }
  })
}

export function addTemplate(data) {
  return request({
    url: '/project-system-set/projectFrame/addTemplate',
    method: 'post',
    data
  })
}

export function getProperty(templateId, pixelId) {
  return request({
    url: '/project-system-set/projectFrame/queryPixelEleList',
    method: 'get',
    params: { templateId: templateId, pixelId: pixelId }
  })
}

export function addProperty(data) {
  return request({
    url: '/project-system-set/projectFrame/addElementValue',
    method: 'post',
    data
  })
}

export function getPropertys(templateId, pixelIds) {
  return request({
    url: '/project-system-set/projectFrame/batchCompare',
    method: 'post',
    data: { templateId: templateId, pixelIds: pixelIds.toString() }
  })
}

export function addPropertys(data) {
  return request({
    url: '/project-system-set/projectFrame/batchSave',
    method: 'post',
    data
  })
}

export function initRender(id) {
  return request({
    url: '/project-system-set/projectFrame/initRender',
    method: 'get',
    params: { id: id }
  })
}
