<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	// 项目上下文路径
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" ng-app="clientApp" ng-csp>
<head>
<base href="<%=contextPath%>/fweb-securit/ac/" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>组件资源初始化</title>
<link rel="shortcut icon"
	href="${config.ui() }fweb-framework-ui/style/icons/fweblogo.ico"
	type="image/x-icon" />
<link rel="stylesheet" type="text/css"
	href="${config.ui()}fweb-framework-ui/style/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="${config.ui()}fweb-framework-ui/style/easyui/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${config.ui()}fweb-framework-ui/style/css/fweb.css">

<script type="text/javascript"
	src="${config.ui()}fweb-framework-ui/js/jquery.min.js"></script>
<script type="text/javascript"
	src="${config.ui()}fweb-framework-ui/js/bootstrap/bootstrap.min.js"></script>
<script type="text/javascript"
	src="${config.ui()}fweb-framework-ui/js/jquery.json-2.2.js"></script>
<script type="text/javascript"
	src="${config.ui()}fweb-framework-ui/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${config.ui()}fweb-framework-ui/js/easyui/insdep/jquery.insdep-extend.min.js"></script>
<script type="text/javascript" src="${config.ui() }style/js/alerts.js"></script>
<style type="text/css">
		body {
		    font-family:verdana,helvetica,arial,sans-serif;
		    font-size:12px;
		    margin:0;
		}
		.panel-tool {
		  position: absolute;
		  top: 60%;
		  margin-top: -11px;
		  height: 16px;
		  overflow: hidden;
		}
		.panel-tool a {
		  display: inline-block;
		  width: 16px;
		  height: 16px;
		  opacity: 0.6;
		  filter: alpha(opacity=60);
		  margin: 0;
		  vertical-align: top;
		}
		.layout-button-right {
		  background-position:0 -16px;
		}
		.panel-tool-close {
		    background-position: -16px 0px;
		}
		.messager-question {
		    background-position: -32px 0;
		}
		.messager-icon {
		    float: left;
		    width: 32px;
		    height: 42px;
		    margin: 5px 20px 0 20px;
		}
	</style>
</head>
<body class=" easyui-layout">
	<div class="content-layout-center"
		data-options="region:'center',border:false" id="center_content">
		<div id="tb">
			<div id="security_plugin_list"
				class="form-inline container-fluid search-form">
				<div id="searchDiv" class="row form-group">
					<div class="form-input col-md-6 col-sm-6 col-xs-6">
						<div class="form-input-label">
							<label for="" class="control-label">组件名：</label>
						</div>
						<div class="form-input-input">
							<input name="pluginName" type="text" class="form-control" onKeyPress="checkey(event.keyCode||event.which)"
								id="pluginName" placeholder="请输入组件名">
						</div>
					</div>
					<div class="col-md-6 col-xs-6 col-sm-6 search-button">
						<a onclick="loadGrid()" class="btn btn-primary">查&nbsp;询</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<a onclick="loadResources()" class="btn btn-warning">加载资源</a>
					</div>
				</div>
			</div>

			<div class="toolbar-table-btn"></div>

		</div>
		<table id="plugindg" class="easyui-datagrid" fit="true"
			style="width: auto;">
		</table>
	</div>
	<script type="text/javascript">
		var path = '${config.path()}';
		$(document).ready(function() {
			loadGrid();
		});
		function checkey(e){
			if(e == 13){
				loadGrid();
			}
		}
		function loadGrid() {
			var pluginId = $("#pluginName").val();
			$("#plugindg")
					.datagrid(
							{
								method : 'get',
								url : path+'resources/plugins?name='
										+ pluginId,
								pagination : true,
								fit : true,
								fitColumns : true,
								striped : true,
								scrollbarSize : 0,
								singleSelect : false,
								toolbar : '#tb',
								columns : [ [
										{
											field : "ck",
											checkbox : true,
											width : '6%'

										},
										{
											field : "Plugin-Id",
											title : "<b>组件编号</b>",
											width : '18%'

										},
										{
											field : "Plugin-Name",
											title : "<b>组件名称</b>",
											width : '30%'
										},
										{
											field : "Plugin-Version",
											width : '12%',
											title : "<b>版本</b>"
										},
										{
											field : "Plugin-PublishTime",
											width : '12%',
											title : "<b>发布时间</b>"
										},
										{
											field : "Load_Time",
											width : '12%',
											title : "<b>资源加载时间</b>"
										},
										{
											field : "opt",
											title : "<b>操作</b>",
											width : '8%',
											formatter : function(value, row,
													index) {
												var str = '';
												str += '&nbsp;&nbsp;<a href="javascript:void(0)" title="点击把组件的资源（接口）注册到权限组件" onclick="loadResource(\''
														+ row['Plugin-Id']
														+ '\',\''
														+ row['Plugin-Name']
														+ '\')">加载</a>';
												return str;
											}
										} ] ],
							});
		}
		function loading(){
			$.messager.progress({title:'请稍等',
					msg:'资源加载处理中...'
			});
		}
		//加载单个组件的资源
		function loadResource(pluginId, name) {
			 loading();
			$.ajax({
				url : path+"resources/load?pluginId=" + pluginId,
				type : 'post',
				success : function(data) {
					$.messager.progress('close');
					if(data.state == 'success'){

						$.messager.alert({
							title:'资源加载',
							msg:'组件'+name+'的资源已经加载！'
						});

						 loadGrid() ;

					}else{
						$.messager.alert({
							title:'资源加载',
							msg:'加载组件'+name+'的资源失败！原因：【'+data.msg+'】'
						});
					}

				},
				error: function(){
					$.messager.progress('close');
				}

			});
		}
		//加载所有选中组件的资源
		function loadResources(){
			 loading();
			var rows = $("#plugindg").datagrid("getSelections");
			var ids = new Array();
			for(i =0; i <rows.length ; i++){
				ids.push( rows[i]['Plugin-Id']);
			}

			$.ajax({
				url : path+"resources/loadMulti",
				type : 'post',
				data : {'ids': ids},
				dataType: 'json',
				success : function(data) {
					$.messager.progress('close');
					if(data.state == 'success'){

						$.messager.alert({
							title:'资源加载',
							msg:'所选组件的资源已经加载！'
						});
						 loadGrid() ;
					}else{
						$.messager.alert({
							title:'资源加载',
							msg:'加载组件'+name+'的资源失败！原因：【'+data.msg+'】'
						});
					}

				},
				error: function(){
					$.messager.progress('close');
				}
			});
		}
	</script>
</body>