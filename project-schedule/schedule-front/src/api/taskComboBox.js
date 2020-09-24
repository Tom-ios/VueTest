import request from '@/utils/request'
const iterm = {
  // 任务类型
  taskTypeId: 'c9690e2b4caf4d8ba92080e85cd5ec71',
  // 作业类型
  workTypeId: '936b380012bb49e19c4642b8f8359ee6',
  // 逻辑类型
  logicTypeId: '36607d0482474447939809fe19e180fb',
  // 计算方式
  calculateTypeId: 'e969da967d5048f992f2e3048d13c634',
  // 计划状态
  planStatusId: '',
  // 审批状态
  approveStatusId: ''

}
export { iterm }
export function getTaskComboBox(params) {
  return request({
    url: '/fweb-commons-sort/commons/sort/dict/list',
    method: 'get',
    params
  })
}
