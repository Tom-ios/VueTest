import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

/* Layout */
import Layout from '@/layout'

/**
 * Note: sub-menu only appear when route children.length >= 1
 * Detail see: https://panjiachen.github.io/vue-element-admin-site/guide/essentials/router-and-nav.html
 *
 * hidden: true                   if set true, item will not show in the sidebar(default is false)
 * alwaysShow: true               if set true, will always show the root menu
 *                                if not set alwaysShow, when item has more than one children route,
 *                                it will becomes nested mode, otherwise not show the root menu
 * redirect: noRedirect           if set noRedirect will no redirect in the breadcrumb
 * name:'router-name'             the name is used by <keep-alive> (must set!!!)
 * meta : {
    roles: ['admin','editor']    control the page roles (you can set multiple roles)
    title: 'title'               the name show in sidebar and breadcrumb (recommend set)
    icon: 'svg-name'             the icon show in the sidebar
    breadcrumb: false            if set false, the item will hidden in breadcrumb(default is true)
    activeMenu: '/example/list'  if set path, the sidebar will highlight the path you set
  }
 */

/**
 * constantRoutes
 * a base page that does not have permission requirements
 * all roles can be accessed
 */
export const constantRoutes = [
  {
    path: '/login',
    component: () => import('@/views/login/index'),
    hidden: true
  },

  {
    path: '/404',
    component: () => import('@/views/404'),
    hidden: true
  },
  {
    path: '/',
    component: Layout,
    redirect: '/dashboard',
    children: [{
      path: 'dashboard',
      hidden: true,
      name: 'dashboard',
      component: () => import('@/views/dashboard/index'),
      meta: { title: '', icon: 'dashboard', type: 'main' }
    }]
  },
  {
    path: '/personCenter',
    component: Layout,
    children: [{
      path: '',
      hidden: true,
      name: 'personCenter',
      component: () => import('@/views/personCenter/index'),
      meta: { title: '个人中心', icon: 'zhgl', type: 'main' }
    }]
  }

  // 404 page must be placed at the end !!!
  // { path: '*', redirect: '/404', hidden: true }
]
export const asyncRoutes = [
  {
    path: '/project',
    component: Layout,
    children: [
      {
        path: 'list',
        name: 'projectList',
        component: () => import('@/views/project/Project.vue'),
        meta: { title: '项目列表', icon: 'mxll', type: 'main' }
      },
      {
        path: 'add',
        name: 'projectAdd',
        hidden: true,
        component: () => import('@/views/project/ProjectEdit.vue'),
        meta: { title: '新建项目', icon: 'dashboard', type: 'main', breadcrumb: 'projectList' }
      },
      {
        path: 'edit/:id',
        name: 'projectEdit',
        hidden: true,
        component: () => import('@/views/project/ProjectEdit.vue'),
        meta: { title: '编辑项目', icon: 'dashboard', type: 'main', breadcrumb: 'projectList' }
      }
    ]
  },
  {
    path: '/projectSet',
    component: Layout,
    name: 'projectSet',
    meta: { title: '项目设置', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' },
    children: [

      {
        path: 'setPeople/:id',
        name: 'setPeople',
        meta: { title: '人员权限', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' },
        component: () => import('@/views/projectSet/resource/PersonPermission.vue')
      },
      {
        path: 'setParams/:id',
        name: 'setParams',
        meta: { title: '参数设置', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' },
        component: () => import('@/views/projectSet/resource/ProjectParam.vue')
      },
      {
        path: 'setParams/edit/:id',
        name: 'setParamsEdit',
        meta: { title: '编辑', icon: 'zhgl', type: 'project', breadcrumb: 'projectList,setParams' },
        component: () => import('@/views/projectSet/resource/ProjectParamEdit.vue')
      }

    ]
  },
  {
    path: '/schePlan/task/versionDetail/:id',
    component: () => import('@/views/task/taskVersionDetail.vue')
  },
  {
    path: '/schePlan',
    component: Layout,
    name: 'schePlan',
    meta: { title: '计划编制', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' },
    children: [
      {
        path: 'wbs/edit/:id',
        name: 'wbsPlan',
        component: () => import('@/views/wbs/index.vue'),
        meta: { title: 'WBS编制', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' }
      },
      {
        path: 'versioninfo',
        // name: 'wbsVersionInfo',
        hidden: true,
        component: () => import('@/views/wbs/WbsVersionHistoryInfo.vue'),
        meta: { title: '版本详情', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' }
      },
      {
        path: 'task/edit/:id',
        component: () => import('@/views/task/TaskEdit.vue'),
        name: 'taskPlan',
        meta: { title: '作业编制', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' }
      },
      {
        name: 'wbsCheckDate',
        path: '/views/task/dateCheck/:id',
        component: () => import('@/views/wbs/WbsDateCheck.vue'),
        meta: { title: 'WBS时间校验', icon: 'zhgl', type: 'project', breadcrumb: 'projectList,taskPlan' }
      }
      // {
      //   path: 'resourceOptimize/:id',
      //   component: () => import('@/views/resourceOptimize/index.vue'),
      //   name: 'resourceOptimize',
      //   meta: { title: '资源优化', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' }
      // }
    ]
  },
  {
    path: '/planAdjust',
    component: Layout,
    children: [
      {
        path: ':id',
        name: 'NoMenuplanAdjust',
        component: () => import('@/views/planAdjust/index.vue'),
        meta: { title: '计划调整', icon: 'dashboard', type: 'project', breadcrumb: 'projectList,taskPlan' }
      },
      {
        path: 'setWarning/:id',
        name: 'setWarning',
        component: () => import('@/views/planAdjust/SetWarning.vue'),
        meta: { title: '设置预警阙值', icon: 'dashboard', type: 'project', breadcrumb: 'projectList,taskPlan,NoMenuplanAdjust' }
      }
    ]
  },

  {
    path: '/planlist',
    component: Layout,
    children: [
      {
        path: 'list/:id',
        name: 'planCompare',
        component: () => import('@/views/planList/planList.vue'),
        meta: { title: '计划对比', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
      },
      {
        path: 'baselineVersion/:id',
        name: 'BaselineVersion',
        component: () => import('@/views/planList/BaselineVersion.vue'),
        meta: { title: '版本详情', icon: 'xmry', type: 'project', breadcrumb: 'projectList,planCompare' }
      }
      // {
      //   path: 'compareResult',
      //   // name: 'compareResult',
      //   hidden: true,
      //   component: () => import('@/views/planList/compareResult.vue'),
      //   meta: { title: '对比结果', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
      // }
    ]
  },
  {
    path: '/wbsTemplate',
    component: Layout,
    name: 'wbsTemplate',
    meta: {
      title: 'WBS模板'
    },
    children: [
      {
        path: 'edit/:id',
        name: 'auth',
        hidden: true,
        component: () => import('@/views/wbs/WbsTemplateEdit.vue'),
        meta: { title: '编辑', icon: 'jdgl', breadcrumb: 'systemSetIndex' }
      },
      {
        path: 'add',
        name: 'wbsTemplateAdd',
        component: () => import('@/views/wbs/WbsTemplateEdit.vue'),
        meta: { title: '添加', icon: 'jdgl', breadcrumb: 'wbsTemplateList' }
      },
      {
        path: 'list',
        name: 'wbsTemplateList',
        component: () => import('@/views/wbs/WbsTemplateList.vue'),
        meta: { title: '列表', icon: 'jdgl' }
      }
    ]
  },

  {
    path: '/taskTemplate/:id',
    component: Layout,
    name: 'projectQualityManage',
    children: [
      {
        path: '',
        meta: { title: '作业模板', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' },
        component: () => import('@/views/task/Template.vue')
      }]
  },

  {
    path: '/progressReport',
    component: Layout,
    children: [
      {
        path: 'list/:id',
        name: 'scheReport',
        component: () => import('@/views/progressReport/ProgressReportList.vue'),
        meta: { title: '进度填报', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
      },
      {
        path: 'edit/:id',
        name: 'scheReportEdit',
        component: () => import('@/views/progressReport/ProgressReportEdit.vue'),
        meta: { title: '进度编辑', icon: 'dashboard', type: 'project', breadcrumb: 'projectList,scheReport' }
      }
    ]
  },
  {
    path: '/scheAnalysis',
    component: Layout,
    name: 'scheAnaly',
    meta: { title: '进度分析', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' },
    children: [
      {
        path: 'list/:id',
        name: 'scheAnalysis',
        component: () => import('@/views/scheAnalysis/index.vue'),
        meta: { title: '挣值分析', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
      },
      {
        path: 'PlanListView/:id',
        name: 'evAnalysis',
        component: () => import('@/views/scheAnalysis/planListView.vue'),
        meta: { title: '计划表查看', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
      }
    ]
  },
  {
    path: '/approve',
    component: Layout,
    name: 'scheApprove',
    meta: { title: '计划审批', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' },
    children: [
      {
        path: 'list/:id',
        component: () => import('@/views/approve/index.vue'),
        meta: { title: '计划审批', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' }
      },
      {
        path: 'view',
        hidden: true,
        component: () => import('@/views/approve/approveView.vue'),
        meta: { title: '计划审批查看', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' }
      }
    ]
  },
  {
    path: '/company',
    component: Layout,
    children: [
      {
        path: 'list',
        name: 'company',
        component: () => import('@/views/company/Company.vue'),
        meta: { title: '企业管理', icon: 'dashboard', type: 'main' }
      },
      {
        path: 'detail/:id',
        name: 'companyDetail',
        hidden: true,
        component: () => import('@/views/company/CompanyDetail.vue'),
        meta: { title: '企业信息', icon: 'dashboard', type: 'main' }
      }
    ]
  },
  {
    path: '/account',
    component: Layout,
    children: [
      {
        path: 'list',
        name: 'account',
        component: () => import('@/views/account/index.vue'),
        meta: { title: '账号管理', icon: 'zhgl', type: 'main' }
      }
    ]
  },

  {
    path: '/systemSet',
    name: 'systemSet',
    component: Layout,
    meta: { title: '系统设置', icon: 'dashboard', type: 'main' },
    children: [
      {
        path: 'template',
        name: 'template',
        meta: { title: '模板库', icon: 'dashboard', type: 'main', breadcrumb: 'systemSet' },
        component: () => import('@/views/systemSet/index.vue')
      },
      {
        path: 'resource',
        name: 'resource',
        meta: { title: '资源库', icon: 'dashboard', type: 'main', breadcrumb: 'systemSet' },
        component: () => import('@/views/systemSet/resource/Resource.vue'),
        props: { showTreeToolBar: true }
      }
    ]

  },

  // --------------------------*************** fweb路由 *****************************//
  {
    path: '/fweb/dashboard',
    hidden: true,
    name: 'fwebdashboard',
    component: () => import('@/views/dashboard/index'),
    meta: { title: '', icon: 'dashboard', type: 'main' }
  },
  {
    path: '/fweb/project/list',
    name: 'fweb/projectList',
    component: () => import('@/views/project/Project.vue'),
    meta: { title: '项目列表', icon: 'mxll', type: 'main' }
  },
  {
    path: '/fweb/project/add',
    name: 'fwebprojectAdd',
    hidden: true,
    component: () => import('@/views/project/ProjectEdit.vue'),
    meta: { title: '新建项目', icon: 'dashboard', type: 'main', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/project/edit/:id',
    name: 'fwebprojectEdit',
    hidden: true,
    component: () => import('@/views/project/ProjectEdit.vue'),
    meta: { title: '编辑项目', icon: 'dashboard', type: 'main', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/projectSet/setParams/:id',
    name: 'fwebsetParams',
    meta: { title: '参数设置', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' },
    component: () => import('@/views/projectSet/resource/ProjectParam.vue')
  },
  {
    path: '/fweb/projectSet/setParams/edit/:id',
    name: 'fwebsetParamsEdit',
    meta: { title: '编辑', icon: 'zhgl', type: 'project', breadcrumb: 'projectList,setParams' },
    component: () => import('@/views/projectSet/resource/ProjectParamEdit.vue')
  },
  {
    path: '/fweb/projectSet/setPeople/:id',
    name: 'fwebsetPeople',
    meta: { title: '人员权限', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' },
    component: () => import('@/views/projectSet/resource/PersonPermission.vue')
  },
  {
    path: '/fweb/schePlan/task/versionDetail/:id',
    component: () => import('@/views/task/taskVersionDetail.vue')
  },
  {
    path: '/fweb/schePlan/wbs/edit/:id',
    name: 'fwebwbsPlan',
    component: () => import('@/views/wbs/index.vue'),
    meta: { title: 'WBS编制', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/schePlan/versioninfo',
    // name: 'wbsVersionInfo',
    hidden: true,
    component: () => import('@/views/wbs/WbsVersionHistoryInfo.vue'),
    meta: { title: '版本详情', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/schePlan/task/edit/:id',
    component: () => import('@/views/task/TaskEdit.vue'),
    name: 'fwebtaskPlan',
    meta: { title: '作业编制', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/schePlan/resourceOptimize/:id',
    component: () => import('@/views/resourceOptimize/index.vue'),
    name: 'fwebresourceOptimize',
    meta: { title: '资源优化', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: 'planAdjust/:id',
    name: 'fwebplanAdjust',
    component: () => import('@/views/planAdjust/index.vue'),
    meta: { title: '计划调整', icon: 'dashboard', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/planlist/list/:id',
    name: 'fwebplanCompare',
    component: () => import('@/views/planList/planList.vue'),
    meta: { title: '计划对比', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/planlist/baselineVersion/:id',
    hidden: true,
    component: () => import('@/views/planList/BaselineVersion.vue'),
    meta: { title: '版本详情', icon: 'xmry', type: 'project', breadcrumb: 'projectList,fwebplanCompare' }
  },
  // {
  //   path: '/fweb/planlist/list/compareResult',
  //   hidden: true,
  //   component: () => import('@/views/planList/compareResult.vue'),
  //   meta: { title: '对比结果', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
  // },
  {
    path: '/fweb/wbsTemplate/edit/:id',
    name: 'fwebauth',
    hidden: true,
    component: () => import('@/views/wbs/WbsTemplateEdit.vue'),
    meta: { title: '编辑', icon: 'jdgl', breadcrumb: 'systemSetIndex' }
  },
  {
    path: '/fweb/wbsTemplate/add',
    name: 'fwebwbsTemplateAdd',
    component: () => import('@/views/wbs/WbsTemplateEdit.vue'),
    meta: { title: '添加', icon: 'jdgl', breadcrumb: 'wbsTemplateList' }
  },
  {
    path: '/fweb/wbsTemplate/list',
    name: 'fwebwbsTemplateList',
    component: () => import('@/views/wbs/WbsTemplateList.vue'),
    meta: { title: '列表', icon: 'jdgl' }
  },
  {
    path: '/fweb/taskTemplate/:id',
    name: 'fwebTaskTemplate',
    meta: { title: '作业模板', icon: 'zhgl', type: 'project', breadcrumb: 'projectList' },
    component: () => import('@/views/task/Template.vue')
  },
  {
    path: '/fweb/progressReport/list/:id',
    name: 'fwebscheReport',
    component: () => import('@/views/progressReport/ProgressReportList.vue'),
    meta: { title: '进度填报', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/progressReport/edit/:id',
    name: 'fwebscheReportEdit',
    component: () => import('@/views/progressReport/ProgressReportEdit.vue'),
    meta: { title: '进度编辑', icon: 'dashboard', type: 'project', breadcrumb: 'projectList,fwebscheReport' }
  },
  {
    path: '/fweb/statistic/list/:id',
    name: 'statistic',
    component: () => import('@/views/progressReport/ProgressReportList.vue'),
    meta: { title: '进度统计', icon: 'xmry', type: 'project', breadcrumb: 'projectList' },
    props: { statistic: true }
  },
  {
    path: '/fweb/scheAnalysis/list/:id',
    name: 'fwebscheAnaly',
    component: () => import('@/views/scheAnalysis/index.vue'),
    meta: { title: '挣值分析', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/scheAnalysis/PlanListView/:id',
    name: 'fwebevAnalysis',
    component: () => import('@/views/scheAnalysis/planListView.vue'),
    meta: { title: '计划表查看', icon: 'xmry', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/company/list',
    name: 'fwebcompany',
    component: () => import('@/views/company/Company.vue'),
    meta: { title: '企业管理', icon: 'dashboard', type: 'main' }
  },
  {
    path: '/fweb/detail/:id',
    name: 'fwebcompanyDetail',
    hidden: true,
    component: () => import('@/views/company/CompanyDetail.vue'),
    meta: { title: '企业信息', icon: 'dashboard', type: 'main' }
  },
  {
    path: '/fweb/account/list',
    name: 'fwebaccount',
    component: () => import('@/views/account/index.vue'),
    meta: { title: '账号管理', icon: 'zhgl', type: 'main' }
  },
  {
    path: '/fweb/systemSet/wbstemplate',
    name: 'fwebwbstemplate',
    meta: { title: 'WBS模板库', icon: 'dashboard', type: 'main', breadcrumb: 'systemSet' },
    component: () => import('@/views/systemSet/WbsTemplate.vue')
  },
  {
    path: '/fweb/systemSet/template',
    name: 'fwebtemplate',
    meta: { title: '模板库', icon: 'dashboard', type: 'main', breadcrumb: 'systemSet' },
    component: () => import('@/views/systemSet/index.vue')
  },
  {
    path: '/fweb/systemSet/resource',
    name: 'fwebresource',
    meta: { title: '资源库', icon: 'dashboard', type: 'main', breadcrumb: 'systemSet' },
    component: () => import('@/views/systemSet/resource/Resource.vue')
  },
  {
    path: '/fweb/systemSet/calendarTemplate',
    name: 'fwebcalendarTemplate',
    meta: { title: '日历库', icon: 'dashboard', type: 'main', breadcrumb: 'systemSet' },
    component: () => import('@/views/systemSet/calendarTemplate/calendarTemplate.vue')
  },
  {
    path: '/fweb/systemSet/codeRule',
    name: 'fwebcodeRule',
    meta: { title: '编码规则', icon: 'dashboard', type: 'main', breadcrumb: 'systemSet' },
    component: () => import('@/views/systemSet/resource/CodeRule.vue')
  },
  {
    path: '/fweb/systemSet/expenseAccountTemplate',
    name: 'fwebexpenseAccount',
    meta: { title: '费用科目', icon: 'dashboard', type: 'main', breadcrumb: 'systemSet' },
    component: () => import('@/views/systemSet/expenseAccountTemplate/expenseAccountTemplate.vue')
  },
  {
    path: '/fweb/approve/list/:id',
    name: 'fwebapprovelist',
    component: () => import('@/views/approve/index.vue'),
    meta: { title: '计划审批', icon: 'jdgl', type: 'project', breadcrumb: 'projectList' }
  },
  {
    path: '/fweb/approve/view',
    name: 'fwebapproveView',
    component: () => import('@/views/approve/approveView.vue'),
    meta: { title: '计划审批查看', icon: 'dashboard', type: 'project', breadcrumb: 'projectList' }
  }
]

const createRouter = () => new Router({
  // mode: 'history', // require service support
  scrollBehavior: () => ({ y: 0 }),
  routes: [...constantRoutes, ...asyncRoutes]
})

const router = createRouter()

// Detail see: https://github.com/vuejs/vue-router/issues/1234#issuecomment-357941465
export function resetRouter() {
  const newRouter = createRouter()
  router.matcher = newRouter.matcher // reset router
}

export default router
