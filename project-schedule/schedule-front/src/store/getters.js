const getters = {
  sidebar: state => state.app.sidebar,
  device: state => state.app.device,
  token: state => state.user.token,
  avatar: state => state.user.avatar,
  name: state => state.user.name,
  userId: state => state.user.userId,
  tentantId: state => state.user.tentantId,
  filetoken: state => state.user.filetoken,
  roleIds: state => state.user.roleIds,
  projectRoleIds: state => state.user.projectRoleIds,
  permission_routes: state => state.permission.routes,
  projectName: state => state.project.name
}
export default getters
