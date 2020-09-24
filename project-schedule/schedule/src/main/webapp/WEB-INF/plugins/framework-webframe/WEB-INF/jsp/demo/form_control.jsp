<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>表单控制器</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  	<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/style/css//easyui/bootstrap.css">
    <link rel="stylesheet" href="http://static.365power.cn/scss/web/v3.1.20180117/skin1/assets-3rd/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/style/icons/css/ionicons.min.css">
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/style/css/AdminLTE.css">
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/style/css/skins/_all-skins.css">
    
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/style/css/easyui/easyui.css">
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/style/css/easyui/easyui_full.css">
	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/style/css/easyui/icons/icon.css">
	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/style/css/fweb/css.css">
	
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/insdep/jquery.insdep-extend.min.js"></script>
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/validate_extend.js"></script>
	
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/expand/searchlayout.js"></script>
	
	<style type="text/css">
		.pb-15{
			padding-bottom: 15px;
		}
		body label {
			font-weight: lighter;
		    background-color: #fff !important;
		    border: none !important;
		}
		input{
			/* height: 52px; */
		}
	</style>
	
</head>

<body>
	<div class="wrapper">
		<!-- 文本框 -->
		<h1>水平分布的文本框</h1>
		<div class="container">
			<div class="row pb-15">
				<input id="tt1" class="textbox-radius" style="height: 32px; width: 30%;">
			</div>
			<div class="row pb-15">
				<input type="password" id="tt2" class="textbox-radius" style="height: 32px; width: 30%;">
			</div>
			<div class="row pb-15">
				<input id="tt3" class="textbox-radius" style="height: 96px; width: 30%;">
			</div>
		</div>
		
		<h1>垂直分布的文本框</h1>
		<div class="container">
			<div class="row pb-15">
				<input id="tt1_vertical" class="textbox-radius" style="height: 52px; width: 30%;">
			</div>
			<div class="row pb-15">
				<input type="password" id="tt2_vertical" class="textbox-radius" style="height: 52px; width: 30%;">
			</div>
			<div class="row pb-15">
				<input id="tt3_vertical" class="textbox-radius" style="height: 118px; width: 30%;">
			</div>
		</div>
		
		<!-- 下拉框 -->
		<h1>水平分布的下拉框</h1>
		<div class="container">
			<div class="row pb-15">
				<input id="cb1" class="textbox-radius" style="width: 30%;">
			</div>
			<div class="row pb-15">
				<input id="cb2" class="textbox-radius" style="width: 30%;">
			</div>
		</div>
		
		<h1>垂直分布的下拉框</h1>
		<div class="container">
			<div class="row pb-15">
				<input id="cb1_vertical" class="textbox-radius" style="height: 52px; width: 30%;">
			</div>
			<div class="row pb-15">
				<input id="cb2_vertical" class="textbox-radius" style="height: 52px; width: 30%;">
			</div>
		</div>
	</div>

    <script type="text/javascript">
	
 		$(function(){
 			$("#tt1").textbox({
 				label: 'name:',
 				labelPosition: 'beffore',
 				labelWidth: 100,
 				labelAlign: 'right',
 				required: true,
 				validType: 'minLength[3]',
 				missingMessage: '用户名不能为空',
 				prompt: '请输入用户名'
 			});
 			$("#tt2").textbox({
 				label: 'name:',
 				labelPosition: 'beffore',
 				labelWidth: 100,
 				labelAlign: 'right',
 				required: true,
 				validType: 'minLength[6]',
 				missingMessage: '密码不能为空',
 				prompt: '请输入密码'
 			});
 			$("#tt3").textbox({
 				label: 'name:',
 				labelPosition: 'beffore',
 				labelWidth: 100,
 				labelAlign: 'right',
 				required: true,
 				validType: 'minLength[3]',
 				missingMessage: '用户名不能为空',
 				multiline: true,
 				value: 'ddfdf'
 			});
 			
 			$("#tt1_vertical").textbox({
 				label: 'name:',
 				labelPosition: 'top',
 				required: true,
 				validType: 'minLength[3]',
 				missingMessage: '用户名不能为空',
 				prompt: '请输入用户名'
 			});
 			$("#tt2_vertical").textbox({
 				label: 'name:',
 				labelPosition: 'top',
 				required: true,
 				validType: 'minLength[6]',
 				missingMessage: '密码不能为空'
 			});
 			$("#tt3_vertical").textbox({
 				label: 'name:',
 				labelPosition: 'top',
 				required: true,
 				validType: 'minLength[3]',
 				missingMessage: '用户名不能为空',
 				multiline: true,
 				value: 'ddfdf'
 			});
 			
 			/* 下拉框 */
 			$("#cb1").combobox({
				label: 'language:',
				labelposition: 'before',
				labelWidth: 100,
				labelAlign: 'right',
			    valueField: 'label',
			    textField: 'value',
			    prompt: '请输入语言',
			    data: [{
			      label: 'java',
			      value: 'Java'
			    },{
			      label: 'perl',
			      value: 'Perl'
			    },{
			      label: 'ruby',
			      value: 'Ruby'
			    }]
 			});
 			$("#cb2").combobox({
				label: 'language2:',
				labelposition: 'before',
				labelWidth: 100,
				labelAlign: 'right',
			    valueField: 'label',
			    textField: 'value',
			    multiple: true,
			    data: [{
			      label: 'java',
			      value: 'Java'
			    },{
			      label: 'perl',
			      value: 'Perl'
			    },{
			      label: 'ruby',
			      value: 'Ruby'
			    }]
 			});
 			
 			$("#cb1_vertical").combobox({
				label: 'language:',
				labelPosition: 'top',
			    valueField: 'label',
			    textField: 'value',
			    prompt: '请输入语言',
			    data: [{
			      label: 'java',
			      value: 'Java'
			    },{
			      label: 'perl',
			      value: 'Perl'
			    },{
			      label: 'ruby',
			      value: 'Ruby'
			    }]
 			});
 			$("#cb2_vertical").combobox({
				label: 'language2:',
				labelPosition: 'top',
			    valueField: 'label',
			    textField: 'value',
			    multiple: true,
			    data: [{
			      label: 'java',
			      value: 'Java'
			    },{
			      label: 'perl',
			      value: 'Perl'
			    },{
			      label: 'ruby',
			      value: 'Ruby'
			    }]
 			});
 			
 		});
    </script>

</body>
</html>