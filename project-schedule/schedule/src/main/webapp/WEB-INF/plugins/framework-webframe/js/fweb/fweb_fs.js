var FSTool = {
	
	/*--------------------------------------------
	  描述 : 	设置节点的字体尺寸
	  参数 : 	size      	增加的字体大小
		 	dom_ 		文档
	--------------------------------------------*/
	setFontSize4Dom : function(size,dom_){
		
		if(!size || parseInt(size)==NaN || parseInt(size)==0 )
			return;
		
		for(var i=0;i<dom_.childNodes.length;i++){
			var that=dom_.childNodes[i];  
			if(that.nodeType==1){         
				var tt = window.getComputedStyle(that).fontSize;
				this.setFontSize4Dom(size,that);
				if(tt && tt.length>0){
					var newFontSize = parseFloat(tt.substring(0,tt.length-2))+parseInt(size)+'px';
					$(that).css('font-size',newFontSize);
					//console.log(newFontSize);
				}
					
			}  
		}
	},
		
	/*--------------------------------------------
	  描述 : 	增加字体尺寸
	  参数 : 	size      	增加的字体大小
	     	$newVal   	总共增加的字体大小
	--------------------------------------------*/
	addAllFontSize : function(size, $newVal){
		//
		if(!size || parseInt(size)==NaN || parseInt(size)==0 )
			return;
		
		//存储新的字体尺寸设置
		var fst = this.getLocalStorage('font-size')
		if (fst && parseInt(fst)){
			fst = parseInt(fst);
		}
		this.store('font-size', $newVal);
		
		//设置主控页面字体尺寸
		var body_=document.getElementsByTagName('body')[0];
		this.setFontSize4Dom(size,body_);
		
		//设置iframe页面字体尺寸
		var iframes = document.getElementsByTagName('iframe');
		//this.addFontSize(size,document);
		for(var i=0,len=iframes.length;i<len;i++){
			//this.addFontSize(size,iframes[i].contentDocument,iframes[i].id);
			this.setFontSize4Dom(size,iframes[i].contentDocument.getElementsByTagName('body')[0]);   
		}
		
	},
		
	/*--------------------------------------------
	  描述 : 增加字体尺寸
	  参数 : size      增加的字体大小
	     document_ 	文档
	     pageId_   	iframe的页面id
	--------------------------------------------*/
	addFontSize : function(size, document_, pageId_){
		//获取所有含字体类的元素
		var fsd = this.getAllFontSizeDom(document_);
		//为所有含字体类的元素增加字体尺寸
		this.addFontSize4Dom(fsd,size,document_,pageId_);
		
	},
	
	/*--------------------------------------------
	描述 : 	添加新的样式rule
	参数 :	$selector		选择器
		  	$rulesStr   	样式内容{font-size:16px !important}
		  	document_		文档
		  	pageId_			iframe的页面id
	--------------------------------------------*/
	addStylesheetRules : function($selector, $rulesStr, document_,pageId_) {
		var style = document_.getElementById(pageId_?'fontSizeStyle_'+pageId_:'fontSizeStyle_');
		if(!style){
		    style = document_.createElement('style');
		    style.id = pageId_?'fontSizeStyle_'+pageId_:'fontSizeStyle_';
		    style.type = 'text/css';
		    document_.getElementsByTagName('head')[0].appendChild(style);
		}
		/*if (!window.createPopup) {  For Safari 
			style.appendChild(document_.createTextNode(''));
	  	}*/
		var s = document_.styleSheets[document_.styleSheets.length - 1];
  
		//样式已存在，则不添加
		if(this.indexOfStyleSheetRule(s, $selector) != -1){
			return;
		}
		if (s.insertRule) {
			s.insertRule($selector + '{' + $rulesStr + '}', s.cssRules.length);
		}else { /* IE */
      		s.addRule($selector, $rulesStr, -1);
  		}
	},
	
	/*--------------------------------------------
	描述 : 	获取所有含字体类的元素
	参数 :	document_		文档
	--------------------------------------------*/
	getAllFontSizeDom : function(document_){
		var fontSizeDom = [];
		/*Array.prototype.slice.call(document_.all).forEach(function (ele) {
			if(ele.classList && ele.classList.length>0){
				var iterator = ele.classList.values();
				for(var value of iterator) {
				  if(value && value.indexOf("fs_")!=-1){
					  fontSizeDom.push(ele);
					  ele.myFontSizeClass = value;
				  }
				}
			}
		});*/
		return fontSizeDom;
	},
	
	/*--------------------------------------------
	描述 : 	增加所有含字体类的元素的尺寸
	参数 :	$fsd		含字体类的元素
			$size		增加的字体尺寸
			document_	文档
			pageId_		iframe的页面id
	--------------------------------------------*/
	addFontSize4Dom : function($fsd, $size, document_, pageId_){
		var this_ = this;
		if($fsd && $fsd.length>0)
			$fsd.forEach(function(aFsd,index){
				var mfsArr = aFsd.myFontSizeClass.split("_");
				var newFontSize = parseInt(mfsArr[1]) + parseInt($size);
				aFsd.classList.replace(aFsd.myFontSizeClass,"fs_"+newFontSize);
				
				//sheet.addRule(".fs_"+newFontSize,'font-size:'+newFontSize+'px !important',0);
				this_.addStylesheetRules('.fs_'+newFontSize,'font-size:'+newFontSize+'px !important',
						document_,
						pageId_);
			});
	},
	
	/*--------------------------------------------
	描述 : 	判断样式表中是否存在指定样式规则
	参数 :	$styleSheet		样式表
			selector		指定样式规则
	--------------------------------------------*/
	indexOfStyleSheetRule : function($styleSheet, selector){
		if($styleSheet.rules && $styleSheet.rules.length>0){
			for(var i=0;i<$styleSheet.rules.length;i++){
				if($styleSheet.rules[i].selectorText==selector){
					return 0;
				}
			}
		}
		return -1;
	},
	

  	/*--------------------------------------------
	描述 : 	设置本地存储
	参数 :	name
			value
	--------------------------------------------*/
  	store : function(name, val) {
	    if (typeof (Storage) !== "undefined") {
	    	localStorage.setItem(name, val);
	    } else {
	    	window.alert('Please use a modern browser to properly view this template!');
	    }
  	},

  	/*--------------------------------------------
	描述 : 	根据name从本地存储中获取数据
	参数 :	name
	返回值 :	name对应本地存储中的数据
	--------------------------------------------*/
  	getLocalStorage : function(name) {
	    if (typeof (Storage) !== "undefined") {
	    	return localStorage.getItem(name);
	    } else {
	    	window.alert('Please use a modern browser to properly view this template!');
	    }
  	},
  	
  	/*--------------------------------------------
	描述 : 	清空本地存储
	--------------------------------------------*/
  	clearLocalStorage : function() {
  		if (typeof (Storage) !== "undefined") {
  			localStorage.clear();
  		}
  	}
	
};

$(function(){
	/*FSTool.setFontSize4Dom(FSTool.getLocalStorage('font-size'),
			document.getElementsByTagName('body')[0])*/
});