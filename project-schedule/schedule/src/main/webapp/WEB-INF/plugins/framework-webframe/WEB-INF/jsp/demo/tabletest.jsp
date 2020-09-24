<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

		<table id="dg" class="easyui-datagrid fs_14" fit="true" style="width: auto;">
		</table>
		<div id="tb">
			<form id="ff_user_list" class="form-inline container-fluid search-form">
			
			  	<div id="searchDiv" class="row form-group">
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
				  	<div class="form-input col-md-3 col-sm-4">
				  		<div class="form-input-label">
					    	<label for="userName" class="control-label">用户名</label>
				  		</div>
				  		<div class="form-input-input">
					    	<input name="userName4list" type="text" class="form-control" id="userName4list" placeholder="用户名">
				  		</div>
				  	</div>
			  	</div>
			  	
			</form>
			
			<div class="toolbar-table-btn">
				<a href="javascript:void(0);" onclick="addUserInfo()" class="btn btn-skin bg_f"><span class="fa fa-plus"></span>&nbsp;添加</a>
				<a href="javascript:void(0);" onclick="delUserInfo()" class="btn btn-skin bg_f"><span class="fa fa-trash-o"></span>&nbsp;批量删除</a>
			</div>
			
			<!-- <div class="col-md-3 col-xs-3 text-right">
			<a href="#" onclick="addUserInfo()" class="btn btn-default"><span class="fa fa-plus" style=""></span>&nbsp;添加</a>
			</div> -->
		</div>
	  <!-- </div> -->
	
	<script type="text/javascript">
		
		var queryParam = {};
	
		$(function(){
			toggleSearchStat('1');
			$("#dg").datagrid({
				pagination : true,
				method : 'get',
				url : '${Config.baseURL}userinfo/page',
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
						field : 'userName',
						title : '用户名',
						//fixed : true,
						width : '30%',
						formatter : function(value,row,index){
							return '<a href="javaScript:showUserDetail(\''+row.id+'\')">'+value+'</a>';
						}
				    },{
				    	field : 'mobile',
						title : '手机号',
						//fixed : true,
						width : '30%'
				    },{
				    	field : 'userType',
						title : '用户类型',
						formatter : function(value,row,index){
							if(value == '0')
								return '普通用户';
							if(value == '1')
								return '普通会员';
							if(value == '2')
								return '高级会员';
							return "";
						},
						//fixed : true,
						width : '28%'
				    },{
				    	field : 'option',
						title : '操作',
						formatter : function(value,row,index){
							return '<i onclick="editUserInfo(\''+row.id+'\')" class="fa fa-edit option-icon" title="编辑"></i>'
								  +'<i id="row_del_'+row.id+'" class="fa fa-trash-o option-icon"></i>';
						},
						//fixed : true,
						width : '12%'
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
			    	
					$('#dg').datagrid('getRows').each(function(i, row){
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
		        	searchUserList();
		        	return false;
		        }
			});
			
			FSTool.setFontSize4Dom(FSTool.getLocalStorage('font-size'),
					document.getElementsByTagName('body')[0])
			
		})

		//表格宽度自适应，这里的#dg是datagrid表格生成的div标签
		function fitCoulms(){
		    //$('#dg').datagrid('resize');
		    $('#dg').datagrid({
		        fitColumns:true,
		        fit:true
		    });
		}
		
		/* $('#dg').datagrid('getPanel')
			.removeClass('lines-both lines-no lines-right lines-bottom')
			.addClass('lines-no'); */
		
		function addUserInfo(){
			//添加编辑页
			crumbs.addCrumbs({name:'添加',url:'view/demoframe/pages/demo/user_edit_control'});
		}
		
		function editUserInfo(id_){
			//var row = $('#dg').datagrid('getSelected');
			if (id_){
				//添加编辑页
				crumbs.addCrumbs({
					name:'编辑',
					url:'view/demoframe/pages/demo/user_edit_control?id='+id_
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
		
		function showUserDetail(id_){
			//添加详情页
			crumbs.addCrumbs({name:'详情',url:'view/demoframe/pages/user_detail?id='+id_});
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
						 +'<a href="javascript:void(0);" onclick="delUserInfo(\''+id_+'\')" class="btn btn-default">确认</a>',  
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
		function delUserInfo(id_){
			var rows = $('#dg').datagrid('getChecked');

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
					url : '${Config.basePath}userinfo/'+id_,
					type : 'delete',
					contentType : 'application/json;charset=UTF-8',
					success : function(data) {
						$('#dg').datagrid('reload');
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
			$('#dg').datagrid('reload');
		}
		
		//根据查询条件分页获取用户列表
		function searchUserList(isReset_){
			if(isReset_){
				$('#ff_user_list').form('clear');
				queryParam = {};
			}else
				queryParam = {
						userName : $("#userName4list").val()
				};
			$('#dg').datagrid('load',queryParam);
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
		  		   +	'<a onclick="searchUserList()" class="btn btn-primary">查&nbsp;询</a>'
			  	   +	'<a onclick="searchUserList(true)" class="btn btn-default search-button-reset">重&nbsp;置</a>'
			  	   +	(searchToggleButtonShow?'<a href="javascript:void(0);" onclick="toggleSearchStat(\'0\')" class="search-button-more">更多&nbsp;<i class="fa fa-angle-down"></i></a>':'')
			  	   +'</div>'
		  		);
		  	}else{
		  		//展开
		  		$("#searchDiv").children().show();
		  		$("#searchDiv").parent().append(
		  			'<div id="searchButtonDiv" class="row">'
		  		   +'<div class="search-button search-button-expend">'
		  		   +	'<a onclick="searchUserList()" class="btn btn-primary">查&nbsp;询</a>'
			  	   +	'<a onclick="searchUserList(true)" class="btn btn-default search-button-reset">重&nbsp;置</a>'
			  	   +	(searchToggleButtonShow?'<a href="javascript:void(0);" onclick="toggleSearchStat(\'1\')" class="search-button-more"><i class="fa fa-angle-up"></i>更多&nbsp;</a>':'')
			  	   +'</div>'
			  	   +'</div>'
		  		);
		  	}
		  	
		  	fitCoulms();
		}
	</script>
