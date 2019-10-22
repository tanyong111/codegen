package ${packageName}.${controller};

import ${packageName}.${entity}.${entityName};
import ${packageName}.${service}.${entityName}Service;
import ${packageName}.common.R;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import lombok.extern.slf4j.Slf4j;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import javax.validation.Valid;
import org.springframework.validation.annotation.Validated;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import ${packageName}.vo.PageVo;
import ${packageName}.vo.SearchVo;
import org.apache.commons.lang3.StringUtils;
<#if isSwagger=="true" >
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
</#if>
/**   
 * ${comments}API接口层
 * @version: ${version}
 * @author: ${author}
 * @date: ${createTime}
 */
 <#if isSwagger=="true" >
@Api(value = "${comments}API接口层",tags="${comments}接口类" )
</#if>
@Validated
@RestController
@Slf4j
@RequestMapping("/${lowerClassName}")
public class ${entityName}Controller extends BaseController{

    @Autowired
    private ${entityName}Service ${lowerClassName}Service;

    <#if isSwagger=="true" >
    @ApiOperation(value = "添加",notes = "添加")
    </#if>
    @PostMapping(value = "/add")
    public R add(@Valid ${entityName} ${lowerClassName}) {
        ${lowerClassName}.builder();
        ${lowerClassName}Service.save(${lowerClassName});
        return R.ok();
    }

    <#if isSwagger=="true" >
    @ApiOperation(value = "根据Id查询",notes = "根据Id查询")
    </#if>
    @GetMapping(value = "/getById/{id}")
    public R getById(@PathVariable Long id) {
        ${entityName} byId = ${lowerClassName}Service.getById(id);
        return R.ok(byId);
    }

    <#if isSwagger=="true" >
    @ApiOperation(value = "修改",notes = "修改")
    </#if>
    @PostMapping(value = "/update")
    public R update(@Valid ${entityName} ${lowerClassName}) {
        ${lowerClassName}.builderUpdate();
        ${lowerClassName}Service.updateById(${lowerClassName});
        return R.ok();
    }

    <#if isSwagger=="true" >
    @ApiOperation(value = "删除",notes = "删除")
    </#if>
    @PostMapping(value = "/delete/{id}")
    public R delete(@PathVariable Long id) {
        ${entityName} ${lowerClassName} = new ${entityName}();
        ${lowerClassName}.setId(id);
        ${lowerClassName}.setDeleteFlag(true);
        ${lowerClassName}Service.updateById(${lowerClassName});
        return R.ok();
    }

    <#if isSwagger=="true" >
    @ApiOperation(value = "根据ids数组删除",notes = "根据ids数组删除")
    </#if>
    @PostMapping(value = "/deleteByIds")
    public R deleteByIds(@RequestParam(value = "ids[]") Long[] ids) {
        ${lowerClassName}Service.deleteByIds(ids);
        return R.ok();
    }

    <#if isSwagger=="true" >
    @ApiOperation(value = "搜索",notes = "搜索")
    </#if>
    @GetMapping(value = "/search")
    public R search(PageVo pageVo,${entityName} ${lowerClassName}, SearchVo searchVo) {
        PageHelper.startPage(pageVo.getPage(), pageVo.getSize());
        QueryWrapper<${entityName}> ${lowerClassName}QueryWrapper = new QueryWrapper<>();
        ${lowerClassName}QueryWrapper.eq("delete_flag",false);
        ${lowerClassName}QueryWrapper.orderByDesc("modify_time");
        <#list columns as ci>
            <#if ci.lowerAttrName == "name">
        if(StringUtils.isNotEmpty(${lowerClassName}.getName())) {
            ${lowerClassName}QueryWrapper.like("Name",${lowerClassName}.getName());
        }
            </#if>
        </#list>
        searchVo.build(${lowerClassName}QueryWrapper);
        ${lowerClassName}QueryWrapper.select(<#list columns as ci><#if ci.lowerAttrName == "createId" ||ci.lowerAttrName == "createBy" ||ci.lowerAttrName == "createTime" ||ci.lowerAttrName == "modifyId" ||ci.lowerAttrName == "modifyBy"||ci.lowerAttrName == "modifyTime" ||ci.lowerAttrName == "deleteFlag"><#else>"${ci.column}",</#if></#list>"modify_time");
        PageInfo<${entityName}> result = new PageInfo<>(${lowerClassName}Service.list(${lowerClassName}QueryWrapper));
        return R.ok(result);
    }

<#--    /**-->
<#--    * @explain 查询${entityName}-->
<#--    * @param   id-->
<#--    * @time    2019年4月9日-->
<#--    */-->
<#--    @GetMapping("/{id}")-->
<#--    <#if isSwagger=="true" >-->
<#--    @ApiOperation(value = "获取${entityName}", notes = "获取${entityName}", httpMethod = "GET")-->
<#--    @ApiImplicitParam(paramType="path", name = "id", value = "对象id", required = true, dataType = "Long")-->
<#--    </#if>-->
<#--    public ${entityName} get${entityName}ById(@PathVariable("id")Long id){-->
<#--        ${entityName} ${lowerClassName}=${lowerClassName}Service.getById(id);-->
<#--        if (null != ${lowerClassName}) {-->
<#--            return ${lowerClassName};-->
<#--        } else {-->
<#--            throw new RuntimeException("${entityName}不存在");-->
<#--        }-->
<#--    }-->
}