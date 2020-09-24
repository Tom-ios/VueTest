import { login, logout, getInfo, getPublicKey, getRoleIds, fwebRoleMenu, getRoleIdsByProject, getUserInfo } from '@/api/user'
import { getToken, setToken, removeToken } from '@/utils/auth'
import { resetRouter } from '@/router'
import { JSEncrypt } from '@/utils/jsencrypt'

var keyStr = 'ABCDEFGHIJKLMNOP' + 'QRSTUVWXYZabcdef' + 'ghijklmnopqrstuv' + 'wxyz0123456789+/' + '='
function MD5(input) {
  var output = ''
  var chr1; var chr2; var chr3 = ''
  var enc1; var enc2; var enc3; var enc4 = ''
  var i = 0
  do {
    chr1 = input.charCodeAt(i++)
    chr2 = input.charCodeAt(i++)
    chr3 = input.charCodeAt(i++)
    enc1 = chr1 >> 2
    enc2 = ((chr1 & 3) << 4) | (chr2 >> 4)
    enc3 = ((chr2 & 15) << 2) | (chr3 >> 6)
    enc4 = chr3 & 63
    if (isNaN(chr2)) {
      enc3 = enc4 = 64
    } else if (isNaN(chr3)) {
      enc4 = 64
    }
    output = output + keyStr.charAt(enc1) + keyStr.charAt(enc2) +
        keyStr.charAt(enc3) + keyStr.charAt(enc4)
    chr1 = chr2 = chr3 = ''
    enc1 = enc2 = enc3 = enc4 = ''
  } while (i < input.length)
  return output
}

const state = {
  token: getToken(),
  userId: '',
  tentantId: '',
  name: '',
  avatar: '',
  filetoken: '',
  roleIds: '',
  projectRoleIds: ''
}

const mutations = {
  SET_TOKEN: (state, token) => {
    state.token = token
  },
  SET_NAME: (state, name) => {
    state.name = name
  },
  SET_USERID: (state, id) => {
    state.userId = id
  },
  SET_TENTANTID: (state, tentantId) => {
    state.tentantId = tentantId
  },
  SET_AVATAR: (state, avatar) => {
    state.avatar = avatar
  },
  SET_FILETOKEN: (state, token) => {
    state.filetoken = token
  },
  SET_ROLEIDS: (state, ids) => {
    state.roleIds = ids
  },
  SET_PROROLEIDS: (state, ids) => {
    state.projectRoleIds = ids
  }
}

function encryptPasswd(password, publicKey, random) {
  // 加密密码
  const encrypt = new JSEncrypt()
  encrypt.setPublicKey(publicKey)
  const mdPassword = MD5(password)
  const enPassword = encrypt.encryptLong(password + ',' + mdPassword + ',' + random)
  return enPassword
}

function getText(menus) {
  let arr = []
  if (menus) {
    for (let index = 0; index < menus.length; index++) {
      const element = menus[index]
      arr.push(element.text)
      const children = getText(element.children)
      arr = [...arr, ...children]
    }
  }

  return arr
}

const actions = {
  // user login
  login({ commit }, userInfo) {
    const { username, password } = userInfo
    return new Promise((resolve, reject) => {
      getPublicKey().then(response => {
        const enPassword = encryptPasswd(password, response.data.publicKey, response.data.random)
        return login({ userCode: username.trim(), enPassword: enPassword, rememberMe: false, captcha: '' })
      }).then(response => {
        const { data, state } = response
        if (state === 'success') {
          commit('SET_TOKEN', data.token_)
          setToken(data.token_)
          resolve()
        } else {
          reject(response.msg)
        }
      }).catch(error => {
        reject(error)
      })
    })
  },

  // get user info
  getInfo({ commit, state }) {
    return new Promise((resolve, reject) => {
      getInfo(state.token).then(response => {
        const { data_ } = response.result
        if (!data_) {
          reject('请重新登录')
        }
        const { userName, avatar, id } = data_
        if (process.env.VUE_APP_BFWEB === 'false') {
          getUserInfo(id).then(res => {
            if (!res.tentantId) {
              reject('请重新登录')
            }
            commit('SET_TENTANTID', res.tentantId)
            commit('SET_USERID', id)
            commit('SET_NAME', userName)
            commit('SET_AVATAR', avatar)
          })
        } else {
          commit('SET_USERID', id)
          commit('SET_NAME', userName)
          commit('SET_AVATAR', avatar)
        }
        // return getFileToken()
      }).then(response => {
        commit('SET_FILETOKEN', response)
        resolve()
      }).catch(error => {
        reject(error)
      })
    })
  },

  // user logout
  logout({ commit, state }) {
    return new Promise((resolve, reject) => {
      logout(state.token).then(() => {
        commit('SET_TOKEN', '')
        commit('SET_NAME', '')
        commit('SET_TENTANTID', '')
        removeToken()
        resetRouter()
        resolve()
      }).catch(error => {
        reject(error)
      })
    })
  },

  // remove token
  resetToken({ commit }) {
    return new Promise(resolve => {
      commit('SET_TOKEN', '')
      removeToken()
      resolve()
    })
  },

  getMenus({ commit, state }, params) {
    const fun = params.type === 'main' ? getRoleIds : getRoleIdsByProject
    return new Promise((resolve, reject) => {
      fun(params.params).then(response => {
        if (params.type === 'main') {
          commit('SET_ROLEIDS', response)
        } else {
          commit('SET_PROROLEIDS', response)
        }
        return fwebRoleMenu({ roleIds: response })
      }).then((res) => {
        const arr = getText(res.data)
        resolve(arr)
      }).catch(error => {
        reject(error)
      })
    })
  }
}

export default {
  namespaced: true,
  state,
  mutations,
  actions
}

