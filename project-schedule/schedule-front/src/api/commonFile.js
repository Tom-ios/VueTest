
import request from '@/utils/request'
// 保存附件
// commonId=&type=1
export function saveCommFile(data) {
  return request({
    url: '/project-system-set/commonFile/uploadFile',
    method: 'post',
    data
  })
}

// commonId  获取附件
export function getFileList(params) {
  return request({
    url: '/project-system-set/commonFile/getFileList',
    method: 'get',
    params
  })
}
// delete /commonFile/附件id
export function deleteFile(id) {
  return request({
    url: `project-system-set/commonFile/${id}`,
    method: 'delete'
  })
}
export function updateDes(data) {
  return request({
    url: '/project-system-set/commonFile/updateCommonFileDesc',
    method: 'put',
    data
  })
}

export function getGroupId(params) {
  return request({
    url: '/fileext/groupId',
    baseURL: process.env.VUE_APP_FILE_API,
    method: 'get',
    params
  })
}

export function getFileFromFileService(id) {
  return request({
    url: `/fileext/list/${id}`,
    baseURL: process.env.VUE_APP_FILE_API,
    method: 'get'
  })
}

export function deleteFileFromFileService(data) {
  return request({
    url: `/fileext/del_file`,
    baseURL: process.env.VUE_APP_FILE_API,
    method: 'delete',
    data
  })
}
export function saveCommFileToFileSerVice(data, url) {
  return request({
    url: url,
    baseURL: process.env.VUE_APP_FILE_API,
    method: 'post',
    data
  })
}
