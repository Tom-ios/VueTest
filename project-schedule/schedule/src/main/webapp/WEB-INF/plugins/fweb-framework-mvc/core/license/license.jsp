<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	// 项目上下文路径
	String contextPath = request.getContextPath();
%>
<!DOCTYPE html><html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<title>授权信息</title>
<!-- Tell the browser to be responsive to screen width -->
<meta
	content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no"
	name="viewport">

<link rel="stylesheet" href="<%=contextPath %>/../fweb-framework-ui/style/css/bootstrap.min.css">

<script src="<%=contextPath %>/../fweb-framework-ui/js/jquery.min.js"></script>
<script src="<%=contextPath %>/../fweb-framework-ui/js/bootstrap.min.js"></script>

<style type="text/css">
.fweb_introduction_r {
    height: 550px;
    z-index: 0;
    top: 50%;
    margin-top: 50px;
    background: url(<%=contextPath %>/../fweb-framework-ui/style/images/zhongjiao.png) center no-repeat;
        background-size: auto auto;
    background-size: contain;
}
.pt_15{
	 padding-top: 15px;
}
.license_introduction_info {
	border-bottom: 2px solid #aeaeae;padding-left: 0px;
	margin-left: 15px;
	margin-bottom: 0px;
	height: 32px;
}
.license_introduction_info span {
	border-bottom: 2px solid #1e5c9b;
	line-height: 30px;
	float: left !important;
	color: #1e5c9b;
}
.pl_0 {
	padding-left: 0px;
}
</style>

</head>
<body class="">
	<div class="wrapper">
		<div class="col-md-5 fweb_introduction_r">
			
		</div>
		<div class="col-md-7" style="">
			<div class="col-md-12">
				<span class="" style="line-height: 118px;float: left !important;">
					<img style="" src="<%=contextPath %>/../fweb-framework-ui/style//images/zhongjiaologo.png" alt="fweb网站logo" class="pb-10">
					</img>
				</span>
				<span class="" style="line-height: 140px;float: left !important;padding-left: 25px;color: #1e5c9b;">
					WAF 平台（v6.0.0）
				</span>
			</div>
			<div class="col-md-11 license_introduction_info">
				<span>基本信息</span>
			</div>
			<div class="col-md-11" style="padding: 15px 0px 15px 0px;">
				<div class="col-md-12">
					<span class="col-md-6 pl_0">申请人：</span>
					<span class="col-md-6">公司：中国交建</span>
					<span class="col-md-6 pl_0">电话：82016562</span>
					<span class="col-md-6">eamil：231434wre@163.com</span>
					<span class="col-md-6 pl_0">申请时间：2017年1月1日</span>
					<span class="col-md-6">license类型：普通</span>
					<span class="col-md-6 pl_0">到期时间：2027年1月1日</span>
				</div>
			</div> 	
			<div class="col-md-11 license_introduction_info">
				<span>授权信息</span>
			</div>
			<div class="col-md-11">				
				<p class="pt_15">本“软件”是由公司开发。“软件”的一切版权、商标权、专利权、商业秘密等知识产权，以及与“软件”相关的所有信息内容，包括但不限于：文字表述及其组合、图标、图饰、图表、色彩、界面设计、版面框架、有关数据、印刷材料、或电子文档等均受中华人民共和国著作权法、商标法、专利法、反不正当竞争法和相应的国际条约以及其他知识产权法律法规的保护，除涉及第三方授权的软件或技术外，公司享有上述知识产权。</p>
			</div> 	
			<div class="col-md-11 license_introduction_info">
				<span>最终用户权利</span>
			</div>
			<div class="col-md-11">
				<ol style="padding: 15px 0px 15px 15px;">
					<li>根据使用的要求把软件装入计算机内，但是在同一时间只能在一台机器上运行，不得同时在多台机器上使用</li>
					<li>为防止许可软件损坏而制作许可软件的备份复制品，但必须保证许可软件上所有的本公司名称、商标标识、版权标识、版权声明及其他权属标志或声明同时被复制</li>
					<li>为进行许可软件的操作培训而复制用户手册，或将许可软件磁盘或光盘上的许可资料打印输出，但必须保留上述资料中所有的本公司名称、商标标识、版权标识、版权声明及其他权属标志或声明</li>
				</ol>
			</div>
			<div class="col-md-11 license_introduction_info">
				<span>最终用户不得</span>
			</div>
			<div class="col-md-11">
				<ol style="padding: 15px 0px 15px 15px;">
					<li>将软件或其使用权利，有偿或无偿向其他单位或个人销售、转租、转借、转让或提供分许可、转许可</li>
					<li>向其他单位或个人提供软件或资料的复制品</li>
					<li>对软件作改变、反编译、反汇编等反向工程处理</li>
					<li>除掉或掩盖有关软件著作权或商标的标志</li>
					<li>超过本协议允许复制份数的复制</li>
				</ol>
			</div> 			
			<div class="col-md-11 license_introduction_info">
				<span>终止</span>
			</div>
			<div class="col-md-11">
				<p class="pt_15">如果您不遵守条款和条件，则在不损害任何其他权利的情况下，WAF可以终止本服务。终止后，您或您的代表必须销毁软件产品及其所有组件的所有副本。</p>
			</div> 	
		</div>
	</div>
</body>
</html>