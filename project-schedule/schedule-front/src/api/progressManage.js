import request from '@/utils/request'
export function importProgressPlan(data, progressFun) {
  return request({
    url: 'project-system-set/bimProjectTask/upload',
    method: 'post',
    data,
    onUploadProgress: progressFun,
    timeout: 600000
  })
}

export function getPlanList(data) {
  return request({
    url: 'project-system-set/bimProjectTask/getProjectTask',
    method: 'post',
    data
  })
}
export function savePlanList(data) {
  return request({
    url: 'project-system-set/bimProjectTask/updateProjectTaskInfo',
    method: 'put',
    data
  })
}
export function getUserList(params) {
  return request({
    url: '/project-system-set/projectUser/queryAllProjectUserList',
    method: 'get',
    params
  })
}
export function connectTaskModel(data) {
  return request({
    url: 'project-system-set/bimTaskModel/saveTakModel',
    method: 'post',
    data
  })
}
export function cancelTaskModel(id) {
  return request({
    url: `project-system-set/bimTaskModel/${id}`,
    method: 'delete'
  })
}

export function getTreeData(url, requestData, getWay) {
  if (getWay === 'post') {
    return request({
      url: url,
      method: getWay,
      data: requestData
    })
  } else {
    return request({
      url: url,
      method: getWay || 'get',
      params: requestData
    })
  }
}
export function getFlowSegList(params) {
  return request({
    url: '/project-system-set/bimSectionManagement/querySectionManageListTree',
    method: 'get',
    params
  })
}
export function taskConnectFlowSeg(data) {
  return request({
    url: '/project-system-set/schedule/taskSectionRelation',
    method: 'post',
    data
  })
}

// 模型关联获取流水段
export function getqualityOrSafe(params) {
  return request({
    url: '/project-system-set/qualitySafetyModel/queryQualitySafetyModelTree',
    method: 'get',
    params
  })
}
// 流水段关联模型
export function connectQualityOrSafeModel(data) {
  return request({
    url: '/project-system-set/qualitySafetyModel/saveQualitySafetyModelRelation',
    method: 'post',
    data
  })
}
// 取消关联模型
export function cancelFlowSegModelModel(id) {
  return request({
    url: `/project-system-set/qualitySafetyModel/cancelQualitySafetyModelRelation/${id}`,
    method: 'delete'
  })
}

/** **构建流水段树的接口 */
// 新增节点 0同级 1子级
export function addNode(data) {
  return request({
    url: '/project-system-set/bimSectionManagement/saveNode',
    method: 'post',
    data
  })
}
// 更新名字
export function updateNodeName(data) {
  return request({
    url: '/project-system-set/bimSectionManagement/updateNodeName',
    method: 'put',
    data
  })
}
// 删除节点
export function deleteNode(data) {
  return request({
    url: '/project-system-set/bimSectionManagement/deleteNode',
    method: 'post',
    data
  })
}
// 上移
export function shiftUp(params) {
  return request({
    url: '/project-system-set/bimSectionManagement/shiftUp',
    method: 'get',
    params
  })
}
// 下移
export function shiftDown(params) {
  return request({
    url: '/project-system-set/bimSectionManagement/shiftDown',
    method: 'get',
    params
  })
}
// 升级
export function upgrade(params) {
  return request({
    url: '/project-system-set/bimSectionManagement/upgrade',
    method: 'get',
    params
  })
}
// 降级
export function demotion(params) {
  return request({
    url: '/project-system-set/bimSectionManagement/demotion',
    method: 'get',
    params
  })
}
export function flowConnectTree(data) {
  return request({
    url: '/project-system-set/bimSectionManagement/saveBimSectionTemplateRelationList',
    method: 'post',
    data
  })
}
export function saveTask(data) {
  return request({
    url: '/project-system-set/bimProjectTask/saveListProjectTask',
    method: 'post',
    data
  })
}
// 预警

export function saveProgressWarn(data) {
  return request({
    url: '/project-system-set/projectTaskWarning ',
    method: 'post',
    data
  })
}
// 升级
export function getProgressWarn(params) {
  return request({
    url: '/project-system-set/projectTaskWarning',
    method: 'get',
    params
  })
}
