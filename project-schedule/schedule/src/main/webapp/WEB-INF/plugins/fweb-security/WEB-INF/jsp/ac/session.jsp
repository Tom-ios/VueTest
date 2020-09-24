<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>会话管理</title>
<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo.ico" type="image/x-icon" />
   	
   	<link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/css/bootstrap.min.css">
    
  	<link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/easyui/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/css/fweb.css">
	
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/jquery.min.js"></script>
	<script src="${config.base()}fweb-framework-ui/js/bootstrap/bootstrap.min.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/jquery.json-2.2.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/easyui/insdep/jquery.insdep-extend.min.js"></script>
	
   	
	<script type="text/javascript" src="${config.path() }style/js/alerts.js"></script>
</head>
<body class=" easyui-layout">
	
	<div class="content-layout-center" data-options="region:'center',border:false" id="center_content">
	<div id="tb">
			<form id="ff_user_list" class="form-inline container-fluid search-form">
			
			  	<div id="searchDiv" class="row form-group">
				  
				  	<div class="form-input col-md-8 col-sm-8 col-xs-8">
				  		<div class="form-input-label">
					    	<label for="" class="control-label">用户名：</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName" type="text" class="form-control" id="userName" placeholder="请输入用户名">
				  		</div>
				  	</div>
				  	<div class="col-md-3 col-xs-3 col-sm-4 search-button">
				  		<a onclick="queryOnlineUser()" class="btn btn-primary">查&nbsp;询</a>
				  	</div>
				  	
			  	</div>
			  	
			</form>
			
			<div class="toolbar-table-btn">
			</div>
			
		</div>	
	<table id="online_dg" class="easyui-datagrid" fit="true" style="width: auto;">
	</table>
	</div>
	
	
	<script>
	$(function(){
		$("#online_dg").datagrid({
			pagination : true,
			method : 'get',
			url :'${config.base()}fweb-security/sessions/list',
			fit: true,
			fitColumns:true,
			scrollbarSize:0,
			singleSelect : true,
			toolbar: '#tb',
			param : {
				pageSize:100,
				pageIndex:2
			},
			emptyMsg : '<span>暂无相关数据</span>',
			columns : [[
			    {
					field : "userName",
					title : "用户名",
					width : '24.9%',
					
				},{
					field : "loginIp",
					width : '30%',
					title : "登陆IP"
				},{
					
					field : "sessionId",
					title : "会话ID",
					hidden:'true'
				},{
					field : "lastAccessTime",
					width : '30%',
					title : "最后操作时间"
				},{
					field : "opt",
					title : "操作",
					width : '15%',
					formatter : function(value,row,index){
						var str='';
						str +='&nbsp;&nbsp;<a href="#" onclick="deleteOnlineUser(\''+row.userName+'\')">踢出</a>';
						return str;
					}
				}
			]],
			
			
	        onClickRow: function(index, data) {
	        },
		});
	})
	function queryOnlineUser(){
		$('#online_dg').datagrid('load',{
			userName: $('#userName').val(),
			loginIp: $('#loginIp').val()
		});
	}
	
	function deleteOnlineUser(userCode){
		 $.ajax({
			 url:"${config.base()}fweb-security/sessions/forceLogout",
			 method:"post",
			 data:JSON.stringify({"userCode":userCode}),
			 dataType:'json',
			 contentType: 'application/json',
			 success:function(data){
				 $('#online_dg').datagrid('reload');
			 },
			 error:function(){
				alert("错误");
		    		}
	               
		 })  
	}

	</script>
</body>
</html>