(function($){
    function init(target) {
        //注：此处还不能获取options
 
        //所以这里可以进行一些如设置样式、绑定事件的事情
        //$(target).css('cursor', 'pointer');
 
        /*$(target).bind('click', function (e, preventBubble) {
            $.fn.searchlayout.methods.sayHello($(e.target));
            return false;
        });*/
 
        return $(target);
    }
 
    //easyui插件函数
    $.fn.searchlayout = function (options, param) {
        //如果options为string，则是方法调用，如$('#divMyPlugin').searchlayout('sayHello');
        if (typeof options == 'string'){
            var method = $.fn.searchlayout.methods[options];
            if (method){
                return method(this, param);
            }
        }
         
        //否则是插件初始化函数，如$('#divMyPlugin').searchlayout();
        options = options || {};
        return this.each(function(){
            var state = $.data(this, 'searchlayout');
            if (state){
                $.extend(state.options, options);
            } else {
                //easyui的parser会依次计算options、initedObj
                state = $.data(this, 'searchlayout', {
                    options: $.extend({}, $.fn.searchlayout.defaults, $.fn.searchlayout.parseOptions(this), options),
                    initedObj: init(this) //这里的initedObj名称随便取的
                });
            }
            
            //为元素添加插件样式标识
            if(!$(this).hasClass('easyui-searchlayout'))
            	$(this).addClass('easyui-searchlayout');
            	
        	var layoutClass = 'col-md-'+(state.options.col? state.options.col : 6);
            $(this).addClass(layoutClass);
            $(this).css('padding-bottom',state.options.paddingBottom);
        });
    };
     
    //设置hello插件的一些方法的默认实现
    //注：第一个参数为当前元素对应的jQuery对象
    $.fn.searchlayout.methods = {
        options: function(jq){
            return $.data(jq[0], 'searchlayout').options;
        }
    };
     
    //设置参数转换方法
    $.fn.searchlayout.parseOptions = function (target) {
        var opts = $.extend({}, $.parser.parseOptions(target, ['col',{paddingBottom: 'number'}]));//这里可以指定参数的类型
        return opts;
    };
     
    //设置hello插件的一些默认值
    $.fn.searchlayout.defaults = {
        col: '6',
        paddingBottom: 4
    };
     
    //注册自定义easyui插件hello
    $.parser.plugins.push("searchlayout");
})(jQuery);