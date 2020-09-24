var fwebFormNav = new FmNav()

function FwebForm() {
  this.param = fwebFormNav.getPageParams()
  this.basePath = getFwebFormBase() + 'fweb-form/'
  this.base = getFwebFormBase()
  this.fmNav = fwebFormNav
  this.init = function() {
  } // 定义初始化控件的规则（主要是控件初始化的顺序）
  this.link = {
    // 弹出打开
    openWindows: function(windowId, url, windowTitle, windowWidth, windowHeight, closeWindowAction, closeWindowBackParam) {
      fwebFormNav.toWindow(windowId, url, windowTitle, windowWidth, windowHeight, closeWindowAction, closeWindowBackParam)
    },
    // 页签打开
    openPageTab: function(url) {
    },
    // 新页打开
    openPage: function(url) {
      window.open(url)
    },
    // 本页打开，默认采用导航的方式
    openThisPage: function(url) {
      window.location.href = url
      // fwebFormNav.toPage(url);
    },
    closeWindow: function() {
      try {
        // 添加外部脚本执行处理
        var pageParams = new FwebForm().param
        if (pageParams && pageParams.callbackscript) {
          window.top.eval(pageParams.callbackscript)
        }

        var windowId = top.document.getElementsByClassName('modal fade in')[[top.document.getElementsByClassName('modal fade in').length - 1]].id
        var windowIdScript = windowId + 'script'
        top.$('#' + windowId).modal('hide')
        top.$(document.getElementsByClassName('modal-backdrop fade in')).remove()
        eval('top.document.scripts.' + windowIdScript + '.remove()')
        top.$('#' + windowId).remove()
      } catch (e) {
        console.log('关闭弹框失败', e)
      }
    },
    // 参数回调方法
    callbackParam: function(closeWindowBackParam, windowIframeId) {
      fwebFormNav.callbackParam(closeWindowBackParam, windowIframeId)
    }
  }
  this.getUUID = function() {
    return (this.S4() + this.S4() + this.S4() + this.S4() + this.S4() + this.S4() + this.S4() + this.S4())
  }
  this.S4 = function() {
    return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1)
  }
  this.SUM = function() {
    if (!data || !key) {
      return null
    }

    var sum = 0

    if (Array.isArray) {
      if (Array.isArray(data)) {
        if (data.length > 0) {
          for (var i of data) {
            if (i[key]) {
              sum += i[key]
            }
          }
        }
      }
    }

    return sum
  }
  this.MAX = function() {

  }
  this.MIN = function() {

  }
  this.AVERAGE = function() {

  }
  this.LOWER_CASE = function() {

  }
  this.UPPER_CASE = function() {

  }
  this.FORMATE_ARRAY = function(data, key, split) {
    if (!data || !key || !split) {
      return null
    }

    var format = ''

    if (Array.isArray) {
      if (Array.isArray(data)) {
        if (data.length > 0) {
          for (var i of data) {
            if (i[key]) {
              format += i[key] + split
            } else {
              format += split
            }
          }
        }
      }
    }

    if (format) {
      format = format.substring(0, format.length - 1)
    }

    return format
  }
}

/**
 *
 *  FmNav 表单导航工具
 *
 *  @author linyu
 *  @date   2019-10-25
 *
 */
