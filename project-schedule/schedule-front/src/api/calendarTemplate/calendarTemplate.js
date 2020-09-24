import request from '@/utils/request'

export function getCalendarList(params) {
  return request({
    url: '/project-system-set/scheCalendar/getCalendarList',
    method: 'get',
    params
  })
}

export function getCalendarDetail(params) {
  return request({
    url: '/project-system-set/scheCalendar/getCalendarDetail',
    method: 'get',
    params
  })
}

export function saveCalendar(data) {
  return request({
    url: '/project-system-set/scheCalendar/saveCalendar',
    method: 'post',
    data
  })
}

export function deleteCalendar(id) {
  return request({
    url: `/project-system-set/scheCalendar/deleteCalendar/${id}`,
    method: 'delete'
  })
}

export function setDefault(data) {
  return request({
    url: '/project-system-set/scheCalendar/setDefault',
    method: 'post',
    data
  })
}

export function cancelDefault(data) {
  return request({
    url: '/project-system-set/scheCalendar/cancelDefault',
    method: 'post',
    data
  })
}

export function checkCalendar(params) {
  return request({
    url: '/project-system-set/scheCalendar/checkCalendar',
    method: 'get',
    params
  })
}
