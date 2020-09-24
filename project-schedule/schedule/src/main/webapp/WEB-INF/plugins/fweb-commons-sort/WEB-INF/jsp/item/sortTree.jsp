<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

	<link href="${config.ui() }fweb-framework-ui/style/css/bootstrap.min.css" rel="stylesheet">
	<link href="${config.base() }fweb-commons-sort/assets/css/ztree/metroStyle/metroStyle.css" rel="stylesheet">
	<link href="${config.ui() }fweb-framework-ui/assets/fonts/css/font-awesome.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/css/fweb.css">
	
	<script src="${config.ui() }fweb-framework-ui/js/bootstrap/bootstrap.min.js"></script>
	<script src="${config.ui() }fweb-framework-ui/js/bootstrap/bootstrap-modal.js"></script>
	<script src="${config.base() }fweb-commons-sort/assets/js/ztree/jquery.ztree.all.js"></script>
	<script type="text/javascript" src="${config.path() }assets/js/easyui/validate_extend.js"></script>
	
	<style>
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

	<div>			
		<a id="addSortItemBtn" disabled href="javascript:void(0);" onclick="addSortItem()" class="btn btn-skin bg_f" title="添加"><span class="fa fa-plus"></span></a>
		<a href="javascript:void(0);" onclick="expandSortTree()" class="btn btn-skin bg_f" title="展开"><span class="fa fa-chevron-circle-down"></span></a>
		<a href="javascript:void(0);" onclick="collapseSortTree()" class="btn btn-skin bg_f" title="收起"><span class="fa fa-angle-double-up"></span></a>
		<a href="javascript:void(0);" onclick="refreshSortTree()" class="btn btn-skin bg_f" title="刷新"><span class="fa fa-refresh"></span></a>
	</div>
	<div id="sortTreeDiv">
		<ul id="sortItemTree" class="ztree"></ul>
	</div>
	
	<div class="modal fade" id="addSortItemModal" tabindex="-1" role="dialog" aria-labelledby="addModalLabelType" aria-hidden="true">
	    <div class="modal-dialog">
	        <div class="modal-content">
	        	<div class="modal-header">
	        		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
	       			<h4 class="modal-title" id="addModalLabelType">添加分类</h4>
	        	</div>
				<div class="modal-body">
					<div class="form-horizontal row">
			            <div class="form-group col-xs-12">
			            	<input type="hidden" id="parentId4Name" name="parentId4Name">
			            	<input type="hidden" id="typeKey4Name" name="typeKey4Name">
							<label for="typeName" class="col-sm-3 control-label">分类名称:</label>
						    <div class="col-sm-9">
						    	<input type="text" class="form-control" name="sortItemName" id="sortItemName" placeholder="请输入分类名称:">
						    </div>
					  	</div>
					</div>
					<div class="form-group row"><br>
			        	<div style="text-align: center;">
				            <button class="btn btn-primary btn-large" onclick="saveSortItem()">提交</su-button>
				            <button class="btn btn-defalut btn-large" onclick="cancelModal()">取消</su-button>
			          	</div>
		        	</div>
				</div>
			</div>
	    </div>
	</div>