function FmNav() {
  this.pageInfo = [],
  this.getPageInfo = function(pageInfo) {
    this.pageInfo = []

    if (pageInfo) {
      var prePageInfo = new Base64().decode(pageInfo)
      this.pageInfo = JSON.parse(prePageInfo)
    }

    var curPageInfo = {
      title: document.title,
      path: window.location.href
    }

    this.pageInfo.push(curPageInfo)

    return this.pageInfo
  },
  /**
         * 描述：初始化当前页面信息
         */
  this.init = function(id) {
    // 获取当前页面的导航信息
    var urlStr = window.location.href
    // 获取页面参数
    var pageParams = this.getPageParams()
    var pi = ''
    if (pageParams && pageParams.pageInfo) {
      pi = pageParams.pageInfo
    }
    this.pageInfo = this.getPageInfo(pi)

    if (id) {
      this.generateNav(id)
    }
  },
  this.generateNav = function(id) {
    var pageInfo = this.pageInfo

    if (pageInfo && pageInfo.length > 1) {
      var html = '<div class="fm-path-nav"><a href="javaScript:fwebFormNav.goback()" style="padding: 0px 9px; background: url(http://fweb.hhwy.org:80/fweb/fweb-framework-ui/style/icons/goback.svg) no-repeat #fff;"></a>'
      var index = pageInfo.length - 1
      for (var i = 0; i < pageInfo.length; i++) {
        if (i == index) {
          html += '<h3 class="box-title">' + pageInfo[i].title + '</h3>'
        } else {
          html += '<a class="box-title" href="' + pageInfo[i].path + '">' + pageInfo[i].title + '</a>&nbsp;' +
                            '<i class="fa fa-angle-right" aria-hidden="true"></i>&nbsp;'
        }
      }

      html += '</div>'
      if (html) {
        $('#' + id).append(html)
      }
    }
  },
  /**
         * 描述：跳转到新页面
         *
         * 参数：
         *    url    跳转页面的地址
         */
  this.toPage = function(url) {
    var pageInfo = ''
    if (this.pageInfo && this.pageInfo.length > 0) {
      pageInfo = new Base64().encode(JSON.stringify(this.pageInfo))
    }
    if (url) {
      if (this.existPageParam(url)) {
        window.location.href = url + '&pageInfo=' + pageInfo + '&1=1'
      } else {
        window.location.href = url + '?pageInfo=' + pageInfo + '&1=1'
      }
    }
  },
  /**
         * 描述：弹窗到新页面
         *
         * 参数：
         *    url    跳转页面的地址
         */
  this.toWindow = function(windowId, url, windowTitle, windowWidth, windowHeight, closeWindowAction, closeWindowBackParam) {
    var nowWindowWidth = windowWidth
    var nowWindowHeight = windowHeight
    if (nowWindowWidth == '') {
      nowWindowWidth = 700
    }
    if (windowWidth.indexOf('%') != -1) {
      nowWindowWidth = $(top.window).width() * (parseFloat(windowWidth) / 100)
    }
    if (nowWindowHeight == '') {
      nowWindowHeight = 500
    }
    if (windowHeight.indexOf('%') != -1) {
      nowWindowHeight = $(top.window).height() * (parseFloat(windowHeight) / 100)
    }
    if (windowTitle == '') {
      windowTitle = '标题'
    }

    // 编辑脚本片段
    var js = ''
    var funcName = 'loadDialog' + windowId
    // 如果宽高为百分比，添加监听事件
    js += '$(window).resize(function() {'
    if (windowWidth.indexOf('%') != -1) {
      js += '$(".modal-content").css("width", $(top.window).width()*' + (parseFloat(windowWidth) / 100) + '+"px");'
      js += 'var modalWidth=$(top.window).width() / 2 - ($(top.window).width()*' + (parseFloat(windowWidth) / 100) + ')/ 2; '
      js += " $('#" + windowId + "dialog').css(   "
      js += "  'margin-left', modalWidth); "
    }
    if (windowHeight.indexOf('%') != -1) {
      js += '$(".modal-content").css("height", $(top.window).height()*' + (parseFloat(windowHeight) / 100) + '+"px");'
      js += "var modalHeight=$(top.window).height() / 2 - $('#" + windowId + " .modal-dialog').height() / 2; "
      js += " $('#" + windowId + "dialog').css(   "
      js += "  'margin-top', modalHeight); "
    }
    js += '});'
    // 设置模态框居中和打开
    js += ' function ' + funcName + '(){'
    js += "$('#" + windowId + "').on('show.bs.modal', function (e) { "
    js += "$(this).css('display', 'block'); "
    js += "var modalHeight=$(top.window).height() / 2 - $('#" + windowId + " .modal-dialog').height() / 2; "
    js += 'var modalWidth=$(top.window).width() / 2 - ' + nowWindowWidth + '/ 2; '
    js += " $(this).find('.modal-dialog').css({   "
    js += "  'margin-top': modalHeight,'margin-left': modalWidth, "
    js += '   });  '
    js += '});'
    js += '$("#' + windowId + '").modal("show");'
    // 隐藏阴影背景
    js += 'window.top.$(".modal-backdrop").hide();'
    // 设置弹出框可拖动
    js += 'top.$("#' + windowId + '").css("overflow", "hidden");'
    // 注册监听
    js += '$("#' + windowId + '").on("hide.bs.modal", function (e) {'
    if (closeWindowBackParam) {
      js += 'window.top.document.getElementById(\'' + windowId + 'Iframe\').contentWindow.eval(\'new FwebForm().link.callbackParam(' + closeWindowBackParam + ')\');'
    }
    if (closeWindowAction) {
      js += 'var click="' + closeWindowAction + '";'
      js += 'var actions = click.split(",");' + 'for(var i = 0; i < actions.length; i++){'
      js += 'var comId=actions[i].split(".")[0];'
      js += 'if(top.document.getElementById(comId)!=null){'
      js += 'window.top.eval(actions[i] + "()");'
      js += '}'
      js += 'var iframes=window.top.document.getElementsByTagName("iframe");'
      js += 'for(var j=0;j<iframes.length;j++){'
      js += 'if(iframes[j].contentDocument.getElementById(comId)!=null){'
      js += 'iframes[j].contentWindow.eval(actions[i] + "()");'
      js += '}'
      js += '}'
      js += '}'
    }
    js += '})}'
    // 设置模态框隐藏函数
    js += ' function clearModal' + windowId + '(){'
    js += 'top.$("#' + windowId + '").remove();'
    js += 'top.document.scripts.' + windowId + 'script' + '.remove();'
    js += 'top.$(document.getElementsByClassName("modal-backdrop fade in")).remove();'
    js += '}'

    // 设置模态框
    var bootmodal = '<div id="' + windowId + '" class="modal fade" onsubmit="return false;"tabindex="-1" role="dialog" data-backdrop="static" aria-labelledby="myModalLabel" aria-hidden="true">'
    bootmodal += '<div id="' + windowId + 'dialog" class="modal-dialog" role="document">'
    bootmodal += '<div class="modal-content" style="width:' + nowWindowWidth + 'px;height:' + nowWindowHeight + 'px">'
    bootmodal += '<div class="modal-header" style="height:10%">'
    bootmodal += '<button type="button" class="close" data-dismiss="modal" aria-hidden="true" onclick="clearModal' + windowId + '()">×</button>'
    bootmodal += ' <h4 class="modal-title">' + windowTitle + '</h4>'
    bootmodal += '</div>'
    bootmodal += '<div class="modal-body" style="height:86%;max-height:none !important;overflow:visible !important">'
    bootmodal += '<iframe id="' + windowId + 'Iframe' + '" src="' + url + '" width="100%" height="100%" frameborder="0" scrolling="no"></iframe>'
    bootmodal += '</div>'
    bootmodal += '<div class="modal-footer">'
    bootmodal += '</div>'
    bootmodal += '</div>'
    bootmodal += '</div>'
    bootmodal += '</div>'

    // 注册脚本
    var script = document.createElement('script')
    script.id = windowId + 'script'
    script.type = 'text/javascript'
    script.appendChild(document.createTextNode(js))

    // 页面添加模态框
    if (window.top.document.getElementById(windowId) == null) {
      $(window.top.document.getElementsByTagName('body')[0]).append(bootmodal)
      window.top.document.body.appendChild(script)
    }
    // 定义全局传参变量
    window.top.iframeParam
    window.top.eval('loadDialog' + windowId + '()')
  },

  /**
         * 描述：参数回调方法
         */
  this.callbackParam = function(closeWindowBackParam) {
    var me = this
    console.log(window.top.iframeParam, closeWindowBackParam)
    var backTableData = window.top.iframeParam

    // 未选中记录，不设置回调参数
    if (!backTableData || backTableData.length == 0) {
      return
    }

    var tableData = []
    // 替换
    if (backTableData && backTableData.length == 1) {
      for (var i in closeWindowBackParam) {
        // 替换关系里表单的值
        if (closeWindowBackParam[i].type == 'formItem') {
          for (var j in backTableData[0]) {
            if (j == closeWindowBackParam[i].value) {
              closeWindowBackParam[i].value = backTableData[0][j]
            }
            if (j == closeWindowBackParam[i].name) {
              closeWindowBackParam[i].name = backTableData[0][j]
            }
          }
        }
        // 替换关系里列表的值
        if (closeWindowBackParam[i].type == 'table') {
          var tableArray = closeWindowBackParam[i].value

          if (tableArray && tableArray.length > 0) {
            var obj = {}
            for (k = 0; k < tableArray.length; k++) {
              for (var l in backTableData[0]) {
                if (l == tableArray[k].linkkey) {
                  // 设置obj的key和value然后push到tableData
                  var status = 'obj.' + tableArray[k].currentkey + "='" + backTableData[0][l] + "'"
                  eval(status)
                }
              }
            }
            tableData.push(obj)
          }
        }
      }
    } else if (backTableData && backTableData.length > 1) {
      // 替换关系里列表的值
      for (var i in closeWindowBackParam) {
        if (closeWindowBackParam[i].type == 'table') {
          var tableArray = closeWindowBackParam[i].value
          for (j = 0; j < backTableData.length; j++) {
            var obj = {}
            for (k = 0; k < tableArray.length; k++) {
              for (var l in backTableData[j]) {
                if (l == tableArray[k].linkkey) {
                  // 设置obj的key和value然后push到tableData
                  var status = 'obj.' + tableArray[k].currentkey + "='" + backTableData[j][l] + "'"
                  eval(status)
                }
              }
            }
            tableData.push(obj)
          }
        }
      }
    }
    console.log(closeWindowBackParam, tableData)
    for (var m in closeWindowBackParam) {
      if (closeWindowBackParam[m].type == 'formItem') {
        if (top.document.getElementById(m) != null) {
          if (closeWindowBackParam[m].value) {
            window.top.eval(m + ".setValue('" + closeWindowBackParam[m].value + "')")
          }
          if (closeWindowBackParam[m].name) {
            window.top.eval(m + ".setName('" + closeWindowBackParam[m].name + "')")
          }
        }
        var iframes = me.getAllIframes()
        for (i = 0; i < iframes.length; i++) {
          if (iframes[i].contentDocument.getElementById(m) != null) {
            if (closeWindowBackParam[m].value) {
              iframes[i].contentWindow.eval(m + ".setValue('" + closeWindowBackParam[m].value + "')")
            }
            if (closeWindowBackParam[m].name) {
              iframes[i].contentWindow.eval(m + ".setName('" + closeWindowBackParam[m].name + "')")
            }
          }
        }
      }
      if (closeWindowBackParam[m].type == 'table') {
        if (top.document.getElementById(m) != null) {
          window.top.eval(m + '.addRows(' + JSON.stringify(tableData) + ')')
        }
        var iframes = me.getAllIframes()
        for (i = 0; i < iframes.length; i++) {
          if (iframes[i].contentDocument.getElementById(m) != null) {
            iframes[i].contentWindow.eval(m + '.addRows(' + JSON.stringify(tableData) + ')')
          }
        }
      }
    }

    window.top.iframeParam = null
  }

  /**
     * 描述：获取当前页面的所有iframe
     */
  this.getAllIframes = function() {
    var me = this
    var iframeArr = window.top.document.getElementsByTagName('iframe')
    var is = []

    if (iframeArr && iframeArr.length > 0) {
      is = Array.from(iframeArr)
      for (var iframe of iframeArr) {
        me.getChildrenIframs(iframe, is)
      }
    }

    return is
  },

  /**
         * 递归查询iframe下的子iframe
         */
  this.getChildrenIframs = function(iframe, iframes) {
    var me = this
    var childs = iframe.contentDocument.getElementsByTagName('iframe')
    var childIframes = Array.from(childs)

    if (childIframes && childIframes.length > 0) {
      for (var childIframe of childIframes) {
        iframes.push(childIframe)
        me.getChildrenIframs(childIframe, iframes)
      }
    }
  },

  /**
         * 描述：判断当前页面是否存在参数
         */
  this.existPageParam = function(url) {
    if (url.indexOf('?') != -1) {
      return true
    } else {
      return false
    }
  },
  /**
         * 描述：获取当前页面的参数
         */
  this.getPageParams = function() {
    var urlParameters = window.location.search
    // 声明并初始化接收请求参数的对象
    var pageParams = new Object()
    // 如果该求青中有请求的参数，则获取请求的参数，否则打印提示此请求没有请求的参数
    if (urlParameters.indexOf('?') != -1) {
      // 获取请求参数的字符串
      var parameters = decodeURI(urlParameters.substr(1))
      // 将请求的参数以&分割中字符串数组
      parameterArray = parameters.split('&')
      // 循环遍历，将请求的参数封装到请求参数的对象之中
      for (var i = 0; i < parameterArray.length; i++) {
        var key = parameterArray[i].split('=')[0]
        pageParams[key] = (parameterArray[i].replace(key + '=', ''))
      }
      console.info('pageParams =====', pageParams)
    } else {
      console.info('当前页面无参数')
    }
    return pageParams
  },
  /**
         * 描述：回退到上一级页面
         */
  this.goback = function() {
    if (this.pageInfo && this.pageInfo.length > 1) {
      window.location.href = this.pageInfo[this.pageInfo.length - 2].path
    }
  }
}

