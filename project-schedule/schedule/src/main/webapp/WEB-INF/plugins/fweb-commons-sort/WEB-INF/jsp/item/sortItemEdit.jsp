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
	</style>
	
<div class="hold-transition skin-green-light pace-done">
	<div class="col-md-10">
			<form id="ff" class="form-horizontal container-fluid">
			<div class="row">
			  	<div class="form-group">
			  		<input type="hidden" id="id" name="id" value="${param.id }">
			  		<input type="hidden" id="depth" name="depth">
			  		<input type="hidden" id="parentId" name="parentId" value="${param.parentId }">
			  		<input type="hidden" id="path" name="path">
				    <input type="hidden" id="typeKey" name="typeKey" value="${param.typeKey }">
				    <input id="name" name="name" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="serialNumber" name="serialNumber" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="itemKey" name="itemKey" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="itemCode" name="itemCode" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="dataShowType" name="dataShowType" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="userId" name="userId" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="editable" name="editable" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="iconType" name="iconType" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="iconUrl" name="iconUrl" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="iconOpenUrl" name="iconOpenUrl" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="iconCloseUrl" name="iconCloseUrl" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="iconClass" name="iconClass" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="iconOpenClass" name="iconOpenClass" class="textbox-radius">
			  	</div>
			  	<div class="form-group">
				    <input id="iconCloseClass" name="iconCloseClass" class="textbox-radius">
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
	var editType = '${param.editType}';

	function loadRemote(id_){
		$.ajax({
			url : basePath+'commons/sort/item?id='+id_,
			type : 'get',
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				$('#ff').form('load', {
					name : data.name||'',
					typeKey : data.typeKey||'',
					serialNumber : data.serialNumber,
					path : data.path||'',
					parentId : data.parentId||'',
					depth : data.depth||'',
					itemKey : data.itemKey||'',
					description : data.description||'',
					itemCode : data.itemCode||'',
					description : data.description||'',
					userId : data.userId||'',
					iconType : data.iconType||'',
					iconUrl : data.iconUrl||'',
					iconOpenUrl : data.iconOpenUrl||'',
					iconCloseUrl : data.iconCloseUrl||'',
					iconClass : data.iconClass||'',
					iconOpenClass : data.iconOpenClass||'',
					iconCloseClass : data.iconCloseClass||'',
					content1 : data.content1||'',
					content2 : data.content2||'',
					content3 : data.content3||'',
					content4 : data.content4||''
				});
				
				if(data.dataShowType)
					$('#dataShowType').fwebformcontrol('setValueTest',data.dataShowType);
				if(data.editable)
					$('#editable').fwebformcontrol('setValueTest',data.editable);
			},
			error : function(xhr) {
				$.gritter.add({  
				    text: '获取分类信息失败',  
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
					
					var sortItem = $("#ff").serializeObject();
					
					var requestType = "post";
					
					if("${param.id}" && copy != 'true'){
						requestType = "put";
					}
					
					$.ajax({
						url : basePath+'commons/sort/item',
						type : requestType,
						async : false,
						data : $.toJSON(sortItem),
						contentType : 'application/json;charset=UTF-8',
						success : function(data) {
							$.gritter.add({  
							    text: '保存成功',  
							    sticky: false,  
							    time: 3000,
							    speed:500,  
							    class_name: 'gritter-success'  
							});
							crumbs.goback();
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
			label: '分类名称:',
			labelWidth: 200,
		    required: true,    
			missingMessage: '分类名称不能为空',
		    prompt: '请输入分类名称',
		});
		$('#serialNumber').fwebformcontrol({
			label: '序号:',
			labelWidth: 200,
		    required: true,
		    missingMessage: '序号不能为空',
			prompt: '请输入序号'
		});
		$('#itemKey').fwebformcontrol({
			label: '分类键值:',
			labelWidth: 200,
		    required: true,
		    missingMessage: '分类键值不能为空',
			prompt: '请输入分类键值'
		});
		$('#itemCode').fwebformcontrol({
			label: '分类编码:',
			labelWidth: 200,
			prompt: '请输入分类编码'
		});
		$('#dataShowType').fwebformcontrol({
			label: '数据字典展示类型:',
			labelWidth: 200,
			required: true,
		    data: [{
		    	label: '平铺',
		    	value: '1',
		    	checked: true
		    },{
		    	label: '树',
		    	value: '0',
		    	checked: false
		    }],
		    controlType: 'radiobox'
		});
		$('#userId').fwebformcontrol({
			label: '分类项所属的用户ID:',
			labelWidth: 200,
			prompt: '请输入分类项所属的用户ID'
		});
		$('#editable').fwebformcontrol({
			label: '是否可编辑:',
			labelWidth: 200,
			required: true,
		    data: [{
		    	label: '是',
		    	value: '1',
		    	checked: true
		    },{
		    	label: '否',
		    	value: '0',
		    	checked: false
		    }],
		    controlType: 'radiobox'
		});
		$('#iconType').fwebformcontrol({
			label: '图标类型:',
			labelWidth: 200,
		    valueField: 'value',
		    textField: 'label',
		    validType: 'selectValid[""]',
		    missingMessage: '图标类型不能为空',
		    prompt: '请输入图标类型',
		    controlType: 'combobox',
		    data: [{
			      label: '请选择图标类型',
			      value: ''
			    },{
			      label: '字体图标',
			      value: '01'
			    },{
			      label: '自定义图标',
			      value: '02'
			    }]
		});
		$('#iconUrl').fwebformcontrol({
			label: '图标地址:',
			labelWidth: 200,
			prompt: '请输入图标地址'
		});
		$('#iconOpenUrl').fwebformcontrol({
			label: '展开图标地址:',
			labelWidth: 200,
			prompt: '请输入展开图标地址'
		});
		$('#iconCloseUrl').fwebformcontrol({
			label: '收起图标地址:',
			labelWidth: 200,
			prompt: '请输入收起图标地址'
		});
		$('#iconClass').fwebformcontrol({
			label: '字体图标样式:',
			labelWidth: 200,
			prompt: '请输入字体图标样式'
		});
		$('#iconOpenClass').fwebformcontrol({
			label: '展开字体图标样式:',
			labelWidth: 200,
			prompt: '请输入展开字体图标样式'
		});
		$('#iconCloseClass').fwebformcontrol({
			label: '收起字体图标样式:',
			labelWidth: 200,
			prompt: '请输入收起字体图标样式'
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
