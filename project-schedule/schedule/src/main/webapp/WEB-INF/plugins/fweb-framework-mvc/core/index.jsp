<%@page import="com.hhwy.fweb.framework.api.utils.EnvironmentHelper"%>
<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	// 项目上下文路径
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=contextPath %>" />
	<meta charset="UTF-8">
	<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo.ico" type="image/x-icon" />
	<title><spring:message code="i18n.plugin.manager.listTitle" />-<%=EnvironmentHelper.getContextPath() %></title>
	<link rel="stylesheet" type="text/css" href="fweb-framework-ui/style/css/bootstrap.min.css">
	<link href="fweb-framework-ui/style/css/bootstrap-table.min.css" rel="stylesheet" >
	<script src="fweb-framework-ui/js/jquery.min.js"></script>
	<script src="fweb-framework-ui/js/jquery.json-2.2.js"></script>
	<script src="fweb-framework-ui/js/bootstrap/bootstrap.min.js"></script>
	<script src="fweb-framework-ui/js/bootstrap/bootstrap-modal.js"></script>
	<script src="fweb-framework-ui/js/bootstrap/bootstrap-editable.js"></script>
	<script src="fweb-framework-ui/js/bootstrap/bootstrap-table.min.js"></script>
	<script src="fweb-framework-ui/js/bootstrap/bootstrap-table-editable.js"></script>
	<script src="fweb-framework-ui/js/bootstrap/bootstrap-table-zh-CN.js"></script>
	<script src="fweb-framework-ui/js/jquery.form.min.js"></script>
	<style>
		body {
			font: 12px sans-serif;
		}
		.table > thead > tr > th, .table > tbody > tr > th, .table > tfoot > tr > th, .table > thead > tr > td, .table > tbody > tr > td, .table > tfoot > tr > td{
			vertical-align:middle;
		}
		.panel-default{
			border-color:white;
		}

		.ui-input-file {
			height: 40px
		}
		body.modal-open {
			padding-right: 0 !important;
			overflow-y:hidden;
		}
	</style>
</head>
<body style="margin:8px;">

