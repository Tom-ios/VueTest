<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>面包屑首页</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  	<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />
  	<link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/style/css/bootstrap.css">
  	<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css">
    <!-- <link rel="stylesheet" href="http://static.365power.cn/scss/web/v3.1.20180117/skin1/assets-3rd/font-awesome/css/font-awesome.min.css"> -->
<!--     <link rel="stylesheet" href="${config.base()}framework-webframe/assets/awesome/css/font-awesome.min.css"> -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/icons/css/ionicons.min.css">
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/AdminLTE.css">
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/skins/_all-skins.css">
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/jquery.gritter.css">
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/gritter.extra.css">
    
    <link rel="stylesheet" href="${config.base()}framework-webframe/assets-3rd/iCheck/all.css">
    
  	<link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/style/css/easyui/easyui.css">
	<link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/style/css/easyui/insdep/insdep_tables.css">
  	<%-- <link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/css/easyui/easyui_full.css"> --%>
  	<link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/style/css/easyui/insdep/easyui_plus.css">
	<link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/style/css/easyui/icons/icon.css">
	<!-- <link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/css/easyui/demo.css"> -->
	<link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/style/css/fweb/css.css">
	
	<script type="text/javascript" src="${config.base()}framework-webframe/js/easyui/jquery/jquery.min.js"></script>
	<script src="${config.base()}framework-webframe/js/commons/bootstrap.min.js"></script>
	<script type="text/javascript" src="${config.base()}framework-webframe/js/commons/jquery.json-2.2.js"></script>
	<script type="text/javascript" src="${config.base()}framework-webframe/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${config.base()}framework-webframe/js/easyui/insdep/jquery.insdep-extend.min.js"></script>
	
	<script type="text/javascript" src="${config.base()}framework-webframe/assets-3rd/iCheck/icheck.min.js"></script>
	
	<script type="text/javascript" src="${config.base()}framework-webframe/js/fweb/fweb.util.js"></script>
	<script type="text/javascript" src="${config.base()}framework-webframe/js/fweb/bread_crumbs2.js"></script>
	<!-- 提示框 （必选） -->
	<script src="${config.base()}framework-webframe/js/commons/jquery.gritter.min.js" type="text/javascript"></script>
	<!-- 字体控制插件 （必选） -->
	<script src="${config.base()}framework-webframe/js/fweb/fweb_fs.js"></script>
	
	
	<style type="text/css">
		/* #contentHeader>a{
			color: #00a65a;
		} */
		#layout-north div{
			display: none;
		}
	</style>
	
</head>

<body style="background-color: #ecf0f5;" class="skin-green-light fs_14 easyui-layout">
	<div id="layout-north" class="content-layout-north" data-options="region:'north',border:false">
		<!-- 顶部布局 -->
	</div>
	<div class="content-layout-south" data-options="region:'south',border:false">
		<!-- 底部布局 -->
	</div>
	<div class="content-layout-west" data-options="region:'west',border:false">
		<!-- 左侧布局 -->
	</div>
	<div class="content-layout-east" data-options="region:'east',border:false">
		<!-- 右侧布局 -->
	</div>
	<div class="content-layout-center" data-options="region:'center',border:false" id="center_content">
		<!-- 主体布局 -->
	</div>

	
<script type="text/javascript">
	$(function(){
		//添加列表页
		crumbs.setBasePath('${Config.basePath}');
		crumbs.addCrumbs({
			name:'用户信息',
			url:'${config.base()}framework-webframe/demo/tabletest',
			//url:'view/demoframe/basetable',
			callback:function($par){
				if($par && $par.isRefresh){
					//是否回首页
					if($par.isHomePage)
						$('#dg').datagrid('reload');
					else
						$('#dg').datagrid('load');
						
					return;					
				}
				
				//datagrid表格的宽度，为0时，调整宽度
				var panelBodyWidth = $('#dg')
					.parent()
					.outerHeight();
				
				if(panelBodyWidth != 0)
					return;
				
				$('#dg').datagrid({
			        fitColumns : true
			    });
				
			}
		});
	});
</script>

</body>
</html>