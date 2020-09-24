<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<link rel="shortcut icon" href="${config.ui() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />
	<link href="${config.path() }assets/css/ztree/metroStyle/metroStyle.css" rel="stylesheet">
	<link href="${config.base() }fweb-framework-ui/assets/fonts/css/font-awesome.min.css" rel="stylesheet">
	
	<script src="${config.path() }assets/js/ztree/jquery.ztree.all.js"></script>
	<script type="text/javascript" src="${config.path()}assets/js/easyui/validate_extend.js"></script>
	<script type="text/javascript" src="${config.path()}assets/js/easyui/expand/fweb_form_control.js"></script>

	<style>
		.panel{
			border: unset;
		}
		#sortTreeDiv{
	        overflow:auto;
   		}
		#sortTreeDiv::-webkit-scrollbar{
		    width:5px;
		    height:5px;
		    background-color: #00A65A;
		}
		#sortTreeDiv::-webkit-scrollbar-track{
		    background: #bbb;
		    border-radius:2px;
		}
		#sortTreeDiv::-webkit-scrollbar-thumb{
		    background: #00A65A;
		    border-radius:2px;
		}
		#sortTreeDiv::-webkit-scrollbar-thumb:hover{
		    background: #00A65A;
		}
		#sortTreeDiv::-webkit-scrollbar-corner{
		    background: #00A65A;
		}
	</style>


	<div style="width: 20%;float: left; padding-left: 3px; padding-top: 3px;">
		<div>
			<a href="javascript:void(0);" onclick="addSortItem()" class="btn btn-skin bg_f" title="添加"><span class="fa fa-plus"></span></a>
			<a href="javascript:void(0);" onclick="expandSortTree()" class="btn btn-skin bg_f" title="展开"><span class="fa fa-chevron-circle-down"></span></a>
			<a href="javascript:void(0);" onclick="collapseSortTree()" class="btn btn-skin bg_f" title="收起"><span class="fa fa-angle-double-up"></span></a>
			<a href="javascript:void(0);" onclick="refreshSortTree()" class="btn btn-skin bg_f" title="刷新"><span class="fa fa-refresh"></span></a>
		</div>
		<div>
			<input id="sortTypeList" name="sortTypeList" class="textbox-radius">
		</div>
		<div id="sortTreeDiv">
			<ul id="sortItemTree" class="ztree"></ul>
		</div>
	</div>
	<div id="dictList" style="width: 80% !important;height: 100%;">
		<!-- 数据字典项列表 -->
	</div>


