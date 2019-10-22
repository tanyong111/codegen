<template>
 <div>
  <div style="margin-bottom: 10px;background-color: #ffffff;"
       >

   <el-row style="padding: 10px;">
    <el-form :model="searchParams" ref="searchParams" inline style="margin: 10px;">
    <#list columns as ci>
    <#if ci.lowerAttrName == "name">
     <el-form-item label="${ci.comment}" label-width="70" prop="${ci.lowerAttrName}">
      <el-input v-model="searchParams.${ci.lowerAttrName}" autocomplete="off" style="width: 200px"></el-input>
     </el-form-item>
    </#if>
    </#list>
     <el-form-item label="更新时间" label-width="70" prop="date">
      <el-date-picker
              v-model="searchParams.date"
              type="daterange"
              range-separator="至"
              start-placeholder="开始日期"
              end-placeholder="结束日期"
              value-format="yyyy-MM-dd"
      ></el-date-picker>
     </el-form-item>
     <el-form-item>
      <el-button type="primary" @click="requestData()">搜索</el-button>
      <el-button @click="resetForm('searchParams');">重置</el-button>
     </el-form-item>
    </el-form>
   </el-row>
   <el-button type="primary" @click="handleAddShow()">新增</el-button>
   <el-button type="danger" @click="deleteByIds()" :disabled="deleteByIdsDisable">删除选中行</el-button>

   <${lowerClassName}edit v-bind:id="id" v-bind:visible.sync="dialogFormVisible" v-bind:dialogtype="dialogtype" v-on:editsucess="requestData"></${lowerClassName}edit>
  </div>

  <el-table :data="tableData" style="width: 100%" border ref="multipleTable" @selection-change="handleSelectionChange"
            v-loading="loading"
            element-loading-text="拼命加载中"
            element-loading-spinner="el-icon-loading"
            element-loading-background="rgba(0, 0, 0, 0.8)">
   <el-table-column type="selection" width="55"></el-table-column>
   <#list columns as ci>
    <#if ci.lowerAttrName == "id" || ci.lowerAttrName == "createId" ||ci.lowerAttrName == "createBy" ||ci.lowerAttrName == "createTime" ||ci.lowerAttrName == "modifyId" ||ci.lowerAttrName == "modifyBy" ||ci.lowerAttrName == "modifyTime" ||ci.lowerAttrName == "deleteFlag">
    <#else>
     <el-table-column label="${ci.comment}" width="180">
      <template slot-scope="scope">{{ scope.row.${ci.lowerAttrName} }}</template>
     </el-table-column>
    </#if>
   </#list>
   <el-table-column label="操作" fixed="right" width="240">
    <template slot-scope="scope">
     <el-button title="查看" size="mini" @click="handleView(scope.$index, scope.row)">
      <i class="el-icon-view"></i>
     </el-button>
     <el-button title="编辑" size="mini" @click="handleEdit(scope.$index, scope.row)">
      <i class="el-icon-edit"></i>
     </el-button>
     <el-button title="删除" size="mini" type="danger" @click="handleDelete(scope.$index, scope.row)">
      <i class="el-icon-delete"></i>
     </el-button>
    </template>
   </el-table-column>
  </el-table>
  <el-pagination
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
          :page-sizes="[5, 10, 20, 30]"
          :page-size="10"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
  ></el-pagination>
 </div>
</template>

