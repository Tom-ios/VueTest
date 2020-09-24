var crumbs = {
	crumbsArr:[],
	basePath:"",
	setBasePath:function(basePath_){
		this.basePath = basePath_||"";
	},
	generateCrumbs:function (id){
		$("#contentHeader_"+id).empty();
		var len = crumbs.crumbsArr.length;
		//alert('00x0:'+len)
		
		if(len == 0)
			return;
		
		if(len == 1){
			//$("#contentHeader").hide();
			//$("#contentHeader").append('<h3 class="box-title">'+crumbs.crumbsArr[len-1].name+'</h3>')
			return;
		}
		
		/**
		 * <div class="box box-solid">
	            <div class="box-header with-border fs_14" id="contentHeader">
					<!-- 标题 -->
	        	</div>
        		<!-- /.box-header -->
	        	<div class="box-body" id="center_contentaaa">
	          		<!-- 主体内容 -->
	        	</div>
        		<!-- /.box-body -->
      		</div>
		 */
		
		//$("#contentHeader").show();
		$("#contentHeader_"+id)
		//.append(contentHeaderHtml);
		.append('<a href="javaScript:crumbs.goback()" class="fa fa-chevron-circle-left" style="padding: 3px 3px;"></a><h3 class="box-title">'+crumbs.crumbsArr[len-1].name+'</h3>')
		
	},
	addCrumbs:function (menuObj){
		 var guid = guidEqpt();
		 menuObj.id = guid;
		 
		 //判断是否为一级页面
		 var len = crumbs.crumbsArr.length;
		 
	     //$('#center_content').append('<div id="cc_'+guid+'" style="width: 100%;height:100%;"></div>')
		 
	     $('#center_content').append('<div class="" style="height: 100%; width: 100%;" id="cc_'+guid+'"></div>')
	     
	     
	     if(len == 0){
	    	 $('#cc_'+guid).load(this.basePath+menuObj.url);
	     }else{
	    	 
	    	 //创建二级页面结构
	    	 var contentHeaderHtml = '<div class="box box-solid">'
	    		 +'<div class="box-header with-border fs_14" id="contentHeader_'+guid+'">'
	    		 +'</div>'
	    		 +'<div class="box-body" id="center_content2_'+guid+'">'
	    		 +'</div>'
	    		 +'</div>';
	    	 $('#cc_'+guid).append(contentHeaderHtml);
	    	 $('#center_content2_'+guid).load(this.basePath+menuObj.url);
	    	 
	     }
	    	 
	     
	     
	     
	     /*$('#cc_'+guid).panel({
	    	    href:this.basePath+menuObj.url,
	    	    style:"height:100%;",
	    	    height:380,
	    	    border:false,
	    	    //fit:true,
	    	    //doSize:true,
	    	    onLoad:function(){
	    		//alert('loaded successfully');
	    	    }
	    	});*/
	  
	     this.crumbsArr.push(menuObj);
	     this.showCrumbs(guid);
	},
	showCrumbs:function (id){
		//$('#cc_'+id).parent().show();
		$("#center_content>div").hide();
		$('#cc_'+id).show();
		 
		if(this.crumbsArr.length>1){
			$(crumbs.crumbsArr).each(function(i){
				var crumbsItem = crumbs.crumbsArr.pop();
				if(crumbsItem.id == id){
					crumbs.crumbsArr.push(crumbsItem);
					crumbs.generateCrumbs(id);
					return;
				}else{
					$('#cc_'+crumbsItem.id).remove();
				}
		 	});
		}else{
			crumbs.generateCrumbs(id);
		}
		
	},
	cancelCrumbs:function(){
		try{
			var tabObj = crumbs.crumbsArr[crumbs.crumbsArr.length-2];
			crumbs.showCrumbs(tabObj.id);
		}catch(e){}
	},
	 goback:function(par){
		 try{
				var tabObj = crumbs.crumbsArr[crumbs.crumbsArr.length-2];
				crumbs.showCrumbs(tabObj.id);
				if(tabObj.callback){
					if(tabObj.callback != null && tabObj.callback != '' ){
						tabObj.callback(par);
					}
				}
			}catch(e){}
	 },
	 refreshCrumbs:function (menuObj){
		 var guid = menuObj.id;
	     $('#cc_'+guid).panel({
	    	    href:this.basePath+menuObj.url,
	    	    style:"height:100%",
	    	    border:false,
	    	    onLoad:function(){
	    		//alert('loaded successfully');
	    	    }
	    	});
	  
	     this.generateCrumbs(guid);
	 }
}
	
function guidEqpt(){
	   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
}
function S4(){
	   return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
}