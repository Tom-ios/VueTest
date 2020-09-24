<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	// 项目上下文路径
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<base href="<%=contextPath %>" />
	<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo.ico" type="image/x-icon" />
	<title><spring:message code="i18n.cache.info.title" /></title>
	<link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/css/bootstrap.min.css">
    <link href="${config.base() }fweb-framework-ui/assets/fonts/css/font-awesome.min.css" rel="stylesheet">
  	<link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/easyui/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/css/fweb.css">
    <link rel="stylesheet" type="text/css" href="${config.base()}fweb-cache/js/jsonview/jquery.jsonview.css">

	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/jquery.min.js"></script>
	<script src="${config.base()}fweb-framework-ui/js/bootstrap/bootstrap.min.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/jquery.json-2.2.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/easyui/insdep/jquery.insdep-extend.min.js"></script>

	<script type="text/javascript" src="${config.base()}fweb-cache/js/jsonview/jquery.jsonview.js"></script>
	<style type="text/css">
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
		.datagrid .panel-body{
			border-width: 0px;
		}
		.panel-title{
			font-size : 14px;
		}
	</style>

</head>
<body class="easyui-layout" style="margin: 8px !important;">
<div data-options="region:'west'" style="width:22%; padding: 0px !important; border-width: 0px 1px 0px 0px;">
	<div class="easyui-tabs" style="width:95%;height:100%">
		<div title="现有缓存" data-options="iconCls:'icon-ok'">
			<ul id="usedTree" class="easyui-tree"
						data-options="url:'fweb-cache/cache/tree?type=used',method:'get',animate:true"
						style="width:220px;"></ul>
		</div>
		<div title="未使用缓存" data-options="iconCls:'icon-help',closable:true">
			<ul id="unUsedTree" class="easyui-tree"
						data-options="url:'fweb-cache/cache/tree?type=unused',method:'get',animate:true"
						style="width:220px;"></ul>
		</div>
	</div>
</div>

<div data-options="region:'center',title:'缓存信息'" style="width: 78%;">
	<div id="usedCacheDiv" style="width:100%;height:100%">
		<table id="usedCacheTable" title="类型" class="easyui-datagrid" fit="true" style="width: auto;"
				data-options="
					collapsible:true,
					fitColumns:true,
					toolbar:'#cacheToolbar',
					method:'get'
				">
			<thead>
				<tr>
					<th data-options="field:'ck',checkbox : true" width="5%"></th>
					<th data-options="field:'domain'" width="20%"><b>域</b></th>
					<th data-options="field:'key'" width="25%"><b>键</b></th>
					<th data-options="field:'value'" width="30%" ><b>值(双击查看详细内容)</b></th>
					<th data-options="field:'size'" width="10%" align="right"><b>大小</b></th>
					<th data-options="field:'operate',
														formatter: function(value,row){
															return '<a href=javascript:void(0) onclick=deleteKey(\''+row.key+'\',\''+row.cacheName+'\')>删除</a>';}"
															 width="10%"><b>操作</b></th>
				</tr>
			</thead>
		</table>
	</div>
	<div id="unUsedCacheDiv" style="width:100%;height:100%;">
		<table id="unUsedCacheTable" class="easyui-datagrid" fit="true" style="width: auto;"
				data-options="
					singleSelect:true,
					collapsible:true,
					fitColumns:true,
					method:'get'
				">
			<thead>
				<tr>
					<th data-options="field:'key'" width="30%">属性</th>
					<th data-options="field:'value'" width="70%" >值</th>
				</tr>
			</thead>
		</table>
	 <!-- <div id="cacheToolbar" style="padding-bottom: 8px !important;">
        	<b>键: </b><input id="key" name="key"  class="easyui-textbox" style="width:220px">
        <a href=" javascript:void(0)" onclick="queryCache()" class="easyui-linkbutton" iconCls="icon-search">查询</a>
    </div> -->
    <div id="cacheToolbar">
		<form id="ff_user_list" class="form-inline container-fluid search-form">

		  	<div id="searchDiv" class="row form-group">

			  	<div class="form-input col-md-6 col-sm-6 col-xs-6">
			  		<div class="form-input-label">
				    	<label for="" class="control-label">键：</label>
			  		</div>
			  		<div class="form-input-input">
				    	<input name="key" type="text" class="form-control" id="key" placeholder="请输入键值">
			  		</div>
			  	</div>
			  	<div class="col-md-6 col-xs-6 col-sm-6 search-button">
			  		<a onclick="queryCache()" class="btn btn-primary">查&nbsp;询</a>
			  		<a onclick="deleteCaches()" class="btn btn-warning">删除缓存对象</a>
			  	</div>

		  	</div>

		</form>

		<div class="toolbar-table-btn">
		</div>

	</div>
	</div>
