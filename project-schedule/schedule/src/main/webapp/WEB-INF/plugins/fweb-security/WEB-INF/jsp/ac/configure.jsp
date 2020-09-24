<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>权限参数配置</title>
<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo.ico" type="image/x-icon" />
   	
   	<link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/css/bootstrap.min.css">
    
  	<link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/easyui/bootstrap/easyui.css">
    <link rel="stylesheet" type="text/css" href="${config.base()}fweb-framework-ui/style/css/fweb.css">
	
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/jquery.min.js"></script>
	<script src="${config.base()}fweb-framework-ui/js/bootstrap/bootstrap.min.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/jquery.json-2.2.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${config.base()}fweb-framework-ui/js/easyui/insdep/jquery.insdep-extend.min.js"></script>
	<script type="text/javascript" src="${config.base()}framework-webframe/js/fweb/fweb.util.js"></script>
   	
	<script type="text/javascript" src="${config.path() }style/js/alerts.js"></script>
</head>
<style>
.elegant-aero {
margin-left:auto;
margin-right:auto;
max-width: 100%;
height:100%;
background: #F8F8F8;
padding: 20px 20px 20px 20px;
font: 12px Arial, Helvetica, sans-serif;
color: blanchedalmond;
}
.elegant-aero h1 {
font: 24px "Trebuchet MS", Arial, Helvetica, sans-serif;
padding: 10px 10px 10px 20px;
display: block;
background: #18A4DB;
border-bottom: 1px solid #3C8DBC;
margin: -20px -20px 15px;
}
.elegant-aero h1>span {
display: block;
font-size: 11px;
}

