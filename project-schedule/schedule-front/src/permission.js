import router from '@/router'
import store from './store'
import { Message } from 'element-ui'
import NProgress from 'nprogress' // progress bar
import 'nprogress/nprogress.css' // progress bar style
import { getToken } from '@/utils/auth' // get token from cookie
import getPageTitle from '@/utils/get-page-title'
import { getGlobalProjectInfo } from '@/api/GlobalProjectInfo'
NProgress.configure({ showSpinner: false }) // NProgress Configuration

const whiteList = ['/login'] // no redirect whitelist
router.beforeEach(async(to, from, next) => {
  if (process.env.VUE_APP_BFWEB === 'true' || process.env.VUE_WEB_COMPONTENT === 'true') {
    if (to.path.indexOf('/fweb') === 0) {
      // start progress bar
      NProgress.start()
      // set page title
      document.title = getPageTitle(to.meta.title)

      // determine whether the user has logged in
      const hasToken = process.env.VUE_APP_BFWEB === 'true' || process.env.VUE_WEB_COMPONTENT === 'true' ? true : getToken()

      // console.log(to, from)
      if (hasToken) {
        if (to.path === '/login') {
          // if is logged in, redirect to the home page
          next({ path: '/' })
          NProgress.done()
        } else {
          const hasGetUserInfo = store.getters.name
          try {
            if (!hasGetUserInfo) {
              await store.dispatch('user/getInfo')
            }
            if (process.env.VUE_APP_BFWEB === 'false') {
              if (to.meta.type !== 'project') {
                store.dispatch('project/setprojectName', '')
              }
              if (from.meta.type !== to.meta.type) {
                let names = []
                names = await store.dispatch('user/getMenus', { type: to.meta.type, params: to.params })
                if (names.length === 0) { return }
                await store.dispatch('permission/generateRoutes', { menus: names, params: to.params })

                // dynamically add accessible routes
                // router.addRoutes(accessRoutes)
              }
              next()
            } else {
              if (to.path.indexOf('pid') > -1 && process.env.VUE_APP_BFWEB_NEED_PROJECT_ID) {
                const res = await getGlobalProjectInfo()
                if (res && res.length < 35) {
                  to.params.id = res
                  next()
                  NProgress.done()
                } else {
                  next()
                }
              } else {
                next()
                NProgress.done()
              }
            }
          } catch (error) {
            await store.dispatch('user/resetToken')
            Message.error(error || 'Has Error')
            if (process.env.VUE_APP_BFWEB === 'true') {
              window.top.location.href = '../../view/mainframe/login'
            } else if (process.env.VUE_WEB_COMPONTENT === 'true') {
              window.top.location.href = '../../bimserver/dist/html.login'
            } else {
              next(`/login`)
            }
            NProgress.done()
          }
        }
      } else {
        /* has no token*/

        if (whiteList.indexOf(to.path) !== -1) {
          // in the free login whitelist, go directly
          next()
        } else {
          // other pages that do not have permission to access are redirected to the login page.

          next(`/login`)
          NProgress.done()
        }
      }
    } else {
      next({ path: '/fweb' + to.path, query: to.query })
    }
  } else {
    // start progress bar
    NProgress.start()
    // set page title
    document.title = getPageTitle(to.meta.title)

    // determine whether the user has logged in
    const hasToken = process.env.VUE_APP_BFWEB === 'true' ? true : getToken()

    // console.log(to, from)
    if (hasToken) {
      if (to.path === '/login') {
        // if is logged in, redirect to the home page
        next({ path: '/' })
        NProgress.done()
      } else {
        const hasGetUserInfo = store.getters.name
        try {
          if (!hasGetUserInfo) {
            await store.dispatch('user/getInfo')
          }
          if (process.env.VUE_APP_BFWEB === 'false') {
            if (to.meta.type !== 'project') {
              store.dispatch('project/setprojectName', '')
            }
            if (from.meta.type !== to.meta.type) {
              // resetRouter()
              // generate accessible routes map based on roles
              let names = []
              names = await store.dispatch('user/getMenus', { type: to.meta.type, params: to.params })
              if (names.length === 0) { return }
              await store.dispatch('permission/generateRoutes', { menus: names, params: to.params })

              // dynamically add accessible routes
              // router.addRoutes(accessRoutes)
            }
            next()
          } else {
            next()
          }
        } catch (error) {
          await store.dispatch('user/resetToken')
          Message.error(error || 'Has Error')
          if (process.env.VUE_APP_BFWEB === 'true') {
            window.top.location.href = '../../view/mainframe/login'
          } else {
            next(`/login`)
          }
          NProgress.done()
        }
      }
    } else {
      /* has no token*/

      if (whiteList.indexOf(to.path) !== -1) {
        // in the free login whitelist, go directly
        next()
      } else {
        // other pages that do not have permission to access are redirected to the login page.

        next(`/login`)
        NProgress.done()
      }
    }
  }
})

router.afterEach(() => {
  // finish progress bar
  NProgress.done()
})