Date.prototype.formatDate = function(format) // author: meizz
{
  var o = {
    'M+': this.getMonth() + 1, // month
    'd+': this.getDate(), // day
    'H+': this.getHours(), // hour
    'm+': this.getMinutes(), // minute
    's+': this.getSeconds(), // second
    'q+': Math.floor((this.getMonth() + 3) / 3), // quarter
    'S': this.getMilliseconds() // millisecond
  }
  if (/(y+)/.test(format)) {
    format = format.replace(RegExp.$1,
      (this.getFullYear() + '').substr(4 - RegExp.$1.length)) 
}
  for (var k in o) {
    if (new RegExp('(' + k + ')').test(format))
    { 
format = format.replace(RegExp.$1,
      RegExp.$1.length == 1 ? o[k]
                : ('00' + o[k]).substr(('' + o[k]).length))}
  }
  return format
}

// 表单详情回显处理（仿vue）
function MVVM(options) {
  this.$options = options || {}
  var data = this._data = this.$options.data
  var me = this

  // 数据代理
  // 实现 vm.xxx -> vm._data.xxx
  Object.keys(data).forEach(function(key) {
    me._proxyData(key)
  })

  this.$compile = new Compile(options.el || document.body, this)
}

MVVM.prototype = {
  constructor: MVVM,

  _proxyData: function(key, setter, getter) {
    var me = this
    setter = setter ||
            Object.defineProperty(me, key, {
              configurable: false,
              enumerable: true,
              get: function proxyGetter() {
                return me._data[key]
              },
              set: function proxySetter(newVal) {
                me._data[key] = newVal
              }
            })
  }

}

