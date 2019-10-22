package com.tan.codegen.utils;

import cn.hutool.core.io.IoUtil;
import cn.hutool.core.util.StrUtil;
import cn.hutool.db.Entity;
import cn.hutool.setting.dialect.Props;
import com.google.common.collect.Lists;
import com.tan.codegen.constants.GenConstants;
import com.tan.codegen.entity.ColumnEntity;
import com.tan.codegen.entity.GenConfig;
import com.tan.codegen.entity.TableEntity;
import lombok.experimental.UtilityClass;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.text.WordUtils;

import java.io.File;
import java.io.IOException;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

/**
 * <p>
 * 代码生成器   工具类
 * </p>
 *
 * @package: com.tan.codegen.utils
 * @description: 代码生成器   工具类
 * @author: yangkai.shen
 * @date: Created in 2019-03-22 09:27
 * @copyright: Copyright (c) 2019
 * @version: V1.0
 * @modified: yangkai.shen
 */
@Slf4j
@UtilityClass
public class CodeGenUtil {

    private final String ENTITY_JAVA_VM = "Entity.java.vm";
    private final String MAPPER_JAVA_VM = "Mapper.java.vm";
    private final String SERVICE_JAVA_VM = "Service.java.vm";
    private final String SERVICE_IMPL_JAVA_VM = "ServiceImpl.java.vm";
    private final String CONTROLLER_JAVA_VM = "Controller.java.vm";
    private final String MAPPER_XML_VM = "Mapper.xml.vm";
    private final String API_JS_VM = "api.js.vm";

    private Map<String,String> getTemplates(TableEntity tableEntity) {
        // 包路径
        String packagePath = GenConstants.SIGNATURE + File.separator + "src" + File.separator + "main" + File.separator + "java" + File.separator;
        // 资源路径
        String resourcePath = GenConstants.SIGNATURE + File.separator + "src" + File.separator + "main" + File.separator + "resources" + File.separator;
        // vue文件路径
        String vuePath = GenConstants.SIGNATURE + File.separator + "vue" + File.separator;

        if (StrUtil.isNotBlank(tableEntity.getPackageName())) {
            packagePath += tableEntity.getPackageName().replace(".", File.separator) + File.separator + tableEntity.getModuleName() + File.separator;
        }

        if(StrUtil.isNotBlank(tableEntity.getModuleName())) {
            tableEntity.setPackageName(tableEntity.getPackageName()+"."+tableEntity.getModuleName());
        }

        Map<String,String> res=new HashMap<>();
        res.put("entity.ftl",packagePath+tableEntity.getEntity()+File.separator+tableEntity.getEntityName()+".java");
        res.put("dao.ftl",packagePath+tableEntity.getDao()+File.separator+tableEntity.getEntityName()+"Mapper.java");
        res.put("mapper.ftl",resourcePath+tableEntity.getMapper()+File.separator+tableEntity.getEntityName()+"Mapper.xml");
        res.put("service.ftl",packagePath+tableEntity.getService()+File.separator+tableEntity.getEntityName()+"Service.java");
        res.put("serviceImpl.ftl",packagePath+tableEntity.getService()+File.separator+tableEntity.getServiceImpl()+File.separator+tableEntity.getEntityName()+"ServiceImpl.java");
        res.put("controller.ftl",packagePath+tableEntity.getController()+File.separator+tableEntity.getEntityName()+"Controller.java");
        res.put("vue.ftl",vuePath+tableEntity.getEntityName()+".vue");
        res.put("vueEdit.ftl",vuePath+tableEntity.getEntityName()+"Edit.vue");
        return res;
    }

