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
		#searchDiv .form-input .textbox.combo{
			width: 135px !important;
		}
		#searchDiv .form-input{
			padding-left: unset;
		}
	</style>

		<table id="sortDictDg" class="easyui-datagrid fs_14" fit="true" style="width: auto;">
		</table>
		<div id="tb">
			<form id="ff_sort_type_list" class="form-inline container-fluid search-form">
			
			  	<div id="searchDiv" class="row">
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="searchcontent" class="control-label"></label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="searchcontent" type="text" class="form-control" id="searchcontent" placeholder="请输入名称、编码或key">
				  		</div>
				  	</div>
			  	</div>
			  	
			</form>
			
			<div class="toolbar-table-btn">
				<a href="javascript:void(0);" onclick="addSortDict()" class="btn btn-skin bg_f"><span class="fa fa-plus"></span>&nbsp;添加</a>
				<a href="javascript:void(0);" onclick="delSortDict()" class="btn btn-skin bg_f"><span class="fa fa-trash-o"></span>&nbsp;批量删除</a>
			</div>
			
		</div>
	
	<script type="text/javascript">
		
		var queryParam = {};
		var $itemId;
		var basePath = '${config.path()}';
		var basePage = '${config.page()}';
	
		$(function(){
			toggleSearchStat('1');
			$("#sortDictDg").datagrid({
				pagination : true,
				method : 'get',
				url : basePath+'commons/sort/dict/page',
	 			singleSelect : false,
	 			checkOnSelect : true,
				rownumbers : false,
				toolbar : '#tb',
				queryParams : queryParam,
				fitColumns : true,
				rowStyler: function(index,row){
					//return 'background-color:#6293BB;'; // return inline style
				},
				columns : [[
				    {
						field : 'ck',
						checkbox : true
				    },{
						field : 'name',
						title : '数据字典项名称',
						width : '30%',
						formatter : function(value,row,index){
							return '<a href="javaScript:showSortDictDetail(\''+row.id+'\')">'+value+'</a>';
						}
				    },{
				    	field : 'serialNumber',
						title : '序号',
						width : '10%'
				    },{
				    	field : 'dictCode',
						title : '编码',
						//fixed : true,
						width : '30%'
				    },{
				    	field : 'option',
						title : '操作',
						formatter : function(value,row,index){
							return '<i onclick="editSortDict(\''+row.id+'\')" class="fa fa-edit option-icon" title="编辑"></i>'
								  +'<i id="row_del_'+row.id+'" class="fa fa-trash-o del-icon"></i>'
								  +'<i onclick="copySortDict(\''+row.id+'\')" class="fa fa-copy option-icon" title="复制新建"></i>';
						},
						//fixed : true,
						width : '30%'
				    }
					
				]],
				onLoadSuccess : function(data){
					try{
						$(".popover[id^=popover]").popover('destroy');
					}catch(err){
					}
					if(data && data.rows)
						for(j = 0,len=data.rows.length; j < len; j++) {
							if(data.rows[j].id)
								initDelPopOver(data.rows[j].id);
						}
					
				},
				emptyMsg : '<span>暂无相关数据</span>'
				
			});
			
			//为输入框绑定回车事件
			$(".search-form input").keypress(function(e){
		        var eCode = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
		        if (eCode == 13){
		        	searchSortDictList();
		        	return false;
		        }
			});
			
		});

		//表格宽度自适应，这里的#dg是datagrid表格生成的div标签
		function fitCoulms(){
		    //$('#sortDictDg').datagrid('resize');
		    $('#sortDictDg').datagrid({
		        fitColumns:true,
		        fit:true
		    });
		}
		
		function addSortDict(){
			//添加编辑页
			crumbs.addCrumbs({name:'添加',url:'dict/sortDictEdit?itemId='+$itemId});
		}
		
		function editSortDict(id_){
			//var row = $('#sortDictDg').datagrid('getSelected');
			if (id_){
				//添加编辑页
				crumbs.addCrumbs({
					name:'编辑',
					url:'dict/sortDictEdit?id='+id_+'&itemId='+$itemId
				});
			} else{
				$.gritter.add({  
				    text: '请选择要编辑的数据',  
				    sticky: false,  
				    time: 3000,
				    speed:500,  
				    class_name: 'gritter-success'  
				});
			}
		}
		
		function copySortDict(id_){
			if (id_){
				//添加编辑页
				crumbs.addCrumbs({
					name:'复制新建',
					url:'dict/sortDictEdit?id='+id_+'&copy=true&itemId='+$itemId
				});
			} else{
				$.gritter.add({  
				    text: '请选择要复制新建的数据',  
				    sticky: false,  
				    time: 3000,
				    speed:500,  
				    class_name: 'gritter-success'  
				});
			}
		}
		
		function showSortDictDetail(id_){
			//添加详情页
			crumbs.addCrumbs({name:'详情',url:'dict/sortDictDetail?id='+id_});
		}
		
		//初始化删除弹出层
		function initDelPopOver(id_){
			$('#row_del_'+id_).popover({   
				trigger:'manual',//manual 触发方式  
				placement : 'top',    
				title:'<div style="text-align:left; color:gray; font-size:12px;">你确认要删除该数据字典项吗？</div>',  
				html: 'true', 
				container: 'body',
				//这里可以直接写字符串，也可以 是一个函数，该函数返回一个字符串；
				content : '<a style="margin-right: 8px;" href="javascript:void(0);" onclick="cancelDel(\''+id_+'\')" class="btn btn-default">取消</a>'
						 +'<a href="javascript:void(0);" onclick="delSortDict(\''+id_+'\')" class="btn btn-default">确认</a>',  
				animation: false  
			}).on("mouseenter", function () {  
				var _this = this;  
				$(this).popover("show");  
				$(this).siblings(".popover").on("mouseleave", function () {  
					$(_this).popover('hide');  
				});  
			}).on("mouseleave", function () {  
				var _this = this;  
				setTimeout(function () {  
					if (!$(".popover:hover").length) {  
						$(_this).popover("hide")  
					}  
				}, 100);  
			});
		}
		
		//隐藏删除弹出层
		function cancelDel(id_){
			$("#row_del_"+id_).popover('hide');
		}
		
		//删除数据字典项
		function delSortDict(id_){
			var rows = $('#sortDictDg').datagrid('getChecked');

			if(!id_ && rows.length>0){
				id_ = "";
				for(var i=0,len=rows.length;i<len;i++){
					id_+=rows[i].id+",";
				}
				id_ = id_.substring(0,id_.length-1);
			}
			
			$("#row_del_"+id_).popover('hide');
			if (id_){
				$.ajax({
					url : basePath+'commons/sort/dict/batch?ids='+id_+'&itemId='+$itemId,
					type : 'delete',
					contentType : 'application/json;charset=UTF-8',
					success : function(data) {
						$('#sortDictDg').datagrid('reload');
						$.gritter.add({  
						    text: '删除成功',  
						    sticky: false,  
						    time: 3000,
						    speed:500,  
						    class_name: 'gritter-success'  
						}); 
					},
					error : function(xhr) {
						$.gritter.add({  
						    text: '删除失败',  
						    sticky: false,  
						    time: 3000,  
						    speed:500,  
						    class_name: 'gritter-error'  
						}); 
					}
				});
			}else{
				$.gritter.add({  
				    text: '请选择要删除的数据',  
				    sticky: false,  
				    time: 3000,  
				    speed:500,  
				    class_name: 'gritter-warning'
				}); 
			}
		}
		
		//刷新列表
		function refreshDatagrid(){
			$('#sortDictDg').datagrid('reload');
		}
		
		//根据查询条件分页获取数据字典项列表
		function searchSortDictList(isReset_, itemId){
			if(itemId)
				$itemId = itemId;
			if(isReset_){
				$('#ff_sort_type_list').form('clear');
				queryParam = {itemId: $itemId||''};
			}else
				queryParam = {
					content : $("#searchcontent").val(),
					//此处获取itemId
					itemId : $itemId||'',
				};
			$('#sortDictDg').datagrid('load',queryParam);
		}
		
		//切换搜索框区域状态（展开、收起）
		function toggleSearchStat(stat_){
			
		  	$("#searchButtonDiv").remove();
		  	
		  	var searchToggleButtonShow = $("#searchDiv").children().length > 7;
		  	
		  	if(stat_ == '1'){
			  	//收起
			  	$("#searchDiv").children().hide();
			  	$("#searchDiv").children(':lt(7)').show();
			  	
		  		$("#searchDiv").append(
		  			'<div id="searchButtonDiv" class="col-md-3 col-xs-3 col-sm-4 search-button">'
		  		   +	'<a onclick="searchSortDictList()" class="btn btn-primary">查&nbsp;询</a>'
			  	   +	'<a onclick="searchSortDictList(true)" class="btn btn-default search-button-reset">重&nbsp;置</a>'
			  	   +	(searchToggleButtonShow?'<a href="javascript:void(0);" onclick="toggleSearchStat(\'0\')" class="search-button-more">更多&nbsp;<i class="fa fa-angle-down"></i></a>':'')
			  	   +'</div>'
		  		);
		  	}else{
		  		//展开
		  		$("#searchDiv").children().show();
		  		$("#searchDiv").parent().append(
		  			'<div id="searchButtonDiv" class="row">'
		  		   +'<div class="search-button search-button-expend">'
		  		   +	'<a onclick="searchSortDictList()" class="btn btn-primary">查&nbsp;询</a>'
			  	   +	'<a onclick="searchSortDictList(true)" class="btn btn-default search-button-reset">重&nbsp;置</a>'
			  	   +	(searchToggleButtonShow?'<a href="javascript:void(0);" onclick="toggleSearchStat(\'1\')" class="search-button-more"><i class="fa fa-angle-up"></i>更多&nbsp;</a>':'')
			  	   +'</div>'
			  	   +'</div>'
		  		);
		  	}
		  	
		  	fitCoulms();
		}
	</script>
