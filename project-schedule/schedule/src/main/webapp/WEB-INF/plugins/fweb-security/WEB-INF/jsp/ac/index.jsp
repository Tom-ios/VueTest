<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>FWEB-WEBFRAME</title>
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">

	<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo.ico" type="image/x-icon" />

	<!-- bootstrap样式表（必选  -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/bootstrap.css">
	<!-- font-awesome字体图标样式表（必选） -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/fonts/css/font-awesome.min.css">
	<!-- ionicons图标样式表（必选） -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/icons/css/ionicons.min.css">
	<!-- iCheck复选框美化样式表（必选） -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/assets-3rd/iCheck/all.css">
	<!-- AdminLTE样式表（必选） -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/AdminLTE.css">
	<!-- 皮肤样式表（必选） -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/skins/_all-skins.css">
	<!-- jQuery.spinner数字增减器样式表（必选）） -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/bootstrap-spinner.css">
	<!-- gritter提示框样式表（必选） -->
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/jquery.gritter.css">
    <link rel="stylesheet" href="${config.base()}framework-webframe/style/css/gritter.extra.css">
    
    <link rel="stylesheet" type="text/css" href="${config.base()}framework-webframe/style/css/fweb/css.css">
    <script type="text/javascript" src="${config.base()}fweb-framework-ui/js/jquery.min.js"></script>
	<script type="text/javascript" src="${config.base()}framework-webframe/js/commons/alerts.js"></script>
	<!-- 移动端响应式布局插件（可选） -->
    <!--[if lt IE 9]>
    <script src="../plugins/ie9/html5shiv.min.js"></script>
    <script src="../plugins/ie9/respond.min.js"></script>
    <![endif]-->
    