<!-- text-center -->
<div class="container" style="width:100%;">
	<div class="row">
		<div class="panel panel-default">
			<div id="myAlert" class="alert alert-success" style="display:none;">
				<a href="#" class="close" data-dismiss="alert">&times;</a>
				<span id="message"></span>
			</div>
			<div class="panel-body form-group" style="margin-bottom:0px;">
				<div class="col-xs-2">
					<input class="form-control" type="text" name="pluginName" id="pluginName" placeholder="<spring:message code="i18n.plugin.manager.pluginName" />">
				</div>
				<div class="col-xs-2" >
					<select class="form-control" name="state" id="state"  placeholder="<spring:message code="i18n.plugin.manager.pluginName" />">
						<option value =""><spring:message code="i18n.plugin.manager.all" /></option>
						<option value ="ACTIVE"><spring:message code="i18n.sys.startUsing" /></option>
						<option value ="STOP"><spring:message code="i18n.sys.stopUsing" /></option>
					</select>
				</div>
				<div class="col-xs-2">
					<input class="form-control" id="search_btn" type="button" name="<spring:message code="i18n.sys.query" />" value="<spring:message code="i18n.sys.query" />">
				</div>
				<div class="col-xs-2">
				</div>
			</div>
			<div id="plugin-upload" class="col-sm-10" style="margin-bottom:0px;">
				<form action="/plugin/upload"  name="plugin_form" id="plugin_form" method="post" enctype="multipart/form-data">
					<div class="col-xs-6" style="vertical-align: middle;">
						<input id="uploadFile" name="uploadFile" type="file" style="display:none">
						<div style="display:initial;" id="pluginFileView"></div>
						<a  class="btn btn-default glyphicon glyphicon-level-up" onclick="$('input[id=uploadFile]').click();"><spring:message code="i18n.plugin.manager.upload.browse" /></a>
						<input type="button"  value="<spring:message code="i18n.sys.upload" />"  onclick="uploadPlugin()" class="btn btn-default"/>
					</div>
					<div class="col-xs-2">
						<a data-toggle="modal" href="#repositoriesDialog" class="btn btn-primary btn-large">
							<spring:message code="i18n.plugin.manager.download" /></a>
					</div>
					<div class="col-xs-2">
						<a  data-toggle="modal" href="view/fweb-framework-mvc/core/monitor/run" class="btn btn-primary btn-large" target="_runtimeWin">
							<spring:message code="i18n.plugin.manager.system.load" /></a>
					</div>
				</form>
			</div>
			<div id="repositoriesDialog" class="modal fade" >
				<div class="modal-dialog"  style="width:960px;460px">
					<div class="modal-content">
						<div class="modal-header">
							<a class="close" data-dismiss="modal">×</a>
							<h3><spring:message code="i18n.plugin.manager.browse.repositories" /></h3>
						</div>
						<div class="modal-body" style="width:960px;height:450px">
							<iframe id="repositoriesFrame" frameborder=0  style="width:100%;height:100%"></iframe>
						</div>
						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
						</div>
					</div>
				</div>
			</div>
			<table id="tableSysPlugin"></table>
		</div>

		<script >
			$(function(){

				$('input[id=uploadFile]').change(function() {
					$('#pluginFileView').html($(this).val());
				});

				inittableSysPlugin({});

				$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
					// 获取已激活的标签页的名称
					var activeTab = $(e.target).text();
					// 获取前一个激活的标签页的名称
					var previousTab = $(e.relatedTarget).text();
					$(".active-tab span").html(activeTab);
					$(".previous-tab span").html(previousTab);
				});
				//仓库对话框关闭时刷新插件列表
				$('#repositoriesDialog').on('hide.bs.modal', function () {
					refresh();
				})
				//重新打开时刷新
				$('#repositoriesDialog').on('show.bs.modal', function () {
					$("#repositoriesFrame").attr('src','view/fweb-framework-mvc/core/repositories/plugins?locale=${param.locale}');
				})

			});

			var plugin_constant = {}; //常量
			plugin_constant.ACTIVE = "ACTIVE";//激活
			plugin_constant.STOP = "STOP";
			plugin_constant.INVALID = "INVALID";

			plugin_constant.LAZY = "LAZY";
			plugin_constant.EAGER = "EAGER";//启动时加载

			plugin_constant.BASE = "BASE"; //基础组件
			plugin_constant.BUSINESS = "BUSINESS";//业务组件 默认
			plugin_constant.APP = "APP";//应用组件

			var currentPluginId ;

			function inittableSysPlugin(data){
				$('#tableSysPlugin').bootstrapTable({
					url: 'core/plugin/list',
					method: 'get',                      //请求方式（*）
					striped: true,                      //是否显示行间隔色
					cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
					pagination: true,                   //是否显示分页（*）
					useCurrentPage:true, 				//
					editable:true,						//开启编辑模式
					sortable: false,                     //是否启用排序
// 			 			clickToSelect:true,					// 点击 行选中
//			 			sortOrder: "asc",                   //排序方式
					queryParamsType:'limit',//查询参数组织方式
					queryParams:queryParams,//请求服务器时所传的参数
//			 		 	sidePagination: "server",           //分页方式：client客户端分页，server服务端分页（*）
					pageNumber: 1,                       //初始化加载第一页，默认第一页
					pageSize: 10,	                  //每页的记录行数（*）
					undefinedText : '',
					pageList : [ 5, 10, 20 ],
					showColumns : true, // 显示隐藏列
					showRefresh : true, // 显示刷新按钮
					columns: [{
						title: '<spring:message code="i18n.sys.sequenceNumber" />',
						align:'center',
						formatter: function (value, row, index) {
							return index+1;
						}
					}, {
						field: 'type',
						title: '<spring:message code="i18n.plugin.manager.type" />',
						align:'center',
						formatter:function(value, row, index) {
							return row.typeView;

						}
					}, {
						field: 'pluginName',
						title: '<spring:message code="i18n.plugin.manager.pluginName" />',
						formatter:function(value, row, index) {
							var v = value;
							if(undefined == v){
								v = "";
							}
							return '<a style="cursor:pointer" onclick="pluginDetails('+ "'" + row.pluginId +"'"+ ');">'+v+'</a>'
						}
					}, {
						field: 'pluginDesc',
						visible:false,
						align:'center',
						title: '<spring:message code="i18n.sys.desc" />',
					}, {
						field: 'version_',
						title: '<spring:message code="i18n.sys.version" />',
					}, {
						field: 'sort',
						align:'center',
						title: '<spring:message code="i18n.plugin.manager.order" />',
						width:'18px',
						editable: {
							type: 'number',
							title: '<spring:message code="i18n.plugin.manager.order" />',
							validate: function (value) {
								if ($.trim(value) == '') {
									return '<spring:message code="i18n.sys.notEmpty" />!';
								}
							}
						}
					}, {
						field: 'fetchType',
						title: '<spring:message code="i18n.sys.fetchType" />',
						width:'18px',
						align:'center',
						editable: {
							type: 'select',
							width:'180px',
							placement: 'top',
							source: [{ value: 'LAZY', text: '  <spring:message code="i18n.sys.yes" />  ' },
								{ value: 'EAGER', text: '  <spring:message code="i18n.sys.no" />  ' }],
							title: '<spring:message code="i18n.sys.yes" /><spring:message code="i18n.sys.no" /><spring:message code="i18n.sys.fetchType" />'
						}
					}, {
						field: 'pluginId',
						align:'center',
						visible:false,
						title: '<spring:message code="i18n.plugin.manager.pluginId" />',
						formatter:function(value, row, index) {
							return '<a style="cursor:pointer" onclick="pluginDetails('+ "'" + row.pluginId +"'"+ ');">'+value+'</a>'
						}
					}, {
						field: 'state',
						align:'center',
						title: '<spring:message code="i18n.sys.startUsing" />',
						formatter:function(value, row, index) {
							return row.stateView;
						}
					}, {
						field: 'runView',
						align:'center',
						title: '<spring:message code="i18n.sys.run" />'
					}, {
						field: 'startupTime',
						align:'center',
						title: '<spring:message code="i18n.sys.runTime" />'
					}, {
						field: '',
						align:'center',
						cellStyle:function(){
							return {
								css : {
									"white-space" : "nowrap"
								}
							}
						},
						title: '<spring:message code="i18n.sys.operation" />',
						formatter:function(value, row, index) {
							var btn = [];
							if(plugin_constant.INVALID != row.state ){
								if(plugin_constant.BASE != row.type ){

									if(row.state == "ACTIVE"){ // 启用  显示停用
										btn.push('<a style="cursor:pointer" title=""  onclick="destroy(' + "'" + row.pluginId + "'"+ ' )" id=""  ><spring:message code="i18n.plugin.manager.stop" /> </a>')
									}else{
										btn.push('<a style="cursor:pointer" onclick="loadPlugin('+ "'"  + row.pluginId + "'" + ',plugin_constant.ACTIVE)" id=""  ><i class="glyphicon glyphicon-"></i><spring:message code="i18n.sys.startUsing" /> </a>')
									}

									btn.push('<a  style="cursor:pointer" onclick="pl_restart('+ "'"  + row.pluginId + "'" + ')" id="" ><i class="glyphicon glyphicon-"></i><spring:message code="i18n.sys.restart" /></a>')
									btn.push('<a  style="cursor:pointer" title="<spring:message code="i18n.sys.delTitle" />" onclick="deletePlugin('+ "'"  + row.pluginId + "'" + ')" id=""  ><i class="glyphicon glyphicon-"></i><spring:message code="i18n.sys.del" /></a>')
								}
								btn.push('<a  style="cursor:pointer"  data-toggle="modal"  onclick="showParameters('+ "'"  + row.pluginId + "'"+');" title="<spring:message code="i18n.plugin.manager.parametersSet" />"   ><i class="glyphicon glyphicon-"></i><spring:message code="i18n.plugin.manager.parametersSet" /></a>')
								//无效组件
							}else{
								btn.push('<a title="<spring:message code="i18n.plugin.manager.invalid.title" />"><spring:message code="i18n.plugin.manager.invalid" /></a>')
							}
							return btn.join(" | ");
						}
					}],onEditableSave: function (field, row, oldValue, $el) {
						$.ajax({
							type: 'PUT',
							contentType: "application/json;charset=utf-8",
							data :JSON.stringify(row),
							url: "core/plugin/operation_par",
							success: function(r){
							},
							error: function (data){
								alert("<spring:message code="i18n.sys.error" />!");
							}
						});
						return false;
					}
				});



				$('#tableSysPluginParameters').bootstrapTable({
					url: '',
					method: 'get',                      //请求方式（*）
					striped: true,                      //是否显示行间隔色
					cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
					pagination: false,                   //是否显示分页（*）
					useCurrentPage:true, 				//
					editable:true,						//开启编辑模式
					sortable: false,                     //是否启用排序
//			 		clickToSelect:true,					// 点击 行选中
//		 			sortOrder: "asc",                   //排序方式
					height:460,
					undefinedText : '',
					columns: [{
						title: '<spring:message code="i18n.sys.sequenceNumber" />',
						formatter: function (value, row, index) {
							return index+1;
						}
					}, {
						field: 'key',
						title: '<spring:message code="i18n.sys.key" />',
						editable: {
							type: 'text',
							title: '<spring:message code="i18n.sys.value" />',
							validate: function (v) {
								if (!v) return '<spring:message code="i18n.sys.key" /><spring:message code="i18n.sys.notEmpty" />';

							}
						}
					}, {
						field: 'value',
						title: '<spring:message code="i18n.sys.value" />',
						formatter:function(value, row, index) {
							return value;
						},
						editable: {
							type: 'text',
							title: '<spring:message code="i18n.sys.value" />',
							validate: function (v) {
								if (!v) return '<spring:message code="i18n.sys.value" /><spring:message code="i18n.sys.notEmpty" />!';

							}
						}
					}, {
						field: 'updateTime',
						title: '<spring:message code="i18n.sys.updateTime" />',
						formatter:function(value, row, index) {
							return value;
						}
					}, {
						field: 'opt',
						title: '<spring:message code="i18n.sys.operation" />',
						formatter:function(value, row, index) {
							row.rowId = index;
							var btn = [];
							btn.push('<button type="button"  onclick="delParameters('+ "'"+row.rid+ "'"+','+ "'"  + row.id + "'" + ','+ "'"  + row.pluginId + "'" + ');" class="btn btn-default"><i class="glyphicon glyphicon-">删除</i> </button>');
							return btn;
						}
					}],onEditableSave: function (field, row, oldValue, $el) {
						$.ajax({
							type: 'PUT',
							contentType: "application/json;charset=utf-8",
							data :JSON.stringify(row),
							url: "core/plugin/parameters/upload/",
							success: function(r){
								row.id = r.id;
								$("#tableSysPluginParameters").bootstrapTable('updateCell',{index:row.rowId,field:'opt',value:''});
							},
							error: function (data){
								alert("<spring:message code="i18n.sys.update" /><spring:message code="i18n.sys.error" />!");//msg.errCode
							}
						});
						return false;
					}
				});


				$('#tableSysPluginParameters_sel').bootstrapTable({
					url: '',
					method: 'get',                      //请求方式（*）
					striped: true,                      //是否显示行间隔色
					cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
					pagination: false,                   //是否显示分页（*）
					useCurrentPage:true, 				//
					checkbox:true,						//开启编辑模式
					sortable: false,                     //是否启用排序
//			 			clickToSelect:true,					// 点击 行选中
//		 			sortOrder: "asc",                   //排序方式
					height:260,
					undefinedText : '',
					columns: [
						{
							checkbox: true
						},{
							title: '<spring:message code="i18n.sys.sequenceNumber" />',
							formatter: function (value, row, index) {
								return index+1;
							}
						}, {
							field: 'key',
							title: '<spring:message code="i18n.sys.key" />',
							editable: {
								type: 'text',
								title: '<spring:message code="i18n.sys.key" />',
								validate: function (v) {
									if (!v) return '<spring:message code="i18n.sys.notEmpty" />';

								}
							}
						}, {
							field: 'value',
							title: '<spring:message code="i18n.sys.value" />',
							formatter:function(value, row, index) {
								return value;
							},
							editable: {
								type: 'text',
								title: '<spring:message code="i18n.sys.value" />',
								validate: function (v) {
									if (!v) return '<spring:message code="i18n.sys.notEmpty" />!';

								}
							}
						}]
				});

				$('#runtimeInfo').bootstrapTable({
					url: '',
					method: 'get',                      //请求方式（*）
					striped: true,                      //是否显示行间隔色
					cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
					pagination: false,                   //是否显示分页（*）
					useCurrentPage:true, 				//
					sortable: false,                     //是否启用排序
					height:260,
					undefinedText : '',
					columns: [
						{
							title: '<spring:message code="i18n.sys.sequenceNumber" />',
							width:20,
							formatter: function (value, row, index) {
								return index+1;
							}
						}, {
							field: 'className',
							title: '<spring:message code="i18n.sys.class" />'
						}, {
							field: 'url',
							title: '<spring:message code="i18n.sys.path" />',
							formatter: function (value, row, index) {
								var requestURL = encodeURI(row.path);
								var paramJson =  row.paramJson;
								var method = row.method;
								return "<a href='view/fweb-rest-ui/restui?c="+row.className+"&requestURL="+requestURL+"&paramJson="+paramJson+"&method="+method+"'  alt='安装fweb-rest-ui组件以后可以打开测试页面' target='_blank'>"+value+"</a>";
							}
						}, {
							field: 'desc',
							title: '<spring:message code="i18n.sys.interfaceDesc" />'
						}]
				});
				$('#pageInfo').bootstrapTable({
					url: '',
					method: 'get',                      //请求方式（*）
					striped: true,                      //是否显示行间隔色
					cache: false,                       //是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
					pagination: false,                   //是否显示分页（*）
					useCurrentPage:true, 				//
					sortable: false,                     //是否启用排序
					height:260,
					undefinedText : '',
					columns: [
						{
							title: '<spring:message code="i18n.sys.sequenceNumber" />',
							width:20,
							formatter: function (value, row, index) {
								return index+1;
							}
						}, {
							field: 'pageName',
							title: '<spring:message code="i18n.sys.pageName" />',
							formatter: function (value, row, index) {
								return "<a href="+row.pagePath+" target='_blank'>"+value+"</a>";
							}
						}]
				});

			};

			//请求服务数据时所传参数
			function queryParams(params){
				var pluginName = $('#pluginName').val();
				var state = $('#state').val();
				var	search_type = $('#search_type').val();
				var param = {};
				param.pageSize = params.limit || 10;
				param.pageIndex = params.pageNumber || (params.offset/param.pageSize)+1;
				if(pluginName){
					param.pluginName = pluginName;
				}
				if(state){
					param.state = state;
				}
				if(search_type){
					param.type = search_type;
				}
				return param;
			}

			//查询按钮事件
			$('#search_btn').click(function(){
				refresh();
			})

			// 操作按钮事件
			function destroy(pluginId){
				$.ajax({
					type: 'DELETE',
					url: "core/plugin/destroy/"+pluginId,
					success: function(){
						refresh();
					}
				});
			}

			function loadPlugin(pluginId){
				$("#loadingModal").modal('show');
				$.ajax({
					type: 'GET',
					url: "core/plugin/load/"+pluginId,
					success: function(msg){
						$("#loadingModal").modal('hide');
						refresh();
						console.log(msg)
						if(msg && msg.result == 'success'){

							alertMessage("<strong><spring:message code="i18n.sys.loadSuccess" />！</strong>")
						}else{
							alert(" Loading Plugin failed!");
						}
					}
				});
			}

			function pl_restart(pluginId){
				$("#loadingModal").modal('show');
				$.ajax({
					type: 'GET',
					url: "core/plugin/reload/"+pluginId,
					success: function(){
						refresh();
						$("#loadingModal").modal('hide');
					},
					error: function (data)
					{
						alert("Start Error!");
						$("#loadingModal").modal('hide');
					}
				});
			}


			function deletePlugin(pluginId){
				var msg = "<spring:message code="i18n.sys.warn" />：<spring:message code="i18n.sys.delAlert" />";
				msg = msg.replace("{0}","【"+pluginId+"】");
				if (confirm(msg)==true){
					$.ajax({
						type: 'DELETE',
						url: "core/plugin/delete/"+pluginId,
						success: function(){
							refresh();
						}
					});
				}else{
					return false;
				}
			}


			function refresh(){
				$("#tableSysPlugin").bootstrapTable('refresh', {});
			}

			function uploadPlugin(){

				$("#plugin_form").ajaxSubmit({
					url: "core/plugin/upload",
					type: "post",
					enctype: 'multipart/form-data',
					//iframe: true,
					success: function (data)
					{
						alert("<spring:message code="i18n.sys.loadSuccess" />");
						$('#pluginFileView').html("");
						document.getElementById("plugin_form").reset();
						refresh();
					},
					error: function (data)
					{
						$('#pluginFileView').html("");
						document.getElementById("plugin_form").reset();
						alert("<spring:message code="i18n.sys.error" />");//msg.errCode
					}
				})
			}

			$(".fixed-table-toolbar").insertBefore($("plugin-upload"));

			function alertMessage(mes){
				$("#message").html(mes);
				$("#myAlert").show();
				setTimeout(function(){
					$("#myAlert").hide(1000);

				},5000);
			}

			function pluginDetails(pluginId){
				$("#runtimeInfo").bootstrapTable("removeAll");
				currentPluginId = pluginId;
				$.ajax({
					type: 'GET',
					url: "core/plugin/detail/"+pluginId,
					success: function(data){
						$("#pluginId_d").html(data.pluginId);
						$("#pluginName_d").html(data.pluginName);
						$("#groupId_d").html(data.groupId);
						$("#packageName_d").html(data.packageName);
						$("#state_d").html(data.stateView);
						$("#fetchType_d").html(data.fetchTypeView);
						$("#jarName_d").html(data.jarName);
						$("#type_d").html(data.typeView);
						$("#version_d").html(data.version_);
						$("#sort_d").html(data.sort);
						$("#dependency_d").html(data.dependency);
						$("#pluginDesc_d").html(data.pluginDesc);
						$("#startupTime_d").html(data.startupTime);
						$('#pluginDetails').modal('show')
					}
				});

				var opt = {
					url: "core/plugin/controller/"+pluginId,
					silent: true
				};
				$("#runtimeInfo").bootstrapTable('refresh',opt);
				var pageOpt = {
					url: "core/plugin/pages/"+pluginId,
					silent: true
				};
				$("#pageInfo").bootstrapTable('refresh',pageOpt);
			}

			function addParameter(){
				var pId = $("#tableSysPluginParameters").bootstrapTable('getOptions').pluginId+"";
				var rowObj = $("#tableSysPluginParameters").bootstrapTable('insertRow',{index:0,row:{id:'',key:'<spring:message code="i18n.sys.enter" /><spring:message code="i18n.sys.key" />',value:'<spring:message code="i18n.sys.enter" /><spring:message code="i18n.sys.value" />',"pluginId":pId,rid:Math.random()+''}});
			}

			function parametersApply(){
				var pId = $("#tableSysPluginParameters").bootstrapTable('getOptions').pluginId+"";
				$.ajax({
					type: 'get',
					url: "core/plugin/parameters/apply/"+pId,
					success: function(){
						$('#myModal').modal('hide');
					},
					error: function (data)
					{
						alert("<spring:message code="i18n.sys.error" />!");
					}
				});
			}

			function delParameters(rid,id,pluginId){
				if(id !=''){
					$.ajax({
						type: 'DELETE',
						url: "core/plugin/parameters/delete/"+id,
						success: function(){
							//showParameters(pluginId);
							$("#tableSysPluginParameters").bootstrapTable('remove',{ field:'id',values:[id]})
						}
					});
				}else{
					$("#tableSysPluginParameters").bootstrapTable('remove',{ field:'rid',values:[rid]})

				}
			}

			function showParameters(pluginId){
				var opt = {
					url: "core/plugin/parameters/list",
					silent: true,
					query:{
						"pluginId":pluginId
					}
				};
				$("#tableSysPluginParameters").bootstrapTable('getOptions').pluginId=pluginId;
				$("#tableSysPluginParameters").bootstrapTable('refresh',opt);
				$('#myModal').modal('show');

			}

			function selParameters(){
				$('#myModal_par').modal('show');

			}
			function showInterfaceDetail(){
				window.open("core/plugin/resources/"+currentPluginId,"_interfaceDetailWin");
			}

		</script>
	</div>
