import Mock from 'mockjs'

const data = Mock.mock({
  'items|10': [{
    id: '@id',
    updateUser: '@sentence(10, 20)',
    'processStatus|1': ['完成', '未完成'],
    updateTime: '@datetime',
    completeTime: '@datetime',
    pageviews: '@integer(300, 5000)'
  }]
})

export default [
  {
    url: '/wbsedit/list',
    type: 'get',
    response: config => {
      const items = data.items
      return {
        code: 20000,
        data: {
          total: items.length,
          items: items
        }
      }
    }
  }
]
