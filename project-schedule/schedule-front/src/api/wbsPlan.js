import request from '@/utils/request'

export function getDictByItemId(params) {
  return request({
    url: '/fweb-commons-sort/commons/sort/dict/list',
    method: 'get',
    params
  })
}
export function getWbsData(params) {
  return request({
    url: '/project-schedule/schePlanTask/getWbsData',
    method: 'get',
    params
  })
}
export function getWbsLevelData(params) {
  return request({
    url: '/project-schedule/schePlanTask/getWbsLevelData',
    method: 'get',
    params
  })
}
export function getCurrentUserLevel(params) {
  return request({
    url: '/project-schedule/schePlanTask/getCurrentUserLevel',
    method: 'get',
    params
  })
}
export function saveScheEdit(data) {
  return request({
    url: '/project-schedule/schePlanTask/saveScheEdit',
    method: 'post',
    data
  })
}

export function getWbsVersionPage(params) {
  return request({
    url: '/project-schedule/schePlanTask/getWbsVersionPage',
    method: 'get',
    params
  })
}
export function getScheWbsLevelInfo(params) {
  return request({
    url: '/project-schedule/schePlanTask/getScheWbsLevelInfo',
    method: 'get',
    params
  })
}
export function saveScheWbs(data) {
  return request({
    url: '/project-schedule/schePlanTask/saveScheWbs',
    method: 'post',
    data
  })
}
export function updateWbsLevelInfo(data) {
  return request({
    url: '/project-schedule/schePlanTask/updateWbsLevelInfo',
    method: 'put',
    data
  })
}
export function saveWbsVersion(data) {
  return request({
    url: '/project-schedule/schePlanTask/saveWbsVersion',
    method: 'post',
    data
  })
}
export function getWbsVerData(params) {
  return request({
    url: '/project-schedule/schePlanTask/getWbsVerData',
    method: 'get',
    params
  })
}
export function queryWbsTemplateList(params) {
  return request({
    url: '/project-system-set/scheTemplate/getWbsTempDataPage',
    method: 'get',
    params
  })
}
export function setDefault(params) {
  return request({
    url: `/project-system-set/scheTemplate/setDefault`,
    method: 'get',
    params
  })
}
export function getWbsTempById(id) {
  return request({
    url: `/project-system-set/scheTemplate/getWbsTempById/${id}`,
    method: 'get'
  })
}
export function deleteScheWbsTempById(id) {
  return request({
    url: `/project-system-set/scheTemplate/deleteScheWbsTempById/${id}`,
    method: 'delete'
  })
}
export function getScheWbsTempDet(params) {
  return request({
    url: '/project-system-set/scheTemplate/getScheWbsTempDet',
    method: 'get',
    params
  })
}
export function copyScheWbsTemp(params) {
  return request({
    url: '/project-schedule/scheTemplate/copyScheWbsTemp',
    method: 'get',
    params
  })
}
export function saveWbsTempData(data) {
  return request({
    url: '/project-system-set/scheTemplate/saveWbsTempData',
    method: 'post',
    data
  })
}

export function submitApproval(params) {
  return request({
    url: '/project-schedule/schePlanTask/submitApproval',
    method: 'get',
    params
  })
}
export function getWbsApprovePage(params) {
  return request({
    url: '/project-schedule/schePlanTask/getWbsApprovePage',
    method: 'get',
    params
  })
}
export function recoverWbsVersion(params) {
  return request({
    url: '/project-schedule/schePlanTask/recoverWbsVersion',
    method: 'get',
    params
  })
}
export function getCompileState(params) {
  return request({
    url: '/project-schedule/schePlanTask/getCompileState',
    method: 'get',
    params
  })
}
export function importWbsDet(data, progressFun) {
  return request({
    url: '/project-system-set/scheTemplate/importWbsDet',
    method: 'post',
    data,
    onUploadProgress: progressFun,
    timeout: 600000
  })
}
export function getWbsRuleCode(data) {
  return request({
    url: `/project-system-set/setWbsRuleinfo/getCode`,
    method: 'post',
    data
  })
}

// wbs编制方式为导入,获取编制方式接口
export function getWbsEditType(params) {
  return request({
    url: `/project-schedule/settings/scheParams/getWbsEditType`,
    method: 'get',
    params
  })
}

// 文件上传接口
export function wbsImport(data, progressFun) {
  return request({
    url: `/project-schedule/schePlanTask/importWbsDet`,
    method: 'post',
    data,
    onUploadProgress: progressFun,
    timeout: 600000
  })
}

// 保存wbs
export function importWbsSave(data) {
  return request({
    url: `/project-schedule/schePlanTask/importWbsSave`,
    method: 'post',
    data
  })
}

// 获取导入完成进度列表信息
export function importMMPEditMsg(id) {
  return request({
    url: `/project-schedule/schePlanTask/importMMPEditMsg/${id}`,
    method: 'get'
  })
}

// 获取级别信息
export function getProjectWbsLevels(params) {
  return request({
    url: `/project-schedule/settings/scheParams/getProjectWbsLevels`,
    method: 'get',
    params
  })
}

// 导入完成
export function editMMPAccomplish(data) {
  return request({
    url: `/project-schedule/schePlanTask/editMMPAccomplish`,
    method: 'post',
    data
  })
}

// 获取wbs树
export function getWbsImportData(params) {
  return request({
    url: `/project-schedule/schePlanTask/getWbsData`,
    method: 'get',
    params
  })
}

