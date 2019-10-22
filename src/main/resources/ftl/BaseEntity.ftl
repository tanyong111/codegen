package com.tan.codegen.entity;

import cn.hutool.core.lang.Snowflake;
import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
* 公共抽象实体类
* @version: V1.0
* @author: tan
* @date: 2019-09-25 17:14:05
*/
@Data
public class BaseEntity implements Serializable {

private static final long serialVersionUID = 1L;

public static Snowflake snowflake = IdUtil.getSnowflake(1, 1);
/**
* 记录标识
*/
@TableId
@TableField("id")
@ApiModelProperty(hidden = true)
// Long类型传递到前端引起精度丢失
@JsonSerialize(using = ToStringSerializer.class)
private Long id;

/**
* 创建人记录标识
*/
@TableField("create_id")
@ApiModelProperty(hidden = true)
private Long createId;

/**
* 创建时间
*/
@TableField("create_time")
@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
@ApiModelProperty(hidden = true)
private LocalDateTime createTime;

/**
* 更新人记录标识
*/
@TableField("modify_id")
@ApiModelProperty(hidden = true)
private Long modifyId;

/**
* 更新时间
*/
@TableField("modify_time")
@JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
@ApiModelProperty(hidden = true)
private LocalDateTime modifyTime;

/**
* 是否删除
*/
@TableField("delete_flag")
@ApiModelProperty(hidden = true)
private Boolean deleteFlag;

}
