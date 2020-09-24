<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
	<link rel="shortcut icon" href="${config.ui() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />

<div class="container" id="sortTypeDetailDiv">
</div>


<script type="text/javascript">
	
	var basePath = '${config.path()}';
	
	$(function(){
		$.ajax({
			url : basePath+'commons/sort/type?id=${param.id}',
			type : 'get',
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				var $sortTypeDetailDiv = $("#sortTypeDetailDiv");
				$name = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">分类类别名称：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.name||'')+'</span>'
						   +'</div>';
				$typeKey = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">分类类别key：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.typeKey||'')+'</span>'
						   +'</div>';
				$serialNumber = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">序号：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.serialNumber)+'</span>'
						   +'</div>';
				$validDate = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">字典生效日期：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.validDate||'')+'</span>'
						   +'</div>';
				//维护单位，以后可以关联单位表
				$maintOrg = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">维护单位：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.maintOrg||'')+'</span>'
						   +'</div>';
					
				var maintTypeName;
				if(data.maintType == '01')
					maintTypeName = '不可维护';
				else if(data.maintType == '02')
					maintTypeName = '可增加';
				else if(data.maintType == '03')
					maintTypeName = '可增删改';
				$maintTypeName = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">维护类型：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(maintTypeName||'')+'</span>'
						   +'</div>';
						   
				$typeVersion = '<div class="row">'
						   	 +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">版本：</label>'
						     +'<span class="col-md-8 col-sm-8">'+(data.typeVersion||'')+'</span>'
						     +'</div>';
						     
				var validFlagName;
				if(data.validFlag == '0')
					validFlagName = '失效';
				else
					validFlagName = '有效';
				$validFlagName = '<div class="row">'
						   	 +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">有效标记：</label>'
						     +'<span class="col-md-8 col-sm-8">'+(validFlagName||'')+'</span>'
						     +'</div>';
					
				$description = '<div class="row">'
						   	 +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">描述：</label>'
						     +'<span class="col-md-8 col-sm-8" style="word-break: break-all;">'+(data.description||'')+'</span>'
						     +'</div>';
						     
				$sortTypeDetailDiv.append($name);
				$sortTypeDetailDiv.append($typeKey);
				$sortTypeDetailDiv.append($serialNumber);
				$sortTypeDetailDiv.append($validDate);
				$sortTypeDetailDiv.append($maintOrg);
				$sortTypeDetailDiv.append($typeVersion);
				$sortTypeDetailDiv.append($maintTypeName);
				$sortTypeDetailDiv.append($validFlagName);
				$sortTypeDetailDiv.append($description);
				
			},
			error : function(xhr) {
				alert("查询失败");
			}
		});
	});
	
</script>
