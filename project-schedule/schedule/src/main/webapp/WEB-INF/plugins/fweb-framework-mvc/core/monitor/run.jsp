<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%
	// 项目上下文路径
	String contextPath = request.getContextPath();
%>
 
<!DOCTYPE html>
<html>
    <head>
        <meta charset="utf-8" />
        <link rel="shortcut icon" href="${config.base() }fweb-framework-ui/style/icons/fweblogo.ico" type="image/x-icon" />
        <title>Fweb3负载状态监控</title>
        <style>
            .node_right {
              font: 12px sans-serif;
            }
			.node_left {
              font: 12px sans-serif;
            }
			.node_root {
              font: 12px sans-serif;
            }

            .link_right {
              fill: none;
              stroke: #ccc;
              stroke-width: 1.5px;
            }
            .link_left {
              fill: none;
              stroke: #ccc;
              stroke-width: 1.5px;
            }
			.link_root {
              fill: none;
              stroke: #ccc;
              stroke-width: 1.5px;
            }
        </style>
    </head>
    <body style="background:  url(<%=contextPath %>/../fweb-framework-ui/style/images/bg.jpg) repeat;width:100%;height:600px;text-align:center;" >
	<div>
	<div  id="plugin_run_map">
		
	</div>
	</div>
	<script type="text/javascript" src="<%=contextPath %>/../fweb-framework-ui/js/d3.js"></script>
    <script type="text/javascript" src="<%=contextPath %>/../fweb-framework-ui/js/jquery.min.js"></script>
    <script>
        var width = 900, 						//svg的宽
			height = 700,						//svg的高
			halfWidth = width/2,	
			firstChildHeight = 30,				//一级子节点的高
			firstChildWidth = 100, 				//一级子节点的宽
			secondChildHeigth = 30,				//二级子节点的高
			secondChildWidth = 100;				//二级子节点的高
			rootHeigth = 50,					//根节点的高
			rootWidth = 100,					//根节点的高
			idelColor = "#6cbf00",				//空闲颜色
			busyColor = "#d7ad0d",				//繁忙颜色
			overLoadColor = "#e35b5f",			//超负荷颜色
			linearGradientWidth = width-200,	//线性渐变比例尺宽度
			linearGradientHeight = 30,			//线性渐变比例尺高度
			linearGradientX = 150,				//线性渐变比例尺开始横坐标
			linearGradientY = 50,				//线性渐变比例尺开始纵坐标
			linearGradientYbWidth = 30,			//线性渐变比例尺游标宽度
			linearGradientYbHeight = 20,		//线性渐变比例尺游标高度
			busyMin = 800,						//繁忙最小值
			overLoadMin = 1600,					//超负荷最小值
			buttomRectWidth = 100,				//底部图例宽度
			buttomRectHeight = 20,				//底部图例高度
			mainBgMl = 50,						//主体背景左边距
			mainBgMr = 50,						//主体背景右边距
			mainBgMt = 50,						//主体背景右边距
			mainBgMb = 100;						//主体背景右边距
			
		var switchCount = 2;
		var dataFlowDuration = "2s";			//数据流向持续时间
		var plugins = {};
 

        var tree = d3.tree()
        .size([height-300, halfWidth-250]);
			
		var rootNode;		//根节点
		var offset;			//左侧树与右侧树的偏移量
		var totalRequest;	//系统的总负载
		
		//定义随机数
		var randomDataAccessQuantity = d3.randomUniform(3000);
		
		//定义颜色比列尺(value<0：#00FF00，0<=value<100：#CD950C，value>=100：#CD5B45)
		var color = d3.scaleThreshold()
						.domain([busyMin, overLoadMin])
						.range([idelColor, busyColor, overLoadColor]);
		
		//定义线性比例尺（内核专用）
		var coreColor = d3.scaleLinear()
			.domain([0, busyMin, overLoadMin])
			.range([idelColor, busyColor, overLoadColor]);
		console.log(coreColor(0));
		console.log(coreColor(99));
		console.log(coreColor(400));
		console.log(coreColor(800));
		console.log(coreColor(1200));
		console.log(coreColor(1600));
		console.log(coreColor(2400));
		
		//定义层次操作符
		var stratify = d3.stratify()
						.id(function(d){
							return d.name;
						})
						.parentId(function(d) {
							return d.parent 
						});
						
		//定义缩放平移函数
		var zoom = d3.zoom()  
					.scaleExtent([1,3])//用于设置最小和最大的缩放比例  
		
	 
		
		//绘制有20个一级子节点的系统运行图
		//drawSystemDiagram(getData(20));
		
		//绘制系统运行图
		function drawSystemDiagram($data){
			//每次加载运行图时删除原先的svg
			d3.select("#plugin_run_map").selectAll("svg").remove();
			var svg = d3.select("#plugin_run_map").append("svg")
						.attr("width", width)
						.attr("height", height)
						<!-- .attr("style",function(){ -->
							<!-- return "background: url(bg.jpg) repeat;<!-- background-size:"+width+"px "+height+"px; -->"; -->
						<!-- }) -->
						<!-- .call(zoom) -->
			
			
			//绘制头部和底部图片
			drawTop();
			drawButtom();
			
			var svg = d3.select("#plugin_run_map").selectAll("svg")
						.append("g")
						.attr("id","mianP")
						.attr("transform", "translate("+halfWidth+",150)")
			
						
			if($data==null || $data.length==0){
				return;
			}
			var nodes = stratify($data);
			  
			//存放左侧树的菜单
			var tempData = nodes.copy();
			//存放右侧树的菜单
			var tempData2 = nodes.copy();
			  
			if(nodes.children && nodes.children.length>0){
				tempData.children=nodes.children.slice(0,nodes.children.length/2);
				tempData2.children=nodes.children.slice(nodes.children.length/2,nodes.children.length);
			}
			
			//获取右侧树节点路径集合
			var rightDataLinks = getLinks(tempData);
			//获取左侧树节点路径集合
			var leftDataLinks = getLinks(tempData2);
				  
			offset = (tempData.x&&tempData2.x)?tempData.x - tempData2.x:0;

			treeLayout(svg,rightDataLinks,tempData,'right');
			treeLayout(svg,leftDataLinks,tempData2,'left');
			
			//绘制箭头
			drawArrowMarker(svg);
				
			var coreNode = svg.selectAll(".node_root")
				  .data(rootNode)
				  .enter()
				  .append("g")
				  .attr("class", "node_root")
				  .attr("transform", function(d) {
						return "translate(" + (d.y-rootWidth/2) + "," + (d.x-rootHeigth/2) + ")"; 	
				  })

			coreNode.append("rect")
					.attr("width",rootWidth)
					.attr("height",function(d){
						return rootHeigth;
					})
					.attr("x",0)
					.attr("y",0)
					.attr("rx",5)
					.attr("ry",5)
					.attr("style","fill:"+idelColor+";fill-opacity:1;");

			coreNode.append("text")
					.attr("dx", function(d) { 
						return rootWidth/2;
					})
					.attr("dy", rootHeigth/2+4)
					.style("text-anchor", function(d) { 
						return "middle";
					})
					.style("fill","#000")
					.text(function(d) { 
						return d.data.name; 
					});
					
		}
		
		//绘制头部图片
		function drawTop(){
			var svg = d3.select("#plugin_run_map").selectAll("svg");
			
			svg.append("text")
				.attr("dx", function(d) { 
					return linearGradientX-50;
				})
				.attr("dy", linearGradientY+20)
				.style("text-anchor", function(d) { 
					return "middle";
				})
				.style("fill","#fff")
				.text('<spring:message code="i18n.sys.runState" />：');
			
			//定义一个三种颜色的线性渐变
			var linearGradientDefs = svg.append("defs");

			var linearGradient = linearGradientDefs.append("linearGradient")
									.attr("id","linearColor")
									.attr("x1","0%")
									.attr("y1","0%")
									.attr("x2","100%")
									.attr("y2","0%");

			var stop1 = linearGradient.append("stop")
							.attr("offset","0%")
							.style("stop-color",idelColor);

			var stop2 = linearGradient.append("stop")
							.attr("offset","50%")
							.style("stop-color",busyColor);
							
			var stop2 = linearGradient.append("stop")
							.attr("offset","100%")
							.style("stop-color",overLoadColor);
			
			//添加一个矩形，并应用线性渐变
			var colorRect = svg.append("rect")
							.attr("x", linearGradientX)
							.attr("y", linearGradientY)
							.attr("width", linearGradientWidth)
							.attr("height", linearGradientHeight)
							.style("fill","url(#" + linearGradient.attr("id") + ")");
				
			var pathOffest=(totalRequest/overLoadMin)>=1?linearGradientWidth:(totalRequest/overLoadMin)*linearGradientWidth;
			totalRequest = coreColor>=overLoadMin?overLoadMin:totalRequest;
			
			var lineGenerator = d3.line();
			var points = [
						  [linearGradientX+pathOffest, linearGradientY+linearGradientHeight],
						  [linearGradientX+pathOffest, linearGradientY],
						  [linearGradientX-linearGradientYbWidth/2+pathOffest, linearGradientY-linearGradientYbHeight],
						  [linearGradientX+linearGradientYbWidth/2+pathOffest, linearGradientY-linearGradientYbHeight],
						  [linearGradientX+pathOffest, linearGradientY]
						];
						
			var pathData = lineGenerator(points);
			svg.select("#gYb").remove();
			//游标的路径
			var pathYb = svg.append('g')
							.attr("id","gYb")
							.append("path")
							.attr("id","pathYb")
							.attr('d', pathData)
							.attr("style",function(){
								return "stroke:#fff;fill:#fff;fill-opacity:1;stroke-width:2";
							})
							.on('mouseover',function(){
								svg.select("#coreColorText").remove();
								svg.append("text")
									.attr("dx", function(d) { 
										return linearGradientX-linearGradientYbWidth/2+pathOffest;
									})
									.attr("dy", linearGradientY-linearGradientYbHeight-10)
									.style("text-anchor", function(d) { 
										return "middle";
									})
									.attr("id","coreColorText")
									.style("fill","#fff")
									.text(totalRequest);
							})
							.on('mouseout',function(){
								svg.select("#coreColorText").remove();
							});
			
			//绘制主体的背景
			var mainPoints = [
				[mainBgMl, linearGradientY+linearGradientHeight+mainBgMt],
				[width-mainBgMr, linearGradientY+linearGradientHeight+mainBgMt],
				[width-mainBgMr, height-100-25],
				[mainBgMl, height-100-25],
				[mainBgMl, linearGradientY+linearGradientHeight+mainBgMt]
			];
			var mainPathData = lineGenerator(mainPoints);
			svg.select("#gMain").remove();
			//主体的路径
			var pathYb = svg.append('g')
							.attr("id","gMain")
							.append("path")
							.attr("id","pathMain")
							.attr('d', mainPathData)
							.attr("style",function(){
								return "stroke:#000;fill:#000;fill-opacity:0.3;stroke-width:0";
							});
			
		}
			  
		//绘制底部图片
		function drawButtom(){
			var svg = d3.select("#plugin_run_map").selectAll("svg");
				
			svg.append("text")
				.attr("dx", function(d) { 
					return linearGradientX;
				})
				.attr("dy", height-100+20-4)
				.style("text-anchor", function(d) { 
					return "middle";
				})
				.style("fill","#fff")
				.text('<spring:message code="i18n.sys.ideal" />');
			svg.append("rect")
				.attr("width",buttomRectWidth)
				.attr("height",function(d){
					return buttomRectHeight;
				})
				.attr("x",(linearGradientX)+40)
				.attr("y",height-100)
				.attr("style","fill:"+idelColor+";fill-opacity:1;");
			svg.append("text")
				.attr("dx", function(d) { 
					return linearGradientX+(2*buttomRectWidth);
				})
				.attr("dy", height-100+20-4)
				.style("text-anchor", function(d) { 
					return "middle";
				})
				.style("fill","#fff")
				.text('<spring:message code="i18n.sys.busy" />');
			svg.append("rect")
				.attr("width",buttomRectWidth)
				.attr("height",function(d){
					return buttomRectHeight;
				})
				.attr("x",linearGradientX+2*buttomRectWidth+40)
				.attr("y",height-100)
				.attr("style","fill:"+busyColor+";fill-opacity:1;");
			svg.append("text")
				.attr("dx", function(d) { 
					return linearGradientX+4*buttomRectWidth;
				})
				.attr("dy", height-100+20-4)
				.style("text-anchor", function(d) { 
					return "middle";
				})
				.style("fill","#fff")
				.text('<spring:message code="i18n.sys.overload" />');
			svg.append("rect")
				.attr("width",buttomRectWidth)
				.attr("height",function(d){
					return buttomRectHeight;
				})
				.attr("x",linearGradientX+4*buttomRectWidth+50)
				.attr("y",height-100)
				.attr("style","fill:"+overLoadColor+";fill-opacity:1;");
					
		}
			  
		//绘制箭头
		function drawArrowMarker($svg){
			var defs = $svg.append("defs");

			var arrowMarker = defs.append("marker")
								.attr("id","arrow")
								.attr("markerUnits","strokeWidth")
								.attr("markerWidth","10")
								.attr("markerHeight","20")
								.attr("viewBox","0 0 12 12") 
								.attr("refX","10")
								.attr("refY","6")
								.attr("orient","auto");
			var arrow_path = "M2,2 L10,6 L2,10 L6,6 L2,2";  
							  
			arrowMarker.append("path")  
				.attr("d",arrow_path)  
				.attr("fill","#fff");
		}
		
		//绘制子节点
		function treeLayout($svg,$tempDataLinks,$tempData,$classSuffix){
			if($tempData==null || $tempData.children==null || $tempData.children.length==0){
				return;
			}			
			var rootLink = $svg.selectAll(".link_"+$classSuffix)
								.data($tempDataLinks)
								.enter()
								.append("path")
								.attr("class", "link_"+$classSuffix)
								.attr("d", d3.linkHorizontal()
												.x(function(d) { 
													return $classSuffix=='left'?-d.y:d.y; 
												})
												.y(function(d) {
													return $classSuffix=='left'?d.x+offset:d.x; 
												}))
								.attr("style",function(){
									return "stroke:#fff"
								})
								.attr("id",function(d,i){
									return "path_"+$classSuffix+i;
								})
								.attr("marker-end","url(#arrow)");
			  
			rootLink.each(function(d,i){
				if(d.target.data.dataAccessQuantity > 0){
					 
					//添加圆圈
					var color_ = color(d.target.data.dataAccessQuantity);
				 
					var circle = $svg.append("circle")
						.attr("r", 5)
						.attr("id","circle_"+$classSuffix+i)
						.attr("cx",0)
						.attr("cy",0)
						.attr("style","fill:"+color_+";fill-opacity:1");
				  
					var animateMotion = $svg.append("animateMotion")
						.attr("xlink:href", "#circle_"+$classSuffix+i)
						.attr("dur","1s")//dataFlowDuration
						.attr("begin","0s")
						.attr("fill","freeze")
						.attr("repeatCount",1.1);//"indefinite"
						
					animateMotion.append("mpath")
						.attr("xlink:href","#path_"+$classSuffix+i);
				}
			})
								
			
			var nodeDataArray = $tempData.descendants().filter(nda => nda.depth != 0);
		  
			//获取根节点
			if(!rootNode){
				rootNode = $tempData.descendants().filter(nda => nda.depth == 0);
			}  
		  
			var heightPercent = (nodeDataArray.length<5)?1.5:3*nodeDataArray.length/10;
			var childNode = $svg.selectAll(".node_"+$classSuffix)
								.data(nodeDataArray)
								.enter()
								.append("g")
								.attr("class", "node_"+$classSuffix)
								.attr("transform", function(d) {
									if($classSuffix=='left'){
										return "translate(" 
											+ (-d.y-firstChildWidth) 
											+ ","
											+ (d.x+offset-firstChildHeight/heightPercent)
											+ ")"; 
									}else{
										return "translate(" 
										+ (d.y) + "," 
										+ (d.x -firstChildHeight/heightPercent) 
										+ ")"; 	
									}
								});

			childNode.append("rect")
						.attr("width",firstChildWidth)
						.attr("height",function(d){
							return 2*firstChildHeight/heightPercent;
						})
						.data(nodeDataArray)
						.attr("x",0)
						.attr("y",0)
						.attr("rx",5)
						.attr("ry",5)
						.attr("style",function(d,i){
							//设置节点填充颜色及透明度
							return "fill:"+color(d.data.dataAccessQuantity)+";fill-opacity:1;"
						});	

			childNode.append("text")
						.attr("dx", function(d) {
							return firstChildWidth/2;
						})
						.attr("dy", firstChildHeight/heightPercent+4)
						.style("text-anchor", function(d) { 
							return "middle";
						})
						.style("fill","#000")
						.text(function(d) {
							return d.data.name; 
						});
		}
		
		//获取数据
		function getData(){
		     var currentRunData = {};
			  $.ajax({
	              type: 'GET',
	              url: "<%=contextPath%>/system/systemload",
	              async: false,
	              success: function(d){
	            	  currentRunData = d;
	              }
	          });
			   
			var pluginData = [];
			for(var p in plugins){
				if(p=='core'){
					var requestCount = 0;
					if(currentRunData[p]){
						requestCount = currentRunData[p].requestCount;
					}
					var rootNodeObj = {
						name : "内核",
						parent : null,
						dataAccessQuantity : requestCount,
						total : currentRunData['total']
					};
					pluginData.push(rootNodeObj);
				}else if(p == 'total'){
					totalRequest = currentRunData.total;
				}else{
					 
					var dataAccessQuantity = 0;
				 
					if(currentRunData[plugins[p].pluginId]){
						dataAccessQuantity = currentRunData[plugins[p].pluginId].requestCount
					}
					
					var childNode = {
						name : p,
						parent : '内核',
						dataAccessQuantity : dataAccessQuantity
					};
					pluginData.push(childNode);
				}
			}
			console.log(pluginData)
			return pluginData;
		}
		
		//获取路径信息
		function getLinks($tempData){
			
			if($tempData==null || $tempData.children==null || $tempData.children.length==0){
				return [];
			}
			
			var tempDataLinks = tree($tempData).links();
		  
			for(var i=0;i<tree($tempData).links().length;i++){
				var depth = tempDataLinks[i].source.depth;
				if(depth==0){
					tempDataLinks[i].source=$tempData;
				}
			}
			return tempDataLinks;
		}

		//插件初始化
		function pluginsInit(){
			plugins = {"core": {
				"pluginId":'core',
				"countTime": "2017-11-27 08:59:29",
				"requestCount": 0,
				"urls": []
				},
		   "total": 0}
			
			  $.ajax({
	              type: 'GET',
	              url: "<%=contextPath%>/plugin/list?state=ACTIVE",
	             async: false,
	              success: function(d){
	                  $(d).each(function(){
	                	  plugins[this.pluginName+""] = {};
	                	  plugins[this.pluginName+""].requestCount =0;
	                	  plugins[this.pluginName+""].pluginId = this.pluginId;
	                  });
	              }
	          });
		}
		
	
		 pluginsInit();
		 drawSystemDiagram(getData());  
	     setInterval(function(){ 
			 
		 drawSystemDiagram(getData());
		  }, 4*1000);  
	     
	     //15秒检测一次插件是否变化
	     setInterval(function(){  
	    	 pluginsInit();
		 }, 15*1000);
		
		//缩放平移设置
		function zoomed(){  
			d3.select("#plugin_run_map").selectAll("svg").attr("transform",d3.event.transform);
		} 
    </script>

    </body>
</html>