</div>
<div id="cacheContentDialog" style="padding:8px;display:none"><div id="jsonContent"></div></div>
<script type="text/javascript">
var currentCacheName ;
$(document).ready(function(){
	$("#unUsedCacheDiv").hide();
	$('#usedTree').tree({
		onClick: function(node){
			if(undefined === node.msg){
				return ;
			}
			$("#unUsedCacheDiv").hide();
			$("#usedCacheDiv").show();
			currentCacheName = node.text;
			loadUsedCache(node.id, node.text, node.type , node.msg);
		}
	});
	$('#unUsedTree').tree({
		onClick: function(node){
			$("#usedCacheDiv").hide();
			$("#unUsedCacheDiv").show();
			loadUnUsedCache(node.id, node.text, node.type , node.msg);
		}
	});

});
function queryCache(){
	var selectedNode = $('#usedTree').tree('getSelected');
	loadUsedCache(selectedNode.id, selectedNode.text, selectedNode.type , selectedNode.msg);
}
function loadUsedCache(id, text , type , msg){

	var keyVal = $("#key").val();
	var paramObj = {
			id : id,
			listUrl : "fweb-cache/cache/list?cacheName="+text,
			queryParameters:{
				key:keyVal
			}
		}
	$("#usedCacheTable").datagrid({
		url : paramObj.listUrl,
		method: 'get',
		striped:true,
		remoteSort:true,
		//序号
		rownumbers:true,
		fitColumns : true,
		loadMsg : "正在加载数据",
		queryParams: paramObj.queryParameters,
		onClickRow: loadCacheContent,
		onDblClickCell: showCacheContent
	});
	if(type === 'REDIS'){
		$("#usedCacheTable").datagrid("getPanel").panel("setTitle",msg)
	}else{
		$("#usedCacheTable").datagrid("getPanel").panel("setTitle",'缓存类型 : '+type)
	}
}
function loadUnUsedCache(id, text , type , msg){
	$("#unUsedCacheTable").datagrid({
		url : 'fweb-cache/cache/cacheConfig?cacheName='+text,
		method: 'get',
		striped:true,
		remoteSort:true,
		//默认单选
		singleSelect:true,
		//序号
		rownumbers:true,
		fitColumns : true,
		loadMsg : "正在加载数据"
	});
}
//显示缓存内容
function showCacheContent(index, filed ,value){
	setContent(value)
	$("#cacheContentDialog").dialog({
		title : '缓存内容',
		width: 800,
		height: 600,
		cache: false,
		closed: false,
		modal: true
	});
}
function setContent(jsonContent){
	$('#jsonContent').JSONView(jsonContent);
}
//加载缓存内容
function loadCacheContent(index ,row){
	$.ajax({
		url :  "fweb-cache/cache/get?cacheName="+row.cacheName+"&key="+row.key,
		type : 'get',
		cache : false,
		contentType : 'application/json;charset=UTF-8',
		success : function(data) {
			row.value=JSON.stringify(data);
			row.size=row.value.length;
			$("#usedCacheTable").datagrid('refreshRow', index);
		}
	});

}
/**
 * 删除缓存中的一个键值
 */
function deleteKey(key , cacheName){

	$.messager.confirm('请确认', '确定要删除缓存 '+key+' 吗?', function(r){
		if(r){
			$.ajax({
				url :  "fweb-cache/cache/delete?cacheName="+cacheName+"&key="+key,
				type : 'delete',
				success : function(data) {
					$("#usedCacheTable").datagrid('reload', {});
				}
			});
		}
	})
}
/**
 * 删除选中的多个缓存对象
 */
function deleteCaches(){
	var rows = $("#usedCacheTable").datagrid("getSelections");
	var ids = new Array();
	for(i =0; i <rows.length ; i++){
		ids.push( rows[i].key);
	}
	if(ids.length == 0){
		return ;
	}
	$.messager.confirm('请确认', '确定要删除缓存选中的缓存对象吗?', function(r){
		
		if(r){
			$.ajax({
				url :  'fweb-cache/cache/deleteMulti',
				type : 'post',
				data : {'cacheName':currentCacheName,'ids': ids},
				dataType: 'json',
				success : function(data) {
					$("#usedCacheTable").datagrid('reload', {});
				}
			});
		}
	})
	
}
</script>
</body>
</html>