.elegant-aero label>span {
float: left;
margin-top: 10px;
color: #5E5E5E;
}
.elegant-aero label {
display: block;
margin: 0px 0px 5px;
}
.elegant-aero label>span {
float: left;
width: 29%;
text-align: right;
padding-right: 25px;
margin-top: 10px;
font-weight: bold;
font-size: 14px;
}
.elegant-aero input[type="text"], .elegant-aero input[type="email"], .elegant-aero textarea, .elegant-aero select {
color: #888;
width: 50%;
padding: 0px 0px 0px 5px;
border: 1px solid #C5E2FF;
background: #FBFBFB;
outline: 0;
-webkit-box-shadow:inset 0px 1px 6px #ECF3F5;
box-shadow: inset 0px 1px 6px #ECF3F5;
font: 200 12px/25px Arial, Helvetica, sans-serif;
height: 30px;
line-height:15px;
margin: 2px 6px 16px 0px;
border-radius:4px;
}
.elegant-aero textarea{
height:100px;
padding: 5px 0px 0px 5px;
width: 50%;
border-radius:4px;
}
.elegant-aero select {
appearance:none;
-webkit-appearance:none;
-moz-appearance: none;
text-indent: 0.01px;
text-overflow: '';
width: 50%;
border-radius:4px;
}
.elegant-aero .button{
padding: 10px 30px 10px 30px;
background: #18A4DB;
border: none;
color: #FFF;
box-shadow: 1px 1px 1px #4C6E91;
-webkit-box-shadow: 1px 1px 1px #4C6E91;
-moz-box-shadow: 1px 1px 1px #4C6E91;
text-shadow: 1px 1px 1px #5079A3;
border-radius:4px;
}
.elegant-aero .button:hover{
background: #3EB1DD;
}
</style>
<body class=" easyui-layout">
	
	<div class="content-layout-center" data-options="region:'center',border:false" id="center_content">
	
	
	<form id="parameter_list" action="" class="elegant-aero">
			<h1>参数配置
			<span>请输入参数进行参数配置</span>
			</h1>
				<label>
				<span>缓存种类配置：</span>
				<select name="security.cache.type" id="security.cache.type" disabled="disabled">
				  									<option value ="redis">redis缓存</option>
				  									<option value ="default" selected = "selected">map缓存</option>
				</select>				
				</label>
				
				<label>
				<span>是否需要验证码验证登陆标志：</span>
				<select name="security.login.captchaFlag" id="security.login.captchaFlag" >
								    <option value ="true">是</option>
  									<option value ="false" selected = "selected">否</option>
								    </select>					
				</label>
			
				<label>
				<span>密码存储加密方式:</span>
				<select name="security.login.passwd.encryption.algorithmName" id="security.login.passwd.encryption.algorithmName" >
								    <option value ="SHA" selected = "selected">SHA</option>
  									<option value ="MD5">MD5</option>	
								    </select>
				</label>
				
				<label>
				<span>密码存储加密迭代次数:</span>
				<input type="text" name="security.login.passwd.encryption.hashIterations" id="security.login.passwd.encryption.hashIterations" 
								    onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"  
   									onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}"
								required="required" value="3"/>	
				</label>
				<label>
				<span>密码错误最大次数:</span>
				<input type="text" name="security.login.passwd.MaxRetryCount" id="security.login.passwd.MaxRetryCount" 
								    onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"  
   									onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}"
								required="required" value="3"/>
				</label> 
				
				<label>
				<span>密码重置的明文密码:</span>
				<input type="text" name="security.login.passwd.resetpassword" id="security.login.passwd.resetpassword" 
								required="required" value="123456"/>
				</label>
						
				<label>
				<span>密码传输加密随机数的位数:</span>
				<input type="text" name="security.login.passwd.randomdigit" id="security.login.passwd.randomdigit" 
								    onkeyup="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'')}else{this.value=this.value.replace(/\D/g,'')}"  
   									onafterpaste="if(this.value.length==1){this.value=this.value.replace(/[^1-9]/g,'0')}else{this.value=this.value.replace(/\D/g,'')}"
								required="required" value="6"/>	
				</label> 
				
				<label>
				<span>登录地址:</span>
				<input type="text" name="security.loginurl" id="security.loginurl" 
								required="required" value="/view/fweb-security/ac/login"/>	
				</label>	
				
				<label>
				<span>登录成功后的地址:</span>
				<input type="text" name="security.successUrl" id="security.successUrl" 
								required="required" value="/view/framework-webframe/index"/>	
				</label>	
				
				<label>
				<span>会话过期时间(毫秒):</span>
				<input type="text" name="security.session.timeout" id="security.session.timeout" 
								required="required" value="1800000"/>	
				</label>
				
				<label>
				<span>是否开启权限验证:</span>
				<select name="security.auth.on-off" id="security.auth.on-off" >
								    <option value ="on">开启</option>
  									<option value ="off" selected = "selected">关闭</option>
								    </select>
				</label>		
									
				<label>
				<span>&nbsp;</span>
				<input type="button" class="button" value="保存" onclick="submitForm()" />&nbsp;
				<input type="button" class="button" value="恢复默认设置"  onclick="restoreSet()"/>
				</label>
	</form>
	</div>
	<script>
	
	function submitForm(){
		var data = $.toJSON($('#parameter_list').serializeObject());
		var obj=JSON.parse(data);
		var key="";
		var pluginId="";
		var value="";
		console.log(data);
		for(var p in obj){  
			pluginId="fweb-security";
			value=obj[p];
			key=p;
			$.ajax({
				   url:'${config.base()}core/plugin/parameters/upload',
			       type:'PUT',
			       dataType:"json",
			       data:JSON.stringify({"pluginId":pluginId,"key":key,"value":value}),
			       contentType:'application/json;charset=UTF-8',
			       success:function(data){
			    	   if(data.key=="security.auth.on-off"){
			    		   myAlert('系统提示','保存成功',function(){   
					            //要回调的方法  
					            $.ajax({
								   url:'${config.base()}core/plugin/parameters/apply/'+pluginId,
							       type:'GET',
							       success:function(data){}
					            });
							})
			    	   }
			       },
			       error:function(request){
			    	   myAlert('系统提示','保存失败',function(){   
				            //要回调的方法  
						})	   
			       }
			   }); 
	      }
		
	}
	
	$(function loadConfig(){
		$.ajax({
			   url:'${config.base()}core/plugin/parameters/list?order=asc&pluginId=fweb-security',
		       type:'get',
		       success:function(data){
		    	   console.log(data);
		    	   for(var i = 0;i<data.length;i++){ 
		    		   if(data[i].key=="security.cache.type"){
		    			   $("[id='security.cache.type']").val(data[i].value);		    				
		    		   }else if(data[i].key=="security.login.captchaFlag"){
		    			   $("[id='security.login.captchaFlag']").val(data[i].value);
		    		   }else if(data[i].key=="security.login.passwd.encryption.algorithmName"){
		    			   $("[id='security.login.passwd.encryption.algorithmName']").val(data[i].value);
		    		   }else if(data[i].key=="security.login.passwd.encryption.hashIterations"){
		    			   $("[id='security.login.passwd.encryption.hashIterations']").attr("value",data[i].value);
		    		   }else if(data[i].key=="security.login.passwd.MaxRetryCount"){
		    			   $("[id='security.login.passwd.MaxRetryCount']").attr("value",data[i].value);
		    		   }else if(data[i].key=="security.login.passwd.resetpassword"){
		    			   $("[id='security.login.passwd.resetpassword']").attr("value",data[i].value);
		    		   }else if(data[i].key=="security.login.passwd.randomdigit"){
		    			   $("[id='security.login.passwd.randomdigit']").attr("value",data[i].value);
		    		   }else if(data[i].key=="security.loginurl"){
		    			   $("[id='security.loginurl']").val(data[i].value);
		    		   }else if(data[i].key=="security.successUrl"){
		    			   $("[id='security.successUrl']").val(data[i].value);
		    		   }else if(data[i].key=="security.session.timeout"){
		    			   $("[id='security.session.timeout']").val(data[i].value);
		    		   }else if(data[i].key=="security.auth.on-off"){
		    			   $("[id='security.auth.on-off']").val(data[i].value);
		    		   }
		    	   }
		       },
		       error:function(){
		    	  	    	   
		       }
		   });
	})
	
	function restoreSet(){
		
	}
	</script>
</body>
</html>