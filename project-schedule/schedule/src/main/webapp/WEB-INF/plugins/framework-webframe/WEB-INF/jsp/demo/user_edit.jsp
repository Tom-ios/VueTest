<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>编辑</title>

	<!-- <link rel="stylesheet" type="text/css" href="./css/easyui/bootstrap.min.css">
    <link rel="stylesheet" href="./assets/awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="./assets/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="./css/AdminLTE.css">
    <link rel="stylesheet" href="./css/skins/_all-skins.css">
    
	<link rel="stylesheet" type="text/css" href="./css/easyui/easyui.css">
  	<link rel="stylesheet" type="text/css" href="./css/easyui/insdep/easyui_plus.css">
	<link rel="stylesheet" type="text/css" href="./css/easyui/icons/icon.css">
	<link rel="stylesheet" type="text/css" href="./css/easyui/easyui_full.css">
	<script type="text/javascript" src="./js/easyui/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="./js/jquery.json-2.2.js"></script>
	<script type="text/javascript" src="./js/easyui/bootstrap.min.js"></script>
	<script type="text/javascript" src="./js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="./js/fweb.util.js"></script>
	<script type="text/javascript" src="./js/easyui/insdep/jquery.insdep-extend.min.js"></script> -->

	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/validate_extend.js"></script>
	
</head>
<body class="hold-transition skin-green-light pace-done">
	<div class="col-md-10">
			<form id="ff" class="form-horizontal container-fluid">
			<div class="row">
			  	<div class="form-group">
				    <label for="userName" class="col-sm-2 control-label">用户名</label>
				    <div class="col-sm-10">
				      	<input name="userName" type="text" class="form-control" id="userName" placeholder="请输入用户名">
				    </div>
			  	</div>
			  	<div class="form-group">
				    <label for="age" class="col-sm-2 control-label">年龄</label>
				    <div class="col-sm-10">
				      	<input name="age" type="text" class="form-control" id="age" placeholder="请输入年龄">
				    </div>
			  	</div>
			  	<div class="form-group">
			    	<label for="mobile" class="col-sm-2 control-label">手机号</label>
				    <div class="col-sm-10">
				    	<input type="text" class="form-control" id="mobile" name="mobile" placeholder="请输入手机号">
				    </div>
			  	</div>
			  	<div class="form-group">
			    	<label for="onlineTime" class="col-sm-2 control-label">在线时间</label>
				    <div class="col-sm-10">
				    	<input style="width:100%;" type="text" class="form-control" id="onlineTime" name="onlineTime">
				    </div>
			  	</div>
			  	<div class="form-group">
			    	<label for="userType" class="col-sm-2 control-label">用户类型</label>
				    <div class="col-sm-10">
				    	<select class="form-control" name="userType" id="userType">
						  <option value=""></option>
						  <option value="0">普通用户</option>
						  <option value="1">普通会员</option>
						  <option value="2">高级会员</option>
						</select>
				    </div>
			  	</div>
				<div class="form-group">
				    <label for="mobile" class="col-sm-2 control-label">性别</label>
				    <div class="col-sm-10">
						<label class="radio-inline">
						<input type="radio" value="男" name="sex" checked="checked">
							男
						</label>
						
						<label class="radio-inline">
							<input type="radio" value="女" name="sex">
							女
						</label>
				    </div>
				</div>
			  	<div class="form-group">
			    	<div class="col-sm-offset-2 col-sm-10">
			      		<a onclick="submitForm()" class="btn btn-primary">保存</a>
			      		<a onclick="clearForm()" class="btn btn-default">清空</a>
			      		<a onclick="cancelEdit()" class="btn btn-default">取消</a>
			    	</div>
			  	</div>
			  	</div>
			</form>
	</div>
<!-- <form id="ff_user_list" class="form-inline container-fluid search-form">
	<div id="searchDiv" class="row">
	  	<div class="form-group col-md-4 col-xs-4 col-sm-4" style="padding-right: 0px;overflow: hidden;white-space: nowrap;margin-bottom: 0;">
		  	<div style="margin-bottom: 5px; display: flex;">
		  		<div style="padding-right: 8px; width: auto;line-height: 26px;">
			    	<label for="userName" class="control-label" style="padding-left: 0 !important;">用户名</label>
		  		</div>
		  		<div style="width: 100%;">
			    	<input style="width: inherit;height: 26px;" name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
		  		</div>
		  	</div>
		  	<span>fdsdf</span>
		</div>
	</div>
</form> -->
<script>
		/* function loadLocal(){
			$('#ff').form('load',{
				userName:'小明',
				mobile:'13566669999',
				sex:'女',
				userType:'1'
			});
		} */
		function loadRemote(id_){
			$.ajax({
				url : '${Config.basePath}userinfo/'+id_,
				type : 'get',
				contentType : 'application/json;charset=UTF-8',
				success : function(data) {
					$('#ff').form('load', {
						userName:data.userName||'',
						age:data.age||'',
						mobile:data.mobile||'',
						sex:data.sex||'',
						userType:data.userType||'',
						onlineTime:data.onlineTime||''
					});
				},
				error : function(xhr) {
					$.gritter.add({  
					    text: '获取用户信息失败',  
					    sticky: false,  
					    time: 3000,
					    speed:500,  
					    class_name: 'gritter-error'  
					});
				}
			});
		}
		function clearForm(){
			$('#ff').form('clear');
		}
		
		function submitForm(){
			$('#ff').form('submit',{
				onSubmit:function(){
					var isValidatePass = $(this).form('enableValidation').form('validate');
					if(isValidatePass){
						
						var data = $("#ff").serializeObject();
						
						var requestType = "post";
						
						if("${param.id}"){
							data.id = "${param.id}";
							requestType = "put";
						}
						
						$.ajax({
							url : '${Config.basePath}userinfo',
							type : requestType,
							async : false,
							data : $.toJSON(data),
							contentType : 'application/json;charset=UTF-8',
							success : function(data) {
								//
								$.gritter.add({  
								    text: '保存成功',  
								    sticky: false,  
								    time: 3000,
								    speed:500,  
								    class_name: 'gritter-success'  
								});
								if("${param.id}"){
									crumbs.goback({isRefresh:true});
								}else{
									crumbs.goback({isRefresh:true,isHomePage: true});
								}
							},
							error : function(xhr) {
								$.gritter.add({  
								    text: '保存失败',  
								    sticky: false,  
								    time: 3000,
								    speed:500,  
								    class_name: 'gritter-error'  
								});
							}
						});
					}
					return false;
				}
			});
		}
		
		$(function(){
			$('#onlineTime').datetimebox({    
			    required: true,    
			    showSeconds: true   
			});
			if("${param.id}"){
				loadRemote("${param.id}");
			}
			
			$('#userName').validatebox({
			    required: true,
			    validType: 'minLength[3]',
			    tipPosition: 'right',
			    missingMessage: '用户名不能为空'
			    //invalidMessage: '用户名不能超过30个字'
			});
			$('#mobile').validatebox({
			    required: true,
			    validType: 'mobile',
			    tipPosition: 'right',
			    missingMessage: '手机号不能为空'
			});
			$('#userType').validatebox({
			    required: true,
			    validType: 'selectValid[""]',
			    tipPosition: 'right',
			    missingMessage: '用户类型不能为空'
			});
			$('#age').validatebox({
			    required: true,
			    validType: 'ddPrice[1,150]',
			    tipPosition: 'right',
			    missingMessage: '年龄不能为空'
			});
		})
		
		function cancelEdit(){
			crumbs.goback();
		}
</script>

</body>
</html>