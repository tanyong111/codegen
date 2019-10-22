package com.tan.codegen.entity;

import lombok.Data;

/**
 * <p>
 * 列属性： https://blog.csdn.net/lkforce/article/details/79557482
 * </p>
 *
 * @package: com.xkcoding.codegen.entity
 * @description: 列属性： https://blog.csdn.net/lkforce/article/details/79557482
 * @author: yangkai.shen
 * @date: Created in 2019-03-22 09:46
 * @copyright: Copyright (c) 2019
 * @version: V1.0
 * @modified: yangkai.shen
 */
@Data
public class ColumnEntity {
    /**
     * 列名
     */
    private String column;
    /**
     *  jdbc类型
     */
    private String jdbcType;
    /**
     * 备注
     */
    private String comment;
    /**
     * 驼峰属性
     */
    private String caseAttrName;
    /**
     * 普通属性名，即javabean属性名称
     */
    private String lowerAttrName;
    /**
     * java类型
     */
    private String javaType;
    /**
     * 其他信息
     */
    private String extra;
    /**
     * 是否可以为空
     */
    private Boolean nullable;
    /**
     * 字符串形式字段最大长度
     */
    private String maxLength;
}
