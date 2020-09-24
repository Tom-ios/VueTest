
import request from '@/utils/request'

export function getSelectSetList(params) {
  return request({
    url: '/project-system-set/groupFigure/getGroupFigures',
    method: 'get',
    params
  })
}
export function saveSelectSet(data) {
  return request({
    url: '/project-system-set/groupFigure/saveOrUpdateGroupFigures',
    method: 'post',
    data
  })
}
export function delSelectSet(id) {
  return request({
    url: `project-system-set/groupFigure/deleteGroupFigure/${id}`,
    method: 'delete'
  })
}