</head>
<body class="hold-transition skin-blue-light sidebar-mini fixed fs_14">
<div class="wrapper">

	<!-- 顶部导航 -->
    <header class="main-header">
        <!-- Logo存放位置 -->
        <a href="#" class="logo">
            <!-- 50x50px的mini logo -->
            <span class="logo-mini"><b>F</b>WEB</span>
            <!-- logo -->
            <span class="logo-lg"><b>FWEB</b>-3.0</span>
        </a>
        <!-- Header Navbar: style can be found in header.less -->
        <nav class="navbar navbar-static-top">
            <!-- 左侧边框切换图标  -->
            <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button" onresize="alert('aaa');">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </a>
			<!-- 顶部导航右侧展示区域 -->
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <!-- Messages: style can be found in dropdown.less-->
                    <li class="dropdown messages-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-envelope-o"></i>
                            <span class="label label-success">4</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">你有 1 条消息</li>
                            <li>
                                <!-- inner menu: contains the actual data -->
                                <ul class="menu">
                                    <li><!-- start message -->
                                        <a href="#">
                                            <div class="pull-left">
                                                <img src="${config.base()}framework-webframe/style/images/user2-160x160.jpg" class="img-circle"
                                                     alt="User Image">
                                            </div>
                                            <h4>
                                                                                                                             你有新的bug
                                                <small><i class="fa fa-clock-o"></i> 5 mins</small>
                                            </h4>
                                            <p>推送人[xxx]</p>
                                        </a>
                                    </li>
                                    <!-- end message -->                                   
                                </ul>
                            </li>
                            <li class="footer"><a href="#">查看所有消息</a></li>
                        </ul>
                    </li>
                    <!-- Notifications: style can be found in dropdown.less -->
                    <li class="dropdown notifications-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-bell-o"></i>
                            <span class="label label-warning">5</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">你有5个通知</li>
                            <li>
                                <!-- inner menu: contains the actual data -->
                                <ul class="menu">
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-users text-aqua"></i> 今天有5名新成员加入
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-warning text-yellow"></i> 这里描述的很长可能不适合
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-users text-red"></i> 有5名新成员加入
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-shopping-cart text-green"></i> 25销售额
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="fa fa-user text-light-blue"></i> 您更改了用户名
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="footer"><a href="#">查看全部</a></li>
                        </ul>
                    </li>
                    <!-- Tasks: style can be found in dropdown.less -->
                    <li class="dropdown tasks-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-flag-o"></i>
                            <span class="label label-danger">9</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">你有4个任务</li>
                            <li>
                                <!-- inner menu: contains the actual data -->
                                <ul class="menu">
                                    <li><!-- Task item -->
                                        <a href="#">
                                            <h3>
                                                	设计一些按钮
                                                <small class="pull-right">20%</small>
                                            </h3>
                                            <div class="progress xs">
                                                <div class="progress-bar progress-bar-aqua" style="width: 20%"
                                                     role="progressbar" aria-valuenow="20" aria-valuemin="0"
                                                     aria-valuemax="100">
                                                    <span class="sr-only">20% Complete</span>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                    <!-- end task item -->
                                    <li><!-- Task item -->
                                        <a href="#">
                                            <h3>
                                                	创造一个美好的主题
                                                <small class="pull-right">40%</small>
                                            </h3>
                                            <div class="progress xs">
                                                <div class="progress-bar progress-bar-green" style="width: 40%"
                                                     role="progressbar" aria-valuenow="20" aria-valuemin="0"
                                                     aria-valuemax="100">
                                                    <span class="sr-only">40% Complete</span>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                    <!-- end task item -->
                                    <li><!-- Task item -->
                                        <a href="#">
                                            <h3>
                                                	我需要做的任务
                                                <small class="pull-right">60%</small>
                                            </h3>
                                            <div class="progress xs">
                                                <div class="progress-bar progress-bar-red" style="width: 60%"
                                                     role="progressbar" aria-valuenow="20" aria-valuemin="0"
                                                     aria-valuemax="100">
                                                    <span class="sr-only">60% Complete</span>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                    <!-- end task item -->
                                    <li><!-- Task item -->
                                        <a href="#">
                                            <h3>
                                               		做漂亮的转变
                                                <small class="pull-right">80%</small>
                                            </h3>
                                            <div class="progress xs">
                                                <div class="progress-bar progress-bar-yellow" style="width: 80%"
                                                     role="progressbar" aria-valuenow="20" aria-valuemin="0"
                                                     aria-valuemax="100">
                                                    <span class="sr-only">80% Complete</span>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                    <!-- end task item -->
                                </ul>
                            </li>
                            <li class="footer">
                                <a href="#">查看全部任务</a>
                            </li>
                        </ul>
                    </li>
                    <!-- User Account: style can be found in dropdown.less -->
                    <li class="dropdown user user-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <img src="${config.base()}framework-webframe/style/images/user2-160x160.jpg" class="user-image" alt="User Image">
                            <span class="hidden-xs" id="userinfo"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <!-- User image -->
                            <li class="user-header">
                                <img src="${config.base()}framework-webframe/style/images/user2-160x160.jpg" class="img-circle" alt="User Image">

                                <p id="puserName">
                                    
                                </p>
                                <small style="color:white">FWEB平台</small>
                            </li>
                            <!-- Menu Body -->
                            <li class="user-body">
                                <div class="row">
                                    <div class="col-xs-6 text-center">
                                        <a href="#" data-toggle="modal" data-target="#userInfoModal">个人信息</a>
                                    </div>
                                    <div class="col-xs-6 text-center">
                                        <a href="#" onclick="getuserInfo()">修改头像</a>
                                    </div>
                                </div>
                                <!-- /.row -->
                            </li>
                            <!-- Menu Footer-->
                            <li class="user-footer">
                                <div class="pull-left">
                                    <a href="#" data-toggle="modal" data-target="#updatePasswdModal" class="btn btn-success" style="color:white">修改密码</a>
                                </div>
                                <div class="pull-right">
                                    <a href="#" onclick="logout()" class="btn btn-danger" style="color:white">退出</a>
                                </div>
                            </li>
                        </ul>
                    </li>
                    <!-- Control Sidebar Toggle Button -->
                    <li>
                        <a href="#" data-toggle="control-sidebar"><i class="fa fa-gears"></i></a>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <!-- 左侧菜单 -->
    <aside class="main-sidebar">
        <!-- sidebar: style can be found in sidebar.less -->
        <section class="sidebar">
            <!-- search form -->
            <form action="#" method="get" class="sidebar-form">
                <div class="input-group">
                    <input id="menuSearch" type="text" name="q" class="form-control" placeholder="Search...">
                    <span class="input-group-btn">
                <button type="button" name="search" id="search-btn" class="btn btn-flat" onclick="search_menu()"><i class="fa fa-search"></i>
                </button>
              </span>
                </div>
            </form>
            <!-- /.search form -->
            <!-- sidebar menu: : style can be found in sidebar.less -->
            <ul class="sidebar-menu">
            </ul>
        </section>
        <!-- /.sidebar -->
    </aside>

    <!-- 主体内容 -->
    <div class="content-wrapper" id="content-wrapper" style="min-height: 421px;background-color: #ecf0f5;">
        <!--bootstrap tab风格 多标签页-->
        <div class="content-tabs">
            <nav class="page-tabs menuTabs tab-ui-menu" id="tab-menu">
                <div class="page-tabs-content" style="margin-left: 0px;">

                </div>
            </nav>
            <button class="roll-nav roll-right tabRight" onclick="scrollTabLeft()" style="right:160px;">
                <i class="fa fa-caret-left"></i>
            </button>
            <button class="roll-nav roll-right tabRight" onclick="scrollTabRight()">
                <i class="fa fa-caret-right" style="margin-left: 3px;"></i>
            </button>
            <div class="btn-group roll-nav roll-right">
                <button class="dropdown tabClose" data-toggle="dropdown">
                    页签操作<i class="fa fa-caret-down" style="padding-left: 3px;"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-right" style="min-width: 128px;">
                    <li><a class="tabReload" href="javascript:refreshTab();">刷新当前</a></li>
                    <li><a class="tabCloseCurrent" href="javascript:closeCurrentTab();">关闭当前</a></li>
                    <li><a class="tabCloseAll" href="javascript:closeOtherTabs(true);">全部关闭</a></li>
                    <li><a class="tabCloseOther" href="javascript:closeOtherTabs();">除此之外全部关闭</a></li>
                </ul>
            </div>
            <button class="roll-nav roll-right fullscreen" onclick="App.handleFullScreen(this)"><i
                    class="fa fa-arrows-alt"></i></button>
        </div>
        <div class="content-iframe " style="background-color: #ecf0f5; ">
            <div class="tab-content " id="tab-content" style="background-color: #ecf0f5; ">

            </div>
        </div>
    </div>

    <!-- 右侧边栏（全局设置区域） -->
    <aside class="control-sidebar control-sidebar-dark">
        <!-- Create the tabs -->
        <ul class="nav nav-tabs nav-justified control-sidebar-tabs">
            <!-- <li><a href="#control-sidebar-home-tab" data-toggle="tab"><i class="fa fa-home"></i></a></li> -->
            <li id="control-sidebar-settings-tab-li"><a id="aaatest" href="#control-sidebar-settings-tab" data-toggle="tab"><i class="fa fa-gears"></i></a></li>
        </ul>
        <!-- Tab panes -->
        <div class="tab-content">
            <!-- Home tab content -->
            <!-- <div class="tab-pane" id="control-sidebar-home-tab">
               

            </div> -->
            <!-- /.tab-pane -->
            <!-- Stats tab content -->
            <!-- <div class="tab-pane" id="control-sidebar-stats-tab">Stats Tab Content</div> -->
            <!-- /.tab-pane -->
            <!-- Settings tab content -->
            <div class="tab-pane" id="control-sidebar-settings-tab">
            	<div class="row">
            		<label class="col-xs-5">字体尺寸</label>
			    	<div class="input-group spinner col-xs-6" data-trigger="spinner" id="font-size-spinner">
			        	<input type="text" id="font-size-spinner-input" class="form-control text-center" value="0" data-max="20" data-min="0" data-step="2">
			          	<div class="input-group-addon">
				            <a href="javascript:;" class="spin-up" data-spin="up"><i class="fa fa-caret-up"></i></a>
				            <a href="javascript:;" class="spin-down" data-spin="down"><i class="fa fa-caret-down"></i></a>
			          	</div>
			        </div>
				</div>
            </div>
            <!-- /.tab-pane -->
        </div>
    </aside>
    <!-- 右侧边栏背景 -->
    <div class="control-sidebar-bg"></div>	