function Compile(el, vm) {
  this.$vm = vm
  this.$el = this.isElementNode(el) ? el : document.querySelector(el)

  if (this.$el) {
    this.$fragment = this.node2Fragment(this.$el)
    this.init()
    this.$el.appendChild(this.$fragment)
    // 处理屏闪问题
    $('[dom-hidden]').show()
  }
}

Compile.prototype = {
  constructor: Compile,
  node2Fragment: function(el) {
    var fragment = document.createDocumentFragment()
    var child

    // 将原生节点拷贝到fragment
    while (child = el.firstChild) {
      fragment.appendChild(child)
    }

    return fragment
  },

  init: function() {
    this.compileElement(this.$fragment)
  },

  compileElement: function(el) {
    var childNodes = el.childNodes
    var me = this;

    [].slice.call(childNodes).forEach(function(node) {
      var text = node.textContent
      var reg = /\{\{(.*)\}\}/

      if (me.isTextNode(node) && reg.test(text)) {
        me.compileText(node, RegExp.$1.trim())
      }

      if (node.childNodes && node.childNodes.length) {
        me.compileElement(node)
      }
    })
  },

  compile: function(node) {
    var nodeAttrs = node.attributes
    var me = this;

    [].slice.call(nodeAttrs).forEach(function(attr) {
      var attrName = attr.name
      if (me.isDirective(attrName)) {
        var exp = attr.value
        var dir = attrName.substring(2)
        // 事件指令
        if (me.isEventDirective(dir)) {
          compileUtil.eventHandler(node, me.$vm, exp, dir)
          // 普通指令
        } else {
          compileUtil[dir] && compileUtil[dir](node, me.$vm, exp)
        }

        node.removeAttribute(attrName)
      }
    })
  },

  compileText: function(node, exp) {
    compileUtil.text(node, this.$vm, exp)
  },

  isDirective: function(attr) {
    return attr.indexOf('v-') == 0
  },

  isEventDirective: function(dir) {
    return dir.indexOf('on') === 0
  },

  isElementNode: function(node) {
    return node.nodeType == 1
  },

  isTextNode: function(node) {
    return node.nodeType == 3
  }
}

