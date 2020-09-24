<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
<meta charset="UTF-8">
<title>Fweb</title>
<meta name="viewport" content="width=device-width, initial-scale=1"/>
<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo.ico" type="image/x-icon" />
<link href="${config.path()}style/css/style.css" rel="stylesheet" type="text/css">
<link href="${config.base()}fweb-framework-ui/style/css/bootstrap.min.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/jquery.min.js"></script>
<script type="text/javascript" src="${config.path() }style/js/alerts.js"></script>
<script type="text/javascript" src="${config.path() }style/js/jsencrypt.js"></script>
</head>

<body onkeydown="if(event.keyCode==13){login()}">
	<div class="logobox">
		<div class="logopic">
			<span class="logopicbox"><img src="${config.path()}style/images/logo.png"/></span>
		</div>
	</div>
	<div class="content">
		<div class="leftbox"><img src="${config.path()}style/images/leftpic.png"/></div>
		<div class="loginbox">
			<div class="login-tilte"><img src="${config.path()}style/images/login-tilte.png"/></div>
			<div class="inputbox">
			  <div class="inputbox1"><input type="text" class="form-control uname" id="username" onfocus="if(this.value==defaultValue) {this.value='';this.type='text'}" onblur="if(!value) {value=defaultValue; this.type='text';}"/></div>
			  <div class="inputbox2"><input type="text" class="form-control pword" id="password" onfocus="if(this.value==defaultValue) {this.value='';this.type='password'}" onblur="if(!value) {value=defaultValue; this.type='text';}"/></div>
			  
			  <div id="captchadiv" class="inputbox3 row form-group" style="display:none;">
			  	<div class="inputbox3 col-md-5 col-sm-5 col-xs-5" style="width:50%;float:left">
			  		<input type="text" class="form-control uname" id="captcha" autocomplete="off" onfocus="if(this.value==defaultValue) {this.value='';this.type='text'}" onblur="if(!value) {value=defaultValue; this.type='text';}"/>			 
			  	</div>
			  	<div class="col-md-4 col-sm-4 col-xs-4" style="margin-left:-25px;margin-top:25px">
			   		<img alt="验证码" src="${config.base()}fweb-security/login/captcha/captcha" title="点击更换" id="captcha_img"/ style="">		      
			  	</div>
			 	<div class="col-md-3 col-sm-3 col-xs-3" style="margin-left:-15px;margin-top:28px">
			  		<a href="javascript:void(0)" style="font-size:12px" onclick="javascript:refreshCaptcha()">换一张</a>
			  	</div>
			  </div>
			 <div class="remember"><input type="checkbox" id="checkbox1"> 记住我</div>
			 <a class="btn" onclick="login()">登录</a>
			</div>
		</div>
	</div>
	<div class="foot">
		<p>Copyright ©2000-2015 | <a href="" class="yellow">北京恒华伟业科技股份有限公司版权所有 </a>V ${config.getConfig('common.page.info.version')}</p>
		<p>京ICP备10054994号-4 11010102001882号</p>
		<p>恒华云提供计算服务</p>
	</div>
	
	<script>
	
	
	$(function () {
		 //获取验证码配置
		 $.ajax({
			 url:"${config.base()}fweb-security/login/captcha/captchaConfig",
			 method:"get",
			 success:function(data){
				 var captchaConfig=data.data;
				 if(captchaConfig=="true"){
					 $("#captchadiv").show()
				 }else if(captchaConfig=="false"){
					 $("#captchadiv").hide()
				 }
			 },
			 error:function(){
				 myAlert('系统提示','获取验证码配置失败',function(){   
			            //要回调的方法  
					});
		    		}	               
		 });
	 });
	
  
  //登陆成功页面逻辑
 function login(){	
	 var successUrl="${config.getConfig('security.successUrl')}";
	 successUrl=successUrl.substr(1,successUrl.length-1);
	 //获取输入值
	 rememberMe=false;
	 loginname=$("#username").val();
	 captcha=$("#captcha").val();
	 password=$("#password").val();
	 //如果选中则为true,没有选中则为false
	 if($("#checkbox1").is(':checked')){
		  rememberMe=true;
		 }
	 
	 //获取公钥和随机数
	 $.ajax({
		 url:"${config.base()}fweb-security/login/getPublicKey",
		 method:"get",
		 async:false, 
		 success:function(data){
			 publicKey=data.data.publicKey;
			 random=data.data.random;
		 
	   //密码加密
	   enPassword = encryptPasswd(password,publicKey,random);
	 
       var data={"userCode":loginname,"enPassword":enPassword,"rememberMe":rememberMe,"captcha":captcha};
       data= JSON.stringify(data);
	     $.ajax({
		 url:"${config.base()}fweb-security/login/dologin",
		 method:"post",
		 data:data,
		 dataType:'json',
		 contentType: 'application/json',
		 success:function(data){
			 console.log(data);
			 var status=data.code;
			 if(status==="10200"){
		    window.location.href="${config.base()}"+successUrl;
			 }else if(status==="10403"){
				 myAlert('系统提示','当前用户已被管理员锁定，请联系管理员',function(){   
			            //要回调的方法  
					})
			 }else if(status==="10401"){
				 myAlert('系统提示','用户名/密码错误',function(){   
			            //要回调的方法  
					})
			 }else if(status==="10402"){
				 myAlert('系统提示','用户名/密码错误',function(){   
			            //要回调的方法  
					})
			 }else if(status==="10404"){
				 myAlert('系统提示','密码错误多次，帐号已被锁定',function(){   
			            //要回调的方法  
					})
			 }else if(status==="10405"){
				 myAlert('系统提示','验证码错误',function(){   
			            //要回调的方法  
					})
			 }else if(status==="10406"){
				 myAlert('系统提示','不在可登陆时间',function(){   
			            //要回调的方法  
					})
			 }else if(status==="10407"){
				 myAlert('系统提示','用户口令在传输过程中可能被篡改',function(){   
			            //要回调的方法  
					})
			 }
		 },
		 error:function(){
			 myAlert('系统提示','登陆失败',function(){   
		            //要回调的方法  
				});
	    		}            
	 		}) 
		 },
		 error:function(){
			 myAlert('系统提示','获取公钥和随机数失败',function(){   
		            //要回调的方法  
				});
	    	}	               
	 })
  } 
  
 function refreshCaptcha(){
     $("#captcha_img").attr("src","${config.base()}fweb-security/login/captcha/captcha?id=" + new Date() + Math.floor(Math.random()*24));
 }
 
 function encryptPasswd(password,publicKey,random){
	//加密密码
	 let encrypt = new JSEncrypt();
     encrypt.setPublicKey(publicKey);
     mdPassword = MD5(password);
	 enPassword = encrypt.encryptLong(password+","+mdPassword+","+random);
	 return enPassword;
 }

</script>
</body>
</html>