</div>
 
 <!--用户个人信息的模态框  -->		
	<div class="modal fade" id="userInfoModal" onsubmit="return false;"tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" >
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true" onclick="clearModel()">&times;</button>
					<h4 class="modal-title" id="myModalLabel">个人信息</h4>
				</div>

				<div class="modal-body">
					<form id="userInfo1" class="row" style="width: 350px; margin-left: 150px">
						<div class="form-group">
							<input type="hidden" name="id" id="id" 
								    class="form-control" required="required" />
						</div>
						<div class="form-group">
							<label>用户名称：</label> <input type="text" name="userName" id="userName" 
								    class="form-control"
								required="required" disabled="disabled"/>
						</div>
						<div class="form-group">
							<label>用户帐号：</label> <input type="text" name="userCode" id="userCode" 
								    class="form-control"
								required="required" disabled="disabled"/>
						</div>
						<div class="form-group">
							<label>用户类型：</label> <input type="text" name="userTypeName" id="userTypeName" 
								    class="form-control"
								required="required" disabled="disabled"/>
						</div>
						<div class="form-group">
							<label>最后登陆时间：</label> <input type="text" name="latestLoginTime" id="latestLoginTime" 
								    class="form-control"
								required="required" disabled="disabled"/>
						</div>
					</form>

					<div class="modal-footer">
						<!-- <button type="button" class="btn btn-primary" onclick="updatauser()">修改</button>
						<button type="button" class="btn btn-default" onclick="clearForm()">清空</button> -->
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!--修改密码的模态框  -->		
	<div class="modal fade" id="updatePasswdModal" onsubmit="return false;"tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true" >
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true" onclick="clearModel()">&times;</button>
					<h4 class="modal-title" id="myModalLabel">修改密码</h4>
				</div>

				<div class="modal-body">
					<form id="userInfo1" class="row" style="width: 350px;height:200px;margin-left: 70px">
						<div class="form-group">
							<span style="color:red">*</span><label>原密码：</label> <input type="text" name="oldUserPasswd" id="oldUserPasswd" 
								    class="form-control"
								required="required" />
						</div>
						<div class="form-group">
							<span style="color:red">*</span><label>新密码：</label> <input type="text" name="newUserPasswd" id="newUserPasswd" 
								    class="form-control"
								required="required" oninput="checkPasswdStrong()"/>
						</div>
						<div id="passStrength" style="height:30px;width:350px;border:1px solid #ccc;padding:2px;background:green;text-align:center;line-height:30px;color:white">低</div> 
					</form>

					<div class="modal-footer">
						<button type="button" class="btn btn-primary" onclick="updatePasswd()">修改</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<!-- jQuery 2.2.3 -->
	<script src="${config.base()}framework-webframe/js/commons/jquery-2.2.3.min.js"></script>
	<!-- Bootstrap 3.3.6 （必选）  -->
	<script src="${config.base()}framework-webframe/js/commons/bootstrap.min.js"></script>
	<!-- Slimscroll滚动条优化插件 （必选）  -->
	<script src="${config.base()}framework-webframe/js/commons/jquery.slimscroll.min.js"></script>
	<!-- iCheck复选框优化插件 （必选） -->
	<script src="${config.base()}framework-webframe/assets-3rd/iCheck/icheck.min.js"></script>
	<!-- FastClick快速点击插件，防延迟 （可选） -->
	<script src="${config.base()}framework-webframe/js/commons/fastclick.js"></script>
	<!-- AdminLTE App（必选） -->
	<script src="${config.base()}framework-webframe/js/commons/app.js"></script>
	<!-- 数字增殖器 （必选） -->
	<script src="${config.base()}framework-webframe/js/commons/jquery.spinner.min.js"></script>
	<!-- 提示框 （必选） -->
	<script src="${config.base()}framework-webframe/js/commons/jquery.gritter.min.js" type="text/javascript"></script>
	<!-- 字体控制插件 （必选） -->
	<script src="${config.base()}framework-webframe/js/fweb/fweb_fs.js"></script>
	<!--  主控右侧边栏生成及全局设置插件（必选） -->
	<script src="${config.base()}framework-webframe/js/fweb/fweb_iframe.js"></script>
	<!-- 主控使用iframe模式，对AdminLTE做的调整（必选）-->
	<script src="${config.base()}framework-webframe/js/commons/app_iframe.js"></script>

