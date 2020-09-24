<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>面包屑首页</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  	<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />
  	
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/easyui/bootstrap.css">
    <link rel="stylesheet" href="http://static.365power.cn/scss/web/v3.1.20180117/skin1/assets-3rd/font-awesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/assets/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/css/AdminLTE.css">
    <link rel="stylesheet" href="${Config.baseURL }view/demoframe/css/skins/_all-skins.css">
    
  	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/easyui/easyui.css">
	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/easyui/icons/icon.css">
	<link rel="stylesheet" type="text/css" href="${Config.baseURL }view/demoframe/css/custom/css.css">
	
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/jquery/jquery.min.js"></script>
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/jquery.easyui.min.js"></script>
	
	
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/hello.js"></script>
	<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/fweb_fs.js"></script>
	
	
</head>

<body>
	<div id="divMyPlugin1" class="easyui-hello">
	点我sayHello一次
	</div>
    <div id="divMyPlugin2">
    	点我sayHello三次
    </div>
    <button onclick="invokePluginMethod()">调用插件的方法</button>
    <button onclick="invokePluginExMethod()">调用插件的拓展方法</button>
    <button onclick="$('#divMsg').empty()">Clear</button>
    <div id="divMsg">
         
    </div>
    <script type="text/javascript">
    
    	$(function(){
    		
    		$("#divMsg").wrap('<div id="aaa"></div>');
    		
    		/* $("#divMyPlugin1").hello({
    			to : '恒华',
    			myColor : 'green'
    		}); */
    		
    		$("#divMyPlugin2").hello({
    			to : '恒华',
    			myColor : 'red',
    			repeatTimes : 3,
    			howToSay : customHowToSay
    		});
    		
    		
    	});
 
        function invokePluginMethod() {
            $('#divMyPlugin2').hello('sayHello');
        }
 
        function invokePluginExMethod() {
            $('#divMyPlugin2').hello('sayHi');
        }
 
        function customHowToSay(to) {
            $('<p></p>').html('你好, <span style="color:red">' + to + '<span>!' + new Date().getTime()).appendTo($('#divMsg'));
        }
 
    </script>

	
<script type="text/javascript">
	
</script>

</body>
</html>