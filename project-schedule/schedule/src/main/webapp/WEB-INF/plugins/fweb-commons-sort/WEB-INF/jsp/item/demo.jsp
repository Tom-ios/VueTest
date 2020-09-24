<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />

	<link href="${config.ui() }fweb-framework-ui/style/css/bootstrap.min.css" rel="stylesheet">
	<link href="${config.base() }fweb-commons-sort/assets/fonts/css/font-awesome.min.css" rel="stylesheet">
	
	<script type="text/javascript" src="${config.path()}assets/js/easyui/validate_extend.js"></script>
	
	<style type="text/css">
		#demoDg{
			width: 80% !important;
		    height: 100%;
		    float: left;
		    border: 1px #00A65A solid;
		}
	</style>
	
		<div id="sortTree4bpm" style="width: 20%;float: left;"></div>
		<div id="demoDg" style="width: 80% !important;height: 100%;">
			<p>此处添加列表</p>
		</div>
	
	<script type="text/javascript">
		$(function(){
			$("#sortTree4bpm").load("${config.base() }view/fweb-commons-sort/item/sortTree?typeKey=${param.typeKey }&isRootShow=${param.isRootShow}");
		});
		function getSortItemId(id){
			alert(id);
		}
		
	</script>
