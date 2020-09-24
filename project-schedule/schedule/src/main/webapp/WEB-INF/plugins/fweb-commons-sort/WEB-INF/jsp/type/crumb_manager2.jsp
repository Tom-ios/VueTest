<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>分类类别管理</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
	<link rel="shortcut icon" href="${config.ui() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />
  
  	<link rel="stylesheet" type="text/css" href="${config.ui() }fweb-framework-ui/style/css/bootstrap.min.css">
  	<link href="${config.ui() }fweb-framework-ui/assets/fonts/css/font-awesome.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${config.ui() }fweb-framework-ui/style/css/jquery.gritter.css">
    <link rel="stylesheet" href="${config.ui() }fweb-framework-ui/style/css/gritter.extra.css">
    
  	<link rel="stylesheet" type="text/css" href="${config.ui() }fweb-framework-ui/style/easyui/bootstrap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${config.ui() }fweb-framework-ui/style/easyui/insdep/insdep_tables.css">
  	<link rel="stylesheet" type="text/css" href="${config.ui() }fweb-framework-ui/style/easyui/insdep/easyui_plus.css">
	<link rel="stylesheet" type="text/css" href="${config.ui() }fweb-framework-ui/style/easyui/icon.css">
    <link rel="stylesheet" type="text/css" href="${config.ui() }fweb-framework-ui/style/css/fweb.css">
	
	<script type="text/javascript" src="${config.ui() }fweb-framework-ui/js/jquery.min.js"></script>
	<script src="${config.ui() }fweb-framework-ui/js/bootstrap/bootstrap.min.js"></script>
	<script type="text/javascript" src="${config.ui() }fweb-framework-ui/js/jquery.json-2.2.js"></script>
	<script type="text/javascript" src="${config.ui() }fweb-framework-ui/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${config.ui() }fweb-framework-ui/js/easyui/insdep/jquery.insdep-extend.min.js"></script>
	
	<script type="text/javascript" src="${config.path()}assets/js/fweb/fweb.util.js"></script>
	<script type="text/javascript" src="${config.path()}assets/js/fweb/bread_crumbs2.js"></script>
	<!-- 提示框 （必选） -->
	<script src="${config.ui() }fweb-framework-ui/js/gritter/jquery.gritter.min.js" type="text/javascript"></script>
	
	<style type="text/css">
		/* #contentHeader>a{
			color: #00a65a;
		} */
		#layout-north div{
			display: none;
		}
	</style>
	
</head>

<body class="easyui-layout">
	<div class="content-layout-center" data-options="region:'center',border:false" id="center_content">
		<!-- 主体布局 -->
	</div>

	
<script type="text/javascript">
	$(function(){
		//添加列表页
		crumbs.setBasePath('${config.page()}');
		crumbs.addCrumbs({
			name:'分类类型',
			url:'type/sortTypeList',
			//url:'view/demoframe/basetable',
			callback:function($par){
				if($par && $par.isRefresh){
					//是否回首页
					if($par.isHomePage)
						$('#sortTypeDg').datagrid('reload');
					else
						$('#sortTypeDg').datagrid('load');
						
					return;					
				}
				
				//datagrid表格的宽度，为0时，调整宽度
				var panelBodyWidth = $('#sortTypeDg')
					.parent()
					.outerHeight();
				
				if(panelBodyWidth != 0)
					return;
				
				$('#sortTypeDg').datagrid({
			        fitColumns : true
			    });
				
			}
		});
	});
</script>

</body>
</html>