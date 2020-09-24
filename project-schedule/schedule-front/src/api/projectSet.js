
import request from '@/utils/request'
export function queryPersonPermissionList(params) {
  return request({
    url: '/project-schedule/settings/scheRole/query',
    method: 'get',
    params
  })
}
export function shiftUp(params) {
  return request({
    url: '/project-schedule/settings/scheRole/shiftUp',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    method: 'post',
    params
  })
}
export function shiftDown(params) {
  return request({
    url: '/project-schedule/settings/scheRole/shiftDown',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    method: 'post',
    params
  })
}
export function deletePersonPermissionById(params) {
  return request({
    url: `/project-schedule/settings/scheRole/delete`,
    method: 'delete',
    params
  })
}
export function savePersonPermission(data) {
  return request({
    url: '/project-schedule/settings/scheRole/saveRole',
    method: 'post',
    data
  })
}
export function getList(params) {
  return request({
    url: '/project-schedule/scheUserInfo/getUserList',
    method: 'get',
    params
  })
}
export function checkSameName(params) {
  return request({
    url: '/project-schedule/settings/scheRole/checkSameName',
    method: 'get',
    params
  })
}

// ----参数设置的界面
export function getProjectParams(params) {
  return request({
    url: '/project-schedule/settings/scheParams/query',
    method: 'get',
    params
  })
}

// 校验当前作业编制完成状态
export function checkTaskIsEditFinish(id) {
  return request({
    url: `/project-schedule/settings/scheParams/checkTaskIsEditFinish/${id}`,
    method: 'get'
  })
}

// 获取项目日历
export function getProjectCalendar(params) {
  return request({
    url: '/project-schedule/settings/scheParams/getProjectCalendar',
    method: 'get',
    params
  })
}
export function getProjectCalendarDefault(params) {
  return request({
    url: '/project-system-set/scheCalendar/getCalendarList?getCalendarName&isDefault=1',
    method: 'get',
    params
  })
}

// 保存参数
export function saveParams(data) {
  return request({
    url: '/project-schedule/settings/scheParams/save',
    method: 'post',
    data
  })
}
// 获取节点
export function getCodeFromWbs(params) {
  return request({
    url: '/project-system-set/scheTemplate/getProjectSetData',
    method: 'get',
    params
  })
}
// 获取默认编码规则
export function getDefaultCodeRule(params) {
  return request({
    url: '/project-system-set/expenseDictTemp/getCodeRule',
    method: 'get',
    params
  })
}

export function queryProjectUserList(params) {
  return request({
    url: '/bimserver/projectUser/queryProjectUserList',
    method: 'get',
    params
  })
}

// 切换wbs编制方式判断是否可切换
export function checkIsExistWbs(id) {
  return request({
    url: `/project-schedule/settings/scheParams/checkIsExistWbs/${id}`,
    method: 'get',
    id
  })
}
