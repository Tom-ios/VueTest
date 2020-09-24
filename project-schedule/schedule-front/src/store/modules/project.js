const state = {
  name: ''
}

const mutations = {
  SET_NAME: (state, name) => {
    state.name = name
  }
}

const actions = {
  setprojectName({ commit }, name) {
    commit('SET_NAME', name)
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}
