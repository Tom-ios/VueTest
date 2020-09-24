<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<div class="container" id="sortTypeDetailDiv">
</div>


<script type="text/javascript">
	
	var basePath = '${config.path()}';
	
	$(function(){
		$.ajax({
			url : basePath+'commons/sort/dict?id=${param.id}',
			type : 'get',
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				var $sortTypeDetailDiv = $("#sortTypeDetailDiv");
				$name = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">数据字典项名称：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.name||'')+'</span>'
						   +'</div>';
				$serialNumber = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">序号：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.serialNumber)+'</span>'
						   +'</div>';
				$dictKey = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">数据字典项key：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.dictKey||'')+'</span>'
						   +'</div>';
				$dictCode = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">编码：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.dictCode||'')+'</span>'
						   +'</div>';
				$content1 = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">扩展字段1：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.content1||'')+'</span>'
						   +'</div>';
				$content2 = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">扩展字段1：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.content2||'')+'</span>'
						   +'</div>';
				$content3 = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">扩展字段1：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.content3||'')+'</span>'
						   +'</div>';
				$content4 = '<div class="row">'
						   +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">扩展字段1：</label>'
						   +'<span class="col-md-8 col-sm-8">'+(data.content4||'')+'</span>'
						   +'</div>';
					
				$description = '<div class="row">'
						   	 +'<label class="col-md-offset-2 col-md-2 col-sm-offset-2 col-sm-2">描述：</label>'
						     +'<span class="col-md-8 col-sm-8" style="word-break: break-all;">'+(data.description||'')+'</span>'
						     +'</div>';
						     
				$sortTypeDetailDiv.append($name);
				$sortTypeDetailDiv.append($serialNumber);
				$sortTypeDetailDiv.append($dictKey);
				$sortTypeDetailDiv.append($dictCode);
				$sortTypeDetailDiv.append($content1);
				$sortTypeDetailDiv.append($content2);
				$sortTypeDetailDiv.append($content3);
				$sortTypeDetailDiv.append($content4);
				$sortTypeDetailDiv.append($description);
				
			},
			error : function(xhr) {
				alert("查询失败");
			}
		});
	});
	
</script>
