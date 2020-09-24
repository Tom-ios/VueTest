<%@ page import="com.hhwy.fweb.framework.api.utils.EnvironmentHelper" %>
<%@ page pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en" ng-app="clientApp" ng-csp>
<head>
    <base href="${config.base()}"/>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>服务中心-<%=EnvironmentHelper.getContextPath() %></title>
    <link rel="shortcut icon"
          href="${config.ui('fweb-framework-ui/style/icons/fweblogo.ico') }"
          type="image/x-icon"/>
    <link rel="stylesheet" type="text/css"
          href="${config.ui('fweb-framework-ui/style/css/bootstrap.min.css')}">
    <link rel="stylesheet" type="text/css"
          href="${config.ui('fweb-framework-ui/style/easyui/bootstrap/easyui.css')}">
    <link rel="stylesheet" type="text/css"
          href="${config.ui('fweb-framework-ui/style/css/fweb.css')}">
    <script type="text/javascript"
            src="${config.ui('fweb-framework-ui/js/jquery.min.js')}"></script>
    <script type="text/javascript"
            src="${config.ui('fweb-framework-ui/js/bootstrap/bootstrap.min.js')}"></script>
    <script type="text/javascript"
            src="${config.ui('fweb-framework-ui/js/jquery.json-2.2.js')}"></script>
    <script type="text/javascript"
            src="${config.ui('fweb-framework-ui/js/easyui/jquery.easyui.min.js')}"></script>
    <script type="text/javascript"
            src="${config.ui('fweb-framework-ui/js/easyui/insdep/jquery.insdep-extend.min.js')}"></script>
</head>
<body class="easyui-layout">
<div id="servicesTabs" class="easyui-tabs"
     data-options="fit:true,onSelect:function(title,index){serviceManageObj.refreshFrame(title,index)}"
     style="width:100%;height:100%;">
    <div title="上下文变量" style="padding:3px">
        <label>
            <input class="easyui-textbox"
                   data-options="onChange:serviceManageObj.autoMatch"
                   prompt="输入过滤条件"
                   style="width:200px;">
        </label>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           onclick="serviceManageObj.refreshFrame('', 0)">刷新</a>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           onclick="serviceManageObj.addVariable()">添加</a>
        <table id="contextdg" class="easyui-datagrid"
               style="width: auto;"></table>
        <div id="contextDialog" style="padding: 3px; display: none">
            <table id="variableInfodg" class="easyui-datagrid"> </table>
            <div style="text-align: center;"><a
                    onclick="serviceManageObj.close('contextDialog')"
                    class="btn btn-primary">关闭</a></div>
        </div>
        <div id="addVariableDialog" style="padding: 3px; display: none">
            <form id="variableForm">
                <table >
                    <tr><td style="text-align: right;height:25px; width: 180px;"><b>变量名&nbsp;</b></td><td>
                        <input  type="hidden" id="variableId"  name="variableId">
                        <input  id="variableName" name="variableName" style="width:300px" class="easyui-textbox" prompt="输入变量名称"></td></tr>
                    <tr><td style="text-align: right;height:25px; width: 180px;"><b>变量描述&nbsp;</b></td><td>
                        <input  id="variableDesc" name="variableDesc" style="width:300px" class="easyui-textbox" prompt="输入变量描述"></td></tr>
                    <tr><td style="text-align: right;height:25px; width: 180px;"><b>变量类型&nbsp;</b></td><td>
                        <input id="variableType"
                               class="easyui-combobox"
                               name="variableType"
                               style="width:300px;"
                               data-options="valueField: 'id',
                                            textField: 'text',
                                            method: 'get',
                                            panelHeight:'auto',
                                            value: '1',
                                            url:'${config.path()}contextVariable/variableType'
                                            "></td></tr>
                    <tr><td style="text-align: right;height:25px; width: 180px;"><b>变量&nbsp;</b></td><td>
                                <input id="bindingVariable"
                                        class="easyui-combobox"
                                        name="bindingVariable"
                                        style="width:300px;"
                                        data-options="valueField: 'id',
                                            textField: 'text',
                                            method: 'get',
                                            panelHeight:'auto',
                                            url:'${config.path()}contextVariable/variables'
                                            "></td></tr>

                </table>
            </form>
            <br><br><br><br>
            <div style="text-align: center;"><a
                    onclick="serviceManageObj.saveVariable()"
                    class="btn btn-primary">保存</a></div>
        </div>
    </div>
    <div title="服务列表" style="padding:3px">
        <label>
            <input class="easyui-textbox"
                   data-options="onChange:serviceManageObj.autoMatch"
                   prompt="输入过滤条件"
                   style="width:200px;">
        </label>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           onclick="serviceManageObj.refreshFrame('', 1)">刷新</a>
        <table id="consumersdg" class="easyui-datagrid"
               style="width: auto;"></table>
    </div>
    <div title="服务调用者" style="padding:3px">
        <label>
            <input class="easyui-textbox"
                   data-options="onChange:serviceManageObj.autoMatch"
                   prompt="输入过滤条件"
                   style="width:200px;">
        </label>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           onclick="serviceManageObj.refreshFrame('', 2)">刷新</a>
        <table id="producersdg" class="easyui-datagrid"
               style="width: auto;"></table>
    </div>
    <div title="服务调用记录" style="padding:3px">
        <label>
            <input class="easyui-textbox"
                   data-options="onChange:serviceManageObj.autoMatch"
                   prompt="输入过滤条件"
                   style="width:200px;">
        </label>
        <a href="javascript:void(0);" class="easyui-linkbutton"
           onclick="serviceManageObj.refreshFrame('', 3)">刷新</a>
        <table id="exchangeRecorddg" class="easyui-datagrid"
               style="width: auto;"></table>
        <div id="recordDialog" style="padding: 3px; display: none">
            <table >
                <tr><td style="text-align: right;height:25px; width:180px"><b>目标业务编码&nbsp;:</b></td><td><div id="targetBusinessCode_detail"></div></td></tr>
                <tr><td style="text-align: right;height:25px; "><b>目标路由&nbsp;:</b></td><td><div id="targetEndpointUri_detail"></div></td></tr>
                <tr><td style="text-align: right;height:25px; "><b>请求者组件Id&nbsp;:</b></td><td><div id="pluginId_detail"></div></td></tr>
                <tr><td style="text-align: right;height:25px;"><b>请求者名称&nbsp;:</b></td><td><div id="producerName_detail"></div></td></tr>
                <tr><td style="text-align: right;height:25px;vertical-align: top"><b>参数&nbsp;:</b></td><td><div id="parameter_detail"></div></td></tr>
                <tr><td style="text-align: right;height:25px;vertical-align: top"><b>返回结果&nbsp;:</b></td><td><div id="result_detail"></div></td></tr>
                <tr><td style="text-align: right;height:25px;"><b>请求发起时间&nbsp;:</b></td><td><div id="invokeTime_detail"></div></td></tr>
                <tr><td style="text-align: right;height:25px;"><b>消耗时间【毫秒】&nbsp;:</b></td><td><div id="elapsedTime_detail"></div></td></tr>
                <tr><td style="text-align: right;height:25px;"><b>请求方式&nbsp;:</b></td><td><div id="synch_detail"></div></td></tr>
            </table>
            <div style="text-align: center;"><a
                    onclick="serviceManageObj.close('recordDialog')"
                    class="btn btn-primary">关闭</a></div>
        </div>
    </div>