    /**
     * 生成代码
     */
    public void generatorCode(GenConfig genConfig, Entity table, List<Entity> columns, ZipOutputStream zip) {
        //配置信息
        Props props = getConfig();
        boolean hasBigDecimal = false;
        //表信息
        TableEntity tableEntity = new TableEntity();
        tableEntity.setTableName(table.getStr("tableName"));

        if (StrUtil.isNotBlank(genConfig.getComments())) {
            tableEntity.setComments(genConfig.getComments());
        } else {
            tableEntity.setComments(table.getStr("tableComment"));
        }

        String tablePrefix;
        if (StrUtil.isNotBlank(genConfig.getTablePrefix())) {
            tablePrefix = genConfig.getTablePrefix();
        } else {
            tablePrefix = props.getStr("tablePrefix");
        }

        if (StrUtil.isNotBlank(genConfig.getAuthor())) {
            tableEntity.setAuthor(genConfig.getAuthor());
        } else {
            tableEntity.setAuthor(props.getStr("author"));
        }

        if (StrUtil.isNotBlank(genConfig.getModuleName())) {
            tableEntity.setModuleName(genConfig.getModuleName());
        } else {
            tableEntity.setModuleName(props.getStr("moduleName"));
        }

        if (StrUtil.isNotBlank(genConfig.getPackageName())) {
            tableEntity.setPackageName(genConfig.getPackageName());
        } else {
            tableEntity.setPackageName(props.getStr("package"));
        }

        //表名转换成Java类名
        String className = tableToJava(tableEntity.getTableName(), tablePrefix);
        tableEntity.setEntityName(className);
        tableEntity.setLowerClassName(StrUtil.lowerFirst(className));

        //列信息
        List<ColumnEntity> columnList = Lists.newArrayList();
        for (Entity column : columns) {
            ColumnEntity columnEntity = new ColumnEntity();
            columnEntity.setColumn(column.getStr("columnName"));
            columnEntity.setJdbcType(column.getStr("dataType"));
            columnEntity.setComment(column.getStr("columnComment"));
            columnEntity.setExtra(column.getStr("extra"));
            columnEntity.setNullable(column.getBool("isNullable"));
            columnEntity.setMaxLength(column.getStr("characterMaximumLength"));

            //列名转换成Java属性名
            String attrName = columnToJava(columnEntity.getColumn());
            columnEntity.setCaseAttrName(attrName);
            columnEntity.setLowerAttrName(StrUtil.lowerFirst(attrName));

            //列的数据类型，转换成Java类型
            String attrType = props.getStr(columnEntity.getJdbcType(), "unknownType");
            columnEntity.setJavaType(attrType);
            if (!hasBigDecimal && "BigDecimal".equals(attrType)) {
                hasBigDecimal = true;
            }
            //是否主键
            if ("PRI".equalsIgnoreCase(column.getStr("columnKey")) && tableEntity.getPk() == null) {
                tableEntity.setPk(columnEntity);
            }

            columnList.add(columnEntity);
        }
        tableEntity.setColumns(columnList);

        List<ColumnEntity> columns1 = tableEntity.getColumns();
        String agile="";
        for (ColumnEntity columnEntity : columns1) {
            agile=agile+columnEntity.getColumn()+", ";
        }
        agile=agile.substring(0, agile.length()-2);
        tableEntity.setAgile(agile);

        //没主键，则第一个字段为主键
        if (tableEntity.getPk() == null) {
            tableEntity.setPk(tableEntity.getColumns().get(0));
        }

        //获取模板列表
        Map<String, String> map = getTemplates(tableEntity);
        for(String tem:map.keySet()) {
            try {
                //添加到zip
                zip.putNextEntry(new ZipEntry(Objects.requireNonNull(map.get(tem), tableEntity.getModuleName())));
                StringWriter stringWriter = FreemarkerUtil.createStringWriter(tableEntity, tem);
                IoUtil.write(zip, StandardCharsets.UTF_8, false, stringWriter.toString());
                IoUtil.close(stringWriter);
                zip.closeEntry();
            } catch (IOException e) {
                throw new RuntimeException("渲染模板失败，表名：" + tableEntity.getTableName(), e);
            }
        }
    }


    /**
     * 列名转换成Java属性名
     */
    private String columnToJava(String columnName) {
        return WordUtils.capitalizeFully(columnName, new char[]{'_'}).replace("_", "");
    }

    /**
     * 表名转换成Java类名
     */
    private String tableToJava(String tableName, String tablePrefix) {
        if (StrUtil.isNotBlank(tablePrefix)) {
            tableName = tableName.replaceFirst(tablePrefix, "");
        }
        return columnToJava(tableName);
    }

    /**
     * 获取配置信息
     */
    private Props getConfig() {
        Props props = new Props("generator.properties");
        props.autoLoad(true);
        return props;
    }

    /**
     * 获取文件名
     */
    private String getFileName(String template, String className, String packageName, String moduleName) {
        // 包路径
        String packagePath = GenConstants.SIGNATURE + File.separator + "src" + File.separator + "main" + File.separator + "java" + File.separator;
        // 资源路径
        String resourcePath = GenConstants.SIGNATURE + File.separator + "src" + File.separator + "main" + File.separator + "resources" + File.separator;
        // api路径
        String apiPath = GenConstants.SIGNATURE + File.separator + "api" + File.separator;

        if (StrUtil.isNotBlank(packageName)) {
            packagePath += packageName.replace(".", File.separator) + File.separator + moduleName + File.separator;
        }

        if (template.contains(ENTITY_JAVA_VM)) {
            return packagePath + "entity" + File.separator + className + ".java";
        }

        if (template.contains(MAPPER_JAVA_VM)) {
            return packagePath + "mapper" + File.separator + className + "Mapper.java";
        }

        if (template.contains(SERVICE_JAVA_VM)) {
            return packagePath + "service" + File.separator + className + "Service.java";
        }

        if (template.contains(SERVICE_IMPL_JAVA_VM)) {
            return packagePath + "service" + File.separator + "impl" + File.separator + className + "ServiceImpl.java";
        }

        if (template.contains(CONTROLLER_JAVA_VM)) {
            return packagePath + "controller" + File.separator + className + "Controller.java";
        }

        if (template.contains(MAPPER_XML_VM)) {
            return resourcePath + "mapper" + File.separator + className + "Mapper.xml";
        }

        if (template.contains(API_JS_VM)) {
            return apiPath + className.toLowerCase() + ".js";
        }

        return null;
    }
}
