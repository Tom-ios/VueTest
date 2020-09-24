import request from '@/utils/request'
export function getDictByItemId(params) {
  return request({
    url: '/fweb-commons-sort/commons/sort/dict/list',
    method: 'get',
    params
  })
}
export function wbsRuleinfoList(params) {
  return request({
    url: `/project-system-set/setWbsRuleinfo/queryRuleInfo`,
    method: 'get',
    params
  })
}
export function deleteWbsRuleinfo(id) {
  return request({
    url: `/project-system-set/setWbsRuleinfo/${id}`,
    method: 'delete'
  })
}
export function deleteRuleinfo(id) {
  return request({
    url: `/project-system-set/setWbsRuleinfo/rule/${id}`,
    method: 'delete'
  })
}
export function getWbsRuleinfo(id) {
  return request({
    url: `/project-system-set/setWbsRuleinfo/${id}`,
    method: 'get'
  })
}
export function setDefaultRuleinfo(id) {
  return request({
    url: `/project-system-set/setWbsRuleinfo/${id}`,
    method: 'post'
  })
}
export function saveWbsRuleinfo(data) {
  return request({
    url: `/project-system-set/setWbsRuleinfo/saveOrUpdateRule`,
    method: 'post',
    data
  })
}
export function getWbsRuleCode(params) {
  return request({
    url: `/project-system-set/setWbsRuleinfo/getCode`,
    method: 'post',
    params
  })
}
export function getAllSort() {
  return request({
    url: `/project-system-set/setWbsRuleinfo/getAllSort`,
    method: 'get'
  })
}
