package com.tan.codegen.entity;

import lombok.Data;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

/**
 * <p>
 * 表属性： https://blog.csdn.net/lkforce/article/details/79557482
 * </p>
 *
 * @package: com.xkcoding.codegen.entity
 * @description: 表属性： https://blog.csdn.net/lkforce/article/details/79557482
 * @author: yangkai.shen
 * @date: Created in 2019-03-22 09:47
 * @copyright: Copyright (c) 2019
 * @version: V1.0
 * @modified: yangkai.shen
 */
@Data
public class TableEntity {
    /**
     * 名称
     */
    private String tableName;
    /**
     * 备注
     */
    private String comments;
    /**
     * 作者
     */
    private String author;
    /**
     * 版本
     */
    private String version = "1.0";
    /**
     * 创建时间
     */
    private String createTime = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
    /**
     * 模块名
     */
    private String moduleName;
    /**
     * 主键
     */
    private ColumnEntity pk;
    /**
     * 列名
     */
    private List<ColumnEntity> columns;
    /**
     * 驼峰类型
     */
    private String entityName;
    /**
     * 普通类型
     */
    private String lowerClassName;
    /**
     * 是否有BigDecimal
     */
    private boolean hasBigDecimal;
    /**
     * 基础包路径
     */
    private String packageName;
    /**
     * 实体类包名
     */
    private String entity="entity";
    /**
     * dao层包名
     */
    private String dao="dao";
    /**
     * mapper xml文件路径
     */
    private String mapper="mapper";
    /**
     * service类包名
     */
    private String service="service";
    /**
     * serviceImpl类包名
     */
    private String serviceImpl="impl";
    /**
     * controller类包名
     */
    private String controller="controller";
    /**
     * 是否开启Swagger
     */
    private String isSwagger = "true";
    /**
     * 逗号拼接的列名字符串
     */
    private String agile;
}
