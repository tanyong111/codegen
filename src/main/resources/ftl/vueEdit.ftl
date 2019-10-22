<!--
 本组件为新增、编辑、查看弹窗组件
 组件用法：
 <edit v-bind:id="id" v-bind:visible.sync="visible" v-bind:dialogtype="dialogtype" v-on:editsucess="requestData"></dit>
 需要定义3个变量：id用来保存编辑时的标识id，visible用来控制弹窗显示，dialogtype用来控制弹窗标题（分别只能是新增，修改，查看）
 一个函数：editsucess函数在弹窗提交后会被触发，一般用来回调刷新列表。
 示列代码：
 data里定义变量：
 id:'',
 dialogtype:'',
 visible: false,
 控制弹窗函数：
 // 新增弹窗
  handleAddShow() {
    this.id = '';
    this.visible = true;
    this.dialogtype = "新增";
  },
  // 编辑
  handleEdit(index, row) {
    this.id = row["id"];
    this.visible = true;
    this.dialogtype = "修改";
  },
  // 查看
  handleView(index, row) {
    this.id = row["id"];
    this.visible = true;
    this.dialogtype = "查看";
  },
-->
<template>
 <el-dialog
         v-bind:title="dialogtype"
         :visible.sync="visible"
         :close-on-click-modal="false"
         :show-close="false"
 >
  <el-form :model="form" :rules="rules" ref="form" :disabled="isView">
   <#list columns as ci>
    <#if ci.lowerAttrName == "id" || ci.lowerAttrName == "createId" ||ci.lowerAttrName == "createBy" ||ci.lowerAttrName == "createTime" ||ci.lowerAttrName == "modifyId" ||ci.lowerAttrName == "modifyBy" ||ci.lowerAttrName == "modifyTime" ||ci.lowerAttrName == "deleteFlag">
    <#else>
     <#if ci.javaType=="String">
      <el-form-item label="${ci.comment}" :label-width="formLabelWidth" prop="${ci.lowerAttrName}">
       <el-input v-model="form.${ci.lowerAttrName}" autocomplete="off" maxlength="${ci.maxLength}" show-word-limit></el-input>
      </el-form-item>
     <#elseif ci.javaType=="Integer">
      <el-form-item label="${ci.comment}" :label-width="formLabelWidth" prop="${ci.lowerAttrName}">
       <el-input type="number" v-model="form.${ci.lowerAttrName}" autocomplete="off" step="1" min="0"></el-input>
      </el-form-item>
     <#elseif ci.javaType=="BigDecimal">
      <el-form-item label="${ci.comment}" :label-width="formLabelWidth" prop="${ci.lowerAttrName}">
       <el-input type="number" v-model="form.${ci.lowerAttrName}" autocomplete="off" step="0.01" min="0"></el-input>
      </el-form-item>
     <#elseif ci.javaType=="LocalDateTime">
      <el-form-item label="${ci.comment}" :label-width="formLabelWidth" prop="${ci.lowerAttrName}">
       <el-date-picker v-model="form.${ci.lowerAttrName}" type="datetime" placeholder="选择日期时间"></el-date-picker>
      </el-form-item>
     <#elseif ci.javaType=="Boolean">
      <el-form-item label="${ci.comment}" :label-width="formLabelWidth" prop="${ci.lowerAttrName}">
       <el-radio-group v-model="form.${ci.lowerAttrName}">
        <el-radio :label="true">是</el-radio>
        <el-radio :label="false">否</el-radio>
       </el-radio-group>
      </el-form-item>
     <#else>
      <el-form-item label="${ci.comment}" :label-width="formLabelWidth" prop="${ci.lowerAttrName}">
       <el-input v-model="form.${ci.lowerAttrName}" autocomplete="off"></el-input>
      </el-form-item>
     </#if>
    </#if>
   </#list>
  </el-form>
  <div slot="footer" class="dialog-footer">
   <el-button @click="dialogCancel()">取 消</el-button>
   <el-button type="primary" @click="dialogSubmit()" v-show="!isView">{{dialogtype}}</el-button>
  </div>
 </el-dialog>
</template>

<script>
 import api from "@/utils/api";
 export default {
  // id即编辑的id，新增时不传，visible属性用来监听是否显示弹窗,type属性表示（新增，修改，查看）
  props: ["id", "visible", "dialogtype"],
  watch: {
   id: function() {
    let that = this;
    if (that.id) {
     that.$http.get({ url: api.${lowerClassName}_getById + that.id }).then(res => {
      Object.keys(that.form).forEach(function(key) {
       if (res.data[key] == undefined) {
        that.form[key] = null;
       } else {
        that.form[key] = res.data[key];
       }
      });
    });
    } else {
     Object.keys(that.form).forEach(function(key) {
      if (typeof that.form[key] == "boolean") {
       that.form[key] = false;
      } else {
       that.form[key] = "";
      }
     });
    }
   },
   visible: function() {
    let that = this;
   },
   dialogtype: function() {
    let that = this;
    if (that.dialogtype == "新增") {
     that.isView = false;
    } else if (that.dialogtype == "修改") {
     that.isView = false;
    } else {
     that.isView = true;
    }
   }
  },
  data() {
   return {
    // 控制弹窗标题显示
    dialogType: "新增",
    // 编辑的form表单内容
    form: {
     id: "",
   <#list columns as ci>
   <#if ci.lowerAttrName == "id" || ci.lowerAttrName == "createId" ||ci.lowerAttrName == "createBy" ||ci.lowerAttrName == "createTime" ||ci.lowerAttrName == "modifyId" ||ci.lowerAttrName == "modifyBy" ||ci.lowerAttrName == "modifyTime" ||ci.lowerAttrName == "deleteFlag">
   <#elseif ci.javaType=="Boolean">
   ${ci.lowerAttrName}:false,
   <#else>
   ${ci.lowerAttrName}:'',
   </#if>
   </#list>
    },
    rules: {
     <#list columns as ci>
     <#if ci.lowerAttrName == "id" || ci.lowerAttrName == "createId" ||ci.lowerAttrName == "createBy" ||ci.lowerAttrName == "createTime" ||ci.lowerAttrName == "modifyId" ||ci.lowerAttrName == "modifyBy" ||ci.lowerAttrName == "modifyTime" ||ci.lowerAttrName == "deleteFlag">
     <#elseif ci.nullable==false>
     <#if ci.javaType=="String">
     ${ci.lowerAttrName}:[{required: true, message: "请输入${ci.comment}", trigger: "blur"},],
     </#if>
     </#if>
     </#list>
    },
    // 表单是否为只读
    isView: false,
    // 表单行长度
    formLabelWidth: "120px"
   };
  },
  methods: {
   // 取消，关闭弹窗
   dialogCancel() {
    // vue伪双向绑定，使用visible时需要使用v-bind:visible.sync="visible"方式
    this.$emit("update:visible", false);
   },
   // 提交
   dialogSubmit() {
    let that = this;
    that.$refs["form"].validate(valid => {
     if (valid) {
      that.loading = true;
      let postUrl = api.${lowerClassName}_add;
      if (that.dialogtype == "修改") {
       postUrl = api.${lowerClassName}_update;
      }
      that.$http.post({ url: postUrl, paramDic: that.form }).then(res => {
       that.loading = false;
      that.$message({
       message: res.msg,
       type: "success"
      });
      this.$emit("update:visible", false);
      this.$emit("editsucess");
     });
     } else {
      return false;
   }
   });
   }
  },
  mounted() {}
 };
</script>