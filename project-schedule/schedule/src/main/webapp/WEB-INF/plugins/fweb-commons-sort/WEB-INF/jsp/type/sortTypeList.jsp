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
		#searchDiv .form-input .textbox.combo{
			width: 135px !important;
		}
		#searchDiv .form-input{
			padding-left: unset;
		}
	</style>

		<table id="sortTypeDg" class="easyui-datagrid fs_14" fit="true" style="width: auto;">
		</table>
		<div id="tb">
			<form id="ff_sort_type_list" class="form-inline container-fluid search-form">
			
			  	<div id="searchDiv" class="row">
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="searchcontent" class="control-label"></label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="searchcontent" type="text" class="form-control" id="searchcontent" placeholder="请输入名称或key">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<input id="maintType4Search" name="maintType4Search" class="textbox-radius form-control">
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<input id=validFlag4Search name="validFlag4Search" class="textbox-radius form-control">
				  	</div>
			  	</div>
			  	
			</form>
			
			<div class="toolbar-table-btn">
				<a href="javascript:void(0);" onclick="addSortType()" class="btn btn-skin bg_f"><span class="fa fa-plus"></span>&nbsp;添加</a>
				<a href="javascript:void(0);" onclick="delSortType()" class="btn btn-skin bg_f"><span class="fa fa-trash-o"></span>&nbsp;批量删除</a>
			</div>
			
			<!-- <div class="col-md-3 col-xs-3 text-right">
			<a href="#" onclick="addSortType()" class="btn btn-default"><span class="fa fa-plus" style=""></span>&nbsp;添加</a>
			</div> -->
		</div>
	  <!-- </div> -->
	
	<script type="text/javascript">
		
		var queryParam = {};
		var basePath = '${config.path()}';
		var basePage = '${config.page()}';
	
		$(function(){
			toggleSearchStat('1');
			$("#sortTypeDg").datagrid({
				pagination : true,
				method : 'get',
				url : basePath+'commons/sort/type/page',
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
						title : '分类类别名称',
						//fixed : true,
						width : '20%',
						formatter : function(value,row,index){
							return '<a href="javaScript:showSortTypeDetail(\''+row.id+'\')">'+value+'</a>';
						}
				    },{
				    	field : 'typeKey',
						title : '分类类别key',
						//fixed : true,
						width : '10%'
				    },{
				    	field : 'serialNumber',
						title : '序号',
						//fixed : true,
						width : '10%'
				    },{
				    	field : 'validDate',
						title : '字典生效日期',
						//fixed : true,
						width : '10%'
				    },{
				    	field : 'maintOrg',
						title : '维护单位',
						//fixed : true,
						width : '10%'
				    },{
				    	field : 'maintType',
						title : '维护类型',
						//fixed : true,
						width : '10%'
				    },{
				    	field : 'typeVersion',
						title : '版本',
						//fixed : true,
						width : '10%'
				    },{
				    	field : 'validFlag',
						title : '有效标记',
						//fixed : true,
						width : '10%'
				    },{
				    	field : 'option',
						title : '操作',
						formatter : function(value,row,index){
							return '<i onclick="editSortType(\''+row.id+'\')" class="fa fa-edit option-icon" title="编辑"></i>'
								  +'<i id="row_del_'+row.id+'" class="fa fa-trash-o del-icon"></i>'
								  +'<i onclick="copySortType(\''+row.id+'\')" class="fa fa-copy option-icon" title="复制新建"></i>';
						},
						//fixed : true,
						width : '10%'
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
			
			//浏览器窗口大小变化后，表格宽度自适应
		    $(window).resize(function(a,b){
		    	try{
			    	//销毁弹出层
					/* $(".popover[id^=popover]").popover('destroy');
			    	
					$('#sortTypeDg').datagrid('getRows').each(function(i, row){
						initDelPopOver(row.id);debugger;
					}); */
				}catch(err){
				}
		    	
		    	//表格宽度自适应
		        //fitCoulms();
		    });
			
			//为输入框绑定回车事件
			$(".search-form input").keypress(function(e){
		        var eCode = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
		        if (eCode == 13){
		        	searchSortTypeList();
		        	return false;
		        }
			});
			
			$('#maintType4Search').fwebformcontrol({
				label: '维护类型:',
				labelWidth: 80,
			    valueField: 'value',
			    textField: 'label',
			    prompt: '请输入维护类型',
			    controlType: 'combobox',
			    data: [{
				      label: '',
				      value: ''
				    },{
				      label: '不可维护',
				      value: '01'
				    },{
				      label: '可增加',
				      value: '02'
				    },{
				      label: '可增删改',
				      value: '03'
				    }]
			});
			$('#validFlag4Search').fwebformcontrol({
				label: '有效标识:',
				labelWidth: 80,
			    valueField: 'value',
			    textField: 'label',
			    prompt: '请输入维护类型',
			    controlType: 'combobox',
			    data: [{
				      label: '',
				      value: ''
				    },{
				      label: '有效',
				      value: '1'
				    },{
				      label: '失效',
				      value: '0'
				    }]
			});
			
		});

		//表格宽度自适应，这里的#dg是datagrid表格生成的div标签
		function fitCoulms(){
		    //$('#sortTypeDg').datagrid('resize');
		    $('#sortTypeDg').datagrid({
		        fitColumns:true,
		        fit:true
		    });
		}
		
		/* $('#sortTypeDg').datagrid('getPanel')
			.removeClass('lines-both lines-no lines-right lines-bottom')
			.addClass('lines-no'); */
		
		function addSortType(){
			//添加编辑页
			crumbs.addCrumbs({name:'添加',url:'type/sortTypeEdit'});
		}
		
		function editSortType(id_){
			//var row = $('#sortTypeDg').datagrid('getSelected');
			if (id_){
				//添加编辑页
				crumbs.addCrumbs({
					name:'编辑',
					url:'type/sortTypeEdit?id='+id_
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
		
		function copySortType(id_){
			if (id_){
				//添加编辑页
				crumbs.addCrumbs({
					name:'复制新建',
					url:'type/sortTypeEdit?id='+id_+'&copy=true'
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
		
		function showSortTypeDetail(id_){
			//添加详情页
			crumbs.addCrumbs({name:'详情',url:'type/sortTypeDetail?id='+id_});
		}
		
		//初始化删除弹出层
		function initDelPopOver(id_){
			$('#row_del_'+id_).popover({   
				trigger:'manual',//manual 触发方式  
				placement : 'top',    
				title:'<div style="text-align:left; color:gray; font-size:12px;">你确认要删除该用户吗？</div>',  
				html: 'true', 
				container: 'body',
				//这里可以直接写字符串，也可以 是一个函数，该函数返回一个字符串；
				content : '<a style="margin-right: 8px;" href="javascript:void(0);" onclick="cancelDel(\''+id_+'\')" class="btn btn-default">取消</a>'
						 +'<a href="javascript:void(0);" onclick="delSortType(\''+id_+'\')" class="btn btn-default">确认</a>',  
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
		
		//删除用户
		function delSortType(id_){
			var rows = $('#sortTypeDg').datagrid('getChecked');

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
					url : basePath+'commons/sort/type/batch?ids='+id_,
					type : 'delete',
					contentType : 'application/json;charset=UTF-8',
					success : function(data) {
						$('#sortTypeDg').datagrid('reload');
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
			$('#sortTypeDg').datagrid('reload');
		}
		
		//根据查询条件分页获取用户列表
		function searchSortTypeList(isReset_){
			if(isReset_){
				$('#ff_sort_type_list').form('clear');
				queryParam = {};
			}else
				queryParam = {
						content : $("#searchcontent").val(),
						maintType : $("#maintType4Search").val(),
						validFlag : $("#validFlag4Search").val()
				};
			$('#sortTypeDg').datagrid('load',queryParam);
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
		  		   +	'<a onclick="searchSortTypeList()" class="btn btn-primary">查&nbsp;询</a>'
			  	   +	'<a onclick="searchSortTypeList(true)" class="btn btn-default search-button-reset">重&nbsp;置</a>'
			  	   +	(searchToggleButtonShow?'<a href="javascript:void(0);" onclick="toggleSearchStat(\'0\')" class="search-button-more">更多&nbsp;<i class="fa fa-angle-down"></i></a>':'')
			  	   +'</div>'
		  		);
		  	}else{
		  		//展开
		  		$("#searchDiv").children().show();
		  		$("#searchDiv").parent().append(
		  			'<div id="searchButtonDiv" class="row">'
		  		   +'<div class="search-button search-button-expend">'
		  		   +	'<a onclick="searchSortTypeList()" class="btn btn-primary">查&nbsp;询</a>'
			  	   +	'<a onclick="searchSortTypeList(true)" class="btn btn-default search-button-reset">重&nbsp;置</a>'
			  	   +	(searchToggleButtonShow?'<a href="javascript:void(0);" onclick="toggleSearchStat(\'1\')" class="search-button-more"><i class="fa fa-angle-up"></i>更多&nbsp;</a>':'')
			  	   +'</div>'
			  	   +'</div>'
		  		);
		  	}
		  	
		  	fitCoulms();
		}
	</script>
