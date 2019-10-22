package ${packageName}.${entity};

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;
import com.fasterxml.jackson.annotation.JsonFormat;
import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.Size;
<#if isSwagger=="true" >
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
</#if>
import java.util.Date;
<#if hasBigDecimal==true >
import java.math.BigDecimal;
</#if>

/**   
 * ${comments}实体类
 * @version: ${version}
 * @author: ${author}
 * @date: ${createTime}
 */
<#--@Data-->
<#--@EqualsAndHashCode(callSuper = false)-->
@Data
@TableName("${tableName}")
<#if isSwagger=="true" >
<#--@ApiModel(value = "(表:${table})--(实体:${entityName})", description = "${entityComment}")-->
@ApiModel(value = "${entityName}实体", description = "${comments}")
</#if>
public class ${entityName} extends BaseEntity {

<#list columns as ci>
 <#if ci.lowerAttrName == "id" || ci.lowerAttrName == "createId" ||ci.lowerAttrName == "createBy" ||ci.lowerAttrName == "createTime" ||ci.lowerAttrName == "modifyId" ||ci.lowerAttrName == "modifyBy" ||ci.lowerAttrName == "modifyTime" ||ci.lowerAttrName == "deleteFlag">
  <#else>
  <#if ci.javaType=="LocalDate">
   @DateTimeFormat(pattern = "yyyy-MM-dd")
  <#elseif ci.javaType=="LocalTime">
   @DateTimeFormat(pattern = "HH:mm:ss")
  <#elseif ci.javaType=="LocalDateTime">
   @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
   @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
  </#if>
  <#if isSwagger=="true" >
   @ApiModelProperty(name = "${ci.lowerAttrName}" , value = "${ci.comment}")
  </#if>
   @TableField("${ci.column}")
   <#if ci.javaType=="String">
   @Size(max = ${ci.maxLength},message = "${ci.comment}长度不能超过${ci.maxLength}个字符")
   </#if>
   <#if ci.nullable==false>
   @NotEmpty(message = "${ci.comment}不能为空")
   </#if>
   private ${ci.javaType} ${ci.lowerAttrName};

 </#if>
</#list>

}
	