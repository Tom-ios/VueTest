<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
	// 项目上下文路径
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en" ng-app="clientApp" ng-csp>
<head>
<base href="<%=contextPath%>" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>编码转换配置</title>
<link rel="shortcut icon"
	href="${config.ui() }fweb-framework-ui/style/icons/fweblogo.ico"
	type="image/x-icon" />
<link rel="stylesheet" type="text/css"
	href="${config.ui()}fweb-framework-ui/style/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="${config.ui()}fweb-framework-ui/style/easyui/bootstrap/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${config.ui()}fweb-framework-ui/style/css/fweb.css">
<link rel="stylesheet" type="text/css"
	href="${config.ui()}fweb-codeconvert/heightLight/shCoreDefault.css">
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
<script type="text/javascript"
	src="${config.ui()}fweb-codeconvert/heightLight/shCore.js"></script>
<script type="text/javascript"
	src="${config.ui()}fweb-codeconvert/heightLight/shBrushJava.js"></script>
<style type="text/css">
body {
	font-family: verdana, helvetica, arial, sans-serif;
	font-size: 12px;
	margin: 0;
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
	filter: alpha(opacity = 60);
	margin: 0;
	vertical-align: top;
}

.layout-button-right {
	background-position: 0 -16px;
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
					<div class="form-input col-md-8 col-sm-8 col-xs-8">
						<div class="form-input-label">
							<label for="" class="control-label">编码转换来源：</label>
						</div>
						<div class="form-input-input">
							<input name="codeSource" type="text" class="form-control"
								onKeyPress="checkey(event.keyCode||event.which)" id="codeSource"
								placeholder="请输入功能编码">
						</div>
					</div>
					<div class="col-md-4 col-xs-4 col-sm-4 search-button">
						<a onclick="loadGrid()" class="btn btn-primary">查&nbsp;询</a>&nbsp;&nbsp;&nbsp;
						<a onclick="newScript()" class="btn btn-primary">添加脚本</a>
					</div>
				</div>
			</div>

			<div class="toolbar-table-btn"></div>

		</div>
		<table id="converdg" class="easyui-datagrid" fit="true"
			style="width: auto;"></table>

	</div>
	<div id="scriptContentDialog" style="padding: 8px; display: none">
		<pre id="code_Block" class="brush: java;toolbar:false;"></pre>
	</div>
	<div id="scriptEditContentDialog" style="padding: 8px; display: none">
		<table>
			<tr><td style="text-align:right;width:160px;height:28px"><b>脚本文件名：</b></td>
					<td><input style="width:450px" type="text" id="fileName" name="fileName"/></td></tr>
			<tr><td style="text-align:right;width:160px;height:28px"><b>功能类型：</b></td>
					<td><input style="width:450px" type="text" id="type" name="type"/></td></tr>
			<tr><td style="text-align:right;width:160px;height:28px"><b>脚本文件说明：</b></td>
					<td><input style="width:450px" type="text" id="fileDesc" name="fileDesc"/></td></tr>
			<tr><td style="text-align:left;height:28px" colspan=2><b>&nbsp;&nbsp;脚本内容：</b></td></tr>
			<tr><td colspan=2><textarea  id="fileContent" rows="22" cols="107"></textarea></td></tr>
		</table>
		<center><a onclick="saveScript()" class="btn btn-primary">保存</a></center>
	</div>
	<script type="text/javascript">
	var path = '${config.path()}';
	var scriptSaveURL = {"new":path+"codeconfig/newScript" , "update":path+"codeconfig/saveScript"};
	var action ="new";
	$(document).ready(function() {
		loadGrid();
	});
	function checkey(e) {
		if (e == 13) {
			loadGrid();
		}
	}
	function loadGrid() {
		var code = $("#codeSource").val();
		$("#converdg")
				.datagrid(
						{
							method : 'get',
							url : path+'codeconfig/configs?code='+code,
							pagination : true,
							fit : true,
							fitColumns : true,
							striped : true,
							scrollbarSize : 0,
							singleSelect : true,
							toolbar : '#tb',
							columns : [ [
									{
										field : "fileName",
										title : "<b>脚本文件名</b>",
										width : '20%',
										formatter: function (value, row , index){
											var str = '';
											str += '<a href="javascript:void(0)" title="点击查看脚本内容" onclick="oepnConfig('
													+index+ ')">'+value+'</a>';
											return str;
										}

									},
									{
										field : "type",
										title : "<b>功能编码</b>",
										width : '20%'
									},
									{
										field : "fileDesc",
										title : "<b>脚本文件说明</b>",
										width : '25%'
									},
									{
										field : "createtime",
										width : '12%',
										title : "<b>创建时间</b>"
									},
									{
										field : "updatetime",
										width : '12%',
										title : "<b>更新时间</b>"
									},
									{
										field : "opt",
										title : "<b>操作</b>",
										width : '10%',
										formatter : function(value, row,
												index) {
											var str = '';
													str += '<a href="javascript:void(0)" title="点击编辑配置" onclick="editConfig('
														+index+ ')">编辑</a>';
											return str;
										}
									} ] ],
						});
	}
	function oepnConfig(index) {

		setContent(index)
		$("#scriptContentDialog").dialog({
			title : '脚本内容',
			width : 800,
			height : 600,
			cache : false,
			closed : false,
			modal : true
		});
	}
	function setContent(index) {
		var rows = $("#converdg").datagrid("getRows");
		if(rows.length > 0){
			var row = rows[index];
			SyntaxHighlighter.all();
			$("#code_Block").html(row['fileContent']);
		}
	}
	function editConfig(index) {
		action = "update";
		setTextContent(index)
		$("#scriptEditContentDialog").dialog({
			title : '脚本内容',
			width : 800,
			height : 600,
			cache : false,
			closed : false,
			modal : true
		});
	}
	var currentId ;
	function setTextContent(index) {
		var rows = $("#converdg").datagrid("getRows");
		if(rows.length > 0){
			var row = rows[index];
			currentId = row['id'];
			$("#fileContent").val(row['fileContent']);
			$("#fileName").val(row['fileName']);
			$("#type").val(row['type']);
			$("#fileDesc").val(row['fileDesc']);
		}
	}
	function saveScript(){
		var content = $("#fileContent").val();
		var fileName = $("#fileName").val();
		var type = $("#type").val();
		var fileDesc = $("#fileDesc").val();

		var param =  {'id': currentId, 'fileName':fileName,'type':type, 'fileDesc':fileDesc,'fileContent': content};
		$.ajax({
			url : scriptSaveURL[action],
			type : 'post',
			data :  $.toJSON(param),
			contentType: 'application/json;charset=UTF-8',
			success : function(data) {
				if(data.state == 'success'){
					$.messager.alert({
						title:'保存成功',
						msg:'脚本保存成功！'
					});
					 loadGrid() ;
					 $("#scriptEditContentDialog").dialog("close");
				}else{
					$.messager.alert({
						title:'保存失败',
						msg:'脚本修改失败！原因：【'+data.msg+'】'
					});
				}

			},
			error: function(data){console.log(data)
				$.messager.alert({
					title:'保存失败',
					msg:'脚本修改失败！原因：【'+data.status+'】'
				});
			}
		});
	}
	function newScript(){
		action = "new";
		setNullForm();
		$("#scriptEditContentDialog").dialog({
			title : '脚本内容',
			width : 800,
			height : 600,
			cache : false,
			closed : false,
			modal : true
		});
	}
	function setNullForm() {
		$("#fileContent").val('');
		$("#fileName").val('');
		$("#type").val('');
		$("#fileDesc").val('');
	}
</script>
</body>