</div>
<div class="modal fade" id="pluginDetails" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog" style="width:980px;height:720px">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					<spring:message code="i18n.plugin.manager.pluginDetails" />
				</h4>
			</div>
			<div class="modal-body">
				<ul id="myTab" class="nav nav-tabs">
					<li class="active"><a href="#plugin_baseInfo" data-toggle="tab"><spring:message code="i18n.sys.baseInfo" /></a></li>
					<li style="display:none"><a href="#runtime_info" data-toggle="tab"><spring:message code="i18n.sys.runtimeInfo" /></a></li>
					<li >
						<a href="#plugin_runtimeInfo" data-toggle="tab"><spring:message code="i18n.plugin.manager.interfaceInfo" /></a>
					</li>
					<li >
						<a href="#plugin_page" data-toggle="tab"><spring:message code="i18n.plugin.manager.pageInfo" /></a>
					</li>
				</ul>
				<div class="tab-content">
					<div class="tab-pane active" id="plugin_baseInfo">
						<table class="table table-bordered table-striped">
							<tbody>
							<tr>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.plugin.manager.name" /></th>
								<td  class="text-muted" colspan="3"  id="pluginName_d"></td>
								<th class="text-nowrap" scope="row" ><spring:message code="i18n.sys.startUsing" /></th>
								<td id="state_d" ></td>
							</tr>
							<tr>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.sys.version" /></th>
								<td  id="version_d" ></td>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.plugin.manager.type" /></th>
								<td id="type_d" ></td>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.plugin.manager.pluginId" /></th>
								<td id="pluginId_d"> </td>
							</tr>
							<tr>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.sys.runTime" /></th>
								<td id="startupTime_d"></td>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.plugin.manager.order" /></th>
								<td id="sort_d"></td>
								<th class="text-nowrap" scope="row">group_id</th>
								<td id="groupId_d"> </td>
							</tr>
							<tr>
								<th class="text-nowrap" scope="row">jar_<spring:message code="i18n.sys.fileName" /></th>
								<td class="text-muted" colspan="3"  id="jarName_d"></td>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.sys.fetchType" /></th>
								<td id="fetchType_d"></td>
							</tr>
							<tr>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.plugin.manager.dependency" /></th>
								<td colspan="5" id="dependency_d" ></td>
							</tr>
							<tr>
								<th class="text-nowrap" scope="row"><spring:message code="i18n.sys.desc" /></th>
								<td colspan="5"  id="pluginDesc_d" ></td>
							</tr>
							</tbody>
						</table>
					</div>

					<div id="runtime_info" class="tab-pane">
						<center> <stong></stong></center>
					</div>
					<div id="plugin_runtimeInfo" class="tab-pane">  <stong><a  class="btn btn-primary btn-large" onclick="showInterfaceDetail()" >
						<spring:message code="i18n.plugin.manager.interfaceDetail" /></a></stong> <br/><br/>
						<table id="runtimeInfo" >
						</table>
					</div>
					<div id="plugin_page" class="tab-pane">
						<table id="pageInfo" >
						</table>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button"  class="btn btn-default" data-dismiss="modal"><spring:message code="i18n.sys.close" />
				</button>
			</div>
		</div>

		<!-- /.modal-content -->
	</div><!-- /.modal -->