<script type="text/javascript">

	var basePath = '${config.path()}';
	
    /**
     * 本地搜索菜单
     */
    function search_menu() {
        //要搜索的值
        var text = $('input[name=q]').val();
        
        if(!text)
        	return;

        var $ul = $('.sidebar-menu');
        $ul.find("a.nav-link").each(function () {
            var $a = $(this).css("border","");

            //判断是否含有要搜索的字符串
            if ($a.children("span.menu-text").text().indexOf(text) >= 0) {

                //如果a标签的父级是隐藏的就展开
                $ul = $a.parents("ul");

                if ($ul.is(":hidden")) {
                    $a.parents("ul").prev().click();
                }

                //点击该菜单
                $a.click().css("border","1px solid");

				return false;
            }
        });
    }

    $(function () {

		var base = '${config.base()}';
        App.setbasePath(base+"fweb-security/");
		App.setGlobalImgPath("style/images/");
        /* addTabs({
            id: '10008',
            title: '工作台',
            close: false,
            url: 'view/fweb-security/ac/crumb_manager',
            urlType: "relative"
        }); */ 

        App.fixIframeCotent();
        /*$.getJSON(base+'fweb-security/style/menu.json',function(data){
	        $('.sidebar-menu').sidebarMenu({data: data});
        }); */

        
				//获取当前用户信息
				$.ajax({
					url:base+'fweb-security/login/getLoginUserInfo',
					method:'get',
					async:false,
					success:function(data){
					userId=data.result.data_.id;
					userName=data.result.data_.userName;
					userCode=data.result.data_.userCode;
					userTypeName=data.result.data_.userTypeName;
					latestLoginTime=data.result.data_.latestLoginTime;
					console.log(data);
					document.getElementById("userName").value=userName;
					document.getElementById("userCode").value=userCode;
					document.getElementById("userTypeName").value=userTypeName;
					document.getElementById("latestLoginTime").value=latestLoginTime;
					$("#puserName").html(userName);
						},
					error:function(){
						myAlert('系统提示','系统错误',function(){   
						})
						}
					})
				
			   //清除权限缓存
        		$.ajax({
                	url:base+'fweb-security/auth/flushAuthCache?'+userId,
                	method:"get",
                	async:false,
                	success:function(data){
                		console.log(data);
                	}
                })
                
        	   //获取当前用户拥有权限的菜单列表
               $.ajax({
                	url:base+'fweb-security/auth/fwebUserMenu',
                	method:"get",
                	async:false,
                	success:function(data){
                		console.log(data.data);
                		var menudata=data.data;
                		$('.sidebar-menu').sidebarMenu({data: menudata});
                	}
                })         
        
      	//为输入框绑定回车事件
		$("#menuSearch").keypress(function(e){
	        var eCode = e.keyCode ? e.keyCode : e.which ? e.which : e.charCode;
	        if (eCode == 13){
	        	search_menu();
	        	return false;
	        }
		});

    });



    //退出登录
    function logout(){;
    	var baseUrl="${config.base()}";
    	$.ajax({
    		url:'${config.base()}fweb-security/login/logout',
    		method:'post',
    		success:function(){
    			window.location.href=baseUrl+"/view/fweb-security/ac/login";
    		},
    		error:function(){
				window.location.href=baseUrl+"/view/fweb-security/ac/login";
    		}
    	})
    }
    
    //修改密码
    function updatePasswd(){
    	/* var userCode="admin" */
    	var newUserPasswd=document.getElementById("newUserPasswd").value;
    	var oldUserPasswd=document.getElementById("oldUserPasswd").value;
    	var isReset = false;
    	var data={"userCode":userCode,"oldUserPasswd":oldUserPasswd,"newUserPasswd":newUserPasswd,"isReset":isReset}
    	console.log(data);
    	data= JSON.stringify(data);
    	$.ajax({
    		url:'${config.base()}fweb-security/user/updatepasswd',
    		method:'post',
    		data:data,
   		 	dataType:'json',
   		 	contentType: 'application/json',
    		success:function(data){
    			 var status=data.status;
    			 console.log(status);
    			 if(status==="10200"){
    			myAlert('系统提示','修改成功',function(){   
    				window.location.reload();
				})
				}else if(status==="10201"){
				myAlert('系统提示','参数值不能为空',function(){   
	    				
					})
				}else if(status==="10401"){
				myAlert('系统提示','原密码不正确',function(){   
	    				
					})
				}
    		},
    		error:function(){
				myAlert('系统提示','修改失败',function(){   
    				
				})
    		}
    	})
    }
   
    //验证密码强度
    function checkPasswdStrong(){
		var password=document.getElementById("newUserPasswd").value;
    	$.ajax({
    		url:'${config.base()}fweb-security/login/checkPasswdStrong',
    		method:'get',
    		data:{"password":password},
   		 	dataType:'text',
    		success:function(data){
    			var obj = JSON.parse(data); 
    			var level=obj.data;
    			if(level=="easy"){
    				var div1 = document.getElementById("passStrength");
    				div1.style.background = "green";
    				div1.innerHTML="低";
    			}else if(level=="strong"){
    				var div1 = document.getElementById("passStrength");
    				div1.style.background = "yellow";
    				div1.innerHTML="中";
    			}else if(level=="verystrong"){
    				var div1 = document.getElementById("passStrength");
    				div1.style.background = "red";
    				div1.innerHTML="高";
    			}
    		},
    		error:function(){
    		}
    	})
    }
</script>

</body>
</html>