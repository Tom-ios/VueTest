import { asyncRoutes, constantRoutes } from '@/router'

function hasPermission(menus, route) {
  // if (route.meta && route.meta.roles) {
  //   return roles.some(role => route.name === role)
  // } else {
  //   return true
  // }
  if (!route.name) {
    return true
  }
  return menus.some(role => route.name === role)
}

export function filterAsyncRoutes(routes, params) {
  const res = []
  routes.forEach(route => {
    var tmp = { ...route }
    if (hasPermission(params.menus, tmp)) {
      if (tmp.children) {
        tmp.children = filterAsyncRoutes(tmp.children, params)
      }
      if (params.params.id) {
        tmp.path = tmp.path.replace(/:id/g, params.params.id)
      }
      res.push(tmp)
    }
  })
  return res
}

const state = {
  routes: [],
  addRoutes: []
}

const mutations = {
  SET_ROUTES: (state, routes) => {
    state.addRoutes = routes
    state.routes = constantRoutes.concat(routes)
  }
}

const actions = {
  generateRoutes({ commit }, params) {
    return new Promise(resolve => {
      let accessedRoutes = []
      if (params.menus.length > 0) {
        accessedRoutes = filterAsyncRoutes(asyncRoutes, params)
      }
      // console.log('accessedRoutes----', accessedRoutes)
      commit('SET_ROUTES', accessedRoutes)
      resolve(accessedRoutes)
    })
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