</div>


<div class="modal fade" id="myModal"  tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" >
	<div class="modal-dialog" style="height: 520px;width:800px">
		<div class="modal-content">
			<div class="modal-header" >
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					<spring:message code="i18n.plugin.manager.parametersSet" />
				</h4>
			</div>
			<div class="modal-body" style="height: 520px;width:760px">
				<div id="toolbar">
					<button type="button" onclick="addParameter();" class="btn btn-default btn-sm">
						<span class="glyphicon glyphicon-plus"></span> <spring:message code="i18n.sys.add" />
					</button>
					<!--
              <button type="button" onclick="selParameters();" class="btn btn-default btn-sm">
                  <span class="glyphicon glyphicon-import"></span> 导入
                </button> -->
				</div>
				<table id="tableSysPluginParameters" style="word-break:break-all; word-wrap:break-all;" ></table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="i18n.sys.close" />
				</button>

				<button type="button" class="btn btn-primary"  onclick="parametersApply();"><spring:message code="i18n.sys.apply" />
				</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->
</div>

<div class="modal fade" id="myModal_par"   aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header" >
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					<spring:message code="i18n.plugin.manager.parameters" />
				</h4>
			</div>
			<div class="modal-body" style="height: 320px">
				<table id="tableSysPluginParameters_sel" style="word-break:break-all; word-wrap:break-all;" ></table>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code="i18n.sys.close" />
				</button>
			</div>
		</div><!-- /.modal-content -->
	</div><!-- /.modal -->
</div>


<div class="modal fade" id="loadingModal" data-backdrop="static" transparent="true"  >
	<div style="width: 400px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-200px;margin-top:-10px">
		<div class="progress progress-striped active" style="margin-bottom: 0;">
			<div class="progress-bar" style="width: 100%;"></div>
		</div>
		<h3>Loading Plugin...</h3>
	</div>
</div>
</body>
</html>