<script>

 import api from '@/utils/api';
 import ${lowerClassName}edit from "@/pages/businessmanage/${lowerClassName}/${lowerClassName}Edit"
 export default {
  components:{${lowerClassName}edit},
  data: function() {
   return {
    id:'',
    dialogtype:'',
    loading: false,
    // 分页搜索参数
    searchParams: {
     page: 1,
     size: 10,
     <#list columns as ci>
     <#if ci.lowerAttrName == "name">
     ${ci.lowerAttrName}:'',
     </#if>
     </#list>
      date:'',
    },
    total: 10, // 分页记录总数
    // 表格数据
    tableData: [],
    // 控制添加和编辑框是否显示
    dialogFormVisible: false,
    // 操作列的宽度
    optionWidth:0,
    multipleSelection: [],
    deleteByIdsDisable:true,// 删除选中行是否禁用
   };
  },
  methods: {
   // 表格选中事件
   handleSelectionChange(val) {
    this.multipleSelection = val;
    if(this.multipleSelection && this.multipleSelection.length>0) {
     this.deleteByIdsDisable=false;
    } else {
     this.deleteByIdsDisable=true;
    }
   },
   deleteByIds() {
    let that=this;
    if(that.multipleSelection && this.multipleSelection.length>0) {
     let ids=[];
     for(let i=0;i<that.multipleSelection.length;i++) {
      ids.push(that.multipleSelection[i].id);
     }
     this.$confirm("是否确认删除？", "提示", {
      confirmButtonText: "确定",
      cancelButtonText: "取消",
      type: "warning"
     })
             .then(() => {
      that.loading = true;
     that.$http.post({url:api.${lowerClassName}_deleteByIds, paramDic:{ids:ids}})
             .then(res => {
      that.loading = false;
     that.$message({
      message: res.msg,
      type: "success"
     });
     that.deleteByIdsDisable = true;
     that.requestData();
    })
    .catch(err => {
      that.loading = false;
      that.$message.error('出错了');
    });
    })
    .catch(() => {
      that.$message({
       message: "已取消删除！",
       type: "info"
      });
    });
    }
   },
   // 重置表单
   resetForm(formName) {
    this.$refs[formName].resetFields();
   },
   //第几页
   handleCurrentChange(val) {
    this.searchParams.page = val;
    this.requestData();
   },
   //每页多少条
   handleSizeChange(val) {
    this.searchParams.size = val;
    this.requestData();
   },
   // 请求列表数据
   requestData() {
    let that = this;
    that.loading = true;
    let params = JSON.parse(JSON.stringify(that.searchParams));
    params.date='';
    if(that.searchParams.date) {
     if(that.searchParams.date[0]) {
      params.startDate=that.searchParams.date[0];
     }
     if(that.searchParams.date[1]) {
      params.endDate=that.searchParams.date[1];
     }
    }
    that.$http.get({url:api.${lowerClassName}_search, paramDic:params})
            .then(res => {
     that.total = res.data.total;
    that.tableData = res.data.list;
    that.loading = false;
   })
   .catch(err => {
     that.loading = false;
     that.$message.error('出错了');
   });
   },
   // 新增弹窗
   handleAddShow() {
    this.id = '';
    this.dialogFormVisible = true;
    this.dialogtype = "新增";
   },
   // 新增取消
   handleAddCancel() {
    this.dialogFormVisible = false;
   },
   // 提交
   handleSubmit() {
    let that = this;
    that.$refs["form"].validate(valid => {
     if (valid) {
      that.loading = true;
      let postUrl = api.${lowerClassName}_add;
      if (!that.isAdd) {
       postUrl = api.${lowerClassName}_update;
      }
      that.$http.post({url:postUrl, paramDic:that.form})
              .then(res => {
       that.loading = false;
      that.$message({
       message: res.msg,
       type: "success"
      });
      that.dialogFormVisible = false;
      that.requestData();
     })
     .catch(err => {
       that.loading = false;
       that.$message.error('出错了');
     });
     } else {
      return false;
   }
   });
   },
   // 编辑
   handleEdit(index, row) {
    this.id = row["id"];
    this.dialogFormVisible = true;
    this.dialogtype = "修改";
   },
   // 查看
   handleView(index, row) {
    this.id = row["id"];
    this.dialogFormVisible = true;
    this.dialogtype = "查看";
   },
   // 删除
   handleDelete(index, row) {
     let that = this;
     this.$confirm("是否确认删除？", "提示", {
       confirmButtonText: "确定",
       cancelButtonText: "取消",
       type: "warning"
     }).then(() => {
      that.loading = true;
    that.$http.post({url:api.${lowerClassName}_deleteByIds, paramDic:{ids:row["id"]}}).then(res => {
       that.loading = false;
       that.$message({
        message: res.msg,
        type: "success"
       });
       that.dialogFormVisible = false;
       that.requestData();
      }).catch(err => {
       that.loading = false;
       that.$message.error('出错了');
      });
     }).catch(() => {
      that.$message({
       message: "已取消删除！",
       type: "info"
      });
     });
    }
  },
  mounted() {
   this.requestData();
  }
 };
</script>

<style scoped>
</style>

<!--
// 路由配置，component请修改为相应路径
{
   icon: "el-icon-setting",
   index: "/${entityName}",
   title: "${comments}管理"
 },
 {
    path: '/${entityName}',
    component: () => import('@/pages/sysmanage/${entityName}'),
    meta: { title: '${comments}管理' }
  },

// api配置
${lowerClassName}_search: "/${lowerClassName}/search",//${comments}管理
${lowerClassName}_add: "/${lowerClassName}/add",
${lowerClassName}_update: "/${lowerClassName}/update",
${lowerClassName}_delete: "/${lowerClassName}/delete",
${lowerClassName}_deleteByIds: "/${lowerClassName}/deleteByIds",
${lowerClassName}_getById: "/${lowerClassName}/getById/",
-->