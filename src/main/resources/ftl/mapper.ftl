<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN" "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="${packageName}.${dao}.${entityName}Mapper">
	<resultMap id="BaseResultMap" type="${packageName}.${entity}.${entityName}">
		<id column="id" jdbcType="BIGINT" property="id" />
	<#list columns as ci>
		<#if ci.column != "id">
		<result column="${ci.column}" jdbcType="${ci.jdbcType}" property="${ci.lowerAttrName}" />
		</#if>
	</#list>
	</resultMap>
	<sql id="Base_Column_List">
		${agile}
	</sql>
	
</mapper>