<script>
	
	var basePath = '${config.path()}';
	var basePage = '${config.page()}';
	var firstLoad = true;

	var setting = {
        view: {
            addHoverDom: addHoverDom,
            removeHoverDom: removeHoverDom,
            selectedMulti: false
        },
        check: {
            enable: true
        },
        data: {
            simpleData: {
                enable: true,
                idKey: 'id',
				pIdKey: 'parentId'
            }
        },
        edit: {
        	drag: {
				autoExpandTrigger: true,
				prev: dropPrev,
				inner: dropInner,
				next: dropNext
			},
            enable: true,
            removeTitle: '删除分类',
            renameTitle: '编辑分类'
        },
        callback: {
			beforeRemove: beforeRemove,
			//beforeRename: beforeRename,
			onRename: onRename,
			beforeDrag: beforeDrag,
			beforeDrop: beforeDrop,
			beforeDragOpen: beforeDragOpen,
			onDrag: onDrag,
			onDrop: onDrop,
			onExpand: onExpand,
			onClick: searchDictByItemId
		}
    };

    var zNodes =[];

    $(document).ready(function(){
    	
    	$.ajax({
    		 url: basePath+'commons/sort/type/list',
			type : 'get',
			contentType : 'application/json;charset=UTF-8',
			success : function(data) {
				var typeList = data?data:[];
				
				//添加其他分类类别
				var otherData = {
					id: "",
					maintOrg: "",
					maintType: "",
					name: "其他",
					serialNumber: 10000,
					typeKey: "other",
					typeVersion: "",
					validFlag: "1"			
				};
				typeList.push(otherData);
				
				$('#sortTypeList').fwebformcontrol({
				    valueField: 'typeKey',
				    textField: 'name',
				    data: typeList,
				    prompt: '请输入分类类别',
				    controlType: 'combobox',
				    onLoadSuccess: function () { //加载完成后,设置选中第一项  
                        var val = $(this).combobox('getData');
                        if (val.length > 0) {  
                            $(this).combobox('select', val[0].typeKey);  
                        }
                    },
                    onChange: function(newValue, oldValue){
                    	if(newValue && !firstLoad){
	                    	initSortTree(newValue);
                    	}
                    	firstLoad = false;
                    }
				});
		        initSortTree(typeList[0].typeKey);
			},
			error : function(xhr) {
				$.gritter.add({  
				    text: '获取分类类别失败',  
				    sticky: false,  
				    time: 3000,  
				    speed:500,  
				    class_name: 'gritter-error'  
				});
			}
		});
    	
    	$("#dictList").load(basePage+'dict/sortDictList');
    	
    });

    function addHoverDom(treeId, treeNode) {
        var sObj = $("#" + treeNode.tId + "_span");
        if (treeNode.editNameFlag || $("#addBtn_"+treeNode.tId).length>0) return;
        var addStr = "<span class='button add' id='addBtn_" + treeNode.tId
            + "' title='添加分类' onfocus='this.blur();'></span>";
        sObj.after(addStr);
        var btn = $("#addBtn_"+treeNode.tId);
        if (btn) btn.bind("click", function(){
            var zTree = $.fn.zTree.getZTreeObj("sortItemTree");
            editSortItem(treeNode.id,'add');
            return false;
        });
    };
    function removeHoverDom(treeId, treeNode) {
        $("#addBtn_"+treeNode.tId).unbind().remove();
    };
    
    function initSortTree(typeKey){
    	if(typeKey){
    		$.ajax({
       			url: basePath+'commons/sort/item/list?typeKey='+typeKey,
   				type : 'get',
	   			contentType : 'application/json;charset=UTF-8',
	   			success : function(data) {
	   				$.fn.zTree.init($("#sortItemTree"), setting, data);
	   			},
	   			error : function(xhr) {
	   				$.gritter.add({  
	   				    text: '获取分类类别失败',  
	   				    sticky: false,  
	   				    time: 3000,  
	   				    speed:500,  
	   				    class_name: 'gritter-error'  
	   				});
	   			}
    		});
    	}
    }
    
    function addSortItem() {
		var zTree = $.fn.zTree.getZTreeObj("sortItemTree"),
		nodes = zTree.getSelectedNodes(),
		treeNode = nodes[0];
		if (treeNode) {
			editSortItem(treeNode.id,'add');
		} else {
			editSortItem(null,'add');
		}
	};
    
    //添加、编辑分类
    function editSortItem(itemId,editType){
    	var typeKey = $('#sortTypeList').fwebformcontrol('getValue');
    	itemId = itemId||'0';
    	if(editType == 'edit'){
	    	crumbs.addCrumbs({
				name:'编辑分类',
				url:'item/sortItemEdit?id='+itemId+'&typeKey='+typeKey+'&editType='+editType
			});
    	}else if(editType == 'add'){
	    	crumbs.addCrumbs({
				name:'添加分类',
				url:'item/sortItemEdit?parentId='+itemId+'&typeKey='+typeKey+'&editType='+editType
			});
    	}
    }
    
    function beforeRename(treeId, treeNode){
    	/* console.log("treeId=edit="+treeId,treeNode);
    	editSortItem(treeNode.id, 'edit'); */
    }
    function onRename(event,treeId,treeNode,isCancel){
    	if(!isCancel){
    		editSortItem(treeNode.id, 'edit');
    	}
    }
    function beforeRemove(treeId, treeNode){
    	$.messager.confirm('确认',"确认删除这条记录吗?", function(flag){if(flag){
    		var typeKey = $('#sortTypeList').fwebformcontrol('getValue');
			$.ajax({
				url : basePath + "commons/sort/item/batch?ids=" + treeNode.id+'&typeKey='+typeKey,
				type : 'delete',
				success : function(data) {
					refreshSortTree();
				},
				error : function(jqXHR, textStatus, errorThrown) {
					$.alert("error","删除失败！");
				}
			});
			}
		});
    	return false;
    }
    
    //展开分类树
    function expandSortTree(){
    	var zTree = $.fn.zTree.getZTreeObj("sortItemTree");
    	zTree.expandAll(true);
    }
    //收起分类树
    function collapseSortTree(){
    	var zTree = $.fn.zTree.getZTreeObj("sortItemTree");
    	zTree.expandAll(false);
    }
    //刷新分类树
    function refreshSortTree(){
    	var $typeKey = $('#sortTypeList').fwebformcontrol('getValue');
    	initSortTree($typeKey);
    }
    
    function dropPrev(treeId, nodes, targetNode) {
    	console.log("dropPrev",treeId,nodes,targetNode);
		var pNode = targetNode.getParentNode();
		if (pNode && pNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				var curPNode = curDragNodes[i].getParentNode();
				if (curPNode && curPNode !== targetNode.getParentNode() && curPNode.childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}
	function dropInner(treeId, nodes, targetNode) {
		console.log("dropInner",treeId,nodes,targetNode);
		if (targetNode && targetNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				if (!targetNode && curDragNodes[i].dropRoot === false) {
					return false;
				} else if (curDragNodes[i].parentTId && curDragNodes[i].getParentNode() !== targetNode && curDragNodes[i].getParentNode().childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}
	function dropNext(treeId, nodes, targetNode) {
		console.log("dropNext",treeId,nodes,targetNode);
		var pNode = targetNode.getParentNode();
		if (pNode && pNode.dropInner === false) {
			return false;
		} else {
			for (var i=0,l=curDragNodes.length; i<l; i++) {
				var curPNode = curDragNodes[i].getParentNode();
				if (curPNode && curPNode !== targetNode.getParentNode() && curPNode.childOuter === false) {
					return false;
				}
			}
		}
		return true;
	}

	var log, className = "dark", curDragNodes, autoExpandNode;
	function beforeDrag(treeId, treeNodes) {
		console.log("beforeDrag",treeId,treeNodes);
		className = (className === "dark" ? "":"dark");
		for (var i=0,l=treeNodes.length; i<l; i++) {
			if (treeNodes[i].drag === false) {
				curDragNodes = null;
				return false;
			} else if (treeNodes[i].parentTId && treeNodes[i].getParentNode().childDrag === false) {
				curDragNodes = null;
				return false;
			}
		}
		curDragNodes = treeNodes;
		return true;
	}
	function beforeDragOpen(treeId, treeNode) {
		console.log("beforeDragOpen",treeId,treeNode);
		autoExpandNode = treeNode;
		return true;
	}
	function beforeDrop(treeId, treeNodes, targetNode, moveType, isCopy) {
		console.log("beforeDrop",treeId,treeNodes,targetNode,moveType,isCopy);
		className = (className === "dark" ? "":"dark");
		return true;
	}
	function onDrag(event, treeId, treeNodes) {
		console.log("onDrag",treeId,treeNodes);
		console.log("onDrag",treeId,treeNodes,targetNode,moveType,isCopy);
		className = (className === "dark" ? "":"dark");
	}
	function onDrop(event, treeId, treeNodes, targetNode, moveType, isCopy) {
		className = (className === "dark" ? "":"dark");
		dragSortItem(targetNode.id, treeNodes[0].id, moveType);
	}
	function onExpand(event, treeId, treeNode) {
		console.log("onExpand",treeId,treeNode);
		if (treeNode === autoExpandNode) {
			className = (className === "dark" ? "":"dark");
		}
	}
	
	//拖拽分类
	function dragSortItem(targetId, sourceRootId, moveType){
		var typeKey = $('#sortTypeList').fwebformcontrol('getValue');
		$.ajax({
			url : basePath + "commons/sort/item/drag?typeKey="+typeKey
					+"&targetId="+targetId+"&sourceRootId="+sourceRootId
					+"&moveType="+moveType,
			type : 'get',
			success : function(data) {
				refreshSortTree();
			},
			error : function(jqXHR, textStatus, errorThrown) {
				$.alert("error","删除失败！");
			}
		});
	}
	
	//根据选择的分类获取数据字典列表
	function searchDictByItemId(e, treeId, treeNode, clickFlag){
		searchSortDictList(true, treeNode.id);
	}
	
</script>