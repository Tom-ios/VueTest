<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>表单插件</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  	<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/style/css/easyui/bootstrap.css">
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
		.easyui-searchlayout{
			display: flex;
			padding-left: 0;
		}
		.easyui-searchlayout label{
			font-weight: lighter;
		    background-color: #fff;
		    border: none;
		}
		.easyui-searchlayout>span.textbox input,
		.easyui-searchlayout>span.textbox select{
			width: 100% !important;
		}
		.easyui-searchlayout>span.textbox{
			width: 64% !important;
		}
	</style>
	
</head>

<body>
	<div class="container-fluid" style="border: 1px solid green; width: 100%; height: auto;">
	<div class="row">
		<div id="layout">
			<input id="tt1" class="easyui-textbox" label="Name:" labelposition="before" 
			labelWidth="100" labelAlign="right" data-options="
				validType: 'minLength[3]',
			    missingMessage: '用户名不能为空'">
		</div>
		<div class="easyui-searchlayout" data-options="col:'3',paddingBottom: 8">
			<input class="easyui-textbox" label="Name:" labelposition="before" labelWidth="100" labelAlign="right">
		</div>
		<div class="easyui-searchlayout" data-options="col:'3',paddingBottom: 8">
			<select class="easyui-combobox" name="state" label="State:" labelposition="before" 
				labelWidth="100" labelAlign="right">
				<option value="">&nbsp;</option>
				<option value="AL">Alabama</option>
				<option value="AK">Alaska</option>
				<option value="AZ">Arizona</option>
			</select>
		</div>
		<div class="easyui-searchlayout" data-options="col:'3',paddingBottom: 8">
			<input class="easyui-combobox" data-options="
				label: 'language:',
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
			    }]" />
		</div>
		<div class="easyui-searchlayout" data-options="col:'3',paddingBottom: 8">
			<input type="text" class="easyui-datebox"  data-options="
				label: 'data:',
				labelposition: 'before',
				labelWidth: 100,
				labelAlign: 'right',
				panelWidth: 180">
			</input>
		</div>
		<div class="easyui-searchlayout" data-options="col:'3',paddingBottom: 8">
			<input type="text" class="easyui-datetimebox"  data-options="
				label: 'datatime:',
				labelposition: 'before',
				labelWidth: 100,
				labelAlign: 'right',
				panelWidth: 180">
			</input>
		</div>
	</div>
	<div class="row">
		<div class="easyui-searchlayout" data-options="col:'12',paddingBottom: 8">
			<button>aaa</button>
		</div>
	</div>	
	</div>

    <script type="text/javascript">
    
	    $.extend($.fn.textbox.methods, {
			addClearBtn: function(jq, iconCls){
				return jq.each(function(){
					var t = $(this);
					var opts = t.textbox('options');
					opts.icons = opts.icons || [];
					opts.icons.unshift({
						iconCls: iconCls,
						handler: function(e){
							$(e.data.target).textbox('clear').textbox('textbox').focus();
							$(this).css('visibility','hidden');
						}
					});
					t.textbox();
					if (!t.textbox('getText')){
						t.textbox('getIcon',0).css('visibility','hidden');
					}
					t.textbox('textbox').bind('keyup', function(){
						var icon = t.textbox('getIcon',0);
						if ($(this).val()){
							icon.css('visibility','visible');
						} else {
							icon.css('visibility','hidden');
						}
					});
				});
			}
		});
	
 		$(function(){
 			$("#layout").searchlayout({
 				col : '3',
 				paddingBottom: 8
 			});
 			
 			$('#tt1').textbox().textbox('addClearBtn', 'icon-clear');
 		});
    </script>

</body>
</html>