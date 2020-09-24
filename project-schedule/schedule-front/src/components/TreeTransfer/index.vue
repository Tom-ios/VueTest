<template>
  <div class="transfer" :style="{ width, height }">
    <template v-if="mode == 'transfer'">
      <!-- 左侧穿梭框 原料框 -->
      <div class="transfer-left">
        <h3 class="transfer-title">
          <span>{{ fromTitle }}</span>
          <slot name="title-left"></slot>
        </h3>
        <!-- 内容区 -->
        <div class="transfer-main" v-loading="leftTreeLoading">
          <!-- <slot name="from"></slot> -->   
          <el-input
            v-if="filter"
            :placeholder="placeholder"
            v-model="filterFrom"
            size="small"
            class="filter-tree"
            @keyup.enter.native="search"
          >
          </el-input>
          <el-button type="primary" @click="search">查询</el-button>
          <div class="left-tree ">
            <el-tree
              ref="from-tree"
              :data="self_from_data"
              show-checkbox
              :node-key="node_key"
              @check="fromTreeChecked"
              :default-expanded-keys="from_expanded_keys"
              :props="defaultProps"
              :filter-node-method="filterNodeFrom"
              :default-expand-all="openAll"
              :render-content="renderContent"
              :default-checked-keys="defaultCheckedKeys"
              :lazy="lazy"
              :load="leftloadNode"
              :highlight-current="true"
              empty-text="请选择模型文件"
            >
            </el-tree>
          </div>
          <slot name="left-footer"></slot>
        </div>
      </div>
      <!-- 穿梭区 按钮框 -->
      <div class="transfer-center">
        <template v-if="button_text">
          <p class="transfer-center-item">
            <el-button
              type="primary"
              @click="addToAims"
              :disabled="from_disabled"
              icon="el-icon-arrow-right"
            >
              {{ fromButton || "添加" }}
            </el-button>
          </p>
          <p class="transfer-center-item">
            <el-button
              type="primary"
              @click="removeToSource"
              :disabled="checkList.length === 0"
              icon="el-icon-arrow-left"
              >
              {{ toButton || "移除" }}
              </el-button>
          </p>
        </template>
        <template v-else>
          <p class="transfer-center-item">
            <el-button
              type="primary"
              @click="addToAims"
              icon="el-icon-arrow-right"
              circle
              :disabled="from_disabled"
            ></el-button>
          </p>
          <p class="transfer-center-item">
            <el-button
              type="primary"
              @click="removeToSource"
              :disabled="checkList.length === 0"
              icon="el-icon-arrow-left"
              circle
            ></el-button>
          </p>
        </template>
      </div>
      <!-- 右侧穿梭框 目标框 -->
      <div class="transfer-right">
        <h3 class="transfer-title" style="width: 200%;">
          <span>{{ toTitle }}</span>
          <slot name="title-right"></slot>
          <div style="float:right;margin-right:51%" v-if="rightData.length > 0">
            <el-tooltip effect="dark" content="新增同级节点" placement="top">
              <el-button icon="el-icon-folder-add" size="mini" circle @click="add"></el-button>
            </el-tooltip>
            <el-tooltip effect="dark" content="新增子节点" placement="top">
              <el-button icon="el-icon-plus" size="mini" circle @click="addChildren"></el-button>
            </el-tooltip>
            <el-tooltip effect="dark" content="编辑" placement="top">
              <el-button icon="el-icon-edit" size="mini" circle @click="edit"></el-button>
            </el-tooltip>
            <el-tooltip effect="dark" content="删除" placement="top">
              <el-button icon="el-icon-minus" size="mini" circle @click="del"></el-button>
            </el-tooltip>
            <el-tooltip effect="dark" content="上移" placement="top">
              <el-button icon="el-icon-top" size="mini" circle @click="up"></el-button>
            </el-tooltip>
            <el-tooltip effect="dark" content="下移" placement="top">
              <el-button icon="el-icon-bottom" size="mini" circle @click="down"></el-button>
            </el-tooltip>
          </div>
        </h3>
        <!-- 内容区 -->
        <div class="transfer-main" style="width:100%">
          <div class="typeTitle">分类</div>
          <el-input
            v-if="filter"
            :placeholder="placeholder"
            v-model="filterTo"
            size="small"
            class="filter-tree"
            @keyup.enter.native="searchTo"
          >
          </el-input>
          <el-button type="primary" @click="searchTo">查询</el-button>
          <el-tree
            slot="to"
            ref="to-tree-show"
            :data="rightData"
            :node-key="node_key"
            @check="toShowTreeChecked"
            :props="defaultProps"
            :filter-node-method="filterNodeTo"
            :default-expand-all="true"
            :render-content="renderContent"
            :lazy="lazy"
            :load="rightloadNode"
            @current-change="currentChange"
            :highlight-current="true"
            :key="tree_key"
            :default-expanded-keys="defaultExpand"
            empty-text=""
          >
          </el-tree>
          <el-button style="position: absolute;top: 50%;left: 50%;transform: translate(-50%, -50%);" v-if="rightData.length === 0" type="primary" @click="add">创建节点</el-button>
          <slot name="right-footer"></slot>
        </div>
      </div>
      <div class="transfer-right-ext">
        <div class="typeTitle" style="margin-top: 40px">分类包含的图元</div>
        <el-input
          v-if="filter"
          placeholder="图元名称"
          v-model="filterExt"
          size="small"
          class="filter-tree"
          @keyup.enter.native="searchExt"
        >
        </el-input>
        <el-button type="primary" @click="searchExt">查询</el-button>
        <div style="overflow:auto;height: calc(100% - 90px)">
          <el-checkbox style="margin-top:4px" v-if="searchExtData.length > 0" v-model="checkAll" :indeterminate="isIndeterminate" @change="handleCheckAllChange">全选</el-checkbox>
          <el-checkbox-group v-model="checkList" @change="groupChange">
            <el-checkbox v-for="item in searchExtData" :key="item.id" :label="item.id+'-'+item.moduleId">{{item.label}}</el-checkbox>
          </el-checkbox-group>
          <div v-if="!rightCurrentNode.id" style="position: absolute;top: 50%;left: 50%;transform: translate(-50%, -50%);">请选择构件</div>
          <div v-else-if="searchExtData.length === 0 && (rightCurrentNode.children && rightCurrentNode.children.length === 0)" style="position: absolute;top: 50%;left: 50%;transform: translate(-50%, -50%);">{{ filterExt?'没有结果':'该节点暂无图元' }}</div>
        </div>
      </div>
    </template>

    <el-dialog
      title=""
      :visible.sync="dialogVisible"
      :close-on-click-modal="false"
      width="30%">
      
      <el-form ref="nameForm" :model="form">
        <el-form-item label="名称" label-width="68" prop="label" :rules="[
          { required: true, message: '请输入名称', trigger: 'blur' }
          ]">
          <el-input ref="addNodeInput" v-model="form.label"></el-input>
        </el-form-item>
      </el-form>

      <span slot="footer">
        <el-button @click="dialogVisible = false">取 消</el-button>
        <el-button type="primary" @click="nameSubmit">确 定</el-button>
      </span>
    </el-dialog>
    
  </div>