// 指令处理集合
var compileUtil = {
  text: function(node, vm, exp) {
    this.bind(node, vm, exp, 'text')
  },

  bind: function(node, vm, exp, dir) {
    var updaterFn = updater[dir + 'Updater']

    updaterFn && updaterFn(node, this._getVMVal(vm, exp))
  },

  // 事件处理
  eventHandler: function(node, vm, exp, dir) {
    var eventType = dir.split(':')[1]
    var fn = vm.$options.methods && vm.$options.methods[exp]

    if (eventType && fn) {
      node.addEventListener(eventType, fn.bind(vm), false)
    }
  },

  _getVMVal: function(vm, exp) {
    var val = vm
    exp = exp.split('.')
    exp.forEach(function(k) {
      val = val[k]
    })
    return val
  }

}

var updater = {
  textUpdater: function(node, value) {
    node.textContent = typeof value === 'undefined' ? '' : value
  }
}

function getFwebFormBase() {
  var locations = (window.location + '').split('/')
  var basePath = ''
  if (window.location.protocol == 'http:') {
    basePath = 'http://' + locations[2] + '/' + locations[3] + '/'
  } else {
    basePath = 'https://' + locations[2] + '/' + locations[3] + '/'
  }
  return basePath
}

var fweb_BroadcastChannel_bjhhkejybgds = null
function FwebBroadcastChannel() {
  if (fweb_BroadcastChannel_bjhhkejybgds == null) {
    fweb_BroadcastChannel_bjhhkejybgds = new BroadcastChannel('fweb_BroadcastChannel_00000001')
  }

  var _this = this
  try {
    this.postMessage = function(action, data) {
      var n = ('' + action).indexOf('_')
      if (n <= 0) {
        console.log('FwebBroadcastChannel enregistrer is error')
        return
      }
      // action ####_####_#### fweb_todo_complete
      fweb_BroadcastChannel_bjhhkejybgds.postMessage({ 'action': action, 'data': data })
    }

    fweb_BroadcastChannel_bjhhkejybgds.onmessage = function(ev) {
      if (_this.onmessage && _this.onmessage != null) {
        // console.log("FwebBroadcastChannel is success["+ev.data.action+"] ");
        _this.onmessage(ev.data.action, ev.data.data)
      }
	    }
  } catch (error) {
    console.log('FwebBroadcastChannel is error ')
  }
  return this
}
