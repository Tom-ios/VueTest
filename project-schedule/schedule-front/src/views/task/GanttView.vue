<template>
  <div ref="pageDiv" class="clearfix">
    <el-row v-if="showTopInfoToolbar" style="border: 1px solid #EBEEF5;padding:8px 0px;font-size:14px;color:#606266" class="clearfix">
      <div style="float:left;">
        <span class="ml-10">编码</span>
        <el-input v-model="searchForm.taskCode" size="mini" style="width: 140px;margin-left:5px" clearable @keyup.enter.native="searchTaskByParam" />
      </div>
      <div style="float:left;">
        <span class="ml-20">名称</span>
        <el-input v-model="searchForm.taskName" size="mini" style="width: 140px;margin-left:5px" clearable @keyup.enter.native="searchTaskByParam" />
      </div>
      <div style="float:left;">
        <span class="ml-20">作业类型</span>
        <el-select
          v-model="searchForm.taskType"
          style="width: 140px;margin-left:5px"
          placeholder="全部"
          clearable
          size="mini"
          default-first-option
          @keyup.enter.native="searchTaskByParam"
        >
          <el-option v-for="item in taskTypeComboxOptions" :key="item.dictCode" size="small" :label="item.name" :value="item.dictCode" />
        </el-select>
      </div>
      <div style="font-size: 0;display: inline-block;">
        <el-button type="primary" class="ml-10" style="bottom:10px;" size="mini" @click="searchTaskByParam">查询</el-button>
        <!-- <el-button type="primary" class="ml-10" style="bottom:10px;" size="mini" @click="exportTask">导出</el-button> -->
        <el-button v-if="isEdit" type="primary" class="ml-10" style="bottom:10px;" size="mini" @click="showVersionHistory">版本记录</el-button>
        <template v-if="isCurrentUserCanOpt">
          <el-button v-if="isEdit" v-show="isOpenEdit" type="primary" size="mini" @click="commitTaskTable">提交版本</el-button>
        </template>
      </div>
      <template v-if="isCurrentUserCanOpt">
        <div style="float:right;font-size: 0;">
          <el-button v-if="isEdit" v-show="!isOpenEdit && eidtStatus && (approveStatus === '01' || approveChange || approveStatus === '04' || approveStatus === '05' || approveStatus === '07')" type="primary" size="mini" style="margin-right: 10px;" @click="handleGanttTableEdit">编辑</el-button>
          <el-button v-if="isEdit" v-show="isOpenEdit" type="primary" style="margin-right: 10px" size="mini" @click="saveTaskTable">保存</el-button>
          <el-button v-if="isEdit" v-show="isOpenEdit" style="margin-right: 10px" size="mini" @click="handleCancelGanttEdit">取消</el-button>
        </div>
      </template>
    </el-row>
    <el-row class="clearfix">
      <div style="margin-left:10px;" class="clearfix">
        <div class="mt-10 clearfix" style="float:left;font-size: 0;position:absolute;height:calc(100% - 10px);">
          <el-popover
            v-model="showCustomCol"
            title="自定义列"
            width="120px"
            trigger="click"
          >
            <CustomCol :prop-all-col="allCol" :prop-select-col="selCol" @selectCol="setTableColumn" />
            <el-button slot="reference" size="mini" plain :icon="customIcon">自定义列</el-button>
          </el-popover>

          <el-link :underline="false" class=" ml-10 button-group" @click="openTask">全部展开</el-link>
          <el-link :underline="false" class="ml-10 button-group" @click="closeTask">全部收起</el-link>
          <template v-if="isCurrentUserCanOpt">
            <el-link v-if="isEdit" v-show="isOpenEdit" :underline="false" class="ml-10 button-group" @click="addTaskBackward">新增同级节点</el-link>
            <el-link v-if="isEdit" v-show="isOpenEdit" :underline="false" class="ml-10 button-group" @click="addChildrenTask">新增子节点</el-link>
            <el-link v-if="isEdit" v-show="isOpenEdit" :underline="false" class="ml-10 button-group" @click="deleteTask"> 删除</el-link>
            <el-link v-if="isEdit" v-show="isOpenEdit" :underline="false" class="ml-10 button-group" @click="taskMoveUp">上移</el-link>
            <el-link v-if="isEdit" v-show="isOpenEdit" :underline="false" class="ml-10 button-group" @click="taskMoveDown">下移</el-link>
            <el-button v-if="isEdit" v-show="isOpenEdit" type="primary" class="ml-10" size="mini" @click="importFromTemplate">从模板导入</el-button>
            <el-button v-if="isEdit" v-show="isOpenEdit" type="primary" class="ml-10" size="mini" @click="handleGenerateWeights">自动生成权重</el-button>
            <el-button v-if="isEdit" v-show="isOpenEdit" type="primary" class="ml-10" size="mini" @click="toWbsDateCheck">WBS时间校验</el-button>
            <el-button v-if="isEdit" v-show="!isOpenEdit" type="primary" class="ml-10" style="bottom:10px;" size="mini" @click="handleCalculateCriticalPath">计算关键路径</el-button>
            <el-button v-if="isEdit" v-show="!isOpenEdit && isFilterCriticalTask" type="primary" class="ml-10" style="bottom:10px;" size="mini" @click="handleCalculateCriticalPath(1)">过滤关键活动</el-button>
            <el-button v-show="!isOpenEdit && !isFilterCriticalTask" type="primary" class="ml-10" style="bottom:10px;" size="mini" @click="handleCalculateCriticalPath(0)">取消过滤关键活动</el-button>
          </template>
          <el-checkbox v-if="!isOpenEdit" v-model="showDetail" style="float:right;margin-left:10px;margin-top:8px">显示资源/前置</el-checkbox>
        </div>
        <div class="mt-10" style="float:right;font-size: 0;height:28px;">
          <el-button type="primary" size="mini" @click="zoomIn()">放大</el-button>
          <el-button type="primary" size="mini" style="margin-right: 10px;" @click="zoomOut()">缩小</el-button>
          <el-select
            v-if="isEdit"
            v-show="isOpenEdit"
            v-model="selectTimeScaleValue"
            size="mini"
            style="width:100px;margin-right: 10px;"
            @change="handleChangTimeScale"
          >
            <el-option label="年/季" :value="'1'" />
            <el-option label="年/月" :value="'2'" />
            <el-option label="季/月" :value="'3'" />
            <el-option label="月/周" :value="'4'" />
            <el-option label="周/天" :value="'5'" />
          </el-select>
        </div>
        <!-- </div> -->
      </div>
    </el-row>
    <div class="mt-10" :style="{'position':'relative'}">
      <gantt
        id="00"
        ref="gantDiv"
        :drag-branch-free="false"
        :drag-move-date="false"
        :drag-resize-date="false"
        :style="{'height':maxGridHeight+'px','width':showDetail?'100%':'100%'}"
        :tasks="tasks"
        :gant-columns="tablecolumn"
        :filter="onBeforeTaskDisplay"
        @clickRow="clickGanttGridRow"
        @doubleClick="doubleClickGanttGrid"
        @initOver="initOver"
      />
      <div v-if="showDetail" ref="rightDetail" :style="{'position':'absolute','width':rightWidth+'px','background':'white','top':'1px','right':'1px','bottom':'1px','padding-left':'5px','padding-right':'20px'}">
        <el-row style="margin-top:10px">
          <span v-if="isOpenEdit && (currentObj && currentObj.operate)">
            <label style="font-size:14px;color:#606266;">作业类型：</label>
            <el-select v-model="taskForm.data.taskType" :disabled="taskForm.data.deleteFlag === '1'" size="small" placeholder="请选择" style="width:20%;" @change="handleTaskTypeChang">
              <el-option v-for="item in taskTypeComboxOptions" :key="item.dictCode" size="small" :label="item.name" :value="item.dictCode" />
            </el-select>
          </span>
          <el-tabs id="tabGroup" ref="tabGroup" v-model="activeName">
            <el-tab-pane v-show="isOpenEdit && currentObj " label="基本信息" name="first">
              <span v-if="taskForm.data.id &&( currentObj && currentObj.taskMold==='1')">
                <el-form ref="taskForm" :model="taskForm.data" class="form-wrap" label-width="45%" size="small" label-suffix="" :required="true" :rules="taskForm.rules">
                  <el-row class="edit-row" :gutter="0">
                    <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                      <el-form-item v-if="editMode === 'detail'" label="作业名称：">
                        <template>
                          {{ taskForm.data.wbsName }}
                        </template>
                      </el-form-item>
                      <el-form-item v-else label="作业名称：">
                        <template>
                          <el-input v-model.trim="taskForm.data.wbsName" maxlength="20" style="width:95%;" />
                        </template>
                      </el-form-item>

                    </el-col>
                    <template v-if="taskForm.data.taskType === '1'">
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item v-if="editMode==='detail'" label="负责人：">
                          <div class="el-input el-input--small" @click="taskForm.selVisible = true">
                            <span>{{ taskForm.data.principalName }}</span>
                          </div>
                        </el-form-item>
                        <el-form-item v-else label="负责人：" prop="principalId">
                          <div class="el-input el-input--small" @click="taskForm.selVisible = true">
                            <el-input v-model="taskForm.data.principalName" readonly size="small" placeholder="请选择" style="width:95%;" />
                          </div>
                        </el-form-item>
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item label="计算方式：" :prop="editMode === 'detail' ? '' : 'scheCalcType'">
                          <el-select v-model="taskForm.data.scheCalcType" :disabled="editMode === 'detail'" size="small" placeholder="请选择" style="width:95%;">
                            <el-option v-for="item in scheCalcTypeComboxOptions" :key="item.dictCode" :disabled="item.dictCode === '02'" size="small" :label="item.name" :value="item.dictCode" />
                          </el-select>
                        </el-form-item>
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item v-if="editMode==='detail'" label="权值：">
                          <div class="el-input el-input--small">
                            <span>{{ taskForm.data.weightValue }}</span>
                          </div>
                        </el-form-item>
                        <el-form-item v-else label="权值" prop="weightValue">
                          <el-input-number v-model="taskForm.data.weightValue" controls-position="right" step-strictly :min="1" :max="5" size="small" style="width:95%;" />
                        </el-form-item>

                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <!-- <div align="center"> -->
                        <div class="el-form-item  el-form-item--small">
                          <div class=" el-form-item__content" align="center">
                            <div class="el-input el-input--small">
                              <el-radio-group v-model="taskForm.data.setType" :disabled="editMode === 'detail'" style="width:95%;" @change="handleDateTypeRadioChange">
                                <el-radio :label="1">手动设置时间</el-radio>
                                <el-radio :label="0">自动计算时间</el-radio>
                              </el-radio-group>
                            </div>
                          </div>
                        </div>
                      <!-- </div> -->
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item label="计划开始时间：" prop="planStartDate">
                          <el-date-picker
                            v-model="taskForm.data.planStartDate"
                            style="width:95%;"
                            value-format="yyyy-MM-dd"
                            type="date"
                            :picker-options="pickerOptions('planStartDate')"
                            :disabled="taskForm.data.setType === 0"
                            @change="getTaskDuration"
                          />
                        </el-form-item>
                      </el-col>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item v-if="editMode === 'detail'" label="计划工期">
                          <template>
                            {{ taskForm.data.planDuration }}
                          </template>
                        </el-form-item>
                        <el-form-item v-else label="计划工期" prop="planDuration">
                          <template v-if="taskForm.data.setType === 1">
                            {{ taskForm.data.planDuration }}
                          </template>
                          <el-input v-else v-model.number="taskForm.data.planDuration" style="width:95%;" @input="handleDurationCalendarChange" />
                        </el-form-item>
                      </el-col>

                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item label="计划结束时间：" prop="planEndDate">
                          <el-date-picker
                            v-model="taskForm.data.planEndDate"
                            style="width:95%;"
                            value-format="yyyy-MM-dd"
                            type="date"
                            :picker-options="pickerOptions('planEndDate')"
                            :disabled="taskForm.data.setType === 0"
                            @change="getTaskDuration"
                          />
                        </el-form-item>

                      </el-col>
                    </template>
                    <template v-else>
                      <el-col :xl="8" :lg="12" :md="12" :sm="24" :xs="24">
                        <el-form-item
                          label="计划时间："
                          prop="planDate"
                          :rules="[
                            { required: true, message: '请选择计划日期'}
                          ]"
                        >
                          <el-date-picker
                            v-model="taskForm.data.planDate"
                            style="width:95%;"
                            value-format="yyyy-MM-dd"
                            type="date"
                            :picker-options="pickerOptions('planStartDate')"
                            @change="getTaskDuration"
                          />
                        </el-form-item>
                      </el-col>
                    </template>
                  </el-row>
                </el-form>
              </span>
              <div v-else style="text-align:center;margin-top:200px">请选择作业</div>
            </el-tab-pane>
            <el-tab-pane v-if="currentObj" label="逻辑关系" name="second">
              <div v-if="taskForm.data.id && currentObj.taskType === '1'" class="table-wrap edit-table">
                <div class="table-header clearfix">
                  <div class="buttons-right" style="margin-bottom:15px;">
                    <el-button v-if="(editMode !== 'detail') && isOpenEdit && currentObj.operate" type="primary" size="mini" @click="logicGridAddRow">新增
                    </el-button>
                  </div>
                </div>
                <el-form ref="logicTableForm" :model="logicGridForm">
                  <el-table
                    v-loading="logicGridForm.loading"
                    :data="logicGridForm.data"
                    row-key="id"
                    size="mini"
                    style="overflow-y:scroll"
                    :height="maxGridHeight-145"
                    border
                  >
                    <el-table-column label="序号" type="index" width="50" />
                    <el-table-column prop="taskPreCode" label="作业编码">
                      <template slot-scope="scope">
                        {{ scope.row.taskPreCode }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="taskPreName" label="作业名称">
                      <template slot-scope="scope">
                        {{ scope.row.taskPreName }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="relationshipId" label="关系类型" :label-class-name="isOpenEdit && currentObj.operate?'require':''">
                      <template slot-scope="scope">
                        <el-form-item
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.relationshipId'"
                          :rules="[{ required: true, message: '关系类型不能为空'}]"
                        >
                          <el-select
                            v-if=" isOpenEdit && currentObj.operate"
                            v-model="scope.row.relationshipId"
                            :disabled="editMode === 'detail'"
                            size="mini"
                            placeholder=""
                            default-first-option
                          >
                            <el-option v-for="item in relationshipComboxOptions" :key="item.dictCode" :disabled="item.dictCode === '3'" size="small" :label="item.name" :value="item.dictCode" />
                          </el-select>
                          <span v-else>{{ scope.row.relationshipName }}</span>
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column prop="intervalDays" label="延时（天）">
                      <template slot-scope="scope">
                        <template v-if="editMode === 'detail' || !(isOpenEdit && currentObj.operate) ">
                          {{ scope.row.intervalDays }}
                        </template>
                        <el-form-item
                          v-else
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.intervalDays'"
                        >
                          <el-input
                            v-model="scope.row.intervalDays"
                            oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                            size="mini"
                            placeholder="请输入延时天数"
                          />
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column v-if="editMode !== 'detail' && (isOpenEdit && currentObj.operate) " prop="type" label="操作">
                      <template slot-scope="scope">
                        <el-button icon="el-icon-delete" size="mini" type="danger" @click="logicGridRowDelete(scope.$index)">删除</el-button>
                      </template>
                    </el-table-column>
                  </el-table>
                </el-form>
              </div>
              <div v-else style="text-align:center;margin-top:200px ">请选择作业</div>
              <el-dialog
                title="选择作业"
                append-to-body
                :close-on-click-modal="false"
                :visible.sync="showSelectTaskDialog"
                @close="handleSelectTaskDialogClose"
              >
                <div style="height:350px;position:relative;">
                  <TaskTreeGridView :task-tree-data="taskTreeData" :current-task="taskForm.data" :logic-grid-data="logicGridForm.data" @multiple-selection="taskMultipleSelectionMethod" />
                </div>
                <span slot="footer">
                  <el-button type="default" size="mini" @click="handleSelectTaskDialogClose">取消</el-button>
                  <el-button type="primary" size="mini" @click="handleSelectTask">确定</el-button>
                </span>
              </el-dialog>

            </el-tab-pane>
            <el-tab-pane v-if="currentObj" label="资源" name="third">
              <div v-if="taskForm.data.id && currentObj.taskType === '1'" class="table-wrap edit-table">
                <div class="table-header clearfix">
                  <div class="buttons-right" style="margin-bottom:15px;">
                    <el-button v-if="editMode !== 'detail' && isOpenEdit && (currentObj && currentObj.operate)" type="primary" size="mini" @click="resourceGridAddRow">新增
                    </el-button>
                  </div>
                </div>
                <el-form ref="resourceTableForm" :model="resourceGridForm">
                  <el-table
                    v-loading="resourceGridForm.loading"
                    :data="resourceGridForm.data"
                    row-key="id"
                    :row-style="{height:'15px'}"
                    :cell-style="{padding:'2px'}"
                    size="mini"
                    border
                    style="overflow-y:scroll"
                    :height="maxGridHeight-145"
                  >
                    <el-table-column label="序号" type="index" width="50" />
                    <el-table-column prop="resCode" label="资源代码">
                      <template slot-scope="scope">
                        {{ scope.row.resCode }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="resName" label="资源名称">
                      <template slot-scope="scope">
                        {{ scope.row.resName }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="resTypeName" label="资源类型">
                      <template slot-scope="scope">
                        {{ scope.row.resTypeName }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="resModel" label="规格型号">
                      <template slot-scope="scope">
                        {{ scope.row.resModel }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="unitEstimate" label="计量单位">
                      <template slot-scope="scope">
                        {{ scope.row.unitEstimate }}
                      </template>
                    </el-table-column>
                    <el-table-column prop="unitPrice" label="单价（元）" :label-class-name="isOpenEdit && currentObj.operate?'require':''" width="120">
                      <template slot-scope="scope">
                        <template v-if="editMode === 'detail' || !(isOpenEdit && currentObj.operate)">
                          {{ scope.row.unitPrice }}
                        </template>
                        <el-form-item
                          v-else
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.unitPrice'"
                          :rules="priceRule"
                        >
                          <el-input v-model="scope.row.unitPrice" size="mini" placeholder="请输入内容" />
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column prop="amount" label="数量" :label-class-name="isOpenEdit && currentObj.operate?'require':''" width="120">
                      <template slot-scope="scope">
                        <template v-if="editMode === 'detail' || !(isOpenEdit && currentObj.operate)">
                          {{ scope.row.amount }}
                        </template>
                        <el-form-item
                          v-else
                          v-model.number="scope.row.amount"
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.amount'"
                          :rules="amountRule"
                        >
                          <el-input v-model.number="scope.row.amount" size="mini" placeholder="请输入内容" />
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column prop="startDate" label="开始日期" :label-class-name="isOpenEdit && currentObj.operate?'require':''" min-width="180">
                      <template slot-scope="scope">
                        <el-form-item
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.startDate'"
                          :rules="[{ required: true, message: '请选择开始日期'}]"
                        >
                          <el-date-picker
                            v-if="isOpenEdit && currentObj.operate"
                            v-model="scope.row.startDate"
                            :readonly="editMode === 'detail'"
                            value-format="yyyy-MM-dd"
                            :picker-options="pickerOptions('resourceGridRowBeginDate',scope.row.endDate)"
                            type="date"
                          />
                          <span v-else>
                            {{ scope.row.startDate }}
                          </span>
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column prop="endDate" label="结束日期" :label-class-name="isOpenEdit && currentObj.operate?'require':''" min-width="180">
                      <template slot-scope="scope">
                        <el-form-item
                          label-width="0px"
                          :prop="'data.' + scope.$index + '.endDate'"
                          :rules="[{ required: true, message: '请选择结束日期'}]"
                        >
                          <el-date-picker
                            v-if="isOpenEdit && currentObj.operate"
                            v-model="scope.row.endDate"
                            :readonly="editMode === 'detail'"
                            value-format="yyyy-MM-dd"
                            :picker-options="pickerOptions('resourceGridRowEndDate',scope.row.startDate)"
                            type="date"
                          />
                          <span v-else>
                            {{ scope.row.endDate }}
                          </span>
                        </el-form-item>
                      </template>
                    </el-table-column>
                    <el-table-column v-if="editMode !== 'detail' && (isOpenEdit && currentObj.operate)" label="操作" width="120">
                      <template slot-scope="scope">
                        <el-button icon="el-icon-delete" type="danger" size="mini" @click="resourceGridRowDelete(scope.$index)">删除</el-button>
                      </template>
                    </el-table-column>
                  </el-table>
                </el-form>
              </div>
              <div v-else style="text-align:center;margin-top:200px">请选择作业</div>
            </el-tab-pane>
          </el-tabs>
        </el-row>
      </div>
    </div>
    <el-dialog
      title="版本记录"
      :visible.sync="showTaskVersionHistory"
      width="1000px"
      :close-on-click-modal="false"
      @close="showTaskVersionHistory=false"
    >
      <template v-if="showTaskVersionHistory">
        <TaskVersionHistory
          v-if="isEdit && isCurrentUserCanOpt"
          :is-edit="isEdit"
          :row-handle="rowHandle"
          @after-version-recover="fetchTaskList"
          @to-task-version-detail="handleToTaskVersionDetail"
        />
        <TaskVersionHistory
          v-else
          :is-edit="isEdit"
        />
      </template>
    </el-dialog>
    <el-dialog
      title="查看历史版本"
      :visible.sync="showTaskVersionDetail"
      :close-on-click-modal="false"
      custom-class="task-version-detail-dialog"
      @close="handleCloseTaskVersionDetailDialog"
    >
      <div
        id="taskVersionDetailDiv"
        style="height:calc(100% -54px);width:100%;position:absolute;top: 54px;right: 0;bottom: 0;left: 0;"
      >
        <!-- <TaskVersionDetail /> -->
        <iframe v-if="showTaskVersionDetail" :src="taskVersionDetailSrc" style="width:100%;height:100%;border:none;" />
      </div>
    </el-dialog>
    <el-dialog
      title="选择模板"
      center
      :visible.sync="showTemplateDialog"
      custom-class="select-template-dialog"
      :close-on-click-modal="false"
      @close="showTemplateDialog=false"
    >
      <div
        style="height:calc(100% -54px);width:100%;position:absolute;top: 54px;right: 0;bottom: 0;left: 0;"
      >
        <TaskTemplate :is-detail="true" @after-template-selection="afterTemplateSelection" />
      </div>
    </el-dialog>
    <el-dialog
      :close-on-click-modal="false"
      title="增加资源"
      :visible.sync="resourceDialogVisible"
      class="select-resource-dialog"
      width="60%"
      :body-style="{ padding: '20px 0px 0px' }"
      @close="cancelSetResource"
    >
      <div style="height:460px;position:relative;">
        <Resource ref="setResource" :cur-sel-rows="setResource.curSelRows" select-type="multiple" key-word="resId" @resourceTypeChange="resourceTypeChange" />
      </div>
      <span slot="footer">
        <el-button size="mini" @click="cancelSetResource">取 消</el-button>
        <el-button type="primary" size="mini" @click="handleSetResouce">确 定</el-button>
      </span>
    </el-dialog>
    <el-dialog :visible.sync="wbsDateCheckVisble" width="80%" :show-close="true" title="WBS时间校验" :close-on-click-modal="false" top="15px">

      <div
        ref="wbsDateCheckDiv"
      >
        <WbsDateCheck :task-data="taskData" :show="wbsDateCheckVisble" style="position:absolute;top: 50px;right: 0;bottom: 50;left: 0;" @handleNewTasks="handleNewTasks" />
      </div>
    </el-dialog>
    <SelectPerople ref="sel" :visible.sync="taskForm.selVisible" sel-type="single" :is-fweb="true" :b-project-select="true" :url-param="{'wbsLevelId':curLevelInfo.wbsLevelId}" :init-datas="taskForm.data.principalId?[taskForm.data.principalId]:[]" :add-account="false" @sure="handleSel" />

  </div>
</template>
<script>
import Qs from 'qs'
import Gantt from '@/components/Gantt/index.vue'
import TaskVersionHistory from './TaskVersionHistoryView.vue'
import TaskTreeGridView from './TaskTreeGridView.vue'
import TaskTemplate from './Template.vue'
import WbsDateCheck from '@/views/wbs/WbsDateCheck.vue'
// import TaskVersionDetail from './taskVersionDetail.vue'
import Resource from '@/views/systemSet/resource/Resource'
import { getTaskList } from '@/api/taskView'
import { saveTaskTable, commitTaskTable, getCriticalPath, getWbsApproveStatus, getWbsCode, getWbsCodes, getTaskDuration, getProgrameSettings } from '@/api/taskEdit'
import { iterm, getTaskComboBox } from '@/api/taskComboBox'
import SelectPerople from '@/components/SelectPeople'
import CustomCol from '@/components/CustomCol/index.vue'
import { mapGetters } from 'vuex'
export default {
  components: {
    Gantt,
    TaskVersionHistory,
    TaskTreeGridView,
    TaskTemplate,
    WbsDateCheck,
    // TaskVersionDetail,
    Resource,
    SelectPerople,
    CustomCol
  },
  props: {
    isCurrentUserCanOpt: Boolean,
    curLevelInfo: {
      type: Object,
      default: function() { return {} }
    },
    maxHeight: {
      type: Number,
      default: 500
    },
    isEdit: {
      type: Boolean,
      default: true
    },
    taskVersionInfo: {
      type: Object,
      default: null
    },
    eidtStatus: {
      type: Boolean,
      default: false
    },
    approveStatus: {
      type: String,
      default: ''
    },
    approveChange: {
      type: Boolean,
      default: false
    },
    showInfoToolbar: {
      type: Boolean,
      default: true
    }
  },
  data() {
    return {
      rightWidth: 0,
      bApprove: false,
      priceRule: [{ required: true, message: '单价不能为空' }, { trigger: 'blur', validator: (rule, value, callback) => {
        const MoneyTest = /((^[1-9]\d*)|^0)(\.\d{0,2}){0,1}$/
        if (MoneyTest.test(value)) {
          callback()
        } else {
          callback(new Error('请输入非负数，最多两位小数'))
        }
      } }],
      amountRule: [{ required: true, message: '数量不能为空' }, { type: 'number', message: '请输入正整数' }, { trigger: 'blur', validator: (rule, value, callback) => {
        if (value > 0) {
          callback()
        } else {
          callback(new Error('请输入正整数'))
        }
      } }],

      showBuldVersion: false,
      showDetail: false,
      change: false,
      showTopInfoToolbar: this.showInfoToolbar,
      globalParam: { projectId: this.$route.params.id },
      selectTimeScaleValue: '4',
      projectSetting: {},
      deleteTaskArray: [],
      taskMultipleSelection: [],
      showSelectTaskDialog: false,
      logicGridForm: {
        data: [],
        tempData: [],
        loading: false
      },
      resourceGridForm: {
        data: [{
          id: '',
          code: 'M-0001',
          resName: '马',
          resType: '1',
          resModel: '',
          unitEstimate: '匹',
          unitPrice: 100,
          amount: 100,
          startDate: '2020-01-01',
          endDate: '2020-01-01',
          expCost: 1400
        }],
        loading: false
      },
      activeName: 'first',
      taskTypeComboxOptions: [{
        name: '里程碑',
        dictCode: '0'
      }, {
        name: '作业',
        dictCode: '1'
      }
      ],
      limitTypeComboxOptions: [{
        name: '尽可能晚',
        dictCode: '0'
      }, {
        name: '开始不晚于',
        dictCode: '1'
      }
      ],
      scheCalcTypeComboxOptions: [{
        name: '工期百分比',
        dictCode: '01'
      }, {
        name: '资源百分比',
        dictCode: '02'
      }, {
        name: '实际百分比',
        dictCode: '03'
      }
      ],
      calendarComboxOptions: [{
        name: '日历一',
        dictCode: '0'
      }, {
        name: '日历二',
        dictCode: '1'
      }, {
        name: '日历三',
        dictCode: '2'
      }
      ],
      expenseComboxOptions: [{
        name: '科目一',
        dictCode: '0'
      }, {
        name: '科目二',
        dictCode: '1'
      }, {
        name: '科目三',
        dictCode: '2'
      }
      ],
      principalComboxOptions: [{
        name: '川普',
        dictCode: '0'
      }, {
        name: '科比',
        dictCode: '1'
      }],
      relationshipComboxOptions: [{
        name: '完成-开始',
        dictCode: '0'
      }, {
        name: '完成-完成',
        dictCode: '2'
      }],
      planTypeComboxOptions: [{
        name: 'WBS',
        dictCode: '0'
      }, {
        name: '作业',
        dictCode: '1'
      }],
      showTaskVersionHistory: false,
      tablecolumn: [],
      searchForm: {
        taskName: '',
        taskCode: '',
        taskType: ''
      },
      maxGridHeight: 500,
      tasks: {
        parent: '',
        data: [
        ],
        links: []
      },
      currentObj: null,
      taskForm: {
        selVisible: false,
        data: {
          wbsName: '',
          wbsCode: '',
          principalId: '',
          principalName: '',
          planStartDate: '',
          taskType: '',
          scheCalcType: '',
          planEndDate: '',
          limitType: '',
          expenseId: '',
          calendarId: '',
          costCode: '',
          planDuration: '',
          planDate: '',
          taskMold: ''
        },
        tempData: {

        },
        tempTaskType: '',
        rules: {
          wbsName: [
            { required: true, message: '请输入作业名称', trigger: 'blur' },
            { max: 100, message: '限100字', trigger: 'blur' }
          ],
          // planStartDate: [
          //   { required: true, message: '请选择计划开始时间', trigger: 'blur' }
          // ],
          // planEndDate: [
          //   { required: true, message: '请选择计划结束时间', trigger: 'change' }
          // ],
          taskType: [
            { required: true, message: '请选择作业类型', trigger: 'change' }
          ],
          scheCalcType: [
            { required: true, message: '请选择进度计算方式', trigger: 'change' }
          ],
          limitType: [
            { required: true, message: '请选择限制条件', trigger: 'change' }
          ],
          /* calendarId: [
            { required: true, message: '请选择作业日历', trigger: 'change' }
          ], */
          principalId: [
            { required: true, message: '请选择负责人', trigger: 'change' }
          ],
          expenseId: [
            { required: true, message: '请选择费用科目', trigger: 'change' }
          ],
          planDuration: [{ required: true, message: '请输入计划工期' }, { type: 'integer', min: 1, message: '计划工期应为正整数' }],
          weightValue: [
            { required: true, trigger: 'change', message: '请输入权重' }
          ],
          planStartDate: [
            { required: false, trigger: 'change', message: '请选择开始日期' }
          ],
          planEndDate: [
            { required: false, trigger: 'change', message: '请选择结束日期' }
          ]
        }
      },
      editTaskDialogVisible: false,
      editMode: '',
      taskTreeData: [],
      isOpenEdit: false,
      showTemplateDialog: false,
      taskTemplatesSelected: [],
      showTaskVersionDetail: false,
      resourceDialogVisible: false,
      setResource: {
        curSelRows: [],
        curTabName: 'human'
      },
      taskVersionDetailSrc: '',
      isFilterCriticalTask: true,
      wbsDateCheckVisble: false,
      rowHandle: {
        width: '150px',
        custom: [
          {
            text: '查看',
            type: 'text',
            size: 'mini',
            emit: 'version-detail-view'
          }
        ],
        fixed: 'right'
      },
      showCustomCol: false,
      allCol: [],
      selCol: [],
      taskData: ''
    }
  },
  computed: {
    customIcon() {
      return this.showCustomCol ? 'el-icon-caret-top' : 'el-icon-caret-bottom'
    },
    gantDiv() {
      return this.$refs.gantDiv
    },
    ...mapGetters([
      'sidebar'
    ])

  },
  watch: {
    'sidebar.opened': {
      handler(v) {
        this.$nextTick(() => {
          if (!v) {
            this.rightWidth = this.rightWidth + 156
          } else {
            this.rightWidth = this.rightWidth - 156
          }
        })
      }
    },
    showDetail() {
      this.changeActive()
    },
    showInfoToolbar(v) {
      this.showTopInfoToolbar = this.showInfoToolbar
    },
    maxHeight(v) {
      this.maxGridHeight = this.maxHeight
    },
    editTaskDialogVisible(v) {
      if (!v) {
        var tasks = this.gantDiv.ganttObj.serialize()
        const data = this.convertToTreeData(tasks.data, '-1')
        this.taskTreeData = data
      }
    },
    resourceDialogVisible(v) {
      if (v) {
        this.$nextTick(() => {
          this.setResource.curSelRows = [...this.resourceGridForm.data]
        })
      }
    },
    isOpenEdit(v) {
      if (v) {
        this.showDetail = true
        this.rowHandle.custom = [
          {
            text: '查看',
            type: 'text',
            size: 'mini',
            emit: 'version-detail-view'
          }, {
            text: '复原至此版本',
            type: 'text',
            size: 'mini',
            emit: 'version-recover'

          }
        ]
      }
      this.changeActive()
    }
  },
  created() {
    this.getTaskComboBox()
    this.fetchTaskList()
    this.initTimeScaleValue()
    const vm = this
    this.$nextTick(() => {
      window.clickGridButton = function(id, action) {
        switch (action) {
          case 'edit':
            vm.handleTaskEdit({ id, action })
            break
          case 'delete':
            vm.deleteTaskById(id)
            break
          case 'detail':
            vm.handleTaskDetail({ id, action })
            break
        }
      }
      window.handlePlanTypeCovert = function(value) {
        return vm.planTypeComboxOptions.find((element) => (element.dictCode === value)).name
      }
      window.handleScheCalcTypeCovert = function(value) {
        return vm.scheCalcTypeComboxOptions.find((element) => (element.dictCode === value)).name
        // vm.handleScheCalcTypeCovert(value)
      }
      window.handleTaskTypeCovert = function(value) {
        return vm.taskTypeComboxOptions.find((element) => (element.dictCode === value)).name
        // vm.handleTaskTypeCovert(value)
      }
    })
  },
  mounted() {
    this.setTaskGridRowBackGroundColor()
    this.setTaskBackGroundColor()
    this.onGanttGridSelected()
    this.onAfterLinkDelete()
    this.onLinkDblClick()
    this.setTableColumn()
    this.rightWidth = this.$refs.pageDiv.clientWidth / 2 - 2
    // this.$refs.pageDiv.clientWidth
  },
  beforeDestroy() {
    if (!this.isOpenEdit && !this.isFilterCriticalTask) {
      this.handleCalculateCriticalPath(0)
    }
    this.gantDiv.ganttObj.clearAll()
  },
  methods: {
    changeActive() {
      if (this.isOpenEdit) {
        this.activeName = 'first'
      } else {
        this.activeName = 'second'
      }
    },
    initOver() {
      if (this.taskForm.data.id) {
        this.$nextTick(() => {
          this.handleTaskEdit({ id: this.taskForm.data.id, action: 'edit' })
          this.gantDiv.ganttObj.selectTask(this.taskForm.data.id)
          this.gantDiv.ganttObj.showTask(this.taskForm.data.id)
          const currenTask = this.gantDiv.ganttObj.getTaskBy('id', this.taskForm.data.id)
          this.currentObj = currenTask[0] || { }
        })
      }
    },
    convertTreeData(parent, arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj, parent)
        if (obj.childList) {
          this.tasks.parent = obj.id
          this.convertTreeData(obj.id, obj.childList, callBack)
          this.tasks.parent = ''
        }
      })
    },
    taskTreeDataEdit(arr, callBack) {
      arr.forEach((obj) => {
        callBack(obj)
        if (obj.childList) {
          this.taskTreeDataEdit(obj.childList, callBack)
        }
      })
    },
    fetchTaskList() {
      var param = {}
      if (this.taskVersionInfo) {
        param = this.taskVersionInfo
      } else {
        param = this.globalParam
      }
      getTaskList(param, Boolean(this.taskVersionInfo)).then(res => {
        var treeData = []
        if (this.currentObj) {
          this.currentObj = null
        }
        this.taskForm.data = {}
        this.tasks.links = []
        if (res.state === 'success') {
          this.convertTreeData('', res.data, (item, parent) => {
            if (!this.taskForm.data.id && item.taskMold === '1') {
              this.taskForm.data = { ...item, ...{ planDate: '' }} || {}
            }
            item.parent = parent || ''
            if (item.planStartDate && item.planEndDate) {
              item.start_date = item.planStartDate.split(' ')[0].split('-')[2] + '-' + item.planStartDate.split(' ')[0].split('-')[1] + '-' + item.planStartDate.split(' ')[0].split('-')[0]
              item.duration = item.planDuration
            } else {
              item.start_date = ''
              item.end_date = ''
              item.duration = '0'
              item.unscheduled = true
            }
            item.text = item.wbsName
            treeData.push(item)
            if (Array.isArray(item.relateList) && item.relateList.length) {
              for (let i = 0, len = item.relateList.length; i < len; i++) {
                this.tasks.links.push({ id: item.relateList[i].id, source: item.relateList[i].taskPreId, target: item.relateList[i].taskNextId, type: item.relateList[i].relationshipId })
                // links.push({ id: item.relateList[i].id, source: item.relateList[i].taskPreId, target: item.relateList[i].taskNextId, type: item.relateList[i].relationshipId })
              }
            }
          })
          this.tasks.data = [...treeData]
        } else {
          this.$message.error('初始化作业列表失败')
        }
      }).catch(
      ).finally(() => {
        if (this.taskVersionInfo) {
          // this.taskVersionInfo = null
          this.$emit('after-load-detail')
        }
      })
    },
    showCriticalPath() {
      this.gantDiv.ganttObj.destructor()
      alert('关键路径')
    },
    handleChangTimeScale(v) {
      if (v === '1') {
        this.setZoom('years-quarters')
      } else if (v === '2') {
        this.setZoom('months')
      } else if (v === '3') {
        this.setZoom('quarters-months')
      } else if (v === '4') {
        this.setZoom('weeks')
      } else {
        this.setZoom('days')
      }
    },
    taskMultipleSelectionMethod(tasks) {
      var tasks_ = []
      for (let i = 0, len = tasks.length; i < len; i++) {
        if (tasks[i].relateList && tasks[i].relateList.length > 0 && this.editMode === 'edit') {
          for (let j = 0, len = tasks[i].relateList.length; j < len; j++) {
            if (tasks[i].relateList[j].taskPreId === this.taskForm.data.id) {
              return this.$message.warning('当前作业已设为“' + tasks[i].wbsName + '”前置，不能互为前置')
            }
          }
        }
        tasks_.push({
          /* taskNextCode: tasks[i].wbsCode,
          taskNextName: tasks[i].wbsName,
          taskNextId: tasks[i].id
          */
          taskPreCode: tasks[i].wbsCode,
          taskPreName: tasks[i].wbsName,
          taskPreId: tasks[i].id
        })
      }
      this.taskMultipleSelection = tasks_
    },
    handleSelectTask() {
      this.showSelectTaskDialog = false
      this.taskMultipleSelection.forEach((item, index, array) => {
        //  item.relationshipId = '0'
        this.$set(item, 'relationshipId', '0')
      })
      this.logicGridForm.data.push(...this.taskMultipleSelection)
    },
    handleSelectTaskDialogClose() {
      this.showSelectTaskDialog = false
      this.editTaskDialogVisible = true
    },
    logicGridAddRow() {
      this.editTaskDialogVisible = false
      this.showSelectTaskDialog = true
    },
    logicGridRowDelete(index) {
      this.logicGridForm.data.splice(index, 1)
    },
    resourceGridAddRow() {
      this.editTaskDialogVisible = false
      this.resourceDialogVisible = true
    },
    resourceGridRowDelete(index) {
      this.resourceGridForm.data.splice(index, 1)
    },
    screenFull() {
      this.gantDiv.ganttObj.ext.fullscreen.toggle()
    },
    searchTaskByParam() {
      this.gantDiv.ganttObj.refreshData()
    },
    setTableColumn(arr) {
      // this.change = !this.change
      if (!this.$refs.gantDiv || !this.$refs.gantDiv.ganttObj) {
        return
      }
      if (this.allCol.length === 0) {
        this.allCol = [{
          name: 'wbs',
          label: '序号',
          width: 60,
          // width: 100,
          template: this.gantDiv.ganttObj.getWBSCode,
          align: 'left',
          disabled: true
        }, {
          label: '编码',
          name: 'wbsCode',
          width: 120,
          // width: 150,
          resize: true,
          align: 'left',
          template: function(obj) {
            if (obj.wbsCode) {
              return ('<span class="tag-pointer" title="' + obj.wbsCode + '">') + obj.wbsCode + ('</span>')
            }
          }
        }, {
          label: '名称',
          name: 'text',
          // width: 150,
          width: 200,
          tree: true,
          resize: true,
          align: 'left',
          disabled: true,
          template: function(obj) {
            if (!obj.parent) {
              return ('<span style="font-weight:700">') + obj.text + ('</span>')
            } else {
              return obj.text
            }
          }
        },
        {
          label: '类型',
          name: 'taskMold',
          width: 50,
          align: 'center',
          resize: true,
          template: function(obj) {
          // if (obj.taskMold === '0') {
          //   return 'WBS'
          // } else {
          //   return '作业'
          // }
            if (obj.taskMold) {
              if (obj.taskMold === '0') {
                return window.handlePlanTypeCovert(obj.taskMold)
              } else {
                return window.handleTaskTypeCovert(obj.taskType)
              }
            }
          }
        },
        {
          label: '前置任务',
          name: 'taskPreCodes',
          width: 120,
          align: 'left',
          resize: true,
          template: function(obj) {
            if (obj.taskPreCodes) {
              return ('<span class="tag-pointer" title="' + obj.taskPreCodes + '">') + obj.taskPreCodes + ('</span>')
            }
          }
        },
        // {
        //   label: '作业类型',
        //   name: 'taskType',
        //   width: 100,
        //   align: 'center',
        //   resize: true,
        //   template: function(obj) {
        //     if (obj.taskMold === '1') {
        //       /*  if (obj.taskType === '0') {
        //         return '里程碑'
        //       } else {
        //         return '作业'
        //       } */
        //       return window.handleTaskTypeCovert(obj.taskType)
        //     }
        //   }
        // },
        {
          label: '计划工期',
          name: 'planDuration',
          width: 100,
          align: 'center',
          resize: true,
          template: function(obj) {
          // if (!obj.unscheduled) {
            return obj.planDuration
          // } else {
          // return null
          // }
          }
        },
        {
          label: '计划开始时间',
          name: 'planStartDate',
          width: 100,
          align: 'center',
          resize: true
        }, {
          label: '计划结束时间',
          name: 'planEndDate',
          width: 100,
          align: 'center',
          resize: true
        }, {
          label: '权重%',
          name: 'weights',
          width: 80,
          align: 'center',
          resize: true
        }, {
          label: '权值',
          name: 'weightValue',
          width: 80,
          align: 'center',
          resize: true
        }, {
          label: '进度计算方式',
          name: 'scheCalcType',
          width: 80,
          align: 'center',
          resize: true,
          template: function(obj) {
            if (obj.scheCalcType) {
              return window.handleScheCalcTypeCovert(obj.scheCalcType)
            }
          }
        }, {
          label: '负责人',
          name: 'principalName',
          width: 100,
          align: 'center',
          resize: true
        }]
      }
      if (this.selCol.length === 0) {
        this.selCol = [{
          name: 'wbs',
          label: '序号',
          width: 150,
          template: this.gantDiv.ganttObj.getWBSCode,
          align: 'left'
        }, {
          label: '名称',
          name: 'text',
          width: 200,
          tree: true,
          resize: true,
          align: 'left',
          template: function(obj) {
            if (!obj.parent) {
              return ('<span style="font-weight:700">') + obj.text + ('</span>')
            } else {
              return obj.text
            }
          }
        }, {
          label: '计划工期',
          name: 'planDuration',
          width: 100,
          align: 'center',
          resize: true,
          template: function(obj) {
          // if (!obj.unscheduled) {
            return obj.planDuration
          // } else {
          // return null
          // }
          }
        },
        {
          label: '计划开始时间',
          name: 'planStartDate',
          width: 100,
          align: 'center',
          resize: true
        }, {
          label: '计划结束时间',
          name: 'planEndDate',
          width: 100,
          align: 'center',
          resize: true
        }, {
          label: '负责人',
          name: 'principalName',
          width: 100,
          align: 'center',
          resize: true
        }]
      }
      let tmpArr = []
      if (!arr) {
        this.selCol.forEach(element => {
          tmpArr.push(element.label)
        })
      } else {
        tmpArr = arr
      }

      var selArr = []
      this.allCol.forEach(itemCol => {
        tmpArr.forEach(label => {
          if (itemCol.label === label) {
            selArr.push(itemCol)
          }
        })
      })
      this.tablecolumn = [...selArr]
    },
    setTaskGridRowBackGroundColor() {
      this.gantDiv.ganttObj.templates.grid_row_class = function(start, end, task) {
        if (task.taskMold === '0') {
          return 'task-grid-wbs-row-background-color'
        }
        return ''
      }
    },
    setTaskBackGroundColor() {
      this.gantDiv.ganttObj.templates.task_class = function(start, end, task) {
        if (task.taskMold === '0') {
          return 'medium'
        }
      }
    },
    onGanttGridSelected() {
      this.gantDiv.ganttObj.attachEvent('onBeforeTaskSelected', function(id) {
        return true
      })
    },
    onLinkDblClick() {
      const vm = this
      this.gantDiv.ganttObj.attachEvent('onLinkDblClick', function(id, e) {
        // any custom logic here
        return vm.isOpenEdit
      })
    },
    onAfterLinkDelete() {
      var vm = this
      var ganttObj = vm.gantDiv.ganttObj
      ganttObj.attachEvent('onAfterLinkDelete', function(id, item) {
        ganttObj.eachTask(function(task) {
          if (task.relateList && task.relateList.length > 0) {
            for (let i = task.relateList.length - 1; i >= 0; i--) {
              if (id === task.relateList[i].id) {
                task.relateList.splice(i, 1)
              }
            }
            let taskPreCodes = ''
            for (let i = 0, len = task.relateList.length; i < len; i++) {
              if (i === len - 1) {
                taskPreCodes += task.relateList[i].taskPreCode
              } else {
                taskPreCodes += task.relateList[i].taskPreCode + ','
              }
            }
            task.taskPreCodes = taskPreCodes
            ganttObj.updateTask(task.id)
          }
          if (!task.parent && task.childList) {
            vm.taskTreeDataEdit(task.childList, (item) => {
              if (item.childList) {
                item.childList.forEach((val, key) => {
                  if (val.relateList && val.relateList.length > 0) {
                    for (let i = val.relateList.length - 1; i >= 0; i--) {
                      if (id === val.relateList[i].id) {
                        val.relateList.splice(i, 1)
                      }
                    }
                  }
                })
              }
            })
          }
        })
      })
    },
    addTask({ obj, event }, callback, flag) {
      // 获取wbsCode 编码
      this.editMode = 'add'
      this.handleEditTaskDialogOpen(flag).then(rescode => {
        this.taskForm.data = {
          id: this.getUUID(),
          wbsName: '',
          wbsCode: '',
          principalId: '',
          principalName: '',
          planStartDate: '',
          taskMold: '1',
          taskType: '1',
          scheCalcType: '',
          planEndDate: '',
          limitType: '',
          expenseId: '',
          calendarId: '',
          costCode: '',
          // duration: '',
          planDuration: '',
          operate: true,
          parent: obj.parent,
          _index: event,
          // ------------//
          // wbsId: obj.parent,
          wbsId: this.currentObj.taskMold === '0' ? this.currentObj.oldId : this.currentObj.wbsId,
          projectId: '' + this.globalParam.projectId,
          /* 权值 时间 */
          weightValue: 1,
          setType: 0,
          taskPreCodes: '',
          $open: true
        }
        /* resove plan start end date valid TODO review (replace with watch) */
        if (this.taskForm.data.setType) {
          this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = true
          this.taskForm.rules.planDuration[0].required = false
        } else {
          this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = false
          this.taskForm.rules.planDuration[0].required = true
        }
        this.$nextTick(() => {
          if (this.$refs.taskForm) {
            this.$refs.taskForm.clearValidate()
          }
        })
        this.logicGridForm.data = []
        this.resourceGridForm.data = []
        this.taskForm.data.wbsCode = rescode
        if (this.activeName !== 'first') {
          this.activeName = 'first'
        }
        this.editTaskDialogVisible = true
        if (callback && callback instanceof Function) {
          callback()
        }
      })
    },
    showVersionHistory() {
      this.showTaskVersionHistory = true
    },
    exportTask() {
      alert('导出')
    },
    validateTaskGrid() {
      var warningHtml
      var workTasks = this.gantDiv.ganttObj.getTaskBy('taskMold', '1')
      if (!workTasks || workTasks.length === 0) {
        // warningHtml = '<span style="color: #f56c6c;">还未添加任何作业，请先添加作业</span>'
        warningHtml = '<span>还未添加任何作业，请先添加作业</span>'
        this.$alert(warningHtml, '提示', {
          confirmButtonText: '确定',
          dangerouslyUseHTMLString: true,
          type: 'warning'
        })
        return false
      }
      var templateTasks = this.gantDiv.ganttObj.getTaskBy('add_from_template', true)
      for (let i = 0, len = templateTasks.length; i < len; i++) {
        if ((!templateTasks[i].principalId || !templateTasks[i].planDuration) && templateTasks[i].taskType === '1') {
          warningHtml = `第<strong>${templateTasks[i].$wbs}</strong>行<b>${templateTasks[i].text}</b>${!templateTasks[i].principalId ? '负责人为空' : '工期为空'}，请设置${!templateTasks[i].principalId ? '负责人' : '工期'}后再保存`
          // <span style="color: #f56c6c;"></span>
          this.$alert(warningHtml, '提示', {
            confirmButtonText: '确定',
            dangerouslyUseHTMLString: true,
            type: 'warning'
          })
          return false
        }
      }
      return true
    },
    convertToTreeData(data, pid) {
      const result = []
      let temp = []
      for (let i = 0; i < data.length; i++) {
        if (data[i].hasOwnProperty('childList')) {
          delete data[i].childList
        }
        const parentId = data[i].taskMold === '0' ? data[i].parentId : data[i].wbsId
        if (parentId === pid) {
          const obj = { ...data[i] }
          const id = data[i].taskMold === '0' ? data[i].oldId : data[i].id
          temp = this.convertToTreeData(data, id)
          if (temp.length > 0) {
            obj.childList = temp
          }
          result.push(obj)
        }
      }
      return result
    },
    saveTaskTable(type) {
      // 1作业 0里程碑
      if (this.isOpenEdit && this.currentObj && this.currentObj.id && this.currentObj.taskMold === '1') {
        this.handleTaskEditSubmit(() => {
          this.saveMethod(type)
        })
      } else {
        this.saveMethod(type)
      }
    },
    saveMethod(type) {
      var flag = false
      getWbsApproveStatus(this.globalParam).then(res => {
        flag = res
        if (!flag) {
          return this.$message.warning('待WBS审核通过后才能进行此操作')
        }
        this.caclWeight()
        if (!this.validateTaskGrid()) {
          return
        }
        var tasks = this.gantDiv.ganttObj.serialize()
        var data = this.convertToTreeData(tasks.data, '-1')
        saveTaskTable(data, { headers: {}, params: {
          projectId: this.globalParam.projectId,
          period: this.selectTimeScaleValue
        }}).then(res => {
          if (res.state === 'success') {
            type === 'weights' ? this.$message.success('成功生成权重') : this.$message.success('保存成功')
            if (type === 'weights') {
              //
            } else {
              this.$emit('after-approve-change')
            }
            this.fetchTaskList()
            //
            this.isOpenEdit = false
            this.emitBuildVersion()
          } else {
            this.$message.error('保存作业失败')
          }
        })
      })
    },
    async commitData() {
      var flag = false
      await getWbsApproveStatus(this.globalParam).then(res => {
        flag = res
      })
      if (!flag) {
        return this.$message.warning('待WBS审核通过后才能进行此操作')
      }
      if (!this.validateTaskGrid()) {
        return
      }
      this.$prompt('<span style="color:red">*</span>说明：提交后，当前作业自动生成一个新版本', '提交说明', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        inputPattern: /^(?=.{1,200}$)[\s\S]*.*[^\s][\s\S]*$/,
        inputType: 'textarea',
        dangerouslyUseHTMLString: true,
        inputErrorMessage: '输入不能为空，最多可输入200字符'
      }).then(({ value }) => {
        var serData = this.gantDiv.ganttObj.serialize()
        var tasks = this.convertToTreeData(serData.data, '-1')
        commitTaskTable({ remark: value,
          projectId: this.globalParam.projectId,
          submitFlag: 1
        }, tasks, { headers: {}}).then(res => {
          if (res.state === 'success') {
            this.$message.success('提交成功')
            // this.fetchTaskList()
          } else {
            this.$message.error('提交失败')
          }
        }).catch(() => {
        }).finally(() => {
        })
      }).catch(() => {
        this.$message({
          type: 'info',
          message: '取消输入'
        })
      })
    },
    commitTaskTable() {
      if (this.isOpenEdit && this.currentObj && this.currentObj.id && this.currentObj.taskMold === '1') {
        this.handleTaskEditSubmit(() => {
          this.commitData()
        })
      } else {
        this.commitData()
      }
    },
    addTaskBackward() {
      if (!this.currentObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'warning'
        })
      } else {
        if (this.currentObj.taskMold === '0') {
          return this.$message({
            message: '请选择作业节点',
            type: 'warning'
          })
        }
      }
      const me = this
      // 先保存当前节点
      this.handleTaskEditSubmit(() => {
        // 先增加在编辑更新
        // this.addTask({ obj: { parent: me.currentObj.parent }, event: parseInt(me.currentObj.$wbs.split('.')[me.currentObj.$wbs.split('.').length - 1]) })
        this.addTask({ obj: { parent: me.currentObj.parent }, event: this.gantDiv.ganttObj.getChildren(me.currentObj.parent).length }, () => {
          this.currentObj = null
          this.gantDiv.ganttObj.addTask(this.taskForm.data, this.taskForm.data.parent, this.taskForm.data._index)
          this.gantDiv.ganttObj.selectTask(this.taskForm.data.id)
          this.gantDiv.ganttObj.showTask(this.taskForm.data.id)
          const curTask = this.gantDiv.ganttObj.getTaskBy('id', this.taskForm.data.id)[0]
          this.clickGanttGridRow({ id: curTask.id, row: curTask })
        }, 'sameLevel')
      })
    },
    addChildrenTask() {
      if (!this.currentObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'warning'
        })
      } else {
        if (this.currentObj.taskMold === '0' && (!this.currentObj.childList || this.currentObj.childList.length === 0 || this.currentObj.childList[0].taskMold === '1')) {
          this.addTask({ obj: { parent: this.currentObj.id }}, () => {
            this.currentObj = null
            this.gantDiv.ganttObj.addTask(this.taskForm.data, this.taskForm.data.parent, this.taskForm.data._index)
            this.gantDiv.ganttObj.selectTask(this.taskForm.data.id)
            this.gantDiv.ganttObj.showTask(this.taskForm.data.id)
            const curTask = this.gantDiv.ganttObj.getTaskBy('id', this.taskForm.data.id)[0]
            this.clickGanttGridRow({ id: curTask.id, row: curTask })
          }, 'subLevel')
        } else {
          return this.$message({
            message: '请选择最后一级WBS节点',
            type: 'warning'
          })
        }
      }
    },
    // date1:小日期 date2:大日期
    DateMinus(startDate, endDate) {
      var sdate = new Date(startDate)
      var now = new Date(endDate)
      var days = now.getTime() - sdate.getTime()
      var day = parseInt(days / (1000 * 60 * 60 * 24))
      return day + 1
    },

    importFromTemplate() {
      if (!this.currentObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'warning'
        })
      } else {
        if (this.currentObj.taskMold === '0' &&
        (!this.currentObj.childList || this.currentObj.childList.length === 0 || this.currentObj.childList[0].taskMold === '1')) {
          this.showTemplateDialog = true
        } else {
          return this.$message({
            message: '请选择最后一级WBS节点',
            type: 'warning'
          })
        }
      }
    },

    addTaskBefore() {
      if (!this.currentObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'warning'
        })
      } else {
        if (this.currentObj.taskMold === '0') {
          return this.$message({
            message: '请选择作业节点',
            type: 'warning'
          })
        }
      }
      const vm = this
      this.addTask({ obj: { parent: vm.currentObj.parent }, event: parseInt(vm.currentObj.$wbs.split('.')[vm.currentObj.$wbs.split('.').length - 1]) - 1 })
      this.handleTaskEditSubmit()
      // this.$refs.gantDiv.ganttObj.selectedTasks(this.taskForm.data.id)
      // this.clickGanttGridRow()
    },
    deleteTask() {
      if (!this.currentObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'warning'
        })
      }
      // TODO 待优化
      var vm = this
      var selectId = vm.gantDiv.ganttObj.getSelectedId()
      var selectedTasks = vm.gantDiv.ganttObj.getTaskBy('id', selectId)
      vm.currentObj = selectedTasks[0]
      if (vm.currentObj.deleteFlag === '1') {
        return this.$message.warning('已填报进度的作业不能删除哦')
      }
      if (vm.currentObj.taskMold === '0') {
        return this.$message.warning('不能删除WBS计划哦')
      }
      if (this.currentObj.operate === false) {
        return this.$message.warning('只有创建人和负责人才可删除哦')
      }
      if (vm.currentObj) {
        var refreshCodeParam = {}
        vm.$confirm(`确定要删除该节点吗?`, '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          dangerouslyUseHTMLString: true
        }).then(() => {
          /* 是否需要刷新编码 */
          refreshCodeParam = {
            isRefreshCode: false,
            childrenNodes: [],
            childrenTaskNum: 0
          }
          var currentIndex = vm.gantDiv.ganttObj.getTaskIndex(vm.currentObj.id)
          var childrenTaskLength = vm.gantDiv.ganttObj.getChildren(vm.currentObj.parent).length
          if (currentIndex === childrenTaskLength - 1) {
            //
          } else {
            refreshCodeParam.isRefreshCode = true
            refreshCodeParam.parent = vm.gantDiv.ganttObj.getParent(vm.currentObj.id)
            refreshCodeParam.childrenNodes = vm.gantDiv.ganttObj.getTaskBy('parent', vm.gantDiv.ganttObj.getParent(refreshCodeParam.parent))
            refreshCodeParam.childrenTaskNum = childrenTaskLength - 1
          }
          // vm.deleteTaskArray.push(selectId)
          vm.gantDiv.ganttObj.unselectTask(vm.currentObj.id)
          vm.gantDiv.ganttObj.deleteTask(vm.currentObj.id)

          // TODO 待优化
          // const parentTask = this.gantDiv.ganttObj.getTaskBy('id', vm.currentObj.parent)

          // if (!parentTask[0].parent) {
          //   for (let i = parentTask[0].childList.length - 1; i >= 0; i--) {
          //     if (parentTask[0].childList[i].id === vm.currentObj.id) {
          //       parentTask[0].childList.splice(i, 1)
          //     }
          //   }
          // }
          // vm.gantDiv.ganttObj.eachParent(function(task) {
          //   if (!task.parent) {
          //     vm.taskTreeDataEdit(task.childList, (item) => {
          //       if (item.id === vm.currentObj.parent && item.childList) {
          //         for (let i = item.childList.length - 1; i >= 0; i--) {
          //           if (item.childList[i].id === vm.currentObj.id) {
          //             item.childList.splice(i, 1)
          //           }
          //         }
          //       }
          //     })
          //   }
          // }, vm.currentObj.parent)
          vm.currentObj = null
          vm.taskForm.data = {}
          return new Promise(resolve => {
            resolve(refreshCodeParam)
          })
        }).catch((err) => {
          console.log('----deleteErr', err)
          vm.currentObj = null
        }).then((refreshCodeParam) => {
          /* 刷新编码 */
          var wbsCodeArray = []
          if (refreshCodeParam && refreshCodeParam.isRefreshCode) {
            var params = { childFlag: 2,
              isChild: 2,
              codeType: 1
            }
            params.nodeList = refreshCodeParam.childrenNodes.map(function(item) {
              return item.wbsCode
            })
            params.total = refreshCodeParam.childrenTaskNum
            getWbsCodes(
              params
            ).then(res => {
              wbsCodeArray = res
              var childrenTasks = vm.gantDiv.ganttObj.getTaskBy('parent', refreshCodeParam.parent)
              for (let i = 0; i < refreshCodeParam.childrenTaskNum; i++) {
                childrenTasks[i].wbsCode = wbsCodeArray[i]
                vm.gantDiv.ganttObj.updateTask(childrenTasks[i].id)
              }
            }).catch(
            ).finally(() => {
            })
          }
        })
      } else {
        vm.$message({
          message: '请先选择节点',
          type: 'warning'
        })
      }
    },
    deleteTaskById(id) {
      var vm = this
      this.$confirm(`确定要删除该节点么?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        // this.deleteTaskArray.push(selectId)
        this.gantDiv.ganttObj.unselectTask(this.currentObj.id)
        this.gantDiv.ganttObj.deleteTask(this.currentObj.id)
        this.gantDiv.ganttObj.eachParent(function(task) {
          if (!task.parent) {
            vm.taskTreeDataEdit(task.childList, (item) => {
              if (item.id === vm.currentObj.parent) {
                for (let i = item.childList.length - 1; i >= 0; i--) {
                  if (item.childList[i].id === vm.currentObj.id) {
                    item.childList.splice(i, 1)
                  }
                }
              }
            })
          }
        }, vm.currentObj.parent)
        this.currentObj = null
      }).catch(() => {
      })
    },
    taskMoveUp() {
      if (!this.currentObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'warning'
        })
      } else {
        if (this.currentObj.taskMold === '0') {
          return this.$message({
            message: '请选择作业节点',
            type: 'warning'
          })
        }
      }
      /*      var childrenTasks = this.gantDiv.ganttObj.getTask(this.currentObj.parent).childList
      for (let i = 0, len = childrenTasks.length; i < len; i++) {
        if (childrenTasks[i].id === this.currentObj.id) {
          if (i > 0) {
            this.gantDiv.ganttObj.moveTask(childrenTasks[i].id, i - 1, this.currentObj.parent)
            const tempTask = childrenTasks[i - 1]
            childrenTasks[i - 1] = childrenTasks[i]
            childrenTasks[i] = tempTask
          }
        }
      } */
      var vm = this
      this.gantDiv.ganttObj.eachParent(function(task) {
        if (!task.parent) {
          vm.taskTreeDataEdit(task.childList, (item) => {
            if (item.id === vm.currentObj.parent) {
              for (let i = 0, len = item.childList.length; i < len; i++) {
                if (item.childList[i].id === vm.currentObj.id) {
                  if (i > 0) {
                    vm.gantDiv.ganttObj.moveTask(item.childList[i].id, i - 1, vm.currentObj.parent)
                    const tempTask = item.childList[i - 1]
                    item.childList[i - 1] = item.childList[i]
                    item.childList[i] = tempTask
                  }
                }
              }
            }
          })
        }
      }, vm.currentObj.parent)
    },
    taskMoveDown() {
      if (!this.currentObj) {
        return this.$message({
          message: '请先选择节点',
          type: 'warning'
        })
      } else {
        if (this.currentObj.taskMold === '0') {
          return this.$message({
            message: '请选择作业节点',
            type: 'warning'
          })
        }
      }
      var vm = this
      this.gantDiv.ganttObj.eachParent(function(task) {
        if (!task.parent) {
          vm.taskTreeDataEdit(task.childList, (item) => {
            if (item.id === vm.currentObj.parent) {
              for (let i = 0, len = item.childList.length; i < len; i++) {
                if (item.childList[i].id === vm.currentObj.id) {
                  if (i < item.childList.length - 1) {
                    vm.gantDiv.ganttObj.moveTask(item.childList[i].id, i + 1, vm.currentObj.parent)
                    const tempTask = item.childList[i + 1]
                    item.childList[i + 1] = item.childList[i]
                    item.childList[i] = tempTask
                    return
                  }
                }
              }
            }
          })
        }
      }, vm.currentObj.parent)
    },
    clickGanttGridRow({ id, row }) {
      if (this.$refs.gantDiv.ganttObj.getSelectedId() !== id) {
        this.$refs.gantDiv.ganttObj.selectTask(id)
        this.$refs.gantDiv.ganttObj.showTask(id)
      }
      if (this.isOpenEdit && this.currentObj && this.currentObj.id && this.currentObj.taskMold === '1') {
        this.handleTaskEditSubmit(() => {
          const currenTask = this.gantDiv.ganttObj.getTaskBy('id', id)
          this.currentObj = currenTask[0] || { }

          if (this.currentObj.taskMold === '1') {
            if (this.isOpenEdit) {
              if (this.currentObj.operate === false) {
                this.handleTaskEdit({ id, action: 'detail' })
              } else {
                this.handleTaskEdit({ id, action: 'edit' })
              }
            } else {
              this.handleTaskEdit({ id, action: 'detail' })
            }
          } else {
            this.handleTaskEdit({ id, action: 'detail' })
          }
        })
      } else {
        const currenTask = this.gantDiv.ganttObj.getTaskBy('id', id)
        this.currentObj = { ...currenTask[0] } || { }
        if (this.currentObj.taskMold === '1') {
          if (this.isOpenEdit) {
            if (this.currentObj.operate === false) {
              this.handleTaskEdit({ id, action: 'detail' })
            } else {
              this.handleTaskEdit({ id, action: 'edit' })
            }
          } else {
            this.handleTaskEdit({ id, action: 'detail' })
          }
        } else {
          this.handleTaskEdit({ id, action: 'detail' })
        }
      }
    },
    openTask() {
      const me = this
      this.gantDiv.ganttObj.eachTask(function(task) {
        me.gantDiv.ganttObj.open(task.id)
      })
    },
    closeTask() {
      const me = this
      this.gantDiv.ganttObj.eachTask(function(task) {
        me.gantDiv.ganttObj.close(task.id)
      })
    },
    handleTaskEditSubmit(callBack) {
      const vm = this
      let validPromise
      if (this.taskForm.data.taskType === '1') { // 作业
        validPromise = this.checkForm('taskForm')
          .then((value) => {
            if (value) {
              return this.checkForm('logicTableForm')
            }
          })
          .catch((e) => {
            if (e === 'taskForm') {
              this.activeName = 'first'
            } else {
              this.activeName = 'second'
            }
            // 此处为失败状态的回调， error即为以上reject函数里的error;

          // return true
          }).finally(() => {
          // 此处不管成功还是失败，都会执行，使用情况比较少。
          })
          .then((value) => {
            if (value) {
              return this.checkForm('resourceTableForm')
            }
          })
          .catch((e) => {
            // 此处为失败状态的回调， error即为以上reject函数里的error;
            if (e === 'logicTableForm') {
              this.activeName = 'second'
            } else {
              this.activeName = 'third'
            }
          }).finally(() => {
          // 此处不管成功还是失败，都会执行，使用情况比较少。
          })
      } else { // 里程碑
        validPromise = this.checkForm('taskForm')
      }
      validPromise.then((value) => {
        if (value) {
          if (this.taskForm.data.taskType === '0') {
            this.logicGridForm.data = []
            this.resourceGridForm.data = []
            this.taskForm.data.planStartDate = this.taskForm.data.planDate
            this.taskForm.data.planEndDate = this.taskForm.data.planDate
            this.taskForm.data.principalId = ''
            this.taskForm.data.principalName = ''
            this.taskForm.data.scheCalcType = ''
            this.taskForm.data.weightValue = ''
            this.taskForm.data.weights = ''
            this.taskForm.data.taskPreCodes = ''
          }
          // 前置任务
          const links = this.gantDiv.ganttObj.getLinks()
          for (let i = this.logicGridForm.tempData.length - 1; i >= 0; i--) {
            let flag = true
            for (let j = this.logicGridForm.data.length - 1; j >= 0; j--) {
              if (this.logicGridForm.tempData[i].id === this.logicGridForm.data[j].id) {
                flag = false
              }
            }
            if (flag) {
              if (this.logicGridForm.tempData[i].id) {
                this.gantDiv.ganttObj.deleteLink(this.logicGridForm.tempData[i].id)
              } else {
                for (let j = 0, len = links.length; j < len; j++) {
                  if (links[j].source === this.logicGridForm.tempData[i].taskPreId && links[j].target === this.taskForm.data.id) {
                    this.gantDiv.ganttObj.deleteLink(links[j].id)
                  }
                }
              }
            }
            // TODO update
          }
          for (let i = this.logicGridForm.data.length - 1; i >= 0; i--) {
            if (!this.logicGridForm.data[i].id) {
              this.gantDiv.ganttObj.addLink({
                source: this.logicGridForm.data[i].taskPreId,
                target: this.taskForm.data.id,
                type: this.logicGridForm.data[i].relationshipId
              })
            }
          }

          let taskPreCodes = ''
          for (let i = 0, len = this.logicGridForm.data.length; i < len; i++) {
            this.logicGridForm.data[i].intervalDays = this.logicGridForm.data[i].intervalDays || 0
            if (i === len - 1) {
              taskPreCodes += this.logicGridForm.data[i].taskPreCode
            } else {
              taskPreCodes += this.logicGridForm.data[i].taskPreCode + ','
            }
          }

          this.taskForm.data.taskPreCodes = taskPreCodes
          Object.assign(this.taskForm.data, { text: this.taskForm.data.wbsName,
            relateList: this.logicGridForm.data,
            resourceList: this.resourceGridForm.data,
            unscheduled: !(this.taskForm.data.planStartDate && this.taskForm.data.planEndDate),
            duration: this.taskForm.data.planDuration
          })
          if (this.taskForm.data.planStartDate && this.taskForm.data.planEndDate) {
            this.taskForm.data.duration = this.taskForm.data.planDuration
            this.taskForm.data.start_date = new Date(this.taskForm.data.planStartDate)
          }
          if (this.editMode === 'add') {
            this.gantDiv.ganttObj.addTask(this.taskForm.data, this.taskForm.data.parent, this.taskForm.data._index)
          } else if (this.editMode === 'edit') {
            for (var key in this.taskForm.data) {
              if (key === 'start_date') {
                if (this.taskForm.data.planStartDate) {
                  this.gantDiv.ganttObj.getTask(this.taskForm.data.id)[key] = new Date(this.taskForm.data.planStartDate)
                }
              } else if (key === 'end_date') {
                if (this.taskForm.data.planEndDate) {
                  const d = new Date(new Date(this.taskForm.data.planEndDate).getTime() + 24 * 60 * 60 * 1000)
                  const ed = d.getFullYear() + '-' + (d.getMonth() + 1) + '-' + d.getDate()
                  this.taskForm.data.end_date = new Date(ed)
                  this.gantDiv.ganttObj.getTask(this.taskForm.data.id)[key] = new Date(ed)
                }
              } else {
                this.gantDiv.ganttObj.getTask(this.taskForm.data.id)[key] = this.taskForm.data[key]
                this.gantDiv.ganttObj.updateTask(this.taskForm.data.id)
              }
            }

            // if (!parentTask[0].parent) {
            //   parentTask[0].childList.forEach((val, key) => {
            //     if (val.id === vm.taskForm.data.id) {
            //       Object.assign(val, vm.taskForm.data)
            //     }
            //   })
            // } else {
            //   this.gantDiv.ganttObj.eachParent(function(task) {
            //     if (!task.parent) {
            //       vm.taskTreeDataEdit(task.childList, (item) => {
            //         if (item.id === vm.taskForm.data.parent && item.childList) {
            //           item.childList.forEach((val, key) => {
            //             if (val.id === vm.taskForm.data.id) {
            //               Object.assign(val, vm.taskForm.data)
            //             }
            //           })
            //         }
            //       })
            //     }
            //   }, this.taskForm.data.parent)
            // }
            if ((this.taskForm.data.taskType === '0') && (this.taskForm.tempTaskType === '1')) {
              this.gantDiv.ganttObj.eachTask(function(task) {
                if (!task.parent && task.childList) {
                  vm.taskTreeDataEdit(task.childList, (item) => {
                    if (item.childList) {
                      item.childList.forEach((val, key) => {
                        if (val.relateList && val.relateList.length > 0) {
                          for (let i = val.relateList.length - 1; i >= 0; i--) {
                            if (vm.taskForm.data.id === val.relateList[i].taskPreId) {
                              val.relateList.splice(i, 1)
                            }
                          }
                        }
                      })
                    }
                  })
                }
              })
            }
            this.taskForm.tempTaskType = ''
          }
          // this.gantDiv.ganttObj.getTask(this.taskForm.data.parent).childList.forEach((val, key) => {
          //   if (val.id === this.taskForm.data.id) {
          //     Object.assign(val, this.gantDiv.ganttObj.getTask(this.taskForm.data.id))
          //   }
          // })
          this.editTaskDialogVisible = false
          if (callBack && callBack instanceof Function) {
            callBack(true)
          }
        } else {
          if (vm.taskForm.data.id) {
            this.gantDiv.ganttObj.selectTask(vm.taskForm.data.id)
            this.gantDiv.ganttObj.showTask(vm.taskForm.data.id)
          }
        }
      }).catch((err) => {
        console.log('----errr', err)
        if (vm.taskForm.data.id) {
          this.gantDiv.ganttObj.selectTask(vm.taskForm.data.id)
          this.gantDiv.ganttObj.showTask(vm.taskForm.data.id)
        }
      })
    },
    checkForm(formName, resultArr) { // 封装验证表单的函数
      var _self = this
      return new Promise(function(resolve, reject) {
        if (_self.$refs[formName]) {
          _self.$refs[formName].validate((valid) => {
            if (valid) {
              resolve(formName)
            } else {
              reject(formName)
            }
          })
        } else {
          resolve(formName)
        }
      })
    },
    handleTaskEdit({ id, action }) {
      this.changeActive()
      this.editMode = action
      const curTask = this.gantDiv.ganttObj.getTaskBy('id', id)
      this.taskForm.tempData = curTask[0]
      this.taskForm.tempTaskType = curTask[0].taskType
      // 作业基本信息
      this.taskForm.data = { ...curTask[0], ...{ planDate: '' }} || {}
      this.taskForm.data.wbsName = this.taskForm.data.text
      if (this.taskForm.data.taskType === '0') {
        this.taskForm.data.planDate = this.taskForm.data.planStartDate
      }
      if (this.taskForm.data.setType) {
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = true
        this.taskForm.rules.planDuration[0].required = false
      } else {
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = false
        this.taskForm.rules.planDuration[0].required = true
      }
      this.$nextTick(() => {
        if (this.$refs.taskForm) {
          this.$refs.taskForm.clearValidate()
        }
      })
      // 逻辑关系
      this.logicGridForm.data = JSON.parse(JSON.stringify(curTask[0].relateList || []))
      this.logicGridForm.tempData = [...this.logicGridForm.data]
      // 资源
      this.resourceGridForm.data = JSON.parse(JSON.stringify(curTask[0].resourceList || []))

      this.editTaskDialogVisible = true
    },
    handleTaskDetail({ id, action }) {
      this.changeActive()
      this.editMode = action
      const curTask = this.gantDiv.ganttObj.getTaskBy('id', id)
      // 作业基本信息
      this.taskForm.data = { ...curTask[0] }
      this.taskForm.data.wbsName = this.taskForm.data.text
      // 逻辑关系
      if (curTask[0].relateList) {
        this.logicGridForm.data = curTask[0].relateList
      } else {
        this.logicGridForm.data = []
      }
      // 资源
      if (curTask[0].resourceList) {
        this.resourceGridForm.data = curTask[0].resourceList
      } else {
        this.resourceGridForm.data = []
      }
      this.editTaskDialogVisible = true
    },
    resetForm(formName) {
      this.$nextTick(() => {
        this.$refs[formName].resetFields()
      })
    },
    handleTaskDisplay(arr, flag) {
      var vm = this
      arr.some((obj) => {
        const childrens = vm.gantDiv.ganttObj.getChildren(obj)
        if (childrens && childrens.length > 0) {
          for (let i = 0, len = childrens.length; i < len; i++) {
            const childrenTask = vm.gantDiv.ganttObj.getTask(childrens[i])
            if ((childrenTask.taskMold === '1' &&
              ((childrenTask.wbsCode.indexOf(vm.searchForm.taskCode) > -1 && vm.searchForm.taskCode) || (childrenTask.wbsName.indexOf(vm.searchForm.taskName) > -1 && vm.searchForm.taskName) || childrenTask.taskType === vm.searchForm.taskType)) ||
              (!vm.isFilterCriticalTask && childrenTask.criticalTask === '1')) {
              flag = true
              return flag
            } else {
              flag = this.handleTaskDisplay(childrens, flag)
            }
          }
        } else {
          const childrenTask = vm.gantDiv.ganttObj.getTask(obj)
          if ((childrenTask.taskMold === '1' &&
              ((childrenTask.wbsCode.indexOf(vm.searchForm.taskCode) > -1 && vm.searchForm.taskCode) || (childrenTask.wbsName.indexOf(vm.searchForm.taskName) > -1 && vm.searchForm.taskName) || childrenTask.taskType === vm.searchForm.taskType)) ||
               (!vm.isFilterCriticalTask && childrenTask.criticalTask === '1')) {
            flag = true
            return flag
          } else {
            flag = false
          }
        }
      })
      return flag
    },
    onBeforeTaskDisplay(id, task) {
      var vm = this
      if (task.taskMold === '0') {
        if (!vm.searchForm.taskCode && !vm.searchForm.taskName && !vm.searchForm.taskType && vm.isFilterCriticalTask) {
          return true
        }
        let flag = false
        flag = vm.handleTaskDisplay(vm.gantDiv.ganttObj.getChildren(id), flag)
        return flag
      }
      var count = 0
      if (this.searchForm.taskCode) {
        if (task.wbsCode.indexOf(this.searchForm.taskCode) > -1) {
          count++
        }
      } else {
        count++
      }
      if (this.searchForm.taskName) {
        if (task.wbsName.indexOf(this.searchForm.taskName) > -1) {
          count++
        }
      } else {
        count++
      }
      if (this.searchForm.taskType) {
        if (task.taskType === this.searchForm.taskType) {
          count++
        }
      } else {
        count++
      }
      if (!this.isFilterCriticalTask) {
        if (task.criticalTask === '1') {
          count++
        }
      } else {
        count++
      }
      if (count === 4) {
        return true
      } else {
        return false
      }
    },
    pickerOptions(param, beginDate) {
      const _self = this
      return {
        disabledDate(time) {
          switch (param) {
            case 'planEndDate':
              if (_self.taskForm.data.planStartDate) {
                return time.getTime() + (1000 * 60 * 60 * 24) < (new Date(_self.taskForm.data.planStartDate).getTime())
              } else {
                return false
              }
            case 'planStartDate':
              if (_self.taskForm.data.planEndDate) {
                return (new Date(_self.taskForm.data.planEndDate).getTime()) < time.getTime()
              } else {
                return false
              }

            case 'resourceGridRowEndDate':
              if (beginDate) {
                return (new Date(beginDate).getTime() - (1000 * 60 * 60 * 24)) >= time.getTime()
              } else {
                return false
              }
            case 'resourceGridRowBeginDate':
              if (beginDate) {
                return (new Date(beginDate).getTime()) <= time.getTime()
              } else {
                return false
              }
          }
        }
      }
    },
    emitBuildVersion() {
      this.showBuldVersion = !!((!this.isOpenEdit && this.projectSetting.scheWbsLevelList && this.projectSetting.scheWbsLevelList[this.projectSetting.scheWbsLevelList.length - 1].approval === 0))
      this.$emit('showBuildVersion', this.showBuldVersion)
    },
    async handleGanttTableEdit() {
      var flag = false
      await getWbsApproveStatus(this.globalParam).then(res => {
        flag = res
      })
      if (!flag) {
        return this.$message.warning('待WBS审核通过后才能进行此操作')
      }
      this.isOpenEdit = true
      this.$nextTick(() => {
        if (this.taskForm.data.id) {
          const curTask = this.gantDiv.ganttObj.getTaskBy('id', this.taskForm.data.id)[0]
          this.clickGanttGridRow({ id: curTask.id, row: curTask })
        }
      })

      this.emitBuildVersion()
    },
    async afterTemplateSelection(templates) {
      var vm = this
      var wbsCodeArray = []
      if (templates && templates.length > 0) {
        var params = { childFlag: 2,
          isChild: 2,
          codeType: 1
        }
        var childrenTasks = vm.gantDiv.ganttObj.getTaskBy('parent', vm.currentObj.id)
        var childrenTaskNum = childrenTasks.length
        var childrenNodes = vm.gantDiv.ganttObj.getTaskBy('parent', vm.gantDiv.ganttObj.getParent(vm.currentObj.id))
        params.nodeList = childrenNodes.map(function(item) {
          return item.wbsCode
        })
        params.total = templates.length + childrenTaskNum
        await getWbsCodes(
          params
        ).then(res => {
          wbsCodeArray = res
        }).catch(
        ).finally(() => {
        })
      }
      for (let i = 0; i < childrenTaskNum; i++) {
        childrenTasks[i].wbsCode = wbsCodeArray[i]
        vm.gantDiv.ganttObj.updateTask(childrenTasks[i].id)
      }
      for (let i = 0, len = templates.length; i < len; i++) {
        templates[i].wbsName = templates[i].taskName
        templates[i].text = templates[i].taskName
        templates[i].taskMold = '1'
        templates[i].expenseId = templates[i].expenseName
        templates[i].unscheduled = !((templates[i].planStartDate && templates[i].planEndDate))
        templates[i].add_from_template = true
        templates[i].wbsId = vm.currentObj.oldId
        templates[i].oldId = null
        templates[i].projectId = this.globalParam.projectId
        templates[i].wbsCode = wbsCodeArray[childrenTaskNum + i]
        templates[i].setType = 0
        templates[i].weightValue = templates[i].weights
        templates[i].weights = null
        templates[i].principalId = null
        templates[i].principalName = null
        templates[i].taskPreCodes = ''
        templates[i].operate = true

        delete templates[i].id
        vm.gantDiv.ganttObj.addTask(templates[i], vm.currentObj.id, childrenTaskNum + i)
      }

      if (!vm.currentObj.parent) {
        if (!vm.currentObj.childList) {
          vm.currentObj.childList = []
        }
        vm.currentObj.childList.splice(vm.currentObj.childList.length, 0, ...templates)
      }

      vm.gantDiv.ganttObj.eachParent(function(task) {
        if (!task.parent) {
          vm.taskTreeDataEdit(task.childList, (item) => {
            if (item.id === vm.currentObj.id) {
              if (!item.childList) {
                item.childList = []
              }
              item.childList.splice(item.childList.length, 0, ...templates)
            }
          })
        }
      }, vm.currentObj.id)
      vm.showTemplateDialog = false
    },
    doubleClickGanttGrid({ id, event }) {
      var task = this.gantDiv.ganttObj.getTaskBy('id', id)
      if (task[0].taskMold === '1') {
        if (this.isOpenEdit) {
          if (task[0].operate === false) {
            this.$message.warning('只有创建人和负责人才可编辑哦')
          } else {
            this.handleTaskEdit({ id, action: 'edit' })
          }
        } else {
          this.handleTaskEdit({ id, action: 'edit' })
        }
      }
    },
    getTaskComboBox() {
      getTaskComboBox({ itemId: iterm.workTypeId }).then(res => {
        this.taskTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化作业类型下拉框失败')
      }).finally(() => {
      })
      getTaskComboBox({ itemId: iterm.calculateTypeId }).then(res => {
        // TODO
        this.scheCalcTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化计算方式下拉框失败')
      }).finally(() => {
      })
      getTaskComboBox({ itemId: iterm.taskTypeId }).then(res => {
        this.planTypeComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化任务类型下拉框失败')
      }).finally(() => {
      })
      getTaskComboBox({ itemId: iterm.logicTypeId }).then(res => {
        this.relationshipComboxOptions = res
      }).catch(() => {
        this.$message.error('初始化逻辑关系下拉框失败')
      }).finally(() => {
      })
    },
    handleToTaskVersionDetail({ index, row }) {
      this.taskVersionDetailSrc = '#' + this.$route.path.replace('edit', 'versionDetail') + '?' + Qs.stringify(row)
      this.showTaskVersionHistory = false
      this.showTaskVersionDetail = true
    },
    /*  handleTaskTypeCovert(value) {
      return this.taskTypeComboxOptions.find((element) => (element.dictCode === value)).name
    },
    handlePlanTypeCovert(value) {
      return this.planTypeComboxOptions.find((element) => (element.dictCode === value)).name
    },
    handleScheCalcTypeCovert(value) {
      return this.scheCalcTypeComboxOptions.find((element) => (element.dictCode === value)).name
    }, */
    resourceTypeChange({ activeName }) {
      this.setResource.curTabName = activeName
    },
    cancelSetResource() {
      this.$refs.setResource.cancelSel()
      this.resourceDialogVisible = false
      this.editTaskDialogVisible = true
    },
    handleSetResouce() {
      this.resourceDialogVisible = false
      // human的humanSelArr
      const humanSelArr = [...this.$refs.setResource.$refs['human'].selResouce]
      var humanTmpArr = []
      humanTmpArr = JSON.parse(JSON.stringify(humanSelArr))
      if (this.resourceGridForm.data) {
        this.resourceGridForm.data.forEach(taskItem => {
          humanTmpArr.forEach(element => {
            if (taskItem.resId === element.id) {
              this.setValue(element, ['id', 'resCode', 'resName', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'amount', 'startDate', 'endDate', 'bOldResource'], [
                taskItem.id, taskItem.resCode, taskItem.resName, taskItem.resType, taskItem.resTypeName, taskItem.unitEstimate, taskItem.unitPrice, taskItem.amount, taskItem.startDate, taskItem.endDate, true
              ])
            }
          })
        })
      }
      humanTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          const uid = this.getUUID()
          this.setValue(element, ['id', 'resId', 'resCode', 'resName', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'resCreateTime'], [
            uid, element.id, '', element.name, '1', '人力', element.unitName, element.price, element.createTime
          ])
        }
      })

      // material 的处理
      //  material的 materialSelArr
      const materialSelArr = [...this.$refs.setResource.$refs['material'].selResouce]
      var materialTmpArr = []
      materialTmpArr = JSON.parse(JSON.stringify(materialSelArr))
      if (this.resourceGridForm.data) {
        this.resourceGridForm.data.forEach(taskItem => {
          materialTmpArr.forEach(element => {
            if (taskItem.resId === element.id) {
              this.setValue(element, ['id', 'resCode', 'resName', 'resModel', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'amount', 'startDate', 'endDate', 'bOldResource'], [
                taskItem.id, taskItem.resCode, taskItem.resName, taskItem.resModel, taskItem.resType, taskItem.resTypeName, taskItem.unitEstimate, taskItem.unitPrice, taskItem.amount, taskItem.startDate, taskItem.endDate, true
              ])
            }
          })
        })
      }
      materialTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          const uid = this.getUUID()
          this.setValue(element, ['id', 'resId', 'resCode', 'resName', 'resModel', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'resCreateTime'], [
            uid, element.id, element.resourceCode, element.resourceName, element.resourceType, '2', '材料', element.unitName, element.price, element.createTime
          ])
        }
      })

      // device 的处理
      //  devicedeviceSelArr
      const deviceSelArr = [...this.$refs.setResource.$refs['device'].selResouce]
      var deviceTmpArr = []
      deviceTmpArr = JSON.parse(JSON.stringify(deviceSelArr))
      if (this.resourceGridForm.data) {
        this.resourceGridForm.data.forEach(taskItem => {
          deviceTmpArr.forEach(element => {
            if (taskItem.resId === element.id) {
              this.setValue(element, ['id', 'resCode', 'resName', 'resModel', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'amount', 'startDate', 'endDate', 'bOldResource'], [
                taskItem.id, taskItem.resCode, taskItem.resName, taskItem.resModel, taskItem.resType, taskItem.resTypeName, taskItem.unitEstimate, taskItem.unitPrice, taskItem.amount, taskItem.startDate, taskItem.endDate, true
              ])
            }
          })
        })
      }
      deviceTmpArr.forEach(element => {
        if (element.bOldResource) {
          return
        } else {
          const uid = this.getUUID()
          this.setValue(element, ['id', 'resId', 'resCode', 'resName', 'resModel', 'resType', 'resTypeName', 'unitEstimate', 'unitPrice', 'resCreateTime'], [
            uid, element.id, element.resourceCode, element.resourceName, element.resourceType, '3', '设备', element.unitName, element.price, element.createTime
          ])
        }
      })

      this.resourceGridForm.data = [...humanTmpArr, ...materialTmpArr, ...deviceTmpArr]
      this.editTaskDialogVisible = true
    },
    setValue(obj, keyArr, valueArr) {
      for (let i = 0; i < keyArr.length; i++) {
        this.$set(obj, keyArr[i], valueArr[i])
      }
    },
    handleCloseTaskVersionDetailDialog() {
      this.showTaskVersionDetail = false
      this.showTaskVersionHistory = true
    },
    handleDurationCalendarChange(value) {
      if (this.taskForm.data.setType === 0 && this.editMode === 'edit') {
        if (this.taskForm.tempData.planDuration && (value === this.taskForm.tempData.planDuration.toString())) {
          this.taskForm.data.planStartDate = this.taskForm.tempData.planStartDate
          this.taskForm.data.planEndDate = this.taskForm.tempData.planEndDate
        } else {
          this.taskForm.data.planEndDate = null
          this.taskForm.data.planStartDate = null
        }
      }
    },
    handleCalculateCriticalPath(criticalTask) {
      if (criticalTask === 1) {
        this.isFilterCriticalTask = false
      } else if (criticalTask === 0) {
        this.isFilterCriticalTask = true
      }
      var param
      if (criticalTask < 2) {
        // param = { ...this.globalParam, ...{ criticalTask: criticalTask }}
        return this.searchTaskByParam()
      } else {
        param = this.globalParam
      }
      if (!this.isFilterCriticalTask) {
        this.isFilterCriticalTask = true
        this.searchTaskByParam()
      }
      return getCriticalPath(param).then(res => {
        var treeData = []
        // var links = []
        this.tasks.links = []
        if (res.state === 'success') {
          if (res.code === '501') {
            this.fetchTaskList()
            this.$message.warning(res.msg)
            return false
          }
          this.convertTreeData('', res.data, (item, parent) => {
            item.parent = parent || ''
            if (item.planStartDate && item.planEndDate) {
              item.start_date = item.planStartDate.split(' ')[0].split('-')[2] + '-' + item.planStartDate.split(' ')[0].split('-')[1] + '-' + item.planStartDate.split(' ')[0].split('-')[0]
              item.duration = item.planDuration
              item.unscheduled = false
            } else {
              item.start_date = ''
              item.end_date = ''
              item.duration = '0'
              item.unscheduled = true
            }
            item.text = item.wbsName
            treeData.push(item)
            if (Array.isArray(item.relateList) && item.relateList.length) {
              for (let i = 0, len = item.relateList.length; i < len; i++) {
                this.tasks.links.push({ id: item.relateList[i].id, source: item.relateList[i].taskPreId, target: item.relateList[i].taskNextId, type: item.relateList[i].relationshipId })
                // links.push({ id: item.relateList[i].id, source: item.relateList[i].taskPreId, target: item.relateList[i].taskNextId, type: item.relateList[i].relationshipId })
              }
            }
          })
          this.tasks.data = treeData
          /* 清空当前选中节点 */
          if (this.currentObj) {
            this.currentObj = null
          }
          var message = '计算成功'
          if (criticalTask === 1) {
            message = '过滤成功'
          } else if (criticalTask === 0) {
            message = '取消过滤成功'
          }
          if (criticalTask === 'approval') {
            return true
          } else {
            this.$message.success(message)
          }
        } else {
          this.$message.error('操作失败')
        }
      })
    },
    handleCancelGanttEdit() {
      this.isOpenEdit = false
      this.currentObj = null
      this.emitBuildVersion()
      this.fetchTaskList()
    },
    validTaskIsNull() {
      var warningHtml
      var workTasks = this.gantDiv.ganttObj.getTaskBy('taskMold', '1')
      if (!workTasks || workTasks.length === 0) {
        // warningHtml = '<span style="color: #f56c6c;">还未添加任何作业，请先添加作业</span>'
        warningHtml = '<span>还未添加任何作业，请先添加作业</span>'
        this.$alert(warningHtml, '提示', {
          confirmButtonText: '确定',
          dangerouslyUseHTMLString: true,
          type: 'warning'
        })
        return false
      } else {
        return true
      }
    },
    handleGenerateWeights() {
      var vm = this
      if (!vm.validTaskIsNull()) {
        return
      }
      vm.$confirm(`将按作业权值生成权重，是否生成?`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
        dangerouslyUseHTMLString: true
      }).then(() => {
        vm.caclWeight()
        this.$message.success('成功生成权重')
      })
    },
    caclWeight() {
      const vm = this
      vm.gantDiv.ganttObj.eachTask(function(task) {
        // var childrenNodes = vm.gantDiv.ganttObj.getTaskBy('parent', task.id)
        var childrenNodes = vm.gantDiv.ganttObj.getTaskBy(tk => (tk.parent === task.id) && tk.taskType === '1')
        if (childrenNodes && childrenNodes.length > 0) {
          // 获取子节点所有权值
          var weightSum = childrenNodes.reduce(function(prev, cur, index, arr) {
            return prev + cur.weightValue
          }, 0)
          // var proportion = Math.round(10000 / weightSum) / 100
          var lastWeights = 0
          for (var i = 0, len = childrenNodes.length; i < len; i++) {
            if (i === (childrenNodes.length - 1) && childrenNodes.length > 1) {
              childrenNodes[i].weights = Math.round((100.00 - lastWeights) * 100) / 100
            } else {
              // childrenNodes[i].weights = proportion * Number(childrenNodes[i].weightValue)
              childrenNodes[i].weights = Math.round(childrenNodes[i].weightValue / weightSum * 10000) / 100
              lastWeights += childrenNodes[i].weights
            }
            vm.gantDiv.ganttObj.updateTask(childrenNodes[i].id)
          }
        }
      })
    },
    toWbsDateCheck() {
      if (this.isOpenEdit && this.currentObj && this.currentObj.id && this.currentObj.taskMold === '1') {
        this.handleTaskEditSubmit(() => {
          this.taskData = JSON.stringify(this.$refs.gantDiv.ganttObj.serialize())
          this.wbsDateCheckVisble = true
        })
      } else {
        this.taskData = JSON.stringify(this.$refs.gantDiv.ganttObj.serialize())
        this.wbsDateCheckVisble = true
      }
    },
    handleNewTasks(newTasks) {
      if (newTasks) {
        const tasks = this.gantDiv.ganttObj.serialize().data
        tasks.forEach(oItem => {
          newTasks.forEach(argItem => {
            if (oItem.id === argItem.id) {
              if (argItem.taskType === '1') {
                this.gantDiv.ganttObj.getTask(argItem.id)['planStartDate'] = argItem.planStartDate
                this.gantDiv.ganttObj.getTask(argItem.id)['planEndDate'] = argItem.planEndDate
                this.gantDiv.ganttObj.getTask(argItem.id)['start_date'] = new Date(argItem.planStartDate)
                this.gantDiv.ganttObj.getTask(argItem.id)['end_date'] = new Date(argItem.planEndDate)
                this.gantDiv.ganttObj.getTask(argItem.id)['planDuration'] = argItem.planDuration + 1
                this.gantDiv.ganttObj.getTask(argItem.id)['planDate'] = argItem.planDate
                argItem.unscheduled = false
              } else {
                this.gantDiv.ganttObj.getTask(argItem.id)['planStartDate'] = argItem.planStartDate
                this.gantDiv.ganttObj.getTask(argItem.id)['planEndDate'] = argItem.planEndDate
                this.gantDiv.ganttObj.getTask(argItem.id)['planDuration'] = argItem.planDuration + 1
                this.gantDiv.ganttObj.getTask(argItem.id)['planDate'] = argItem.planEndDate
                argItem.unscheduled = true
              }
              this.gantDiv.ganttObj.updateTask(argItem.id)
            }
            if (argItem.id === this.taskForm.data.id) {
              if (argItem.taskType === '1') {
                this.taskForm.data.planStartDate = argItem.planStartDate
                this.taskForm.data.planEndDate = argItem.planEndDate
                this.taskForm.data.planDuration = argItem.planDuration
              } else {
                this.taskForm.data.planStartDate = argItem.planStartDate
                this.taskForm.data.planEndDate = argItem.planEndDate
                this.taskForm.data.planDuration = argItem.planDuration
                this.taskForm.data.planDate = argItem.planEndDate
              }
            }
            if (argItem.id === this.currentObj.id) {
              // taskTYype=1 作业 2里程碑
              if (argItem.taskType === '1') {
                this.currentObj.planStartDate = argItem.planStartDate
                this.currentObj.planEndDate = argItem.planEndDate
                this.currentObj.planDuration = argItem.planDuration
              } else {
                this.currentObj.planStartDate = argItem.planStartDate
                this.currentObj.planEndDate = argItem.planEndDate
                this.currentObj.planDate = argItem.planEndDate
                this.currentObj.planDuration = argItem.planDuration
              }
            }
          })
        })
      } else {
        this.fetchTaskList()
        this.wbsDateCheckVisble = false
      }
    },
    handleEditTaskDialogOpen(flag) {
      return new Promise((resolve, reject) => {
        if (this.editMode === 'add') {
          var params = { childFlag: 1,
            isChild: 2,
            codeType: 1,
            tempId: this.projectSetting.wbsCodeRule
          }
          var childrenNodes = []
          if (flag === 'sameLevel') {
            childrenNodes = this.gantDiv.ganttObj.getTaskBy('parent', this.taskForm.data.parent)
          } else {
            childrenNodes = this.gantDiv.ganttObj.getTaskBy('parent', this.taskForm.data.id)
            if (childrenNodes.length === 0) {
              childrenNodes = this.gantDiv.ganttObj.getTaskBy('id', this.taskForm.data.id)
              params.isChild = 1
            }
            params.childFlag = 2
          }

          params.nodeList = childrenNodes.map(function(item) {
            return item.wbsCode
          })
          getWbsCode(
            params
          ).then(res => {
            if (res.messageCode === '200') {
              resolve(res.code)
              // this.taskForm.data.wbsCode = res.code
            } else {
              this.$message.error(res.message)
            }
          })
        }
      })
    },
    dateFomatter(date, fmt) {
      var o = {
        'M+': date.getMonth() + 1, // 月份
        'd+': date.getDate(), // 日
        'h+': date.getHours(), // 小时
        'm+': date.getMinutes(), // 分
        's+': date.getSeconds(), // 秒
        'q+': Math.floor((date.getMonth() + 3) / 3), // 季度
        'S': date.getMilliseconds() // 毫秒
      }
      if (/(y+)/.test(fmt)) {
        fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length))
      }
      for (var k in o) {
        if (new RegExp('(' + k + ')').test(fmt)) {
          fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? (o[k]) : (('00' + o[k]).substr(('' + o[k]).length)))
        }
      }
      return fmt
    },
    handleSel(sel) {
      this.taskForm.data.principalId = sel[0].userId
      this.taskForm.data.principalName = sel[0].userName
    },
    getTaskDuration() {
      // taskType为1 作业  为2 里程碑
      if (this.taskForm.data.taskType === '1') {
        if (!this.taskForm.data.planStartDate || !this.taskForm.data.planEndDate) {
          return
        }
        getTaskDuration({ ...this.globalParam, ...{ startTime: this.taskForm.data.planStartDate, endTime: this.taskForm.data.planEndDate }}).then(res => {
          if (res.state === 'success') {
            this.$set(this.taskForm.data, 'planDuration', res.data)
          } else {
            this.$message.error('计算工期时出错')
          }
        }).catch(
        ).finally(() => {
        })
      } else {
        this.$set(this.taskForm.data, 'planDuration', 1)
      }
    },
    handleDateTypeRadioChange(value) {
      if (value) {
        this.$nextTick(() => {
          this.$refs.taskForm.clearValidate(['planDuration'])
          this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = true
          this.taskForm.rules.planDuration.splice(1, 1)
          this.taskForm.rules.planDuration[0].required = false
        })
      } else {
        this.$refs.taskForm.clearValidate(['planStartDate', 'planEndDate'])
        if (this.taskForm.rules.planDuration.length === 1) {
          this.taskForm.rules.planDuration.push({ type: 'integer', min: 1, message: '计划工期应为正整数' })
        }
        this.taskForm.rules.planStartDate[0].required = this.taskForm.rules.planEndDate[0].required = false
        this.taskForm.rules.planDuration[0].required = true
        if (this.editMode === 'edit' && this.taskForm.data.planDuration && this.taskForm.data.planDuration.toString() === this.taskForm.tempData.planDuration.toString()) {
          this.$set(this.taskForm.data, 'planStartDate', this.taskForm.tempData.planStartDate)
          this.$set(this.taskForm.data, 'planEndDate', this.taskForm.tempData.planEndDate)
        } else {
          this.taskForm.data.planStartDate = this.taskForm.data.planEndDate = ''
        }
      }
    },
    initTimeScaleValue() {
      getProgrameSettings(this.globalParam).then(res => {
        if (res.state === 'success') {
          this.selectTimeScaleValue = res.data.period
          this.projectSetting = res.data
          // 作业是否可以审批
          this.bApprove = this.projectSetting.scheWbsLevelList[this.projectSetting.scheWbsLevelList.length - 1].approval === 1
          this.emitBuildVersion()
        } else {
          this.$message.error('初始化项目参数信息出错')
        }
      }).catch(
      ).finally(() => {
      })
    },
    zoomIn() {
      this.$refs.gantDiv.zoomIn()
    },
    zoomOut() {
      this.$refs.gantDiv.zoomOut()
    },
    handleTaskTypeChang(v) {
      if (v === '0') {
        this.activeName = 'first'
      } else {
        //
      }
      this.$refs.taskForm.clearValidate()
    },
    S4: function() {
      return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1)
    },
    getUUID: function() {
      return (this.S4() + this.S4() + this.S4() + this.S4() + this.S4() + this.S4() + this.S4() + this.S4())
    }
  }
}
</script>

<style lang="scss" scoped>
app-container{
  width: 100%;
  height: 100%;
  position: absolute;
  padding: 0
}
.upContainer {
  height: 50%;
}
.downContainer {
  height: 70%;
}
.el-icon-arrow-down {
  font-size: 10px;
}
.ml-10 {
  margin-left:10px;
}
.mr-10 {
  margin-right:20px;
}
.mr-20 {
  margin-right:20px;
}
.ml-20 {
  margin-left:20px;
}
.mt-10{
  margin-top:10px;
}
.mt-20{
  margin-top:20px;
}

.button-group {
  vertical-align:baseline;
  line-height: 100%;
  height:100%;
}

.stateCheckBox{
  width:45px;
  margin-top:15px;
}
.textCenter{
  position: absolute;
  top: 25%;
  left: 50%;
  transform: translate(-50%, -50%);
  color: #808080;
}
.el-checkbox{
  display: block;
  font-weight:normal;
}
.font-14{
  font-size: 14px;
}
.el-date-editor.el-input {
    width: 140px;
}
/deep/ .el-checkbox__label{
  font-weight:normal;
}
/deep/ table th.must div:before  {
			content: '*';
			color: #ff1818;

}
/deep/ table th.must{
	text-align: center;
  font-size:13px;

}
/deep/ .tableHeader{
  text-align: center;
  font-size:13px;

}
/deep/ .justcenter{
  text-align: center;
}
/deep/ .el-checkbox__label{
  line-height: 16px
}
 /deep/ .el-table td.redBgColor{
  background: red;
  text-align: center;
}

.edit-table .el-form-item--mini.el-form-item, .edit-table .el-form-item--small.el-form-item {
  margin-top: 18px;
}

/deep/ .select-resource-dialog .el-dialog__body {
    padding: 0px 20px;
    color: #727f99;
    font-size: 14px;
    word-break: break-all;
}

 #edit-task-dialog /deep/ .el-tabs__content {
  height: 350px;
}
</style>
<style>
.select-template-dialog{
   position:absolute;
   top: 0;
   right: 0;
   bottom: 0;
   left: 0;
   height: 80vh;
   width: 80%;
}
.task-version-detail-dialog{
   position:absolute;
   top: 0;
   right: 0;
   bottom: 0;
   left: 0;
   height: 80vh;
   width: 80%;
}

.gantt_grid_data .task-grid-wbs-row-background-color,
.gantt_grid_data .task-grid-wbs-row-background-color.odd {
background-color:#DCDFE6;
}

/* .gantt_grid_data .task-grid-wbs-row-background-color:hover,
.gantt_grid_data .task-grid-wbs-row-background-color.odd:hover {
background-color:#2e9f36;
} */

.table-header .buttons-right {
    float: right;
    padding-right: 20px;
}

/* .gantt_grid_data .gantt_row.odd:hover,.gantt_grid_data .gantt_row:hover{
    background-color:unset
} */

.medium {
			border: 2px solid #34c461;
			color: #34c461;
			background: #34c461;
		}

.medium .gantt_task_progress {
  background: #23964d;
}
</style>