</template>

<script>
import { arrayToTree } from "./array.js";
export default {
  data() {
    return {
      from_is_indeterminate: false, // 源数据是否半选
      from_check_all: false, // 源数据是否全选
      to_is_indeterminate: false, // 目标数据是否半选
      to_check_all: false, // 目标数据是否全选
      from_expanded_keys: [], // 源数据展开节点
      to_expanded_keys: [], // 目标数据展开节点
      from_disabled: true, // 添加按钮是否禁用
      to_disabled: true, // 移除按钮是否禁用
      from_check_keys: [], // 源数据选中key数组 以此属性关联穿梭按钮，总全选、半选状态
      to_check_keys: [], // 目标数据选中key数组 以此属性关联穿梭按钮，总全选、半选状态
      filterFrom: "", // 源数据筛选
      filterTo: "", // 目标数据筛选
      filterExt: "",
      filterListFirst: "", // 通讯录模式 右1筛选
      filterListSecond: "", // 通讯录模式 右2筛选
      filterListThird: "", // 通讯录模式 右3筛选
      archiveFirst: [], // 存档右侧筛选前数据
      archiveSecond: [], // 存档右侧筛选前数据
      archiveThird: [], // 存档右侧筛选前数据
      addressee: [], // 收件人列表
      Cc: [], // 抄送人列表
      secret_receiver: [], // 密送人列表
      move_up: false, // 通讯录模式 切换右侧,
      rightData: [],
      dialogVisible: false,
      form: {
        label: "",
      },
      leafDatas: [],
      checkList: [],
      dialogMode: 0,
      tree_key: 0,
      defaultExpand:[],
      isIndeterminate: false,
      checkAll: false,
      searchText: '',
      rightCurrentNode:{},//右侧树的当前节点
      delNodes: [],
      delLeafs: new Map(),
      searchExtText:''
    };
  },
  props: {
    // 宽度
    width: {
      type: String,
      default: "100%"
    },
    // 高度
    height: {
      type: String,
      default: "320px"
    },
    // 标题
    title: {
      type: Array,
      default: () => ["源列表", "目标列表"]
    },
    // 穿梭按钮名字
    button_text: Array,
    // 源数据
    from_data: {
      type: Array,
      default: () => []
    },
    // 选中数据
    to_data: {
      type: Array,
      default: () => []
    },
    // el-tree 配置项
    defaultProps: {
      type: Object,
      default: () => {
        return { label: "label", children: "children", disabled: "disabled" };
      }
    },
    // el-tree node-key 必须唯一
    node_key: {
      type: String,
      default: "id"
    },
    // 自定义 pid参数名
    pid: {
      type: String,
      default: "pid"
    },
    // 是否启用筛选
    filter: {
      type: Boolean,
      default: false
    },
    // 是否展开所有节点
    openAll: {
      type: Boolean,
      default: false
    },
    // 自定义树节点
    renderContent: Function,
    // 穿梭框模式
    mode: {
      type: String,
      default: "transfer"
    },
    // 通讯录模式配置项 num-> 所需右侧通讯录个数 suffix-> label后想要拼接的字段（如id，即取此条数据的id拼接在后方）connector -> 连接符（字符串）
    addressOptions: {
      type: Object,
      default: () => {
        return {
          num: 3,
          suffix: "suffix",
          connector: "-"
        };
      }
    },
    // 穿梭后是否展开节点
    transferOpenNode: {
      type: Boolean,
      default: true
    },
    // 源数据 默认选中节点
    defaultCheckedKeys: {
      type: Array,
      default: () => []
    },
    // 筛选placeholder
    placeholder: {
      type: String,
      default: "输入关键字进行过滤"
    },
    // 默认穿梭一次默认选中数据
    defaultTransfer: {
      type: Boolean,
      default: false
    },
    // 是否开启arrayToTree
    arrayToTree: {
      type: Boolean,
      default: false
    },
    // 是否启用懒加载
    lazy: {
      type: Boolean,
      default: false
    },
    // 懒加载的回调函数
    lazyFn: Function,
    initRightData: {
      type: Array,
      default:function(){return []}
    },
    leftTreeLoading: {
      type: Boolean,
      default:false
    },
    modelId: {
      type: String,
      default:""
    }
  },
  created() {
    this.from_check_keys = this.defaultCheckedKeys;
  },
  methods: {
    getDelNodes(){
      return this.delNodes
    },
    getDelLeafs(){
      let tmpMap = new Map()
      this.delLeafs.forEach((value, key) =>{
        let ids = value.split('-')
        if (ids.length === 2){
          if (!tmpMap.has(ids[1])){
            tmpMap.set(ids[1], [])
          }
          tmpMap.get(ids[1]).push(ids[0])
        }
      })
      let arr = []
      tmpMap.forEach((value, key) =>{
        arr.push({id:key, figures:value.toString()})
      })
      return arr
    },
    handleCheckAllChange(v){
      this.checkList = []
      if (v){
        this.searchExtData.forEach(item =>{
          this.checkList.push(item.id+'-'+item.moduleId)
        })
      }
      this.isIndeterminate = false;
    },
    groupChange(v){
      let checkedCount = v.length;
      this.checkAll = checkedCount === this.searchExtData.length;
      this.isIndeterminate = checkedCount > 0 && checkedCount < this.searchExtData.length;
    },
    search(){
      this.$refs["from-tree"].filter(this.filterFrom);
      this.searchText = this.filterFrom
    },
    // 右侧 数据筛选
    searchTo() {
      this.$refs["to-tree-show"].filter(this.filterTo);
    },
    searchExt(){
      this.searchExtText = this.filterExt
    },
    setDisabled(ids){
      ids.forEach(id => {
        let node = this.$refs["from-tree"].getNode(id)
        if (node){
          this.$set(node.data, 'disabled', true)
        }
      })
    },
    setExpendedKeys(val){
      this.from_expanded_keys = val
    },
    currentChange(node){
      this.rightCurrentNode = node;
      this.checkList = []
      this.leafDatas = node.leafChildren || []
      this.from_disabled = this.from_check_keys.length === 0 || node.children.length !== 0
    },
    // 添加按钮
    addToAims(bNotAddShowTree) {
      // 获取选中通过穿梭框的keys - 仅用于传送纯净的id数组到父组件同后台通信
      let keys = this.$refs["from-tree"].getCheckedKeys();
      // 获取半选通过穿梭框的keys - 仅用于传送纯净的id数组到父组件同后台通信
      let harfKeys = this.$refs["from-tree"].getHalfCheckedKeys();
      // 选中节点数据
      let arrayCheckedNodes = this.$refs["from-tree"].getCheckedNodes();
      // 获取选中通过穿梭框的nodes - 仅用于传送选中节点数组到父组件同后台通信需求
      let nodes = JSON.parse(JSON.stringify(arrayCheckedNodes));
      // 半选中节点数据
      let arrayHalfCheckedNodes = this.$refs["from-tree"].getHalfCheckedNodes();
      // 获取半选通过穿梭框的nodes - 仅用于传送选中节点数组到父组件同后台通信需求
      let halfNodes = JSON.parse(JSON.stringify(arrayHalfCheckedNodes));

      // 自定义参数读取设置
      let children__ = this.defaultProps.children || "children";
      let pid__ = this.pid || "pid";
      let id__ = this["node_key"] || "id";

      /*
       * 先整合目标树没有父节点的叶子节点选中，需要整理出来此叶子节点的父节点直到根节点路径 - 此时所有骨架节点已有
       * 再将所有末端叶子节点根据pid直接推入目标树即可
       * 声明新盒子将所有半选节点的子节点清除 - 只保留骨架 因为排序是先父后子 因此不存在子元素处理好插入时父元素还没处理的情况
       * 下面一二步是为了搭建出来目标树没有根节点躯干节点时的叶子选中，给此叶子搭建出根节点和躯干节点
       */

      // let不存在状态提升 因此在函数调用之前赋值 并递归为以为数组！
      // let self_to_data = JSON.stringify(this.self_to_data);
      // // 第一步
      // let skeletonHalfCheckedNodes = JSON.parse(
      //   JSON.stringify(arrayHalfCheckedNodes)
      // ); // 深拷贝数据 - 半选节点
      // // 筛选目标树不存在的骨架节点 - 半选内的节点
      // let newSkeletonHalfCheckedNodes = [];
      // skeletonHalfCheckedNodes.forEach(item => {
      //   if (!inquireIsExist(item)) {
      //     newSkeletonHalfCheckedNodes.push(item);
      //   }
      // });
      // // 筛选到目标树不存在的骨架后在处理每个骨架节点-非末端叶子节点 - 半选节点
      // newSkeletonHalfCheckedNodes.forEach(item => {
      //   item[children__] = [];
      //   [0, "0"].includes(item[pid__])
      //     ? this.$refs["to-tree"].append(item)
      //     : this.$refs["to-tree"].append(item, item[pid__]);
      // });

      // // 第二步
      // // 筛选目标树不存在的骨架节点 - 全选内的节点
      // let newSkeletonCheckedNodes = [];
      // nodes.forEach(item => {
      //   if (!inquireIsExist(item)) {
      //     newSkeletonCheckedNodes.push(item);
      //   }
      // });
      // // 筛选到目标树不存在的骨架后在处理每个骨架节点-非末端叶子节点 - 全选节点
      // newSkeletonCheckedNodes.forEach(item => {
      //   if (item[children__] && item[children__].length > 0) {
      //     item[children__] = [];
      //     [0, "0"].includes(item[pid__])
      //       ? this.$refs["to-tree"].append(item)
      //       : this.$refs["to-tree"].append(item, item[pid__]);
      //   }
      // });

      // // 第三步 处理末端叶子元素 - 声明新盒子筛选出所有末端叶子节点
      // let leafCheckedNodes = arrayCheckedNodes.filter(
      //   item => !item[children__] || item[children__].length == 0
      // );
      // // 末端叶子插入目标树
      // leafCheckedNodes.forEach(item => {
      //   if (!inquireIsExist(item)) {
      //     this.$refs["to-tree"].append(item, item[pid__]);
      //   }
      // });

      // 递归查询data内是否存在item函数
      function inquireIsExist(item, strData = self_to_data) {
        // 将树形数据格式化成一维字符串 然后通过匹配来判断是否已存在
        let strItem =
          typeof item[id__] == "number"
            ? `"${id__}":${item[id__]},`
            : `"${id__}":"${item[id__]}"`;
        let reg = RegExp(strItem);
        let existed = reg.test(strData);
        return existed;
      }

      // 左侧删掉选中数据
      arrayCheckedNodes.map(item => {
        if (item.children.length == 0 && item.label.toLowerCase().indexOf(this.searchText.toLowerCase()) !== -1){
          this.$set(item, 'disabled', true)
        }
      });

      // 处理完毕按钮恢复禁用状态
      this.from_check_keys = [];

      // 目标数据节点展开
      if (this.transferOpenNode && !this.lazy) {
        this.to_expanded_keys = keys;
      }

      // 传递信息给父组件
      this.$emit("addBtn", this.self_from_data, this.self_to_data, {
        keys,
        nodes,
        harfKeys,
        halfNodes
      });

      // 处理完毕取消选中
      this.$refs["from-tree"].setCheckedKeys([]);

      if (bNotAddShowTree !== true){
        let leafNodes = nodes.filter(node => node.children.length == 0 && node[this.defaultProps.label].toLowerCase().indexOf(this.searchText.toLowerCase()) !== -1)
        let current = this.$refs['to-tree-show'].getCurrentNode()
        if (current){
          leafNodes.forEach(node => {
            node.templateId = current.id
            node.moduleId = this.modelId
            this.delLeafs.delete(node.id+'-'+current.id)
          })
          current.leafChildren = current.leafChildren.concat(leafNodes)
          this.currentChange(current)
        }
      }
    },
    // 移除按钮
    removeToSource() {
      // 获取选中通过穿梭框的keys - 仅用于传送纯净的id数组到父组件同后台通信
      // let keys = this.$refs["to-tree"].getCheckedKeys();
      // // 获取半选通过穿梭框的keys - 仅用于传送纯净的id数组到父组件同后台通信
      // let harfKeys = this.$refs["to-tree"].getHalfCheckedKeys();
      // // 获取选中通过穿梭框的nodes 选中节点数据
      // let arrayCheckedNodes = this.$refs["to-tree"].getCheckedNodes();
      // // 获取选中通过穿梭框的nodes - 仅用于传送选中节点数组到父组件同后台通信需求
      // let nodes = JSON.parse(JSON.stringify(arrayCheckedNodes));
      // // 半选中节点数据
      // let arrayHalfCheckedNodes = this.$refs["to-tree"].getHalfCheckedNodes();
      // // 获取半选通过穿梭框的nodes - 仅用于传送选中节点数组到父组件同后台通信需求
      // let halfNodes = JSON.parse(JSON.stringify(arrayHalfCheckedNodes));

      // 自定义参数读取设置
      let children__ = this.defaultProps.children || "children";
      let pid__ = this.pid || "pid";
      let id__ = this["node_key"] || "id";

      /*
       * 先整合目标树没有父节点的叶子节点选中，需要整理出来此叶子节点的父节点直到根节点路径 - 此时所有骨架节点已有
       * 再将所有末端叶子节点根据pid直接推入目标树即可
       * 声明新盒子将所有半选节点的子节点清除 - 只保留骨架 因为排序是先父后子 因此不存在子元素处理好插入时父元素还没处理的情况
       * 下面一二步是为了搭建出来目标树没有根节点躯干节点时的叶子选中，给此叶子搭建出根节点和躯干节点
       */

      // let不存在状态提升 因此在函数调用之前赋值 并递归为以为数组！
      // let self_from_data = JSON.stringify(this.self_from_data);
      // // 第一步
      // let skeletonHalfCheckedNodes = JSON.parse(
      //   JSON.stringify(arrayHalfCheckedNodes)
      // ); // 深拷贝数据 - 半选节点
      // // 筛选目标树不存在的骨架节点 - 半选内的节点
      // let newSkeletonHalfCheckedNodes = [];
      // skeletonHalfCheckedNodes.forEach(item => {
      //   if (!inquireIsExist(item)) {
      //     newSkeletonHalfCheckedNodes.push(item);
      //   }
      // });
      // // 筛选到目标树不存在的骨架后在处理每个骨架节点-非末端叶子节点 - 半选节点
      // newSkeletonHalfCheckedNodes.forEach(item => {
      //   item[children__] = [];
      //   [0, "0"].includes(item[pid__])
      //     ? this.$refs["from-tree"].append(item)
      //     : this.$refs["from-tree"].append(item, item[pid__]);
      // });

      // // 第二步
      // // 筛选目标树不存在的骨架节点 - 全选内的节点
      // let newSkeletonCheckedNodes = [];
      // nodes.forEach(item => {
      //   if (!inquireIsExist(item)) {
      //     newSkeletonCheckedNodes.push(item);
      //   }
      // });
      // // 筛选到目标树不存在的骨架后在处理每个骨架节点-非末端叶子节点 - 全选节点
      // newSkeletonCheckedNodes.forEach(item => {
      //   if (item[children__] && item[children__].length > 0) {
      //     item[children__] = [];
      //     [0, "0"].includes(item[pid__])
      //       ? this.$refs["from-tree"].append(item)
      //       : this.$refs["from-tree"].append(item, item[pid__]);
      //   }
      // });

      // // 第三步 处理末端叶子元素 - 声明新盒子筛选出所有末端叶子节点
      // let leafCheckedNodes = arrayCheckedNodes.filter(
      //   item => !item[children__] || item[children__].length == 0
      // );
      // // 末端叶子插入目标树
      // leafCheckedNodes.forEach(item => {
      //   if (!inquireIsExist(item)) {
      //     this.$refs["from-tree"].append(item, item[pid__]);
      //   }
      // });

      // 递归查询data内是否存在item函数
      function inquireIsExist(item, strData = self_from_data) {
        // 将树形数据格式化成一维字符串 然后通过匹配来判断是否已存在
        let strItem =
          typeof item[id__] == "number"
            ? `"${id__}":${item[id__]},`
            : `"${id__}":"${item[id__]}"`;
        let reg = RegExp(strItem);
        let existed = reg.test(strData);
        return existed;
      }

      // 右侧删掉选中数据
      // arrayCheckedNodes.map(item => {
      //   this.$refs["to-tree"].remove(item)
      // });
      this.checkList.forEach(ids =>{
        let id = parseInt(ids.split('-')[0])
        let node = this.$refs["from-tree"].getNode(id)
        this.delLeafs.set(id+'-'+this.rightCurrentNode.id,ids)
        if (node){
          this.$set(node.data, 'disabled', false)
        }
        this.leafDatas = this.leafDatas.filter(node => {
          return node.id != id
        })
      })
      this.$refs['to-tree-show'].getCurrentNode().leafChildren = this.leafDatas

      this.checkList = []
      this.checkAll = false

      // 处理完毕按钮恢复禁用状态
      this.to_check_keys = [];

      // 目标数据节点展开
      // if (this.transferOpenNode && !this.lazy) {
      //   this.from_expanded_keys = keys;
      // }

      // 传递信息给父组件
      // this.$emit("removeBtn", this.self_from_data, this.self_to_data, {
      //   keys,
      //   nodes,
      //   harfKeys,
      //   halfNodes
      // });
      // 处理完毕取消选中
      // this.$refs["to-tree"].setCheckedKeys([]);
    },
    // 异步加载左侧
    leftloadNode(node, resolve) {
      if (node.level === 0) {
        return resolve(this.self_from_data);
      }

      this.lazyFn && this.lazyFn(node, resolve, "left");
    },
    // 异步加载右侧
    rightloadNode(node, resolve) {
      if (node.level === 0) {
        return resolve(this.self_to_data);
      }

      this.lazyFn && this.lazyFn(node, resolve, "right");
    },
    // 源树选中事件 - 是否禁用穿梭按钮
    fromTreeChecked(nodeObj, treeObj) {
      this.from_check_keys = treeObj.checkedNodes;
      this.$nextTick(()=>{
        this.$emit("left-check-change", nodeObj, treeObj, this.from_check_all);
      })
    },
    // 目标树选中事件 - 是否禁用穿梭按钮
    toTreeChecked(nodeObj, treeObj) {
      this.to_check_keys = treeObj.checkedNodes;
      this.$nextTick(()=>{
        this.$emit("right-check-change", nodeObj, treeObj, this.to_check_all);
      })
    },
    toShowTreeChecked(nodeObj, treeObj){
      this.to_check_keys = treeObj.checkedNodes;
      this.$refs["to-tree"].setCheckedNodes(treeObj.checkedNodes)
    },
    // 源数据 总全选checkbox
    fromAllBoxChange(val) {
      if (this.self_from_data.length == 0) {
        return;
      }
      if (val) {
        this.from_check_keys = this.self_from_data;
        this.$refs["from-tree"].setCheckedNodes(this.self_from_data);
      } else {
        this.$refs["from-tree"].setCheckedNodes([]);
        this.from_check_keys = [];
      }
      this.$emit("left-check-change", null, null, this.from_check_all);      
    },
    // 目标数据 总全选checkbox
    toAllBoxChange(val) {
      if (this.self_to_data.length == 0) {
        return;
      }
      if (val) {
        this.to_check_keys = this.self_to_data;
        this.$refs["to-tree"].setCheckedNodes(this.self_to_data);
      } else {
        this.$refs["to-tree"].setCheckedNodes([]);
        this.to_check_keys = [];
      }
      this.$emit("right-check-change", null, null, this.to_check_all);         
    },
    // 源数据 筛选
    filterNodeFrom(value, data) {
      if (!value) return true;
      return data[this.defaultProps.label].toLowerCase().indexOf(value.toLowerCase()) !== -1;
    },
    // 目标数据筛选
    filterNodeTo(value, data) {
      if (!value) return true;
      return data[this.defaultProps.label].toLowerCase().indexOf(value.toLowerCase()) !== -1;
    },
    // 通讯录模式 穿梭操作
    addressListTransfer(type) {
      // 获取选中通过穿梭框的keys - 仅用于传送纯净的id数组到父组件同后台通信
      let keys = this.$refs["from-tree"].getCheckedKeys(true);
      // 选中节点数据
      let arrayCheckedNodes = this.$refs["from-tree"].getCheckedNodes(true);
      // 去重筛选
      let arrayDeWeighting = [];
      switch (type) {
        case 0:
          arrayDeWeighting = arrayCheckedNodes.filter(item => {
            if (
              !this.addressee.some(
                ite => ite[this.node_key] == item[this.node_key]
              )
            ) {
              return item;
            }
          });
          this.addressee = [...this.addressee, ...arrayDeWeighting];
          break;
        case 1:
          arrayDeWeighting = arrayCheckedNodes.filter(item => {
            if (
              !this.Cc.some(ite => ite[this.node_key] == item[this.node_key])
            ) {
              return item;
            }
          });
          this.Cc = [...this.Cc, ...arrayDeWeighting];
          break;
        case 2:
          arrayDeWeighting = arrayCheckedNodes.filter(item => {
            if (
              !this.secret_receiver.some(
                ite => ite[this.node_key] == item[this.node_key]
              )
            ) {
              return item;
            }
          });
          this.secret_receiver = [...this.secret_receiver, ...arrayDeWeighting];
          break;
      }

      // 处理完毕取消选中
      this.$refs["from-tree"].setCheckedKeys([]);

      // 处理完毕按钮恢复禁用状态
      this.from_check_keys = [];

      // 传递信息给父组件
      this.$emit("addBtn", this.addressee, this.Cc, this.secret_receiver);
    },
    // 清理 通讯录选中 数据
    clearList(type, id) {
      switch (type) {
        case 0:
          this.addressee =
            id == "all"
              ? []
              : this.addressee.filter(item => item[this.node_key] != id);
          break;
        case 1:
          this.Cc =
            id == "all"
              ? []
              : this.Cc.filter(item => item[this.node_key] != id);
          break;
        case 2:
          this.secret_receiver =
            id == "all"
              ? []
              : this.secret_receiver.filter(item => item[this.node_key] != id);
          break;
      }
      // 传递信息给父组件
      this.$emit("removeBtn", this.addressee, this.Cc, this.secret_receiver);
    },
    // 右侧 通讯录 上下自动
    moveUp(type) {
      if (type == "up") {
        this.move_up = true;
      } else {
        this.move_up = false;
      }
    },
    add(){
      this.setNodeInput(0);
    },
    addChildren(){
      let current = this.$refs['to-tree-show'].getCurrentNode()
      if (!current){
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      if (this.leafDatas.length > 0){
        this.$message({
          message: '此构件已关联图元，如需调整层级关系请移除所有图元',
          type: 'error'
        })
      }else{
        this.setNodeInput(1);
      }
    },
    edit(){
      let current = this.$refs['to-tree-show'].getCurrentNode()
      if (!current){
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      this.form.label = current.label
      this.setNodeInput(2)
    },
    setNodeInput(dialogMode){
      this.dialogVisible = true
      this.dialogMode = dialogMode;
      this.$nextTick(() => {
        this.$refs.addNodeInput.focus();
      });
    },
    eachArr(arr, v, e) {
      arr.forEach((item) => {
        if (item.data) {
          v.push(item)
        }else {
          if (e){
            e.push(item.id)
          }
        }
        if (item.children.length > 0) {
          this.eachArr(item.children, v, e)
        }
        if (item.leafChildren && item.leafChildren.length > 0) {
          this.eachArr(item.leafChildren, v, e)
        }
      })
    },
    del(){
      let current = this.$refs['to-tree-show'].getCurrentNode()
      if (current){
        let leafs = []
        let nodes = []
        this.eachArr([current], leafs, nodes)
        this.delNodes = [...this.delNodes, ...nodes]
        leafs.forEach(item =>{
          this.delLeafs.set(item.id ,item.id+'-'+item.moduleId)
          let node = this.$refs["from-tree"].getNode(item.id)
          if (node){
            this.$set(node.data, 'disabled', false)
          }
          this.leafDatas = this.leafDatas.filter(node => {
            return node.id !== item.id
          })
        })
        this.$refs['to-tree-show'].remove(current)
        this.rightCurrentNode = {}
      }else{
        this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
    },
    up(){
      let key = this.$refs['to-tree-show'].getCurrentKey()
      if (!key){
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      let current = this.$refs['to-tree-show'].getNode(key)
      let parentNode = current.parent
      let cIndex = parentNode.data.children.findIndex(item => item.id === key)
      if (cIndex !== 0){
        let children = parentNode.data.children
        const tempChildrenNodex1 = children[cIndex - 1]
        this.$refs['to-tree-show'].remove(tempChildrenNodex1)
        this.$refs['to-tree-show'].insertAfter(tempChildrenNodex1, current)
      }
    },
    down(){
      let key = this.$refs['to-tree-show'].getCurrentKey()
      if (!key){
        return this.$message({
          message: '请先选择节点',
          type: 'error'
        })
      }
      let current = this.$refs['to-tree-show'].getNode(key)
      let parentNode = current.parent
      let cIndex = parentNode.data.children.findIndex(item => item.id === key)
      if (cIndex !== parentNode.data.children.length -1){
        let children = parentNode.data.children
        const tempChildrenNodex1 = children[cIndex + 1]
        this.$refs['to-tree-show'].remove(tempChildrenNodex1)
        this.$refs['to-tree-show'].insertBefore(tempChildrenNodex1, current)
      }
    },
    nameSubmit(){
      this.$refs.nameForm.validate((valid) => {
        if (valid) {
          let current = this.$refs['to-tree-show'].getCurrentNode()
          let d = {id:this.$uuid.v1(), label: this.form.label, children:[], leafChildren:[]}
          if (current){
            if (this.dialogMode === 0){
              this.$refs['to-tree-show'].insertAfter(d, current)
            }
            else if (this.dialogMode === 1){
              current.children.push(d)
            }else if(this.dialogMode === 2){//编辑
              current.label = this.form.label
            }
          }else {
            this.rightData.push(d)
          }
          
          this.dialogVisible = false
          this.form = {label:''}
          if (this.dialogMode === 0 || this.dialogMode === 1){
            this.defaultExpand[0] = d.id
            this.$nextTick(()=>{
              this.$refs['to-tree-show'].setCurrentNode(d)
              this.currentChange(d)
            })
            if (this.dialogMode === 1){
              this.delNodes.push(current.id)
            }
          }
        } else {
          return false;
        }
      });
    }
  },
  computed: {
    // 左侧数据
    self_from_data() {
      let from_array = [...this.from_data];
      
      if (!this.arrayToTree) {
        from_array.forEach(item => {
          item[this.pid] = 0;
        });
        return from_array;
      } else {
        let tree = arrayToTree(from_array, {
          id: this.node_key,
          pid: this.pid,
          children: this.defaultProps.children
        });
        return tree
      }
    },
    // 右侧数据
    self_to_data() {
      let to_array = [...this.to_data];
      if (!this.arrayToTree) {
        to_array.forEach(item => {
          item[this.pid] = 0;
        });
        return to_array;
      } else {
        return arrayToTree(to_array, {
          id: this.node_key,
          pid: this.pid,
          children: this.defaultProps.children
        });
      }
    },
    // 左侧菜单名
    fromTitle() {
      let [text] = this.title;
      return text;
    },
    // 右侧菜单名
    toTitle() {
      let [, text] = this.title;
      return text;
    },
    // 右侧菜单名2
    toTitleSecond() {
      let [, , text] = this.title;
      return text;
    },
    // 右侧菜单名3
    toTitleThird() {
      let [, , , text] = this.title;
      return text;
    },
    // 上部按钮名
    fromButton() {
      if (this.button_text == undefined) {
        return;
      }

      let [text] = this.button_text;
      return text;
    },
    // 下部按钮名
    toButton() {
      if (this.button_text == undefined) {
        return;
      }
      let [, text] = this.button_text;
      return text;
    },
    searchExtData(){
      if (this.searchExtText){
        return this.leafDatas.filter(item =>{
          return item.label.toLowerCase().indexOf(this.searchExtText.toLowerCase()) !== -1
        })
      }else {
        return this.leafDatas
      }
    }
  },
  watch: {
    // 左侧 状态监测
    from_check_keys(val) {
      if (val.length > 0) {
        // 穿梭按钮是否禁用
        let current = this.$refs['to-tree-show'].getCurrentNode()
        if (current && current.children.length === 0 ){
          this.from_disabled = false;
        }
        // 总半选是否开启
        // this.from_is_indeterminate = true;

        // // 总全选是否开启 - 根据选中节点中为根节点的数量是否和源数据长度相等
        // let allCheck = val.filter(item => item[this.pid] == 0);
        // if (allCheck.length == this.self_from_data.length) {
        //   // 关闭半选 开启全选
        //   this.from_is_indeterminate = false;
        //   this.from_check_all = true;
        // } else {
        //   this.from_is_indeterminate = true;
        //   this.from_check_all = false;
        // }
      } else {
        // this.from_disabled = true;
        // this.from_is_indeterminate = false;
        // this.from_check_all = false;
      }
    },
    // 右侧 状态监测
    to_check_keys(val) {
      if (val.length > 0) {
        // 穿梭按钮是否禁用
        this.to_disabled = false;
        // 总半选是否开启
        this.to_is_indeterminate = true;

        // 总全选是否开启 - 根据选中节点中为根节点的数量是否和源数据长度相等
        let allCheck = val.filter(item => item[this.pid] == 0);
        if (allCheck.length == this.self_to_data.length) {
          // 关闭半选 开启全选
          this.to_is_indeterminate = false;
          this.to_check_all = true;
        } else {
          this.to_is_indeterminate = true;
          this.to_check_all = false;
        }
      } else {
        this.to_disabled = true;
        this.to_is_indeterminate = false;
        this.to_check_all = false;
      }
    },
    // 左侧 数据筛选
    // filterFrom(val) {
    //   this.$refs["from-tree"].filter(val);
    // },
    // 通讯录模式 右1筛选
    filterListFirst(newval, oldval) {
      if (oldval == "") {
        this.archiveFirst = this.addressee;
      }
      if (newval == "") {
        this.addressee = this.archiveFirst;
      }
      let reg = RegExp(newval);
      this.addressee = this.addressee.filter(item => reg.test(item.label));
    },
    // 通讯录模式 右2筛选
    filterListSecond(newval, oldval) {
      if (oldval == "") {
        this.archiveSecond = this.Cc;
      }
      if (newval == "") {
        this.Cc = this.archiveSecond;
      }
      let reg = RegExp(newval);
      this.Cc = this.Cc.filter(item => reg.test(item.label));
    },
    // 通讯录模式 右3筛选
    filterListThird(newval, oldval) {
      if (oldval == "") {
        this.archiveThird = this.secret_receiver;
      }
      if (newval == "") {
        this.secret_receiver = this.archiveThird;
      }
      let reg = RegExp(newval);
      this.secret_receiver = this.secret_receiver.filter(item =>
        reg.test(item.label)
      );
    },
    // 监视默认选中
    defaultCheckedKeys(val) {
      if (val && this.defaultTransfer) {
        this.$nextTick(() => {
          this.addToAims(true);
        });
      }
    },
    initRightData(val) {
      this.rightData = val
    }
  }
};
</script>

<style scoped>
@import "./clear.css";
.el-tree {
  min-width: 100%;
  display: inline-block !important;
}

.transfer {
  position: relative;
  overflow: hidden;
}

.transfer-left {
  position: absolute;
  top: 0;
  left: 0;
}

.transfer-right {
  position: absolute;
  top: 0;
  right: calc(31% - 40px);
}

.transfer-right-ext {
  position: absolute;
  top: 0;
  right: 0;
  padding: 10px; 
  height: 100% 
  ;border: 1px solid #ebeef5;
  right: 1px;
  border-radius: 5px;
}

.transfer-right-item {
  height: calc((100% - 41px) / 2);
}

.transfer-right-small {
  height: 41px;
}

.transfer-right-only {
  height: 100%;
}

.transfer-main {
  padding: 10px;
  height: calc(100% - 41px);
  box-sizing: border-box;
  overflow: auto;
}

.left-tree {
  height: calc(100% - 45px);
  overflow: auto;
}

.transfer-left,
.transfer-right {
  border: 1px solid #ebeef5;
  height: 100%;
  box-sizing: border-box;
  border-radius: 5px;
  vertical-align: middle;
}

.transfer-left{
  width: 38%;
}

.transfer-right{
  width: calc(31% - 40px);
}

.transfer-center {
  position: absolute;
  top: 50%;
  left: 38%;
  width: 80px;
  transform: translateY(-50%);
  text-align: center;
}

.transfer-center-item {
  padding: 5px;
  overflow: hidden;
}

.address-list-center {
  height: 100%;
}

.address-list-center > .transfer-center-item {
  height: 50%;
  padding: 70px 10px 0;
  box-sizing: border-box;
  overflow: hidden;
}

.address-list-center > .address-only-item {
  height: 100%;
  position: relative;
}

.address-only-item > .address-first-btn {
  position: absolute;
  top: 50%;
  left: 50%;
  transform: translate(-50%, -50%);
}

.transfer-title {
  border-bottom: 1px solid #ebeef5;
  padding: 0 15px;
  height: 40px;
  line-height: 40px;
  color: #333;
  font-size: 16px;
  background-color: #f5f7fa;
}

.transfer-right-ext{
  width: calc(31% - 40px);
}

.transfer-title .el-checkbox {
  margin-right: 10px;
}

.filter-tree {
  margin-bottom: 10px;
  width: calc(100% - 62px);
}

.address-list-ul {
  padding-bottom: 20px;
}

.address-list-li {
  position: relative;
  padding: 4px 24px 4px 4px;
  border-radius: 3px;
  overflow: hidden; /*超出部分隐藏*/
  white-space: nowrap; /*不换行*/
  text-overflow: ellipsis; /*超出部分文字以...显示*/
}

.address-list-li:hover {
  background-color: #f5f7fa;
}

.address-list-li:hover .address-list-del {
  display: block;
}

.address-list-del {
  display: none;
  position: absolute;
  top: 50%;
  right: 2px;
  margin-top: -10px;
  width: 20px;
  height: 20px;
  line-height: 20px;
  border-radius: 50%;
  text-align: center;
  background-color: #fef0f0;
  color: #f56c6c;
  cursor: pointer;
}

.u-clear {
  float: right;
  color: #67c23a;
  font-size: 14px;
  cursor: pointer;
}

.move_up_img {
  float: right;
  margin-top: 10px;
  width: 20px;
  height: 20px;
  cursor: pointer;
}

.move_down_img {
  transform: rotate(180deg);
}

.totree{
  display: none !important
}

.el-button+.el-button{
  margin-left:0px
}

.typeTitle{
  font-size: 14px;
  margin-bottom: 10px;
  padding-left: 5px;
}
</style>

<style>
.transfer-center .el-button [class*=el-icon-]+span {
    margin-left: 0px;
}
</style>