<script type="text/javascript">

	var $itemId = null;
	var $typeKey = '${param.typeKey }';
	var isRootShow = '${param.isRootShow }';
	var idField = '${param.idField }';
	var firstLoad = true;
	var basePath = '${config.path()}';
	var basePage = '${config.page()}';
	var base = '${config.base()}';

	$(function(){
		initSortTree($typeKey);
	});

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
				pIdKey: 'parentId',
				rootPId: null
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
            showRemoveBtn: showRemoveBtn,
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

    function initSortTree(typeKey){
    	if(typeKey){
    		$.ajax({
       			url: base+'fweb-commons-sort/commons/sort/item/list?typeKey=${param.typeKey}',
   				type : 'get',
	   			contentType : 'application/json;charset=UTF-8',
	   			success : function(data) {
   					if(isRootShow && isRootShow=='true'){
   						var rootObj = {
   							id : '0',
   							parentId : null,
   							name : '全部分类'
   						};
   						data.push(rootObj);
		   				$.fn.zTree.init($("#sortItemTree"), setting, data);
		   				expandSortTree();
   					}else{
		   				$.fn.zTree.init($("#sortItemTree"), setting, data);
		   				expandSortTree();
   					}
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
		}
	};
    
    function beforeRename(treeId, treeNode){
    	//console.log("treeId=edit="+treeId,treeNode);
    	//editSortItem(treeNode.id, 'edit');
    }
    function onRename(event,treeId,treeNode,isCancel){
    	if(!isCancel && treeNode.id!='0'){
    		$.ajax({
				url : basePath+'commons/sort/item/name',
				type : 'put',
				data : JSON.stringify({id:treeNode.id,name:treeNode.name,typeKey:$typeKey}),
				contentType : 'application/json;charset=UTF-8',
				success : function(data) {
					$.gritter.add({  
					    text: '保存成功',  
					    sticky: false,  
					    time: 3000,
					    speed:500,  
					    class_name: 'gritter-success'  
					});
					//crumbs.goback();
					refreshSortTree();
				},
				error : function(xhr) {
					$.gritter.add({  
					    text: '保存失败',  
					    sticky: false,  
					    time: 3000,
					    speed:500,  
					    class_name: 'gritter-error'  
					});
				}
			});
    	}
    }
    function beforeRemove(treeId, treeNode){
    	$.messager.confirm('确认',"确认删除这条记录吗?", function(flag){if(flag){
				$.ajax({
					url : base + "fweb-commons-sort/commons/sort/item/batch?ids=" + treeNode.id+'&typeKey='+$typeKey,
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
    	//禁用添加功能
    	$('#addSortItemBtn').attr('disabled',"true");
    	initSortTree($typeKey);
    	$itemId = null;
    	getSortItemId($itemId);
    }
    
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
		$.ajax({
			url : base + "fweb-commons-sort/commons/sort/item/drag?typeKey="+$typeKey
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
	
	//是否显示删除按钮
	function showRemoveBtn(treeId,treeNode){
		if(treeNode.id && treeNode.id!='0'){
			return true;
		}else{
			return false;
		}
	}
    
  	//添加、编辑分类
    function editSortItem(itemId,editType){
    	var typeKey = $typeKey;
    	itemId = itemId||'0';
    	$("#parentId4Name").val(itemId);
    	$("#typeKey4Name").val($typeKey);
    	$("#addSortItemModal").modal('show');
    }
	
	//保存模板信息
	function saveSortItem(){
		var data = {};
		data.parentId = $("#parentId4Name").val();
		data.typeKey = $("#typeKey4Name").val();
		data.name = $("#sortItemName").val();
			
		$.ajax({
			cache: false,
			type : 'post',
			url : basePath+'commons/sort/item',
			data : JSON.stringify(data),
			contentType : 'application/json;charset=UTF-8',
			success : function() {
				refreshSortTree();
				cancelModal();
			},
			error : function() {
				console.log("添加失败");
			}
		});
	}
	
	//取消保存
	function cancelModal(){
		$("#addSortItemModal").modal('hide');
	}
	
	//根据选择的分类获取数据字典列表
	function searchDictByItemId(e, treeId, treeNode, clickFlag){
		$('#addSortItemBtn').removeAttr('disabled');
		if(idField != 'itemCode'){
			if(treeNode.id && treeNode.id!='0'){
				$itemId = treeNode.id;
			}else{
				$itemId = null;
			}
		}else{
			if(treeNode.itemCode && treeNode.itemCode!='0'){
				$itemId = treeNode.itemCode;
			}else{
				$itemId = null;
			}
		}
		getSortItemId($itemId);
	}

</script>
