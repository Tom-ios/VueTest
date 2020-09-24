/**
 * AdminLTE Demo Menu
 * ------------------
 * You should not use this file in production.
 * This file is for demo purposes only.
 */
(function ($, AdminLTE) {

	"use strict";

  	/**
  	 * List of all the available skins
  	 *
  	 * @type Array
  	 */
  	var my_skins = [
	    "skin-blue",
	    "skin-black",
	    "skin-red",
	    "skin-yellow",
	    "skin-purple",
	    "skin-green",
	    "skin-blue-light",
	    "skin-black-light",
	    "skin-red-light",
	    "skin-yellow-light",
	    "skin-purple-light",
	    "skin-green-light"
    ];

	//Create the new tab
  	var $tabPane = $('<div />', {
	    'id'   : 'control-sidebar-theme-demo-options-tab',
	    'class': 'tab-pane active'
  	})

  	// Create the tab button
  	var $tabButton = $('<li />', { 'class': 'active' })
	    .html('<a href=\'#control-sidebar-theme-demo-options-tab\' data-toggle=\'tab\'>'
	      + '<i class="fa fa-wrench"></i>'
	      + '</a>')

    // Add the tab button to the right sidebar tabs
	$('[href="#control-sidebar-settings-tab"]')
		.parent()
		.before($tabButton)

    // Create the menu
    var $demoSettings = $('<div />')
  
  	// 布局方式
  	$demoSettings.append(
	    '<h4 class="control-sidebar-heading">'
	    + '布局方式'
	    + '</h4>'
	    // Fixed layout
	    + '<div class="form-group">'
	    + '<label class="control-sidebar-subheading">'
	    + '<input type="checkbox" class="pull-right flat-red"/> '
	    + '方式1'
	    + '</label>'
	    + '</div>'
	    // Boxed layout
	    + '<div class="form-group">'
	    + '<label class="control-sidebar-subheading">'
	    + '<input type="checkbox" class="pull-right flat-red"/> '
	    + '方式2'
	    + '</label>'
	    + '</div>'
  	)

  	// 布局操作
  	$demoSettings.append(
	    '<h4 class="control-sidebar-heading">'
	    + '布局操作'
	    + '</h4>'
	    // Fixed layout
	    /*+ '<div class="form-group">'
	    + '<label class="control-sidebar-subheading">'
	    + '<input type="checkbox"data-layout="fixed" class="pull-right"/> '
	    + '固定导航条'
	    + '</label>'
	    + '</div>'*/
	    // Boxed layout
	    + '<div class="form-group">'
	    + '<label class="control-sidebar-subheading">'
	    + '<input type="checkbox" data-layout="layout-boxed" class="pull-right flat-red"/> '
	    + '	切换窄屏 '
	    + '</label>'
	    + '</div>'
	    // Sidebar Toggle
	    + '<div class="form-group">'
	    + '<label class="control-sidebar-subheading">'
	    + '<input type="checkbox" data-layout="sidebar-collapse" class="pull-right flat-red"/> '
	    + '切换左侧边栏'
	    + '</label>'
	    + '</div>'
	    // Sidebar mini expand on hover toggle
	    + '<div class="form-group">'
	    + '<label class="control-sidebar-subheading">'
	    + '<input type="checkbox" data-enable="expandOnHover" class="pull-right flat-red"/> '
	    + '覆盖时展开左侧边栏'
	    + '</label>'
	    + '</div>'
	    // Control Sidebar Toggle
	    + '<div class="form-group">'
	    + '<label class="control-sidebar-subheading">'
	    + '<input type="checkbox" data-controlsidebar="control-sidebar-open" class="pull-right flat-red"/> '
	    + '右侧侧边栏效果切换'
	    + '</label>'
	    + '</div>'
	    // Control Sidebar Skin Toggle
	    + '<div class="form-group">'
	    + '<label class="control-sidebar-subheading">'
	    + '<input type="checkbox" data-sidebarskin="toggle" class="pull-right flat-red"/> '
	    + '右侧边栏背景色（深/浅）'
	    + '</label>'
	    + '</div>'
  	)
  	var $skinsList = $('<ul />', { 'class': 'list-unstyled clearfix' })

  	// Dark sidebar skins
  	var $skinBlue =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-blue" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px; background: #367fa9"></span><span class="bg-light-blue" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #222d32"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">蓝色</p>')
    $skinsList.append($skinBlue)
  	var $skinBlack =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-black" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div style="box-shadow: 0 0 2px rgba(0,0,0,0.1)" class="clearfix"><span style="display:block; width: 20%; float: left; height: 7px; background: #fefefe"></span><span style="display:block; width: 80%; float: left; height: 7px; background: #fefefe"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #222"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">黑色</p>')
    $skinsList.append($skinBlack)
  	var $skinPurple =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-purple" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px;" class="bg-purple-active"></span><span class="bg-purple" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #222d32"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">紫色</p>')
    $skinsList.append($skinPurple)
  	var $skinGreen =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-green" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px;" class="bg-green-active"></span><span class="bg-green" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #222d32"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">绿色</p>')
    $skinsList.append($skinGreen)
  	var $skinRed =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-red" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px;" class="bg-red-active"></span><span class="bg-red" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #222d32"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">红色</p>')
    $skinsList.append($skinRed)
  	var $skinYellow =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-yellow" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px;" class="bg-yellow-active"></span><span class="bg-yellow" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #222d32"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">黄色</p>')
    $skinsList.append($skinYellow)

  	// Light sidebar skins
  	var $skinBlueLight =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-blue-light" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px; background: #367fa9"></span><span class="bg-light-blue" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">蓝色浅底</p>')
	$skinsList.append($skinBlueLight)
  	var $skinBlackLight =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-black-light" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div style="box-shadow: 0 0 2px rgba(0,0,0,0.1)" class="clearfix"><span style="display:block; width: 20%; float: left; height: 7px; background: #fefefe"></span><span style="display:block; width: 80%; float: left; height: 7px; background: #fefefe"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">黑色浅底</p>')
    $skinsList.append($skinBlackLight)
  	var $skinPurpleLight =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-purple-light" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px;" class="bg-purple-active"></span><span class="bg-purple" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">紫色浅底</p>')
    $skinsList.append($skinPurpleLight)
  	var $skinGreenLight =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-green-light" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px;" class="bg-green-active"></span><span class="bg-green" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">绿色浅底</p>')
    $skinsList.append($skinGreenLight)
  	var $skinRedLight =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
          .append('<a href="javascript:void(0)" data-skin="skin-red-light" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
            + '<div><span style="display:block; width: 20%; float: left; height: 7px;" class="bg-red-active"></span><span class="bg-red" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
            + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
            + '</a>'
            + '<p class="text-center no-margin">红色浅底</p>')
    $skinsList.append($skinRedLight)
    
  	var $skinYellowLight =
        $('<li />', { style: 'float:left; width: 16.66667%; padding: 5px;' })
		  .append('<a href="javascript:void(0)" data-skin="skin-yellow-light" style="display: block; box-shadow: 0 0 3px rgba(0,0,0,0.4)" class="clearfix full-opacity-hover">'
		    + '<div><span style="display:block; width: 20%; float: left; height: 7px;" class="bg-yellow-active"></span><span class="bg-yellow" style="display:block; width: 80%; float: left; height: 7px;"></span></div>'
		    + '<div><span style="display:block; width: 20%; float: left; height: 20px; background: #f9fafc"></span><span style="display:block; width: 80%; float: left; height: 20px; background: #f4f5f7"></span></div>'
		    + '</a>'
		    + '<p class="text-center no-margin">黄色浅底</p>')
    $skinsList.append($skinYellowLight)

  	$demoSettings.append('<h4 class="control-sidebar-heading">皮肤</h4>')
  	$demoSettings.append($skinsList)

  	$tabPane.append($demoSettings)
  	$('#control-sidebar-settings-tab').after($tabPane)
  
  	//数字自增器change监听
  	$('#font-size-spinner').spinner('changed', function(e, newVal, oldVal) {
  		FSTool.addAllFontSize(newVal-oldVal,newVal);
		resizeLogoAndSideMenuHeight();
		$.gritter.add({  
		    text: '字体尺寸设置成功',  
		    sticky: false,  
		    time: 3000,
		    speed:500,  
		    class_name: 'gritter-success'  
		});
  	});
  	
  	//Flat red color scheme for iCheck
    $('input[type="checkbox"].flat-red, input[type="radio"].flat-red').iCheck({
    	checkboxClass: 'icheckbox_flat-green',
    	radioClass   : 'iradio_flat-green'
    })
    
  	setup();

    /*--------------------------------------------
	描述 : 	修改布局方式
	参数 :	cls			布局样式(fixed,layout-boxed)
	--------------------------------------------*/
  	function change_layout(cls) {
	    $("body").toggleClass(cls);
	    AdminLTE.layout.fixSidebar();
	    //Fix the problem with right sidebar and layout boxed
	    if (cls == "layout-boxed"){
	    	AdminLTE.controlSidebar._fix($(".control-sidebar-bg"));
	    	if ($('body').hasClass('fixed'))
	    			$("body").toggleClass('fixed');
	    }
	    if ($('body').hasClass('fixed') && cls == 'fixed') {
	    	AdminLTE.pushMenu.expandOnHover();
	    	AdminLTE.layout.activate();
	    }
	    AdminLTE.controlSidebar._fix($(".control-sidebar-bg"));
		AdminLTE.controlSidebar._fix($(".control-sidebar"));
  	}

  	/*--------------------------------------------
	描述 : 	修改皮肤样式
	参数 :	cls			皮肤样式
	--------------------------------------------*/
  	function change_skin(cls) {
	    $.each(my_skins, function (i) {
	    	$("body").removeClass(my_skins[i]);
	    });

	    $("body").addClass(cls);
	    store('skin', cls);
	    return false;
  	}

  	/*--------------------------------------------
	描述 : 	设置本地存储
	参数 :	name
			value
	--------------------------------------------*/
  	function store(name, val) {
	    if (typeof (Storage) !== "undefined") {
	    	localStorage.setItem(name, val);
	    } else {
	    	window.alert('Please use a modern browser to properly view this template!');
	    }
  	}

  	/*--------------------------------------------
	描述 : 	根据name从本地存储中获取数据
	参数 :	name
	返回值 :	name对应本地存储中的数据
	--------------------------------------------*/
  	function get(name) {
	    if (typeof (Storage) !== "undefined") {
	    	return localStorage.getItem(name);
	    } else {
	    	window.alert('Please use a modern browser to properly view this template!');
	    }
  	}
  	
  	/*--------------------------------------------
	描述 : 	清空本地存储
	--------------------------------------------*/
  	function clearLocalStorage() {
  		if (typeof (Storage) !== "undefined") {
  			localStorage.clear();
  		}
  	}

  	/*--------------------------------------------
	描述 : 	主控页面全局设置
	--------------------------------------------*/
  	function setup() {
  		_init();
  		
  		/*初始化设置*/
  		
  		//皮肤
	    var tmp = get('skin');
	    if (tmp && $.inArray(tmp, my_skins)>=0)
	    	change_skin(tmp);
	    
	    //右侧边栏背景色
	    var sidebarskinTmp = get('data-sidebarskin')
	    if (sidebarskinTmp == 'control-sidebar-dark'){
	    	$(".control-sidebar").removeClass("control-sidebar-light")
	    	$(".control-sidebar").addClass("control-sidebar-dark")
	    	$("[data-sidebarskin='toggle']").iCheck('check');
	    }else{
	    	$(".control-sidebar").removeClass("control-sidebar-dark")
	    	$(".control-sidebar").addClass("control-sidebar-light")
	    }
	  
	    //字体尺寸
	    var fontSizeTmp = FSTool.getLocalStorage('font-size')
	    if (fontSizeTmp && parseInt(fontSizeTmp)>0){
	    	$("#font-size-spinner-input").val(fontSizeTmp);
	    	if(parseInt(fontSizeTmp)>20){
	    		FSTool.addAllFontSize(0,0);
	    		resizeLogoAndSideMenuHeight();
	    	}else{
	    		FSTool.addAllFontSize(fontSizeTmp,fontSizeTmp)
	    		resizeLogoAndSideMenuHeight();
	    	}
	    }
	
	    //换肤
		$("[data-skin]").on('click', function (e) {
			if($(this).hasClass('knob'))
				return;
			e.preventDefault();
			change_skin($(this).data('skin'));
	    });
	
	    //切换页面布局窄边，左侧边栏收缩展开
	    $("[data-layout]").on('ifChecked ifUnchecked', function (event) {
	    	if(event.type == 'ifChecked'){
	    		if($(this).data('layout')=='layout-boxed')
	      	  		store('layout', $(this).data('layout'));
	    		else
	    			store('sidebar-collapse', $(this).data('layout'));
	        }else{
	        	if($(this).data('layout')=='layout-boxed')
	        		store('layout', '');
	        	else
	      	  		store('sidebar-collapse', '');
	        }
	    	change_layout($(this).data('layout'));
	    });
	
	    $("[data-controlsidebar]").on('ifChecked ifUnchecked', function (event) {
	    	if(event.type=='ifChecked'){
	      	  	store('layout-controlsidebar', $(this).data('controlsidebar'));
	        }else{
	      	  	store('layout-controlsidebar', '');
	        }
	    	change_layout($(this).data('controlsidebar'));
	    	var slide = !AdminLTE.options.controlSidebarOptions.slide;
	    	AdminLTE.options.controlSidebarOptions.slide = slide;
	    	if (!slide)
	    		$('.control-sidebar').removeClass('control-sidebar-open');
	    });
	
	    $("[data-sidebarskin='toggle']").on('ifChecked ifUnchecked', function (event) {
	    	var sidebar = $(".control-sidebar");
	    	if (sidebar.hasClass("control-sidebar-dark")) {
	    		sidebar.removeClass("control-sidebar-dark")
	    		sidebar.addClass("control-sidebar-light")
	    		//保存右侧边栏背景配置
	    		store('data-sidebarskin', 'control-sidebar-light');
	    	} else {
	    		sidebar.removeClass("control-sidebar-light")
	    		sidebar.addClass("control-sidebar-dark")
	    		//保存右侧边栏背景配置
	    		store('data-sidebarskin', 'control-sidebar-dark');
	    	}
	    });
	
	    $("[data-enable='expandOnHover']").on('ifChecked ifUnchecked', function (event) {
	    	//$(this).attr('disabled', true);
	    	$(this).iCheck('disable')
	    	AdminLTE.pushMenu.expandOnHover();
	    	if ($('body').hasClass('sidebar-collapse'))
	    		$("[data-layout='sidebar-collapse']").iCheck('check');
	    	if(event.type == 'ifChecked')
	    		store('data-enable', 'expandOnHover');
	    	else
	    		store('data-enable', '');
	    });
	
	    //箱体布局
	    var layoutTmp = get('layout')
	    if (layoutTmp){
	    	$("[data-layout='layout-boxed']").iCheck('check');
	    }
	    
	    //右侧边栏收缩展开
	    var layoutControlsidebarTmp = get('layout-controlsidebar')
	    if (layoutControlsidebarTmp){
	    	$("[data-controlsidebar]").iCheck('check');
	    }
	    
	    //左侧边栏收缩展开
	    var layoutSidebarCollapseTmp = get('sidebar-collapse')
	    if (layoutSidebarCollapseTmp){
	    	$("[data-layout='sidebar-collapse']").iCheck('check');
	    }
	    
	    //覆盖时左侧边栏展开
	    var expandOnHoverTmp = get('data-enable')
	    if (expandOnHoverTmp){
	    	$("[data-enable='expandOnHover']").iCheck('check');
	    }
	    
  	}
  
  	
  	/*--------------------------------------------
	描述 : 	重新调整顶部导航的高度
	--------------------------------------------*/
	function resizeLogoAndSideMenuHeight(){
		var navHeight = $('.main-header .navbar .sidebar-toggle')[0].getBoundingClientRect().height;
		$('.main-header .logo').css('height',navHeight);
		$('.main-sidebar').css('padding-top',navHeight);
		$('.content-wrapper,.control-sidebar').css('padding-top',navHeight);
	};
  
  
})(jQuery, $.AdminLTE);
