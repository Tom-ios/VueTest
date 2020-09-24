<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<link rel="shortcut icon" href="${config.ui() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />

	<script type="text/javascript" src="${config.path()}assets/js/easyui/validate_extend.js"></script>
	
	<script type="text/javascript" src="${config.path()}assets/js/easyui/expand/fweb_form_control.js"></script>
	
	<style type="text/css">
		body label {
			font-weight: lighter;
		    background-color: #fff !important;
		    border: none !important;
		}
		#ff .row .form-group{
			display: flex;
		}
	</style>
	
<div class="hold-transition skin-green-light pace-done">
	<div class="col-md-10">
			<form id="ff" class="form-horizontal container-fluid">
			<div class="row">
			  	<div class="form-group">
				    <input id="name" name="name" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="typeKey" name="typeKey" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="serialNumber" name="serialNumber" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="validDate" name="validDate" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="maintOrg" name="maintOrg" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="maintType" name="maintType" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="typeVersion" name="typeVersion" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="validFlag" name="validFlag" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="description" name="description" class="textbox-radius">
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
	
	var basePath = '${config.path()}';
	var copy = '${param.copy}';

	function loadRemote(id_){
		$.ajax({
			url : basePath+'commons/sort/type?id='+id_,
			type : 'get',
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$('#ff').form('load', {
					name : data.name||'',
					typeKey : data.typeKey||'',
					serialNumber : data.serialNumber,
					validDate : data.validDate||'',
					maintOrg : data.maintOrg||'',
					maintType : data.maintType||'',
					typeVersion : data.typeVersion||'',
					description : data.description||''
				});
				
				if(data.validFlag)
					$('#validFlag').fwebformcontrol('setValueTest',data.validFlag);
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
					
					if("${param.id}" && copy != 'true'){
						data.id = "${param.id}";
						requestType = "put";
					}
					
					$.ajax({
						url : basePath+'commons/sort/type',
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
		$('#name').fwebformcontrol({
			label: '分类类别名称:',
			labelWidth: 200,
		    required: true,    
				missingMessage: '分类类别名称不能为空',
		    prompt: '请输入分类类别名称',
		});
		$('#typeKey').fwebformcontrol({
			label: '分类类别键值:',
			labelWidth: 200,
				required: true,
				missingMessage: '分类类别键值不能为空',
				prompt: '请输入分类类别键值'
		});
		$('#serialNumber').fwebformcontrol({
			label: '序号:',
			labelWidth: 200,
		    required: true,
		    missingMessage: '序号不能为空',
				prompt: '请输入序号'
		});
		$('#validDate').fwebformcontrol({
			label: '分类类别生效时间:',
			labelWidth: 200,
		    required: true,    
		    showSeconds: true,
		    prompt: '请输入分类类别生效时间',
		    controlType: 'datetimebox'
		});
		$('#maintOrg').fwebformcontrol({
			label: '维护单位:',
			labelWidth: 200,
		    required: false,
		    missingMessage: '维护单位不能为空',
				prompt: '请输入维护单位'
		});
		$('#maintType').fwebformcontrol({
			label: '维护类型:',
			labelWidth: 200,
		    valueField: 'value',
		    textField: 'label',
		    required: true,
		    validType: 'selectValid[""]',
		    missingMessage: '维护类型不能为空',
		    prompt: '请输入维护类型',
		    controlType: 'combobox',
		    data: [{
			      label: '不可维护',
			      value: '01'
			    },{
			      label: '可增加',
			      value: '02'
			    },{
			      label: '可增删改',
			      value: '03'
			    }]
		});
		$('#typeVersion').fwebformcontrol({
			label: '版本:',
			labelWidth: 200,
		    required: true,
		    missingMessage: '版本不能为空',
				prompt: '请输入版本'
		});
		$('#validFlag').fwebformcontrol({
			label: '有效标识:',
			labelWidth: 200,
		    data: [{
		    	label: '有效',
		    	value: '1',
		    	checked: true
		    },{
		    	label: '失效',
		    	value: '0',
		    	checked: false
		    }],
		    controlType: 'radiobox'
		});
		$('#description').fwebformcontrol({
			label: '版本:',
			labelWidth: 200,
			height: 128,
		    required: false,
		    multiline: true,
		    missingMessage: '版本不能为空',
				prompt: '请输入版本'
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
