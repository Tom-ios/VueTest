<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<base href="<%=request.getContextPath()%>" />
<meta charset="UTF-8">
<title><spring:message code="i18n.plugin.manager.repositoryTitle" /></title>
<link href="fweb-framework-ui/style/css/bootstrap.min.css" rel="stylesheet" type="text/css">
<link href="fweb-framework-ui/style/css/bootstrap-table.min.css" rel="stylesheet">
<link href="fweb-framework-ui/style/easyui/bootstrap/easyui.css" rel="stylesheet" type="text/css">
<link href="fweb-framework-ui/style/easyui/icon.css" rel="stylesheet" type="text/css">
<script src="fweb-framework-ui/js/jquery.min.js"></script>
<script src="fweb-framework-ui/js/jquery.json-2.2.js"></script>
<script src="fweb-framework-ui/js/easyui/jquery.easyui.min.js"></script>
<script src="fweb-framework-ui/js/bootstrap/bootstrap.min.js"></script>
<script src="fweb-framework-ui/js/bootstrap/bootstrap-modal.js"></script>
<style>
body {
	font: 14px sans-serif;
}
.datagrid-header-row,.datagrid-row {
	height: 38px;
}
</style>
</head>
<body style="margin: 2px;">
	<table id="pluginsList" style="width:100%;height:400px"> </table>
	<div id="pluginRepositoryTools" style="padding: 2px 5px;height:38px">
		<b><spring:message code="i18n.plugin.manager.repositoryTitle" /></b>
		: <select id="servers" class="easyui-combobox" panelHeight="auto" style="width:300px"
				data-options="valueField:'serverURL',textField:'serverURL',method:'get', url:'core/repositories/servers',
				onLoadSuccess : function() {	
						var data = $('#servers').combobox('getData');
						if (data && data.length > 0) {
							$('#servers').combobox('setValue', data[0].serverURL);
							initGrid();
						}
					}"></select> 
		 <a href="javascript:void(0)" title="Click to download The Latest plugin's List" class="easyui-linkbutton" onclick="initGrid(true)"><spring:message code="i18n.plugin.repository.loadplugins" /></a>
	</div><!-- 暂不用 -->
	<div class="modal fade">  
	  <div class="modal-dialog modal-sm" style="position: absolute;left:50%;top: 45%;transform: translateY(-50%);">
	        <img src="data:image/gif;base64,R0lGODlhGQAZAJECAK7PTQBjpv///wAAACH/C05FVFNDQVBFMi4wAwEAAAAh/wtYTVAgRGF0YVhNUDw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuNS1jMDE0IDc5LjE1MTQ4MSwgMjAxMy8wMy8xMy0xMjowOToxNSAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDo5OTYyNTQ4Ni02ZGVkLTI2NDUtODEwMy1kN2M4ODE4OWMxMTQiIHhtcE1NOkRvY3VtZW50SUQ9InhtcC5kaWQ6RUNGNUFGRUFGREFCMTFFM0FCNzVDRjQ1QzI4QjFBNjgiIHhtcE1NOkluc3RhbmNlSUQ9InhtcC5paWQ6RUNGNUFGRTlGREFCMTFFM0FCNzVDRjQ1QzI4QjFBNjgiIHhtcDpDcmVhdG9yVG9vbD0iQWRvYmUgUGhvdG9zaG9wIENDIChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjk5NjI1NDg2LTZkZWQtMjY0NS04MTAzLWQ3Yzg4MTg5YzExNCIgc3RSZWY6ZG9jdW1lbnRJRD0ieG1wLmRpZDo5OTYyNTQ4Ni02ZGVkLTI2NDUtODEwMy1kN2M4ODE4OWMxMTQiLz4gPC9yZGY6RGVzY3JpcHRpb24+IDwvcmRmOlJERj4gPC94OnhtcG1ldGE+IDw/eHBhY2tldCBlbmQ9InIiPz4B//79/Pv6+fj39vX08/Lx8O/u7ezr6uno5+bl5OPi4eDf3t3c29rZ2NfW1dTT0tHQz87NzMvKycjHxsXEw8LBwL++vby7urm4t7a1tLOysbCvrq2sq6qpqKempaSjoqGgn56dnJuamZiXlpWUk5KRkI+OjYyLiomIh4aFhIOCgYB/fn18e3p5eHd2dXRzcnFwb25tbGtqaWhnZmVkY2JhYF9eXVxbWllYV1ZVVFNSUVBPTk1MS0pJSEdGRURDQkFAPz49PDs6OTg3NjU0MzIxMC8uLSwrKikoJyYlJCMiISAfHh0cGxoZGBcWFRQTEhEQDw4NDAsKCQgHBgUEAwIBAAAh+QQFCgACACwAAAAAGQAZAAACTpSPqcu9AKMUodqLpAb0+rxFnWeBIUdixwmNqRm6JLzJ38raqsGiaUXT6EqO4uIHRAYQyiHw0GxCkc7l9FdlUqWGKPX64mbFXqzxjDYWAAAh+QQFCgACACwCAAIAFQAKAAACHYyPAsuNH1SbME1ajbwra854Edh5GyeeV0oCLFkAACH5BAUKAAIALA0AAgAKABUAAAIUjI+py+0PYxO0WoCz3rz7D4bi+BUAIfkEBQoAAgAsAgANABUACgAAAh2EjxLLjQ9UmzBNWo28K2vOeBHYeRsnnldKBixZAAA7" />  
	  </div>
	</div>
	<div class="modal fade" id="repositoryModal" data-backdrop="static" transparent="true"  >
		<div style="width: 460px;height:20px; z-index: 20000; position: absolute; text-align: center; left: 50%; top: 50%;margin-left:-240px;margin-top:-10px">
			<div class="progress progress-striped active" style="margin-bottom: 0;">
				<div class="progress-bar" style="width: 100%;"></div>
			</div>
			<h3><div id="modalMsg" style="color:#39c;">Installing...</div></h3>
		</div>
	</div>
	<script type="text/javascript">
		var serverURL="127.0.0.1";
		function hideModal(){  
	        $('#repositoryModal').modal('hide');  
	    }  
	      
	    function showModal(msg){  
	    	$("#modalMsg").html(msg)
	    	$('#repositoryModal').modal({backdrop:'static',keyboard:false});  
	    } 
		function initGrid(refresh) {
			serverURL = $("#servers").combobox('getValue');
			if(refresh ){
				$('#pluginsList').treegrid('load', {'serverURL': serverURL	, 'refresh':true});
			}else{
				$('#pluginsList').treegrid('load', {'serverURL': serverURL	});
			}
		}
		//安装组件
		function installPlugin(id  , artifactId , version) {
			 showModal('Installing '+artifactId+' '+version);
			$.ajax({
				   type: "get",
				   url: "core/repositories/install/"+id,
				   success: function(msg){
					   initGrid();
					   hideModal();
				   },
				   error: function (data){
		 		         alert("<spring:message code="i18n.sys.update" /><spring:message code="i18n.sys.error" />!");//msg.errCode
		 		        hideModal();
		 		      }
				});
		}
		//更新组件
		function updatePlugin(id  , artifactId , version) {
			showModal('Installing '+artifactId+' '+version);
			$.ajax({
				   type: "get",
				   url: "core/repositories/update/"+id,
				   success: function(msg){
					   initGrid();
					   hideModal();
				   },
				   error: function (data){
		 		         alert("<spring:message code="i18n.sys.update" /><spring:message code="i18n.sys.error" />!");//msg.errCode
		 		        hideModal();
		 		      }
				});
		}
		$('#pluginsList').treegrid({
			url : 'core/repositories/plugins',
			method : 'post',
			queryParams : {
				'serverURL' : serverURL
			},
			striped : true,
			fitColumns : true,
			singleSelect : true,
			idField:'id',
			treeField:'name', 
			state : 'close',
			toolbar : '#pluginRepositoryTools',
			loadMsg : 'Loading plugins info, please wait...', 
			columns : [ [
				{
					field : 'artifactId',
					halign : 'center',
					title : '<b><spring:message code="i18n.plugin.manager.pluginName" /></b> ',
					width : 160
				},
				{
					field : 'desc',
					halign : 'center',
					title : '<b><spring:message code="i18n.plugin.repository.desc" /></b>',
					width : 180,
					align : 'left'
				},
				{
					field : 'version',
					halign : 'center',
					title : '<b><spring:message code="i18n.sys.version" /></b>',
					width : 120,
					align : 'left'
				},
				{
					field : 'publishTime',
					halign : 'center',
					title : '<b><spring:message code="i18n.plugin.repository.plugin.publish.time" /></b>',
					width : 120,
					align : 'left'
				},
				{
					field : 'operation',
					halign : 'center',
					align : 'center',
					title : '<b><spring:message code="i18n.sys.operation" /></b>',
					width : 100,
					formatter : function(value, row, index) {
						var btn = '<a title="点击安装'+row.version+' 版本！！！" style="cursor:pointer;color:#00f"  onclick="installPlugin(\'' + row.id + '\',\''+row.artifactId+'\',\''+row.version+'\' )" ><spring:message code="i18n.plugin.repository.plugin.install" /></a>';
						if (row.installedVersion) {
							 if(row.localNoJar){
								 btn = '<a title="本地未安装，点击安装'+row.version+' 版本！！！" style="cursor:pointer;color:#f00"  onclick="installPlugin(\'' + row.id + '\',\''+row.artifactId+'\',\''+row.version+'\' )" ><spring:message code="i18n.plugin.repository.plugin.install" /></a>';
							 }else if (row.installedVersion == row.version ) {
								btn = '<div style="color:#228B22" title="已经安装此版本组件" ><spring:message code="i18n.plugin.repository.plugin.installed" />';
								if(row.sameVersionUpdate){
									btn += '('+ '<a title="点击安装此版本（没有修改版本号的新版本）！！！" style="cursor:pointer;color:#00f"  onclick="updatePlugin(\'' + row.id +  '\',\''+row.artifactId+'\',\''+row.version+'\')" ><spring:message code="i18n.plugin.repository.plugin.update" /></a>)';
								}
								btn += '</div>';
							} else if(row.oldVersion){
								btn = '<a title="点击安装'+row.version+' 版本，替换已安装的'+row.installedVersion+' 版本！！！" style="cursor:pointer"  onclick="updatePlugin(\'' + row.id + '\',\''+row.artifactId+'\',\''+row.version+'\' )" ><spring:message code="i18n.plugin.repository.plugin.installold" /></a>';
							}else{
								btn = '<a title="点击安装'+row.version+' 版本，替换已安装'+row.installedVersion+' 版本！！！" style="cursor:pointer;color:#00f"  onclick="updatePlugin(\'' + row.id +  '\',\''+row.artifactId+'\',\''+row.version+'\')" ><spring:message code="i18n.plugin.repository.plugin.update" /></a>';
							}
						}
						return btn;
					}
				} ] ],
				 onSelect:function(index,row){  
					 $('#pluginsList').treegrid('clearSelections'); 
				 }
		});
	</script>
</body>
</html>