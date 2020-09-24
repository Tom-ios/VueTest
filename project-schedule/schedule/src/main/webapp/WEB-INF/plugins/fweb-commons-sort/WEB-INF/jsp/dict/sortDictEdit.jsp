<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<script type="text/javascript" src="${config.path()}assets/js/easyui/validate_extend.js"></script>
	
	<script type="text/javascript" src="${config.path()}assets/js/easyui/expand/fweb_form_control.js"></script>
	
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
				    <input type="hidden" id="id" name="id" value="${param.id }">
				    <input type="hidden" id="parentId" name="parentId">
				    <input type="hidden" id="itemId" name="itemId" value='${param.itemId }'>
				    <input id="name" name="name" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="serialNumber" name="serialNumber" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="dictCode" name="dictCode" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="content1" name="content1" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="content2" name="content2" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="content3" name="content3" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="content4" name="content4" class="textbox-radius">
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
			url : basePath+'commons/sort/dict?id='+id_,
			type : 'get',
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$('#ff').form('load', {
					name : data.name||'',
					serialNumber : data.serialNumber,
					dictCode : data.dictCode||'',
					itemId : data.itemId||'',
					parentId : data.parentId||'',
					content1 : data.content1||'',
					content2 : data.content2||'',
					content3 : data.content3||'',
					content4 : data.content4||'',
					description : data.description||''
				});
				
			},
			error : function(xhr) {
				$.gritter.add({  
				    text: '获取数据字典项失败',  
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
						requestType = "put";
					}else{
						data.id = '';
					}
					
					$.ajax({
						url : basePath+'commons/sort/dict',
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
			label: '数据字典项名称:',
			labelWidth: 200,
		    required: true,    
			missingMessage: '数据字典项名称不能为空',
		    prompt: '请输入数据字典项名称',
		});
		$('#serialNumber').fwebformcontrol({
			label: '序号:',
			labelWidth: 200,
		    required: true,
		    missingMessage: '序号不能为空',
			prompt: '请输入序号'
		});
		$('#dictCode').fwebformcontrol({
			label: '数据字典项编码:',
			labelWidth: 200,
		    required: true,
			missingMessage: '数据字典项编码不能为空',
			prompt: '请输入数据字典项编码'
		});
		$('#content1').fwebformcontrol({
			label: '扩展字段1:',
			labelWidth: 200,
			prompt: '请输入扩展字段1'
		});
		$('#content2').fwebformcontrol({
			label: '扩展字段2:',
			labelWidth: 200,
			prompt: '请输入扩展字段2'
		});
		$('#content3').fwebformcontrol({
			label: '扩展字段3:',
			labelWidth: 200,
			prompt: '请输入扩展字段3'
		});
		$('#content4').fwebformcontrol({
			label: '扩展字段4:',
			labelWidth: 200,
			prompt: '请输入扩展字段4'
		});
		$('#description').fwebformcontrol({
			label: '描述:',
			labelWidth: 200,
			height: 128,
		    required: false,
		    multiline: true,
		    missingMessage: '描述不能为空',
			prompt: '请输入描述'
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
