<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>demo</title>
	
<link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo-16.ico" type="image/x-icon" />

<link rel="stylesheet" href="${Config.baseURL }view/demoframe/css/bootstrap.min.css">

<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/easyui/jquery/jquery.min.js"></script>
<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/bootstrap.min.js"></script>
<script type="text/javascript" src="${Config.baseURL }view/demoframe/js/fweb_fs.js"></script>

</head>
<body>
<div id="fsdoc" style="width: 100%; height: 100%;">
	<div>
		<button onclick="handleFullScreen()">全屏切换</button>
	</div>
	<p>测试字体尺寸全局生效</p>
</div>

<!-- <div class="container-fluid">
	<div class="row" style="border: 1px solid green; width: 300px; height: 300px; margin-left: 300px;">
		<div class="col-md-4" style="border: 1px solid red; height: 50%;"></div>
		<div class="col-md-4" style="border: 1px solid red; height: 50%;"></div>
		<div class="col-md-4" style="border: 1px solid red; height: 50%;"></div>
		<div class="col-md-4" style="border: 1px solid red; height: 50%;"></div>
		<div class="col-md-4" style="border: 1px solid red; height: 50%;"></div>
		<div class="col-md-4" style="border: 1px solid red; height: 50%;"></div>
	</div>
</div> -->

</body>

<script>
$(function(){
	FSTool.setFontSize4Dom(FSTool.getLocalStorage('font-size'),
			document.getElementsByTagName('body')[0]);
});

function handleFullScreen() {
    if (checkFull()) {
        exitFull();
    } else {
        requestFullScreen();
    }
}

function checkFull(){
	return document.fullscreenElement
			|| document.msFullscreenElement
			|| document.mozFullScreenElement
			|| document.webkitFullscreenElement 
			|| false;
}

/* 退出全屏 判断浏览器种类 */
function exitFull() {
    // 判断各种浏览器，找到正确的方法
    var exitMethod = document.exitFullscreen || //W3C
        document.mozCancelFullScreen ||    //Chrome等
        document.webkitExitFullscreen || //FireFox
        document.webkitExitFullscreen; //IE11
    if (exitMethod) {
        exitMethod.call(document);
    }
    else if (typeof window.ActiveXObject !== "undefined") {//for Internet Explorer
        var wscript = new ActiveXObject("WScript.Shell");
        if (wscript !== null) {
            wscript.SendKeys("{F11}");
        }
    }
}

function requestFullScreen() {
    //var de = document.documentElement;
    var de = document.getElementById('fsdoc');
    //var de = document.getElementById('content-wrapper');

    if (de.requestFullscreen) {
        de.requestFullscreen();
    } else if (de.mozRequestFullScreen) {
        de.mozRequestFullScreen();
    } else if (de.webkitRequestFullScreen) {
        de.webkitRequestFullScreen();
    } else if (de.msRequestFullscreen){
    	de.msRequestFullscreen();
    } else if (typeof window.ActiveXObject !== "undefined"){
    	var wscript = new ActiveXObject("WScript.Shell");
        if (wscript !== null) {
            wscript.SendKeys("{F11}");
        }
    }
    else {
        //App.alert({message: "该浏览器不支持全屏！", type: "danger"});
    	alert("该浏览器不支持全屏！");
    }

}

</script>

</html>