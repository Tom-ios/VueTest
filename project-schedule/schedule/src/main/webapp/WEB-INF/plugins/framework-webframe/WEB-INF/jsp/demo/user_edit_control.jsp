<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/validate_extend.js"></script>
	
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/expand/fweb_form_control.js"></script>
	
	<style type="text/css">
		body label {
			font-weight: lighter;
		    background-color: #fff !important;
		    border: none !important;
		}
	</style>
	
<div class="hold-transition skin-green-light pace-done">
	<div class="col-md-10">
			<form id="ff" class="form-horizontal container-fluid">
			<div class="row">
			  	<div class="form-group">
				    <!-- <input id="userName" name="userName" class="textbox-radius easyui-fwebformcontrol" data-options="
				    		label: '用户名:',
			 				required: true,
			 				validType: 'minLength[3]',
			 				missingMessage: '用户名不能为空',
			 				prompt: '请输入用户名'	
				    	"> -->
				    <input id="userName" name="userName" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <!-- <label for="age" class="col-sm-2 control-label">年龄</label>
				    <div class="col-sm-10">
				      	<input name="age" type="text" class="form-control" id="age" placeholder="请输入年龄">
				    </div> -->
				    <input id="age" name="age" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
			    	<!-- <label for="mobile" class="col-sm-2 control-label">手机号</label>
				    <div class="col-sm-10">
				    	<input type="text" class="form-control" id="mobile" name="mobile" placeholder="请输入手机号">
				    </div> -->
				    <input id="mobile" name="mobile" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
			    	<!-- <label for="onlineTime" class="col-sm-2 control-label">在线时间</label>
				    <div class="col-sm-10">
				    	<input style="width:100%;" type="text" class="form-control" id="onlineTime" name="onlineTime">
				    </div> -->
				    <input id="onlineTime" name="onlineTime" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
			    	<!-- <label for="userType" class="col-sm-2 control-label">用户类型</label>
				    <div class="col-sm-10">
				    	<select class="form-control" name="userType" id="userType">
						  <option value=""></option>
						  <option value="0">普通用户</option>
						  <option value="1">普通会员</option>
						  <option value="2">高级会员</option>
						</select>
				    </div> -->
				    <input id="userType" name="userType" class="textbox-radius">
			  	</div>
				<div class="form-group">
					<!-- <label class="textbox-label textbox-label-beffore" for="mobile"
						style="text-align: right; width: 200px; height: 32px; line-height: 32px;"
						>
						性别:
					</label>
				    <span>
						<label class="radio-inline">
						<input type="radio" value="男" name="sex" checked="checked">
							男
						</label>
						
						<label class="radio-inline">
							<input type="radio" value="女" name="sex">
							女
						</label>
				    </span> -->
				    <input id=sex name="sex">
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
<script>
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
					
					if(data.sex)
						$('#sex').fwebformcontrol('setValueTest',data.sex);
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
								crumbs.goback({isRefresh:true});
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
			$('#onlineTime').fwebformcontrol({
				label: '在线时间:',
				labelWidth: 200,
			    required: true,    
			    showSeconds: true,
			    prompt: '请输入在线时间',
			    controlType: 'datetimebox'
			});
			
			$('#userName').fwebformcontrol({
				label: '用户名:',
				labelWidth: 200,
 				required: true,
 				validType: 'minLength[3]',
 				missingMessage: '用户名不能为空',
 				prompt: '请输入用户名'
			});
			$('#mobile').fwebformcontrol({
				label: '手机号:',
				labelWidth: 200,
			    required: true,
			    validType: 'mobile',
			    tipPosition: 'right',
			    missingMessage: '手机号不能为空'
			});
			$('#userType').fwebformcontrol({
				label: '用户类型:',
				labelWidth: 200,
			    valueField: 'value',
			    textField: 'label',
			    required: true,
			    validType: 'selectValid[""]',
			    tipPosition: 'right',
			    missingMessage: '用户类型不能为空',
			    prompt: '请输入用户类型',
			    controlType: 'combobox',
			    data: [{
				      label: '普通用户',
				      value: '0'
				    },{
				      label: '普通会员',
				      value: '1'
				    },{
				      label: '高级会员',
				      value: '2'
				    }]
			});
			$('#age').fwebformcontrol({
				label: '年龄:',
				labelWidth: 200,
			    required: true,
			    validType: 'ddPrice[1,150]',
			    tipPosition: 'right',
			    missingMessage: '年龄不能为空',
			    prompt: '请输入年龄'
			});
			$('#sex').fwebformcontrol({
				label: '性别:',
				labelWidth: 200,
			    //required: true,
			    //validType: 'ddPrice[1,150]',
			    //tipPosition: 'right',
			    data: [{
			    	label: '男',
			    	value: '男',
			    	checked: true
			    },{
			    	label: '女',
			    	value: '女',
			    	checked: false
			    }],
			    controlType: 'radiobox'
			});
			
			
			if("${param.id}"){
				loadRemote("${param.id}");
			}
		})
		
		function cancelEdit(){
			crumbs.goback();
		}
</script>

</div>
