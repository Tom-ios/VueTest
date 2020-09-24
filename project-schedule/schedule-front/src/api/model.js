import request from '@/utils/request'

export function getList(params) {
  return request({
    url: '/project-system-set/projectModule/queryProjectModuleList',
    method: 'get',
    params
  })
}

export function add(data, progressFun) {
  return request({
    url: '/project-system-set/projectModule/add',
    method: 'post',
    data,
    onUploadProgress: progressFun,
    timeout: 600000
  })
}

export function del(id) {
  return request({
    url: `/project-system-set/projectModule/delete/${id}`,
    method: 'delete'
  })
}

export function move(transFrom, transTo) {
  return request({
    url: `/project-system-set/projectModule/updateProjectModelSort?transFrom=${transFrom}&transTo=${transTo}`,
    method: 'put'
  })
}
