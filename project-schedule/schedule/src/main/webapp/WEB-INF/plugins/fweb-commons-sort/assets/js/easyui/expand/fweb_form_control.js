(function($){
    function init(target) {
        //注：此处还不能获取options
 
        //所以这里可以进行一些如设置样式、绑定事件的事情
        //$(target).css('cursor', 'pointer');
 
        /*$(target).bind('click', function (e, preventBubble) {
            $.fn.fwebformcontrol.methods.sayHello($(e.target));
            return false;
        });*/
        return $(target);
    }
 
    //easyui插件函数
    $.fn.fwebformcontrol = function (options, param) {
        //如果options为string，则是方法调用，如$('#divMyPlugin').fwebformcontrol('sayHello');
        if (typeof options == 'string'){
            var method = $.fn.fwebformcontrol.methods[options];
            if (method){
                return method(this, param);
            }else{
            	
            	//获取插件配置信息
            	var controlOptions = $.data($(this)[0], 'fwebformcontrol').options;
            	
            	//匹配插件执行方法
            	if(controlOptions.controlType == 'textbox'){
            		return this.textbox(options, param);
                }else if(controlOptions.controlType == 'combobox'){
                	return this.combobox(options, param);
                }else if(controlOptions.controlType == 'datebox'){
                	return this.datebox(options, param);
                }else if(controlOptions.controlType == 'datetimebox'){
                	return this.datetimebox(options, param);
                }else if(controlOptions.controlType == 'combogrid'){
                	return this.combogrid(options, param);
                }else if(controlOptions.controlType == 'combotree'){
                	return this.combotree(options, param);
                }else if(controlOptions.controlType == 'combotreegrid'){
                	return this.combotreegrid(options, param);
                }else if(controlOptions.controlType == 'checkbox'){
                	return this.checkbox(options, param);
                }else if(controlOptions.controlType == 'radiobox'){
                	return this.radiobox(options, param);
                }else{
                	return this.textbox(options, param);
                }
            	
            }
        }
         
        //否则是插件初始化函数，如$('#divMyPlugin').fwebformcontrol();
        options = options || {};
        return this.each(function(){
            var state = $.data(this, 'fwebformcontrol');
            if (state){
                $.extend(state.options, options);
            } else {
                //easyui的parser会依次计算options、initedObj
                state = $.data(this, 'fwebformcontrol', {
                    options: $.extend({}, $.fn.fwebformcontrol.defaults, $.fn.fwebformcontrol.parseOptions(this), options),
                    initedObj: init(this) //这里的initedObj名称随便取的
                });
            }
            
            var jq = $(this);
            
            if(jq.parent().outerWidth())
            	state.options.width = jq.parent().outerWidth()-15;
            
            if(state.options.labelPosition == 'top'){
            	state.options.height = state.options.height + 22;
            }
            
            //为元素添加插件样式标识
            if(state.options.controlType == 'textbox'){
            	$.fn.textbox.call(jq, state.options);
            }else if(state.options.controlType == 'combobox'){
            	$.fn.combobox.call(jq, state.options);
            }else if(state.options.controlType == 'datebox'){
            	$.fn.datebox.call(jq, state.options);
            }else if(state.options.controlType == 'datetimebox'){
            	$.fn.datetimebox.call(jq, state.options);
            }else if(state.options.controlType == 'combogrid'){
            	$.fn.combogrid.call(jq, state.options);
            }else if(state.options.controlType == 'combotree'){
            	$.fn.combotree.call(jq, state.options);
            }else if(state.options.controlType == 'combotreegrid'){
            	$.fn.combotreegrid.call(jq, state.options);
            }else if(state.options.controlType == 'checkbox'){
            	$.fn.checkbox.call(jq, state.options);
            }else if(state.options.controlType == 'radiobox'){
            	//获取单选按钮的label与value
            	var $data = state.options.data;
            	if($data && $data.length && $data.length>0){
            		//style="text-align: right; width: 200px; height: 32px; line-height: 32px;"
            		//水平分布
            		if(state.options.labelPosition == 'beffore'){
            			this.type = 'hidden';
            			var labelHtml = '<label class="textbox-label textbox-label-beffore"'
											+'style="text-align: '+state.options.labelAlign
											+'; width: '+state.options.labelWidth
											+'px; height: '+state.options.height
											+'px;line-height: '+state.options.height+'px;">'
											+state.options.label
										+'</label>';
            			$(this).parent().append(labelHtml);
            		}
            		
            		var radioHtml = '<span>';
            		
            		for(var i=0,len=$data.length; i<len; i++){
            			if($data[i].checked)
            				this.value = $data[i].value;
            			
            			var radioStr = '<label class="radio-inline">'
            						  +'<input type="radio" value="'+$data[i].value+'" name="'+this.name+'_" '
            						  +($data[i].checked?'checked="checked"':'')+'>'
            						  +$data[i].label
            						  +'</label>';
            			radioHtml+=radioStr;
            		}
            		
            		radioHtml+='</span>';
            		$(this).parent().append(radioHtml);
            		
            		var this_ = this; 
            		$('input[name="'+this_.name+'_"]').change(function(){
            			this_.value = this.value;
            		});
            		
            	}
            	
            	//$.fn.radiobox.call(jq, state.options);
            }else{
            	$.fn.textbox.call(jq, state.options);
            }
            
        });
    };
     
    //设置fwebformcontrol插件的一些方法的默认实现
    //注：第一个参数为当前元素对应的jQuery对象
    $.fn.fwebformcontrol.methods = {
        options: function(jq){
            return $.data(jq[0], 'fwebformcontrol').options;
        },
        setValueTest: function(jq, val){
        	$('input[name="'+jq[0].name+'_"][value="'+val+'"]').prop('checked',true);
        }
    };
     
    //设置参数转换方法
    $.fn.fwebformcontrol.parseOptions = function (target) {
        var opts = $.extend({}, $.parser.parseOptions(target, ['controlType',{data:'array'}]));//这里可以指定参数的类型
        return opts;
    };
     
    //设置fwebformcontrol插件的一些默认值
    $.fn.fwebformcontrol.defaults = {
		labelPosition: 'beffore',
		labelWidth: 100,
		labelAlign: 'right',
		height: 32,
		/*
		 * 可选值
		 * textbox,combobox,datebox,datetimebox,checkbox,
		 * radiobox,combogrid,combotree,combotreegrid...
		 * 
		 * ==============radiobox===========
		 * label:'香蕉',
		 * value:'banana',
		 * checked:true
		 * =================================
		 */
		controlType: 'textbox'
    };
     
    //注册自定义easyui插件fwebformcontrol
    $.parser.plugins.push("fwebformcontrol");
})(jQuery);