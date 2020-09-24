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
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/easyui/bootstrap.css">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- <link rel="stylesheet" href="http://static.365power.cn/scss/web/v3.1.20180117/skin1/assets-3rd/font-awesome/css/font-awesome.min.css"> -->
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/assets/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/css/AdminLTE.css">
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/css/skins/_all-skins.css">
    
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/easyui/easyui.css">
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/easyui/easyui_full.css">
	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/easyui/icons/icon.css">
	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/custom/css.css">
	
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/insdep/jquery.insdep-extend.min.js"></script>
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/validate_extend.js"></script>
	
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/plugins/fweb_form_control.js"></script>
	
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
		<div class="col-md-6">
			<div class="pb-15">
				<input id="tt1" name="tt1" class="textbox-radius easyui-fwebformcontrol" data-options="
					label: '用户名:',
	 				required: true,
	 				validType: 'minLength[3]',
	 				missingMessage: '用户名不能为空',
	 				prompt: '请输入用户名'
				">
			</div>
			<div class="pb-15">
				<input id="tt2" class="textbox-radius">
			</div>
			<div class="pb-15">
				<input id="tt3" class="textbox-radius" style="height: 96px;">
			</div>
			<div class=" pb-15">
				<input id="cb1" class="textbox-radius">
			</div>
			<div class=" pb-15">
				<input id="cb2" class="textbox-radius">
			</div>
			<div class=" pb-15">
				<input id="db1" class="textbox-radius">
			</div>
			<div class=" pb-15">
				<input id="dtb1" class="textbox-radius">
			</div>
			<!-- <div class=" pb-15">
				<button onclick="getForm()">获取form</button>
			</div> -->
		</div>
		
		<div class="col-md-6">
			<div class=" pb-15">
				<input id="tt1_vertical" class="textbox-radius">
			</div>
			<div class=" pb-15">
				<input id="tt2_vertical" class="textbox-radius">
			</div>
			<div class=" pb-15">
				<input id="tt3_vertical" class="textbox-radius" style="height: 96px;">
			</div>
			<div class=" pb-15">
				<input id="cb1_vertical" class="textbox-radius">
			</div>
			<div class=" pb-15">
				<input id="cb2_vertical" class="textbox-radius">
			</div>
			<div class=" pb-15">
				<input id="db1_vertical" class="textbox-radius">
			</div>
			<div class=" pb-15">
				<input id="dtb1_vertical" class="textbox-radius">
			</div>
		</div>
		
	</div>

    <script type="text/javascript">
	
 		$(function(){
 			/* $("#tt1").fwebformcontrol({
 				
 			}); */
 			$("#tt2").fwebformcontrol({
 				label: '密码:',
 				required: true,
 				validType: 'minLength[6]',
 				missingMessage: '密码不能为空',
 				type: 'password',
 				prompt: '请输入密码'
 			});
 			$("#tt3").fwebformcontrol({
 				label: '描述:',
 				required: true,
 				validType: 'minLength[20]',
 				missingMessage: '描述不能为空',
 				multiline: true,
 				value: 'ddfdf',
 				prompt: '请输入描述'
 			});
 			
 			$("#tt1_vertical").fwebformcontrol({
 				label: '用户名:',
 				labelPosition: 'top',
				labelAlign: 'left',
 				required: true,
 				validType: 'minLength[3]',
 				missingMessage: '用户名不能为空',
 				prompt: '请输入用户名'
 			});
 			$("#tt2_vertical").fwebformcontrol({
 				label: '密码:',
 				labelPosition: 'top',
				labelAlign: 'left',
 				required: true,
 				validType: 'minLength[6]',
 				missingMessage: '密码不能为空',
 				type: 'password',
 				prompt: '请输入密码'
 			});
 			$("#tt3_vertical").fwebformcontrol({
 				label: '描述:',
 				labelPosition: 'top',
				labelAlign: 'left',
 				required: true,
 				validType: 'minLength[20]',
 				missingMessage: '用户名不能为空',
 				multiline: true,
 				value: 'ddfdf',
 				prompt: '请输入描述'
 			});
 			
 			/* 下拉框 */
 			$("#cb1").fwebformcontrol({
				label: '语言:',
			    valueField: 'label',
			    textField: 'value',
			    prompt: '请输入语言',
			    controlType: 'combobox',
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
 			$("#cb2").fwebformcontrol({
				label: '语言2:',
			    valueField: 'label',
			    textField: 'value',
			    multiple: true,
			    controlType: 'combobox',
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
 			
 			$("#cb1_vertical").fwebformcontrol({
				label: '语言:',
				labelPosition: 'top',
				labelAlign: 'left',
			    valueField: 'label',
			    textField: 'value',
			    prompt: '请输入语言',
			    controlType: 'combobox',
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
 			$("#cb2_vertical").fwebformcontrol({
				label: '语言2:',
				labelPosition: 'top',
				labelAlign: 'left',
			    valueField: 'label',
			    textField: 'value',
			    multiple: true,
			    controlType: 'combobox',
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
 			
 			/* 下拉框 */
 			$("#db1").fwebformcontrol({
				label: '日期:',
			    valueField: 'label',
			    textField: 'value',
			    controlType: 'datebox',
			    prompt: '请输入日期'
 			});
 			$("#dtb1").fwebformcontrol({
				label: '日期时间:',
			    valueField: 'label',
			    textField: 'value',
			    multiple: true,
			    controlType: 'datetimebox',
			    prompt: '请输入日期时间'
 			});
 			
 			$("#db1_vertical").fwebformcontrol({
				label: '日期:',
				labelPosition: 'top',
				labelAlign: 'left',
			    valueField: 'label',
			    textField: 'value',
			    prompt: '请输入日期',
			    controlType: 'datebox'
 			});
 			$("#dtb1_vertical").fwebformcontrol({
				label: '日期时间:',
				labelPosition: 'top',
				labelAlign: 'left',
			    valueField: 'label',
			    textField: 'value',
			    multiple: true,
			    controlType: 'datetimebox',
			    prompt: '请输入日期时间'
 			});
 			
 		});
 		
 		
 		function getForm(){
 			var tt1 = $("#tt1").fwebformcontrol('getValue');
 			var tt2 = $("#tt2").fwebformcontrol('getValue');
 			var tt3 = $("#tt3").fwebformcontrol('getValue');
 			var cb1 = $("#cb1").fwebformcontrol('getValue');
 			var cb2 = $("#cb2").fwebformcontrol('getValue');
 			var cb2s = $("#cb2").fwebformcontrol('getValues');
 			var db1 = $("#db1").fwebformcontrol('getValue');
 			var dtb1 = $("#dtb1").fwebformcontrol('getValue');
 			console.log(tt1);
 		}
 		
    </script>

</body>
</html>