</div>
<script type="text/javascript">
    var path = '${config.path()}';
    var serviceManageObj = {
        path: path,
        index: 0,
        close: function (dialog) {
            $("#"+dialog).dialog("close");
        },
        refreshFrame: function (title, index) {
            serviceManageObj.index = index;
            switch (index) {
                case 0:
                    serviceManageObj.contextGrid();
                    break;
                case 1:
                    serviceManageObj.loadConsumersGrid();
                    break;
                case 2:
                    serviceManageObj.loadProducersGrid();
                    break;
                case 3:
                    serviceManageObj.loadExchangeRecorddg();
                    break;
            }
        },
        contextGrid: function () {
            $("#contextdg")
                .datagrid(
                    {
                        method: 'get',
                        url: serviceManageObj.path + 'contextVariable/list',
                        pagination: false,
                        fit: true,
                        fitColumns: true,
                        striped: true,
                        scrollbarSize: 0,
                        singleSelect: true,
                        columns: [[
                            {
                                field: "variableName",
                                title: "<b>变量名</b>",
                                width: '260',
                                formatter: function (value, row, index) {
                                    var str = '';
                                    str += '<a href="javascript:void(0)" title="点击查看详情" onclick="serviceManageObj.openVariableInfo(\''
                                        + row.variableName + '\')">' + value + '</a>';
                                    return str;
                                }
                            },
                            {
                                field: "variableDesc",
                                title: "<b>变量描述</b>",
                                width: '300'
                            },
                            {
                                field: "variableType",
                                title: "<b>变量类型</b>",
                                width: '100',
                                formatter: function (value, row, index) {
                                    if(value == 1){
                                        return '会话';
                                    }else if(value == 2){
                                        return '表达式';
                                    }
                                }
                            },
                            {
                                field: "bindingVariable",
                                title: "<b>变量绑定</b>",
                                width: '200'
                            },
                            {
                                field: "sourcePlugin",
                                title: "<b>来源组件</b>",
                                width: '200'
                            },
                            {
                                field: "op",
                                title: "<b>操作</b>",
                                width: '200',
                                formatter: function (value, row, index) {
                                    var str = '';
                                    str += '<a href="javascript:void(0)" title="点击修改变量" onclick="serviceManageObj.updateVariableInfo(\''
                                        + index + '\')">修改</a>&nbsp;&nbsp;&nbsp;&nbsp;';
                                    str += '<a href="javascript:void(0)" title="点击删除变量" onclick="serviceManageObj.deleteVariableInfo(\''
                                        + index + '\')">删除</a>';
                                    return str;
                                }
                            }]]
                    });
        },
        addVariable : function(){
            var param = {
                'variableId': '',
                'variableName': '',
                'variableType': '1',
                'variableDesc': '',
                'bindingVariable': ''
            };
            $('#variableForm').form('load',param);
            $("#addVariableDialog").dialog({
                title: '添加变量信息',
                width: 600,
                height: 400,
                cache: false,
                closed: false,
                modal: true
            });
        },
        saveVariable : function(){
            var param = {
                'id': $("#variableId").val(),
                'variableName': $("#variableName").val(),
                'variableDesc': $("#variableDesc").val(),
                'variableType': $("#variableType").val(),
                'bindingVariable':$("#bindingVariable").val()
            };
            if(param.variableName == null || param.variableName.trim() === ''){
                $.messager.alert({
                    title: '填写提示',
                    msg: '变量名必须填写!'
                });
                return ;
            }else{
                $.ajax({
                    url: serviceManageObj.path + 'contextVariable/check?variableName=' + param.variableName+"&id="+param.id,
                    type: 'get',
                    contentType: 'application/json;charset=UTF-8',
                    success: function (result) {
                        if(result.state === 'error'){
                            $.messager.alert({
                                title: '填写提示',
                                msg: '变量名不能与已有变量名重复, 请重新填写!'
                            });
                            return ;
                        }
                    }
                });
            }
            $.ajax({
                url: serviceManageObj.path + "contextVariable/save",
                type: 'post',
                data: $.toJSON(param),
                contentType: 'application/json;charset=UTF-8',
                success: function (data) {
                    if (data.state == 'success') {
                        $.messager.show({
                            title: '保存成功',
                            msg: '变量保存成功！',
                            timeout:3000,
                            style:{
                                right:'',
                                top:document.body.scrollTop+document.documentElement.scrollTop,
                                bottom:''
                            }
                        });
                        serviceManageObj.contextGrid();
                        $("#addVariableDialog").dialog("close");
                    }

                }
            });
        },
        updateVariableInfo: function(index){
            var row = $("#contextdg").datagrid("getRows")[index];
            var param = {
                'variableId': row.id,
                'variableName': row.variableName,
                'variableType': row.variableType,
                'variableDesc': row.variableDesc,
                'bindingVariable': row.bindingVariable
            };
            $('#variableForm').form('load',param);

            $("#addVariableDialog").dialog({
                title: '修改变量信息',
                width: 600,
                height: 400,
                cache: false,
                closed: false,
                modal: true
            });
        },
        deleteVariableInfo: function(index){
            var row = $("#contextdg").datagrid("getRows")[index];
            $.messager.confirm('删除提醒', '确定要删除变量【'+row.variableName+'】吗?', function(r) {
                if (!r) {
                    return;
                }
                $.ajax({
                    url: serviceManageObj.path + "contextVariable/del?id="+row.id,
                    type: 'delete',
                    success: function (data) {
                        if (data.state == 'success') {
                            $.messager.show({
                                title: '删除成功',
                                msg: '变量删除成功！',
                                timeout:3000,
                                style:{
                                    right:'',
                                    top:document.body.scrollTop+document.documentElement.scrollTop,
                                    bottom:''
                                }
                            });
                            serviceManageObj.contextGrid();
                        }
                    }
                });
            });
        },
        loadConsumersGrid: function () {
            $("#consumersdg")
                .datagrid(
                    {
                        method: 'get',
                        url: serviceManageObj.path + 'fwebexchange/consumers',
                        pagination: false,
                        fit: true,
                        fitColumns: true,
                        striped: true,
                        scrollbarSize: 0,
                        singleSelect: true,
                        columns: [[
                            {
                                field: "pluginId",
                                title: "<b>组件编号</b>",
                                width: '180'
                            },
                            {
                                field: "businessCode",
                                title: "<b>业务编号</b>",
                                width: '300',
                                formatter: function (value, row, index) {
                                    var str = '';
                                    str += '<a href="javascript:void(0)" title="点击查看接口详情" onclick="serviceManageObj.openServiceInfo('
                                        + index + ')">' + value + '</a>';
                                    return str;
                                }
                            },
                            {
                                field: "host",
                                title: "<b>主机</b>",
                                width: '160'
                            },
                            {
                                field: "port",
                                width: '120',
                                title: "<b>端口</b>"
                            },
                            {
                                field: "applicationName",
                                width: '200',
                                title: "<b>应用名称</b>"
                            }]]
                    });
        },
        loadProducersGrid: function () {
            $("#producersdg")
                .datagrid(
                    {
                        method: 'get',
                        url: serviceManageObj.path + 'fwebexchange/producers',
                        pagination: false,
                        fit: true,
                        fitColumns: true,
                        striped: true,
                        scrollbarSize: 0,
                        singleSelect: true,
                        columns: [[
                            {
                                field: "targetBusinessCode",
                                title: "<b>目标业务标识</b>",
                                width: '300'
                            },
                            {
                                field: "pluginId",
                                title: "<b>组件编号</b>",
                                width: '280'
                            },
                            {
                                field: "beanId",
                                title: "<b>请求方</b>",
                                width: '260'
                            },
                            {
                                field: "host",
                                title: "<b>主机</b>",
                                width: '120'
                            },
                            {
                                field: "port",
                                width: '120',
                                title: "<b>端口</b>"
                            }]]
                    });
        },
        loadExchangeRecorddg: function () {
            $("#exchangeRecorddg")
                .datagrid(
                    {
                        method: 'get',
                        url: serviceManageObj.path + 'fwebexchange/exchagerecords',
                        pagination: true,
                        fitColumns: true,
                        striped: true,
                        scrollbarSize: 0,
                        singleSelect: true,
                        width: '100%',
                        height: '95%',
                        columns: [[
                            {
                                field: "targetBusinessCode",
                                title: "<b>目标业务标识</b>",
                                width: '300',
                                formatter: function (value, row, index) {
                                    var str = '';
                                    str += '<a href="javascript:void(0)" title="点击查看通讯详情" onclick="serviceManageObj.openRecordInfo('
                                        + index + ')">' + value + '</a>';
                                    return str;
                                }
                            },
                            {
                                field: "targetMethod",
                                width: '200',
                                title: "<b>目标方法</b>"
                            },
                            {
                                field: "pluginId",
                                title: "<b>调用者组件编号</b>",
                                width: '220'
                            },
                            {
                                field: "producerName",
                                title: "<b>请求方</b>",
                                width: '220'
                            },
                            {
                                field: "invokeTime",
                                title: "<b>请求时间</b>",
                                width: '200'
                            },
                            {
                                field: "elapsedTime",
                                title: "<b>耗时[毫秒]</b>",
                                width: '100'
                            }
                        ]]
                    });
        },
        openVariableInfo: function (variableName) {
            serviceManageObj.setContextContent(variableName);
            $("#contextDialog").dialog({
                title: '变量详细内容',
                width: 800,
                height: 600,
                cache: false,
                closed: false,
                modal: true
            });
        },
        setContextContent: function (variableName) {
            $.ajax({
                url: serviceManageObj.path + "contextVariable/variables/"+variableName,
                type: 'get',
                success: function (data) {
                    console.log(data)
                    if (data.state == 'success') {
                        $('#variableInfodg').datagrid({
                            fit: true,
                            fitColumns: true,
                            striped: true,
                            scrollbarSize: 0,
                            singleSelect: true,
                            height: 500,
                            columns: [[
                                {
                                    field: "k",
                                    title: "<b>键</b>",
                                    width: '380'
                                },
                                {
                                    field: "v",
                                    title: "<b>值</b>",
                                    width: '300'
                                }]],
                            data: data
                        });
                    }
                }
            });
        },
        openServiceInfo: function (index) {

        },
        openRecordInfo: function (index) {

            serviceManageObj.setRecordContent(index);
            $("#recordDialog").dialog({
                title: '接口调用记录详细内容',
                width: 800,
                height: 600,
                cache: false,
                closed: false,
                modal: true
            });
        },
        setRecordContent : function(index){
            var rows =   $("#exchangeRecorddg").datagrid('getRows');
            for(var i = 0; i < rows.length; i++){
                if(i == index){
                    row = rows[i];
                    for(a in row){
                        var id = "#"+a+"_detail";
                        $(id).html('&nbsp;&nbsp;'+row[a]);
                    }
                }
            }

        }
    }
</script>
</body>